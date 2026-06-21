/datum/disease/adrenal_crisis
	form = "Condition"
	name = "肾上腺危象"
	max_stages = 2
	cure_text = "Trauma (Adrenaline / \"" + /datum/reagent/determination::name + "\")"
	cures = list(/datum/reagent/determination)
	cure_chance = 10
	agent = "Kronkaine Abuse"
	viable_mobtypes = list(/mob/living/carbon/human)
	spreading_modifier = 1
	desc = "A rare condition caused by continued abuse of Kronkaine. \
		If left untreated the subject will suffer from lethargy, dizziness and periodic loss of consciousness."
	severity = DISEASE_SEVERITY_MEDIUM
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	spread_text = "None"
	visibility_flags = HIDDEN_PANDEMIC
	bypasses_immunity = TRUE

/datum/disease/adrenal_crisis/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_warning(pick("你感到头晕。", "你感到昏昏欲睡。")))
		if(2)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.Unconscious(40)

			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.adjust_slurring(14 SECONDS)

			if(SPT_PROB(7, seconds_per_tick))
				affected_mob.set_dizzy_if_lower(20 SECONDS)

			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_warning(pick("你感到一阵疼痛顺着双腿袭来！", "你感觉随时都可能晕过去。", "你感到非常头晕。")))
