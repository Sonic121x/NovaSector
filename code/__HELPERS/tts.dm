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

/proc/tts_gibberish_speech_filter(text)
	// Only allow alphanumeric characters and whitespace
	var/static/regex/bad_chars_regex = regex("\[^a-zA-Z0-9 ,?.!'&-]", "g")
	return bad_chars_regex.Replace(text, "#")

/proc/tts_filter_encode(text, speaker, pitch, blips = FALSE)
	text = replacetext(text, "%PITCH%", SStts.pitch_enabled ? pitch : 0)
	text = replacetext(text, "%FEMALE%", !!findtext(speaker, "Woman"))
	text = replacetext(text, "%BLIPS%", blips)
	return url_encode(text)
