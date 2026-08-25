// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*Eternal Youth
 * Greatly increases stealth
 * Tremendous increase to resistance
 * Tremendous increase to stage speed
 * Tremendous reduction to transmissibility
 * Critical level
 * Bonus: Can be used to buff your virus
*/

/datum/symptom/youth
	name = "Eternal Youth"
	desc = "The virus becomes symbiotically connected to the cells in the host's body, preventing and reversing aging. \
	The virus, in turn, becomes more resistant, spreads faster, and is harder to spot, although it doesn't thrive as well without a host."
	stealth = 3
	resistance = 4
	stage_speed = 4
	transmittable = -4
	level = 6
	base_message_chance = 100
	symptom_delay = 37.5
	symptom_cure = null
	immunity_proof = TRUE

/datum/symptom/youth/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/M = A.affected_mob
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		switch(A.stage)
			if(1)
				if(H.age > 41)
					H.age = 41
					to_chat(H, span_notice(LANG("datum.0ead50b71f1bf1c0", null)))
			if(2)
				if(H.age > 36)
					H.age = 36
					to_chat(H, span_notice(LANG("datum.028e43291d5d52d5", null)))
			if(3)
				if(H.age > 31)
					H.age = 31
					to_chat(H, span_notice(LANG("datum.b616c5c7cde2cfd4", null)))
			if(4)
				if(H.age > 26)
					H.age = 26
					to_chat(H, span_notice(LANG("datum.b14223fd96c48bbe", null)))
			if(5)
				if(H.age > 21)
					H.age = 21
					to_chat(H, span_notice(LANG("datum.e1dafb65419f272f", null)))
