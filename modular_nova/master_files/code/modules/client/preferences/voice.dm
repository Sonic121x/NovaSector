
/datum/preference/choiced/voice
	category = PREFERENCE_CATEGORY_VOCALS // Originally PREFERENCE_CATEGORY_NON_CONTEXTUAL, we are relocating it to the voice menu

/datum/preference/choiced/voice/is_accessible(datum/preferences/preferences)
	var/voice_type_pref = preferences.read_preference(/datum/preference/choiced/vocals/voice_type)
	if(voice_type_pref != VOICE_TYPE_TTS)
		return FALSE

	return ..(preferences)

/datum/preference/choiced/voice/init_possible_values()
	if(SStts.tts_enabled)
		return list(TTS_VOICE_NONE) + SStts.available_speakers

	if(fexists("data/cached_tts_voices.json"))
		var/list/text_data = rustg_file_read("data/cached_tts_voices.json")
		var/list/cached_data = json_decode(text_data)
		if(!cached_data)
			return list("invalid")

		return list(TTS_VOICE_NONE) + cached_data

	return list("invalid")

/datum/preference/choiced/voice/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/vocals/voice_type) != VOICE_TYPE_TTS)
		target.voice = TTS_VOICE_NONE
		return
	value = SStts.resolve_voice(value)
	if(SStts.tts_enabled && !(value in cached_values))
		value = SStts.random_tts_voice(target.gender) // As a failsafe

	target.voice = value == TTS_VOICE_NONE ? "" : value

/datum/preference/choiced/voice/deserialize(input, datum/preferences/preferences)
	// Voices retired by a TTS model change map onto their replacement instead of a random voice.
	return ..(SStts.resolve_voice(input), preferences)

/datum/preference/choiced/voice/compile_constant_data()
	. = ..()
	var/list/display_names = SStts.voice_display_names(.["choices"])
	if(display_names)
		.[CHOICED_PREFERENCE_DISPLAY_NAMES] = display_names

#undef TTS_VOICE_NONE
