// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
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
			. += span_notice(LANG("obj.b73d03f20c5281b9", null))
		if(LIGHT_CONSTRUCT_WIRED)
			. += span_notice(LANG("obj.f04ddf2d686766bc", null))
		if(LIGHT_CONSTRUCT_CLOSED)
			. += span_notice(LANG("obj.f6ba57373add19fc", null))
	if(cell_connectors)
		if(cell)
			. += span_notice(LANG("obj.d65bfb246ff7c506", list(cell)))
		else
			. += span_notice(LANG("obj.3f83d4f3c2271b25", null))
	else
		. += span_danger(LANG("obj.1bdbd305250d9821", null))

/obj/structure/light_construct/attack_hand(mob/user, list/modifiers)
	if(!cell)
		return
	user.visible_message(span_notice(LANG("obj.6eec863436b99805", list(user, cell, src))), span_notice(LANG("obj.1973523e4f545786", list(cell))))
	user.put_in_hands(cell)
	cell = null
	add_fingerprint(user)

/obj/structure/light_construct/attack_tk(mob/user)
	if(!cell)
		return
	to_chat(user, span_notice(LANG("obj.326e922415f23244", list(cell))))
	var/obj/item/stock_parts/power_store/cell_reference = cell
	cell = null
	cell_reference.forceMove(drop_location())
	return cell_reference.attack_tk(user)

/obj/structure/light_construct/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	add_fingerprint(user)
	if(istype(tool, /obj/item/stock_parts/power_store/cell))
		if(!cell_connectors)
			to_chat(user, span_warning(LANG("obj.3e6b5586b39eb266", list(name))))
			return ITEM_INTERACT_BLOCKING

		if(!user.temporarilyRemoveItemFromInventory(tool))
			to_chat(user, span_warning(LANG("obj.1dbf8014c030d016", list(tool))))
			return ITEM_INTERACT_BLOCKING

		if(cell)
			to_chat(user, span_warning(LANG("obj.18df60619fe8f5e9", null)))
			return ITEM_INTERACT_BLOCKING

		user.visible_message(span_notice(LANG("obj.859ffee5df42a245", list(user, tool, src))), \
		span_notice(LANG("obj.0c27fe262b2ac3b6", list(tool, src))))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		tool.forceMove(src)
		cell = tool
		add_fingerprint(user)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/light))
		to_chat(user, span_warning(LANG("obj.8f9c8ea66971dfa5", list(name))))
		return ITEM_INTERACT_BLOCKING

	if(stage == LIGHT_CONSTRUCT_EMPTY && istype(tool, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = tool
		if(!coil.use(1))
			to_chat(user, span_warning(LANG("obj.41542255dc5f9152", list(src))))
			return ITEM_INTERACT_BLOCKING
		icon_state = "[fixture_type]-construct-stage2"
		stage = LIGHT_CONSTRUCT_WIRED
		user.visible_message(span_notice(LANG("obj.1c9350ed5e24da8d", list(user.name, src))), \
							span_notice(LANG("obj.b1f7e13ceef66539", list(src))))
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/structure/light_construct/wrench_act(mob/living/user, obj/item/tool)
	switch(stage)
		if(LIGHT_CONSTRUCT_EMPTY)
			if(cell)
				to_chat(user, span_warning(LANG("obj.3218f2b785887c8c", null)))
				return ITEM_INTERACT_BLOCKING
			to_chat(user, span_notice(LANG("obj.2f7a5f8d2b2b54b0", list(src))))
			if (!tool.use_tool(src, user, 30, volume=50))
				return ITEM_INTERACT_BLOCKING
			user.visible_message(span_notice(LANG("obj.6d94607af53d4e95", list(user.name, src))), \
								span_notice(LANG("obj.a33d1bb641d47707", list(src))), \
								span_hear(LANG("obj.aa8a193f8da7c41c", null)))
			playsound(src, 'sound/items/deconstruct.ogg', 75, TRUE)
			deconstruct()
			return ITEM_INTERACT_SUCCESS
		if(LIGHT_CONSTRUCT_WIRED)
			to_chat(usr, span_warning(LANG("obj.de6ac88cbece36aa", null)))
			return ITEM_INTERACT_BLOCKING
	return NONE

/obj/structure/light_construct/screwdriver_act(mob/living/user, obj/item/tool)
	if(stage != LIGHT_CONSTRUCT_WIRED)
		return NONE
	user.visible_message(span_notice(LANG("obj.ab5a0f0c0a1d9928", list(user.name, src))), \
						span_notice(LANG("obj.1aba22edc3992fad", list(src))), \
						span_hear(LANG("obj.8616c74b67f81440", null)))
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
	return ITEM_INTERACT_SUCCESS

/obj/structure/light_construct/wirecutter_act(mob/living/user, obj/item/tool)
	if(stage != LIGHT_CONSTRUCT_WIRED)
		return NONE
	stage = LIGHT_CONSTRUCT_EMPTY
	icon_state = "[fixture_type]-construct-stage1"
	new /obj/item/stack/cable_coil(drop_location(), 1, "red")
	user.visible_message(span_notice(LANG("obj.e3ab888fb6330d84", list(user.name, src))), \
						span_notice(LANG("obj.8671a81f671efacf", list(src))), \
						span_hear(LANG("obj.dcc6c1b00318bad4", null)))
	tool.play_tool_sound(src, 100)
	return ITEM_INTERACT_SUCCESS

/obj/structure/light_construct/blob_act(obj/structure/blob/attacking_blob)
	if(attacking_blob && attacking_blob.loc == loc)
		deconstruct(FALSE)

/obj/structure/light_construct/atom_deconstruct(disassembled)
	new /obj/item/stack/sheet/iron(loc, sheets_refunded)
	if(stage == LIGHT_CONSTRUCT_WIRED)
		new /obj/item/stack/cable_coil(drop_location(), 1, "red")

/obj/structure/light_construct/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-stage1"
	fixture_type = "bulb"
	sheets_refunded = 1

/obj/structure/light_construct/floor
	name = "floor light fixture frame"
	icon_state = "floor-construct-stage1"
	fixture_type = "floor"
	sheets_refunded = 1

/obj/structure/light_construct/floor/get_turfs_to_mount_on()
	return list(get_turf(src))

/obj/structure/light_construct/floor/is_mountable_turf(turf/target)
	return !isgroundlessturf(target)
