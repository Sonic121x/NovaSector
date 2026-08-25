/proc/tts_speech_filter(text)
	// NOVA EDIT REMOVAL - ADMIN - ORIGINAL: // Only allow alphanumeric characters and whitespace
	// NOVA EDIT REMOVAL - ADMIN - ORIGINAL: var/static/regex/bad_chars_regex = regex("\[^a-zA-Z0-9 ,?.!'&-]", "g")
	// NOVA EDIT REMOVAL - ADMIN - ORIGINAL: return bad_chars_regex.Replace(text, " ")
	// NOVA EDIT ADDITION START - ADMIN - Preserve printable Unicode for external TTS providers.
	var/static/regex/control_characters = regex(@"[\x00-\x1F\x7F]", "g")
	return control_characters.Replace(text, " ")
	// NOVA EDIT ADDITION END

// NOVA EDIT ADDITION START - ADMIN - Allow CJK speech while retaining the punctuation-only guard.
/// Returns whether text contains content worth synthesizing.
/proc/tts_has_speech_content(text)
	var/static/regex/speech_characters = regex(@"[A-Za-z0-9一-鿿]")
	return speech_characters.Find(text) != 0
// NOVA EDIT ADDITION END

// NOVA EDIT ADDITION START - ADMIN - Speak global station announcements through TTS.
/// Builds plain speech from an announcement title and HTML-formatted body.
/proc/tts_prepare_announcement_message(message, title)
	if(!istext(message))
		return
	var/speech_message = ""
	if(istext(title) && length(title))
		speech_message = "[title]. "
	speech_message += message
	speech_message = html_decode(STRIP_HTML_SIMPLE(speech_message, MAX_MESSAGE_LEN))
	return tts_speech_filter(speech_message)

/// Queues a non-positional TTS announcement and returns whether it was accepted.
/proc/tts_queue_global_announcement(message, title, list/players = GLOB.player_list, speaker_override)
	if(isnull(SStts) || !SStts.is_runtime_enabled() || !istext(message))
		return FALSE

	var/list/listeners = list()
	for(var/mob/player as anything in players)
		if(isnewplayer(player) || HAS_TRAIT(player, TRAIT_DEAF) || !player.client)
			continue
		if(!player.client.prefs.read_preference(/datum/preference/toggle/sound_announcements))
			continue
		listeners += player
	if(!length(listeners))
		return FALSE

	var/speech_message = tts_prepare_announcement_message(message, title)
	if(!tts_has_speech_content(speech_message))
		return FALSE

	var/speaker = speaker_override
	if(!(speaker in SStts.available_speakers))
		speaker = SStts.computer_voice
	if(!(speaker in SStts.available_speakers))
		speaker = SStts.random_tts_voice()
	if(!speaker)
		return FALSE

	var/cache_key = "[speaker]-[speech_message]"
	var/identifier = "[sha1(cache_key)].[world.time]"
	var/datum/language/common_language = GLOB.language_datum_instances[/datum/language/common]
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), SSstation, speech_message, common_language, speaker, "", listeners, station_wide = TRUE, identifier = identifier)
	return TRUE
// NOVA EDIT ADDITION END

/proc/tts_gibberish_speech_filter(text)
	// Only allow alphanumeric characters and whitespace
	var/static/regex/bad_chars_regex = regex("\[^a-zA-Z0-9 ,?.!'&-]", "g")
	return bad_chars_regex.Replace(text, "#")

/proc/tts_filter_encode(text, speaker, pitch, blips = FALSE)
	text = replacetext(text, "%PITCH%", SStts.pitch_enabled ? pitch : 0)
	text = replacetext(text, "%FEMALE%", !!findtext(speaker, "Woman"))
	text = replacetext(text, "%BLIPS%", blips)
	return url_encode(text)
