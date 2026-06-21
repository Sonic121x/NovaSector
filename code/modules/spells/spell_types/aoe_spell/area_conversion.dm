/datum/action/cooldown/spell/aoe/area_conversion
	name = "区域转换"
	desc = "这个法术会瞬间将你周围的一小片区域笼罩起来。"
	background_icon_state = "bg_cult"
	overlay_icon_state = "bg_cult_border"

	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "areaconvert"

	school = SCHOOL_TRANSMUTATION
	cooldown_time = 5 SECONDS

	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	aoe_radius = 2

/datum/action/cooldown/spell/aoe/area_conversion/get_things_to_cast_on(atom/center)
	return RANGE_TURFS(aoe_radius, center)

/datum/action/cooldown/spell/aoe/area_conversion/cast_on_thing_in_aoe(turf/victim, atom/caster)
	playsound(victim, 'sound/items/tools/welder.ogg', 75, TRUE)
	victim.narsie_act(FALSE, TRUE, 100 - (get_dist(victim, caster) * 25))
