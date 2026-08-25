// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(panic_bunker, R_SERVER, "切换恐慌地堡", "Toggles the panic bunker for the server.", ADMIN_CATEGORY_SERVER)
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(user, span_adminnotice(LANG("datum.5bf16f98199b79cc", null)), confidential = TRUE)
		return

	var/new_pb = !CONFIG_GET(flag/panic_bunker)
	var/interview = CONFIG_GET(flag/panic_bunker_interview)
	var/time_rec = 0
	var/message = ""
	if(new_pb)
		time_rec = input(user, LANG("datum.540b8679f42cc9f2", null), LANG("datum.f8299fde919a0ff8", null), CONFIG_GET(number/panic_bunker_living)) as num
		message = input(user, LANG("datum.7ca7f9841ff6f9cc", null), LANG("datum.dda90665d0c25c24", null), CONFIG_GET(string/panic_bunker_message)) as text
		message = replacetext(message, "%minutes%", time_rec)
		CONFIG_SET(number/panic_bunker_living, time_rec)
		CONFIG_SET(string/panic_bunker_message, message)

		var/interview_sys = tgui_alert(user, LANG("datum.1de637924f498c37", null), LANG("datum.11e100225fed527f", null), list("Enable", "Disable"))
		interview = interview_sys == "Enable"
		CONFIG_SET(flag/panic_bunker_interview, interview)
	CONFIG_SET(flag/panic_bunker, new_pb)
	log_admin("[key_name(user)] has toggled the Panic Bunker, it is now [new_pb ? "on and set to [time_rec] with a message of [message]. The interview system is [interview ? "enabled" : "disabled"]" : "off"].")
	message_admins("[key_name_admin(user)] has toggled the Panic Bunker, it is now [new_pb ? "enabled with a living minutes requirement of [time_rec]. The interview system is [interview ? "enabled" : "disabled"]" : "disabled"].")
	if (new_pb && !SSdbcore.Connect())
		message_admins("The Database is not connected! Panic bunker will not work until the connection is reestablished.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Panic Bunker", "[new_pb ? "Enabled" : "Disabled"]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

ADMIN_VERB(toggle_interviews, R_SERVER, "切换恐慌地堡面试", "Toggle whether new players will be interviewed or blocked from connecting.", ADMIN_CATEGORY_SERVER)
	if (!CONFIG_GET(flag/panic_bunker))
		to_chat(user, span_adminnotice(LANG("datum.f6ae7038b747d225", null)), confidential = TRUE)
	var/new_interview = !CONFIG_GET(flag/panic_bunker_interview)
	CONFIG_SET(flag/panic_bunker_interview, new_interview)
	log_admin("[key_name(user)] has toggled the Panic Bunker's interview system, it is now [new_interview ? "enabled" : "disabled"].")
	message_admins("[key_name(user)] has toggled the Panic Bunker's interview system, it is now [new_interview ? "enabled" : "disabled"].")
