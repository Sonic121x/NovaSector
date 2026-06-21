/datum/action/cooldown/spell/conjure_item/snowball
	name = "雪球"
	desc = "集中冰冻动能以制造雪球，这种雪球可用于向他人投掷。"
	button_icon = 'icons/obj/toys/toy.dmi'
	button_icon_state = "snowball"

	spell_requirements = NONE
	antimagic_flags = NONE
	cooldown_time = 1.5 SECONDS
	item_type = /obj/item/toy/snowball
	requires_hands = TRUE
