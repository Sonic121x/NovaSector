/datum/action/cooldown/mob_cooldown/direct_and_aoe
	name = "直射与范围射击"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	desc = "允许你直接射击目标的同时向周围开火。"
	cooldown_time = 12 SECONDS
	sequence_actions = list(
		/datum/action/cooldown/mob_cooldown/dash = 0.1 SECONDS,
		/datum/action/cooldown/mob_cooldown/projectile_attack/kinetic_accelerator = 0,
	)
