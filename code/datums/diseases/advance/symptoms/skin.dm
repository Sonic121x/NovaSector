// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*Polyvitiligo
 * Slight reduction to stealth
 * Greatly increases resistance
 * Slightly increases stage speed
 * Increases transmissibility
 * Critical level
 * Bonus: Makes the mob gain a random crayon powder colorful reagent.
*/
/datum/symptom/polyvitiligo
	name = "Polyvitiligo"
	desc = "The virus replaces the melanin in the skin with reactive pigment."
	illness = "Chroma Imbalance"
	stealth = -1
	resistance = 3
	stage_speed = 1
	transmittable = 2
	level = 5
	severity = 1
	symptom_delay = 10.5
	symptom_cure = /datum/reagent/water/salt

/datum/symptom/polyvitiligo/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(5)
			var/static/list/banned_reagents = list(/datum/reagent/colorful_reagent/powder/invisible, /datum/reagent/colorful_reagent/powder/white)
			var/color = pick(subtypesof(/datum/reagent/colorful_reagent/powder) - banned_reagents)
			if(M.reagents.total_volume <= (M.reagents.maximum_volume/10)) // no flooding humans with 1000 units of colorful reagent
				M.reagents.add_reagent(color, 5)
		else
			if (prob(50)) // spam
				M.visible_message(span_warning(LANG("datum.0128ec25d18aa8e6", list(M))), span_notice(LANG("datum.d0ddca8746f3b8b1", null)))
