// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define SLAM_COMBO "GH"
#define KICK_COMBO "HH"
#define RESTRAIN_COMBO "GG"
#define PRESSURE_COMBO "DG"
#define CONSECUTIVE_COMBO "DDH"

/datum/martial_art/cqc
	name = "CQC"
	id = MARTIALART_CQC
	help_verb = "Remember The Basics"
	smashes_tables = TRUE
	display_combos = TRUE
	/// Weakref to a mob we're currently restraining (with grab-grab combo)
	VAR_PRIVATE/datum/weakref/restraining_mob
	/// Probability of successfully blocking attacks while on throw mode
	var/block_chance = 75

/datum/martial_art/cqc/activate_style(mob/living/new_holder)
	. = ..()
	RegisterSignal(new_holder, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(new_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))

/datum/martial_art/cqc/deactivate_style(mob/living/remove_from)
	UnregisterSignal(remove_from, list(COMSIG_ATOM_ATTACKBY, COMSIG_LIVING_CHECK_BLOCK))
	return ..()

///Signal from getting attacked with an item, for a special interaction with touch spells
/datum/martial_art/cqc/proc/on_attackby(mob/living/cqc_user, obj/item/attack_weapon, mob/attacker, list/modifiers)
	SIGNAL_HANDLER

	if(!istype(attack_weapon, /obj/item/melee/touch_attack))
		return
	if(!can_use(cqc_user))
		return
	cqc_user.visible_message(
		span_danger(LANG("datum.0d333f2552edfa5c", list(cqc_user, attacker, attack_weapon))),
		span_userdanger(LANG("datum.3a51a38eb1271f8c", list(attacker, attack_weapon))),
	)
	var/obj/item/melee/touch_attack/touch_weapon = attack_weapon
	var/datum/action/cooldown/spell/touch/touch_spell = touch_weapon.spell_which_made_us?.resolve()
	if(!touch_spell)
		return
	INVOKE_ASYNC(touch_spell, TYPE_PROC_REF(/datum/action/cooldown/spell/touch, do_hand_hit), touch_weapon, attacker, attacker)
	return COMPONENT_NO_AFTERATTACK

/datum/martial_art/cqc/proc/check_block(mob/living/cqc_user, atom/movable/hitby, damage, attack_text, attack_type, ...)
	SIGNAL_HANDLER

	if(!can_use(cqc_user) || !cqc_user.throw_mode || INCAPACITATED_IGNORING(cqc_user, INCAPABLE_GRAB))
		return NONE
	if(attack_type == PROJECTILE_ATTACK)
		return NONE

	var/blocking_text = "block"
	var/blocking_text_s = "blocks"
	var/potential_block_chance = block_chance

	if(attack_type == OVERWHELMING_ATTACK)
		blocking_text = "dodge"
		blocking_text_s = "dodges"
		potential_block_chance = clamp(round(potential_block_chance / (attack_type == OVERWHELMING_ATTACK ? 2 : 1), 1), 0, 100)

	if(!prob(potential_block_chance))
		return NONE

	var/mob/living/attacker = GET_ASSAILANT(hitby)
	if(istype(attacker) && cqc_user.Adjacent(attacker))
		cqc_user.visible_message(
			span_danger(LANG("datum.1933f4ed93731cce", list(cqc_user, blocking_text_s, attack_text, attacker, attacker.p_their()))),
			span_userdanger(LANG("datum.22d557f300d422c9", list(blocking_text, attack_text))),
		)
		attacker.Stun(4 SECONDS)
	else
		cqc_user.visible_message(
			span_danger(LANG("datum.dd02d8c90a5dee7a", list(cqc_user, blocking_text_s, attack_text))),
			span_userdanger(LANG("datum.22d557f300d422c9", list(blocking_text, attack_text))),
		)
	return SUCCESSFUL_BLOCK


/datum/martial_art/cqc/reset_streak(mob/living/new_target)
	if(!IS_WEAKREF_OF(new_target, restraining_mob))
		restraining_mob = null
	return ..()

/datum/martial_art/cqc/proc/check_streak(mob/living/attacker, mob/living/defender)
	if(findtext(streak, SLAM_COMBO))
		reset_streak()
		return Slam(attacker, defender)
	if(findtext(streak, KICK_COMBO))
		reset_streak()
		return Kick(attacker, defender)
	if(findtext(streak, RESTRAIN_COMBO))
		reset_streak()
		return Restrain(attacker, defender)
	if(findtext(streak, PRESSURE_COMBO))
		reset_streak()
		return Pressure(attacker, defender)
	if(findtext(streak, CONSECUTIVE_COMBO))
		reset_streak()
		return Consecutive(attacker, defender)
	return FALSE

/datum/martial_art/cqc/proc/Slam(mob/living/attacker, mob/living/defender)
	if(defender.body_position != STANDING_UP)
		return FALSE

	attacker.do_attack_animation(defender)
	defender.visible_message(
		span_danger(LANG("datum.28437593a3334789", list(attacker, defender))),
		span_userdanger(LANG("datum.1baae841f826b24c", list(attacker))),
		span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
		null,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.d04aff9ccb0f296e", list(defender))))
	playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
	defender.apply_damage(10, BRUTE)
	defender.Paralyze(12 SECONDS)
	log_combat(attacker, defender, "slammed (CQC)")
	return TRUE

/datum/martial_art/cqc/proc/Kick(mob/living/attacker, mob/living/defender)
	if(IS_UNCONSCIOUS_OR_CRIT(defender))
		return FALSE

	attacker.do_attack_animation(defender)
	if(defender.body_position == LYING_DOWN && !IS_UNCONSCIOUS(defender) && defender.get_stamina_loss() >= 100)
		log_combat(attacker, defender, "knocked out (Head kick)(CQC)")
		defender.visible_message(
			span_danger(LANG("datum.d51c445c737e9416", list(attacker, defender, defender.p_them()))),
			span_userdanger(LANG("datum.1ace6279c0000c05", list(attacker))),
			span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
			null,
			attacker,
		)
		to_chat(attacker, span_danger(LANG("datum.8e839a68309fc8df", list(defender, defender.p_them()))))
		playsound(attacker, 'sound/items/weapons/genhit1.ogg', 50, TRUE, -1)

		var/helmet_protection = defender.run_armor_check(BODY_ZONE_HEAD, MELEE)
		defender.apply_effect(20 SECONDS, EFFECT_KNOCKDOWN, helmet_protection)
		defender.apply_effect(10 SECONDS, EFFECT_UNCONSCIOUS, helmet_protection)
		defender.adjust_organ_loss(ORGAN_SLOT_BRAIN, 15, 150)

	else
		defender.visible_message(
			span_danger(LANG("datum.297558a635c8c1e8", list(attacker, defender))),
			span_userdanger(LANG("datum.a73f7ca41864771c", list(attacker))),
			span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger(LANG("datum.efbba3622af4c4a7", list(defender))))
		playsound(attacker, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)
		var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
		defender.throw_at(throw_target, 1, 14, attacker)
		defender.apply_damage(10, attacker.get_attack_type())
		if(defender.body_position == LYING_DOWN && !IS_UNCONSCIOUS(defender))
			defender.adjust_stamina_loss(45)
		log_combat(attacker, defender, "kicked (CQC)")

	return TRUE

/datum/martial_art/cqc/proc/Pressure(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender)
	log_combat(attacker, defender, "pressured (CQC)")
	defender.visible_message(
		span_danger(LANG("datum.24d741e8a92ad89b", list(attacker, defender))),
		span_userdanger(LANG("datum.ae2e7c737c846795", list(attacker))),
		span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.2d75ec005f210788", list(defender))))
	defender.adjust_stamina_loss(60)
	playsound(attacker, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)
	return TRUE

/datum/martial_art/cqc/proc/Restrain(mob/living/attacker, mob/living/defender)
	if(restraining_mob?.resolve())
		return FALSE
	if(IS_UNCONSCIOUS_OR_CRIT(defender))
		return FALSE

	log_combat(attacker, defender, "restrained (CQC)")
	defender.visible_message(
		span_warning(LANG("datum.67396b6465e14508", list(attacker, defender))),
		span_userdanger(LANG("datum.6d16cc5cd3fc556d", list(attacker))),
		span_hear(LANG("datum.1e8332d652f717af", null)),
		null,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.b7002ec5bba9ad1f", list(defender))))
	defender.adjust_stamina_loss(20)
	defender.Stun(10 SECONDS)
	restraining_mob = WEAKREF(defender)
	addtimer(VARSET_CALLBACK(src, restraining_mob, null), 5 SECONDS, TIMER_UNIQUE)
	return TRUE

/datum/martial_art/cqc/proc/Consecutive(mob/living/attacker, mob/living/defender)
	if(IS_UNCONSCIOUS_OR_CRIT(defender))
		return FALSE

	attacker.do_attack_animation(defender)
	log_combat(attacker, defender, "consecutive CQC'd (CQC)")
	defender.visible_message(
		span_danger(LANG("datum.ea757b5dbc489df2", list(attacker, defender))), \
		span_userdanger(LANG("datum.2e8e51a7f79b7718", list(attacker))),
		span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.1fe9c4d658d79b23", list(defender))))
	playsound(defender, 'sound/items/weapons/cqchit2.ogg', 50, TRUE, -1)
	var/obj/item/held_item = defender.get_active_held_item()
	if(held_item && defender.temporarilyRemoveItemFromInventory(held_item))
		attacker.put_in_hands(held_item)
	defender.adjust_stamina_loss(50)
	defender.apply_damage(25, attacker.get_attack_type())
	return TRUE

/datum/martial_art/cqc/grab_act(mob/living/attacker, mob/living/defender)
	if(attacker == defender)
		return MARTIAL_ATTACK_INVALID
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("G", defender)
	if(check_streak(attacker, defender)) //if a combo is made no grab upgrade is done
		return MARTIAL_ATTACK_SUCCESS
	if(attacker.body_position == LYING_DOWN)
		return MARTIAL_ATTACK_INVALID

	var/old_grab_state = attacker.grab_state
	defender.grabbedby(attacker, TRUE)
	if(old_grab_state == GRAB_PASSIVE)
		defender.drop_all_held_items()
		attacker.setGrabState(GRAB_AGGRESSIVE) //Instant aggressive grab if on grab intent
		log_combat(attacker, defender, "grabbed", addition="aggressively")
		defender.visible_message(
			span_warning(LANG("datum.c089d79c68a0807b", list(attacker, defender))),
			span_userdanger(LANG("datum.59d8575f49ca6ead", list(attacker))),
			span_hear(LANG("datum.1af6c3cc749ce1a9", null)),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger(LANG("datum.a2ee96d0e16ad938", list(defender))))
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/cqc/harm_act(mob/living/attacker, mob/living/defender)
	if(attacker.grab_state == GRAB_KILL \
		&& attacker.zone_selected == BODY_ZONE_HEAD \
		&& attacker.pulling == defender \
		&& defender.stat != DEAD \
	)
		var/obj/item/bodypart/head = defender.get_bodypart(BODY_ZONE_HEAD)
		if(!isnull(head))
			playsound(defender, 'sound/effects/wounds/crack1.ogg', 100)
			defender.visible_message(
				span_danger(LANG("datum.45b3e8b3cdc5d85e", list(attacker, defender))),
				span_userdanger(LANG("datum.810237f60a34e0cf", list(attacker))),
				span_hear(LANG("datum.c20f8aa4fd916933", null)),
				ignored_mobs = attacker
			)
			to_chat(attacker, span_danger(LANG("datum.bb7d46bd5d9cb21d", list(defender))))
			log_combat(attacker, defender, "snapped neck")
			defender.apply_damage(100, BRUTE, BODY_ZONE_HEAD, wound_bonus=CANT_WOUND)
			if(!HAS_TRAIT(defender, TRAIT_NODEATH))
				defender.death()
				defender.investigate_log("has had [defender.p_their()] neck snapped by [attacker].", INVESTIGATE_DEATHS)
			return MARTIAL_ATTACK_SUCCESS

	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(attacker.resting && defender.stat != DEAD && defender.body_position == STANDING_UP)
		defender.visible_message(
			span_danger(LANG("datum.34d4fc2abcc13c5b", list(attacker, defender))),
			span_userdanger(LANG("datum.9efb8512554d97ea", list(attacker))),
			span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
			null,
			attacker,
		)
		to_chat(attacker, span_danger(LANG("datum.d15d9893e5f735f8", list(defender))))
		playsound(attacker, 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
		attacker.do_attack_animation(defender)
		defender.apply_damage(10, BRUTE)
		defender.Knockdown(5 SECONDS)
		log_combat(attacker, defender, "sweeped (CQC)")
		reset_streak()
		return MARTIAL_ATTACK_SUCCESS

	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	attacker.do_attack_animation(defender)
	var/picked_hit_type = pick("CQC", "Big Boss")
	var/bonus_damage = 13
	if(defender.body_position == LYING_DOWN)
		bonus_damage += 5
		picked_hit_type = pick("kick", "stomp")
	defender.apply_damage(bonus_damage, BRUTE)

	playsound(defender, (picked_hit_type == "kick" || picked_hit_type == "stomp") ? 'sound/items/weapons/cqchit2.ogg' : 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)

	defender.visible_message(
		span_danger(LANG("datum.5db4057199ac5e30", list(attacker, picked_hit_type, defender))),
		span_userdanger(LANG("datum.074fb9e3a20824d3", list(picked_hit_type, attacker))),
		span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.22d557f300d422c9", list(picked_hit_type, defender))))
	log_combat(attacker, defender, "attacked ([picked_hit_type]'d)(CQC)")
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/cqc/disarm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	if(IS_WEAKREF_OF(attacker.pulling, restraining_mob))
		log_combat(attacker, defender, "disarmed (CQC)", addition = "knocked out (CQC Chokehold)")
		defender.visible_message(
			span_danger(LANG("datum.dbfacfa8839433f3", list(attacker, defender))),
			span_userdanger(LANG("datum.230e8f7fd61e89bb", list(attacker))),
			span_hear(LANG("datum.1e8332d652f717af", null)),
			null,
			attacker,
		)
		to_chat(attacker, span_danger(LANG("datum.d8130ed66dae3656", list(defender))))
		defender.SetSleeping(40 SECONDS)
		restraining_mob = null
		if(attacker.grab_state < GRAB_NECK && !HAS_TRAIT(attacker, TRAIT_PACIFISM))
			attacker.setGrabState(GRAB_NECK)
		return MARTIAL_ATTACK_SUCCESS

	attacker.do_attack_animation(defender, ATTACK_EFFECT_DISARM)
	if(prob(65) && (!IS_UNCONSCIOUS_OR_CRIT(defender) || !defender.IsParalyzed() || !restraining_mob?.resolve()))
		var/obj/item/disarmed_item = defender.get_active_held_item()
		if(disarmed_item && defender.temporarilyRemoveItemFromInventory(disarmed_item))
			defender.dropItemToGround(disarmed_item)
			if(isturf(disarmed_item.loc)) //If it fell on the ground we can take it, otherwise assume it's attached to something.
				attacker.put_in_hands(disarmed_item)
			else
				disarmed_item = null
		else
			disarmed_item = null

		defender.visible_message(
			span_danger(LANG("datum.b3402f89bb3d52bc", list(attacker, defender, disarmed_item ? ", disarming [defender.p_them()] of [disarmed_item]" : ""))),
			span_userdanger(LANG("datum.ef36a34989408cae", list(attacker, disarmed_item ? " disarming you of [disarmed_item] and" : ""))),
			span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger(LANG("datum.7398bc2077972d64", list(defender, disarmed_item ? " disarming [defender.p_them()] of [disarmed_item] and" : "", defender.p_them()))))
		playsound(defender, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)
		defender.set_jitter_if_lower(4 SECONDS)
		defender.apply_damage(5, attacker.get_attack_type())
		log_combat(attacker, defender, "disarmed (CQC)", addition = disarmed_item ? "(disarmed of [disarmed_item])" : null)
		return MARTIAL_ATTACK_SUCCESS

	defender.visible_message(
		span_danger(LANG("datum.af2d6dcde09377a4", list(attacker, defender))), \
		span_userdanger(LANG("datum.5ce50df813660980", list(attacker))),
		span_hear(LANG("datum.b8189c1ed616b3a4", null)),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_warning(LANG("datum.4c97e2d68a8586f7", list(defender))))
	playsound(defender, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
	log_combat(attacker, defender, "failed to disarm (CQC)")
	return MARTIAL_ATTACK_FAIL


/datum/martial_art/cqc/get_style_help()
	. = list()

	. += LANG("datum.5a0a1ff03ab92037", null)

	. += LANG("datum.1c8561d86366811f", list(span_notice("Slam")))
	. += LANG("datum.d7f076cc0cf6077d", list(span_notice("CQC Kick")))
	. += LANG("datum.7cc062151a1dbe31", list(span_notice("Restrain")))
	. += LANG("datum.5fee409314d44bfe", list(span_notice("Pressure")))
	. += LANG("datum.674011eb6a1294c6", list(span_notice("Consecutive CQC")))

	. += LANG("datum.46c32390830404d9", null)
	return .

///Subtype of CQC. Only used for the chef.
/datum/martial_art/cqc/under_siege
	name = "Close Quarters Cooking"
	///List of all areas that CQC will work in, defaults to Kitchen.
	var/list/kitchen_areas = list(/area/station/service/kitchen)

/// Refreshes the valid areas from the cook's mapping config, adding areas in config to the list of possible areas.
/datum/martial_art/cqc/under_siege/proc/refresh_valid_areas()
	var/list/additional_cqc_areas = CHECK_MAP_JOB_CHANGE(JOB_COOK, "additional_cqc_areas")
	if(!additional_cqc_areas)
		return

	if(!islist(additional_cqc_areas))
		stack_trace("Incorrect CQC area format from mapping configs. Expected /list, got: \[[additional_cqc_areas.type]\]")
		return

	for(var/path_as_text in additional_cqc_areas)
		var/path = text2path(path_as_text)
		if(!ispath(path, /area))
			stack_trace("Invalid path in mapping config for chef CQC: \[[path_as_text]\]")
			continue

		kitchen_areas |= path

/// Limits where the chef's CQC can be used to only whitelisted areas.
/datum/martial_art/cqc/under_siege/can_use(mob/living/martial_artist)
	if(!is_type_in_list(get_area(martial_artist), kitchen_areas))
		return FALSE
	return ..()

#undef SLAM_COMBO
#undef KICK_COMBO
#undef RESTRAIN_COMBO
#undef PRESSURE_COMBO
#undef CONSECUTIVE_COMBO
