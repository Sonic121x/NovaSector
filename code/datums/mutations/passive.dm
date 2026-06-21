/datum/mutation/biotechcompat
	name = "生物技术兼容性"
	desc = "受试者与生物技术（如技能芯片）的兼容性更高。"
	quality = POSITIVE
	instability = POSITIVE_INSTABILITY_MINI

/datum/mutation/biotechcompat/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	owner.adjust_skillchip_complexity_modifier(1)

/datum/mutation/biotechcompat/on_losing(mob/living/carbon/human/owner)
	owner.adjust_skillchip_complexity_modifier(-1)
	return ..()

/datum/mutation/clever
	name = "聪慧"
	desc = "让受试者感觉稍微聪明了一点。对智力水平较低的个体效果最为显著。"
	quality = POSITIVE
	instability = POSITIVE_INSTABILITY_MODERATE // literally makes you on par with station equipment
	text_gain_indication = span_danger("你感觉稍微聪明了一点。")
	text_lose_indication = span_danger("你的思维感觉有点模糊。")

/datum/mutation/clever/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	owner.add_traits(list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LITERATE), GENETIC_MUTATION)

/datum/mutation/clever/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.remove_traits(list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LITERATE), GENETIC_MUTATION)
