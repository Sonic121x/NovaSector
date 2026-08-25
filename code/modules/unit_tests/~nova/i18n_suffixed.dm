/// i18n「基础句 + 运行期追加后缀」反查（lang_reverse_suffixed）测试。
///
/// 守护一整类「目录里有译文却整条显英文」：赏金 description、器官手术 desc 等在 New()/生成期
/// 用 `desc += "…"` 追加固定后缀，拼出来的整串**不是目录键**，精确反查连基础句一起 miss。
/// lang_reverse_suffixed 负责按已知后缀拆成 base + 后缀分别精确反查再拼回。
///
/// 接缝空白是这里唯一的暗礁：手术那条源码自带前导空格，赏金那条靠 DM 续行（`"</br>\` + 换行 +
/// 制表符）。抽取器与 BYOND 对续行空白的处理未必逐字节一致，所以本测试**照抄源码里的续行写法**
/// 构造被测串——真出现不一致，这里会红，而不是等玩家在赏金台上看到一整条英文。
/datum/unit_test/i18n_suffixed

#define I18N_SUFFIX_TEST_LOCALE "i18n-suffix-unittest"

/datum/unit_test/i18n_suffixed/Run()
	var/saved_locale = GLOB.i18n_server_locale

	var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE] = en_cache

	var/base_text = "The lab technicians fried our last one. Mind building one for us?"
	var/bounty_suffix = "</br>This bounty is marked as <b>high priority</b>, and will reward <b>1.5x</b> the normal payout!"
	var/organ_suffix = "This procedure can only be performed once per organ."

	var/list/test_cache = list()
	en_cache["unittest.suffix_base"] = base_text
	test_cache["unittest.suffix_base"] = "实验室技师把上一台烧了。介意帮我们造一台吗？"
	en_cache["unittest.suffix_bounty"] = bounty_suffix
	test_cache["unittest.suffix_bounty"] = "</br>此悬赏被标记为高优先级。"
	en_cache["unittest.suffix_organ"] = organ_suffix
	test_cache["unittest.suffix_organ"] = "此手术每个器官只能做一次。"
	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][I18N_SUFFIX_TEST_LOCALE] = test_cache
	GLOB.i18n_runtime_domains.Remove(I18N_SUFFIX_TEST_LOCALE)

	// --- locale==en：no-op（默认态零行为变化）。 ---
	GLOB.i18n_server_locale = DEFAULT_UI_LOCALE
	TEST_ASSERT_EQUAL(lang_reverse_suffixed("[base_text][bounty_suffix]"), "[base_text][bounty_suffix]", "locale==en 时 lang_reverse_suffixed 应原样返回")

	GLOB.i18n_server_locale = I18N_SUFFIX_TEST_LOCALE
	GLOB.i18n_reverse -= I18N_SUFFIX_TEST_LOCALE // 强制按新注入的 cache 重建反查表

	// ① 无后缀的整串：退化成 lang_reverse_text。
	TEST_ASSERT_EQUAL(lang_reverse_suffixed(base_text), "实验室技师把上一台烧了。介意帮我们造一台吗？", "无后缀时应整串精确反查")

	// ② 赏金形态：**照抄** bounty_machinery.dm 的续行写法，验证接缝空白不会让匹配落空。
	var/appended_like_source = base_text
	appended_like_source += "</br>\
		This bounty is marked as <b>high priority</b>, and will reward <b>1.5x</b> the normal payout!"
	TEST_ASSERT_EQUAL(lang_reverse_suffixed(appended_like_source), "实验室技师把上一台烧了。介意帮我们造一台吗？</br>此悬赏被标记为高优先级。", "续行拼出的赏金后缀应被拆开分别反查")

	// ③ 手术形态：前导空格的后缀，拼回时空格保留。
	TEST_ASSERT_EQUAL(lang_reverse_suffixed("[base_text] [organ_suffix]"), "实验室技师把上一台烧了。介意帮我们造一台吗？ 此手术每个器官只能做一次。", "带前导空格的后缀应被拆开分别反查")

	// ④ 未登记的后缀：整串 miss，原样返回（不乱拆）。
	TEST_ASSERT_EQUAL(lang_reverse_suffixed("[base_text] And something entirely unregistered."), "[base_text] And something entirely unregistered.", "未登记后缀应原样返回")

	GLOB.i18n_server_locale = saved_locale
	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET] -= I18N_SUFFIX_TEST_LOCALE
	GLOB.i18n_runtime_domains.Remove(I18N_SUFFIX_TEST_LOCALE)
	en_cache -= "unittest.suffix_base"
	en_cache -= "unittest.suffix_bounty"
	en_cache -= "unittest.suffix_organ"
	GLOB.i18n_reverse -= I18N_SUFFIX_TEST_LOCALE

#undef I18N_SUFFIX_TEST_LOCALE
