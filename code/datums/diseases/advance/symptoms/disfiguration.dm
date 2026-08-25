// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**Disfiguration
 * Increases stealth
 * No change to resistance
 * Increases stage speed
 * Slightly increases transmissibility
 * Critical level
 * Bonus: Adds disfiguration trait making the mob appear as "Unknown" to others.
 */
/datum/symptom/disfiguration
	name = "Disfiguration"
	desc = "The virus liquefies facial muscles, disfiguring the host."
	illness = "Broken Face"
	stealth = 2
	resistance = 0
	stage_speed = 3
	transmittable = 1
	level = 5
	severity = 1
	symptom_delay = 50
	symptom_cure = /datum/reagent/consumable/milk

/datum/symptom/disfiguration/Activate(datum/disease/advance/disease)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/victim = disease.affected_mob
	var/obj/item/bodypart/head = victim.get_bodypart(BODY_ZONE_HEAD)
	if(!head || HAS_TRAIT_FROM(head, TRAIT_DISFIGURED, DISEASE_TRAIT))
		return

	switch(disease.stage)
		if(5)
			ADD_TRAIT(head, TRAIT_DISFIGURED, DISEASE_TRAIT)
			victim.visible_message(span_warning(LANG("datum.1fe1ec9ba8cd46c9", list(victim))), span_notice(LANG("datum.ec546e6a7d99f589", null)))
		else
			victim.visible_message(span_warning(LANG("datum.988e04d6021c632f", list(victim))), span_notice(LANG("datum.098e19b164ef3c8e", null)))


/datum/symptom/disfiguration/End(datum/disease/advance/disease)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/victim = disease.affected_mob
	var/obj/item/bodypart/head = victim?.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		REMOVE_TRAIT(head, TRAIT_DISFIGURED, DISEASE_TRAIT)
