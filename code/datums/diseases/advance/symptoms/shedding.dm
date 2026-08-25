// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*Alopecia
 * No change to stealth
 * Slight increase to resistance
 * Increases stage speed
 * Increases transmissibility
 * Near critcal level
 * Bonus: Makes the mob lose hair.
*/
/datum/symptom/shedding
	name = "Alopecia"
	desc = "The virus causes rapid shedding of head and body hair."
	illness = "Thin Skinned"
	stealth = 0
	resistance = 1
	stage_speed = 2
	transmittable = 2
	level = 5
	severity = 1
	symptom_cure = /datum/reagent/barbers_aid
	cure_color = "yellow"
	base_message_chance = 50
	symptom_delay = 67.5

/datum/symptom/shedding/Activate(datum/disease/advance/disease)
	. = ..()
	if(!.)
		return

	var/mob/living/affected_living = disease.affected_mob
	if(prob(base_message_chance))
		to_chat(affected_living, span_warning("[pick("Your scalp itches.", "Your skin feels flaky.")]"))
	if(ishuman(affected_living))
		var/mob/living/carbon/human/affected_human = affected_living
		switch(disease.stage)
			if(3, 4)
				if((affected_human.hairstyle == "Bald") && (affected_human.hairstyle != "Balding Hair"))
					to_chat(affected_human, span_warning(LANG("datum.cc5e9c19740b0d58", null)))
					addtimer(CALLBACK(src, PROC_REF(baldify), affected_human, FALSE), 5 SECONDS)
			if(5)
				if((affected_human.facial_hairstyle != "Shaved") || (affected_human.hairstyle != "Bald"))
					if(affected_human.hairstyle == "Balding Hair")
						to_chat(affected_human, span_warning(LANG("datum.1fbafdb492418ddf", null)))
					else
						to_chat(affected_human, span_warning(LANG("datum.cc5e9c19740b0d58", null)))
					addtimer(CALLBACK(src, PROC_REF(baldify), affected_human, TRUE), 3 SECONDS)

/datum/symptom/shedding/proc/baldify(mob/living/carbon/human/baldie, fully_bald)
	if(fully_bald)
		baldie.set_facial_hairstyle("Shaved", update = FALSE)
		baldie.set_hairstyle("Bald") //this will call update_body_parts()
	else
		baldie.set_hairstyle("Balding Hair")
