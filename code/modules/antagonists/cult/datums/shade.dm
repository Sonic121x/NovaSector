// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/antagonist/cult/shade
	name = "\improper Cult Shade"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	antagpanel_category = ANTAG_GROUP_HORRORS
	///The time this player was most recently released from a soulstone.
	var/release_time
	///The time needed after release time to enable rune invocation.
	var/invoke_delay = (1 MINUTES)

/datum/antagonist/cult/shade/check_invoke_validity()
	if(isnull(release_time))
		to_chat(owner.current, span_alert(LANG("datum.b75f250c35aa0ad6", null)))
		return FALSE

	if(release_time + invoke_delay > world.time)
		to_chat(owner.current, span_alert(LANG("datum.1534692bbd6eb7e0", null)))
		return FALSE
	return TRUE
