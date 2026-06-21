ADMIN_VERB(get_server_logs, R_ADMIN, "Get Server Logs", "View or retrieve logfiles.", ADMIN_CATEGORY_MAIN)
	user.browseserverlogs()

ADMIN_VERB(get_current_logs, R_ADMIN, "Get Current Logs", "View or retrieve logfiles for the current round.", ADMIN_CATEGORY_MAIN)
	user.browseserverlogs(current=TRUE)

/client/proc/browseserverlogs(current=FALSE)
	var/path = browse_files(current ? BROWSE_ROOT_CURRENT_LOGS : BROWSE_ROOT_ALL_LOGS)
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	switch(tgui_alert(usr,"查看（在游戏内）、打开（在您系统的文本编辑器中）还是下载？", path, list("View", "Open", "Download")))
		if ("View")
			src << browse(HTML_SKELETON("<pre style='word-wrap: break-word;'>[html_encode(file2text(file(path)))]</pre>"), list2params(list("window" = "viewfile.[path]")))
		if ("Open")
			src << run(file(path))
		if ("Download")
			src << ftp(file(path))
		else
			return
	to_chat(src, "正在尝试发送 [path]，如果文件非常大，这可能需要相当几分钟。", confidential = TRUE)
