/// 边界层「模板逆匹配」引擎（modular_nova/modules/i18n/code/template_match.dm）的行为测试。
/// 向 i18n 缓存注入合成 en/测试 locale 模板对，验证：中间占位符捕获、前导占位符的
/// 标签/句界处理、占位符重排、不完整匹配不替换、幂等。结束后清理注入状态。
/datum/unit_test/i18n_template_match

#define I18N_TEST_LOCALE "i18n-unittest"

/datum/unit_test/i18n_template_match/Run()
	var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE] = en_cache
	var/list/test_pairs = list(
		"unittest.tpl_mid" = list("The {0} is already filled to capacity.", "测试{0}满员。"),
		"unittest.tpl_lead" = list("{0} slams the vault door shut!", "{0}砰地关上了金库门！"),
		"unittest.tpl_reorder" = list("You smack {0} around with {1}.", "你用{1}抽打{0}。"),
	)
	var/list/test_cache = list()
	for(var/key in test_pairs)
		var/list/pair = test_pairs[key]
		en_cache[key] = pair[1]
		test_cache[key] = pair[2]
	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][I18N_TEST_LOCALE] = test_cache
	GLOB.i18n_runtime_domains.Remove(I18N_TEST_LOCALE)

	// 分段诊断：setup / 记录数 / 锚检测 / 完整 apply。
	TEST_ASSERT(lang_tpl_setup(I18N_TEST_LOCALE), "lang_tpl_setup 应返回 ready")
	var/list/recs = GLOB.i18n_tpl_records[I18N_TEST_LOCALE]
	TEST_ASSERT_EQUAL(length(recs), 3, "应建 3 条逆模板记录")
	var/probe = "<span class='warning'>The Zxqv is already filled to capacity.</span>"
	var/marked = rustg_acreplace("i18n_tpl_[I18N_TEST_LOCALE]", probe)
	TEST_ASSERT(findtext(marked, GLOB.i18n_tpl_stx), "锚检测应产出 sentinel（marked=[json_encode(marked)]）")

	// 实参用目录里不存在的无意义 token（Zxqv 等），断言与服务器 locale/真实目录解耦
	// （真实捕获会过整串反查→状态词→字面 AC 链，如 Captain→舰长——那是预期行为）。
	// 中间占位符 + span 包裹。
	TEST_ASSERT_EQUAL(lang_template_apply(probe, I18N_TEST_LOCALE), "<span class='warning'>测试Zxqv满员。</span>", "中间占位符模板应在 span 包裹内命中并填充")
	// 前导占位符：打头的完整标签留在替换区外，名字（含其闭合标签）作为捕获。
	TEST_ASSERT_EQUAL(lang_template_apply("<b>Zxqv</b> slams the vault door shut!", I18N_TEST_LOCALE), "<b>Zxqv</b>砰地关上了金库门！", "前导占位符应从句界/标签边界捕获实参")
	// 占位符按 zh 语序重排。
	TEST_ASSERT_EQUAL(lang_template_apply("You smack Aaqz around with Bbqz.", I18N_TEST_LOCALE), "你用Bbqz抽打Aaqz。", "zh 模板应能重排 {0}/{1}")
	// 不完整匹配（缺后续字面段）不得替换。
	TEST_ASSERT_EQUAL(lang_template_apply("You smack the wall.", I18N_TEST_LOCALE), "You smack the wall.", "字面段不全时不得误替换")
	// 幂等：已替换的中文输出再过引擎不变。
	var/once = lang_template_apply("The Zxqv is already filled to capacity.", I18N_TEST_LOCALE)
	TEST_ASSERT_EQUAL(lang_template_apply(once, I18N_TEST_LOCALE), once, "引擎应幂等")
	// 人工 fallback 是 locale 专属维护数据，伪 locale 只生成自动 forward 目录；只有 active zh-Hans
	// 才能断言这两条中文补充。运行时不会为测试额外加载第二个 locale。
	if(GLOB.i18n_server_locale == LANGUAGE_LOCALE_ZH_HANS)
		// 大厅/状态栏那批标签现在住在 _chrome.json（global_reverse），靠**整串精确反查**落地，
		// 不再靠字面 AC 的子串替换 —— 所以断言的是整串命中，而不是「嵌在更长串里也能翻」。
		TEST_ASSERT_EQUAL(lang_fallback_apply("Loading...", LANGUAGE_LOCALE_ZH_HANS), "加载中……", "_chrome.json 的整串应能精确反查")
		TEST_ASSERT_EQUAL(lang_reverse_text("Map:"), "地图:", "状态栏标签应能整串反查（渲染点自己拼接，见 statpanel.dm）")

	// 清理注入状态（测试 locale 的引擎缓存与字面 AC 状态一并清掉）。
	for(var/key in test_pairs)
		en_cache -= key
	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET] -= I18N_TEST_LOCALE
	GLOB.i18n_runtime_domains.Remove(I18N_TEST_LOCALE)
	GLOB.i18n_tpl_state -= I18N_TEST_LOCALE
	GLOB.i18n_tpl_records -= I18N_TEST_LOCALE
	GLOB.i18n_tpl_anchor_ids -= I18N_TEST_LOCALE
	GLOB.i18n_fallback_cache -= I18N_TEST_LOCALE
	GLOB.i18n_reverse -= I18N_TEST_LOCALE

#undef I18N_TEST_LOCALE
