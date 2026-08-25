// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**********************Jaunter**********************/
/obj/item/wormhole_jaunter
	name = "wormhole jaunter"
	desc = "A single use device harnessing outdated wormhole technology, Nanotrasen has since turned its eyes to bluespace for more accurate teleportation. The wormholes it creates are unpleasant to travel through, to say the least.\nThanks to modifications provided by the Free Golems, this jaunter can be worn on the belt to provide protection from chasms."
	icon = 'icons/obj/mining.dmi'
	icon_state = "Jaunter"
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	slot_flags = ITEM_SLOT_BELT

/obj/item/wormhole_jaunter/attack_self(mob/user)
	user.visible_message(span_notice(LANG("obj.c4887f356612d7e9", list(user.name, src))))
	SSblackbox.record_feedback("tally", "jaunter", 1, "User") // user activated
	activate(user, TRUE)

/obj/item/wormhole_jaunter/proc/turf_check(mob/user)
	var/turf/device_turf = get_turf(src)
	if(!device_turf || is_centcom_level(device_turf.z) || is_reserved_level(device_turf.z))
		if(user)
			to_chat(user, span_notice(LANG("obj.742b1de3f18b0d84", list(src))))
		return FALSE
	return TRUE

/obj/item/wormhole_jaunter/proc/get_destinations()
	var/list/destinations = list()

	for(var/obj/item/beacon/B in GLOB.teleportbeacons)
		var/turf/T = get_turf(B)
		if(is_station_level(T.z))
			destinations += B

	return destinations

/obj/item/wormhole_jaunter/proc/can_jaunter_teleport()
	var/list/destinations = get_destinations()
	return destinations.len > 0

/obj/item/wormhole_jaunter/proc/activate(mob/user, adjacent, teleport)
	if(!turf_check(user))
		return FALSE

	if(!can_jaunter_teleport())
		if(user)
			to_chat(user, span_notice(LANG("obj.98a5ae9f169d7bb4", list(src))))
		else
			visible_message(span_notice(LANG("obj.50b508b32ec44e25", list(src))))
		return FALSE

	var/list/destinations = get_destinations()
	var/chosen_beacon = pick(destinations)

	var/obj/effect/portal/jaunt_tunnel/tunnel = new (get_turf(src), 100, null, FALSE, get_turf(chosen_beacon))
	if(teleport)
		tunnel.teleport(user)
	else if(adjacent)
		try_move_adjacent(tunnel)

	qdel(src)
	return TRUE

/obj/item/wormhole_jaunter/emp_act(power)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	var/triggered = FALSE
	if(power == 1)
		triggered = TRUE
	else if(power == 2 && prob(50))
		triggered = TRUE

	var/mob/M = loc
	if(istype(M) && triggered)
		M.visible_message(span_userdanger(LANG("obj.439c22f5930fa794", list(src.name))))
		SSblackbox.record_feedback("tally", "jaunter", 1, "EMP") // EMP accidental activation
		activate(M, FALSE, TRUE)
	else if(triggered)
		visible_message(span_warning(LANG("obj.bee2023267bb0720", list(src))))
		activate()

/obj/item/wormhole_jaunter/equipped(mob/user, slot, initial)
	. = ..()
	if (slot & ITEM_SLOT_BELT)
		RegisterSignal(user, COMSIG_MOVABLE_CHASM_DROPPED, PROC_REF(chasm_react))

/obj/item/wormhole_jaunter/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_CHASM_DROPPED)

/obj/item/wormhole_jaunter/proc/chasm_react(mob/living/user, turf/chasm)
	SIGNAL_HANDLER

	if(!activate(user, FALSE, TRUE))
		return

	to_chat(user, span_userdanger(LANG("obj.f72a240ea36aebd8", list(src, chasm))))
	chasm.visible_message(span_boldwarning(LANG("obj.cc559545cc158b12", list(user, chasm)))) // To freak out any bystanders
	SSblackbox.record_feedback("tally", "jaunter", 1, "Chasm") // Chasm automatic activation
	return COMPONENT_NO_CHASM_DROP

//jaunter tunnel
/obj/effect/portal/jaunt_tunnel
	name = "jaunt tunnel"
	icon = 'icons/effects/anomalies.dmi'
	icon_state = "vortex"
	desc = "A stable hole in the universe made by a wormhole jaunter. Turbulent doesn't even begin to describe how rough passage through one of these is, but at least it will always get you somewhere near a beacon."
	mech_sized = TRUE //save your ripley
	innate_accuracy_penalty = 6
	light_on = FALSE
	wibbles = FALSE

/obj/effect/portal/jaunt_tunnel/teleport(atom/movable/M, force = FALSE)
	. = ..()
	if(.)
		// KERPLUNK
		playsound(M,'sound/items/weapons/resonator_blast.ogg',50,TRUE)
		if(iscarbon(M))
			var/mob/living/carbon/L = M
			L.Paralyze(60)
			if(ishuman(L))
				shake_camera(L, 20, 1)
				addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/carbon, vomit)), 2 SECONDS)
