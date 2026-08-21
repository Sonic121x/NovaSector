/// 守「说话变形」类效果在中文下不空转。
///
/// 这批机制（口吃/脑损/焦虑、蜥蜴嘶声、苍蝇嗡嗡、以及各种基因语音突变）全是**字母级**变换：
/// 逐词切分靠空格、替换靠 `s→sss` 这样的字母规则。中文文本里既没有词间空格、也没有拉丁字母，
/// 于是整类效果在中文服上**完全不触发**——玩家看到的蜥蜴人和常人说话一模一样。
///
///   ① 逐词切分：中文按**字**切、以空串拼回（`handle_message`）；
///   ② 口吃本身：单个汉字匹配不上原正则，改为整字重复（「我-我-我」）；
///   ③ 拟声替换表：按 locale 选中文表（标点锚定，不硬换字以免毁词义）。
/datum/unit_test/i18n_speech_effects
	var/saved_locale
	var/saved_resolved

/datum/unit_test/i18n_speech_effects/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_server_locale = saved_locale
		GLOB.i18n_locale_resolved = saved_resolved
		saved_locale = null
	return ..()

/datum/unit_test/i18n_speech_effects/Run()
	saved_locale = GLOB.i18n_server_locale
	saved_resolved = GLOB.i18n_locale_resolved
	GLOB.i18n_server_locale = "zh-Hans"
	GLOB.i18n_locale_resolved = TRUE

	var/mob/living/carbon/human/consistent/speaker = allocate(/mob/living/carbon/human/consistent)
	var/datum/status_effect/speech/stutter/stutter = speaker.apply_status_effect(/datum/status_effect/speech/stutter, 10 MINUTES)
	TEST_ASSERT(!isnull(stutter), "口吃状态效果未能施加")
	stutter.stutter_prob = 100 // 断言要确定性：概率拉满，只留「按字切」这一个变量

	// ② 单个汉字必须能被口吃处理（原正则靠 \b + 拉丁字母定位，汉字匹配不上）。
	var/single = stutter.apply_speech("我", 1)
	TEST_ASSERT_NOTEQUAL(single, "我", "单个汉字没有被口吃处理：中文下整类效果空转")
	TEST_ASSERT(findtext(single, "我"), "口吃结果丢掉了原字：[single]")

	// ① 整句必须按字生效，而不是「整句算一个词、只在句首触发一次」。
	// TREAT_MESSAGE_ARG 是**数字下标**（1），list 必须先有对应长度的元素。
	var/list/message_args = list("我们现在就去医疗部治疗伤员", "", "")
	stutter.handle_message(speaker, message_args)
	var/treated = message_args[TREAT_MESSAGE_ARG]
	TEST_ASSERT_NOTEQUAL(treated, "我们现在就去医疗部治疗伤员", "中文整句没有被口吃处理")
	TEST_ASSERT(!findtext(treated, " "), "中文按字切之后不能用空格拼回：[treated]")

	// ③ 英文仍走原逻辑（按空格切词），中文改动不得影响英文服。
	GLOB.i18n_server_locale = DEFAULT_UI_LOCALE
	var/list/english_args = list("we should go to medbay", "", "")
	stutter.handle_message(speaker, english_args)
	TEST_ASSERT(findtext(english_args[TREAT_MESSAGE_ARG], " "), "英文路径被中文改动破坏了词间空格")
