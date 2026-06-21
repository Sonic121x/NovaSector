/**
 * Thoughtfeeding
 *
 * During the night, thoughtfeeding will reveal the person's exact role.
 */
/datum/mafia_ability/thoughtfeeder
	name = "思维读取"
	ability_action = "feast on the memories of"

/datum/mafia_ability/thoughtfeeder/perform_action_target(datum/mafia_controller/game, datum/mafia_role/day_target)
	. = ..()
	if(!.)
		return FALSE

	if((target_role.role_flags & ROLE_UNDETECTABLE))
		host_role.send_message_to_player(span_warning("[target_role.body.real_name]的记忆显示他们是[pick(game.all_roles - target_role)]。"))
	else
		host_role.send_message_to_player(span_warning("[target_role.body.real_name]的记忆显示他们是[target_role.name]。"))
	return TRUE
