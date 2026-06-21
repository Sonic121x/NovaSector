/datum/mafia_role/traitor
	name = "叛徒"
	desc = "你是一名独行叛徒。你对夜间袭击免疫，每晚都可以杀人，你的获胜条件是人数超过其他所有人。"
	win_condition = "kill everyone."
	team = MAFIA_TEAM_SOLO
	role_type = NEUTRAL_KILL
	role_flags = ROLE_CAN_KILL
	winner_award = /datum/award/achievement/mafia/traitor
	revealed_outfit = /datum/outfit/mafia/traitor
	revealed_icon = "traitor"
	hud_icon = "hudtraitor"
	special_ui_theme = "neutral"

	role_unique_actions = list(/datum/mafia_ability/attack_player)

/datum/mafia_role/traitor/New(datum/mafia_controller/game)
	. = ..()
	RegisterSignal(src, COMSIG_MAFIA_ON_KILL, PROC_REF(nightkill_immunity))

/datum/mafia_role/traitor/proc/nightkill_immunity(datum/source,datum/mafia_controller/game,datum/mafia_role/attacker,lynch)
	SIGNAL_HANDLER

	if(game.phase == MAFIA_PHASE_NIGHT && !lynch)
		to_chat(body,span_userdanger("你遭到了攻击，但他们得再加把劲才能把你放倒。"))
		return MAFIA_PREVENT_KILL

/datum/mafia_role/nightmare
	name = "梦魇"
	desc = "你是一个独行的怪物，不会被侦探类角色发现。每晚你可以让另一个房间的灯光闪烁，从而免疫来自那些角色的攻击。你也可以选择狩猎，杀死闪烁房间内的所有人。杀死所有人以获胜。"
	win_condition = "kill everyone."
	revealed_outfit = /datum/outfit/mafia/nightmare
	role_flags = ROLE_UNDETECTABLE | ROLE_CAN_KILL
	team = MAFIA_TEAM_SOLO
	role_type = NEUTRAL_KILL
	special_ui_theme = "neutral"
	hud_icon = "hudnightmare"
	revealed_icon = "nightmare"
	winner_award = /datum/award/achievement/mafia/nightmare

	role_unique_actions = list(/datum/mafia_ability/flicker_rampage)

/datum/mafia_role/nightmare/special_reveal_equip()
	body.set_species(/datum/species/shadow)
	body.update_body()
