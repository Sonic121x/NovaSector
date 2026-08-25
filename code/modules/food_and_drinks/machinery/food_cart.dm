// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/obj/machinery/food_cart
	name = "food cart"
	desc = "A compact unpackable mobile cooking stand. Wow! When unpacked, it reminds you of those greasy gamer setups some people on NTNet have."
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "foodcart"
	density = TRUE
	anchored = FALSE
	use_power = NO_POWER_USE
	req_access = list(ACCESS_KITCHEN)
	obj_flags = parent_type::obj_flags | NO_DEBRIS_AFTER_DECONSTRUCTION
	var/unpacked = FALSE
	var/obj/machinery/griddle/stand/cart_griddle
	var/obj/machinery/smartfridge/food/cart_smartfridge
	var/obj/structure/table/reinforced/cart_table
	var/obj/effect/food_cart_stand/cart_tent
	var/list/packed_things

/obj/machinery/food_cart/Initialize(mapload)
	. = ..()
	cart_griddle = new(src)
	cart_smartfridge = new(src)
	cart_table = new(src)
	cart_tent = new(src)
	packed_things = list(cart_table, cart_smartfridge, cart_tent, cart_griddle) //middle, left, left, right
	RegisterSignal(cart_griddle, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_smartfridge, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_table, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_tent, COMSIG_QDELETING, PROC_REF(lost_part))

/obj/machinery/food_cart/Destroy()
	if(cart_griddle)
		QDEL_NULL(cart_griddle)
	if(cart_smartfridge)
		QDEL_NULL(cart_smartfridge)
	if(cart_table)
		QDEL_NULL(cart_table)
	if(cart_tent)
		QDEL_NULL(cart_tent)
	packed_things.Cut()
	return ..()

/obj/machinery/food_cart/examine(mob/user)
	. = ..()
	if(!(machine_stat & BROKEN))
		if(cart_griddle.machine_stat & BROKEN)
			. += span_warning(LANG("obj.07019d55e38e3875", null))
		else
			. += span_notice(LANG("obj.8241254e7cbdf256", null))
		. += span_notice(LANG("obj.c7d69e5cdace4312", null)) //weirdly enough, these fridges don't break
		. += span_notice(LANG("obj.86f899f5c4246253", null))

/obj/machinery/food_cart/proc/pack_up()
	if(!unpacked)
		return
	visible_message(span_notice(LANG("obj.10504e82f2de78f6", list(src))))
	for(var/o in packed_things)
		var/obj/object = o
		UnregisterSignal(object, COMSIG_MOVABLE_MOVED)
		object.forceMove(src)
	set_anchored(FALSE)
	unpacked = FALSE

/obj/machinery/food_cart/proc/unpack(mob/user)
	if(unpacked)
		return
	if(!check_setup_place())
		to_chat(user, span_warning(LANG("obj.621790211ddd41e7", null)))
		return
	visible_message(span_notice(LANG("obj.fc672b81d38a3240", list(src))))
	set_anchored(TRUE)
	var/iteration = 1
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		var/obj/thing = packed_things[iteration]
		thing.forceMove(T)
		RegisterSignal(thing, COMSIG_MOVABLE_MOVED, PROC_REF(lost_part))
		iteration++
	unpacked = TRUE

/obj/machinery/food_cart/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(machine_stat & BROKEN)
		to_chat(user, span_warning(LANG("obj.c695c81ad5138761", list(src))))
		return
	var/obj/item/card/id/id_card = user.get_idcard(hand_first = TRUE)
	if(!check_access(id_card))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, TRUE)
		return
	to_chat(user, span_notice(LANG("obj.930d236d481f5689", list(unpacked ? "pack up" :"unpack", src))))
	if(!do_after(user, 5 SECONDS, src))
		to_chat(user, span_warning(LANG("obj.d8c1f2e656a12226", list(unpacked ? "" :"un", src))))
		return
	if(unpacked)
		pack_up()
	else
		unpack(user)

/obj/machinery/food_cart/proc/check_setup_place()
	var/has_space = TRUE
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		if(T && !T.density)
			new /obj/effect/temp_visual/cart_space(T)
		else
			has_space = FALSE
			new /obj/effect/temp_visual/cart_space/bad(T)
	return has_space

/obj/machinery/food_cart/proc/lost_part(atom/movable/source, force)
	SIGNAL_HANDLER

	//okay, so it's deleting the fridge or griddle which are more important. We're gonna break the machine then
	UnregisterSignal(cart_griddle, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_smartfridge, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_table, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_tent, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	atom_break()

/obj/machinery/food_cart/atom_break(damage_flag)
	. = ..()
	pack_up()
	if(!QDELETED(cart_griddle))
		QDEL_NULL(cart_griddle)
	if(!QDELETED(cart_smartfridge))
		QDEL_NULL(cart_smartfridge)
	if(!QDELETED(cart_table))
		QDEL_NULL(cart_table)
	if(!QDELETED(cart_tent))
		QDEL_NULL(cart_tent)

/obj/effect/food_cart_stand
	name = "food cart tent"
	desc = "Something to battle the sun, for there are no breaks for the burger flippers."
	icon = 'icons/obj/fluff/3x3.dmi'
	icon_state = "stand"
	layer = ABOVE_MOB_LAYER//big mobs will still go over the tent, this is fine and cool
