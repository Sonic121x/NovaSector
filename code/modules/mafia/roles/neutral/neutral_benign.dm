/datum/mafia_role/fugitive
	name = "逃亡者"
	desc = "你正在逃亡。你可以使用两次防弹背心以获得一夜的免疫，你的获胜条件是存活到游戏结束（与任何人一起）。"
	win_condition = "survive to the end of the game, with anyone"
	revealed_outfit = /datum/outfit/mafia/fugitive
	team = MAFIA_TEAM_SOLO
	role_type = NEUTRAL_DISRUPT
	special_ui_theme = "neutral"
	hud_icon = "hudfugitive"
	revealed_icon = "fugitive"
	winner_award = /datum/award/achievement/mafia/fugitive

	role_unique_actions = list(/datum/mafia_ability/vest)

/datum/mafia_role/fugitive/New(datum/mafia_controller/game)
	. = ..()
	RegisterSignal(game, COMSIG_MAFIA_GAME_END, PROC_REF(survived))

/datum/mafia_role/fugitive/proc/survived(datum/mafia_controller/game)
	SIGNAL_HANDLER

	if(game_status == MAFIA_ALIVE)
		game.award_role(winner_award, src)
		game.send_message("<span class='big comradio'>!! FUGITIVE VICTORY !!</span>")
