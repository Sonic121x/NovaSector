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
		GLOB.i18n_runtime_state = saved_resolved
		saved_locale = null
	return ..()

/datum/unit_test/i18n_speech_effects/Run()
	saved_locale = GLOB.i18n_server_locale
	saved_resolved = GLOB.i18n_runtime_state
	GLOB.i18n_server_locale = "zh-Hans"
	GLOB.i18n_runtime_state = I18N_RUNTIME_READY

	var/mob/living/carbon/human/consistent/speaker = allocate(/mob/living/carbon/human/consistent)
	var/datum/status_effect/speech/stutter/stutter = speaker.apply_status_effect(/datum/status_effect/speech/stutter, 10 MINUTES)
	TEST_ASSERT(!isnull(stutter), "口吃状态效果未能施加")
	// 断言要确定性：两档概率都拉满。按字采样那档（cjk_char_chance）默认 25%，13 个字全落空的
	// 概率约 2.4% —— 不拉满就是一条**偶发红**的 flaky 测试（本轮实测撞上过一次）。
	// **每一层概率都要拉满**才是确定性的。这条测试红过两次，两次都是漏了一层：
	//   ① stutter_prob —— 该词要不要口吃；
	//   ② cjk_char_chance —— 按字切时该字参不参与（默认 25%，13 个字全落空约 2.4%）；
	//   ③ two/three/four_char_chance —— stutter_char() 内部还有一层，默认 two 只有 90%，
	//      也就是说即使前两层都过了，仍有 10% 概率原样返回。
	stutter.stutter_prob = 100
	stutter.cjk_char_chance = 100
	stutter.two_char_chance = 100

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

	// ④ 词表突变：中文表按 `<名>.<locale>.json` 取，取不到才退回英文表。
	// 英文表的键是英文单词，在中文句子里永不匹配 —— 不取中文表就等于整类突变空转。
	var/list/chinese_table = lang_speech_replacements("chav_replacement.json", "chav")
	TEST_ASSERT(length(chinese_table) > 0, "中文语音替换表取不到")
	var/found_chinese_key = FALSE
	for(var/replacement_key in chinese_table)
		if(lang_contains_cjk(replacement_key))
			found_chinese_key = TRUE
			break
	TEST_ASSERT(found_chinese_key, "取到的仍是英文键的表：中文句子里永不匹配，突变整类空转")

	// ⑤ 中文表**叠加**在英文表之上，不是替换。整张换掉会让中文服上的英文发言丢掉效果，
	// 也会让上游的 speech_modifiers 单测直接红（它断言的正是英文输入 "She is so sassy" 的变形）。
	var/found_english_key = FALSE
	for(var/replacement_key in chinese_table)
		if(istext(replacement_key) && !lang_contains_cjk(replacement_key))
			found_english_key = TRUE
			break
	TEST_ASSERT(found_english_key, "中文表把英文表整张替换掉了：中文服上的英文发言会丢掉整个效果")

	// ③ 英文仍走原逻辑（按空格切词），中文改动不得影响英文服。
	GLOB.i18n_server_locale = DEFAULT_UI_LOCALE
	var/list/english_args = list("we should go to medbay", "", "")
	stutter.handle_message(speaker, english_args)
	TEST_ASSERT(findtext(english_args[TREAT_MESSAGE_ARG], " "), "英文路径被中文改动破坏了词间空格")
	var/list/english_table = lang_speech_replacements("chav_replacement.json", "chav")
	// 判据只能看**键**，不能看值。`load_strings_file` 在非英文 locale 下对 strings/ 数据做**就地**
	// 反查（`lang_reverse_tree`），英文表的值在加载那一刻就被换成中文了、而且缓存是全局的、一局只加载
	// 一次 —— 拿值来断言等于在断言「这个文件是在切 locale 之前还是之后第一次被读的」，跑真 zh-Hans
	// 必红。键从不被反查碰，才是「取的是哪张表」的可靠证据。
	// 这条在伪 locale 门禁下是**假绿**：qps-ploc 把值包成 ⟦…⟧，不含 CJK，断言照样过。
	// 而且要断言**一个中文键都没有**：叠加之后英文键排在前面，只看第一条区分不出 en 与 zh。
	for(var/replacement_key in english_table)
		TEST_ASSERT(!lang_contains_cjk(replacement_key), "英文 locale 下取到了中文表的键：[replacement_key]")
