/datum/quirk/bouncy
	name = "Bouncy!"
	desc = "你的步伐带着摇摆感！"
	gain_text = span_notice("你正在蹦蹦跳跳！")
	lose_text = span_notice("你步伐中的活力消失了……")
	medical_record_text = "Patient walks irregularly."
	value = 0
	icon = FA_ICON_TURN_UP

/datum/quirk/bouncy/add(client/client_source)
	quirk_holder.AddElementTrait(TRAIT_WADDLING, QUIRK_TRAIT, /datum/element/waddling)

/datum/quirk/bouncy/remove()
	REMOVE_TRAIT(quirk_holder, TRAIT_WADDLING, QUIRK_TRAIT)
