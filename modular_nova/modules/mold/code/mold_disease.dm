/datum/disease/cryptococcus
	name = "Cryptococcal meningitis"
	max_stages = 4
	stage_prob = 1.75
	spread_text = "Airborne"
	spreading_modifier = 0.75
	cure_text = "Haloperidol"
	cures = list(/datum/reagent/medicine/haloperidol)
	agent = "Cryptococcus gattii fungus"
	viable_mobtypes = list(/mob/living/carbon/human)
	cure_chance = 25
	desc = "Fungal infection that attacks patient's muscles and brain in an attempt to hijack them. Causes fever, headaches, muscle spasms, and fatigue."
	severity = DISEASE_SEVERITY_BIOHAZARD

/datum/disease/cryptococcus/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.5f62e2e3f1597cfa", null)))
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.c22077261bbea27f", null)))
		if(2)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.emote("twitch")
				to_chat(affected_mob, span_danger(LANG("datum.5d60f5c0a54b03b4", null)))
			if(SPT_PROB(2, seconds_per_tick))
				if(!HAS_TRAIT(affected_mob, TRAIT_ANOSMIA))
					to_chat(affected_mob, span_danger(LANG("datum.40eb87515027ba80", null)))
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.c22077261bbea27f", null)))
		if(3)
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_userdanger(LANG("datum.7685f01dd202c1e3", null)))
				affected_mob.set_dizzy_if_lower(10 SECONDS)
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_userdanger(LANG("datum.6a85bce40b176caf", null)))
				affected_mob.adjust_stamina_loss(30, updating_stamina = FALSE)
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_userdanger(LANG("datum.79f1b5cbb5a1add4", null)))
				affected_mob.adjust_bodytemperature(20)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_userdanger(LANG("datum.351181768d69f800", null)))
				affected_mob.adjust_oxy_loss(25, updating_health = FALSE)
				affected_mob.emote("gasp")
		if(4)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("[pick("Your muscles seize!", "You collapse!")]"))
				affected_mob.adjust_stamina_loss(50, updating_stamina = FALSE)
				affected_mob.Paralyze(40, FALSE)
				affected_mob.adjust_brute_loss(5) //It's damaging the muscles
			if(SPT_PROB(2, seconds_per_tick))
				affected_mob.adjust_stamina_loss(100, updating_stamina = FALSE)
				affected_mob.visible_message(span_warning(LANG("datum.3f2076ad78819940", list(affected_mob))), span_userdanger(LANG("datum.f1a296daa43afb19", null)))
				affected_mob.AdjustSleeping(10 SECONDS)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_userdanger(LANG("datum.8b1cef57eb3af0d1", null)))
				affected_mob.adjust_confusion(10 SECONDS)
				affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 10)
			if(SPT_PROB(10, seconds_per_tick))
				to_chat(affected_mob, span_danger("[pick("You feel uncomfortably hot...", "You feel like unzipping your jumpsuit", "You feel like taking off some clothes...")]"))
				affected_mob.adjust_bodytemperature(30)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.vomit(vomit_flags = VOMIT_CATEGORY_DEFAULT, lost_nutrition = 20)

/datum/reagent/cryptococcus_spores
	name = "Cryptococcus gattii microbes"
	description = "Active fungal spores."
	color = "#92D17D"
	chemical_flags = NONE
	taste_description = "slime"
	penetrates_skin = NONE

/datum/reagent/cryptococcus_spores/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.ForceContractDisease(new /datum/disease/cryptococcus(), FALSE, TRUE)
