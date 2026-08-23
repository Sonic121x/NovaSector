// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(reestablish_db_connection, R_NONE, "重新连接数据库", "Attempts to (re)establish the DB Connection", ADMIN_CATEGORY_SERVER)
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(user, span_adminnotice(LANG("datum.5bf16f98199b79cc", null)), confidential = TRUE)
		return

	if (SSdbcore.IsConnected())
		if (!user.holder.check_for_rights(R_DEBUG))
			tgui_alert(user,LANG("datum.5c442773d18ac2a7", null), LANG("datum.9cf82a0ffadbd786", null))
			return

		var/reconnect = tgui_alert(user,LANG("datum.edf02f7036d2a62b", null), LANG("datum.9cf82a0ffadbd786", null), list("Force Reconnect", "Cancel"))
		if (reconnect != "Force Reconnect")
			return

		SSdbcore.Disconnect()
		log_admin("[key_name(user)] has forced the database to disconnect")
		message_admins("[key_name_admin(user)] has <b>forced</b> the database to disconnect!")
		BLACKBOX_LOG_ADMIN_VERB("Force Reestablished Database Connection")

	log_admin("[key_name(user)] is attempting to re-establish the DB Connection")
	message_admins("[key_name_admin(user)] is attempting to re-establish the DB Connection")
	BLACKBOX_LOG_ADMIN_VERB("Reestablished Database Connection")

	SSdbcore.failed_connections = 0
	if(!SSdbcore.Connect())
		message_admins("Database connection failed: " + SSdbcore.ErrorMsg())
	else
		message_admins("Database connection re-established")
