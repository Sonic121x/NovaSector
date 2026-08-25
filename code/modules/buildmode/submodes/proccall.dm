// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/proccall
	key = "proccall"
	///The procedure itself, which we will call in the future. For example "qdel"
	var/proc_name = null
	///The list of arguments for the procedure. They may not be. They are selected in the same way in the game, and can be a datum, and other types.
	var/list/proc_args = null

/datum/buildmode_mode/proccall/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.adb29bd14e63698f", list(span_bold("Choose procedure and arguments"), span_bold("Apply procedure on object")))))
	)

/datum/buildmode_mode/proccall/change_settings(client/target_client)
	if(!check_rights_for(target_client, R_DEBUG))
		return

	proc_name = input(LANG("datum.5a6a7f470a534828", null), LANG("datum.a03a6d4f8aa05257", null), null) as text|null
	if(!proc_name)
		return

	proc_args = target_client.get_callproc_args()
	if(!proc_args)
		return

/datum/buildmode_mode/proccall/handle_click(client/target_client, params, datum/object as null|area|mob|obj|turf)
	if(!proc_name || !proc_args)
		tgui_alert(target_client, LANG("datum.94c65453c6abcac5", null))
		return

	if(!hascall(object, proc_name))
		to_chat(target_client, span_warning(LANG("datum.3ecfa481ca145694", list(object.type, proc_name))), confidential = TRUE)
		return

	if(!is_valid_src(object))
		to_chat(target_client, span_warning(LANG("datum.2ff7dadf2433abdb", null)), confidential = TRUE)
		return


	var/msg = "[key_name(target_client)] called [object]'s [proc_name]() with [proc_args.len ? "the arguments [list2params(proc_args)]":"no arguments"]."
	log_admin(msg)
	message_admins(msg)
	admin_ticket_log(object, msg)
	BLACKBOX_LOG_ADMIN_VERB("Atom ProcCall")

	var/returnval = WrapAdminProcCall(object, proc_name, proc_args) // Pass the lst as an argument list to the proc
	. = target_client.get_callproc_returnval(returnval, proc_name)
	if(.)
		to_chat(target_client, ., confidential = TRUE)
