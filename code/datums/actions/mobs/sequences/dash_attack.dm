/datum/action/cooldown/mob_cooldown/dash_attack
	name = "冲刺与攻击"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	desc = "允许你同时向目标冲刺并开火。"
	cooldown_time = 3 SECONDS
	shared_cooldown = MOB_SHARED_COOLDOWN_2
	sequence_actions = list(
		/datum/action/cooldown/mob_cooldown/charge/basic_charge/blood_drunk_miner = 0.22 SECONDS, // 0.1s windup + 0.12s max dash
		/datum/action/cooldown/mob_cooldown/projectile_attack/rapid_fire/kinetic_accelerator = 0,
	)

/datum/action/cooldown/mob_cooldown/dash_attack/long_burst
	sequence_actions = list(
		/datum/action/cooldown/mob_cooldown/charge/basic_charge/blood_drunk_miner = 0.22 SECONDS,
		/datum/action/cooldown/mob_cooldown/projectile_attack/rapid_fire/kinetic_accelerator/long_burst = 0,
	)
