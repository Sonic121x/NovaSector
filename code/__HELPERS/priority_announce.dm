// please don't use these defines outside of this file in order to ensure a unified framework. unless you have a really good reason to make them global, then whatever

// these four are just text spans that furnish the TEXT itself with the appropriate CSS classes
#define MAJOR_ANNOUNCEMENT_TITLE(string) ("<span class='major_announcement_title'>" + string + "</span>")
#define SUBHEADER_ANNOUNCEMENT_TITLE(string) ("<span class='subheader_announcement_text'>" + string + "</span>")
#define MAJOR_ANNOUNCEMENT_TEXT(string) ("<span class='major_announcement_text'>" + string + "</span>")
#define MINOR_ANNOUNCEMENT_TITLE(string) ("<span class='minor_announcement_title'>" + string + "</span>")
#define MINOR_ANNOUNCEMENT_TEXT(string) ("<span class='minor_announcement_text'>" + string + "</span>")

#define ANNOUNCEMENT_HEADER(string) ("<span class='announcement_header'>" + string + "</span>")

// these two are the ones that actually give the striped background
#define CHAT_ALERT_DEFAULT_SPAN(string) ("<div class='chat_alert_default'>" + string + "</div>")
#define CHAT_ALERT_COLORED_SPAN(color, string) ("<div class='chat_alert_" + color + "'>" + string + "</div>")

#define ANNOUNCEMENT_COLORS list("default", "green", "blue", "pink", "yellow", "orange", "red", "purple")

/**
 * Make a big red text announcement to
 *
 * Formatted like:
 *
 * " Message from sender "
 *
 * " Title "
 *
 * " Text "
 *
 * Arguments
 * * text - required, the text to announce
 * * title - optional, the title of the announcement.
 * * sound - optional, the sound played accompanying the announcement
 * * type - optional, the type of the announcement, for some "preset" announcement templates. See __DEFINES/announcements.dm
 * * sender_override - optional, modifies the sender of the announcement
 * * has_important_message - is this message critical to the game (and should not be overridden by station traits), or not
 * * players - a list of all players to send the message to. defaults to all players (not including new players)
 * * encode_title - if TRUE, the title will be HTML encoded
 * * encode_text - if TRUE, the text will be HTML encoded
 * * tts_speaker - optional voice identifier for player-authored announcements; invalid values fall back to the system voice
 */
/proc/priority_announce(text, title = "", sound, type, sender_override, has_important_message = FALSE, list/mob/players = GLOB.player_list, encode_title = TRUE, encode_text = TRUE, color_override, tts_speaker) // NOVA EDIT CHANGE - ADMIN - Added optional player-authored TTS voice.
	if(!text)
		return

	// NOVA EDIT ADDITION START - i18n: 公告非 sink，正文/标题靠运行时反查翻译。
	// 在 html_encode 之前做（目录键是未转义英文）：整串命中→译文；否则 AC 子串尽力翻动态正文。
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		if(istext(title) && length(title) > 0)
			var/translated_title = lang_reverse_text(title)
			title = (translated_title != title) ? translated_title : lang_fallback_apply(title)
		if(istext(text))
			var/translated_text = lang_reverse_text(text)
			text = (translated_text != text) ? translated_text : lang_fallback_apply(text)
	// NOVA EDIT ADDITION END

	// NOVA EDIT ADDITION START - ADMIN - Replace prerecorded English announcement speech with localized TTS.
	var/tts_queued = tts_queue_global_announcement(text, title, players, tts_speaker)
	// NOVA EDIT ADDITION END

	if(encode_title && title && length(title) > 0)
		title = html_encode(title)
		title = html_encode(title)
	if(encode_text)
		text = html_encode(text)
		if(!length(text))
			return

	var/list/announcement_strings = list()

	// NOVA EDIT ADDITION START - ADMIN - Both of these have to be read before the key is resolved
	// into a file: event_alert is the only signal for how urgent this announcement is, and an
	// explicitly picked sound (admin command report, a module's own effect) must survive untouched.
	var/event_alert = !isnull(sound) && !isnull(SSstation.announcer.event_sounds[sound])
	var/announcer_speech = tts_sound_is_announcer_speech(sound)
	// NOVA EDIT ADDITION END
	if(!sound)
		sound = SSstation.announcer.get_rand_alert_sound()
	else if(SSstation.announcer.event_sounds[sound])
		sound = SSstation.announcer.event_sounds[sound]
	// NOVA EDIT ADDITION START - ADMIN - Keep only a nonverbal cue when TTS carries the announcement.
	// The announcer sounds are all spoken English lines, so they cannot play under the synthesized
	// speech - but they are not interchangeable either, so pick a cue that keeps the distinction.
	if(tts_queued && announcer_speech)
		sound = tts_priority_announcement_cue(urgent = event_alert, hostile = (type == ANNOUNCEMENT_TYPE_SYNDICATE))
	// NOVA EDIT ADDITION END

	var/header
	switch(type)
		if(ANNOUNCEMENT_TYPE_PRIORITY)
			header = MAJOR_ANNOUNCEMENT_TITLE(lang_reverse_text("Priority Announcement")) // NOVA EDIT - i18n: 反查公告标题（词进 ui.json）
			if(length(title) > 0)
				header += SUBHEADER_ANNOUNCEMENT_TITLE(title)
		if(ANNOUNCEMENT_TYPE_CAPTAIN)
			header = MAJOR_ANNOUNCEMENT_TITLE(lang_reverse_text("Captain's Announcement")) // NOVA EDIT - i18n: 反查公告标题
			GLOB.news_network.submit_article(text, "Captain's Announcement", NEWSCASTER_STATION_ANNOUNCEMENTS, null)
		if(ANNOUNCEMENT_TYPE_SYNDICATE)
			header = MAJOR_ANNOUNCEMENT_TITLE(lang_reverse_text("Syndicate Captain's Announcement")) // NOVA EDIT - i18n: 反查公告标题
		else
			header += generate_unique_announcement_header(title, sender_override)

	announcement_strings += ANNOUNCEMENT_HEADER(header)

	///If the announcer overrides alert messages, use that message.
	if(SSstation.announcer.custom_alert_message && !has_important_message)
		// NOVA EDIT CHANGE - I18N: 播音员的自定义提示语是**编译期 span_alert() 包裹**的类型变量，
		// 目录里存的是里层裸串 → 整串直接发出去必然 miss 反查，只剩 AC 子串兜底把 "important" 单词
		// 替换成「重要」，其余留英文（表现：「Please stand by for an 重要message from our new intern.」）。
		// lang_reverse_text 本身会剥单层 span 再查内层，这里补上调用即可。ORIGINAL: MAJOR_ANNOUNCEMENT_TEXT(SSstation.announcer.custom_alert_message)
		announcement_strings += MAJOR_ANNOUNCEMENT_TEXT(lang_reverse_text(SSstation.announcer.custom_alert_message))
	else
		announcement_strings += MAJOR_ANNOUNCEMENT_TEXT(text)

	var/finalized_announcement
	if(color_override)
		finalized_announcement = CHAT_ALERT_COLORED_SPAN(color_override, jointext(announcement_strings, ""))
	else
		finalized_announcement = CHAT_ALERT_DEFAULT_SPAN(jointext(announcement_strings, ""))

	dispatch_announcement_to_players(finalized_announcement, players, sound)

	if(isnull(sender_override) && players == GLOB.player_list)
		if(length(title) > 0)
			GLOB.news_network.submit_article(title + "<br><br>" + text, "[command_name()]", NEWSCASTER_STATION_ANNOUNCEMENTS, null)
		else
			GLOB.news_network.submit_article(text, "[command_name()] Update", NEWSCASTER_STATION_ANNOUNCEMENTS, null)

/**
 * Print a report to all the communications consoles, and optionally send an announcement to players about it. This is used for the roundstart report, but can also be used for other reports in the future.
 *
 * * text - the text of the report to print
 * * title - the title of the report, which is also the name of the printed paper.
 * If null, defaults to "Classified [command_name()] Update"
 * * announce - whether or not to send an announcement to players about the report being printed.
 * Defaults to TRUE.
 * * contains_advanced_html - whether or not the text contains advanced HTML that should be rendered on the paper.
 * Advanced HTML (currently) only includes <img> tags, but may include other tags in the future.
 * Do not allow player inputted reports to contain advanced HTML.
 * Defaults to FALSE, which means only basic HTML will be rendered.
 */
/proc/print_command_report(text = "", title = null, announce = TRUE, contains_advanced_html = FALSE)
	if(!title)
		title = "Classified [command_name()] Update"

	if(announce)
		priority_announce(
			text = "A report has been downloaded and printed out at all communications consoles.",
			title = "Incoming Classified Message",
			sound = SSstation.announcer.get_rand_report_sound(),
			has_important_message = TRUE,
		)

	// NOVA EDIT ADDITION START - I18N - 指挥报告（生成纸张/发到通讯台）正文是多段运行期拼接（威胁等级公告、
	// 特别订单 station_goal.get_report()、station_trait.get_report() 报告、各 LANG 段），整串 reverse 够不着。
	// 过边界模板引擎（插值段 {0} 模板整句命中）+ 字面 AC（多词短语兜底）；威胁公告整块已在 communications.dm
	// 拼接前整串反查为中文，此处不再被 AC 蚕食。locale==en 时 lang_fallback_apply 原样返回（零开销）。
	text = lang_fallback_apply(text)
	// NOVA EDIT ADDITION END
	var/datum/comm_message/message = new
	message.title = title
	message.content = text

	GLOB.communications_controller.send_message(message, contains_advanced_html = contains_advanced_html)

/**
 * Sends a minor annoucement to players.
 * Minor announcements are large text, with the title in red and message in white.
 * Only mobs that can hear can see the announcements.
 *
 * message - the message contents of the announcement.
 * title - the title of the announcement, which is often "who sent it".
 * alert - whether this announcement is an alert, or just a notice. Only changes the sound that is played by default.
 * html_encode - if TRUE, we will html encode our title and message before sending it, to prevent player input abuse.
 * players - optional, a list mobs to send the announcement to. If unset, sends to all palyers.
 * sound_override - optional, use the passed sound file instead of the default notice sounds.
 * should_play_sound - Whether the notice sound should be played or not. This can also be a callback, if you only want mobs to hear the sound based off of specific criteria.
 * color_override - optional, use the passed color instead of the default notice color.
 * tts_speaker - optional voice identifier for player-authored announcements; invalid values fall back to the system voice
 */
/proc/minor_announce(message, title = "Attention:", alert = FALSE, html_encode = TRUE, list/players, sound_override, should_play_sound = TRUE, color_override, tts_speaker) // NOVA EDIT CHANGE - ADMIN - Added optional player-authored TTS voice.
	if(!message)
		return

	// NOVA EDIT ADDITION START - i18n: 同 priority_announce，html_encode 前反查正文/标题。
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		if(istext(title) && length(title) > 0)
			var/translated_title = lang_reverse_text(title)
			title = (translated_title != title) ? translated_title : lang_fallback_apply(title)
		if(istext(message))
			var/translated_message = lang_reverse_text(message)
			message = (translated_message != message) ? translated_message : lang_fallback_apply(message)
	// NOVA EDIT ADDITION END

	// NOVA EDIT ADDITION START - ADMIN - Preserve deliberately silent/callback announcements.
	var/tts_queued = (should_play_sound == TRUE) && tts_queue_global_announcement(message, title, isnull(players) ? GLOB.player_list : players, tts_speaker)
	// NOVA EDIT ADDITION END

	if (html_encode)
		title = html_encode(title)
		message = html_encode(message)

	var/list/minor_announcement_strings = list()
	if(title != null && title != "")
		minor_announcement_strings += ANNOUNCEMENT_HEADER(MINOR_ANNOUNCEMENT_TITLE(title))
	minor_announcement_strings += MINOR_ANNOUNCEMENT_TEXT(message)

	var/finalized_announcement
	if(color_override)
		finalized_announcement = CHAT_ALERT_COLORED_SPAN(color_override, jointext(minor_announcement_strings, ""))
	else
		finalized_announcement = CHAT_ALERT_DEFAULT_SPAN(jointext(minor_announcement_strings, ""))

	var/custom_sound = sound_override || (tts_queued ? tts_minor_announcement_cue(alert) : null) || (alert ? 'modular_nova/modules/alerts/sound/alerts/alert1.ogg' : 'sound/announcer/notice/notice2.ogg') // NOVA EDIT CHANGE - ADMIN - TTS replaces prerecorded speech. CUSTOM ANNOUNCEMENTS ORIGINAL: var/custom_sound = sound_override || (alert ? 'sound/announcer/notice/notice1.ogg' : 'sound/announcer/notice/notice2.ogg')
	dispatch_announcement_to_players(finalized_announcement, players, custom_sound, should_play_sound)

/// Sends an announcement about the level changing to players. Uses the passed in datum and the subsystem's previous security level to generate the message.
/proc/level_announce(datum/security_level/selected_level, previous_level_number)
	var/current_level_number = selected_level.number_level
	var/current_level_name = selected_level.name
	var/current_level_color = selected_level.announcement_color
	var/current_level_sound = selected_level.sound

	var/title
	var/message

	if(current_level_number > previous_level_number)
		title = LANG("datum.b89256636145aa75", list(current_level_name)) // NOVA EDIT CHANGE - I18N - ORIGINAL: title = "Attention! Security level elevated to [current_level_name]:"
		message = selected_level.elevating_to_announcement
	else
		title = LANG("datum.9aa16b5dfe73dfdd", list(current_level_name)) // NOVA EDIT CHANGE - I18N - ORIGINAL: title = "Attention! Security level lowered to [current_level_name]:"
		message = selected_level.lowering_to_announcement

	// NOVA EDIT ADDITION START - ADMIN - Security-level messages use localized TTS. The level's own
	// sound is a plain alarm tone ("Friendly beep" / "Angry alarm" / air raid), not a spoken line,
	// so it plays under the speech and is deliberately left alone.
	tts_queue_global_announcement(message, title, GLOB.player_list)
	// NOVA EDIT ADDITION END

	var/list/level_announcement_strings = list()
	level_announcement_strings += ANNOUNCEMENT_HEADER(MINOR_ANNOUNCEMENT_TITLE(title))
	level_announcement_strings += MINOR_ANNOUNCEMENT_TEXT(message)

	var/finalized_announcement = CHAT_ALERT_COLORED_SPAN(current_level_color, jointext(level_announcement_strings, ""))

	dispatch_announcement_to_players(finalized_announcement, GLOB.player_list, current_level_sound)

/// Proc that just generates a custom header based on variables fed into `priority_announce()`
/// Will return a string.
/proc/generate_unique_announcement_header(title, sender_override)
	var/list/returnable_strings = list()
	if(isnull(sender_override))
		returnable_strings += MAJOR_ANNOUNCEMENT_TITLE("[command_name()] [lang_reverse_text("Update")]") // NOVA EDIT - i18n: 反查 "Update" 后缀（command_name 经聊天 AC 反查）
	else
		returnable_strings += MAJOR_ANNOUNCEMENT_TITLE(sender_override)

	if(length(title) > 0)
		returnable_strings += SUBHEADER_ANNOUNCEMENT_TITLE(title)

	return jointext(returnable_strings, "")

/// Proc that just dispatches the announcement to our applicable audience. Only the announcement is a mandatory arg.
/// `should_play_sound` can also be a callback, if you want to only play the sound to specific players.
/proc/dispatch_announcement_to_players(announcement, list/players = GLOB.player_list, sound_override = null, should_play_sound = TRUE)
	// NOVA EDIT CHANGE BEGIN - CUSTOM ANNOUNCEMENTS
	/* Original:

	var/sound_to_play = !isnull(sound_override) ? sound_override : 'sound/announcer/notice/notice2.ogg'

	var/datum/callback/should_play_sound_callback = astype(should_play_sound)

	for(var/mob/target in players)
		if(isnewplayer(target) || HAS_TRAIT(target, TRAIT_DEAF))
			continue

		to_chat(target, announcement)
		if(!should_play_sound || (should_play_sound_callback && !should_play_sound_callback.Invoke(target)))
			continue
		if(target.client?.prefs.read_preference(/datum/preference/toggle/sound_announcements))
			SEND_SOUND(target, sound(sound_to_play))
	*/
	if(!sound_override)
		sound_override = SSstation.announcer.get_rand_alert_sound()
	else if(SSstation.announcer.event_sounds[sound_override])
		var/list/announcer_key = SSstation.announcer.event_sounds[sound_override]
		sound_override = pick(announcer_key)

	if(!isnull(sound_override))
		sound_override = sound(sound_override)

	var/sound_to_play = !isnull(sound_override) ? sound_override : 'sound/announcer/notice/notice2.ogg'
	// NOVA EDIT ADDITION START - ADMIN - Restore per-player sound gating removed by the custom dispatcher.
	var/datum/callback/should_play_sound_callback = astype(should_play_sound)
	var/list/sound_players = list()
	for(var/mob/target in players)
		if(isnewplayer(target) || HAS_TRAIT(target, TRAIT_DEAF))
			continue

		to_chat(target, announcement)
		if(!should_play_sound || (should_play_sound_callback && !should_play_sound_callback.Invoke(target)))
			continue
		if(target.client?.prefs.read_preference(/datum/preference/toggle/sound_announcements))
			sound_players += target

	if(length(sound_players))
		alert_sound_to_playing(sound_to_play, players = sound_players)
	// NOVA EDIT ADDITION END
	// NOVA EDIT CHANGE END - CUSTOM ANNOUNCEMENTS

#undef MAJOR_ANNOUNCEMENT_TITLE
#undef MAJOR_ANNOUNCEMENT_TEXT
#undef MINOR_ANNOUNCEMENT_TITLE
#undef MINOR_ANNOUNCEMENT_TEXT
#undef CHAT_ALERT_DEFAULT_SPAN
#undef CHAT_ALERT_COLORED_SPAN
