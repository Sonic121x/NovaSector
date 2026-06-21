/datum/mutation/adaptation
	name = "适应"
	desc = "一种奇怪的突变，使宿主免疫极端温度造成的伤害。不提供真空防护。"
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = span_notice("你的身体感觉正常了！")
	instability = NEGATIVE_STABILITY_MAJOR
	locked = TRUE // fake parent
	conflicts = list(/datum/mutation/adaptation)
	mutation_traits = list(TRAIT_WADDLING)
	/// Icon used for the adaptation overlay
	var/adapt_icon = "meow"

/* // NOVA EDIT REMOVAL START - Removes the visual indicators.
/datum/mutation/adaptation/New(datum/mutation/copymut)
	..()
	conflicts = typesof(/datum/mutation/adaptation)
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/mob/effects/genetics.dmi', adapt_icon, -MUTATIONS_LAYER))

/datum/mutation/adaptation/get_visual_indicator()
	return visual_indicators[type][1]

*/ // NOVA EDIT REMOVAL END

/datum/mutation/adaptation/cold
	name = "寒冷适应"
	desc = "一种奇特的突变，使宿主免疫低温环境造成的伤害，同时防止宿主在冰面上滑倒。"
	text_gain_indication = span_notice("你的身体感到一阵清爽的凉意。")
	instability = POSITIVE_INSTABILITY_MODERATE
	mutation_traits = list(TRAIT_RESISTCOLD, TRAIT_NO_SLIP_ICE)
	adapt_icon = "cold"
	locked = FALSE

/datum/mutation/adaptation/heat
	name = "高温适应"
	desc = "一种奇特的突变，使宿主免疫高温造成的伤害，包括被点燃，但火焰本身仍会烧毁衣物。同时似乎能让宿主抵抗灰烬风暴。"
	text_gain_indication = span_notice("你的身体感到一阵振奋的暖意。")
	instability = POSITIVE_INSTABILITY_MODERATE
	mutation_traits = list(TRAIT_RESISTHEAT, TRAIT_ASHSTORM_IMMUNE)
	adapt_icon = "fire"
	locked = FALSE

/datum/mutation/adaptation/thermal
	name = "温度适应"
	desc = "一种奇特的突变，使宿主免疫低温和高温环境造成的伤害。无法保护宿主免受高压或低压环境的影响。"
	difficulty = 32
	text_gain_indication = span_notice("你的身体感到舒适的室温。")
	instability = POSITIVE_INSTABILITY_MAJOR
	mutation_traits = list(TRAIT_RESISTHEAT, TRAIT_RESISTCOLD)
	adapt_icon = "thermal"
	locked = TRUE // recipe

/datum/mutation/adaptation/pressure
	name = "压力适应"
	desc = "一种奇特的突变，使宿主免疫高压和低压环境造成的伤害。无法保护宿主免受温度影响，包括太空的寒冷。"
	text_gain_indication = span_notice("你的身体感到惊人的加压感。")
	instability = POSITIVE_INSTABILITY_MODERATE
	adapt_icon = "pressure"
	mutation_traits = list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTHIGHPRESSURE)
	locked = FALSE
