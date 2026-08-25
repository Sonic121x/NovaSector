// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Hierophant club

/obj/item/hierophant_club
	name = "hierophant club"
	desc = "The shriveled remains of the Hierophant hold some remnant of its power. It used it to beat you, but now you can set the beat."
	icon_state = "hierophant_club"
	inhand_icon_state = "hierophant_club"
	icon_angle = -135
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	force = 15
	attack_verb_continuous = list("clubs", "beats", "pummels")
	attack_verb_simple = list("club", "beat", "pummel")
	hitsound = 'sound/items/weapons/sonic_jackhammer.ogg'
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	actions_types = list(/datum/action/item_action/vortex_recall)
	action_slots = ALL
	/// Linked teleport beacon for the group teleport functionality.
	var/obj/effect/hierophant/beacon
	/// TRUE if currently doing a teleport to the beacon, FALSE otherwise.
	var/teleporting = FALSE
	/// Action enabling the blink-dash functionality.
	var/datum/action/innate/dash/hierophant/blink
	/// Whether the blink ability is activated. IF TRUE, left clicking a location will blink to it. If FALSE, this is disabled.
	var/blink_activated = TRUE

/obj/item/hierophant_club/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	blink = new(src)
	update_appearance(UPDATE_OVERLAYS)

	RegisterSignals(blink, list(COMSIG_DASH_ACTION_CHARGED, COMSIG_DASH_ACTION_DASHED), PROC_REF(on_action_updated))

/obj/item/hierophant_club/Destroy(force)
	QDEL_NULL(blink)
	return ..()

/obj/item/hierophant_club/examine(mob/user)
	. = ..()
	if (beacon)
		. += span_hierophant_warning(LANG("obj.12fb2a0babf6b572", null))
	else
		. += span_hierophant_warning(LANG("obj.2ffa72ef723d2eaa", null))

/obj/item/hierophant_club/equipped(mob/user)
	. = ..()
	blink.Grant(user, src)
	user.update_icons()

/obj/item/hierophant_club/dropped(mob/user)
	. = ..()
	blink.Remove(user)
	user.update_icons()

/obj/item/hierophant_club/suicide_act(mob/living/user)
	say(LANG("obj.2171e62957dafa89", null), forced = "hierophant club suicide")
	user.visible_message(span_suicide(LANG("obj.f07c4e5705c7ecaa", list(user, src, user.p_theyre()))))
	new/obj/effect/temp_visual/hierophant/telegraph(get_turf(user))
	playsound(user,'sound/machines/airlock/airlockopen.ogg', 75, TRUE)
	user.visible_message(span_hierophant_warning(LANG("obj.d8fbae0a1ec34a1b", list(user, user.p_their()))))
	for (var/obj/item/user_item as anything in user.get_all_gear(FALSE, FALSE))
		user.dropItemToGround(user_item)
	for (var/turf/blast_turf as anything in RANGE_TURFS(1, user))
		new /obj/effect/temp_visual/hierophant/blast/visual(blast_turf, user, TRUE)
	user.dropItemToGround(src) //Drop us last, so it goes on top of their stuff
	qdel(user)

/obj/item/hierophant_club/attack_self(mob/user)
	. = ..()
	blink_activated = !blink_activated
	balloon_alert(user, LANG("obj.8bf8601d6abb245f", list(blink_activated ? "enabled" : "disabled")))

/obj/item/hierophant_club/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	// If our target is the beacon and the hierostaff is next to the beacon, we're trying to pick it up.
	if (interacting_with == beacon || !isturf(interacting_with.loc))
		return NONE

	if (!blink_activated)
		return NONE

	if (blink.teleport(user, interacting_with))
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/item/hierophant_club/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (blink_activated)
		blink.teleport(user, interacting_with)
		return ITEM_INTERACT_SUCCESS
	return NONE

/// When dash action is used or recharges, update icon state
/obj/item/hierophant_club/proc/on_action_updated()
	SIGNAL_HANDLER
	update_appearance(UPDATE_OVERLAYS)

/obj/item/hierophant_club/update_overlays()
	. = ..()
	if (QDELETED(beacon))
		. += "hierophant_beacon"
	if (blink?.current_charges)
		. += "hierophant_ready"

/obj/item/hierophant_club/worn_overlays(mutable_appearance/standing, isinhands, icon_file, bodyshape = NONE)
	. = ..()
	if (blink?.current_charges)
		. += "hierophant_ready"


/obj/item/hierophant_club/ui_action_click(mob/user, action)
	if (teleporting)
		balloon_alert(user, LANG("obj.38f46f8c1ab54d5a", null))
		return

	if (!user.is_holding(src))
		to_chat(user, span_warning(LANG("obj.27974ddec7663530", list(beacon ? "teleport with it" : "detach the beacon"))))
		return

	if (!beacon)
		deploy_beacon(user)
		return

	if (get_dist(user, beacon) <= 2)
		balloon_alert(user, LANG("obj.466424023c6ae922", null))
		return

	var/turf/beacon_turf = get_turf(beacon)
	if (!beacon_turf || beacon_turf.is_blocked_turf(TRUE))
		balloon_alert(user, LANG("obj.0073d886a1d4319f", null))
		return

	if (!isturf(user.loc))
		balloon_alert(user, LANG("obj.1b17b31b62d27776", null))
		return

	var/turf/user_turf = get_turf(user)
	teleporting = TRUE
	user.update_mob_action_buttons()
	user.visible_message(span_hierophant_warning(LANG("obj.45261f8221f4b2a6", list(user))), span_hierophant_warning(LANG("obj.9bc97ff8b4d35d0c", list(src))))
	beacon.icon_state = "hierophant_tele_on"
	var/obj/effect/temp_visual/hierophant/telegraph/edge/user_telegraph = new /obj/effect/temp_visual/hierophant/telegraph/edge(user_turf)
	var/obj/effect/temp_visual/hierophant/telegraph/edge/beacon_telegraph = new /obj/effect/temp_visual/hierophant/telegraph/edge(beacon_turf)
	if (!do_after(user, 4 SECONDS, user))
		if (user)
			balloon_alert(user, LANG("obj.c67b5d274d6e724b", null))
		stop_teleport(user)
		qdel(user_telegraph)
		qdel(beacon_telegraph)
		return

	if (!beacon)
		balloon_alert(user, LANG("obj.c67b5d274d6e724b", null))
		stop_teleport(user)
		return

	if (beacon_turf.is_blocked_turf(TRUE))
		balloon_alert(user, LANG("obj.0073d886a1d4319f", null))
		stop_teleport(user)
		return

	new /obj/effect/temp_visual/hierophant/telegraph(user_turf, user)
	new /obj/effect/temp_visual/hierophant/telegraph(beacon_turf, user)
	playsound(user_turf, 'sound/machines/airlock/airlockopen.ogg', 200, TRUE)
	playsound(beacon_turf, 'sound/effects/magic/wand_teleport.ogg', 200, TRUE)

	new /obj/effect/temp_visual/hierophant/telegraph/teleport(user_turf, user)
	new /obj/effect/temp_visual/hierophant/telegraph/teleport(beacon_turf, user)

	for(var/turf/turf_near_user_turf as anything in RANGE_TURFS(1, user_turf))
		new /obj/effect/temp_visual/hierophant/blast/visual(turf_near_user_turf, user, TRUE)

	for(var/turf/turf_near_beacon as anything in RANGE_TURFS(1, beacon_turf))
		new /obj/effect/temp_visual/hierophant/blast/visual(turf_near_beacon, user, TRUE)

	for(var/mob/living/victim in range(1, user_turf))
		INVOKE_ASYNC(src, PROC_REF(teleport_mob), user_turf, beacon_turf, victim, user)

	addtimer(CALLBACK(src, PROC_REF(stop_teleport), user), 0.6 SECONDS)

/// Just to cut down on copypasta
/obj/item/hierophant_club/proc/stop_teleport(mob/user)
	teleporting = FALSE
	if (beacon)
		beacon.icon_state = "hierophant_tele_off"
	if (user)
		user.update_mob_action_buttons()

/// Teleports mobs after a short animation
/obj/item/hierophant_club/proc/teleport_mob(turf/user_turf, turf/beacon_turf, mob/victim, mob/user)
	var/turf/target_turf = get_step(beacon_turf, get_dir(user_turf, victim))
	if (!target_turf || target_turf.is_blocked_turf(TRUE))
		return
	animate(victim, alpha = 0, time = 0.2 SECONDS, easing = SINE_EASING|EASE_OUT)
	sleep(0.2 SECONDS)
	victim.visible_message(span_hierophant_warning(LANG("obj.4bb7a725a18425e7", list(victim))))
	var/success = do_teleport(victim, target_turf, no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
	animate(victim, alpha = 255, time = 0.2 SECONDS, SINE_EASING|EASE_OUT)
	victim.visible_message(span_hierophant_warning(LANG("obj.61581aadb868bdab", list(victim))))
	if (user != victim && success)
		log_combat(user, victim, "teleported", null, "from [AREACOORD(user_turf)]")

/// Attempts to place a return beacon at user's feet
/obj/item/hierophant_club/proc/deploy_beacon(mob/user)
	if (!isopenturf(user.loc) && !isopenspaceturf(user.loc))
		to_chat(user, span_warning(LANG("obj.464f3814dcc55a33", null)))
		return

	user.visible_message(span_hierophant_warning(LANG("obj.cb6fbf099c3a719a", list(user, src))), span_notice(LANG("obj.937ca6cfbd8500e3", null)))
	balloon_alert(user, LANG("obj.906583db69069568", null))
	if (!do_after(user, 5 SECONDS, user))
		balloon_alert(user, LANG("obj.c67b5d274d6e724b", null))
		return

	// Already dropped one
	if (beacon)
		return

	var/turf/user_turf = get_turf(user)
	new /obj/effect/temp_visual/hierophant/telegraph/teleport(user_turf, user)
	beacon = new /obj/effect/hierophant(user_turf)
	playsound(beacon, 'sound/effects/magic/blind.ogg', 200, TRUE, -4)
	RegisterSignal(beacon, COMSIG_QDELETING, PROC_REF(beacon_destroyed))

	user.update_mob_action_buttons()
	user.visible_message(span_hierophant_warning(LANG("obj.75b5b16e0a5ad4e3", list(user, user.p_their()))), span_hierophant(LANG("obj.b6bf25cb7dea1a61", null)))
	to_chat(user, span_hierophant(LANG("obj.5e2546c55d122e5a", null)))
	update_appearance(UPDATE_OVERLAYS)

/obj/item/hierophant_club/proc/beacon_destroyed(datum/source)
	SIGNAL_HANDLER
	beacon = null
	if (ismob(loc))
		to_chat(loc, span_hierophant(LANG("obj.4cbb06f817389035", list(src))))
	else
		visible_message(span_hierophant(LANG("obj.4cbb06f817389035", list(src))))
	playsound(src, 'sound/effects/magic/blind.ogg', 50, TRUE, -4)
	update_appearance(UPDATE_OVERLAYS)

#define HIEROPHANT_BLINK_RANGE 5
#define HIEROPHANT_BLINK_COOLDOWN (15 SECONDS)

/datum/action/innate/dash/hierophant
	current_charges = 1
	max_charges = 1
	charge_rate = HIEROPHANT_BLINK_COOLDOWN
	recharge_sound = null
	phasein = /obj/effect/temp_visual/hierophant/blast/visual
	phaseout = /obj/effect/temp_visual/hierophant/blast/visual
	// It's a simple purple beam, works well enough for the purple hiero effects.
	beam_effect = "plasmabeam"

/datum/action/innate/dash/hierophant/teleport(mob/user, atom/target)
	var/dist = get_dist(user, target)
	if(dist > HIEROPHANT_BLINK_RANGE)
		user.balloon_alert(user, LANG("datum.f5e75781e8f1dc46", null))
		return FALSE

	return ..()

/datum/action/innate/dash/hierophant/charge()
	. = ..()
	var/obj/item/hierophant_club/club = target
	if(istype(club))
		club.update_appearance(UPDATE_ICON_STATE)

#undef HIEROPHANT_BLINK_RANGE
#undef HIEROPHANT_BLINK_COOLDOWN
