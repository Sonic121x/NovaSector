// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/innate/change_name
	name = "Change Name"
	button_icon_state = "ghost"

/datum/action/innate/change_name/Activate()
	var/new_name = reject_bad_name(tgui_input_text(usr, LANG("datum.8027c6f1b3bfd856", null), LANG("datum.26a6716c812dc7d8", null), initial(owner.name)), allow_numbers = TRUE, max_length = MAX_NAME_LEN, cap_after_symbols = FALSE)
	if(!new_name)
		return FALSE

	owner.fully_replace_character_name(owner.name, new_name)
	return TRUE
