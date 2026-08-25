// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(upload_jukebox_music, R_SERVER, "点唱机上传音乐", "Upload a valid .ogg file to be accessed via the jukebox.", ADMIN_CATEGORY_SERVER)
	var/file = input(user, LANG("datum.756b08bf193eb68a", null)) as sound|null
	if(!file)
		return

	// we could theorticly support other sound types but OGG is the better format from what I am aware and I am 100% sure its length is properly fetched.
	if(!IS_OGG_FILE(file))
		tgui_alert(user, LANG("datum.f9fede34ab022030", null), LANG("datum.e990db784bda09f4", null), list("Ok"))
		return

	var/list/track_data = splittext(file, "+")
	if(track_data.len < 2)
		if(tgui_alert(user, LANG("datum.ad5fd0e68bced493", null), LANG("datum.15bc27b6fe454546", null), list("Yes", "No")) != "Yes")
			return
	if(track_data.len > 2)
		tgui_alert(user, LANG("datum.69ad65242447654c", null), LANG("datum.e990db784bda09f4", null), list("Ok"))
		return


	var/clean_name = SANITIZE_FILENAME("[file]")
	var/save_path = "[CONFIG_JUKEBOX_SOUNDS][clean_name]"

	// Copy uploaded file to the server
	fcopy(file, save_path)

	message_admins("[key_name_admin(user)] uploaded [clean_name] to the jukebox!")
	to_chat(user, span_notice(LANG("datum.323743c2d1c4e32c", list(clean_name))))
	refresh_jukebox_songs()

ADMIN_VERB(browse_jukebox_music, R_SERVER, "点唱机浏览音乐", "Browse music files for moderation.", ADMIN_CATEGORY_SERVER)
	var/list/files = flist(CONFIG_JUKEBOX_SOUNDS)
	// Filter out things that are not sound files, like the exclude
	for(var/thing in files)
		if(!IS_SOUND_FILE(thing))
			files -= thing
	if(!files.len)
		to_chat(user, span_warning(LANG("datum.a2ece989c97246b1", null)))
		return

	var/choice = tgui_input_list(user, LANG("datum.30fb41c31519edfd", null), LANG("datum.6aecf803fa49d053", null), files)
	if(!choice)
		return

	var/path = "[CONFIG_JUKEBOX_SOUNDS][choice]"

	switch(tgui_alert(user, LANG("datum.4718cba422df2648", null), choice, list("Play", "Delete", "Download")))
		if ("Play")
			SEND_SOUND(user, sound(path))
		if ("Delete")
			fdel(path)
			var/msg = "[key_name_admin(user)] deleted [choice] from the jukebox!"
			message_admins(msg)
			log_admin(msg)
			SSblackbox.record_feedback("associative", "jukebox_deletion", 1, list("round_id" = "[GLOB.round_id]", "deletor" = "[key_name_admin(user)]", "deleted" = "[choice]"))
			refresh_jukebox_songs()
		if ("Download")
			user << ftp(file(path))
		else
			return

/// Recache the songs from config then force replace all the songs.
/proc/refresh_jukebox_songs()
	var/refreshed = FALSE
	for(var/obj/machinery/jukebox/jukebox as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/jukebox))
		if(!refreshed)
			jukebox.music_player.load_songs_from_config(TRUE)
			refreshed = TRUE

		jukebox.music_player.songs = jukebox.music_player.init_songs()
