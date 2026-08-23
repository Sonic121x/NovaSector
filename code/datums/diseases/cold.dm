// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/disease/cold
	name = "The Cold"
	desc = "A common, mildly annoying contagion. If left untreated the subject will contract the flu."
	max_stages = 3
	cure_text = /datum/reagent/medicine/spaceacillin::name + " or rest"
	cures = list(/datum/reagent/medicine/spaceacillin)
	agent = "XY-rhinovirus"
	viable_mobtypes = list(/mob/living/carbon/human)
	spreading_modifier = 0.5
	spread_text = "Airborne"
	severity = DISEASE_SEVERITY_NONTHREAT
	required_organ = ORGAN_SLOT_LUNGS

/datum/disease/cold/cure(add_resistance)
	// buy one, get one free
	if(add_resistance && affected_mob)
		LAZYOR(affected_mob.disease_resistances, "[/datum/disease/cold9]")
	return ..()

/datum/disease/cold/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("sneeze")
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(0.5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.e46412a11b6e5de4", null)))
			if(SPT_PROB(0.5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.58ac69d53cba3d97", null)))
			if((affected_mob.body_position == LYING_DOWN && SPT_PROB(23, seconds_per_tick)) || SPT_PROB(0.025, seconds_per_tick))  //changed FROM prob(10) until sleeping is fixed // Has sleeping been fixed yet?
				to_chat(affected_mob, span_notice(LANG("datum.9b8f156c70e8aa99", null)))
				cure()
				return FALSE
		if(3)
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("sneeze")
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.emote("cough")
			if(SPT_PROB(0.5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.e46412a11b6e5de4", null)))
			if(SPT_PROB(0.5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.58ac69d53cba3d97", null)))
			if(SPT_PROB(0.25, seconds_per_tick) && !LAZYFIND(affected_mob.disease_resistances, /datum/disease/flu))
				var/datum/disease/Flu = new /datum/disease/flu()
				affected_mob.ForceContractDisease(Flu, FALSE, TRUE)
				cure()
				return FALSE
			if((affected_mob.body_position == LYING_DOWN && SPT_PROB(12.5, seconds_per_tick)) || SPT_PROB(0.005, seconds_per_tick))  //changed FROM prob(5) until sleeping is fixed
				to_chat(affected_mob, span_notice(LANG("datum.9b8f156c70e8aa99", null)))
				cure()
				return FALSE
