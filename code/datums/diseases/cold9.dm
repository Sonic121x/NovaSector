// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/disease/cold9
	name = "The Cold"
	max_stages = 3
	spread_text = "Skin contact"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = /datum/reagent/medicine/spaceacillin::name + " or common Cold antibodies"
	cures = list(/datum/reagent/medicine/spaceacillin)
	agent = "ICE9-rhinovirus"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "An adaption of the common cold, slightly more dangerous in nature. \
		If left untreated the subject will slow, as if partly frozen."
	severity = DISEASE_SEVERITY_HARMFUL
	required_organ = ORGAN_SLOT_LUNGS

/datum/disease/cold9/cure(add_resistance)
	// buy one, get one free
	if(add_resistance && affected_mob)
		LAZYOR(affected_mob.disease_resistances, "[/datum/disease/cold]")
	return ..()

/datum/disease/cold9/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			affected_mob.adjust_bodytemperature(-5 * seconds_per_tick)
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("sneeze")
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(0.5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.e46412a11b6e5de4", null)))
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.9b9fecb32a68a727", null)))
			if(SPT_PROB(0.05, seconds_per_tick))
				to_chat(affected_mob, span_notice(LANG("datum.9b8f156c70e8aa99", null)))
				cure()
				return FALSE
		if(3)
			affected_mob.adjust_bodytemperature(-10 * seconds_per_tick)
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("sneeze")
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(0.5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.e46412a11b6e5de4", null)))
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.9b9fecb32a68a727", null)))
