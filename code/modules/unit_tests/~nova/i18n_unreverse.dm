/// i18n 反查 / 逆向反查（lang_reverse_text ↔ lang_unreverse_text）的往返不变量测试。
///
/// 守护「UI 显示边界把 name 翻成译文、旧消费侧仍按英文键查表」这类兼容路径（chem dispenser/
/// plumbing/portable mixer 等）。name2reagent 用 initial(name) 建 canonical English 键；若界面把显示译名
/// 回传，直接查必 miss，靠 `map[x] || map[lang_unreverse_text(x)]` 兜。若倒置逻辑回归（一对多取错、
/// locale 门控失误、空表毒化），这些 UI 会静默失效（中文名按了没反应）。
///
/// 向 i18n 缓存注入合成 en/测试 locale 对，临时切到测试 locale，断言：
///   ① lang_reverse_text 把英文整串变为显示译文；
///   ② lang_unreverse_text 把译文还原回英文（消费侧解药方向）；
///   ③ locale==en 时两者皆 no-op（默认态零行为变化）；
///   ④ 查不到的串原样返回（玩家名/动态数据零误伤）。
/datum/unit_test/i18n_unreverse

#define I18N_TEST_LOCALE "i18n-unittest"

/datum/unit_test/i18n_unreverse/Run()
	var/saved_locale = GLOB.i18n_server_locale

	var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_cache[DEFAULT_UI_LOCALE] = en_cache

	// 合成「试剂名」对：多词整串（无占位符），模拟 chem dispenser 的 Welding Fuel 类。
	var/list/test_pairs = list(
		"unittest.reagent_a" = list("Welding Fuel", "焊接燃料"),
		"unittest.reagent_b" = list("Carbon Dioxide", "二氧化碳"),
	)
	var/list/test_cache = list()
	for(var/key in test_pairs)
		var/list/pair = test_pairs[key]
		en_cache[key] = pair[1]
		test_cache[key] = pair[2]
	GLOB.i18n_cache[I18N_TEST_LOCALE] = test_cache

	// --- locale==en：两个方向都应 no-op（默认态零行为变化）。 ---
	GLOB.i18n_server_locale = DEFAULT_UI_LOCALE
	TEST_ASSERT_EQUAL(lang_reverse_text("Welding Fuel"), "Welding Fuel", "locale==en 时 lang_reverse_text 应原样返回")
	TEST_ASSERT_EQUAL(lang_unreverse_text("焊接燃料"), "焊接燃料", "locale==en 时 lang_unreverse_text 应原样返回")

	// --- 切到测试 locale。先清掉可能已被默认态缓存污染的反查表，强制按测试 locale 重建。 ---
	GLOB.i18n_server_locale = I18N_TEST_LOCALE
	GLOB.i18n_reverse -= I18N_TEST_LOCALE
	GLOB.i18n_unreverse -= I18N_TEST_LOCALE

	// ① 正向反查：英文整串 → 译文（examine/hover/P1 等显示边界的方向）。
	TEST_ASSERT_EQUAL(lang_reverse_text("Welding Fuel"), "焊接燃料", "正向反查应把英文名变异为译文")
	TEST_ASSERT_EQUAL(lang_reverse_text("Carbon Dioxide"), "二氧化碳", "正向反查应把英文名变异为译文")

	// ② 逆向反查：译文 → 英文（消费侧解药方向；name2reagent 查表的关键）。
	TEST_ASSERT_EQUAL(lang_unreverse_text("焊接燃料"), "Welding Fuel", "逆向反查应把译名还原回英文键")
	TEST_ASSERT_EQUAL(lang_unreverse_text("二氧化碳"), "Carbon Dioxide", "逆向反查应把译名还原回英文键")

	// 解药惯用法 `map[x] || map[lang_unreverse_text(x)]`：用译名也能命中英文键表。
	var/list/english_keyed_map = list("Welding Fuel" = /datum/reagent/fuel)
	var/zh_name = "焊接燃料"
	var/lookup = english_keyed_map[zh_name] || english_keyed_map[lang_unreverse_text(zh_name)]
	TEST_ASSERT_EQUAL(lookup, /datum/reagent/fuel, "译名经 lang_unreverse_text 应命中英文键表（解药惯用法）")

	// ④ 查不到的串（玩家名/动态数据）原样返回，零误伤。
	TEST_ASSERT_EQUAL(lang_unreverse_text("SomePlayerName"), "SomePlayerName", "未登记串应原样返回")
	TEST_ASSERT_EQUAL(lang_reverse_text("SomePlayerName"), "SomePlayerName", "未登记串应原样返回")

	// 清理注入状态。
	GLOB.i18n_server_locale = saved_locale
	for(var/key in test_pairs)
		en_cache -= key
	GLOB.i18n_cache -= I18N_TEST_LOCALE
	GLOB.i18n_reverse -= I18N_TEST_LOCALE
	GLOB.i18n_unreverse -= I18N_TEST_LOCALE

#undef I18N_TEST_LOCALE
