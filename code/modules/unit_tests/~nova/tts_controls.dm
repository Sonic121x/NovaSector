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
