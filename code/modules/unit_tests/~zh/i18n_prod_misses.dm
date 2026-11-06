/// 生产服漏翻日志（2026-11-03 ~ 11-05，16 局）里几类**整类**缺口的回归门禁，全部按运行期真实形态喂真目录：
///   ① 归一表冲突：`MOD control unit` / `\improper MOD control unit` 译文只差一个空格就被判歧义、两条都删；
///   ② 只剩字符串的「区域名 + 其余」合成名（空气警报负载里的通风口名）；
///   ③ 「数量/已译名 + 短语」前缀（订单清单 `1 Suit Storage Unit`、`食盐 large hypovial`）；
///   ④ 列表记号与多行拼接（指挥部状态摘要的站点特质、站点目标）；
///   ⑤ 空括号尾巴与纯数字前缀的实例名（身份卡、全息芯片）。
/// 每条都配反例，证明规则没有把普通句子劈开。locale 不是 zh-Hans 时跳过（见 i18n_zh_catalog_ready）。
/datum/unit_test/i18n_prod_misses
	var/saved_locale

/datum/unit_test/i18n_prod_misses/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_server_locale = saved_locale
	return ..()

/datum/unit_test/i18n_prod_misses/Run()
	saved_locale = GLOB.i18n_server_locale
	if(!i18n_zh_catalog_ready())
		return
	GLOB.i18n_server_locale = LANGUAGE_LOCALE_ZH_HANS
	var/locale = LANGUAGE_LOCALE_ZH_HANS

	// ① 运行期名字带 \improper 标记字节，只能落到归一表；两条同英文来源的译文只差空白。
	var/mod_name = "\improper MOD control unit"
	var/localized_mod = lang_reverse_text(mod_name)
	TEST_ASSERT(lang_contains_cjk(localized_mod), "归一表冲突（译文只差空白）不应让 MOD control unit 整条回落英文：[localized_mod]")
	TEST_ASSERT(lang_contains_cjk(lang_reverse_text("MOD Control Unit")), "大小写变体同样应落到归一表")

	// ② 区域名 + 其余（只剩字符串）。从本局地图里挑一个能翻、名字是多词的区域。
	var/area/sample_area
	var/localized_area
	for(var/area/candidate as anything in GLOB.areas)
		var/candidate_name = format_text(candidate.name)
		if(!findtext(candidate_name, " ") || findtext(candidate_name, "'"))
			continue
		var/candidate_localized = candidate.lang_localize_name_for_display(candidate.name)
		if(!lang_contains_cjk(candidate_localized))
			continue
		sample_area = candidate
		localized_area = candidate_localized
		break
	if(sample_area)
		var/area_name = format_text(sample_area.name)
		var/vent_name = "[area_name] 全色空气通风口 KULB2"
		var/localized_vent = lang_localize_chain(vent_name, locale, allow_template = TRUE)
		TEST_ASSERT_EQUAL(localized_vent, "[localized_area] 全色空气通风口 KULB2", "空气警报负载里的通风口名应翻区域前缀、保留已译类型名与 id")
		TEST_ASSERT_NULL(lang_reverse_area_prefixed("[area_name] zxqv quietly hums along", locale), "其余部分落不了地时不得把句子劈成半截")
	else
		TEST_NOTICE(src, "本局地图没有可翻的多词区域，跳过区域前缀断言")

	// ③ 前导数量 / 已译名。
	var/localized_order = lang_localize_chain("1 Suit Storage Unit", locale, allow_template = TRUE)
	TEST_ASSERT(findtext(localized_order, "1 ") == 1 && lang_contains_cjk(localized_order), "数量前缀 + 整串命中的短语应落地：[localized_order]")
	var/localized_delta = lang_localize_chain("+3 bluespace crystal", locale, allow_template = TRUE)
	TEST_ASSERT(findtext(localized_delta, "+3 ") == 1 && lang_contains_cjk(localized_delta), "增减前缀应落地：[localized_delta]")
	var/localized_vial = lang_localize_chain("食盐 large hypovial", locale, allow_template = TRUE)
	TEST_ASSERT(findtext(localized_vial, "食盐") == 1 && !findtext(localized_vial, "hypovial"), "已译前缀 + 英文基础名应补译基础名：[localized_vial]")
	TEST_ASSERT_NULL(lang_reverse_serial_prefixed("- zxqv bluespace crystal", locale), "不含数字也不含中文的前导记号不归本条管")

	// ④ 指挥部状态摘要：`<i>特质名</i> - 报告` 切块后的 ` - 报告`，以及 `\n` 拼接的站点目标。
	var/bullet = " - Due to good performance, we've provided your station with luxury escape pods."
	var/localized_bullet = lang_localize_chain(bullet, locale, allow_template = TRUE)
	TEST_ASSERT(lang_contains_cjk(localized_bullet) && !findtext(localized_bullet, "performance"), "列表记号后的整句应落地：[localized_bullet]")
	TEST_ASSERT_NULL(lang_reverse_edge_decorated("-18 zxqv crystal", locale), "负数不是列表记号")
	var/goal = list(
		"The station is located in a zone full of space debris.",
		"We have a prototype shielding system you must deploy to reduce collision-related accidents.",
		"",
		"You can order the satellites and control systems at cargo.",
	).Join("\n")
	var/localized_goal = lang_localize_chain(goal, locale, allow_template = TRUE)
	TEST_ASSERT(!findtext(localized_goal, "space debris") && !findtext(localized_goal, "satellites"), "多行拼接的站点目标应逐行落地：[localized_goal]")
	TEST_ASSERT_EQUAL(length(splittext(localized_goal, "\n")), 4, "逐行落地必须保留换行结构")

	// ⑤ 实例名：空括号尾巴（字符串）与纯数字前缀（atom 显示边界）。
	var/localized_card = lang_localize_chain("silver identification card ()", locale, allow_template = TRUE)
	TEST_ASSERT(lang_contains_cjk(localized_card) && copytext(localized_card, -3) == " ()", "空括号尾巴应翻前半段、保留括号：[localized_card]")
	var/obj/item/holochip/chip = allocate(/obj/item/holochip, null, 500)
	var/localized_chip = chip.lang_localize_name_for_display(chip.name)
	TEST_ASSERT(findtext(localized_chip, "500 ") == 1 && !findtext(localized_chip, "holochip"), "全息芯片名应翻基础名、保留金额：[localized_chip]")

	// 储物袋放入消息：中文模板不得再引用英文介词槽（in/on）。
	var/put_message = LANG("datum.686a163dc1f81437", list("zxqv thing", "in", "zxqv bag"))
	TEST_ASSERT(!findtext(put_message, " in"), "放入消息不应夹带英文介词：[put_message]")

	// 发薪日：bank_card_talk 的事件名实参。
	var/payday = LANG("datum.4cd20f13fbb84ab3", list("Payday", 5, "cr"))
	TEST_ASSERT(!findtext(payday, "Payday"), "发薪事件名应翻译：[payday]")
