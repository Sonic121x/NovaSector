/*Self-Respiration
 * Slight increase to stealth
 * Greatly reduces resistance
 * Greatly reduces stage speed
 * Reduces transmission tremendously
 * Lethal level
 * Bonus: Gives the carrier TRAIT_NOBREATH, preventing suffocation and CPR
*/
/datum/symptom/oxygen
	name = "自体呼吸"
	desc = "该病毒能快速合成氧气，有效消除了呼吸需求。"
	stealth = 1
	resistance = -3
	stage_speed = -3
	transmittable = -4
	level = 6
	base_message_chance = 3
	symptom_delay_min = 1
	symptom_delay_max = 1
	required_organ = ORGAN_SLOT_LUNGS
	threshold_descs = list(
		"Resistance 8" = "Additionally regenerates lost blood."
	)
	var/regenerate_blood = FALSE

/datum/symptom/oxygen/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalResistance() >= 8) //blood regeneration
		regenerate_blood = TRUE

/datum/symptom/oxygen/Activate(datum/disease/advance/advanced_disease)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/infected_mob = advanced_disease.affected_mob
	switch(advanced_disease.stage)
		if(4, 5)
			infected_mob.losebreath = max(0, infected_mob.losebreath - 4)
			infected_mob.adjust_oxy_loss(-7)
			if(prob(base_message_chance))
				to_chat(infected_mob, span_notice("你意识到自己一直没在呼吸。"))
			if(regenerate_blood)
				infected_mob.adjust_blood_volume(1, maximum = BLOOD_VOLUME_NORMAL)
		else
			if(prob(base_message_chance))
				to_chat(infected_mob, span_notice("你的肺部感觉棒极了。"))
	return

/datum/symptom/oxygen/on_stage_change(datum/disease/advance/advanced_disease)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/infected_mob = advanced_disease.affected_mob
	if(advanced_disease.stage >= 4)
		ADD_TRAIT(infected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)
		if(advanced_disease.stage == 4)
			to_chat(infected_mob, span_notice("你不再感到需要呼吸了。"))
	else
		REMOVE_TRAIT(infected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)
		if(advanced_disease.stage_peaked && advanced_disease.stage == 3)
			to_chat(infected_mob, span_notice("你又感到需要呼吸了。"))
	return TRUE

/datum/symptom/oxygen/End(datum/disease/advance/advanced_disease)
	. = ..()
	if(!.)
		return
	REMOVE_TRAIT(advanced_disease.affected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)
