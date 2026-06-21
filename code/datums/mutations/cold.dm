/datum/mutation/geladikinesis
	name = "凝冰术"
	desc = "允许使用者将水分和零度以下的力量凝聚成雪。"
	quality = POSITIVE
	text_gain_indication = span_notice("你的手感觉冰冷。")
	instability = POSITIVE_INSTABILITY_MINOR
	difficulty = 10
	synchronizer_coeff = 1
	power_path = /datum/action/cooldown/spell/conjure_item/snow

/datum/action/cooldown/spell/conjure_item/snow
	name = "创造雪"
	desc = "凝聚低温力量来创造雪，可用于雪状构造。"
	button_icon_state = "snow"

	cooldown_time = 5 SECONDS
	spell_requirements = NONE

	item_type = /obj/item/stack/sheet/mineral/snow
	delete_old = FALSE
	delete_on_failure = FALSE

/datum/mutation/cryokinesis
	name = "低温操控"
	desc = "从亚零虚空汲取负能量，依主体意志冻结周围温度。"
	quality = POSITIVE //upsides and downsides
	text_gain_indication = span_notice("你的手感觉冰冷。")
	instability = POSITIVE_INSTABILITY_MODERATE
	difficulty = 12
	synchronizer_coeff = 1
	energy_coeff = 1
	power_path = /datum/action/cooldown/spell/pointed/projectile/cryo

/datum/action/cooldown/spell/pointed/projectile/cryo
	name = "冷冻光束"
	desc = "此能力向目标发射一道冰冻射线。"
	button_icon_state = "icebeam"
	base_icon_state = "icebeam"
	active_overlay_icon_state = "bg_spell_border_active_blue"
	cast_range = 9
	cooldown_time = 16 SECONDS
	spell_requirements = NONE
	antimagic_flags = NONE

	active_msg = "You focus your cryokinesis!"
	deactive_msg = "You relax."
	projectile_type = /obj/projectile/temp/cryo
