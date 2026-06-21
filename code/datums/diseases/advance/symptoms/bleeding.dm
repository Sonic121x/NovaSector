/*Anticoagulant
 * Increases stealth
 * No change to resistance
 * Reduces to stage speed
 * Reduces transmissibility
 * Fatal Level
 * Bonus: Worsens blood loss
*/

/datum/symptom/bleeding
	name = "抗凝血剂"
	desc = "该病毒阻止身体凝血。除非宿主正在流血，否则难以察觉。"
	stealth = 1
	resistance = -1
	stage_speed = -3
	transmittable = 0
	severity = 3
	level = 7
	symptom_cure = /datum/reagent/acetaldehyde
	cure_color = "orange"
	threshold_descs = list(
		"Stage Speed 9" = "The host becomes more vulnerable to bleeding wounds.",
		"Stealth 3" = "The symptom remains hidden even while active."
	)
	var/easybleed = FALSE
	var/hidden = FALSE

/datum/symptom/bleeding/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalStageSpeed() >= 9)
		easybleed = TRUE
	if(A.totalStealth() >= 3)
		hidden = TRUE

/datum/symptom/bleeding/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/carbon_host = A.affected_mob
	for(var/datum/wound/possible_bleeding_wound as anything in carbon_host.all_wounds)
		if(possible_bleeding_wound.blood_flow && !hidden)
			if(4 > A.stage >= 2)
				to_chat(carbon_host, span_warning("你流血的伤口开始发痒。"))
			if(A.stage >= 4)
				to_chat(carbon_host, span_warning("随着更多血液离开你的身体，你流血的伤口痒得发狂。"))
			return

/datum/symptom/bleeding/on_stage_change(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/carbon_host = A.affected_mob
	if(A.stage >= 4)
		ADD_TRAIT(carbon_host, TRAIT_BLOOD_FOUNTAIN, DISEASE_TRAIT)
		if(easybleed)
			ADD_TRAIT(carbon_host, TRAIT_EASYBLEED, DISEASE_TRAIT)
		return
	REMOVE_TRAIT(carbon_host, TRAIT_BLOOD_FOUNTAIN, DISEASE_TRAIT)
	REMOVE_TRAIT(carbon_host, TRAIT_EASYBLEED, DISEASE_TRAIT)


/datum/symptom/bleeding/End(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/carbon_host = A.affected_mob
	REMOVE_TRAIT(carbon_host, TRAIT_BLOOD_FOUNTAIN, DISEASE_TRAIT)
	REMOVE_TRAIT(carbon_host, TRAIT_EASYBLEED, DISEASE_TRAIT)
