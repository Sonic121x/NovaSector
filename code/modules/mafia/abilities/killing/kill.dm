/**
 * Attack
 *
 * During the night, attacks a player in attempts to kill them.
 */
/datum/mafia_ability/attack_player
	name = "攻击"
	ability_action = "attempt to attack"
	action_priority = COMSIG_MAFIA_NIGHT_KILL_PHASE
	///The message told to the player when they are killed.
	var/attack_action = "killed by"
	///Whether the player will suicide if they hit a Town member.
	var/honorable = FALSE

/datum/mafia_ability/attack_player/perform_action_target(datum/mafia_controller/game, datum/mafia_role/day_target)
	. = ..()
	if(!.)
		return FALSE

	if(!target_role.kill(game, host_role, FALSE))
		host_role.send_message_to_player(span_danger("你试图杀死[target_role.body.real_name]的行动被阻止了！"))
	else
		target_role.send_message_to_player(span_userdanger("你被[attack_action] \a [host_role.name]！"))
		if(honorable && (target_role.team & MAFIA_TEAM_TOWN))
			host_role.send_message_to_player(span_userdanger("你杀死了一名无辜的船员。你将在明晚死去。"))
			RegisterSignal(game, COMSIG_MAFIA_SUNDOWN, PROC_REF(internal_affairs))
	return TRUE

/datum/mafia_ability/attack_player/proc/internal_affairs(datum/mafia_controller/game)
	SIGNAL_HANDLER
	host_role.send_message_to_player(span_userdanger("你已被纳米传讯内部事务部处决！"))
	host_role.reveal_role(game, verbose = TRUE)
	host_role.kill(game, host_role, FALSE) //you technically kill yourself but that shouldn't matter

/datum/mafia_ability/attack_player/execution
	name = "处决"
	ability_action = "attempt to execute"
	attack_action = "executed by"
	honorable = TRUE
