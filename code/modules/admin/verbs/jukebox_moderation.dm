ADMIN_VERB(upload_jukebox_music, R_SERVER, "Jukebox Upload Music", "Upload a valid .ogg file to be accessed via the jukebox.", ADMIN_CATEGORY_SERVER)
	var/file = input(user, "选择一个 .ogg 文件上传到点唱机。") as sound|null
	if(!file)
		return

	// we could theorticly support other sound types but OGG is the better format from what I am aware and I am 100% sure its length is properly fetched.
	if(!IS_OGG_FILE(file))
		tgui_alert(user, "无效的文件类型。请选择一个 OGG 文件。", "加载错误", list("Ok"))
		return

	var/list/track_data = splittext(file, "+")
	if(track_data.len < 2)
		if(tgui_alert(user, "您当前的歌曲标题未添加以十分之一秒为单位的节拍，例如：SS13+5.ogg。是否继续？", "确认", list("Yes", "No")) != "Yes")
			return
	if(track_data.len > 2)
		tgui_alert(user, "标题应仅包含其名称和以十分之一秒为单位的节拍，例如：SS13+5.ogg", "加载错误", list("Ok"))
		return


	var/clean_name = SANITIZE_FILENAME("[file]")
	var/save_path = "[CONFIG_JUKEBOX_SOUNDS][clean_name]"

	// Copy uploaded file to the server
	fcopy(file, save_path)

	message_admins("[key_name_admin(user)] uploaded [clean_name] to the jukebox!")
	to_chat(user, span_notice("成功上传 [clean_name]！"))

ADMIN_VERB(browse_jukebox_music, R_SERVER, "Jukebox Browse Music", "Browse music files for moderation.", ADMIN_CATEGORY_SERVER)
	var/list/files = flist(CONFIG_JUKEBOX_SOUNDS)
	// Filter out things that are not sound files, like the exclude
	for(var/thing in files)
		if(!IS_SOUND_FILE(thing))
			files -= thing
	if(!files.len)
		to_chat(user, span_warning("未找到已上传的曲目。"))
		return

	var/choice = tgui_input_list(user, "选择曲目：", "选择点唱机音乐", files)
	if(!choice)
		return

	var/path = "[CONFIG_JUKEBOX_SOUNDS][choice]"

	switch(tgui_alert(user, "播放、删除还是下载？", choice, list("Play", "Delete", "Download")))
		if ("Play")
			SEND_SOUND(user, sound(path))
		if ("Delete")
			fdel(path)
			var/msg = "[key_name_admin(user)] deleted [choice] from the jukebox!"
			message_admins(msg)
			log_admin(msg)
			SSblackbox.record_feedback("associative", "jukebox_deletion", 1, list("round_id" = "[GLOB.round_id]", "deletor" = "[key_name_admin(user)]", "deleted" = "[choice]"))
		if ("Download")
			user << ftp(file(path))
		else
			return
