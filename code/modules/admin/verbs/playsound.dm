//world/proc/shelleo
#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

ADMIN_VERB(play_sound, R_SOUND, "Play Global Sound", "Play a sound to all connected players.", ADMIN_CATEGORY_FUN, sound as sound)
	var/freq = 1
	var/vol = tgui_input_number(user, "你希望以多大音量播放这个声音？", max_value = 100)
	if(!vol)
		return
	vol = clamp(vol, 1, 100)

	var/sound/admin_sound = new
	admin_sound.file = sound
	admin_sound.priority = 250
	admin_sound.channel = CHANNEL_ADMIN
	admin_sound.frequency = freq
	admin_sound.wait = 1
	admin_sound.repeat = FALSE
	admin_sound.status = SOUND_STREAM
	admin_sound.volume = vol

	var/res = tgui_alert(user, "向玩家显示这首歌曲的标题吗？", "播放声音", list("Yes", "No", "Cancel"))
	switch(res)
		if("Yes")
			to_chat(world, span_boldannounce("管理员播放了：[sound]"), confidential = TRUE)
		if("Cancel")
			return

	log_admin("[key_name(user)] played sound [sound]")
	message_admins("[key_name_admin(user)] played sound [sound]")

	for(var/mob/M in GLOB.player_list)
		var/volume_modifier = M.client.prefs.read_preference(/datum/preference/numeric/volume/sound_midi)
		if(volume_modifier > 0)
			admin_sound.volume = vol * M.client.admin_music_volume * (volume_modifier/100)
			SEND_SOUND(M, admin_sound)
			admin_sound.volume = vol

	BLACKBOX_LOG_ADMIN_VERB("Play Global Sound")

ADMIN_VERB(play_local_sound, R_SOUND, "Play Local Sound", "Plays a sound only you can hear.", ADMIN_CATEGORY_FUN, sound as sound)
	log_admin("[key_name(user)] played a local sound [sound]")
	message_admins("[key_name_admin(user)] played a local sound [sound]")
	var/volume = tgui_input_number(user, "你希望以多大音量播放这个声音？", max_value = 100)
	playsound(get_turf(user.mob), sound, volume || 50, FALSE)
	BLACKBOX_LOG_ADMIN_VERB("Play Local Sound")

ADMIN_VERB(play_direct_mob_sound, R_SOUND, "Play Direct Mob Sound", "Play a sound directly to a mob.", ADMIN_CATEGORY_FUN, sound as sound, mob/target in world)
	if(!target)
		target = input(user, "选择一个要播放声音的玩家。只有他们能听到。", "播放玩家声音") as null|anything in sort_names(GLOB.player_list)
	if(QDELETED(target))
		return
	log_admin("[key_name(user)] played a direct mob sound [sound] to [key_name_admin(target)].")
	message_admins("[key_name_admin(user)] played a direct mob sound [sound] to [ADMIN_LOOKUPFLW(target)].")
	var/volume = tgui_input_number(user, "你希望以多大音量播放这个声音？", max_value = 100)
	var/sound/admin_sound = sound(sound)
	if(volume)
		admin_sound.volume = volume
	SEND_SOUND(target, sound)
	BLACKBOX_LOG_ADMIN_VERB("Play Direct Mob Sound")

GLOBAL_VAR_INIT(web_sound_cooldown, 0)

///Takes an input from either proc/play_web_sound or the request manager and runs it through yt-dlp and prompts the user before playing it to the server.
/proc/web_sound(mob/user, input, credit)
	if(!check_rights(R_SOUND))
		return
	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(user, span_boldwarning("yt-dlp 未配置，操作不可用"), confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
		return
	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/list/music_extra_data = list()
	var/duration = 0
	if(istext(input))
		var/shell_scrubbed_input = shell_url_scrub(input)
		var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
		var/errorlevel = output[SHELLEO_ERRORLEVEL]
		var/stdout = output[SHELLEO_STDOUT]
		var/stderr = output[SHELLEO_STDERR]
		if(errorlevel)
			to_chat(user, span_boldwarning("yt-dlp URL 获取失败："), confidential = TRUE)
			to_chat(user, span_warning("[stderr]"), confidential = TRUE)
			return
		var/list/data
		try
			data = json_decode(stdout)
		catch(var/exception/e)
			to_chat(user, span_boldwarning("yt-dlp JSON 解析失败："), confidential = TRUE)
			to_chat(user, span_warning("[e]: [stdout]"), confidential = TRUE)
			return
		if (data["url"])
			web_sound_url = data["url"]
		var/title = "[data["title"]]"
		var/webpage_url = title
		if (data["webpage_url"])
			webpage_url = "<a href=\"[data["webpage_url"]]\">[title]</a>"
		music_extra_data["duration"] = DisplayTimeText(data["duration"] * 1 SECONDS)
		music_extra_data["link"] = data["webpage_url"]
		music_extra_data["artist"] = data["artist"]
		music_extra_data["upload_date"] = data["upload_date"]
		music_extra_data["album"] = data["album"]
		duration = data["duration"] * 1 SECONDS
		if (duration > 10 MINUTES)
			if((tgui_alert(user, "这首歌曲超过10分钟。你确定要播放吗？", "时长警告", list("No", "Yes", "Cancel")) != "Yes"))
				return
		var/include_song_data = tgui_alert(user, "向玩家显示这首歌的标题和链接吗？\n[title]", "歌曲信息", list("Yes", "No", "Cancel"))
		switch(include_song_data)
			if("Yes")
				music_extra_data["title"] = data["title"]
				music_extra_data["artist"] = data["artist"]
			if("No")
				music_extra_data["link"] = "\[\[HYPERLINK BLOCKED\]\]"
				music_extra_data["title"] = "Untitled"
				music_extra_data["artist"] = "Unknown"
				music_extra_data["upload_date"] = "XX.YY.ZZZZ"
				music_extra_data["album"] = "Default"
			if("Cancel", null)
				return
		var/credit_yourself = tgui_alert(user, "显示是谁播放了这首歌？", "署名自己", list("Yes", "No", "Cancel"))

		var/list/to_chat_message = list()

		switch(credit_yourself)
			if("Yes")
				if(include_song_data == "Yes")
					to_chat_message += span_notice("[user.ckey] 播放了：[span_linkify(webpage_url)]")
				else
					to_chat_message += span_notice("[user.ckey] 播放了一个声音。")
			if("No")
				if(include_song_data == "Yes")
					to_chat_message += span_notice("管理员播放了：[span_linkify(webpage_url)]")
				else
					to_chat_message += span_notice("管理员播放了一个声音。")
			if("Cancel", null)
				return

		if(credit)
			to_chat_message += span_notice("<br>[credit]")

		var/list/recipients = list()
		for(var/client/client as anything in GLOB.clients)
			if(client.prefs.read_preference(/datum/preference/numeric/volume/sound_midi) > 0)
				recipients += client
		recipients |= user.client
		to_chat(recipients, fieldset_block("Now Playing: [span_bold(music_extra_data["title"])] by [span_bold(music_extra_data["artist"])]", jointext(to_chat_message, ""), "boxed_message"))

		SSblackbox.record_feedback("nested tally", "played_url", 1, list("[user.ckey]", "[input]"))
		log_admin("[key_name(user)] played web sound: [input]")
		message_admins("[key_name(user)] played web sound: [input]")
	else
		//pressed ok with blank
		log_admin("[key_name(user)] stopped web sounds.")

		message_admins("[key_name(user)] stopped web sounds.")
		web_sound_url = null
		stop_web_sounds = TRUE
	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		tgui_alert(user, "媒体提供商返回的内容URL未使用HTTP或HTTPS协议。这是一个安全风险，声音将不会被播放。", "安全风险", list("OK"))
		to_chat(user, span_boldwarning("已阻止：内容 URL 未使用 HTTP(S) 协议！"), confidential = TRUE)

		return
	if(web_sound_url || stop_web_sounds)
		for(var/m in GLOB.player_list)
			var/mob/M = m
			var/client/C = M.client
			if(C.prefs.read_preference(/datum/preference/numeric/volume/sound_midi))
				// Stops playing lobby music and admin loaded music automatically.
				SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
				SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
				if(!stop_web_sounds)
					C.tgui_panel?.play_music(web_sound_url, music_extra_data)
				else
					C.tgui_panel?.stop_music()

	CLIENT_COOLDOWN_START(GLOB, web_sound_cooldown, duration)

	BLACKBOX_LOG_ADMIN_VERB("Play Internet Sound")

ADMIN_VERB_CUSTOM_EXIST_CHECK(play_web_sound)
	return !!CONFIG_GET(string/invoke_youtubedl)

ADMIN_VERB(play_web_sound, R_SOUND, "Play Internet Sound", "Play a given internet sound to all players.", ADMIN_CATEGORY_FUN)
	if(!CLIENT_COOLDOWN_FINISHED(GLOB, web_sound_cooldown))
		if(tgui_alert(user, "Someone else is already playing an Internet sound! It has [DisplayTimeText(CLIENT_COOLDOWN_TIMELEFT(GLOB, web_sound_cooldown), 1)] remaining. \
		Would you like to override?", "音乐中断", list("No","Yes")) != "Yes")
			return

	var/web_sound_input = tgui_input_text(user, "输入内容URL（仅限支持的网站，留空以停止播放）", "播放网络声音", null)

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(user, span_boldwarning("不允许使用非 HTTP(S) 的 URI。"), confidential = TRUE)
			to_chat(user, span_warning("对于 youtube-dl 快捷方式（如 ytsearch:），请使用网站提供的完整 URL。"), confidential = TRUE)
			return
		web_sound(user.mob, web_sound_input)
	else
		web_sound(user.mob, null)

ADMIN_VERB(set_round_end_sound, R_SOUND, "Set Round End Sound", "Set the sound that plays on round end.", ADMIN_CATEGORY_FUN, sound as sound)
	var/volume = tgui_input_number(user, "你希望以什么音量播放这个声音？", max_value = 100)
	var/sound/admin_sound = sound(sound)
	if(volume)
		admin_sound.volume = volume
	SSticker.SetRoundEndSound(sound)

	log_admin("[key_name(user)] set the round end sound to [sound]")
	message_admins("[key_name_admin(user)] set the round end sound to [sound]")
	BLACKBOX_LOG_ADMIN_VERB("Set Round End Sound")

ADMIN_VERB(stop_sounds, R_NONE, "Stop All Playing Sounds", "Stops all playing sounds for EVERYONE.", ADMIN_CATEGORY_DEBUG)
	log_admin("[key_name(user)] stopped all currently playing sounds.")
	message_admins("[key_name_admin(user)] stopped all currently playing sounds.")
	for(var/mob/player as anything in GLOB.player_list)
		SEND_SOUND(player, sound(null))
		var/client/player_client = player.client
		player_client?.tgui_panel?.stop_music()

	CLIENT_COOLDOWN_RESET(GLOB, web_sound_cooldown)
	BLACKBOX_LOG_ADMIN_VERB("Stop All Playing Sounds")

//world/proc/shelleo
#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR
