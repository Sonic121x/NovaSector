/// i18n 漏翻采集器（miss_log.dm）的 run 提取纯函数测试。
///
/// lang_i18n_extract_runs 决定「什么算一条漏翻记录」：门槛错了要么日志被人名/数字刷屏，
/// 要么真漏翻（如 2 词小写短语）被静默丢弃。此测试冻结门槛语义：
///   ① ≥3 拉丁词的 run 收录；② 恰 2 词且含小写开头词收录（"toggle safety"），
///      2 词全大写开头跳过（"John Smith" 人名）；③ CJK 打断 run；④ HTML 标签/实体剥除；
///   ⑤ run 内部数字保留、尾部数字/标点修剪；⑥ 全中文/空文本零产出。
/datum/unit_test/i18n_miss_log

/datum/unit_test/i18n_miss_log/Run()
	// ① 基础句子收录（含尾随标点）
	var/list/runs = lang_i18n_extract_runs("The engine is on fire!")
	TEST_ASSERT_EQUAL(length(runs), 1, "整句应提取为一条 run")
	TEST_ASSERT_EQUAL(runs[1], "The engine is on fire!", "run 应保留原词与标点")

	// ② 词数门槛：2 词含小写开头收录；2 词全 Title Case（人名类）跳过
	runs = lang_i18n_extract_runs("toggle safety")
	TEST_ASSERT_EQUAL(length(runs), 1, "2 词小写短语应收录")
	runs = lang_i18n_extract_runs("John Smith")
	TEST_ASSERT_EQUAL(length(runs), 0, "2 词 Title Case（人名类）应跳过")

	// ③ CJK 打断：中英混排只收英文段
	runs = lang_i18n_extract_runs("这是一段 partially translated sentence here 的文本")
	TEST_ASSERT_EQUAL(length(runs), 1, "中英混排应只提取英文段")
	TEST_ASSERT_EQUAL(runs[1], "partially translated sentence here", "英文段应完整提取")

	// ④ HTML 标签与实体剥除
	runs = lang_i18n_extract_runs("<span class='warning'>You hear something skittering.</span>&nbsp;")
	TEST_ASSERT_EQUAL(length(runs), 1, "HTML 标签应剥除且不混入 run")
	TEST_ASSERT_EQUAL(runs[1], "You hear something skittering.", "标签属性词不应进入 run")

	// ⑤ run 内数字保留、尾部中性 token 修剪
	runs = lang_i18n_extract_runs("Requires 3 more units now 5")
	TEST_ASSERT_EQUAL(length(runs), 1, "内部数字不应打断 run")
	TEST_ASSERT_EQUAL(runs[1], "Requires 3 more units now", "尾部孤立数字应修剪")

	// ⑥ 无英文内容零产出
	TEST_ASSERT_EQUAL(length(lang_i18n_extract_runs("引擎着火了！")), 0, "全中文应零产出")
	TEST_ASSERT_EQUAL(length(lang_i18n_extract_runs("")), 0, "空串应零产出")
	TEST_ASSERT_EQUAL(length(lang_i18n_extract_runs(null)), 0, "null 应零产出")

/// 采集开着时落地缓存照常工作，缓存命中仍要计数（命中点按 i18n_miss_runs 补记）。从前采集一开就绕开缓存，
/// 只能在单测里开；现在要能常开在生产服，两件事缺一不可：缓存真的被用上、次数不因命中而丢。
/datum/unit_test/i18n_miss_log_cache
	var/saved_log_misses
	var/list/saved_cache
	var/saved_locale

#define I18N_MISS_CACHE_TEXT "Zxqv thranok quibbles zorbly onward"

/datum/unit_test/i18n_miss_log_cache/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_log_misses = saved_log_misses
		GLOB.i18n_fallback_cache[saved_locale] = saved_cache
		GLOB.i18n_miss_counts -= I18N_MISS_CACHE_TEXT
		var/list/by_key = GLOB.i18n_miss_runs["fallback"]
		if(islist(by_key))
			by_key -= I18N_MISS_CACHE_TEXT
		saved_locale = null
	return ..()

/datum/unit_test/i18n_miss_log_cache/Run()
	var/locale = GLOB.i18n_server_locale
	if(locale == DEFAULT_UI_LOCALE)
		return // 英文服不经落地层
	saved_locale = locale
	saved_log_misses = GLOB.i18n_log_misses
	saved_cache = GLOB.i18n_fallback_cache[locale]
	// 空缓存：长跑的套件里缓存可能已满，那样第二次调用不会命中，测不到补记那条路。
	GLOB.i18n_fallback_cache[locale] = list()
	GLOB.i18n_miss_counts -= I18N_MISS_CACHE_TEXT
	GLOB.i18n_log_misses = TRUE

	lang_fallback_apply(I18N_MISS_CACHE_TEXT)
	var/list/cache = GLOB.i18n_fallback_cache[locale]
	TEST_ASSERT(!isnull(cache[I18N_MISS_CACHE_TEXT]), "采集开着时结果也应进落地缓存")
	lang_fallback_apply(I18N_MISS_CACHE_TEXT)
	TEST_ASSERT_EQUAL(GLOB.i18n_miss_counts[I18N_MISS_CACHE_TEXT], 2, "缓存命中的那次也应计数")

#undef I18N_MISS_CACHE_TEXT
