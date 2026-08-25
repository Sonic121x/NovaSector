// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(get_server_logs, R_ADMIN, "获取服务器日志", "View or retrieve logfiles.", ADMIN_CATEGORY_MAIN)
	user.browseserverlogs()

ADMIN_VERB(get_current_logs, R_ADMIN, "获取当前日志", "View or retrieve logfiles for the current round.", ADMIN_CATEGORY_MAIN)
	user.browseserverlogs(current=TRUE)

/client/proc/browseserverlogs(current=FALSE)
	var/path = browse_files(current ? BROWSE_ROOT_CURRENT_LOGS : BROWSE_ROOT_ALL_LOGS)
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	switch(tgui_alert(usr,LANG("client.2f0a3fe18d62e840", null), path, list("View", "Open", "Download")))
		if ("View")
			src << browse(HTML_SKELETON("<pre style='word-wrap: break-word;'>[html_encode(file2text(file(path)))]</pre>"), list2params(list("window" = "viewfile.[path]")))
		if ("Open")
			src << run(file(path))
		if ("Download")
			src << ftp(file(path))
		else
			return
	to_chat(src, LANG("client.04c7cd22dc6cb17f", list(path)), confidential = TRUE)
