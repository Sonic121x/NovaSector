// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
GAME_VERB(/mob, request_internet_sound, "请求互联网音效", "OOC")
	if(!CONFIG_GET(flag/request_internet_sound))
		to_chat(usr, span_danger(LANG("mob.34d73204", null)), confidential = TRUE)
		return

	var/request_url = tgui_input_text(usr, LANG("mob.bd1a1916", list(replacetext(replacetext(CONFIG_GET(string/request_internet_allowed), "\\", ""), ",", ", "))), LANG("mob.513492bc", null))
	if(!request_url)
		return

	var/regex/allowed_regex = regex(replacetext(CONFIG_GET(string/request_internet_allowed), ",", "|"), "i")
	if(!allowed_regex.Find(request_url))
		to_chat(usr, span_danger(LANG("mob.c3fdf371", list(replacetext(CONFIG_GET(string/request_internet_allowed), "\\", " ")))), confidential = TRUE)
		return

	var/credit = tgui_alert(usr, LANG("mob.7ab8bf08", list(usr.ckey)), LANG("mob.eda2ecd3", null), list("No", "Yes", "Cancel"))

	if(credit == "Cancel" || isnull(credit))
		return

	else if (credit == "Yes")
		credit = "[usr.ckey] requested this track."
	else
		credit = null

	log_internet_request("[src.key]/([src.name]): [request_url]")
	if(usr.client)
		if(usr.client.prefs.muted & MUTE_INTERNET_REQUEST)
			to_chat(usr, span_danger(LANG("mob.5567cd98", null)), confidential = TRUE)
			return
		if(src.client.handle_spam_prevention(request_url,MUTE_INTERNET_REQUEST))
			return

	GLOB.requests.music_request(usr.client, request_url, credit)
	to_chat(usr, span_info(LANG("mob.04a6d62d", list(span_linkify(request_url)))), confidential = TRUE)

	var/list/admin_message = list()
	admin_message += ("[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)] has requested the following to be played:<br>")
	admin_message += ("[span_linkify(request_url)] [ADMIN_PLAY_INTERNET(request_url, credit)]")

	for(var/client/admin_client in GLOB.admins)
		if(get_chat_toggles(admin_client) & CHAT_PRAYER)
			to_chat(admin_client, fieldset_block("Internet sound requested", jointext(admin_message, ""), "boxed_message"), type = MESSAGE_TYPE_PRAYER, confidential = TRUE)

	SSblackbox.record_feedback("tally", "music_request", 1, "Music Request") // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!
