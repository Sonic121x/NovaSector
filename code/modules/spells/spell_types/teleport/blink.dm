/datum/action/cooldown/spell/teleport/radius_turf/blink
	name = "闪烁"
	desc = "这个咒语会随机将你传送一小段距离。"
	button_icon_state = "blink"
	sound = 'sound/effects/magic/blink.ogg'

	school = SCHOOL_TRANSLOCATION
	cooldown_time = 2 SECONDS
	cooldown_reduction_per_rank = 0.4 SECONDS

	invocation_type = INVOCATION_NONE

	smoke_type = /datum/effect_system/fluid_spread/smoke
	smoke_amt = 0

	inner_tele_radius = 0
	outer_tele_radius = 6

	post_teleport_sound = 'sound/effects/magic/blink.ogg'

/datum/action/cooldown/spell/teleport/radius_turf/blink/slow
	name = "次级闪烁"
	desc = "这个法术会将你随机传送到短距离外，你仍在练习如何快速施放。"
	cooldown_time = 8 SECONDS
