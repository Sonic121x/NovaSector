/datum/reagent/medicine/lidocaine
	name = "利多卡因"
	description = "一种常用于手术的麻醉剂，代谢缓慢。"
	color = "#6dbdbd" // 109, 189, 189
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	overdose_threshold = 20
	ph = 6.09
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem_val = 0.55
	inverse_chem = /datum/reagent/inverse/lidocaine
	metabolized_traits = list(TRAIT_ANALGESIA)

/datum/reagent/medicine/lidocaine/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 3.75 * seconds_per_tick * metabolization_ratio, 80, required_organ_flag = affected_organ_flags)

//Inverse Medicines//

/datum/reagent/inverse/lidocaine
	name = "利多痛因"
	description = "一种常用于……当混蛋的致痛剂，代谢速度比利多卡因快。"
	color = "#85111f" // 133, 17, 31
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	ph = 6.09
	tox_damage = 0

/datum/reagent/inverse/lidocaine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	to_chat(affected_mob, span_userdanger("你的身体因难以想象的疼痛而剧痛！"))
	affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 3.75 * seconds_per_tick * metabolization_ratio, 85, required_organ_flag = affected_organ_flags)
	if(affected_mob.adjust_stamina_loss(6.25 * seconds_per_tick * metabolization_ratio, updating_stamina = FALSE))
		. = UPDATE_MOB_HEALTH
	if(prob(30))
		INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob, emote), "scream")

//Medigun Clotting Medicine
/datum/reagent/medicine/coagulant/fabricated
	name = "人造凝血剂"
	description = "一种由医疗枪合成的凝血剂。"
	color = "#ff7373" //255, 155. 155
	clot_rate = 0.15 //Half as strong as standard coagulant
	passive_bleed_modifier = 0.5 // around 2/3 the bleeding reduction
