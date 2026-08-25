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
	TEST_ASSERT_NOTNULL(SStts, "The TTS subsystem should exist.")

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
