/datum/mutation/cindikinesis
	name = "灰烬操控"
	desc = "允许使用者将附近的热量集中成一堆灰烬。哇。真有意思。"
	quality = POSITIVE
	text_gain_indication = span_notice("你的手感觉温暖。")
	instability = POSITIVE_INSTABILITY_MINOR
	difficulty = 10
	synchronizer_coeff = 1
	locked = TRUE
	power_path = /datum/action/cooldown/spell/conjure_item/ash

/datum/action/cooldown/spell/conjure_item/ash
	name = "创造灰烬"
	desc = "集中火焰之力创造灰烬，基本上没什么用。"
	button_icon_state = "ash"

	cooldown_time = 5 SECONDS
	spell_requirements = NONE

	item_type = /obj/effect/decal/cleanable/ash
	delete_old = FALSE
	delete_on_failure = FALSE

/datum/mutation/pyrokinesis
	name = "火焰操控"
	desc = "从周围汲取正能量，按主体意愿加热周围温度。"
	quality = POSITIVE
	text_gain_indication = span_notice("你的手感觉发烫！")
	instability = POSITIVE_INSTABILITY_MODERATE
	difficulty = 12
	synchronizer_coeff = 1
	energy_coeff = 1
	locked = TRUE
	power_path = /datum/action/cooldown/spell/pointed/projectile/pyro

/datum/action/cooldown/spell/pointed/projectile/pyro
	name = "火焰射线"
	desc = "此能力向目标发射一道加热的能量束。"
	button_icon_state = "firebeam"
	base_icon_state = "firebeam"
	active_overlay_icon_state = "bg_spell_border_active_blue"
	cast_range = 9
	cooldown_time = 30 SECONDS
	spell_requirements = NONE
	antimagic_flags = NONE

	active_msg = "You focus your pyrokinesis!"
	deactive_msg = "You cool down."
	projectile_type = /obj/projectile/temp/pyro
