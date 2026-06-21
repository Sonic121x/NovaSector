ADMIN_VERB(panic_bunker, R_SERVER, "Toggle Panic Bunker", "Toggles the panic bunker for the server.", ADMIN_CATEGORY_SERVER)
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(user, span_adminnotice("数据库未启用！"), confidential = TRUE)
		return

	var/new_pb = !CONFIG_GET(flag/panic_bunker)
	var/interview = CONFIG_GET(flag/panic_bunker_interview)
	var/time_rec = 0
	var/message = ""
	if(new_pb)
		time_rec = input(user, "他们需要游玩多少存活分钟数？0 表示禁用。", "情况不妙，对吧", CONFIG_GET(number/panic_bunker_living)) as num
		message = input(user, "他们登录时应该看到什么？", "MMM", CONFIG_GET(string/panic_bunker_message)) as text
		message = replacetext(message, "%minutes%", time_rec)
		CONFIG_SET(number/panic_bunker_living, time_rec)
		CONFIG_SET(string/panic_bunker_message, message)

		var/interview_sys = tgui_alert(user, "是否启用面试系统？（允许玩家在时长限制下连接，并强制他们需要手动批准才能游玩）", "启用面试？", list("Enable", "Disable"))
		interview = interview_sys == "Enable"
		CONFIG_SET(flag/panic_bunker_interview, interview)
	CONFIG_SET(flag/panic_bunker, new_pb)
	log_admin("[key_name(user)] has toggled the Panic Bunker, it is now [new_pb ? "on and set to [time_rec] with a message of [message]. The interview system is [interview ? "enabled" : "disabled"]" : "off"].")
	message_admins("[key_name_admin(user)] has toggled the Panic Bunker, it is now [new_pb ? "enabled with a living minutes requirement of [time_rec]. The interview system is [interview ? "enabled" : "disabled"]" : "disabled"].")
	if (new_pb && !SSdbcore.Connect())
		message_admins("The Database is not connected! Panic bunker will not work until the connection is reestablished.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Panic Bunker", "[new_pb ? "Enabled" : "Disabled"]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

ADMIN_VERB(toggle_interviews, R_SERVER, "Toggle PB Interviews", "Toggle whether new players will be interviewed or blocked from connecting.", ADMIN_CATEGORY_SERVER)
	if (!CONFIG_GET(flag/panic_bunker))
		to_chat(user, span_adminnotice("注意：恐慌掩体未启用，因此此更改在启用前不会产生任何效果。"), confidential = TRUE)
	var/new_interview = !CONFIG_GET(flag/panic_bunker_interview)
	CONFIG_SET(flag/panic_bunker_interview, new_interview)
	log_admin("[key_name(user)] has toggled the Panic Bunker's interview system, it is now [new_interview ? "enabled" : "disabled"].")
	message_admins("[key_name(user)] has toggled the Panic Bunker's interview system, it is now [new_interview ? "enabled" : "disabled"].")
