/datum/action/cooldown/mob_cooldown
	name = "标准生物冷却技能"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	desc = "点击此技能进行攻击。"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 5 SECONDS
	text_cooldown = TRUE
	click_to_activate = TRUE
	shared_cooldown = MOB_SHARED_COOLDOWN_1
