/// 用**真目录**跑一遍显示链路的端到端抽查。
///
/// i18n_template_match 注入合成模板验证引擎逻辑，i18n_unreverse 验证反查往返——两者都用假数据，
/// 所以「引擎没问题、真目录里那条却翻不出来」这一格是空的。玩家上报的漏译十有八九落在这一格：
/// 键在、译文在、调用点也对，中间某一环（转义、锚长门槛、半翻译自匹配…）把它悄悄吃掉。
///
/// 这里挑几条**形态各异**的真实条目，按它们在游戏里的实际渲染形态喂进落地层，断言出来是中文：
///   ① 插值句经模板逆匹配（手术可见消息，span 包裹 + 两个实参）；
///   ② 纯串经整串反查（LANG 实参碎片）；
///   ③ 域内表（史莱姆颜色、警报类别，故意不在全局反查表里）。
/// 目录条目被删或被改成半翻译时这里会红——比等玩家截图快。
/datum/unit_test/i18n_real_catalog

/datum/unit_test/i18n_real_catalog/Run()
	var/saved_locale = GLOB.i18n_server_locale
	if(!islist(GLOB.i18n_cache[LANGUAGE_LOCALE_ZH_HANS]))
		return // 该 locale 目录不存在（精简签出）：跳过而不是误报。
	GLOB.i18n_server_locale = LANGUAGE_LOCALE_ZH_HANS

	// ① 插值句：手术台上每一步都长这样（display_results → visible_message → to_chat 的 AC/模板层）。
	// 分层断言：目录 → 引擎就绪 → 裸句 → 带 span 的整条。哪一层断的一目了然。
	var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	var/list/zh_cache = GLOB.i18n_cache[LANGUAGE_LOCALE_ZH_HANS]
	TEST_ASSERT_EQUAL(en_cache["datum.67ca09d3"], "{0} begins to make an incision in the organs within {1}.", "目录里的英文模板应仍是这条（键换了就更新本测试）")
	TEST_ASSERT_NOTEQUAL(zh_cache["datum.67ca09d3"], en_cache["datum.67ca09d3"], "该键应已译")
	TEST_ASSERT(lang_tpl_setup(LANGUAGE_LOCALE_ZH_HANS), "zh-Hans 的模板逆匹配索引应能建起来")

	var/bare = "Isshiki Iroha begins to make an incision in the organs within YC Bond's chest."
	var/marked = rustg_acreplace("i18n_tpl_[LANGUAGE_LOCALE_ZH_HANS]", bare)
	TEST_ASSERT_NOTEQUAL(marked, "", "锚自动机返回空串 = setup 静默失败（见 i18n_tpl_stx 注释里那次 JSON 控制符事故）")
	TEST_ASSERT_NOTEQUAL(marked, bare, "句中应至少命中一个模板锚；记录数 [length(GLOB.i18n_tpl_records[LANGUAGE_LOCALE_ZH_HANS])]")
	TEST_ASSERT_NOTEQUAL(lang_template_apply(bare, LANGUAGE_LOCALE_ZH_HANS), bare, "裸句应被模板逆匹配翻译")

	var/incision = "<span class='notice'>[bare]</span>"
	var/incision_out = lang_fallback_apply_html(incision)
	TEST_ASSERT_NOTEQUAL(incision_out, incision, "带 span 的整条同样应被翻译（聊天落地形态）")

	// ①b 同一把锚下的**短模板**。上面那条是「organs within」长模板，它自带一段极长的独占锚，
	// 就算候选排序出问题也容易蒙对；真正脆的是共用前缀锚 " begins to make an incision in " 的
	// 那一组——候选里按字面量总长排在前面的是 "…{1}'s reagent processor…"，必须先验证失败、
	// 再轮到通用的那条。玩家实报「Default Cyborg-973 begins to make an incision in Orange's head.」
	// 整句留英文，就是这一格塌了；organs within 那条同时还是好的，所以只测长模板看不出来。
	var/list/short_lines = list(
		"Default Cyborg-973 begins to make an incision in Orange's head.",
		"Default Cyborg-973 begins to retract the skin in Orange's head.",
		"Default Cyborg-973 begins to mend the incision in Orange's chest.",
		"Default Cyborg-973 searches for implants in Orange.",
		"Default Cyborg-973 succeeds!",
	)
	for(var/line in short_lines)
		var/out = lang_template_apply(line, LANGUAGE_LOCALE_ZH_HANS)
		TEST_ASSERT_NOTEQUAL(out, line, "手术可见消息应被模板逆匹配翻译，实得原文：[line]")

	// ②a 碎片**绝不能**在单词内部开火（见 i18n_ac_fragment 的闸门）。这里用真目录再守一道：
	// 线上表现是「But n其中一只 its eggs hatched!」「searches for植入了in Orange」。
	var/eggs = "But none of its eggs hatched!"
	TEST_ASSERT(!findtext(lang_fallback_apply(eggs), "n其中一只"), \
		"碎片 pattern 在单词内部开火：[lang_fallback_apply(eggs)]")

	// ①c 整串精确反查必须**赢过**泛化模板。目录里同时存在整句键和「三两个词 + 占位符」的骨架
	// 模板时，若模板先跑就会劫持整句、把捕获到的英文塞回中文脚手架：
	//   `It appears to {0}`→`它看起来像{0}` 把正电子脑那句吃成「它看起来像be completely inactive.」
	//   `{0} produces a {1}.`→`{0}产出{1}。` 把金史莱姆那句吃成「Fully heals the target and产出random coin。」
	// 两句的整句译文一直都在目录里，只是排在模板之后永远轮不到。
	var/list/whole_sentences = list(
		"It appears to be completely inactive. The reset light is blinking.",
		"Fully heals the target and produces a random coin.",
	)
	var/regex/ascii_letters = GLOB.i18n_ascii_letter_regex
	for(var/sentence in whole_sentences)
		var/out = lang_fallback_apply(sentence)
		TEST_ASSERT_NOTEQUAL(out, sentence, "整句在目录里却没被翻译：[sentence]")
		TEST_ASSERT(!ascii_letters.Find(out), \
			"整句被泛化模板劫持、译文里还裹着英文残句：[out]")

	// ② 纯串：被改写抬成 LANG 实参的碎片，经 lang_localize_arg 的整串反查。
	TEST_ASSERT_NOTEQUAL(lang_localize_arg("is secured and ready to be used!"), "is secured and ready to be used!", "LANG 实参碎片应整串反查命中")

	// ③ 逐项翻的状态词列表（鱼的健康警告、材料属性详检）：整句拼完不是目录键，只能逐项过
	// lang_localize_arg 再用顿号连接。断言的是**这条通道**，不是 AC——拿裸碎片喂 AC 本来就不该命中。
	TEST_ASSERT_NOTEQUAL(lang_localize_arg("drowning"), "drowning", "鱼的状态词应经 _state_words 翻译")
	TEST_ASSERT_NOTEQUAL(lang_english_list(list("starving", "drowning")), "starving and drowning", "状态词列表应逐项翻并用顿号连接")

	// ④ 域内表：这些**故意**不在全局反查表里，只能经各自的 lang_* 落地。
	TEST_ASSERT_NOTEQUAL(lang_slime_colour("purple"), "purple", "史莱姆颜色应经域内表翻译")
	TEST_ASSERT_EQUAL(lang_reverse_text("purple"), "purple", "史莱姆颜色**不应**进全局反查表（会误伤 icon_state/switch）")
	TEST_ASSERT_NOTEQUAL(lang_alarm_type("Power"), "Power", "警报类别应经域内表翻译")
	TEST_ASSERT_NOTEQUAL(lang_wire_colour("crimson"), "crimson", "线缆颜色应经域内表翻译")
	TEST_ASSERT_EQUAL(lang_reverse_text("crimson"), "crimson", "线缆颜色**不应**进全局反查表（同时是 CSS 颜色名与 act 标识符）")

	// ⑤ 回合总结的反派目标行：explanation_text 是**裸插值**赋值（objective.dm 没走 LANG），
	// 只能靠边界模板逆匹配救。锚遮蔽修好之前它是半翻译（内层换成中文、外层留英文）。
	var/objective_line = "Prevent Kabu Weien, the Cargo Technician, from escaping alive."
	var/objective_out = lang_template_apply(objective_line, LANGUAGE_LOCALE_ZH_HANS)
	TEST_ASSERT_NOTEQUAL(objective_out, objective_line, "反派目标行应被模板逆匹配整条翻译")
	TEST_ASSERT(!findtext(objective_out, "from escaping alive"), "不应只翻一半、留下英文残句：[objective_out]")

	GLOB.i18n_server_locale = saved_locale
