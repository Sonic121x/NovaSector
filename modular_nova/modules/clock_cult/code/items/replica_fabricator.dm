#define BRASS_POWER_COST 10
#define REGULAR_POWER_COST (BRASS_POWER_COST / 2)

/obj/item/clockwork/replica_fabricator
	name = "复制品制造机"
	desc = "一个奇怪的黄铜装置，带有许多扭曲的齿轮和通风口。"
	icon = 'modular_nova/modules/clock_cult/icons/clockwork_objects.dmi'
	lefthand_file = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_lefthand.dmi'
	righthand_file = 'modular_nova/modules/clock_cult/icons/weapons/clockwork_righthand.dmi'
	icon_state = "replica_fabricator"
	/// How much power this has. 5 generated per sheet inserted, one sheet of bronze costs 10, one floor tile costs 15, one wall costs 20
	var/power = 0
	/// How much power this can contain at most. By default, is 2 stacks of regular materials or 1 stack of brass
	var/max_power = 500
	/// List of things that the fabricator can build for the radial menu
	var/static/list/crafting_possibilities = list(
		"floor" = image(icon = 'icons/turf/floors.dmi', icon_state = "clockwork_floor"),
		"wall" = image(icon = 'icons/turf/walls/clockwork_wall.dmi', icon_state = "clockwork_wall-0"),
		"wall gear" = image(icon = 'icons/obj/structures.dmi', icon_state = "wall_gear"),
		"window" = image(icon = 'icons/obj/smooth_structures/clockwork_window.dmi', icon_state = "clockwork_window-0"),
		"airlock" = image(icon = 'icons/obj/doors/airlocks/clockwork/pinion_airlock.dmi', icon_state = "closed"),
		"glass airlock" = image(icon = 'icons/obj/doors/airlocks/clockwork/pinion_airlock.dmi', icon_state = "construction"),
	)
	/// List of initialized fabrication datums, created on Initialize
	var/static/list/fabrication_datums = list()
	/// Ref to the datum we have selected currently
	var/datum/replica_fabricator_output/selected_output


/obj/item/clockwork/replica_fabricator/Initialize(mapload)
	. = ..()
	if(!length(fabrication_datums))
		create_fabrication_list()

/obj/item/clockwork/replica_fabricator/Destroy(force)
	selected_output = null
	return ..()

/obj/item/clockwork/replica_fabricator/examine(mob/user)
	. = ..()
	if(IS_CLOCK(user))
		. += "[span_brass("Current power: ")][span_clockyellow("[power]")] [span_brass("W / ")][span_clockyellow("[max_power]")] [span_brass("W.")]"
		. += span_brass("对黄铜使用以将其转化为能量。")
		. += span_brass("对其他材料使用以将其转化为能量，但效率较低。")
		. += span_brass("<b>手持使用</b>以选择要制造的物品。")
		. += span_brass("<b>右键点击</b>手中的物品来制造青铜板材。")


/obj/item/clockwork/replica_fabricator/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!IS_CLOCK(user))
		return NONE

	if(istype(interacting_with, /obj/item/stack/sheet)) // If it's an item, handle it seperately
		attempt_convert_materials(interacting_with, user)
		return ITEM_INTERACT_SUCCESS

	if(!selected_output || !isopenturf(interacting_with)) // Now we handle objects
		return ITEM_INTERACT_BLOCKING

	var/turf/creation_turf = get_turf(interacting_with)

	if(locate(selected_output.to_create_path) in creation_turf)
		to_chat(user, span_clockyellow("这个格子上已经有一个了！"))
		return ITEM_INTERACT_BLOCKING

	if(power < selected_output.cost)
		to_chat(user, span_clockyellow("[src] 需要至少 [selected_output.cost]W 的能量来制造此物品。"))
		return ITEM_INTERACT_BLOCKING

	var/obj/effect/temp_visual/ratvar/constructing_effect/effect = new(creation_turf, selected_output.creation_delay)

	if(!do_after(user, selected_output.creation_delay, interacting_with))
		qdel(effect)
		return ITEM_INTERACT_BLOCKING

	if(power < selected_output.cost) // Just in case
		return ITEM_INTERACT_BLOCKING

	power -= selected_output.cost

	var/atom/created

	if(selected_output.to_create_path)
		created = new selected_output.to_create_path(get_turf(interacting_with))

	selected_output.on_create(created, creation_turf, user)
	return ITEM_INTERACT_SUCCESS


/obj/item/clockwork/replica_fabricator/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!IS_CLOCK(user))
		return

	attempt_convert_materials(attacking_item, user)


/obj/item/clockwork/replica_fabricator/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(!IS_CLOCK(user))
		return

	if(power < BRASS_POWER_COST)
		to_chat(user, span_clockyellow("你需要至少[BRASS_POWER_COST]W的能量来制造黄铜。"))
		return

	var/sheets = tgui_input_number(user, "你想要制造多少张板材？", "板材制造", 0, round(power / BRASS_POWER_COST), 0)
	if(!sheets)
		return

	power -= sheets * BRASS_POWER_COST

	var/obj/item/stack/sheet/bronze/sheet_stack = new(null, sheets)
	user.put_in_hands(sheet_stack)
	playsound(src, 'sound/machines/click.ogg', 50, 1)
	to_chat(user, span_clockyellow("你制造了[sheets]青铜。"))


/obj/item/clockwork/replica_fabricator/attack_self(mob/user, modifiers)
	. = ..()
	var/choice = show_radial_menu(user, src, crafting_possibilities, radius = 36, custom_check = PROC_REF(check_menu), require_near = TRUE)

	if(!choice)
		return

	selected_output = fabrication_datums[choice]


/// Standard confirmation for the radial menu proc
/obj/item/clockwork/replica_fabricator/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE

	if(user.incapacitated)
		return FALSE

	return TRUE

/// Attempt to convert the targeted item into power, if it's a sheet item
/obj/item/clockwork/replica_fabricator/proc/attempt_convert_materials(atom/attacking_item, mob/user)
	if(power >= max_power)
		to_chat(user, span_clockyellow("[src] 已经达到最大功率了！"))
		return

	if(istype(attacking_item, /obj/item/stack/sheet/bronze))
		var/obj/item/stack/bronze_stack = attacking_item

		if((power + bronze_stack.amount * BRASS_POWER_COST) > max_power)
			var/amount_to_take = clamp(round((max_power - power) / BRASS_POWER_COST), 0, bronze_stack.amount)

			if(!amount_to_take)
				to_chat(user, span_clockyellow("[src] 无法用这个进一步充能！"))
				return

			bronze_stack.use(amount_to_take)
			power += amount_to_take * BRASS_POWER_COST

		else
			power += bronze_stack.amount * BRASS_POWER_COST
			qdel(bronze_stack)

		playsound(src, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, span_clockyellow("你将[bronze_stack.amount]青铜转化为[bronze_stack.amount * BRASS_POWER_COST]瓦特的能量。"))

		return TRUE

	else if(istype(attacking_item, /obj/item/stack/sheet))
		var/obj/item/stack/stack = attacking_item

		if((power + stack.amount * REGULAR_POWER_COST) > max_power)
			var/amount_to_take = clamp(round((max_power - power) / REGULAR_POWER_COST), 0, stack.amount)

			if(!amount_to_take)
				to_chat(user, span_clockyellow("[src] 无法用这个进一步充能！"))
				return

			stack.use(amount_to_take)
			power += amount_to_take * REGULAR_POWER_COST

		else
			power += stack.amount * REGULAR_POWER_COST
			qdel(stack)

		playsound(src, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, span_clockyellow("你将[stack.amount] [stack.name]转换成了[stack.amount * REGULAR_POWER_COST]瓦特的能量。"))

		return TRUE

	return FALSE

/// Creates the list of initialized fabricator datums, done once on init
/obj/item/clockwork/replica_fabricator/proc/create_fabrication_list()
	for(var/type in subtypesof(/datum/replica_fabricator_output))
		var/datum/replica_fabricator_output/output_ref = new type
		fabrication_datums[output_ref.name] = output_ref


/datum/replica_fabricator_output
	/// Name of the output
	var/name = "parent"
	/// Power cost of the output
	var/cost = 0
	/// Typepath to spawn
	var/to_create_path
	/// How long the creation actionbar is
	var/creation_delay = 1 SECONDS


/// Any extra actions that need to be taken when an object is created
/datum/replica_fabricator_output/proc/on_create(atom/created_atom, turf/creation_turf, mob/creator)
	SHOULD_CALL_PARENT(TRUE)
	playsound(creation_turf, 'sound/machines/clockcult/integration_cog_install.ogg', 50, 1) // better sound?
	to_chat(creator, span_clockyellow("You create \an [name] for [cost]W of power."))


/datum/replica_fabricator_output/brass_floor
	name = "地板"
	cost = BRASS_POWER_COST * 0.25 // 1/4th the cost, since one sheet = 4 floor tiles


/datum/replica_fabricator_output/brass_floor/on_create(obj/created_object, turf/creation_turf, mob/creator)
	creation_turf.ChangeTurf(/turf/open/floor/bronze)

	new /obj/effect/temp_visual/ratvar/floor(creation_turf)
	new /obj/effect/temp_visual/ratvar/beam(creation_turf)
	return ..()


/datum/replica_fabricator_output/brass_wall
	name = "墙壁"
	cost = BRASS_POWER_COST * 4
	creation_delay = 2.5 SECONDS


/datum/replica_fabricator_output/brass_wall/on_create(obj/created_object, turf/creation_turf, mob/creator)
	creation_turf.ChangeTurf(/turf/closed/wall/mineral/bronze)

	new /obj/effect/temp_visual/ratvar/wall(creation_turf)
	new /obj/effect/temp_visual/ratvar/beam(creation_turf)
	return ..()


/datum/replica_fabricator_output/wall_gear
	name = "墙壁齿轮"
	cost = BRASS_POWER_COST * 2
	to_create_path = /obj/structure/girder/bronze
	creation_delay = 1.5 SECONDS


/datum/replica_fabricator_output/wall_gear/on_create(obj/created_object, turf/creation_turf, mob/creator)
	new /obj/effect/temp_visual/ratvar/gear(creation_turf)
	new /obj/effect/temp_visual/ratvar/beam(creation_turf)
	return ..()


/datum/replica_fabricator_output/brass_window
	name = "窗户"
	cost = BRASS_POWER_COST * 2
	to_create_path = /obj/structure/window/bronze/fulltile
	creation_delay = 2.5 SECONDS


/datum/replica_fabricator_output/brass_window/on_create(obj/created_object, turf/creation_turf, mob/creator)
	new /obj/effect/temp_visual/ratvar/window(creation_turf)
	new /obj/effect/temp_visual/ratvar/beam(creation_turf)
	return ..()


/datum/replica_fabricator_output/pinion_airlock
	name = "气闸门"
	cost = BRASS_POWER_COST * 5 // Breaking it only gets 2 but this is the exception to the rule of equivalent exchange, due to all the small parts inside
	to_create_path = /obj/machinery/door/airlock/bronze/clock
	creation_delay = 4 SECONDS


/datum/replica_fabricator_output/pinion_airlock/on_create(obj/created_object, turf/creation_turf, mob/creator)
	new /obj/effect/temp_visual/ratvar/door(creation_turf)
	new /obj/effect/temp_visual/ratvar/beam(creation_turf)
	return ..()


/datum/replica_fabricator_output/pinion_airlock/glass
	name = "玻璃气闸门"
	to_create_path = /obj/machinery/door/airlock/bronze/clock/glass


#undef BRASS_POWER_COST
#undef REGULAR_POWER_COST
