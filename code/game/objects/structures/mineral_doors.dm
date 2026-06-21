//NOT using the existing /obj/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness

/obj/structure/mineral_door
	name = "铁门"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	layer = CLOSED_DOOR_LAYER
	material_flags = MATERIAL_EFFECTS

	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "metal"
	max_integrity = 200
	armor_type = /datum/armor/structure_mineral_door
	can_atmos_pass = ATMOS_PASS_DENSITY
	rad_insulation = RAD_MEDIUM_INSULATION
	material_flags = MATERIAL_EFFECTS
	material_modifier = 0.25

	var/door_opened = FALSE //if it's open or not.
	var/isSwitchingStates = FALSE //don't try to change stats if we're already opening

	var/close_delay = -1 //-1 if does not auto close.
	var/openSound = 'sound/effects/stonedoor_openclose.ogg'
	var/closeSound = 'sound/effects/stonedoor_openclose.ogg'

	var/sheetType = /obj/item/stack/sheet/iron //what we're made of
	var/sheetAmount = 10 //how much it takes to construct us.

/datum/armor/structure_mineral_door
	melee = 10
	energy = 100
	bomb = 10
	fire = 50
	acid = 50

/obj/structure/mineral_door/Initialize(mapload)
	. = ..()
	var/obj/item/stack/initialized_mineral = new sheetType // Okay this kinda sucks.
	set_custom_materials(initialized_mineral.mats_per_unit, sheetAmount)
	qdel(initialized_mineral)
	air_update_turf(TRUE, TRUE)

/obj/structure/mineral_door/Destroy()
	if(!door_opened)
		air_update_turf(TRUE, FALSE)
	. = ..()

/obj/structure/mineral_door/Move()
	var/turf/T = loc
	. = ..()
	if(!door_opened)
		move_update_air(T)

/obj/structure/mineral_door/Bumped(atom/movable/AM)
	..()
	if(!door_opened)
		return TryToSwitchState(AM)

/obj/structure/mineral_door/attack_ai(mob/user) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(iscyborg(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/mineral_door/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/mineral_door/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	return TryToSwitchState(user)

/obj/structure/mineral_door/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(istype(mover, /obj/effect/beam))
		return !opacity

/obj/structure/mineral_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates || !anchored)
		return
	if(isliving(user))
		var/mob/living/matters = user
		if(matters.client)
			if(iscarbon(matters))
				var/mob/living/carbon/carbon_user = matters
				if(!carbon_user.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(ismecha(user))
		SwitchState()

/obj/structure/mineral_door/proc/SwitchState()
	if(door_opened)
		Close()
	else
		Open()

/obj/structure/mineral_door/proc/Open()
	isSwitchingStates = TRUE
	playsound(src, openSound, 100, TRUE)
	set_opacity(FALSE)
	flick("[initial(icon_state)]opening",src)
	sleep(1 SECONDS)
	set_density(FALSE)
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(TRUE, FALSE)
	update_appearance()
	isSwitchingStates = FALSE

	if(close_delay != -1)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/mineral_door/proc/Close()
	if(isSwitchingStates || !door_opened)
		return
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		return
	isSwitchingStates = TRUE
	playsound(src, closeSound, 100, TRUE)
	flick("[initial(icon_state)]closing",src)
	sleep(1 SECONDS)
	set_density(TRUE)
	set_opacity(TRUE)
	door_opened = FALSE
	layer = initial(layer)
	air_update_turf(TRUE, TRUE)
	update_appearance()
	isSwitchingStates = FALSE

/obj/structure/mineral_door/update_icon_state()
	icon_state = "[initial(icon_state)][door_opened ? "open":""]"
	return ..()

/obj/structure/mineral_door/attackby(obj/item/I, mob/living/user)
	if(pickaxe_door(user, I))
		return
	else if(!user.combat_mode)
		return attack_hand(user)
	else
		return ..()

/obj/structure/mineral_door/set_anchored(anchorvalue) //called in default_unfasten_wrench() chain
	. = ..()
	set_opacity(anchored ? !door_opened : FALSE)
	air_update_turf(TRUE, anchorvalue)

/obj/structure/mineral_door/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, time = 4 SECONDS)
	return ITEM_INTERACT_SUCCESS


/////////////////////// TOOL OVERRIDES ///////////////////////


/obj/structure/mineral_door/proc/pickaxe_door(mob/living/user, obj/item/I) //override if the door isn't supposed to be a minable mineral.
	if(!istype(user))
		return
	if(I.tool_behaviour != TOOL_MINING)
		return
	. = TRUE
	to_chat(user, span_notice("你开始挖掘[src]..."))
	if(I.use_tool(src, user, 40, volume=50))
		to_chat(user, span_notice("你完成了挖掘。"))
		deconstruct(TRUE)

/obj/structure/mineral_door/welder_act(mob/living/user, obj/item/I) //override if the door is supposed to be flammable.
	..()
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src]仍然牢牢固定在地面上！"))
		return

	user.visible_message(span_notice("[user]开始焊接拆解[src]！"), span_notice("你开始焊接拆解[src]。"))
	if(!I.use_tool(src, user, 60, 5, 50))
		to_chat(user, span_warning("你未能焊接拆解[src]！"))
		return

	user.visible_message(span_notice("[user]将[src]焊接成了碎片！"), span_notice("你焊接拆解了[src]！"))
	deconstruct(TRUE)

/obj/structure/mineral_door/proc/crowbar_door(mob/living/user, obj/item/I) //if the door is flammable, call this in crowbar_act() so we can still decon it
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src]仍然牢牢固定在地面上！"))
		return

	user.visible_message(span_notice("[user]开始撬开[src]！"), span_notice("你开始撬开[src]。"))
	if(!I.use_tool(src, user, 60, volume = 50))
		to_chat(user, span_warning("你未能撬开[src]！"))
		return

	user.visible_message(span_notice("[user]将[src]撬成了碎片！"), span_notice("你撬开了[src]！"))
	deconstruct(TRUE)


/////////////////////// END TOOL OVERRIDES ///////////////////////


/obj/structure/mineral_door/atom_deconstruct(disassembled = TRUE)
	var/turf/T = get_turf(src)
	if(disassembled)
		new sheetType(T, sheetAmount)
	else
		new sheetType(T, max(sheetAmount - 2, 1))

/obj/structure/mineral_door/iron
	name = "iron door"
	max_integrity = 300
	sheetAmount = 20

/obj/structure/mineral_door/silver
	name = "银门"
	icon_state = "silver"
	sheetType = /obj/item/stack/sheet/mineral/silver
	max_integrity = 300
	rad_insulation = RAD_HEAVY_INSULATION

/obj/structure/mineral_door/gold
	name = "金门"
	icon_state = "gold"
	sheetType = /obj/item/stack/sheet/mineral/gold
	rad_insulation = RAD_HEAVY_INSULATION

/obj/structure/mineral_door/uranium
	name = "铀门"
	icon_state = "uranium"
	sheetType = /obj/item/stack/sheet/mineral/uranium
	max_integrity = 300
	light_range = 2

/obj/structure/mineral_door/sandstone
	name = "砂岩门"
	icon_state = "sandstone"
	sheetType = /obj/item/stack/sheet/mineral/sandstone
	max_integrity = 100

/obj/structure/mineral_door/transparent
	opacity = FALSE
	rad_insulation = RAD_VERY_LIGHT_INSULATION

/obj/structure/mineral_door/transparent/Close()
	..()
	set_opacity(FALSE)

/obj/structure/mineral_door/transparent/plasma
	name = "等离子门"
	icon_state = "plasma"
	sheetType = /obj/item/stack/sheet/mineral/plasma

/obj/structure/mineral_door/transparent/diamond
	name = "钻石门"
	icon_state = "diamond"
	sheetType = /obj/item/stack/sheet/mineral/diamond
	max_integrity = 1000
	rad_insulation = RAD_EXTREME_INSULATION

/obj/structure/mineral_door/wood
	name = "木门"
	icon_state = "wood"
	openSound = 'sound/effects/doorcreaky.ogg'
	closeSound = 'sound/effects/doorcreaky.ogg'
	sheetType = /obj/item/stack/sheet/mineral/wood
	resistance_flags = FLAMMABLE
	max_integrity = 200
	rad_insulation = RAD_VERY_LIGHT_INSULATION

/obj/structure/mineral_door/wood/pickaxe_door(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/crowbar_act(mob/living/user, obj/item/I)
	return crowbar_door(user, I)

/obj/structure/mineral_door/wood/attackby(obj/item/I, mob/living/user)
	if(I.get_temperature() >= FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
		fire_act(I.get_temperature())
		return

	return ..()

/obj/structure/mineral_door/paperframe
	name = "纸框门"
	icon_state = "paperframe"
	openSound = 'sound/effects/doorcreaky.ogg'
	closeSound = 'sound/effects/doorcreaky.ogg'
	sheetType = /obj/item/stack/sheet/paperframes
	sheetAmount = 3
	resistance_flags = FLAMMABLE
	max_integrity = 20

/obj/structure/mineral_door/paperframe/Initialize(mapload)
	. = ..()
	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/structure/mineral_door/paperframe/examine(mob/user)
	. = ..()
	if(atom_integrity < max_integrity)
		. += span_info("它看起来有点损坏，你或许可以用一些<b>纸</b>来修复它。")

/obj/structure/mineral_door/paperframe/pickaxe_door(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/paperframe/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/paperframe/crowbar_act(mob/living/user, obj/item/I)
	return crowbar_door(user, I)

/obj/structure/mineral_door/paperframe/attackby(obj/item/I, mob/living/user)
	if(I.get_temperature() >= FIRE_MINIMUM_TEMPERATURE_TO_EXIST) //BURN IT ALL DOWN JIM
		fire_act(I.get_temperature())
		return

	if((!user.combat_mode) && istype(I, /obj/item/paper) && (atom_integrity < max_integrity))
		user.visible_message(span_notice("[user]开始修补[src]上的破洞。"), span_notice("你开始修补[src]上的一些破洞！"))
		if(do_after(user, 2 SECONDS, src))
			atom_integrity = min(atom_integrity+4,max_integrity)
			qdel(I)
			user.visible_message(span_notice("[user]修补了[src]上的一些破洞。"), span_notice("你修补了[src]上的一些破洞！"))
			return TRUE

	return ..()

/obj/structure/mineral_door/paperframe/Destroy()
	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()
