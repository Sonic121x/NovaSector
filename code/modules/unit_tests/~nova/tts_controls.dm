/datum/unit_test/tts_controls
	var/original_admin_enabled
	var/original_tts_enabled
	var/state_saved = FALSE

/datum/unit_test/tts_controls/Run()
	TEST_ASSERT_EQUAL(tts_speech_filter("Crew 你好，空间站！"), "Crew 你好，空间站！", "Printable Chinese text should be preserved.")
	TEST_ASSERT_EQUAL(tts_speech_filter("前[ascii2text(1)]后"), "前 后", "Control characters should be replaced with spaces.")
	TEST_ASSERT(tts_has_speech_content("你好"), "Chinese speech should pass the meaningful-content gate.")
	TEST_ASSERT(tts_has_speech_content("Crew 123"), "ASCII speech should pass the meaningful-content gate.")
	TEST_ASSERT(!tts_has_speech_content("！？..."), "Punctuation-only text should not be synthesized.")
	TEST_ASSERT_EQUAL(tts_prepare_announcement_message("<b>通知正文</b>", "空间站警报"), "空间站警报. 通知正文", "Announcement TTS should strip HTML and retain the title.")
	TEST_ASSERT_EQUAL(tts_prepare_announcement_message("第一行<br>第二行", null), "第一行 第二行", "Line break tags should become a pause rather than welding two sentences together.")
	// The announcer's own sounds are spoken English lines, so TTS announcements swap in a machine
	// cue instead. Collapsing them all onto one file throws away the alert/priority/hostile
	// distinction and makes every announcement sound identical, so hold them apart.
	var/list/announcement_cues = list(
		tts_priority_announcement_cue(),
		tts_priority_announcement_cue(urgent = TRUE),
		tts_priority_announcement_cue(hostile = TRUE),
		tts_minor_announcement_cue(),
		tts_minor_announcement_cue(alert = TRUE),
	)
	var/list/distinct_cues = list()
	for(var/cue in announcement_cues)
		TEST_ASSERT_NOTNULL(cue, "Every TTS announcement cue should resolve to a sound.")
		distinct_cues |= "[cue]"
	TEST_ASSERT_EQUAL(length(distinct_cues), length(announcement_cues), "Each TTS announcement cue should be a distinct sound.")
	// Only the announcer's prerecorded English lines may be swapped out. An admin who hand-picks a
	// file in the command report panel, or a security level's own alarm tone, must be left alone -
	// otherwise every announcement collapses onto the same cue no matter what was chosen.
	TEST_ASSERT(tts_sound_is_announcer_speech(null), "A missing sound falls back to an announcer line and should be replaceable.")
	TEST_ASSERT(tts_sound_is_announcer_speech(SSstation.announcer.get_rand_alert_sound()), "Announcer alert lines should be recognized as speech.")
	TEST_ASSERT(tts_sound_is_announcer_speech(SSstation.announcer.get_rand_report_sound()), "Announcer command report lines should be recognized as speech.")
	TEST_ASSERT(tts_sound_is_announcer_speech(ANNOUNCER_METEORS), "An ANNOUNCER_* key should be recognized as speech.")
	TEST_ASSERT(!tts_sound_is_announcer_speech('sound/machines/chime.ogg'), "A hand-picked sound file must survive TTS announcements.")
	TEST_ASSERT(!tts_sound_is_announcer_speech('sound/announcer/notice/notice2.ogg'), "Security level alarm tones are not spoken lines and must survive TTS announcements.")
	// play_tts() gates speech-vs-blips on language_holder.has_language(), whose lists are keyed by
	// TYPE PATH. Handing it a /datum/language instance matches nothing, so every announcement
	// listener silently fell back to blips. Guard both directions.
	// /datum/language_holder/atom_basic is what /atom/movable.initial_language_holder hands out,
	// i.e. the holder play_tts() actually queries. The bare base type understands nothing.
	var/datum/language_holder/announcement_listener = allocate(/datum/language_holder/atom_basic)
	TEST_ASSERT(announcement_listener.has_language(tts_announcement_language()), "Announcement TTS language should be understood by a default language holder.")
	TEST_ASSERT(!announcement_listener.has_language(GLOB.language_datum_instances[/datum/language/common]), "Language holders are keyed by type path; a language instance must never be passed to has_language().")
	var/datum/tts_request/global_request = allocate(/datum/tts_request, "global-test", null, null, null, null, null, "通知正文", null, FALSE, null, 7, 0, list(), 0, FALSE, TRUE)
	TEST_ASSERT(global_request.station_wide, "Global announcement requests should retain non-positional playback state.")
	TEST_ASSERT_NOTNULL(SStts, "The TTS subsystem should exist.")
	TEST_ASSERT_NOTNULL(SSadmin_verbs, "The admin verb subsystem should exist.")
	var/datum/admin_verb/toggle_verb = SSadmin_verbs.admin_verbs_by_type[/datum/admin_verb/toggle_tts_runtime]
	var/datum/admin_verb/test_verb = SSadmin_verbs.admin_verbs_by_type[/datum/admin_verb/test_tts_runtime]
	TEST_ASSERT_NOTNULL(toggle_verb, "The global TTS switch should be registered in the admin verb panel.")
	TEST_ASSERT_NOTNULL(test_verb, "The TTS playback test should be registered in the admin verb panel.")
	TEST_ASSERT_EQUAL(toggle_verb.category, ADMIN_CATEGORY_MAIN, "The global TTS switch should be visible in the main Admin category.")
	TEST_ASSERT_EQUAL(test_verb.category, ADMIN_CATEGORY_MAIN, "The TTS playback test should be visible in the main Admin category.")

	original_admin_enabled = SStts.admin_enabled
	original_tts_enabled = SStts.tts_enabled
	state_saved = TRUE
	SStts.tts_enabled = TRUE
	SStts.admin_enabled = TRUE
	TEST_ASSERT(SStts.is_runtime_enabled(), "Connected TTS should initially accept requests.")
	TEST_ASSERT(SStts.set_admin_enabled(FALSE), "Disabling TTS should succeed without contacting the backend.")
	TEST_ASSERT(!SStts.is_runtime_enabled(), "The admin gate should stop new TTS requests.")
	TEST_ASSERT(SStts.set_admin_enabled(TRUE), "Re-enabling a connected TTS backend should succeed.")
	TEST_ASSERT(SStts.is_runtime_enabled(), "The admin gate should resume new TTS requests.")

/// Expressive TTS: emotion tags, voice instructions and voice metadata from the TTS server.
/datum/unit_test/tts_expression
	var/list/original_voice_info
	var/state_saved = FALSE

/datum/unit_test/tts_expression/Run()
	// The TTS server rejects tags outside its allowlist, so a typo would silence every matching line.
	var/list/server_styles = list("sad", "amazed", "deep and loud shouting", "trembling", "angry", "excited", "sarcastic", "curious", "like dracula", "bored", "tired", "scornful", "shouting", "asmr", "panicked", "mischievously", "empathetic", "whispers", "reluctantly", "crying", "serious", "very slowly", "very fast")
	var/list/server_sounds = list("gasp", "sighing", "clears throat", "giggles", "laughing", "cough", "snorts")
	for(var/style in GLOB.tts_style_keywords)
		TEST_ASSERT(style in server_styles, "[style] is not a TTS control tag.")
	for(var/sound in GLOB.tts_sound_keywords)
		TEST_ASSERT(sound in server_sounds, "[sound] is not a TTS nonverbal tag.")

	// Every verb the chat box offers must change how the line is voiced, or picking it does nothing.
	for(var/verb in GLOB.tts_mood_verbs)
		var/list/mood = tts_detect_expression("你好", list(MODE_CUSTOM_SAY_EMOTE = verb))
		var/verb_instruction = tts_compose_instruction(null, list(MODE_CUSTOM_SAY_EMOTE = verb))
		if(mood[1] || mood[2])
			TEST_ASSERT_EQUAL(verb_instruction, "", "Mood verb [verb] is already a tag and should not also become an instruction.")
		else
			TEST_ASSERT_EQUAL(verb_instruction, "[TTS_VERB_INSTRUCTION][verb]", "Mood verb [verb] matches no tag and should become an instruction.")
	var/long_instruction = tts_compose_instruction(repeat_string(40, "低"), list(MODE_SING = TRUE, MODE_CUSTOM_SAY_EMOTE = repeat_string(20, "醉")))
	TEST_ASSERT(length_char(long_instruction) <= TTS_INSTRUCTION_TOTAL_MAX_LENGTH, "Composed instructions must fit the TTS server's limit.")
	for(var/emote_key in GLOB.tts_emote_voices)
		TEST_ASSERT(length(GLOB.emote_list[emote_key]), "Voiced emote [emote_key] does not exist.")
		var/list/voicing = GLOB.tts_emote_voices[emote_key]
		TEST_ASSERT(isnull(voicing[1]) || (voicing[1] in server_styles), "Voiced emote [emote_key] uses an unknown style.")
		TEST_ASSERT(isnull(voicing[2]) || (voicing[2] in server_sounds), "Voiced emote [emote_key] uses an unknown sound.")
		TEST_ASSERT(voicing[2] || length(voicing[3]), "Voiced emote [emote_key] would be silent.")
	TEST_ASSERT_EQUAL(tts_sanitize_custom_voice_text(" 舰长<b>\[x\] ", 24), "舰长 b  x", "Custom voice text must lose markup and tags.")

	// Machines and NPCs speak translated lines; what players typed is never rewritten.
	var/obj/machinery/vending/cola/vendor = allocate(/obj/machinery/vending/cola)
	TEST_ASSERT(lang_speaker_is_scripted(vendor), "Vending machines speak scripted lines.")
	var/mob/living/carbon/human/npc = allocate(/mob/living/carbon/human/consistent)
	TEST_ASSERT(lang_speaker_is_scripted(npc), "Mindless NPCs speak scripted lines.")
	npc.mind_initialize()
	TEST_ASSERT(!lang_speaker_is_scripted(npc), "A mob with a player's mind says what the player typed.")
	var/atom/movable/virtualspeaker/relay = allocate(/atom/movable/virtualspeaker, null, npc)
	TEST_ASSERT(!lang_speaker_is_scripted(relay), "Radio relays of a player's speech must not be rewritten.")

	var/list/expression = tts_detect_expression("快跑！！", list())
	TEST_ASSERT_EQUAL(expression[1], "shouting", "Yelling should be spoken as shouting.")
	expression = tts_detect_expression("你好。", list())
	TEST_ASSERT_NULL(expression[1], "Plain speech should carry no tag.")
	expression = tts_detect_expression("嘘", list(WHISPER_MODE = MODE_WHISPER))
	TEST_ASSERT_EQUAL(expression[1], "whispers", "Whispers should be whispered.")
	expression = tts_detect_expression("收到", list(WHISPER_MODE = MODE_WHISPER, MODE_TTS_RADIO_HUSH = TRUE))
	TEST_ASSERT_NULL(expression[1], "Speaking into a radio should not be whispered on the air.")
	expression = tts_detect_expression("救我", list(WHISPER_MODE = MODE_WHISPER_CRIT))
	TEST_ASSERT_EQUAL(expression[1], "trembling", "Last words in crit should tremble.")
	expression = tts_detect_expression("我没事", list(MODE_CUSTOM_SAY_EMOTE = "sobs"))
	TEST_ASSERT_EQUAL(expression[1], "crying", "Custom say verbs should pick an emotion.")
	expression = tts_detect_expression("来吧！！", list(MODE_CUSTOM_SAY_EMOTE = "低声"))
	TEST_ASSERT_EQUAL(expression[1], "whispers", "A custom say verb outranks the yell ending.")
	expression = tts_detect_expression("太好笑了", list(MODE_CUSTOM_SAY_EMOTE = "laughs"))
	TEST_ASSERT_EQUAL(expression[2], "laughing", "Laughing verbs should add a laugh.")
	var/list/amazed = tts_detect_expression("真漂亮", list(MODE_CUSTOM_SAY_EMOTE = "惊叹道"))
	TEST_ASSERT_EQUAL(amazed[1], "amazed", "惊叹 should be amazed.")
	TEST_ASSERT_NULL(amazed[2], "惊叹 must not also sigh.")
	var/list/smiling = tts_detect_expression("你好", list(MODE_CUSTOM_SAY_EMOTE = "微笑着说"))
	TEST_ASSERT_NULL(smiling[1], "Smiling is not an emotion tag.")
	TEST_ASSERT_NULL(smiling[2], "Smiling must not laugh out loud.")

	TEST_ASSERT_EQUAL(tts_sanitize_instruction("\[laughing\]沙哑<b>"), "laughing 沙哑 b", "Instructions must not carry tags or markup.")
	TEST_ASSERT_EQUAL(length_char(tts_sanitize_instruction(repeat_string(40, "低"))), TTS_INSTRUCTION_MAX_LENGTH, "Instructions should be cut to the character limit.")
	TEST_ASSERT_EQUAL(tts_compose_instruction("沙哑", list(MODE_SING = TRUE)), "沙哑；[TTS_SING_INSTRUCTION]", "Singing should extend the voice instruction.")
	TEST_ASSERT_EQUAL(tts_compose_instruction(null, list()), "", "No description means no instruction.")

	original_voice_info = list(SStts.voice_labels, SStts.random_voices, SStts.voice_aliases, SStts.supported_styles, SStts.supported_sounds, SStts.instruction_enabled, SStts.rate_enabled, SStts.voice_info_loaded, SStts.tts_enabled, SStts.available_speakers)
	state_saved = TRUE
	TEST_ASSERT(SStts.apply_voice_info(list(
		"voices" = list(
			list("id" = "Yu Xiaoyun Woman", "label" = "于小云", "gender" = "female", "description" = "元气、亲切", "random" = TRUE),
			list("id" = "Lidou Boy", "label" = "龙杰力豆", "gender" = "male", "description" = "", "random" = FALSE),
		),
		"aliases" = list("Cherry Woman" = "Yu Xiaoyun Woman"),
		"styles" = list("shouting"),
		"sounds" = list("laughing"),
		"instruction" = TRUE,
		"rate" = TRUE,
	)), "Well-formed voice info should apply.")
	TEST_ASSERT_EQUAL(SStts.resolve_voice("Cherry Woman"), "Yu Xiaoyun Woman", "Retired voices should map to their replacement.")

	// Preferences are often read before the TTS server answers, from last round's cached list.
	// After a voice list change that list rejects every saved voice, which must not randomize it.
	var/datum/preference/choiced/voice/voice_preference = GLOB.preference_entries[/datum/preference/choiced/voice]
	SStts.tts_enabled = FALSE
	voice_preference.cached_values = list("None", "Cherry Woman")
	TEST_ASSERT_EQUAL(voice_preference.deserialize("Cherry Woman"), "Yu Xiaoyun Woman", "Before the TTS server answers, a saved voice must survive a stale voice list.")
	SStts.tts_enabled = TRUE
	SStts.available_speakers = list("Yu Xiaoyun Woman", "Lidou Boy")
	SStts.refresh_voice_preferences()
	TEST_ASSERT_EQUAL(voice_preference.deserialize("Cherry Woman"), "Yu Xiaoyun Woman", "Once the TTS server answers, the live voice list should accept migrated voices.")
	TEST_ASSERT_EQUAL(voice_preference.deserialize("Lidou Boy"), "Lidou Boy", "Current voices should be kept.")
	TEST_ASSERT(GLOB.tts_voice_list.Find("Lidou Boy"), "The voice actor list should follow the live voice list.")
	TEST_ASSERT_EQUAL(SStts.resolve_voice("Lidou Boy"), "Lidou Boy", "Current voices should resolve to themselves.")
	TEST_ASSERT_EQUAL(SStts.voice_labels["Yu Xiaoyun Woman"], "于小云（女·元气、亲切）", "Voice labels should show gender and traits.")
	TEST_ASSERT_EQUAL(SStts.voice_labels["Lidou Boy"], "龙杰力豆（男）", "Voices without traits should still get a label.")
	TEST_ASSERT_EQUAL(jointext(SStts.random_voices, ","), "Yu Xiaoyun Woman", "Only random-eligible voices should be handed out at random.")
	var/list/body = tts_expression_body("shouting", "gasp", "沙哑", 1.5)
	TEST_ASSERT_EQUAL(body["style"], "shouting", "Supported styles should be sent.")
	TEST_ASSERT_NULL(body["sound"], "Sounds the server does not list must not be sent.")
	TEST_ASSERT_EQUAL(body["instruction"], "沙哑", "Instructions should be sent when supported.")
	TEST_ASSERT_EQUAL(body["rate"], 1.5, "Rate should be sent when supported.")
	body = tts_expression_body(null, null, "", 1)
	TEST_ASSERT_EQUAL(length(body), 0, "Defaults should add nothing to the request.")
	TEST_ASSERT(!SStts.apply_voice_info("garbage"), "Malformed voice info should be rejected.")
	TEST_ASSERT(!SStts.instruction_enabled, "Rejected voice info should switch the extras off.")
	TEST_ASSERT_EQUAL(length(tts_expression_body("shouting", "laughing", "沙哑", 1.5)), 0, "Without voice info, requests should stay plain.")

/datum/unit_test/tts_expression/Destroy()
	if(state_saved && SStts)
		SStts.voice_labels = original_voice_info[1]
		SStts.random_voices = original_voice_info[2]
		SStts.voice_aliases = original_voice_info[3]
		SStts.supported_styles = original_voice_info[4]
		SStts.supported_sounds = original_voice_info[5]
		SStts.instruction_enabled = original_voice_info[6]
		SStts.rate_enabled = original_voice_info[7]
		SStts.voice_info_loaded = original_voice_info[8]
		SStts.tts_enabled = original_voice_info[9]
		SStts.available_speakers = original_voice_info[10]
		for(var/preference_type in list(/datum/preference/choiced/voice, /datum/preference/choiced/voice_actor))
			var/datum/preference/choiced/preference = GLOB.preference_entries[preference_type]
			preference.cached_values = null
		GLOB.tts_voice_list.Cut()
	return ..()

/datum/unit_test/tts_controls/Destroy()
	if(state_saved && SStts)
		SStts.admin_enabled = original_admin_enabled
		SStts.tts_enabled = original_tts_enabled
	return ..()

/// Whispers overheard from just outside their range are flagged, so TTS voices them as blips like the starred text.
/// HEAR_HEARD is not asserted: show_message() needs a real client, which a mock client is not.
/datum/unit_test/tts_eavesdrop
	/// The raw message the listener last heard, after Hear() starred it.
	var/heard_raw_message

/datum/unit_test/tts_eavesdrop/Run()
	var/mob/living/carbon/human/consistent/speaker = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/consistent/listener = allocate(/mob/living/carbon/human/consistent)
	listener.mock_client = new /datum/client_interface()
	var/datum/language/language = speaker.get_selected_language()
	var/list/whisper_mods = list(WHISPER_MODE = MODE_WHISPER)
	var/list/heard_at = list()
	RegisterSignal(listener, COMSIG_MOVABLE_HEAR, PROC_REF(on_hear))

	speaker.forceMove(run_loc_floor_bottom_left)
	for(var/distance in 1 to 3)
		listener.forceMove(locate(run_loc_floor_bottom_left.x + distance, run_loc_floor_bottom_left.y, run_loc_floor_bottom_left.z))
		heard_raw_message = null
		var/hearflags = listener.Hear(speaker, language, "Zxqv plorb", spans = list(), message_mods = whisper_mods.Copy(), message_range = WHISPER_RANGE)
		heard_at["[distance]"] = list(hearflags, heard_raw_message)

	TEST_ASSERT_EQUAL(heard_at["1"][2], "Zxqv plorb", "A listener in whisper range should hear the whisper in full.")
	TEST_ASSERT(!(heard_at["1"][1] & HEAR_EAVESDROPPED), "A listener in whisper range should hear the voice, not blips.")
	TEST_ASSERT(heard_at["2"][2] && heard_at["2"][2] != "Zxqv plorb", "A listener just outside whisper range should overhear starred text.")
	TEST_ASSERT(heard_at["2"][1] & HEAR_EAVESDROPPED, "A listener just outside whisper range should be flagged as eavesdropping.")
	TEST_ASSERT_NULL(heard_at["3"][2], "A listener out of eavesdrop range should not hear the whisper at all.")
	TEST_ASSERT(!(heard_at["3"][1] & HEAR_EAVESDROPPED), "A listener out of eavesdrop range should not be flagged.")

	var/hearflags = listener.Hear(speaker, language, "Zxqv plorb", spans = list(), message_mods = list(), message_range = MESSAGE_RANGE)
	TEST_ASSERT(!(hearflags & HEAR_EAVESDROPPED), "Normal speech in range should not be flagged as eavesdropping.")

/datum/unit_test/tts_eavesdrop/proc/on_hear(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	heard_raw_message = hearing_args[HEARING_RAW_MESSAGE]
