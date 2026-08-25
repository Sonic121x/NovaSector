// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**Dizziness
 * Increases stealth
 * Lowers resistance
 * Decreases stage speed considerably
 * Slightly reduces transmissibility
 * Intense Level
 * Bonus: Shakes the affected mob's screen for short periods.
 */

/datum/symptom/dizzy // Not the egg
	name = "Dizziness"
	desc = "The virus causes inflammation of the vestibular system, leading to bouts of dizziness."
	illness = "Motion Sickness"
	stealth = 1
	resistance = 1
	stage_speed = 3
	transmittable = 3
	level = 2
	severity = 2
	base_message_chance = 50
	symptom_delay = 22.5
	symptom_cure = /datum/reagent/medicine/haloperidol
	cure_color = "yellow"
	threshold_descs = list(
		"Transmission 6" = "Also causes druggy vision.",
		"Stealth 4" = "The symptom remains hidden until active.",
	)
	var/suppress_warning = FALSE

/datum/symptom/dizzy/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalStealth() >= 4)
		suppress_warning = TRUE
	if(A.totalTransmittable() >= 6) //druggy
		power = 2

/datum/symptom/dizzy/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(M, span_warning("[pick("You feel dizzy.", "Your head spins.")]"))
		else
			to_chat(M, span_userdanger(LANG("datum.151eedce1312f276", null)))
			M.adjust_dizzy_up_to(40 SECONDS, 80 SECONDS)
			if(power >= 2)
				M.set_drugginess(60 SECONDS)
