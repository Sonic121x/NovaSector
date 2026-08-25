// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Caused by dirty food. Makes you vomit stars.
/datum/disease/nebula_nausea
	name = "Nebula Nausea"
	desc = "You can't contain the colorful beauty of the cosmos inside."
	form = "Condition"
	agent = "Stars"
	cure_text = /datum/reagent/space_cleaner::name
	spread_text = "None"
	cures = list(/datum/reagent/space_cleaner)
	viable_mobtypes = list(/mob/living/carbon/human)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	severity = DISEASE_SEVERITY_MEDIUM
	required_organ = ORGAN_SLOT_STOMACH
	max_stages = 5

/datum/disease/advance/nebula_nausea/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick) && !IS_UNCONSCIOUS_OR_CRIT(affected_mob))
				to_chat(affected_mob, span_warning(LANG("datum.70ef430126e2236d", null)))
		if(3)
			if(SPT_PROB(1, seconds_per_tick) && !IS_UNCONSCIOUS_OR_CRIT(affected_mob))
				to_chat(affected_mob, span_warning(LANG("datum.9b18ac77280439d8", null)))
		if(4)
			if(SPT_PROB(1, seconds_per_tick) && !IS_UNCONSCIOUS_OR_CRIT(affected_mob))
				to_chat(affected_mob, span_warning(LANG("datum.424bbd676ca9dc0c", null)))
		if(5)
			if(SPT_PROB(1, seconds_per_tick) && !IS_UNCONSCIOUS_OR_CRIT(affected_mob))
				to_chat(affected_mob, span_warning(LANG("datum.439ead151f33cb60", null)))
			else
				affected_mob.vomit(vomit_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_HARM), vomit_type = /obj/effect/decal/cleanable/vomit/nebula, lost_nutrition = 10, distance = 2)
