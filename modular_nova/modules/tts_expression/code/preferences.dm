/// Free-text description of the character's TTS voice: age, timbre, accent or dialect.
/datum/preference/text/tts_voice_instruction
	category = PREFERENCE_CATEGORY_VOCALS
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "tts_voice_instruction"
	// A byte limit, and deserialization cuts on bytes; the menu enforces the real character limit.
	maximum_value_length = 256
	can_randomize = FALSE

/datum/preference/text/tts_voice_instruction/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE
	if(!SStts.tts_enabled || !SStts.instruction_enabled)
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/vocals/voice_type) == VOICE_TYPE_TTS

/datum/preference/text/tts_voice_instruction/deserialize(input, datum/preferences/preferences)
	return tts_sanitize_instruction(input)

/datum/preference/text/tts_voice_instruction/compile_constant_data()
	return list("maximum_length" = TTS_INSTRUCTION_MAX_LENGTH)

/datum/preference/text/tts_voice_instruction/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.tts_instruction = tts_sanitize_instruction(value)

/// TTS speaking rate, as a percentage of the voice's normal speed.
/datum/preference/numeric/tts_voice_rate
	category = PREFERENCE_CATEGORY_VOCALS
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "tts_voice_rate"
	minimum = 50
	maximum = 200
	step = 5
	can_randomize = FALSE

/datum/preference/numeric/tts_voice_rate/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE
	if(!SStts.tts_enabled || !SStts.rate_enabled)
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/vocals/voice_type) == VOICE_TYPE_TTS

/datum/preference/numeric/tts_voice_rate/create_default_value()
	return 100

/datum/preference/numeric/tts_voice_rate/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.tts_rate = value / 100
