/// 恐惧症「本地化触发词」正则的不变量测试。
///
/// 中文触发词不能并进英文那条正则：原正则两端是 `(\b|\A)…(\b|\|)`，而 `\b` 是 `\w`（[A-Za-z0-9_]）
/// 与非 `\w` 的交界——中文字符两侧都非 `\w`，句中的中文词根本产生不了边界，永远匹配不上。
/// 所以另建一条**无边界**正则（construct_phobia_regex_localized），两条并列匹配。
///
/// 消费侧（datums/components/fearful/sources/phobia.dm）依赖 `group[2]` 取命中词、用 `$2`/`$3`
/// 做高亮替换，所以本地化正则的**分组布局必须与英文正则一致**。这两点都是「不跑起来看不出来」的
/// 隐性契约，回归了就是恐惧症静默失效（中文服里说中文永远不触发），故在编译期锁住。
/datum/unit_test/i18n_phobia_localized_regex

#define I18N_PHOBIA_TEST_LOCALE "i18n-phobia-unittest"

/datum/unit_test/i18n_phobia_localized_regex/Run()
	var/saved_locale = GLOB.i18n_server_locale
	var/list/saved_tables = GLOB.i18n_scoped_tables["phobia_words.json"]

	// 注入合成词表，绕开磁盘 JSON（测试不依赖 phobia_words.json 的具体内容）。
	GLOB.i18n_server_locale = I18N_PHOBIA_TEST_LOCALE
	GLOB.i18n_scoped_tables["phobia_words.json"] = list(
		I18N_PHOBIA_TEST_LOCALE = list("unittest_cat" = list("外星人", "飞碟")),
	)

	var/regex/localized = construct_phobia_regex_localized("unittest_cat")
	TEST_ASSERT_NOTNULL(localized, "已登记词表的类别应能构建出本地化正则")

	// ① 句**中**的中文词必须命中——这正是英文那条正则（\b 边界）做不到的场景。
	TEST_ASSERT(localized.Find("我最怕外星人了") != 0, "句中的中文触发词应命中（无词边界匹配）")
	TEST_ASSERT_EQUAL(localized.group[2], "外星人", "group\[2\] 应是命中的触发词（消费侧据此高亮）")

	// ② 消费侧契约：`Replace(…, "[span_phobia("$2")]$3")` 必须产出「高亮的触发词 + 原句其余部分」。
	// 直接验产出而不是断言 group[3] 的具体值——BYOND 里零长匹配的捕获组返回 null 而非空串，
	// 英文正则的 `('?s*)` 在没有 's 后缀时同样是 null，生产代码本来就一直在处理这种情况。
	// 要锁的是「$3 被正常替换掉、不残留字面量、不吞掉原文」，这才是两条正则可互换的真正含义。
	var/replaced = localized.Replace("我最怕外星人了", "[span_phobia("$2")]$3")
	TEST_ASSERT(findtext(replaced, "外星人") != 0, "替换结果应仍含触发词（被高亮包裹）")
	TEST_ASSERT(findtext(replaced, "我最怕") != 0, "替换不应吞掉触发词之前的原文")
	TEST_ASSERT(findtext(replaced, "了") != 0, "替换不应吞掉触发词之后的原文")
	TEST_ASSERT(findtext(replaced, "$3") == 0, "$3 应被正则替换掉，不能以字面量残留在玩家可见文本里")
	TEST_ASSERT(findtext(replaced, "null") == 0, "空捕获组不应被渲染成字面 null")

	// ③ 句首/句尾同样命中（\A 分支与结尾边界在中文下都不成立，故必须靠无边界）。
	TEST_ASSERT(localized.Find("飞碟出现了") != 0, "句首的中文触发词应命中")
	TEST_ASSERT(localized.Find("天上有飞碟") != 0, "句尾的中文触发词应命中")

	// ④ 未登记的词不应误伤。
	TEST_ASSERT_EQUAL(localized.Find("今天天气不错"), 0, "未登记的中文不应命中")

	// ⑤ 未登记类别返回 null——消费侧用 `?.` 调用，null 表示「该类别无本地化词」。
	TEST_ASSERT_NULL(construct_phobia_regex_localized("unittest_missing"), "未登记类别应返回 null")

	// ⑥ locale==en 时词表为空 → 不构建正则（默认态零行为变化）。
	GLOB.i18n_server_locale = DEFAULT_UI_LOCALE
	GLOB.i18n_scoped_tables -= "phobia_words.json"
	TEST_ASSERT_NULL(construct_phobia_regex_localized("unittest_cat"), "locale==en 时不应有本地化触发正则")

	GLOB.i18n_server_locale = saved_locale
	if(islist(saved_tables))
		GLOB.i18n_scoped_tables["phobia_words.json"] = saved_tables
	else
		GLOB.i18n_scoped_tables -= "phobia_words.json"

#undef I18N_PHOBIA_TEST_LOCALE
