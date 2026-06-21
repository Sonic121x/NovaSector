/datum/mafia_role/obsessed
	name = "偏执狂"
	desc = "不惜一切代价，在你被杀之前处决你的执念目标！"
	win_condition = "lynch their obsession."
	revealed_outfit = /datum/outfit/mafia/obsessed
	team = MAFIA_TEAM_SOLO
	role_type = NEUTRAL_DISRUPT
	special_ui_theme = "neutral"
	hud_icon = "hudobsessed"
	revealed_icon = "obsessed"

	winner_award = /datum/award/achievement/mafia/obsessed
	///The person the obsessed has to get lynched in order to win.
	var/datum/mafia_role/obsession

/datum/mafia_role/obsessed/New(datum/mafia_controller/game) //note: obsession is always a townie
	. = ..()
	desc = initial(desc) + "不惜一切代价，在你被杀之前处决你的执念目标！ 执念目标将在第一晚分配。"
	RegisterSignal(game, COMSIG_MAFIA_SUNDOWN, PROC_REF(find_obsession))

/datum/mafia_role/obsessed/proc/find_obsession(datum/mafia_controller/game)
	SIGNAL_HANDLER

	var/list/all_roles_shuffle = shuffle(game.living_roles) - src
	for(var/datum/mafia_role/possible as anything in all_roles_shuffle)
		if(possible.team & MAFIA_TEAM_TOWN)
			obsession = possible
			break
	if(!obsession)
		obsession = pick(all_roles_shuffle) //okay no town just pick anyone here
	desc = initial(desc) + "不惜一切代价，在你被杀之前处决你的执念目标！ 目标：[obsession.body.real_name]"
	var/obj/item/modular_computer/modpc = player_pda
	if(modpc)
		modpc.update_static_data_for_all_viewers()
	else
		game.update_static_data(body)
	send_message_to_player(span_userdanger("你的执念目标是[obsession.body.real_name]！让他们被处决以获胜！"))
	RegisterSignal(obsession, COMSIG_MAFIA_ON_KILL, PROC_REF(check_victory))
	UnregisterSignal(game, COMSIG_MAFIA_SUNDOWN)

/datum/mafia_role/obsessed/proc/check_victory(datum/source,datum/mafia_controller/game,datum/mafia_role/attacker,lynch)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_MAFIA_ON_KILL)
	if(game_status == MAFIA_DEAD)
		return
	if(lynch)
		game.send_message("<span class='big comradio'>!! OBSESSED VICTORY !!</span>")
		game.award_role(winner_award, src)
		reveal_role(game, FALSE)
	else
		to_chat(body, span_userdanger("你未能完成处决[obsession.body.real_name]的目标！"))

/datum/mafia_role/clown
	name = "小丑"
	desc = "如果你被处决，你将带走一位投票者（有罪票或弃权票）并获胜。HONK！"
	win_condition = "get themselves lynched!"
	revealed_outfit = /datum/outfit/mafia/clown
	team = MAFIA_TEAM_SOLO
	role_type = NEUTRAL_DISRUPT
	special_ui_theme = "neutral"
	hud_icon = SECHUD_CLOWN
	revealed_icon = "clown"
	winner_award = /datum/award/achievement/mafia/clown

/datum/mafia_role/clown/New(datum/mafia_controller/game)
	. = ..()
	RegisterSignal(src, COMSIG_MAFIA_ON_KILL, PROC_REF(prank))

/datum/mafia_role/clown/proc/prank(datum/source,datum/mafia_controller/game, datum/mafia_role/attacker,lynch)
	SIGNAL_HANDLER

	if(lynch)
		var/datum/mafia_role/victim = pick(game.judgement_guilty_votes + game.judgement_abstain_votes)
		game.send_message("<span class='big clown'>[body.real_name] WAS A CLOWN! HONK! They take down [victim.body.real_name] with their last prank.</span>")
		game.send_message("<span class='big clown'>!! CLOWN VICTORY !!</span>")
		game.award_role(winner_award, src)
		victim.kill(game, FALSE)
