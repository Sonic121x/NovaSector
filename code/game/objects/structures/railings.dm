/obj/structure/railing
	name = "栏杆"
	desc = "基本的栏杆是用来保护像你这样的白痴不会掉下去的。"
	icon = 'icons/obj/railings.dmi'
	icon_state = "railing"
	flags_1 = ON_BORDER_1
	obj_flags = CAN_BE_HIT | BLOCKS_CONSTRUCTION_DIR | IGNORE_DENSITY
	density = TRUE
	anchored = TRUE
	pass_flags_self = LETPASSTHROW|PASSSTRUCTURE
	layer = ABOVE_TREE_LAYER
	plane = ABOVE_GAME_PLANE
	/// armor is a little bit less than a grille. max_integrity about half that of a grille.
	armor_type = /datum/armor/structure_railing
	max_integrity = 25
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	var/climbable = TRUE
	///item released when deconstructed
	var/item_deconstruct = /obj/item/stack/rods

/datum/armor/structure_railing
	melee = 35
	bullet = 50
	laser = 50
	energy = 100
	bomb = 10

/obj/structure/railing/unbreakable
	resistance_flags = INDESTRUCTIBLE

/obj/structure/railing/corner //aesthetic corner sharp edges hurt oof ouch
	icon_state = "railing_corner"
	density = FALSE
	climbable = FALSE
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)

/obj/structure/railing/corner/unbreakable
	resistance_flags = INDESTRUCTIBLE

/obj/structure/railing/corner/end //end of a segment of railing without making a loop
	icon_state = "railing_end"

/obj/structure/railing/corner/end/unbreakable
	resistance_flags = INDESTRUCTIBLE

/obj/structure/railing/corner/end/flip //same as above but flipped around
	icon_state = "railing_end_flip"

/obj/structure/railing/corner/end/flip/unbreakable
	resistance_flags = INDESTRUCTIBLE

/obj/structure/railing/Initialize(mapload)
	. = ..()
	if(climbable)
		AddElement(/datum/element/climbable)

	if(density && flags_1 & ON_BORDER_1) // blocks normal movement from and to the direction it's facing.
		var/static/list/loc_connections = list(
			COMSIG_ATOM_EXIT = PROC_REF(on_exit),
		)
		AddElement(/datum/element/connect_loc, loc_connections)

	var/static/list/tool_behaviors = list(
		TOOL_WELDER = list(
			SCREENTIP_CONTEXT_LMB = "Repair",
		),
		TOOL_WRENCH = list(
			SCREENTIP_CONTEXT_LMB = "Anchor/Unanchor",
		),
		TOOL_WIRECUTTER = list(
			SCREENTIP_CONTEXT_LMB = "Deconstruct",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

	AddElement(/datum/element/simple_rotation, ROTATION_NEEDS_ROOM)

/obj/structure/railing/examine(mob/user)
	. = ..()
	if(anchored == TRUE)
		. += span_notice("栏杆已用<b>螺栓</b>固定在地板上。")
	else
		. += span_notice("栏杆已<i>松开螺栓</i>，可以用<b>钢丝钳</b>拆除。")

/obj/structure/railing/attackby(obj/item/I, mob/living/user, list/modifiers, list/attack_modifiers)
	..()
	add_fingerprint(user)

	if(I.tool_behaviour == TOOL_WELDER && !user.combat_mode)
		if(atom_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=1))
				return

			to_chat(user, span_notice("你开始修理[src]..."))
			if(I.use_tool(src, user, 40, volume=50))
				atom_integrity = max_integrity
				to_chat(user, span_notice("你修好了[src]。"))
		else
			to_chat(user, span_warning("[src]已经处于良好状态！"))
		return


/obj/structure/railing/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(resistance_flags & INDESTRUCTIBLE)
		to_chat(user, span_warning("你试图剪断栏杆，但它太硬了！"))
		I.play_tool_sound(src, 100)
		return TRUE
	to_chat(user, span_warning("你剪断了栏杆。"))
	I.play_tool_sound(src, 100)
	deconstruct()
	return TRUE

/obj/structure/railing/atom_deconstruct(disassembled)
	var/rods_to_make = istype(src,/obj/structure/railing/corner) ? 1 : 2
	var/obj/rod = new item_deconstruct(drop_location(), rods_to_make)
	transfer_fingerprints_to(rod)

///Implements behaviour that makes it possible to unanchor the railing.
/obj/structure/railing/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	to_chat(user, span_notice("你开始将栏杆[anchored ? "unfasten the railing from":"fasten the railing to"]..."))
	if(I.use_tool(src, user, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_anchored), anchored)))
		set_anchored(!anchored)
		to_chat(user, span_notice("你将栏杆[anchored ? "fasten the railing to":"unfasten the railing from"]。"))
	return TRUE

/obj/structure/railing/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(border_dir & dir)
		return . || mover.throwing || (mover.movement_type & MOVETYPES_NOT_TOUCHING_GROUND)
	return TRUE

/obj/structure/railing/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!(to_dir & dir))
		return TRUE
	return ..()

/obj/structure/railing/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return // Let's not block ourselves.

	if(!(direction & dir))
		return

	if (!density)
		return

	if (leaving.throwing)
		return

	if (leaving.movement_type & (PHASING|MOVETYPES_NOT_TOUCHING_GROUND))
		return

	if (leaving.move_force >= MOVE_FORCE_EXTREMELY_STRONG)
		return

	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/railing/proc/check_anchored(checked_anchored)
	if(anchored == checked_anchored)
		return TRUE


/obj/structure/railing/wooden_fence
	name = "木栅栏"
	desc = "用于圈养动物的木栅栏。"
	icon = 'icons/obj/structures.dmi'
	icon_state = "wooden_railing"
	item_deconstruct = /obj/item/stack/sheet/mineral/wood
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/railing/wooden_fence/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_change_layer))
	adjust_dir_layer(dir)

/obj/structure/railing/wooden_fence/proc/on_change_layer(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	adjust_dir_layer(new_dir)

/obj/structure/railing/wooden_fence/proc/adjust_dir_layer(direction)
	layer = (direction & NORTH) ? MOB_LAYER : initial(layer)


/obj/structure/railing/corner/end/wooden_fence
	icon = 'icons/obj/structures.dmi'
	icon_state = "wooden_railing_corner"

/obj/structure/railing/corner/end/flip/wooden_fence
	icon = 'icons/obj/structures.dmi'
	icon_state = "wooden_railing_corner_flipped"
