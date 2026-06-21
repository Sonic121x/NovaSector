/datum/disease/tuberculosis
	form = "Fungus"
	name = "Fungal Tuberculosis"
	max_stages = 5
	spread_text = "Airborne"
	cure_text = /datum/reagent/medicine/spaceacillin::name + " & " + /datum/reagent/medicine/c2/convermol::name
	cures = list(/datum/reagent/medicine/spaceacillin, /datum/reagent/medicine/c2/convermol)
	agent = "Fungal Tubercle Bacillus Cosmosis"
	viable_mobtypes = list(/mob/living/carbon/human)
	cure_chance = 2.5 //like hell are you getting out of hell
	desc = "A rare and highly transmissible virulent fungus. \
		Few samples exist, rumoured to be carefully grown and cultured by clandestine bio-weapon specialists. \
		Causes fever, blood vomiting, lung damage, weight loss, fatigue, and eventually death."
	required_organ = ORGAN_SLOT_LUNGS
	severity = DISEASE_SEVERITY_BIOHAZARD
	bypasses_immunity = TRUE // TB primarily impacts the lungs; it's also bacterial or fungal in nature; viral immunity should do nothing.

/datum/disease/tuberculosis/stage_act(seconds_per_tick) //it begins
	. = ..()
	if(!.)
		return

	if(SPT_PROB(stage * 2, seconds_per_tick))
		affected_mob.emote("cough")
		to_chat(affected_mob, span_danger("你的胸口疼。"))

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("你的胃剧烈地咕咕作响！"))
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("你感到一阵冷汗冒出。"))
		if(4)
			var/need_mob_update = FALSE
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("你看到所有东西都变成了四个！"))
				affected_mob.set_dizzy_if_lower(10 SECONDS)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("你感到下胸部传来一阵剧痛！"))
				need_mob_update += affected_mob.adjust_oxy_loss(5, updating_health = FALSE)
				affected_mob.emote("gasp")
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger("你感到空气痛苦地从肺部逸出。"))
				need_mob_update += affected_mob.adjust_oxy_loss(25, updating_health = FALSE)
				affected_mob.emote("gasp")
			if(need_mob_update)
				affected_mob.updatehealth()
		if(5)
			var/need_mob_update = FALSE
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("[pick("You feel your heart slowing...", "You relax and slow your heartbeat.")]"))
				need_mob_update += affected_mob.adjust_stamina_loss(70, updating_stamina = FALSE)
			if(SPT_PROB(5, seconds_per_tick))
				need_mob_update += affected_mob.adjust_stamina_loss(100, updating_stamina = FALSE)
				affected_mob.visible_message(span_warning("[affected_mob] 昏倒了！"), span_userdanger("你放弃抵抗，感到平静安宁..."))
				affected_mob.AdjustSleeping(10 SECONDS)
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("你感到思绪放松，神游天外！"))
				affected_mob.adjust_confusion_up_to(8 SECONDS, 100 SECONDS)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 20)
			if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(affected_mob, span_warning("<i>[pick("Your stomach silently rumbles...", "Your stomach seizes up and falls limp, muscles dead and lifeless.", "You could eat a crayon")]</i>"))
				affected_mob.overeatduration = max(affected_mob.overeatduration - (200 SECONDS), 0)
				affected_mob.adjust_nutrition(-100)
			if(SPT_PROB(7.5, seconds_per_tick))
				if(ishuman(affected_mob))
					var/mob/living/carbon/human/human_victim = affected_mob
					to_chat(human_victim, span_danger("[human_victim.w_uniform? pick("You feel uncomfortably hot...", "You feel like unzipping your jumpsuit...", "You feel like taking off some clothes...") : "You feel uncomfortably hot..."]"))
				else
					to_chat(affected_mob, span_danger("你感到一阵难耐的燥热..."))
				affected_mob.adjust_bodytemperature(40)
			if(need_mob_update)
				affected_mob.updatehealth()
