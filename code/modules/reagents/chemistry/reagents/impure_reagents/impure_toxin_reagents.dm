//Reagents produced by metabolising/reacting fermichems suboptimally these specifically are for toxins
//Inverse = Splitting
//Invert = Whole conversion
//Failed = End reaction below purity_min

////////////////////TOXINS///////////////////////////

//Lipolicide - Impure Version
/datum/reagent/impurity/ipecacide
	name = "Ipecacide-恶呕素"
	description = "一种极其恶心的物质，会诱发呕吐。它是脂溶灭反应不纯时的产物。"
	ph = 7
	liver_damage = 0

/datum/reagent/impurity/ipecacide/on_mob_add(mob/living/carbon/owner)
	if(owner.disgust >= DISGUST_LEVEL_GROSS)
		return ..()
	owner.adjust_disgust(50)
	..()

//Formaldehyde - Impure Version
/datum/reagent/impurity/methanol
	name = "Methanol-甲醇"
	description = "一种轻盈、无色、带有特殊气味的液体。摄入可导致失明。它是生物体处理不纯甲醛时的副产品。"
	color = "#aae7e4"
	ph = 7
	liver_damage = 0

/datum/reagent/impurity/methanol/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/obj/item/organ/eyes/eyes = affected_mob.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes?.apply_organ_damage(0.25 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags))
		return UPDATE_MOB_HEALTH

//Chloral Hydrate - Impure Version
/datum/reagent/impurity/chloralax
	name = "Chloralax-三氯乙醛"
	description = "一种油状、无色、略有毒性的液体。当不纯的水合氯醛在生物体内分解时产生。"
	color = "#387774"
	ph = 7
	liver_damage = 0

/datum/reagent/impurity/chloralax/on_mob_life(mob/living/carbon/owner, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(owner.adjust_tox_loss(0.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

//Mindbreaker Toxin - Impure Version
/datum/reagent/impurity/rosenol
	name = "Rosenol-高雅油"
	description = "一种奇怪的蓝色液体，产生于不纯的致幻毒素反应过程中。历史上曾被滥用于写诗。"
	color = "#0963ad"
	ph = 7
	liver_damage = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/impurity/rosenol/on_mob_life(mob/living/carbon/owner, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/obj/item/organ/tongue/tongue = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	if(SPT_PROB(4.0, seconds_per_tick))
		owner.manual_emote("clicks with [owner.p_their()] tongue.")
		owner.say("Noice.", forced = /datum/reagent/impurity/rosenol)
	if(SPT_PROB(2.0, seconds_per_tick))
		owner.say(pick("Ah! That was a mistake!", "Horrible.", "Watch out everybody, the potato is really hot.", "When I was six I ate a bag of plums.", "And if there is one thing I can't stand it's tomatoes.", "And if there is one thing I love it's tomatoes.", "We had a captain who was so strict, you weren't allowed to breathe in their station.", "The unrobust ones just used to keel over and die, you'd hear them going down behind you."), forced = /datum/reagent/impurity/rosenol)
