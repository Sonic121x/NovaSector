/// 拼句碎片**不得**进 AC 子串字典（见 fallback.dm 的 lang_fallback_pattern_safe）。
///
/// 守的是一类比「没翻译」严重得多的线上事故：玩家看到的是被从**单词内部**切开的半句乱码。
/// 反查表同时喂两条路——`lang_reverse_text` 的整串精确反查（碎片在那里无害，必须整串相等才
/// 命中），和字面 AC 的**子串替换**（碎片会在任意句子中间开火）。旧闸门只要求「pattern 含
/// 空格」，于是下面这两类原样通过：
///   · `"one of"→"其中一只"`（目录里一条没有调用点的悬空项）
///       → 「But n|one of| its eggs hatched!」渲染成「But n其中一只 its eggs hatched!」
///   · `" and "→" 和 "`（carbon_examine 伤情拼句的连接碎片，靠首尾空格才「含空格」）
///       → 「…on the console 和 he is constantly twitching…」整段 NPC 检查文本被污染
/// rustg 的 AC 没有词边界概念，LeftmostLongest 只保证「同一起点取最长」，管不了「起点落在单词
/// 内部」，所以闸门只能设在建字典这一步。
/datum/unit_test/i18n_ac_fragment

#define I18N_FRAG_TEST_LOCALE "i18n-frag-unittest"

/datum/unit_test/i18n_ac_fragment/Run()
	// 1) 闸门本身（纯函数，与 locale 无关）——直接钉住线上两个真实碎片的形状。
	TEST_ASSERT(!lang_fallback_pattern_safe("one of"), \
		"「one of」这类全虚词短语进了 AC 字典，会把 none/anyone 等单词从中间切开。")
	TEST_ASSERT(!lang_fallback_pattern_safe(" and "), \
		"「 and 」靠首尾空格冒充多词短语，去掉空白后是单个虚词，不得进 AC 字典。")
	TEST_ASSERT(!lang_fallback_pattern_safe("and "), \
		"「and 」同上：trim 后无空格即非多词短语。")

	// 反向断言：正常显示串不能被这道闸门误杀。
	TEST_ASSERT(lang_fallback_pattern_safe("Security Officer"), \
		"普通多词显示名被闸门挡掉了——闸门过严会让整类专有名词回退英文。")
	TEST_ASSERT(lang_fallback_pattern_safe("The door is locked."), \
		"带句末标点的整句必须放行，哪怕它以虚词 The 开头。")
	TEST_ASSERT(lang_fallback_pattern_safe("begins to make an incision in the organs within"), \
		"长于三词的插值句锚必须放行，否则手术类整句全部失译。")

	// 2) 端到端：注入碎片词对，确认它无法在真实句子中间开火。
	var/saved_locale = GLOB.i18n_server_locale
	var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_cache[DEFAULT_UI_LOCALE] = en_cache
	en_cache["frag_oneof"] = "one of"
	GLOB.i18n_cache[I18N_FRAG_TEST_LOCALE] = list("frag_oneof" = "其中一只")

	GLOB.i18n_reverse.Remove(I18N_FRAG_TEST_LOCALE)
	GLOB.i18n_fallback_state.Remove(I18N_FRAG_TEST_LOCALE)
	GLOB.i18n_fallback_single_state.Remove(I18N_FRAG_TEST_LOCALE)
	GLOB.i18n_fallback_cache.Remove(I18N_FRAG_TEST_LOCALE)
	GLOB.i18n_server_locale = I18N_FRAG_TEST_LOCALE

	var/sentence = "But none of its eggs hatched!"
	var/got = lang_fallback_apply(sentence)
	TEST_ASSERT_EQUAL(got, sentence, \
		"碎片 pattern 在单词内部开火了：[sentence] 实得 [got]。\
		AC 无词边界概念，碎片必须在 lang_fallback_setup 建字典时就被挡掉。")

	GLOB.i18n_server_locale = saved_locale
	GLOB.i18n_reverse.Remove(I18N_FRAG_TEST_LOCALE)
	GLOB.i18n_fallback_state.Remove(I18N_FRAG_TEST_LOCALE)
	GLOB.i18n_fallback_single_state.Remove(I18N_FRAG_TEST_LOCALE)
	GLOB.i18n_fallback_cache.Remove(I18N_FRAG_TEST_LOCALE)
	GLOB.i18n_cache.Remove(I18N_FRAG_TEST_LOCALE)
	en_cache.Remove("frag_oneof")

#undef I18N_FRAG_TEST_LOCALE
