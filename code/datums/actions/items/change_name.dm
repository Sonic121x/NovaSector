/datum/action/innate/change_name
	name = "更改名称"
	button_icon_state = "ghost"

/datum/action/innate/change_name/Activate()
	var/new_name = reject_bad_name(tgui_input_text(usr, "输入一个新名字。", "重命名", initial(owner.name)), allow_numbers = TRUE, max_length = MAX_NAME_LEN, cap_after_symbols = FALSE)
	if(!new_name)
		return FALSE

	owner.fully_replace_character_name(owner.name, new_name)
	return TRUE
