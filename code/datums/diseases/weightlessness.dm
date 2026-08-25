// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/disease/weightlessness
	name = "Localized Weightloss Malfunction"
	max_stages = 4
	spread_text = "Skin contact"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = /datum/reagent/liquid_dark_matter::name
	cures = list(/datum/reagent/liquid_dark_matter)
	agent = "Sub-quantum DNA Repulsion"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST|CURABLE
	spreading_modifier = 0.5
	cure_chance = 4
	desc = "This disease results in a low level rewrite of the patient's bioelectric signature, causing them to reject the phenomena of \"weight\". Ingestion of liquid dark matter tends to stabilize the field."
	severity = DISEASE_SEVERITY_MEDIUM
	infectable_biotypes = MOB_ORGANIC


/datum/disease/weightlessness/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.d853d86f3284c6f4", null)))
		if(2)
			if(SPT_PROB(3, seconds_per_tick) && !HAS_TRAIT_FROM(affected_mob, TRAIT_MOVE_FLOATING, NO_GRAVITY_TRAIT))
				to_chat(affected_mob, span_danger(LANG("datum.b0924cbb6054919c", null)))
				affected_mob.reagents.add_reagent(/datum/reagent/gravitum, 1)

		if(4)
			if(SPT_PROB(3, seconds_per_tick) && !affected_mob.has_quirk(/datum/quirk/spacer_born))
				to_chat(affected_mob, span_danger(LANG("datum.b5f96e4c890e883b", null)))
				affected_mob.adjust_confusion(3 SECONDS)
			if(SPT_PROB(8, seconds_per_tick) && !HAS_TRAIT_FROM(affected_mob, TRAIT_MOVE_FLOATING, NO_GRAVITY_TRAIT))
				to_chat(affected_mob, span_danger(LANG("datum.5392e908740dae71", null)))
				affected_mob.reagents.add_reagent(/datum/reagent/gravitum, 5)

/datum/disease/weightlessness/cure(add_resistance)
	. = ..()
	affected_mob.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 95, purge_ratio = 0.4)
	to_chat(affected_mob, span_danger(LANG("datum.2506899620f81029", null)))
