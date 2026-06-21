ADMIN_VERB(reestablish_db_connection, R_NONE, "Reestablish DB Connection", "Attempts to (re)establish the DB Connection", ADMIN_CATEGORY_SERVER)
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(user, span_adminnotice("数据库未启用！"), confidential = TRUE)
		return

	if (SSdbcore.IsConnected())
		if (!user.holder.check_for_rights(R_DEBUG))
			tgui_alert(user,"数据库已连接！（只有拥有+debug权限的人才能强制重连）", "数据库已连接！")
			return

		var/reconnect = tgui_alert(user,"数据库已连接！如果你*确定*这是错误的，可以强制重连", "数据库已连接！", list("Force Reconnect", "Cancel"))
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
