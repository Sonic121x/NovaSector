// Snow, wood, sandbags, metal, plasteel

/obj/structure/deployable_barricade
	icon = 'modular_nova/modules/barricades/icons/barricade.dmi'
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	flags_1 = ON_BORDER_1
	obj_flags = CAN_BE_HIT | BLOCKS_CONSTRUCTION_DIR | IGNORE_DENSITY
	max_integrity = 100
	pass_flags_self = PASSSTRUCTURE | LETPASSTHROW
	///The type of stack the barricade dropped when disassembled if any.
	var/stack_type
	///The amount of stack dropped when disassembled at full health
	var/stack_amount = 5
	///to specify a non-zero amount of stack to drop when destroyed
	var/destroyed_stack_amount = 0
	var/barricade_type = "barricade" //"metal", "plasteel", etc.
	///Whether this barricade has damaged states
	var/can_change_dmg_state = TRUE
	///Whether we can open/close this barrricade and thus go over it
	var/closed = FALSE
	///Can this barricade type be wired
	var/can_wire = FALSE
	///is this barriade wired?
	var/is_wired = FALSE

/obj/structure/deployable_barricade/Initialize(mapload)
	. = ..()
	update_icon()
	var/static/list/connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_try_exit)
	)
	AddElement(/datum/element/connect_loc, connections)
	AddElement(/datum/element/climbable)
	RegisterSignal(src, COMSIG_ATOM_INTEGRITY_CHANGED, PROC_REF(run_integrity))

/obj/structure/deployable_barricade/proc/run_integrity()
	SIGNAL_HANDLER
	update_appearance()

/obj/structure/deployable_barricade/Destroy()
	UnregisterSignal(src, COMSIG_ATOM_INTEGRITY_CHANGED)
	return ..()

/obj/structure/deployable_barricade/examine(mob/user)
	. = ..()
	if(!is_wired && can_wire)
		. += span_info("可以用一些<b>电缆</b>来添加铁丝网。")
	if(is_wired)
		. += span_info("它的顶部装有铁丝网。")

/obj/structure/deployable_barricade/proc/on_try_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return

	if(!(direction & dir))
		return

	if (!density)
		return

	if (leaving.throwing)
		return

	if (leaving.movement_type & (PHASING | FLYING | FLOATING))
		return

	if (leaving.move_force >= MOVE_FORCE_EXTREMELY_STRONG)
		return

	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/deployable_barricade/CanPass(atom/movable/mover, border_dir)
	. = ..()

	if(istype(mover, /obj/projectile))
		if(!anchored)
			return TRUE
		if(closed)
			return TRUE
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
		if(prob(25))
			return TRUE
		return FALSE

	if((border_dir & dir) && !closed)
		return . || mover.throwing || mover.movement_type & (FLYING | FLOATING)
	return TRUE

/obj/structure/deployable_barricade/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/stack/cable_coil) && can_wire)
		var/obj/item/stack/stack_item = attacking_item
		if(stack_item.use(5))
			wire()
		else
			return
	else
		..()
		update_icon()

/obj/structure/deployable_barricade/attack_animal(mob/user)
	return attack_alien(user)

/obj/structure/deployable_barricade/proc/wire()
	can_wire = FALSE
	is_wired = TRUE
	modify_max_integrity(max_integrity + 50)
	update_icon()

/obj/structure/deployable_barricade/wirecutter_act(mob/living/user, obj/item/I)
	if(!is_wired)
		return FALSE

	user.visible_message(span_notice("[user] 开始移除 [src] 上的铁丝网。"),
	span_notice("你开始移除 [src] 上的铁丝网。"))

	if(!do_after(user, 2 SECONDS, src))
		return TRUE

	playsound(src, 'sound/items/tools/wirecutter.ogg', 25, TRUE)
	user.visible_message(span_notice("[user] 移除了 [src] 上的铁丝网。"),
	span_notice("你移除了 [src] 上的铁丝网。"))
	modify_max_integrity(max_integrity - 50)
	can_wire = TRUE
	is_wired = FALSE
	update_icon()


/obj/structure/deployable_barricade/atom_deconstruct(disassembled = TRUE)
	if(stack_type)
		var/stack_amt
		if(!disassembled && destroyed_stack_amount)
			stack_amt = destroyed_stack_amount
		else
			stack_amt = round(stack_amount * (get_integrity()/max_integrity)) //Get an amount of sheets back equivalent to remaining health. Obviously, fully destroyed means 0

		if(stack_amt)
			new stack_type (loc, stack_amt)
	return ..()

/obj/structure/deployable_barricade/ex_act(severity)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			visible_message(span_danger("[src] 爆炸了！"))
			deconstruct(FALSE)
			return
		if(EXPLODE_HEAVY)
			take_damage(rand(33, 66))
		if(EXPLODE_LIGHT)
			take_damage(rand(10, 33))
	update_icon()

/obj/structure/deployable_barricade/setDir(newdir)
	. = ..()
	update_icon()

/obj/structure/deployable_barricade/update_icon()
	. = ..()
	var/damage_state
	var/percentage = (get_integrity() / max_integrity) * 100
	switch(percentage)
		if(-INFINITY to 25)
			damage_state = 3
		if(25 to 50)
			damage_state = 2
		if(50 to 75)
			damage_state = 1
		if(75 to INFINITY)
			damage_state = 0
	if(!closed)
		if(can_change_dmg_state)
			icon_state = "[barricade_type]_[damage_state]"
		else
			icon_state = "[barricade_type]"
		switch(dir)
			if(SOUTH)
				layer = ABOVE_MOB_LAYER
			if(NORTH)
				layer = initial(layer) - 0.01
			else
				layer = initial(layer)
		if(!anchored)
			layer = initial(layer)
	else
		if(can_change_dmg_state)
			icon_state = "[barricade_type]_closed_[damage_state]"
		else
			icon_state = "[barricade_type]_closed"
		layer = OBJ_LAYER

/obj/structure/deployable_barricade/update_overlays()
	. = ..()
	if(is_wired)
		if(!closed)
			. += image('modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "[barricade_type]_wire")
		else
			. += image('modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "[barricade_type]_closed_wire")

/obj/structure/deployable_barricade/verb/rotate()
	set name = "Rotate barricade counterclockwise <"
	set category = "Object"
	set src in oview(1)

	if(anchored)
		to_chat(usr, span_warning("它被固定在地板上，你无法转动它！"))
		return FALSE

	setDir(turn(dir, 90))

/obj/structure/deployable_barricade/verb/revrotate()
	set name = "Rotate barricade clockwise >"
	set category = "Object"
	set src in oview(1)

	if(anchored)
		to_chat(usr, span_warning("它被固定在地板上，你无法转动它！"))
		return FALSE

	setDir(turn(dir, 270))


/obj/structure/deployable_barricade/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(anchored)
		to_chat(usr, span_warning("它被固定在地板上，你无法转动它！"))
		return FALSE

	setDir(turn(dir, 270))


/*----------------------*/
// SNOW
/*----------------------*/

/obj/structure/deployable_barricade/snow
	name = "雪堆路障"
	desc = "一个雪堆，被手掌仔细夯实至相对坚固的状态。你脑海中的建筑师认为这总比什么都没有强。原则上，你同意他的看法。"
	icon_state = "snow_0"
	barricade_type = "snow"
	max_integrity = 75
	stack_type = /obj/item/stack/sheet/mineral/snow
	stack_amount = 2
	destroyed_stack_amount = 0
	can_wire = FALSE
	custom_materials = list(/datum/material/snow = SHEET_MATERIAL_AMOUNT * 2)

/*----------------------*/
// GUARD RAIL
/*----------------------*/

/obj/structure/deployable_barricade/guardrail
	name = "围栏"
	desc = "一个由金属立柱制成的小型路障，旨在阻止你前往不该去的地方。"
	icon_state = "railing_0"
	max_integrity = 150
	armor_type = /datum/armor/deployable_barricade_guardrail
	stack_type = /obj/item/stack/rods
	destroyed_stack_amount = 2
	barricade_type = "railing"
	pass_flags_self = PASSSTRUCTURE
	can_wire = FALSE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)

/datum/armor/deployable_barricade_guardrail
	melee = 35
	bullet = 50
	laser = 50
	energy = 100
	bomb = 10

/obj/structure/deployable_barricade/guardrail/update_icon()
	. = ..()
	if(dir == NORTH)
		pixel_y = 11

/*----------------------*/
// WOOD
/*----------------------*/

/obj/structure/deployable_barricade/wooden
	name = "木质路障"
	desc = "用木板敲出来的墙看起来可能并不十分坚固，但它仍然能提供一些保护。"
	icon = 'modular_nova/modules/barricades/icons/barricade.dmi'
	icon_state = "wooden"
	max_integrity = 100
	layer = OBJ_LAYER
	stack_type = /obj/item/stack/sheet/mineral/wood
	stack_amount = 2
	destroyed_stack_amount = 1
	can_change_dmg_state = FALSE
	barricade_type = "wooden"
	can_wire = FALSE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 5)

/obj/structure/deployable_barricade/wooden/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(istype(attacking_item, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/wood = attacking_item
		if(get_integrity() >= max_integrity)
			return

		if(wood.get_amount() < 1)
			to_chat(user, span_warning("你至少需要一块木板来修复 [src]！"))
			return

		visible_message(span_notice("[user] 开始修复 [src]。"))

		if(!do_after(user,20, src) || get_integrity() >= max_integrity)
			return

		if(!wood.use(1))
			return

		repair_damage(max_integrity)
		visible_message(span_notice("[user] 修复了 [src]。"))


/*----------------------*/
// METAL
/*----------------------*/

#define BARRICADE_METAL_LOOSE 0
#define BARRICADE_METAL_ANCHORED 1
#define BARRICADE_METAL_FIRM 2

#define BARRICADE_TYPE_BOMB "explosion-proof armor"
#define BARRICADE_TYPE_MELEE "ballistic armor"
#define BARRICADE_TYPE_ACID "anti-acid armor"

#define BARRICADE_UPGRADE_REQUIRED_SHEETS 2

/obj/structure/deployable_barricade/metal
	name = "金属路障"
	desc = "一种由金属板制成的耐用且易于安装的路障，常用于快速加固。修复它需要焊枪。"
	icon_state = "metal_0"
	max_integrity = 200
	armor_type = /datum/armor/deployable_barricade_metal
	stack_type = /obj/item/stack/sheet/iron
	stack_amount = 2
	destroyed_stack_amount = 1
	barricade_type = "metal"
	can_wire = TRUE
	/// The type of quickdeploy we drop when folded up.
	var/portable_type = /obj/item/quickdeploy/barricade
	/// Build state of the barricade
	var/build_state = BARRICADE_METAL_FIRM
	/// The type of upgrade and corresponding overlay we have attached
	var/barricade_upgrade_type
	/// How many of our stack_type do we need to repair this?
	var/repair_amount = 2
	/// Can we be upgraded?
	var/can_upgrade = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

/datum/armor/deployable_barricade_metal
	bio = 80
	fire = 80
	acid = 40
	bomb = 20

/obj/structure/deployable_barricade/metal/click_alt(mob/user)
	if(portable_type)
		if(anchored)
			to_chat(user, span_warning("[src] 固定在地面上时无法折叠收起！"))
			return CLICK_ACTION_BLOCKING
		if(barricade_upgrade_type)
			to_chat(user, span_warning("[src] 在装有升级部件时无法折叠收起，请先移除它们！"))
			return CLICK_ACTION_BLOCKING
		if(get_integrity() < max_integrity)
			to_chat(user, span_warning("[src] 受损时无法折叠收起！"))
			return CLICK_ACTION_BLOCKING
		user.visible_message(span_notice("[user] 开始折叠收起 [src]！"), span_notice("你开始折叠收起 [src]！"))
		if(do_after(user, 5 SECONDS, src))
			if(QDELETED(src)) //Copied encase we change states.
				return
			if(anchored)
				to_chat(user, span_warning("[src] 固定在地面上时无法折叠收起！"))
				return CLICK_ACTION_BLOCKING
			if(barricade_upgrade_type)
				to_chat(user, span_warning("[src] 在装有升级部件时无法折叠收起，请先移除它们！"))
				return CLICK_ACTION_BLOCKING
			if(get_integrity() < max_integrity)
				to_chat(user, span_warning("[src] 受损时无法折叠收起！"))
				return CLICK_ACTION_BLOCKING
			user.visible_message(span_notice("[user] 折叠收起了 [src]！"), span_notice("你利落地将[src]折叠了起来！"))
			playsound(src, 'sound/items/tools/ratchet.ogg', 25, TRUE)
			fold_up()
			return CLICK_ACTION_SUCCESS
	return ..()

/obj/structure/deployable_barricade/metal/proc/fold_up()
	new portable_type(get_turf(src))
	qdel(src)

/obj/structure/deployable_barricade/metal/update_overlays()
	. = ..()
	if(!barricade_upgrade_type)
		return
	var/damage_state
	var/percentage = (get_integrity() / max_integrity) * 100
	switch(percentage)
		if(-INFINITY to 25)
			damage_state = 3
		if(25 to 50)
			damage_state = 2
		if(50 to 75)
			damage_state = 1
		if(75 to INFINITY)
			damage_state = 0
	switch(barricade_upgrade_type)
		if(BARRICADE_TYPE_BOMB)
			. += image('modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "+explosive_upgrade_[damage_state]")
		if(BARRICADE_TYPE_MELEE)
			. += image('modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "+brute_upgrade_[damage_state]")
		if(BARRICADE_TYPE_ACID)
			. += image('modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "+burn_upgrade_[damage_state]")

/obj/structure/deployable_barricade/metal/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/stack/sheet/iron))
		var/obj/item/stack/sheet/iron/metal_sheets = attacking_item
		if(can_upgrade && get_integrity() > max_integrity * 0.3)
			return attempt_barricade_upgrade(attacking_item, user, modifiers)

		if(metal_sheets.get_amount() < repair_amount)
			to_chat(user, span_warning("你至少需要两块金属板才能修复[src]！"))
			return FALSE

		visible_message(span_notice("[user]开始修复[src]。"))

		if(!do_after(user, 2 SECONDS, src) || get_integrity() >= max_integrity)
			return FALSE

		if(!metal_sheets.use(repair_amount))
			return FALSE

		repair_damage(max_integrity * 0.3)
		visible_message(span_notice("[user]修复了[src]。"))
	return ..()

/obj/structure/deployable_barricade/metal/proc/attempt_barricade_upgrade(obj/item/stack/sheet/iron/metal_sheets, mob/user, modifiers)
	if(barricade_upgrade_type)
		to_chat(user, span_warning("[src]已经升级过了。"))
		return FALSE
	if(get_integrity() < max_integrity)
		to_chat(user, span_warning("你必须先修复[src]才能升级它！"))
		return FALSE

	if(metal_sheets.get_amount() < BARRICADE_UPGRADE_REQUIRED_SHEETS)
		to_chat(user, span_warning("你至少需要<b>[BARRICADE_UPGRADE_REQUIRED_SHEETS]</b>块金属板才能升级[src]！"))
		return FALSE

	var/static/list/cade_types = list(BARRICADE_TYPE_BOMB = image(icon = 'modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "explosive_obj"), BARRICADE_TYPE_MELEE = image(icon = 'modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "brute_obj"), BARRICADE_TYPE_ACID = image(icon = 'modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "burn_obj"))
	var/choice = show_radial_menu(user, src, cade_types, require_near = TRUE, tooltips = TRUE)

	user.visible_message(span_notice("[user]开始将[choice]安装到[src]上。"),
		span_notice("你开始将[choice]安装到[src]上。"))
	if(!do_after(user, 2 SECONDS, src))
		return FALSE

	if(!metal_sheets.use(BARRICADE_UPGRADE_REQUIRED_SHEETS))
		return FALSE

	switch(choice)
		if(BARRICADE_TYPE_BOMB)
			set_armor_rating(BOMB, min(get_armor_rating(BOMB) + 50, 100))
		if(BARRICADE_TYPE_MELEE)
			set_armor(get_armor().generate_new_with_modifiers(list(MELEE = 30, BULLET = 30)))
		if(BARRICADE_TYPE_ACID)
			set_armor(get_armor().generate_new_with_modifiers(list(ACID = 20)))

	barricade_upgrade_type = choice

	user.visible_message(span_notice("[user]将[choice]安装到了[src]上。"),
		span_notice("你将[choice]安装到了[src]上。"))

	playsound(src, 'sound/items/tools/screwdriver.ogg', 25, TRUE)
	update_icon()

/obj/structure/deployable_barricade/metal/examine(mob/user)
	. = ..()
	switch(build_state)
		if(BARRICADE_METAL_FIRM)
			. += span_info("盖板已用<b>螺丝</b>固定到位。")
		if(BARRICADE_METAL_ANCHORED)
			. += span_info("盖板<i>已拧松</i>，但仍用<b>螺栓</b>固定在地面上。")
		if(BARRICADE_METAL_LOOSE)
			. += span_info("锚点<i>已卸下螺栓</i>，使用<b>撬棍</b>可将其拆解。")

	if(barricade_upgrade_type)
		. += span_info("它已安装了[barricade_upgrade_type]。")

	if(portable_type)
		. += span_info("按Alt+点击可将其折叠成便携形态。")

/obj/structure/deployable_barricade/metal/welder_act(mob/living/user, obj/item/I)
	var/obj/item/weldingtool/welding_tool = I

	if(!welding_tool.isOn())
		return FALSE

	if(get_integrity() <= max_integrity * 0.3)
		to_chat(user, span_warning("[src]损坏过于严重，无法用焊枪修复！"))
		return TRUE

	if(get_integrity() >= max_integrity)
		to_chat(user, span_warning("[src]不需要修复。"))
		return TRUE

	user.visible_message(span_notice("[user]开始焊接[src]上的损伤。"),
	span_notice("你开始焊接[src]上的损伤。"))
	playsound(src, 'sound/items/tools/welder2.ogg', 25, TRUE)

	if(!do_after(user, 5 SECONDS, src))
		return TRUE

	if(get_integrity() <= max_integrity * 0.3 || get_integrity() >= max_integrity)
		return TRUE

	if(!welding_tool.use(2))
		to_chat(user, span_warning("燃料不足！"))
		return TRUE

	user.visible_message(span_notice("[user] 焊接了 [src] 上的损伤。"),
	span_notice("你焊接了 [src] 上的损伤。"))
	repair_damage(150)
	update_icon()
	playsound(src, 'sound/items/tools/welder2.ogg', 25, TRUE)
	return TRUE


/obj/structure/deployable_barricade/metal/screwdriver_act(mob/living/user, obj/item/I)
	switch(build_state)
		if(BARRICADE_METAL_ANCHORED) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			playsound(src, 'sound/items/tools/screwdriver.ogg', 25, TRUE)
			if(!do_after(user, 1 SECONDS, src))
				return TRUE
			user.visible_message (span_notice ("[user] 固定了 [src] 上的面板。"),
			span_notice ("你固定了 [src] 上的面板。"))
			build_state = BARRICADE_METAL_FIRM
			return TRUE

		if(BARRICADE_METAL_FIRM) //Fully constructed step. Use screwdriver to remove the protection panels to reveal the bolts
			playsound(src, 'sound/items/tools/screwdriver.ogg', 25, TRUE)

			if(!do_after(user, 1 SECONDS, src))
				return TRUE

			user.visible_message (span_notice ("[user] 从 [src] 上移除了面板。"),
			span_notice ("你从 [src] 上移除了面板，露出了下面的一些<b>螺栓</b>。"))
			build_state = BARRICADE_METAL_ANCHORED
			return TRUE


/obj/structure/deployable_barricade/metal/wrench_act(mob/living/user, obj/item/I)
	switch(build_state)
		if(BARRICADE_METAL_ANCHORED) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			playsound(src, 'sound/items/tools/ratchet.ogg', 25, TRUE)
			if(!do_after(user, 1 SECONDS, src))
				return TRUE
			user.visible_message (span_notice ("[user] 松开了 [src] 上的锚定螺栓。"),
			span_notice ("你松开了 [src] 上的锚定螺栓。"))
			build_state = BARRICADE_METAL_LOOSE
			anchored = FALSE
			modify_max_integrity(initial(max_integrity) * 0.5)
			update_icon() //unanchored changes layer
			return TRUE

		if(BARRICADE_METAL_LOOSE) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to resecure anchor bolts
			var/turf/mystery_turf = get_turf(src)
			if(!isopenturf(mystery_turf))
				to_chat(user, span_warning("你无法在此处安装 [src]！"))
				return TRUE

			for(var/obj/structure/deployable_barricade/B in loc)
				if(B != src && B.dir == dir)
					to_chat(user, span_warning("此处已有一个路障。"))
					return TRUE

			playsound(src, 'sound/items/tools/ratchet.ogg', 25, TRUE)
			if(!do_after(user, 1 SECONDS, src))
				return TRUE

			user.visible_message(span_notice("[user] 拧紧了 [src] 上的锚定螺栓。"),
			span_notice("你拧紧了 [src] 上的锚定螺栓。"))
			build_state = BARRICADE_METAL_ANCHORED
			anchored = TRUE
			modify_max_integrity(initial(max_integrity))
			update_icon() //unanchored changes layer
			return TRUE


/obj/structure/deployable_barricade/metal/crowbar_act(mob/living/user, obj/item/tool)
	switch(build_state)
		if(BARRICADE_METAL_LOOSE) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to resecure anchor bolts
			user.visible_message(span_notice("[user] 开始拆卸 [src]。"),
			span_notice("你开始拆卸 [src]。"))

			playsound(src, 'sound/items/tools/crowbar.ogg', 25, 1)
			if(!do_after(user, 5 SECONDS, src))
				return TRUE

			user.visible_message(span_notice("[user] 拆解了 [src]。"),
			span_notice("你拆解了 [src]。"))
			playsound(src, 'sound/items/deconstruct.ogg', 25, 1)
			deconstruct(TRUE)
			return TRUE

		if(BARRICADE_METAL_FIRM)
			if(!barricade_upgrade_type) //Check to see if we actually have upgrades to remove.
				to_chat(user, span_warning("这个路障没有安装任何可移除的升级部件！"))
				return TRUE

			user.visible_message(span_notice("[user] 开始从 [src] 上拆卸装甲板。"),
			span_notice("你开始从 [src] 上拆卸装甲板。"))

			playsound(src, 'sound/items/tools/crowbar.ogg', 25, 1)
			if(!do_after(user, 5 SECONDS, src))
				return TRUE

			user.visible_message(span_notice("[user] 从 [src] 上拆下了装甲板。"),
			span_notice("你从 [src] 上拆下了装甲板。"))
			playsound(src, 'sound/items/deconstruct.ogg', 25, 1)

			switch(barricade_upgrade_type)
				if(BARRICADE_TYPE_BOMB)
					set_armor_rating(BOMB, max(get_armor_rating(BOMB) - 50, 0))
				if(BARRICADE_TYPE_MELEE)
					set_armor(get_armor().generate_new_with_modifiers(list(MELEE = -30, BULLET = -30)))
				if(BARRICADE_TYPE_ACID)
					set_armor(get_armor().generate_new_with_modifiers(list(ACID = -20)))

			new /obj/item/stack/sheet/iron(loc, BARRICADE_UPGRADE_REQUIRED_SHEETS)
			barricade_upgrade_type = null
			update_icon()
			return TRUE

/obj/structure/deployable_barricade/metal/ex_act(severity)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			take_damage(rand(400, 600))
		if(EXPLODE_HEAVY)
			take_damage(rand(150, 350))
		if(EXPLODE_LIGHT)
			take_damage(rand(50, 100))

	update_icon()

#undef BARRICADE_TYPE_BOMB
#undef BARRICADE_TYPE_MELEE
#undef BARRICADE_TYPE_ACID
#undef BARRICADE_UPGRADE_REQUIRED_SHEETS


/*----------------------*/
// PLASTEEL
/*----------------------*/

/obj/structure/deployable_barricade/metal/plasteel
	name = "塑钢路障"
	desc = "一个坚固的塑钢路障，必要时可以放倒。使用焊枪进行修复。"
	icon_state = "plasteel_closed_0"
	max_integrity = 500
	stack_type = /obj/item/stack/sheet/plasteel
	barricade_type = "plasteel"
	density = FALSE
	closed = TRUE
	can_upgrade = FALSE
	portable_type = /obj/item/quickdeploy/barricade/plasteel
	///Either we react with other cades next to us ie when opening or so
	var/linked = FALSE
	///Open/close delay, for customisation. And because I was asked to - won't customise anything myself.
	var/toggle_delay = 2 SECONDS
	custom_materials = list(/datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/deployable_barricade/metal/plasteel/crowbar_act(mob/living/user, obj/item/I)
	switch(build_state)
		if(BARRICADE_METAL_LOOSE) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to resecure anchor bolts
			user.visible_message(span_notice("[user] 开始拆卸 [src]。"),
			span_notice("你开始拆卸 [src]。"))

			playsound(src, 'sound/items/tools/crowbar.ogg', 25, 1)
			if(!do_after(user, 5 SECONDS, src))
				return TRUE

			user.visible_message(span_notice("[user] 拆解了 [src]。"),
			span_notice("你拆解了 [src]。"))
			playsound(src, 'sound/items/deconstruct.ogg', 25, 1)
			deconstruct(TRUE)
			return TRUE
		if(BARRICADE_METAL_FIRM)
			linked = !linked
			user.visible_message(span_notice("[user] 已经 [linked ? "linked" : "unlinked" ] [src]。"),
			span_notice("你 [linked ? "link" : "unlink" ] [src]。"))
			for(var/direction in GLOB.cardinals)
				for(var/obj/structure/deployable_barricade/metal/plasteel/cade in get_step(src, direction))
					cade.update_icon()
			update_icon()
			return TRUE

/obj/structure/deployable_barricade/metal/plasteel/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	if(do_after(user, toggle_delay, src))
		toggle_open(null, user)

/obj/structure/deployable_barricade/metal/plasteel/proc/toggle_open(state, mob/living/user)
	if(state == closed)
		return
	playsound(src, 'sound/items/tools/ratchet.ogg', 25, 1)
	closed = !closed
	density = !density

	user?.visible_message(span_notice("[user] [closed ? "lowers" : "raises"] [src] 。"),
		span_notice("你 [closed ? "lower" : "raise"] [src]。"))

	if(!linked)
		update_icon()
		return
	for(var/direction in GLOB.cardinals)
		for(var/obj/structure/deployable_barricade/metal/plasteel/cade in get_step(src, direction))
			if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade.linked)
				cade.toggle_open(closed)

	update_icon()

/obj/structure/deployable_barricade/metal/plasteel/update_overlays()
	. = ..()
	if(linked)
		for(var/direction in GLOB.cardinals)
			for(var/obj/structure/deployable_barricade/metal/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade.linked && cade.closed == closed)
					. += image('modular_nova/modules/barricades/icons/barricade.dmi', icon_state = "[barricade_type]_[closed ? "closed" : "open"]_connection_[get_dir(src, cade)]")

/obj/structure/deployable_barricade/metal/plasteel/ex_act(severity)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			take_damage(rand(450, 650))
		if(EXPLODE_HEAVY)
			take_damage(rand(200, 400))
		if(EXPLODE_LIGHT)
			take_damage(rand(50, 150))

	update_icon()

#undef BARRICADE_METAL_LOOSE
#undef BARRICADE_METAL_ANCHORED
#undef BARRICADE_METAL_FIRM

//An item thats meant to be a template for quickly deploying stuff like barricades
/obj/item/quickdeploy
	name = "C.U.C.K.S"
	desc = "紧凑型通用复合动能自展开路障。非常适合快速部署防御工事。"
	icon = 'modular_nova/modules/barricades/icons/barricade.dmi'
	w_class = WEIGHT_CLASS_SMALL //While this is small, normal 50 stacks of metal is NORMAL so this is a bit on the bad space to cade ratio
	var/delay = 0 //Delay on deploying the thing
	var/atom/movable/thing_to_deploy = null

/obj/item/quickdeploy/examine(mob/user)
	. = ..()
	. += "This [src.name] is set up deploy [initial(thing_to_deploy.name)]." // initial() since thing_to_deploy is a typepath

/obj/item/quickdeploy/attack_self(mob/user)
	to_chat(user, span_notice("你开始在面前部署[src]。"))
	playsound(src, 'sound/items/tools/ratchet.ogg', 25, 1)
	if(!do_after(usr, delay, src))
		return
	if(can_place(user)) //can_place() handles sending the error and success messages to the user
		var/obj/O = new thing_to_deploy(get_turf(user))
		O.setDir(user.dir)
		playsound(src, 'sound/items/tools/ratchet.ogg', 25, TRUE)
		qdel(src)

/obj/item/quickdeploy/proc/can_place(mob/user)
	if(isnull(thing_to_deploy)) //Spaghetti or wrong type spawned
		to_chat(user, span_warning("什么都没发生……[src]一定是坏了。"))
		return FALSE
	return TRUE

/obj/item/quickdeploy/barricade
	thing_to_deploy = /obj/structure/deployable_barricade/metal
	icon_state = "metal"
	delay = 3 SECONDS

/obj/item/quickdeploy/barricade/can_place(mob/user)
	. = ..()
	if(!.)
		return FALSE

	var/turf/mystery_turf = user.loc
	if(!isopenturf(mystery_turf))
		to_chat(user, span_warning("你无法在此处部署[src]！"))
		return FALSE

	var/turf/open/placement_loc = mystery_turf
	if(placement_loc.density) //We shouldn't be building here.
		to_chat(user, span_warning("你无法在此处部署[src]！"))
		return FALSE

	for(var/obj/thing in user.loc)
		if(!thing.density) //not dense, move on
			continue
		if(!(thing.flags_1 & ON_BORDER_1)) //dense and non-directional, end
			to_chat(user, span_warning("此处没有空间部署[src]。"))
			return FALSE
		if(thing.dir != user.dir)
			continue
		to_chat(user, span_warning("此处没有空间部署[src]。"))
		return FALSE
	to_chat(user, span_notice("你开始部署[src]……"))
	return TRUE

/obj/item/quickdeploy/barricade/plasteel
	thing_to_deploy = /obj/structure/deployable_barricade/metal/plasteel
	icon_state = "plasteel"

/obj/item/storage/barricade
	icon = 'modular_nova/modules/barricades/icons/barricade.dmi'
	name = "C.U.C.K.S箱"
	desc = "内含数个可部署路障。"
	icon_state = "box_metal"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/barricade

/datum/storage/barricade
	max_total_storage = 21

/obj/item/storage/barricade/PopulateContents()
	for(var/i = 0, i < 3, i++)
		new /obj/item/quickdeploy/barricade/plasteel(src)
	for(var/i = 0, i < 9, i ++)
		new /obj/item/quickdeploy/barricade(src)
