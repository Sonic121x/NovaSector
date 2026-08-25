// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*Self-Respiration
 * Slight increase to stealth
 * Greatly reduces resistance
 * Greatly reduces stage speed
 * Reduces transmission tremendously
 * Lethal level
 * Bonus: Gives the carrier TRAIT_NOBREATH, preventing suffocation and CPR
*/
/datum/symptom/oxygen
	name = "Self-Respiration"
	desc = "The virus rapidly synthesizes oxygen, effectively removing the need for breathing."
	stealth = 1
	resistance = -3
	stage_speed = -3
	transmittable = -4
	level = 7
	base_message_chance = 3
	symptom_delay = 1
	delay_variation = 0
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
				to_chat(infected_mob, span_notice(LANG("datum.41c2a203dd100ceb", null)))
			if(regenerate_blood)
				infected_mob.adjust_blood_volume(1, maximum = BLOOD_VOLUME_NORMAL)
		else
			if(prob(base_message_chance))
				to_chat(infected_mob, span_notice(LANG("datum.314465a6297ee9a6", null)))
	return

/datum/symptom/oxygen/on_stage_change(datum/disease/advance/advanced_disease)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/infected_mob = advanced_disease.affected_mob
	if(advanced_disease.stage >= 4)
		ADD_TRAIT(infected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)
		if(advanced_disease.stage == 4)
			to_chat(infected_mob, span_notice(LANG("datum.16eefac6a6d8baf1", null)))
	else
		REMOVE_TRAIT(infected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)
		if(advanced_disease.stage_peaked && advanced_disease.stage == 3)
			to_chat(infected_mob, span_notice(LANG("datum.26289339c0094c08", null)))
	return TRUE

/datum/symptom/oxygen/End(datum/disease/advance/advanced_disease)
	. = ..()
	if(!.)
		return
	REMOVE_TRAIT(advanced_disease.affected_mob, TRAIT_NOBREATH, DISEASE_TRAIT)
