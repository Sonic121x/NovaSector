// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * Autopsy
 *
 * During the night, choose someone to check their role.
 */
/datum/mafia_ability/autopsy
	name = "Autopsy"
	ability_action = "perform an autopsy on"
	use_flags = CAN_USE_ON_OTHERS|CAN_USE_ON_DEAD

/datum/mafia_ability/autopsy/perform_action_target(datum/mafia_controller/game, datum/mafia_role/day_target)
	. = ..()
	if(!.)
		return FALSE

	to_chat(host_role.body, span_warning(LANG("datum.1c636e1cfcbc89ca", list(target_role.body.real_name, target_role.name))))
	return TRUE
