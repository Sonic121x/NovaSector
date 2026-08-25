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
	// Line breaks separate sentences in command reports; without a space the tags around them
	// would weld the last word of one line onto the first word of the next.
	var/static/regex/line_break_tags = regex(@"<\s*/?\s*br\s*/?\s*>", "gi")
	speech_message = line_break_tags.Replace(speech_message, " ")
	// STRIP_HTML_SIMPLE only drops the angle brackets, so the announcer read the tag names out
	// loud ("b 通知正文 /b"). STRIP_HTML_FULL removes the whole tag.
	speech_message = html_decode(STRIP_HTML_FULL(speech_message, MAX_MESSAGE_LEN))
	var/static/regex/repeated_whitespace = regex(@"\s{2,}", "g")
	speech_message = trim(repeated_whitespace.Replace(speech_message, " "))
	return tts_speech_filter(speech_message)

/// Language station-wide TTS announcements are spoken in.
/// Must be a TYPE PATH, not a /datum/language instance: play_tts() feeds this to
/// /datum/language_holder/proc/has_language(), whose language lists are keyed by type path.
/// An instance never matches, silently downgrading every listener to blips.
/proc/tts_announcement_language()
	return /datum/language/common

/// Whether this announcement sound comes out of the announcer's spoken-line library.
/// Those are prerecorded English voice lines, so they cannot play underneath synthesized speech -
/// but everything else (an admin's hand-picked file, the security level's alarm tones) is a plain
/// sound effect that was chosen deliberately, and replacing it throws away that choice.
/// A null sound counts, because the caller will fall back to a random announcer line.
/proc/tts_sound_is_announcer_speech(announcement_sound)
	if(isnull(announcement_sound))
		return TRUE
	var/datum/centcom_announcer/announcer = SSstation?.announcer
	if(isnull(announcer))
		return FALSE
	if((announcement_sound in announcer.alert_sounds) || (announcement_sound in announcer.command_report_sounds) || (announcement_sound in announcer.welcome_sounds))
		return TRUE
	// The caller may hand over either the ANNOUNCER_* key or the file it resolves to.
	if(!isnull(announcer.event_sounds[announcement_sound]))
		return TRUE
	for(var/event_key in announcer.event_sounds)
		var/event_sound = announcer.event_sounds[event_key]
		if(islist(event_sound))
			if(announcement_sound in event_sound)
				return TRUE
		else if(event_sound == announcement_sound)
			return TRUE
	return FALSE

/// Nonverbal cue played in place of the announcer's prerecorded English speech when TTS carries
/// the announcement. Every entry must be a plain machine sound, never a spoken line, or it would
/// talk over the synthesized speech. Kept varied on purpose: a single cue for every announcement
/// throws away the alert/priority/hostile distinction the announcer sounds used to carry.
/proc/tts_priority_announcement_cue(urgent = FALSE, hostile = FALSE)
	if(hostile)
		return 'sound/machines/warning-buzzer.ogg'
	if(urgent)
		return 'sound/machines/engine_alert/engine_alert2.ogg'
	return 'sound/machines/beep/triple_beep.ogg'

/// As above, for the smaller AI/department notices.
/proc/tts_minor_announcement_cue(alert = FALSE)
	if(alert)
		return 'sound/machines/engine_alert/engine_alert1.ogg'
	return 'sound/machines/beep/twobeep_high.ogg'

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
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), SSstation, speech_message, tts_announcement_language(), speaker, "", listeners, station_wide = TRUE, identifier = identifier)
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
