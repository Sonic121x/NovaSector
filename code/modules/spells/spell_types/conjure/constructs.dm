/datum/action/cooldown/spell/conjure/construct
	name = "召唤构造体外壳"
	desc = "此法术能召唤出一个可以由幽灵操控的构造体。"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "artificer"
	sound = 'sound/effects/magic/summonitems_generic.ogg'

	school = SCHOOL_CONJURATION
	cooldown_time = 1 MINUTES

	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	summon_radius = 0
	summon_type = list(/obj/structure/constructshell)

/datum/action/cooldown/spell/conjure/construct/lesser // Used by artificers.
	name = "创建构造体外壳"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	cooldown_time = 3 MINUTES
