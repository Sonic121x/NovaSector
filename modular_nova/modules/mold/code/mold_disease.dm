/datum/disease/cryptococcus
	name = "隐球菌性脑膜炎"
	max_stages = 4
	stage_prob = 1.75
	spread_text = "Airborne"
	spreading_modifier = 0.75
	cure_text = "Haloperidol"
	cures = list(/datum/reagent/medicine/haloperidol)
	agent = "Cryptococcus gattii fungus"
	viable_mobtypes = list(/mob/living/carbon/human)
	cure_chance = 25
	desc = "一种真菌感染，攻击患者的肌肉和大脑，试图控制他们。会导致发烧、头痛、肌肉痉挛和疲劳。"
	severity = DISEASE_SEVERITY_BIOHAZARD

/datum/disease/cryptococcus/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(1)
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_danger("你的大脑感觉迷迷糊糊的。这不对劲。"))
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger("你的头好痛。天花板瓷砖一直是那样移动的吗？"))
		if(2)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.emote("twitch")
				to_chat(affected_mob, span_danger("你不自觉地抽搐了一下。这不对劲。"))
			if(SPT_PROB(2, seconds_per_tick))
				if(!HAS_TRAIT(affected_mob, TRAIT_ANOSMIA))
					to_chat(affected_mob, span_danger("你嗅了嗅，闻到了绿色粘液的味道。绿色有气味吗？"))
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_danger("你的头好痛。天花板瓷砖一直是那样移动的吗？"))
		if(3)
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("你看到所有东西都变成了四个！"))
				affected_mob.set_dizzy_if_lower(10 SECONDS)
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("你突然感到精疲力尽。你的动作开始变得僵硬。肯定有什么地方严重不对劲……"))
				affected_mob.adjust_stamina_loss(30, updating_stamina = FALSE)
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("你感觉很热。非常热。你的肌肉暂时感觉还好，但疼痛又回来了。"))
				affected_mob.adjust_bodytemperature(20)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("你感到空气痛苦地从肺部逸出。你并非有意呼气，它们似乎自己在痉挛。"))
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
				affected_mob.visible_message(span_warning("[affected_mob] 昏倒了！"), span_userdanger("你放弃了抵抗，感到平静……"))
				affected_mob.AdjustSleeping(10 SECONDS)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_userdanger("你感到思绪放松，神游天外！"))
				affected_mob.adjust_confusion(10 SECONDS)
				affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 10)
			if(SPT_PROB(10, seconds_per_tick))
				to_chat(affected_mob, span_danger("[pick("You feel uncomfortably hot...", "You feel like unzipping your jumpsuit", "You feel like taking off some clothes...")]"))
				affected_mob.adjust_bodytemperature(30)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.vomit(vomit_flags = VOMIT_CATEGORY_DEFAULT, lost_nutrition = 20)

/datum/reagent/cryptococcus_spores
	name = "新型隐球菌微生物"
	description = "活性真菌孢子。"
	color = "#92D17D"
	chemical_flags = NONE
	taste_description = "slime"
	penetrates_skin = NONE

/datum/reagent/cryptococcus_spores/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if((methods & (PATCH|INGEST|INJECT)) || ((methods & VAPOR) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.ForceContractDisease(new /datum/disease/cryptococcus(), FALSE, TRUE)
