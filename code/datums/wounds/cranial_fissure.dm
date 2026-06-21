/datum/wound_pregen_data/cranial_fissure
	wound_path_to_generate = /datum/wound/cranial_fissure
	required_limb_biostate = BIO_BONE

	required_wounding_type = WOUND_ALL

	wound_series = WOUND_SERIES_CRANIAL_FISSURE

	threshold_minimum = 110
	weight = 10

	viable_zones = list(BODY_ZONE_HEAD)

/datum/wound_pregen_data/cranial_fissure/get_weight(obj/item/bodypart/limb, woundtype, damage, attack_direction, damage_source)
	if (isnull(limb.owner))
		return ..()

	if (HAS_TRAIT(limb.owner, TRAIT_CURSED) && (limb.get_mangled_state() & BODYPART_MANGLED_INTERIOR))
		return ..()

	if (limb.owner.stat >= HARD_CRIT)
		return ..()

	return 0

/// A wound applied when receiving significant enough damage to the head.
/// Will allow other players to take your eyes out of your head, and slipping
/// will cause your brain to fall out of your head.
/datum/wound/cranial_fissure
	name = "颅骨裂隙"
	desc = "患者的颅顶裂开，暴露出颅骨的严重损伤。"
	treat_text = "Surgical reconstruction of the skull is necessary."
	treat_text_short = "Surgical reconstruction required."
	examine_desc = "is split open"
	occur_text = "is split into two separated chunks"

	simple_desc = "Patient's skull is split open."
	threshold_penalty = 40

	severity = WOUND_SEVERITY_CRITICAL
	sound_effect = 'sound/effects/dismember.ogg'
	surgery_states = SURGERY_SKIN_OPEN | SURGERY_BONE_SAWED // Literally a cracked open skull, no vessels as it... doesn't bleed?

	/// If TRUE we have been prepped for surgery (to repair)
	VAR_FINAL/prepped = FALSE

#define CRANIAL_FISSURE_FILTER_DISPLACEMENT "cranial_fissure_displacement"

/datum/wound/cranial_fissure/wound_injury(datum/wound/old_wound = null, attack_direction = null)
	ADD_TRAIT(limb, TRAIT_IMMUNE_TO_CRANIAL_FISSURE, type)
	ADD_TRAIT(victim, TRAIT_HAS_CRANIAL_FISSURE, type)

	victim.add_filter(CRANIAL_FISSURE_FILTER_DISPLACEMENT, 2, displacement_map_filter(icon('icons/effects/cranial_fissure.dmi', "displacement"), size = 3))

	RegisterSignal(victim, COMSIG_MOB_SLIPPED, PROC_REF(on_owner_slipped))

/datum/wound/cranial_fissure/remove_wound(ignore_limb, replaced, destroying)
	REMOVE_TRAIT(limb, TRAIT_IMMUNE_TO_CRANIAL_FISSURE, type)
	if (!isnull(victim))
		REMOVE_TRAIT(victim, TRAIT_HAS_CRANIAL_FISSURE, type)
		victim.remove_filter(CRANIAL_FISSURE_FILTER_DISPLACEMENT)
		UnregisterSignal(victim, COMSIG_MOB_SLIPPED)
	return ..()

/datum/wound/cranial_fissure/proc/on_owner_slipped(mob/source)
	SIGNAL_HANDLER

	if (source.stat == DEAD)
		return

	var/obj/item/organ/brain/brain = source.get_organ_by_type(/obj/item/organ/brain)
	if (isnull(brain))
		return

	brain.Remove(source)

	var/turf/source_turf = get_turf(source)
	brain.forceMove(source_turf)
	brain.throw_at(get_step(source_turf, source.dir), 1, 1)

	source.visible_message(
		span_boldwarning("[source]的大脑直接从[source.p_their()]脑袋里流了出来！"),
		span_userdanger("你的大脑直接从你的脑袋里流了出来！"),
	)

/datum/wound/cranial_fissure/try_handling(mob/living/user)
	if (user.usable_hands <= 0 || user.combat_mode)
		return FALSE

	if(!isnull(user.hud_used?.screen_objects[HUD_MOB_ZONE_SELECTOR]) && (user.zone_selected != BODY_ZONE_HEAD && user.zone_selected != BODY_ZONE_PRECISE_EYES))
		return FALSE

	if (victim.body_position != LYING_DOWN)
		return FALSE

	var/obj/item/organ/eyes/eyes = victim.get_organ_by_type(/obj/item/organ/eyes)
	if (isnull(eyes))
		victim.balloon_alert(user, "没有眼睛可取！")
		return TRUE

	playsound(victim, 'sound/items/handling/surgery/organ2.ogg', 50, TRUE)
	victim.balloon_alert(user, "正在取出眼睛...")
	user.visible_message(
		span_boldwarning("[user]将手伸进[victim]的头骨里..."),
		ignored_mobs = user
	)
	victim.show_message(
		span_userdanger("[victim]开始挖出你的眼睛！"),
		MSG_VISUAL,
		span_userdanger("一条手臂伸进你的大脑，开始拉扯你的眼睛！"),
	)

	if (!do_after(user, 10 SECONDS, victim, extra_checks = CALLBACK(src, PROC_REF(still_has_eyes), eyes)))
		return TRUE

	eyes.Remove(victim)
	user.put_in_hands(eyes)

	log_combat(user, victim, "pulled out the eyes of")

	playsound(victim, 'sound/items/handling/surgery/organ1.ogg', 75, TRUE)
	user.visible_message(
		span_boldwarning("[user]扯出了[victim]的眼睛！"),
		span_boldwarning("你扯出了[victim]的眼睛！"),
		ignored_mobs = victim,
	)

	victim.show_message(
		span_userdanger("[user]扯出了你的眼睛！"),
		MSG_VISUAL,
		span_userdanger("你感到一条手臂从你脑袋里猛地抽出，同时感觉某个非常重要的东西不见了！"),
	)

	return TRUE

/datum/wound/cranial_fissure/proc/still_has_eyes(obj/item/organ/eyes/eyes)
	PRIVATE_PROC(TRUE)

	return victim?.get_organ_by_type(/obj/item/organ/eyes) == eyes

#undef CRANIAL_FISSURE_FILTER_DISPLACEMENT
