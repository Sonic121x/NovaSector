/// 守三类「实测才暴露出来」的落地缺口，它们的共同点是：**译文明明在目录里，玩家看到的却是英文
/// 或半截乱码**——静态审计与合成数据都测不出，只有拿真目录按真实渲染形态跑才会红。
///
///   ① **LANG 的非文本实参从前完全没被本地化**。rewrite 把 `[src]` 抬成实参时给的是 atom 本身
///      （`list(src)` 全仓 3000+ 处），而 lang_interpolate 只对 istext 分支调 lang_localize_arg
///      → 插进去的是英文名，只能指望聊天层的字面 AC 去捞；AC 有多词门槛，于是单词名永远英文
///      （实测「你仔细查看The floor，但没发现什么值得注意的……」）。顺带 `"[atom]"` 还会让 BYOND
///      自己补一个 "The "。
///   ② **目录原值含 BYOND 字面转义/文法宏**（`\improper`、`\n`、`\[`）。它们只在编译期字面量里被
///      引擎处理；从 JSON 取回后是字面字符 → 「\improper 太阳系精品热饮」。LANG 路径末尾早有这道
///      处理，按类型取键那条新路当时漏了。
///   ④ **运行期把区域名拼进 name 的那批**（APC / 空气警报 / 火警器）：整串既不是目录键、又常以
///      单词结尾，精确反查与字面 AC 双双够不着（实测「Courtroom APC」「Brig 空气警报」）。
///   ③ **两词碎片进字面 AC 字典**会在句子中间开火：`"You can"→"你可以"` 把
///      `You can't stop me, Owl!` 咬成「你可以't stop me, Owl!」。
/datum/unit_test/i18n_display_leaks
	var/saved_locale
	var/saved_locale_resolved
	var/list/injected_en_keys

#define I18N_LEAK_LOCALE "i18n-leak-unittest"
#define I18N_LEAK_NAME "Zxqv Thranok Unit"
/// 目录里存的是源码字面形态：反斜杠 + improper（**不是**编译期的控制字节）。
#define I18N_LEAK_NAME_ZH "\\improper 兹克夫单元"
#define I18N_LEAK_FRAGMENT "Zxqv can"

/obj/item/i18n_display_leak_test
	name = I18N_LEAK_NAME

/datum/unit_test/i18n_display_leaks/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_server_locale = saved_locale
		GLOB.i18n_locale_resolved = saved_locale_resolved
		var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
		if(islist(en_cache))
			for(var/key in injected_en_keys)
				en_cache -= key
		GLOB.i18n_cache -= I18N_LEAK_LOCALE
		GLOB.i18n_reverse -= I18N_LEAK_LOCALE
		GLOB.i18n_unreverse -= I18N_LEAK_LOCALE
		GLOB.i18n_type_name_keys.Cut()
		GLOB.i18n_type_desc_keys.Cut()
		GLOB.i18n_type_var_tables_loaded = FALSE
		saved_locale = null
	return ..()

/datum/unit_test/i18n_display_leaks/Run()
	var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_cache[DEFAULT_UI_LOCALE] = en_cache

	var/list/pairs = list(
		"unittest.leak_name" = list(I18N_LEAK_NAME, I18N_LEAK_NAME_ZH),
		"unittest.leak_fragment" = list(I18N_LEAK_FRAGMENT, "兹克夫可以"),
		"unittest.leak_template" = list("You pull the string on \the {0}.", "你拉了拉 \the {0} 上的绳子。"),
	)
	var/list/locale_cache = list()
	for(var/key in pairs)
		var/list/pair = pairs[key]
		en_cache[key] = pair[1]
		locale_cache[key] = pair[2]
	saved_locale = GLOB.i18n_server_locale
	saved_locale_resolved = GLOB.i18n_locale_resolved
	injected_en_keys = pairs.Copy()
	GLOB.i18n_cache[I18N_LEAK_LOCALE] = locale_cache
	GLOB.i18n_server_locale = I18N_LEAK_LOCALE
	GLOB.i18n_locale_resolved = TRUE
	GLOB.i18n_reverse -= I18N_LEAK_LOCALE
	GLOB.i18n_fallback_state -= I18N_LEAK_LOCALE
	GLOB.i18n_fallback_cache -= I18N_LEAK_LOCALE

	var/obj/item/i18n_display_leak_test/subject = allocate(/obj/item/i18n_display_leak_test)
	// 类型表按类型取键（fixture 不进目录，注入合成条目）。
	var/list/name_table = lang_type_name_keys()
	name_table[/obj/item/i18n_display_leak_test] = "unittest.leak_name"

	// ② 目录原值里的字面 `\improper` 不得漏到显示层。
	var/display_name = subject.lang_localize_name_for_display(subject.name)
	TEST_ASSERT_EQUAL(display_name, "兹克夫单元", "类型表返回的目录原值没有剥掉字面文法宏")

	// ① atom 实参必须过显示边界：既不能留英文名，也不能带上 BYOND 自动补的 "The "。
	var/line = lang_resolve("unittest.leak_template", list(subject), I18N_LEAK_LOCALE)
	TEST_ASSERT(!findtext(line, I18N_LEAK_NAME), "LANG 的 atom 实参没有本地化，插进去的还是英文名：[line]")
	TEST_ASSERT(!findtext(line, "The "), "atom 实参带出了 BYOND 自动补的冠词：[line]")
	TEST_ASSERT(findtext(line, "兹克夫单元"), "atom 实参没有落到译名：[line]")

	// ④ 「区域名 + 类型名」合成实例名：两段分别翻、尾巴原样。
	var/area/test_area = get_area(subject)
	if(!isnull(test_area))
		var/saved_area_name = test_area.name
		test_area.name = "Zxqv Sector"
		en_cache["unittest.leak_area"] = "Zxqv Sector"
		locale_cache["unittest.leak_area"] = "兹克夫星区"
		injected_en_keys["unittest.leak_area"] = TRUE
		GLOB.i18n_reverse -= I18N_LEAK_LOCALE
		var/list/area_table = lang_type_name_keys()
		area_table[test_area.type] = "unittest.leak_area"
		subject.name = "Zxqv Sector Zxqv Thranok Unit tag9"
		TEST_ASSERT_EQUAL(
			subject.lang_localize_name_for_display(subject.name),
			"兹克夫星区 兹克夫单元 tag9",
			"「区域名 + 类型名 + id」合成名没有被分段本地化",
		)
		subject.name = I18N_LEAK_NAME
		test_area.name = saved_area_name

	// ⑤ 说话者名字：聊天行里的名字被包在 `<span class='name'>` 里**独立成块**经过落地层，
	// 整句反查与模板引擎都够不着它，只剩字面 AC —— 而 AC 有多词门槛，单词名（wolf/animal）永远
	// 捞不着，玩家看到「The wolf 说，「……」」。而且它到达 compose_message 时**已经带了冠词**
	// （`get_voice()` 返回 `"[src]"`，BYOND 对非专名自动补 "The"），所以不能直接喂给显示边界
	// ——那条按 `name == initial(name)` 判身份名，带冠词的串会被当身份名拒翻。
	var/obj/item/i18n_display_leak_test/speaker_probe = allocate(/obj/item/i18n_display_leak_test)
	var/composed = subject.compose_message(speaker_probe, null, "test", null, null)
	TEST_ASSERT(findtext(composed, "兹克夫单元"), "说话者名字没有本地化：[composed]")
	TEST_ASSERT(!findtext(composed, I18N_LEAK_NAME), "说话者名字仍是英文：[composed]")

	// ③ 没有句末标点的两词碎片不得进字面 AC 字典（否则在句子中间开火）。
	TEST_ASSERT(!lang_fallback_pattern_safe(I18N_LEAK_FRAGMENT), "两词碎片仍被放进 AC 字典，会从单词内部开火")
	var/sentence = lang_fallback_apply("Zxqv can't stop me, Owl!", I18N_LEAK_LOCALE)
	TEST_ASSERT_EQUAL(sentence, "Zxqv can't stop me, Owl!", "AC 从单词内部开火了：[sentence]")

#undef I18N_LEAK_LOCALE
#undef I18N_LEAK_NAME
#undef I18N_LEAK_NAME_ZH
#undef I18N_LEAK_FRAGMENT
