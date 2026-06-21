/obj/structure/light_construct
	name = "灯管支架框"
	desc = "一个正在安装的灯具。"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = TRUE
	layer = WALL_OBJ_LAYER
	max_integrity = 200
	armor_type = /datum/armor/structure_light_construct

	///Light construction stage (LIGHT_CONSTRUCT_EMPTY, LIGHT_CONSTRUCT_WIRED, LIGHT_CONSTRUCT_CLOSED)
	var/stage = LIGHT_CONSTRUCT_EMPTY
	///Type of fixture for icon state
	var/fixture_type = "tube"
	///Amount of sheets gained on deconstruction
	var/sheets_refunded = 2
	///Reference for light object
	var/obj/machinery/light/new_light = null
	///Reference for the internal cell
	var/obj/item/stock_parts/power_store/cell
	///Can we support a cell?
	var/cell_connectors = TRUE

/datum/armor/structure_light_construct
	melee = 50
	bullet = 10
	laser = 10
	fire = 80
	acid = 50

/obj/structure/light_construct/Initialize(mapload)
	. = ..()
	if(mapload && !find_and_mount_on_atom(mark_for_late_init = TRUE))
		return INITIALIZE_HINT_LATELOAD

/obj/structure/light_construct/LateInitialize()
	find_and_mount_on_atom(late_init = TRUE)

/obj/structure/light_construct/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/structure/light_construct/get_turfs_to_mount_on()
	return list(get_step(src, dir))

/obj/structure/light_construct/get_cell()
	return cell

/obj/structure/light_construct/examine(mob/user)
	. = ..()
	switch(stage)
		if(LIGHT_CONSTRUCT_EMPTY)
			. += span_notice("这是一个没有电线的空框架。")
		if(LIGHT_CONSTRUCT_WIRED)
			. += span_notice("它已接好电线，但螺栓没有拧紧。")
		if(LIGHT_CONSTRUCT_CLOSED)
			. += span_notice("外壳已闭合。")
	if(cell_connectors)
		if(cell)
			. += span_notice("你看到[cell]在外壳里面。")
		else
			. += span_notice("外壳内没有用于备用电源的电池。")
	else
		. += span_danger("这个外壳不支持使用电池作为备用电源。")

/obj/structure/light_construct/attack_hand(mob/user, list/modifiers)
	if(!cell)
		return
	user.visible_message(span_notice("[user]从[src]中取出了[cell]！"), span_notice("你取出了[cell]。"))
	user.put_in_hands(cell)
	cell = null
	add_fingerprint(user)

/obj/structure/light_construct/attack_tk(mob/user)
	if(!cell)
		return
	to_chat(user, span_notice("你用意念移物取出了[cell]。"))
	var/obj/item/stock_parts/power_store/cell_reference = cell
	cell = null
	cell_reference.forceMove(drop_location())
	return cell_reference.attack_tk(user)

/obj/structure/light_construct/attackby(obj/item/tool, mob/user, list/modifiers, list/attack_modifiers)
	add_fingerprint(user)
	if(istype(tool, /obj/item/stock_parts/power_store/cell))
		if(!cell_connectors)
			to_chat(user, span_warning("这个[name]不支持安装电池！"))
			return
		if(HAS_TRAIT(tool, TRAIT_NODROP))
			to_chat(user, span_warning("[tool]粘在你手上了！"))
			return
		if(cell)
			to_chat(user, span_warning("已经安装了一块电池！"))
			return
		if(user.temporarilyRemoveItemFromInventory(tool))
			user.visible_message(span_notice("[user]将[tool]连接到[src]。"), \
			span_notice("你将[tool]添加到[src]。"))
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			tool.forceMove(src)
			cell = tool
			add_fingerprint(user)
			return
	if(istype(tool, /obj/item/light))
		to_chat(user, span_warning("这个[name]还没有完成设置！"))
		return

	switch(stage)
		if(LIGHT_CONSTRUCT_EMPTY)
			if(tool.tool_behaviour == TOOL_WRENCH)
				if(cell)
					to_chat(user, span_warning("你必须先取出电池！"))
					return
				to_chat(user, span_notice("你开始解构[src]..."))
				if (tool.use_tool(src, user, 30, volume=50))
					user.visible_message(span_notice("[user.name]解构了[src]。"), \
						span_notice("你拆解了[src]。"), span_hear("你听到棘轮声。"))
					playsound(src, 'sound/items/deconstruct.ogg', 75, TRUE)
					deconstruct()
				return

			if(istype(tool, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = tool
				if(coil.use(1))
					icon_state = "[fixture_type]-construct-stage2"
					stage = LIGHT_CONSTRUCT_WIRED
					user.visible_message(span_notice("[user.name]给[src]接上了电线。"), \
						span_notice("你给[src]接上了电线。"))
				else
					to_chat(user, span_warning("你需要一段电缆来给[src]接线！"))
				return
		if(LIGHT_CONSTRUCT_WIRED)
			if(tool.tool_behaviour == TOOL_WRENCH)
				to_chat(usr, span_warning("你得先把电线拆掉！"))
				return

			if(tool.tool_behaviour == TOOL_WIRECUTTER)
				stage = LIGHT_CONSTRUCT_EMPTY
				icon_state = "[fixture_type]-construct-stage1"
				new /obj/item/stack/cable_coil(drop_location(), 1, "red")
				user.visible_message(span_notice("[user.name]从[src]上拆除了电线。"), \
					span_notice("你从[src]上拆除了电线。"), span_hear("你听到咔哒声。"))
				tool.play_tool_sound(src, 100)
				return

			if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message(span_notice("[user.name]合上了[src]的外壳。"), \
					span_notice("你合上了[src]的外壳。"), span_hear("你听到拧螺丝的声音。"))
				tool.play_tool_sound(src, 75)
				switch(fixture_type)
					if("tube")
						new_light = new /obj/machinery/light/empty(loc)
					if("bulb")
						new_light = new /obj/machinery/light/small/empty(loc)
					if("floor")
						new_light = new /obj/machinery/light/floor/empty(loc)
				new_light.setDir(dir)
				new_light.find_and_mount_on_atom()
				transfer_fingerprints_to(new_light)
				if(!QDELETED(cell))
					new_light.cell = cell
					cell.forceMove(new_light)
					cell = null
				qdel(src)
				return
	return ..()

/obj/structure/light_construct/blob_act(obj/structure/blob/attacking_blob)
	if(attacking_blob && attacking_blob.loc == loc)
		deconstruct(FALSE)

/obj/structure/light_construct/atom_deconstruct(disassembled)
	new /obj/item/stack/sheet/iron(loc, sheets_refunded)
	if(stage == LIGHT_CONSTRUCT_WIRED)
		new /obj/item/stack/cable_coil(drop_location(), 1, "red")

/obj/structure/light_construct/small
	name = "小型灯管支架框"
	icon_state = "bulb-construct-stage1"
	fixture_type = "bulb"
	sheets_refunded = 1

/obj/structure/light_construct/floor
	name = "地板灯具框架"
	icon_state = "floor-construct-stage1"
	fixture_type = "floor"
	sheets_refunded = 1

/obj/structure/light_construct/floor/get_turfs_to_mount_on()
	return list(get_turf(src))

/obj/structure/light_construct/floor/is_mountable_turf(turf/target)
	return !isgroundlessturf(target)
