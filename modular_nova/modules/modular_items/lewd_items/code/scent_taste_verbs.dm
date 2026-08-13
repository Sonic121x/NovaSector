GAME_VERB(/mob/living/carbon/human, lick, "舔", "IC")
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_VIEW, /mob/living/carbon/human)
	if(!istype(target) || !(target in get_adjacent_humans()))
		return FALSE
	if(!get_organ_slot(ORGAN_SLOT_TONGUE))
		to_chat(src, span_warning(LANG("mob.7f0789de", null)))
		return FALSE
	if(!can_use_erp_flavor_verb(target, "doesn't feel like being touched right now."))
		return FALSE

	var/taste = target.dna.features[ERP_FLAVOR_DNA_TASTE]
	if(!taste)
		to_chat(src, span_warning(LANG("mob.77fc7cc5", list(target))))
		return FALSE

	to_chat(src, span_notice(LANG("mob.bed05d46", list(target, taste))))
	to_chat(target, span_notice(LANG("mob.c262fc2b", list(src))))
	return TRUE

GAME_VERB(/mob/living/carbon/human, smell, "闻", "IC")
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_VIEW, /mob/living/carbon/human)
	if(!istype(target) || !(target in get_adjacent_humans()))
		return FALSE
	if(!can_use_erp_flavor_verb(target, "doesn't feel like being approached that close right now."))
		return FALSE

	var/scent = target.dna.features[ERP_FLAVOR_DNA_SCENT]
	if(!scent)
		to_chat(src, span_warning(LANG("mob.2a8abd41", list(target))))
		return FALSE

	to_chat(src, span_notice(LANG("mob.28205dc0", list(target, scent))))
	return TRUE

/mob/living/carbon/human/proc/can_see_erp_flavor(mob/living/carbon/human/target)
	return client?.prefs?.read_preference(/datum/preference/toggle/erp) && target?.client?.prefs?.read_preference(/datum/preference/toggle/erp)

/mob/living/carbon/human/proc/can_use_erp_flavor_verb(mob/living/carbon/human/target, warning_message)
	if(!can_see_erp_flavor(target))
		to_chat(src, span_warning(LANG("mob.83ecc146", null)))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_QUICKREFLEXES))
		to_chat(src, span_warning("[target] [warning_message]"))
		return FALSE

	return TRUE

/// Returns adjacent humans for the Lick/Smell IC verb target selector.
/mob/living/proc/get_adjacent_humans()
	var/list/nearby_humans = list()
	for(var/mob/living/carbon/human/nearby_human in range(1, src))
		if(nearby_human == src)
			continue
		nearby_humans += nearby_human
	return nearby_humans
