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

/datum/unit_test/tts_controls/Destroy()
	if(state_saved && SStts)
		SStts.admin_enabled = original_admin_enabled
		SStts.tts_enabled = original_tts_enabled
	return ..()
