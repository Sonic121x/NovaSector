// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/touch/flesh_surgery
	name = "Knit Flesh"
	desc = "A touch spell that allows you to either harvest or restore flesh of target. \
		Left-clicking will extract the organs of a victim without needing to complete surgery or disembowel. \
		You can also pick up a loose organ and insert it into your vitcim. \
		Right-clicking, if done on summons or minions, will restore health. Can also be used to heal damaged organs."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "mad_touch"
	sound = null

	school = SCHOOL_FORBIDDEN
	cooldown_time = 20 SECONDS
	invocation = "CL'M M'N!" // "CLAIM MINE", but also almost "KALI MA"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE

	hand_path = /obj/item/melee/touch_attack/flesh_surgery
	can_cast_on_self = TRUE

	/// If used on an organ, how much percent of the organ's HP do we restore
	var/organ_percent_healing = 0.5
	/// If used on a heretic mob, how much brute do we heal
	var/monster_brute_healing = 10
	/// If used on a heretic mob, how much burn do we heal
	var/monster_burn_healing = 5
	/// The organ being held in the touch attack - which will be implanted into mobs.
	var/obj/item/organ/held_organ
	/// Can we implant cybernetic organs?
	var/allow_cyber_organs = FALSE

/datum/action/cooldown/spell/touch/flesh_surgery/is_valid_target(atom/cast_on)
	return isliving(cast_on) || isorgan(cast_on)

/datum/action/cooldown/spell/touch/flesh_surgery/remove_hand(mob/living/hand_owner, reset_cooldown_after)
	var/obj/item/organ/the_organ = held_organ
	if(the_organ)
		unregister_held_organ(the_organ)
		the_organ.forceMove(hand_owner.drop_location())

	return ..()

/datum/action/cooldown/spell/touch/flesh_surgery/cast_on_hand_hit(obj/item/melee/touch_attack/flesh_surgery/hand, atom/victim, mob/living/carbon/caster)
	if(isorgan(victim))
		grab_organ(hand, victim, caster)
		return FALSE

	if(isliving(victim))
		if(held_organ)
			return insert_organ_into_mob(held_organ, hand, victim, caster)
		return steal_organ_from_mob(hand, victim, caster)

	return FALSE

/datum/action/cooldown/spell/touch/flesh_surgery/cast_on_secondary_hand_hit(obj/item/melee/touch_attack/flesh_surgery/hand, atom/victim, mob/living/carbon/caster)
	if(isorgan(victim))
		return heal_organ(hand, victim, caster)

	if(isliving(victim))
		var/mob/living/mob_victim = victim
		if(mob_victim.stat == DEAD || !HAS_TRAIT(mob_victim, TRAIT_HERETIC_SUMMON))
			return SECONDARY_ATTACK_CALL_NORMAL

		if(heal_heretic_monster(hand, mob_victim, caster))
			return SECONDARY_ATTACK_CONTINUE_CHAIN

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/datum/action/cooldown/spell/touch/flesh_surgery/register_hand_signals()
	. = ..()
	RegisterSignal(attached_hand, COMSIG_ITEM_REQUESTING_CONTEXT_FOR_TARGET, PROC_REF(add_item_context))
	RegisterSignal(attached_hand, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(hand_interacted_with))
	attached_hand.item_flags |= ITEM_HAS_CONTEXTUAL_SCREENTIPS

/datum/action/cooldown/spell/touch/flesh_surgery/unregister_hand_signals()
	. = ..()
	UnregisterSignal(attached_hand, list(COMSIG_ITEM_REQUESTING_CONTEXT_FOR_TARGET, COMSIG_ATOM_ITEM_INTERACTION))

/datum/action/cooldown/spell/touch/flesh_surgery/proc/hand_interacted_with(obj/item/melee/touch_attack/source, mob/living/user, obj/item/tool)
	SIGNAL_HANDLER
	if(isorgan(tool))
		return grab_organ(source, tool, user)

/// Signal proc for [COMSIG_ITEM_REQUESTING_CONTEXT_FOR_TARGET] to add some context to the hand.
/datum/action/cooldown/spell/touch/flesh_surgery/proc/add_item_context(obj/item/melee/touch_attack/source, list/context, atom/victim, mob/living/user)
	SIGNAL_HANDLER

	. = NONE

	if(isliving(victim))
		var/mob/living/mob_victim = victim

		if(iscarbon(mob_victim))
			if(held_organ)
				context[SCREENTIP_CONTEXT_LMB] = "Insert organ"
			else
				context[SCREENTIP_CONTEXT_LMB] = "Extract organ"
			. = CONTEXTUAL_SCREENTIP_SET

		if(HAS_TRAIT(mob_victim, TRAIT_HERETIC_SUMMON))
			context[SCREENTIP_CONTEXT_RMB] = "Heal [ishuman(mob_victim) ? "minion" : "summon"]"
			. = CONTEXTUAL_SCREENTIP_SET

	else if(isorgan(victim))
		context[SCREENTIP_CONTEXT_LMB] = "Pick up organ"
		context[SCREENTIP_CONTEXT_RMB] = "Heal organ"
		. = CONTEXTUAL_SCREENTIP_SET

	return .

/// If cast on an organ with left-click, we'll try to grab it.
/datum/action/cooldown/spell/touch/flesh_surgery/proc/grab_organ(obj/item/melee/touch_attack/hand, obj/item/organ/to_grab, mob/living/carbon/caster)
	if(held_organ)
		hand.balloon_alert(caster, LANG("datum.7eb0a8807167d51b", null))
		return ITEM_INTERACT_FAILURE
	if(to_grab.organ_flags & ORGAN_ROBOTIC && !allow_cyber_organs)
		hand.balloon_alert(caster, LANG("datum.661ae8b722ca763b", null))
		return ITEM_INTERACT_FAILURE
	if(!caster.transferItemToLoc(to_grab, hand))
		hand.balloon_alert(caster, LANG("datum.dab6f2b0e50d2fd3", null))
		return ITEM_INTERACT_FAILURE
	register_held_organ(to_grab, hand)
	return ITEM_INTERACT_SUCCESS

/datum/action/cooldown/spell/touch/flesh_surgery/proc/register_held_organ(obj/item/organ/new_held_organ, obj/item/melee/touch_attack/hand)
	hand.vis_contents += new_held_organ
	held_organ = new_held_organ
	ADD_TRAIT(new_held_organ, TRAIT_SKIP_BASIC_REACH_CHECK, REF(src))
	new_held_organ.vis_flags |= VIS_INHERIT_PLANE
	RegisterSignal(new_held_organ, COMSIG_MOVABLE_MOVED, PROC_REF(unregister_held_organ))
	RegisterSignal(new_held_organ, COMSIG_QDELETING, PROC_REF(unregister_held_organ))
	// We gotta offset ourselves via pixel_w/z, so we don't end up z fighting with the touch attack
	new_held_organ.pixel_w = new_held_organ.pixel_x
	new_held_organ.pixel_z = new_held_organ.pixel_y
	new_held_organ.pixel_x = 0
	new_held_organ.pixel_y = 0

/datum/action/cooldown/spell/touch/flesh_surgery/proc/unregister_held_organ(obj/item/organ/removed_organ)
	LAZYREMOVE(attached_hand.vis_contents, removed_organ)
	held_organ = null
	REMOVE_TRAIT(removed_organ, TRAIT_SKIP_BASIC_REACH_CHECK, REF(src))
	removed_organ.vis_flags &= ~VIS_INHERIT_PLANE
	UnregisterSignal(removed_organ, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	// Reset item offsets
	removed_organ.pixel_x = removed_organ.pixel_w
	removed_organ.pixel_y = removed_organ.pixel_z
	removed_organ.pixel_w = 0
	removed_organ.pixel_z = 0

/// If cast on an organ with right-click, we'll restore its health and even un-fail it.
/datum/action/cooldown/spell/touch/flesh_surgery/proc/heal_organ(obj/item/melee/touch_attack/hand, obj/item/organ/to_heal, mob/living/carbon/caster)
	if(held_organ)
		hand.balloon_alert(caster, LANG("datum.88357a8fd80fdf0e", null))
		return FALSE
	if(to_heal.damage == 0)
		to_heal.balloon_alert(caster, LANG("datum.43379d5f8d288697", null))
		return FALSE
	to_heal.balloon_alert(caster, LANG("datum.c787bf408eac93ea", null))
	if(!do_after(caster, 1 SECONDS, to_heal, extra_checks = CALLBACK(src, PROC_REF(heal_checks), hand, to_heal, caster)))
		to_heal.balloon_alert(caster, LANG("datum.c67b5d274d6e724b", null))
		return FALSE

	var/organ_hp_to_heal = to_heal.maxHealth * organ_percent_healing
	to_heal.set_organ_damage(max(0 , to_heal.damage - organ_hp_to_heal))
	to_heal.balloon_alert(caster, LANG("datum.e7b5e5840d8e50c7", null))
	playsound(to_heal, 'sound/effects/magic/staff_healing.ogg', 30)
	new /obj/effect/temp_visual/cult/sparks(get_turf(to_heal))
	var/condition = (to_heal.damage > 0) ? "better" : "perfect"
	caster.visible_message(
		span_warning(LANG("datum.65e3a4cb10b7668f", list(caster, caster.p_they(), caster.p_s(), to_heal, condition))),
		span_notice(LANG("datum.7c3a3093b029f6d5", list(to_heal, condition))),
	)

	return TRUE

/// If cast on a heretic monster who's not dead we'll heal it a bit.
/datum/action/cooldown/spell/touch/flesh_surgery/proc/heal_heretic_monster(obj/item/melee/touch_attack/hand, mob/living/to_heal, mob/living/carbon/caster)
	var/what_are_we = ishuman(to_heal) ? "minion" : "summon"
	to_heal.balloon_alert(caster, LANG("datum.2450eff2f764e0b7", list(what_are_we)))
	if(!do_after(caster, 1 SECONDS, to_heal, extra_checks = CALLBACK(src, PROC_REF(heal_checks), hand, to_heal, caster)))
		to_heal.balloon_alert(caster, LANG("datum.c67b5d274d6e724b", null))
		return FALSE

	// Keep in mind that, for simplemobs(summons), this will just flat heal the combined value of both brute and burn healing,
	// while for human minions(ghouls), this will heal brute and burn like normal. So be careful adjusting to bigger numbers
	to_heal.balloon_alert(caster, LANG("datum.adbd89f338081b7c", list(what_are_we)))
	to_heal.heal_overall_damage(monster_brute_healing, monster_burn_healing)
	playsound(to_heal, 'sound/effects/magic/staff_healing.ogg', 30)
	new /obj/effect/temp_visual/cult/sparks(get_turf(to_heal))
	caster.visible_message(
		span_warning(LANG("datum.095292138ff55d99", list(caster, caster.p_they(), caster.p_s(), to_heal))),
		span_notice(LANG("datum.8706eb38ae9e3d88", list(to_heal))),
	)
	return TRUE

/// If cast on a carbon, we'll try to steal one of their organs directly from their person.
/datum/action/cooldown/spell/touch/flesh_surgery/proc/steal_organ_from_mob(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	var/mob/living/carbon/carbon_victim = victim
	if(!istype(carbon_victim) || !length(carbon_victim.organs))
		victim.balloon_alert(caster, LANG("datum.2c3783652d79e64f", null))
		return FALSE

	// Round u pto the nearest generic zone (body, chest, arm)
	var/zone_to_check = check_zone(caster.zone_selected)
	var/parsed_zone = victim.parse_zone_with_bodypart(zone_to_check)

	var/list/organs_we_can_remove = list()
	for(var/obj/item/organ/organ as anything in carbon_victim.organs)
		// Only show organs which are in our generic zone
		if(deprecise_zone(organ.zone) != zone_to_check)
			continue
		// Also, some organs to exclude. Don't remove vital (brains), don't remove synthetics, and don't remove unremovable
		if(organ.organ_flags & (ORGAN_ROBOTIC|ORGAN_VITAL|ORGAN_UNREMOVABLE))
			continue

		organs_we_can_remove[organ.name] = organ

	if(!length(organs_we_can_remove))
		victim.balloon_alert(caster, LANG("datum.5f77ca3cb0f8041c", null))
		return FALSE

	var/chosen_organ = tgui_input_list(caster, LANG("datum.6eba9cd82d3833b2", null), name, sort_list(organs_we_can_remove))
	if(isnull(chosen_organ))
		return FALSE
	var/obj/item/organ/picked_organ = organs_we_can_remove[chosen_organ]
	if(!istype(picked_organ) || !extraction_checks(picked_organ, hand, victim, caster))
		return FALSE

	// Don't let people stam crit into steal heart true combo
	var/time_it_takes = carbon_victim.stat == DEAD ? 3 SECONDS : 15 SECONDS

	// Sure you can remove your own organs, fun party trick
	if(carbon_victim == caster)
		var/are_you_sure = tgui_alert(caster, LANG("datum.15bf88f16062223b", list(chosen_organ)), LANG("datum.773441628de640b4", null), list("Yes", "No"))
		if(are_you_sure != "Yes" || !extraction_checks(picked_organ, hand, victim, caster))
			return FALSE

		time_it_takes = 6 SECONDS
		caster.visible_message(
			span_danger(LANG("datum.08b1b614ab175bf0", list(caster, caster.p_they(), caster.p_es(), caster.p_their(), parsed_zone))),
			span_userdanger(LANG("datum.a1bed891957bb66c", list(parsed_zone))),
		)

	else
		carbon_victim.visible_message(
			span_danger(LANG("datum.7f02bcad6946a1f0", list(caster, caster.p_they(), caster.p_es(), carbon_victim, parsed_zone))),
			span_userdanger(LANG("datum.e35e400056181be7", list(caster, caster.p_they(), caster.p_es(), parsed_zone))),
		)

	carbon_victim.balloon_alert(caster, LANG("datum.1136aa5b98f8d15a", list(chosen_organ)))
	playsound(victim, 'sound/items/weapons/slice.ogg', 50, TRUE)
	carbon_victim.add_atom_colour(COLOR_DARK_RED, TEMPORARY_COLOUR_PRIORITY)
	if(!do_after(caster, time_it_takes, carbon_victim, extra_checks = CALLBACK(src, PROC_REF(extraction_checks), picked_organ, hand, victim, caster)))
		carbon_victim.balloon_alert(caster, LANG("datum.c67b5d274d6e724b", null))
		carbon_victim.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, COLOR_DARK_RED)
		return FALSE

	// Visible message done before Remove()
	// Mainly so it gets across if you're taking the eyes of someone who's conscious
	if(carbon_victim == caster)
		caster.visible_message(
			span_bolddanger(LANG("datum.70963ae7ff4f0b1e", list(caster, caster.p_their(), chosen_organ, caster.p_their(), parsed_zone))),
			span_userdanger(LANG("datum.c9e52d84447d6d46", list(chosen_organ, parsed_zone))),
		)

	else
		carbon_victim.visible_message(
			span_bolddanger(LANG("datum.96a83576566841a0", list(caster, carbon_victim, chosen_organ, carbon_victim.p_their(), parsed_zone))),
			span_userdanger(LANG("datum.120eb0ee82284622", list(caster, chosen_organ, parsed_zone))),
		)

	picked_organ.Remove(carbon_victim)
	carbon_victim.balloon_alert(caster, LANG("datum.2a4235b4837591d1", list(chosen_organ)))
	carbon_victim.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, COLOR_DARK_RED)
	playsound(victim, 'sound/effects/dismember.ogg', 50, TRUE)
	if(!IS_UNCONSCIOUS_OR_CRIT(carbon_victim))
		carbon_victim.adjust_timed_status_effect(15 SECONDS, /datum/status_effect/speech/slurring/heretic)
		carbon_victim.emote("scream")

	// We need to wait for the spell to actually finish casting to put the organ in their hands, hence, 1 ms timer.
	addtimer(CALLBACK(caster, TYPE_PROC_REF(/mob, put_in_hands), picked_organ), 0.1 SECONDS)
	return TRUE

/datum/action/cooldown/spell/touch/flesh_surgery/proc/insert_organ_into_mob(obj/item/organ/inserted_organ, obj/item/melee/touch_attack/flesh_surgery/hand, mob/living/carbon/victim, mob/living/carbon/caster)
	if(!istype(victim))
		hand.balloon_alert(caster, LANG("datum.2c3783652d79e64f", null))
		return FALSE

	var/zone_organ_goes_in = inserted_organ.zone
	if(!victim.get_bodypart(deprecise_zone(zone_organ_goes_in)))
		hand.balloon_alert(caster, LANG("datum.58899bc370285076", null))
		return FALSE

	var/slot_organ_goes_in = inserted_organ.slot
	var/obj/item/organ/organ_victim_already_has = victim.get_organ_slot(slot_organ_goes_in)
	if(organ_victim_already_has?.organ_flags & ORGAN_VITAL|ORGAN_UNREMOVABLE)
		hand.balloon_alert(caster, LANG("datum.13b1ebc420d3a6c1", null))
		return FALSE

	var/time_it_takes
	var/using_on_self = victim == caster
	var/replacing_with_failing = !(organ_victim_already_has?.organ_flags & ORGAN_FAILING) && inserted_organ.organ_flags & ORGAN_FAILING
	if(using_on_self)
		time_it_takes = inserted_organ.w_class * 2 SECONDS
	else if(victim.stat == DEAD)
		time_it_takes = inserted_organ.w_class * 1 SECONDS
	else if(replacing_with_failing)
		time_it_takes = 15 SECONDS
	else
		time_it_takes = inserted_organ.w_class * 3 SECONDS

	if(using_on_self && replacing_with_failing)
		var/are_you_sure = tgui_alert(caster,
			LANG("datum.2669b1c39e3b491e", list(organ_victim_already_has.name, inserted_organ.name)),
			LANG("datum.773441628de640b4", null),
			list("Yes", "No"))
		if(!are_you_sure)
			return FALSE

	if(!insertion_checks(inserted_organ, hand, victim, caster))
		return FALSE

	if(using_on_self)
		caster.visible_message(
			span_danger(LANG("datum.ac353bd5981a9a66", list(caster, caster.p_they(), caster.p_s(), inserted_organ, caster.p_their(), zone_organ_goes_in))),
			span_userdanger(LANG("datum.2f1b18e482c3b976", list(inserted_organ, zone_organ_goes_in)))
		)
	else
		caster.visible_message(
			span_danger(LANG("datum.e1b738cd8e078e62", list(caster, caster.p_they(), caster.p_s(), inserted_organ, victim, zone_organ_goes_in))),
			span_notice(LANG("datum.3ec9a7983718a028", list(inserted_organ, victim, zone_organ_goes_in)))
		)

	victim.balloon_alert(caster, LANG("datum.3b69f686bbad2ffe", list(inserted_organ)))
	playsound(victim, 'sound/items/weapons/slice.ogg', 50, TRUE)
	victim.add_atom_colour(COLOR_DARK_RED, TEMPORARY_COLOUR_PRIORITY)
	if(!do_after(caster, time_it_takes, victim, extra_checks = CALLBACK(src, PROC_REF(insertion_checks), inserted_organ, hand, victim, caster)))
		victim.balloon_alert(caster, LANG("datum.c67b5d274d6e724b", null))
		victim.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, COLOR_DARK_RED)
		return FALSE

	organ_victim_already_has = victim.get_organ_slot(slot_organ_goes_in) // This COULD have changed over the course of the do_after

	if(using_on_self)
		caster.visible_message(
			span_danger(LANG("datum.ec632f28863233ce", list(caster, inserted_organ, caster.p_their(), zone_organ_goes_in, organ_victim_already_has ? ", forcing out [caster.p_their()] [organ_victim_already_has.name]": ""))),
			span_userdanger(LANG("datum.a527df0b03a3fc4a", list(inserted_organ, zone_organ_goes_in, organ_victim_already_has ? ", forcing out your [organ_victim_already_has]" : "")))
		)
	else
		caster.visible_message(
			span_danger(LANG("datum.38d2a3ab0e063b02", list(caster, inserted_organ, victim, zone_organ_goes_in, organ_victim_already_has ? ", forcing out [victim.p_their()] [organ_victim_already_has.name]": ""))),
			span_notice(LANG("datum.6870ecf1f10d26d2", list(inserted_organ, victim, zone_organ_goes_in, organ_victim_already_has ? ", forcing out [victim.p_their()] [organ_victim_already_has.name]": "")))
		)

	unregister_held_organ(inserted_organ)
	inserted_organ.Insert(victim)
	victim.balloon_alert(caster, LANG("datum.048c1f348d556f2c", list(inserted_organ)))
	victim.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, COLOR_DARK_RED)
	playsound(victim, 'sound/effects/dismember.ogg', 50, TRUE)
	if(!IS_UNCONSCIOUS_OR_CRIT(victim))
		victim.emote("scream")
		if(!using_on_self)
			victim.adjust_timed_status_effect(15 SECONDS, /datum/status_effect/speech/slurring/heretic)

	return TRUE

/// Extra checks ran while we're extracting an organ to make sure we can continue to do.
/datum/action/cooldown/spell/touch/flesh_surgery/proc/extraction_checks(obj/item/organ/picked_organ, obj/item/melee/touch_attack/flesh_surgery/hand, mob/living/carbon/victim, mob/living/carbon/caster)
	if(QDELETED(src) || QDELETED(hand) || QDELETED(picked_organ) || QDELETED(victim) || held_organ || !IsAvailable())
		return FALSE

	return TRUE

/// Extra checks ran while we're healing something (organ, mob).
/datum/action/cooldown/spell/touch/flesh_surgery/proc/heal_checks(obj/item/melee/touch_attack/flesh_surgery/hand, atom/healing, mob/living/carbon/caster)
	if(QDELETED(src) || QDELETED(hand) || QDELETED(healing) || held_organ || !IsAvailable())
		return FALSE

	return TRUE

/// Extra checks ran while we're inserting an organ.
/datum/action/cooldown/spell/touch/flesh_surgery/proc/insertion_checks(obj/item/organ/inserted_organ, obj/item/melee/touch_attack/flesh_surgery/hand, mob/living/carbon/victim, mob/living/carbon/caster)
	if(QDELETED(src) || QDELETED(hand) || QDELETED(victim) || QDELETED(inserted_organ) || (held_organ != inserted_organ) || !IsAvailable())
		return FALSE
	var/obj/item/organ/organ_victim_already_has = victim.get_organ_slot(inserted_organ.slot)
	if(organ_victim_already_has?.organ_flags & ORGAN_VITAL|ORGAN_UNREMOVABLE)
		return FALSE

	return TRUE

/obj/item/melee/touch_attack/flesh_surgery
	name = "\improper knit flesh"
	desc = "Let's go practice medicine."
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "disintegrate"
	inhand_icon_state = "disintegrate"
