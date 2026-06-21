/datum/action/cooldown/spell/conjure/soulstone
	name = "召唤灵魂石"
	desc = "This spell reaches into Nar'Sie's realm, summoning one of the legendary fragments across time and space."
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "summonsoulstone"

	school = SCHOOL_CONJURATION
	cooldown_time = 4 MINUTES
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	summon_radius = 0
	summon_type = list(/obj/item/soulstone)

/datum/action/cooldown/spell/conjure/soulstone/cult
	name = "制作纳里西亚灵魂石"
	cooldown_time = 6 MINUTES

/datum/action/cooldown/spell/conjure/soulstone/noncult
	name = "创建灵魂石"
	summon_type = list(/obj/item/soulstone/anybody)

/datum/action/cooldown/spell/conjure/soulstone/purified
	name = "创造纯净的灵魂石"
	summon_type = list(/obj/item/soulstone/anybody/purified)

/datum/action/cooldown/spell/conjure/soulstone/mystic
	name = "创建神秘灵魂石"
	summon_type = list(/obj/item/soulstone/mystic)
