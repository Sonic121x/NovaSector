/// An HTTP request that can send a file from disk as its body.
/datum/http_request/file_body
	/// Path of the file sent as the request body.
	var/body_file

/datum/http_request/file_body/build_options()
	return json_encode(list(
		"output_filename" = output_file ? output_file : null,
		"body_filename" = body_file,
		"timeout_seconds" = timeout_seconds ? timeout_seconds : null,
	))

/datum/controller/subsystem/tts
	/// Whether the TTS server supports player-made voices.
	var/custom_voices_enabled = FALSE
	/// Approved player-made voice ID -> owner ckey.
	var/list/custom_voice_owners = list()

/// Calls the TTS server's custom voice API and waits for the answer. This is blocking.
/// Returns list(status code, decoded JSON body or null, error message or null).
/datum/controller/subsystem/tts/proc/custom_voice_call(method, path, body = "", body_file, output_file, list/extra_headers)
	var/datum/http_request/file_body/request = new()
	var/list/headers = list("Authorization" = CONFIG_GET(string/tts_http_token))
	if(!body_file)
		headers["Content-Type"] = "application/json"
	if(extra_headers)
		headers += extra_headers
	request.body_file = body_file
	request.prepare(method, "[CONFIG_GET(string/tts_http_url)]/[path]", body, headers, output_file, timeout_seconds = 120)
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()
	if(response.errored)
		return list(0, null, "无法连接语音服务器。")
	var/list/decoded = output_file ? null : safe_json_decode(response.body)
	if(response.status_code != 200)
		var/error = islist(decoded) ? decoded["error"] : null
		return list(response.status_code, null, istext(error) ? error : "语音服务器返回错误 [response.status_code]。")
	return list(200, decoded, null)

/// Reloads which player-made voices may speak, and who owns them. This is blocking.
/datum/controller/subsystem/tts/proc/refresh_custom_voices()
	if(!custom_voices_enabled)
		custom_voice_owners = list()
		return FALSE
	var/list/result = custom_voice_call(RUSTG_HTTP_METHOD_GET, "custom-voices?status=approved")
	if(result[1] != 200 || !islist(result[2]))
		return FALSE
	var/list/owners = list()
	for(var/list/voice in result[2])
		if(istext(voice["id"]) && istext(voice["ckey"]))
			owners[voice["id"]] = voice["ckey"]
	custom_voice_owners = owners
	return TRUE

/// Whether `voice` is an approved player-made voice.
/datum/controller/subsystem/tts/proc/is_custom_voice(voice)
	return istext(voice) && !isnull(custom_voice_owners[voice])

/// Whether `user` may speak with the player-made voice `voice`: it must be theirs and they must be a donor.
/datum/controller/subsystem/tts/proc/can_use_custom_voice(client/user, voice)
	if(!istype(user) || !is_custom_voice(voice))
		return FALSE
	return custom_voice_owners[voice] == user.ckey && SSplayer_ranks.is_donator(user)

/// Reduces player text for a custom voice request to one plain line.
/proc/tts_sanitize_custom_voice_text(text, max_length)
	if(!istext(text))
		return ""
	var/static/regex/unsafe_characters = regex(@"[\x00-\x1F\x7F\[\]<>]", "g")
	return copytext_char(trim(unsafe_characters.Replace(text, " ")), 1, max_length + 1)

/// The approved player-made voice this character speaks with instead of the regular voice. Donors only.
/datum/preference/text/tts_custom_voice
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "tts_custom_voice"
	maximum_value_length = 64
	can_randomize = FALSE
	// After the regular voice, which this overrides.
	priority = PREFERENCE_PRORITY_LATE_BODY_TYPE

/datum/preference/text/tts_custom_voice/create_default_value()
	return ""

/datum/preference/text/tts_custom_voice/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!length(value) || !preferences)
		return
	if(preferences.read_preference(/datum/preference/choiced/vocals/voice_type) != VOICE_TYPE_TTS)
		return
	if(SStts.can_use_custom_voice(preferences.parent, value))
		target.voice = value

GLOBAL_LIST_EMPTY(tts_voice_studios)

/// Donor window for designing and cloning voices.
/datum/tts_voice_studio
	/// Ckey of the player this studio belongs to.
	var/owner_ckey
	/// The player's voices, as the TTS server last reported them.
	var/list/voices = list()
	/// Whether a request to the TTS server is in flight.
	var/busy = FALSE
	/// Feedback for the last action.
	var/message
	var/message_is_error = FALSE

/datum/tts_voice_studio/New(client/owner)
	. = ..()
	owner_ckey = owner.ckey

/// Opens the studio for `user`.
/proc/open_tts_voice_studio(mob/user)
	if(!user?.client)
		return
	var/datum/tts_voice_studio/studio = GLOB.tts_voice_studios[user.ckey]
	if(!studio)
		studio = new(user.client)
		GLOB.tts_voice_studios[user.ckey] = studio
	studio.ui_interact(user)
	INVOKE_ASYNC(studio, TYPE_PROC_REF(/datum/tts_voice_studio, refresh))

/datum/tts_voice_studio/ui_state(mob/user)
	return GLOB.always_state

/datum/tts_voice_studio/ui_status(mob/user, datum/ui_state/state)
	if(user.ckey != owner_ckey)
		return UI_CLOSE
	return ..()

/datum/tts_voice_studio/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TtsVoiceStudio")
		ui.open()

/datum/tts_voice_studio/ui_static_data(mob/user)
	return list(
		"consent" = TTS_VOICE_CONSENT,
		"max_prompt_length" = TTS_MAX_VOICE_PROMPT_LENGTH,
		"max_name_length" = TTS_MAX_VOICE_NAME_LENGTH,
		"max_upload_mb" = TTS_MAX_RECORDING_BYTES / (1024 * 1024),
	)

/datum/tts_voice_studio/ui_data(mob/user)
	var/datum/preferences/prefs = user.client?.prefs
	return list(
		"donor" = !!(user.client && SSplayer_ranks.is_donator(user.client)),
		"enabled" = SStts.tts_enabled && SStts.custom_voices_enabled,
		"busy" = busy,
		"message" = message,
		"message_is_error" = message_is_error,
		"voices" = voices,
		"selected" = prefs?.read_preference(/datum/preference/text/tts_custom_voice),
		"character" = prefs?.read_preference(/datum/preference/name/real_name),
	)

/datum/tts_voice_studio/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	if(busy)
		return TRUE
	var/is_donor = user.client && SSplayer_ranks.is_donator(user.client)
	switch(action)
		if("refresh")
			INVOKE_ASYNC(src, PROC_REF(refresh))
		if("preview")
			INVOKE_ASYNC(src, PROC_REF(play_preview), user, params["id"])
		if("design")
			if(!is_donor)
				return TRUE
			INVOKE_ASYNC(src, PROC_REF(design), user, params["name"], params["prompt"])
		if("upload")
			if(!is_donor || !params["consent"])
				return TRUE
			INVOKE_ASYNC(src, PROC_REF(upload), user, params["name"])
		if("use")
			if(!is_donor)
				return TRUE
			use_voice(user, params["id"])
		if("stop_using")
			use_voice(user, "")
		if("delete")
			INVOKE_ASYNC(src, PROC_REF(delete_voice), user, params["id"])
	return TRUE

/datum/tts_voice_studio/proc/set_message(text, is_error = FALSE)
	message = text
	message_is_error = is_error
	SStgui.update_uis(src)

/// Reloads the player's voices from the TTS server. This is blocking.
/datum/tts_voice_studio/proc/refresh()
	if(!SStts.custom_voices_enabled)
		return
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_GET, "custom-voices?ckey=[url_encode(owner_ckey)]")
	if(result[3])
		set_message(result[3], TRUE)
		return
	voices = islist(result[2]) ? result[2] : list()
	SStts.refresh_custom_voices()
	SStgui.update_uis(src)

/// Runs a request with the busy flag up, then reloads the voice list.
/datum/tts_voice_studio/proc/finish(list/result, success_message)
	busy = FALSE
	if(result[3])
		set_message(result[3], TRUE)
	else
		set_message(success_message)
	refresh()

/datum/tts_voice_studio/proc/design(mob/user, name, prompt)
	name = tts_sanitize_custom_voice_text(name, TTS_MAX_VOICE_NAME_LENGTH)
	prompt = tts_sanitize_custom_voice_text(prompt, TTS_MAX_VOICE_PROMPT_LENGTH)
	if(!length(name) || !length(prompt))
		set_message("请填写音色名称和声音描述。", TRUE)
		return
	busy = TRUE
	set_message("正在生成音色，大约需要十几秒……")
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_POST, "custom-voices/design?ckey=[url_encode(owner_ckey)]&name=[url_encode(name)]", json_encode(list("prompt" = prompt)))
	if(!result[3])
		log_game("[key_name(user)] designed a custom TTS voice \"[name]\": [prompt]")
		message_admins("[key_name_admin(user)] 设计了定制音色「[name]」，等待审核（管理员菜单「审核定制音色」）。")
	finish(result, "音色已生成，可以先试听。管理员审核通过后才能在游戏里使用。")

/datum/tts_voice_studio/proc/upload(mob/user, name)
	name = tts_sanitize_custom_voice_text(name, TTS_MAX_VOICE_NAME_LENGTH)
	if(!length(name))
		set_message("请先填写音色名称。", TRUE)
		return
	busy = TRUE
	SStgui.update_uis(src)
	var/recording = input(user, "选择一段 10~20 秒、只有你本人清晰说话的录音（WAV/MP3/M4A/OGG/FLAC，不超过 [TTS_MAX_RECORDING_BYTES / (1024 * 1024)] MB）。", "上传录音") as null|file
	if(!recording)
		busy = FALSE
		set_message(null)
		return
	if(length(recording) > TTS_MAX_RECORDING_BYTES)
		busy = FALSE
		set_message("录音文件太大了。", TRUE)
		return
	set_message("正在上传录音并复刻音色，大约需要半分钟……")
	var/path = "[TTS_UPLOAD_DIR][owner_ckey]-[world.realtime].upload"
	if(!fexists("[TTS_UPLOAD_DIR]readme.txt"))
		rustg_file_write("Recordings waiting to be sent to the TTS server. Deleted right after sending.", "[TTS_UPLOAD_DIR]readme.txt")
	if(!fcopy(recording, path))
		busy = FALSE
		set_message("无法保存录音文件。", TRUE)
		return
	var/list/headers = list("X-Voice-Consent" = "consent=[url_encode(TTS_VOICE_CONSENT)]")
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_POST, "custom-voices/recording?ckey=[url_encode(owner_ckey)]&name=[url_encode(name)]", "", path, null, headers)
	fdel(path)
	if(!result[3])
		log_game("[key_name(user)] uploaded a recording for custom TTS voice \"[name]\" and accepted the consent statement.")
		message_admins("[key_name_admin(user)] 上传了复刻音色「[name]」的录音，等待审核（管理员菜单「审核定制音色」）。")
	finish(result, "音色已复刻，可以先试听。管理员审核通过后才能在游戏里使用。")

/datum/tts_voice_studio/proc/play_preview(mob/user, id)
	tts_play_custom_voice_preview(user, id)

/datum/tts_voice_studio/proc/use_voice(mob/user, id)
	var/datum/preferences/prefs = user.client?.prefs
	if(!prefs)
		return
	if(length(id) && !SStts.can_use_custom_voice(user.client, id))
		set_message("这个音色还不能使用：需要先通过审核。", TRUE)
		return
	prefs.write_preference(GLOB.preference_entries[/datum/preference/text/tts_custom_voice], id)
	prefs.save_character()
	// Speak with it right away if the player is in a body made from this character.
	var/mob/living/carbon/human/body = user
	if(ishuman(body) && body.real_name == prefs.read_preference(/datum/preference/name/real_name) && prefs.read_preference(/datum/preference/choiced/vocals/voice_type) == VOICE_TYPE_TTS)
		if(length(id))
			body.voice = id
		else
			var/datum/preference/voice_preference = GLOB.preference_entries[/datum/preference/choiced/voice]
			voice_preference.apply_to_human(body, prefs.read_preference(/datum/preference/choiced/voice), prefs)
	set_message(length(id) ? "当前角色已改用这个音色。" : "当前角色已改回普通音色。")

/datum/tts_voice_studio/proc/delete_voice(mob/user, id)
	if(!istext(id))
		return
	busy = TRUE
	SStgui.update_uis(src)
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_POST, "custom-voices/[url_encode(id)]/delete?ckey=[url_encode(owner_ckey)]")
	if(!result[3] && user.client?.prefs?.read_preference(/datum/preference/text/tts_custom_voice) == id)
		use_voice(user, "")
	finish(result, "音色已删除。")

/// Downloads a custom voice's preview, or with `recording` the uploaded recording behind a
/// cloned voice, and plays it to `user`. This is blocking.
/proc/tts_play_custom_voice_preview(mob/user, id, recording = FALSE)
	if(!istext(id) || !user?.client)
		return
	var/file = "tmp/tts/custom_voice_preview_[sha1("[id][world.time]")].ogg"
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_GET, "custom-voices/[url_encode(id)]/[recording ? "recording" : "preview"]", output_file = file)
	if(result[3])
		to_chat(user, span_warning(result[3]))
		return
	var/sound/preview = new(file)
	SEND_SOUND(user, preview)

GLOBAL_DATUM_INIT(tts_voice_review, /datum/tts_voice_review, new)

/// Admin window for reviewing player-made voices.
/datum/tts_voice_review
	var/list/voices = list()
	var/busy = FALSE
	var/message
	var/message_is_error = FALSE

ADMIN_VERB(review_custom_tts_voices, R_ADMIN, "审核定制音色", "Review donor-made TTS voices before they can be used.", ADMIN_CATEGORY_MAIN)
	GLOB.tts_voice_review.ui_interact(user.mob)
	INVOKE_ASYNC(GLOB.tts_voice_review, TYPE_PROC_REF(/datum/tts_voice_review, refresh))

/datum/tts_voice_review/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/tts_voice_review/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TtsVoiceReview")
		ui.open()

/datum/tts_voice_review/ui_data(mob/user)
	return list(
		"enabled" = SStts.tts_enabled && SStts.custom_voices_enabled,
		"busy" = busy,
		"message" = message,
		"message_is_error" = message_is_error,
		"voices" = voices,
	)

/datum/tts_voice_review/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	if(busy)
		return TRUE
	switch(action)
		if("refresh")
			INVOKE_ASYNC(src, PROC_REF(refresh))
		if("preview")
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_play_custom_voice_preview), user, params["id"])
		if("recording")
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_play_custom_voice_preview), user, params["id"], TRUE)
		if("approve")
			INVOKE_ASYNC(src, PROC_REF(approve), user, params["id"])
		if("reject")
			INVOKE_ASYNC(src, PROC_REF(reject), user, params["id"])
		if("delete")
			INVOKE_ASYNC(src, PROC_REF(delete_voice), user, params["id"])
	return TRUE

/datum/tts_voice_review/proc/set_message(text, is_error = FALSE)
	message = text
	message_is_error = is_error
	SStgui.update_uis(src)

/// Reloads every player-made voice. This is blocking.
/datum/tts_voice_review/proc/refresh()
	if(!SStts.custom_voices_enabled)
		return
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_GET, "custom-voices")
	if(result[3])
		set_message(result[3], TRUE)
		return
	voices = islist(result[2]) ? result[2] : list()
	SStts.refresh_custom_voices()
	SStgui.update_uis(src)

/datum/tts_voice_review/proc/finish(list/result, success_message)
	busy = FALSE
	if(result[3])
		set_message(result[3], TRUE)
	else
		set_message(success_message)
	refresh()

/// Tells a voice's owner what happened to it, if they are online.
/datum/tts_voice_review/proc/notify_owner(list/voice, text)
	var/client/owner = GLOB.directory[voice?["ckey"]]
	if(owner)
		to_chat(owner, span_boldnotice(text))

/datum/tts_voice_review/proc/find_voice(id)
	for(var/list/voice in voices)
		if(voice["id"] == id)
			return voice

/datum/tts_voice_review/proc/approve(mob/user, id)
	var/list/voice = find_voice(id)
	if(!voice)
		return
	busy = TRUE
	SStgui.update_uis(src)
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_POST, "custom-voices/[url_encode(id)]/approve?admin=[url_encode(user.ckey)]")
	if(!result[3])
		log_admin("[key_name(user)] approved custom TTS voice \"[voice["name"]]\" ([id]) of [voice["ckey"]].")
		message_admins("[key_name_admin(user)] 通过了 [voice["ckey"]] 的定制音色「[voice["name"]]」。")
		notify_owner(voice, "你的定制音色「[voice["name"]]」已通过审核，可以在「定制音色」里启用了。")
	finish(result, "已通过。")

/datum/tts_voice_review/proc/reject(mob/user, id)
	var/list/voice = find_voice(id)
	if(!voice)
		return
	var/reason = tgui_input_text(user, "拒绝「[voice["name"]]」的理由（会告诉玩家）：", "拒绝定制音色", max_length = 200, encode = FALSE)
	if(!reason)
		return
	busy = TRUE
	SStgui.update_uis(src)
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_POST, "custom-voices/[url_encode(id)]/reject?admin=[url_encode(user.ckey)]&reason=[url_encode(tts_sanitize_custom_voice_text(reason, 200))]")
	if(!result[3])
		log_admin("[key_name(user)] rejected custom TTS voice \"[voice["name"]]\" ([id]) of [voice["ckey"]]: [reason]")
		message_admins("[key_name_admin(user)] 拒绝了 [voice["ckey"]] 的定制音色「[voice["name"]]」：[reason]")
		notify_owner(voice, "你的定制音色「[voice["name"]]」未通过审核：[reason]")
	finish(result, "已拒绝。")

/datum/tts_voice_review/proc/delete_voice(mob/user, id)
	var/list/voice = find_voice(id)
	if(!voice)
		return
	if(tgui_alert(user, "永久删除 [voice["ckey"]] 的音色「[voice["name"]]」？", "删除定制音色", list("删除", "取消")) != "删除")
		return
	busy = TRUE
	SStgui.update_uis(src)
	var/list/result = SStts.custom_voice_call(RUSTG_HTTP_METHOD_POST, "custom-voices/[url_encode(id)]/delete")
	if(!result[3])
		log_admin("[key_name(user)] deleted custom TTS voice \"[voice["name"]]\" ([id]) of [voice["ckey"]].")
		message_admins("[key_name_admin(user)] 删除了 [voice["ckey"]] 的定制音色「[voice["name"]]」。")
	finish(result, "已删除。")

/client/verb/tts_voice_studio()
	set name = "定制音色"
	set category = "OOC"
	set desc = "Design or clone a TTS voice for your characters (donors)."
	open_tts_voice_studio(mob)
