/// AC 子串兜底必须取**最长**匹配（`match_kind = "LeftmostLongest"`，见 fallback.dm）。
///
/// 守的是一类只在运行期暴露、且随目录增长必然复发的汉化 bug：目录里只要出现「一个词是另一个词
/// 的严格前缀」，默认的 Standard 匹配模式（一命中就替换 = 最短匹配）就会把长词从中间切开，
/// 留下被截断的英文尾巴。线上实例：
///   "Security Officer"（安保官）里先命中 "Security Office"（安保办公室，区域名）
///   → 输出「安保办公室r」，末尾那个 r 就是切剩的。
///
/// 这类冲突无法靠人工维护词表避免——职业名/区域名/物品名天然互为前缀，且每次往目录补词都可能
/// 新引入一对。唯一可靠的解法是匹配模式本身，所以在这里把它钉死。
///
/// 做法与 i18n_unreverse 一致：注入合成的前缀冲突词对 + 临时切到测试 locale，与实际全服 locale 无关。
/datum/unit_test/i18n_ac_longest

#define I18N_AC_TEST_LOCALE "i18n-ac-unittest"
/// 短词，是长词的严格前缀。
#define I18N_AC_SHORT "Zzq Alpha Room"
#define I18N_AC_SHORT_ZH "阿尔法室"
/// 长词 = 短词 + 后缀。最短匹配会把它切成 I18N_AC_SHORT_ZH + "er"。
#define I18N_AC_LONG "Zzq Alpha Roomer"
#define I18N_AC_LONG_ZH "阿尔法室居民"

/datum/unit_test/i18n_ac_longest/Run()
	var/saved_locale = GLOB.i18n_server_locale

	// 注入合成词对。用 Zzq 前缀确保不与真实目录内容碰撞。
	var/list/test_cache = list(
		"ac_short" = I18N_AC_SHORT_ZH,
		"ac_long" = I18N_AC_LONG_ZH,
	)
	var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_cache[DEFAULT_UI_LOCALE] = en_cache
	en_cache["ac_short"] = I18N_AC_SHORT
	en_cache["ac_long"] = I18N_AC_LONG
	GLOB.i18n_cache[I18N_AC_TEST_LOCALE] = test_cache

	// 清掉该 locale 的反查/AC 缓存，逼 lang_fallback_setup 用上面的词对重建自动机。
	GLOB.i18n_reverse.Remove(I18N_AC_TEST_LOCALE)
	GLOB.i18n_fallback_state.Remove(I18N_AC_TEST_LOCALE)
	GLOB.i18n_fallback_single_state.Remove(I18N_AC_TEST_LOCALE)
	GLOB.i18n_fallback_cache.Remove(I18N_AC_TEST_LOCALE)

	GLOB.i18n_server_locale = I18N_AC_TEST_LOCALE

	// 核心断言：对长词跑兜底，必须整词命中长词译文，而不是「短词译文 + 残留英文尾巴」。
	var/got = lang_fallback_apply(I18N_AC_LONG)
	TEST_ASSERT_EQUAL(got, I18N_AC_LONG_ZH, \
		"AC 兜底把长词切碎了：[I18N_AC_LONG] 应整词译为 [I18N_AC_LONG_ZH]，实得 [got]。\
		说明 match_kind 不是 LeftmostLongest（默认 Standard = 最短匹配），\
		线上表现是「安保办公室r」这类被截断的英文尾巴。见 fallback.dm 的 ac_options。")

	// 短词本身仍须正常命中（长匹配优先不能让短词失效）。
	var/short_got = lang_fallback_apply(I18N_AC_SHORT)
	TEST_ASSERT_EQUAL(short_got, I18N_AC_SHORT_ZH, \
		"改用最长匹配后短词反而不命中了：[I18N_AC_SHORT] 实得 [short_got]。")

	GLOB.i18n_server_locale = saved_locale
	GLOB.i18n_reverse.Remove(I18N_AC_TEST_LOCALE)
	GLOB.i18n_fallback_state.Remove(I18N_AC_TEST_LOCALE)
	GLOB.i18n_fallback_single_state.Remove(I18N_AC_TEST_LOCALE)
	GLOB.i18n_fallback_cache.Remove(I18N_AC_TEST_LOCALE)
	GLOB.i18n_cache.Remove(I18N_AC_TEST_LOCALE)
	en_cache.Remove("ac_short")
	en_cache.Remove("ac_long")

#undef I18N_AC_TEST_LOCALE
#undef I18N_AC_SHORT
#undef I18N_AC_SHORT_ZH
#undef I18N_AC_LONG
#undef I18N_AC_LONG_ZH
