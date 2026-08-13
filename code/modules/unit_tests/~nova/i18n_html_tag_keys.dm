/// 目录键里嵌着 HTML 标签的整句，必须仍能在聊天落地层命中。
///
/// 抽取器照抄源码字面量，标签就留在键里；而 `lang_fallback_apply_html` **按标签切块**，只把标签
/// 之间的纯文本送去查表。两边形态天生对不上，于是「目录有键、译文也有，玩家却看到英文」——
/// 而且往往比不翻更难看，因为接着还会被字面 AC 咬中间某个词组：
///   · `"<b>But none of its eggs hatched!</b>"`
///       切出裸句 → 查不到 → 字面 AC 用碎片 "one of" 咬出「But n其中一只 its eggs hatched!」
///   · `"There is a sticker displaying the <b>Chief Engineer's SEAL OF APPROVAL.</b>"`
///       标签**夹在句中**，切成两个半句 → 只有职业名被 AC 咬中
///       →「There is a sticker displaying the 总工程师's SEAL OF APPROVAL」
///
/// 两条落地通道各修一处，这里分别钉住：
///   ① 边缘标签（整句被 `<b>`/`<span>` 包住）→ lang_build_reverse 的「剥标签变体键」；
///   ② 句中内联标签 → lang_fallback_apply_html 的「跨内联标签整段查表」前置 pass。
/datum/unit_test/i18n_html_tag_keys

/datum/unit_test/i18n_html_tag_keys/Run()
	var/saved_locale = GLOB.i18n_server_locale
	if(!islist(GLOB.i18n_cache[LANGUAGE_LOCALE_ZH_HANS]))
		return // 该 locale 目录不存在（精简签出）：跳过而不是误报。
	GLOB.i18n_server_locale = LANGUAGE_LOCALE_ZH_HANS

	var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	var/list/zh_cache = GLOB.i18n_cache[LANGUAGE_LOCALE_ZH_HANS]

	// ① 边缘标签：整句被 <b> 包住。运行期送到查表的是**剥了标签的裸句**。
	var/eggs_key
	var/sticker_key
	for(var/key in en_cache)
		var/en_text = en_cache[key]
		if(en_text == "<b>But none of its eggs hatched!</b>")
			eggs_key = key
		else if(en_text == "There is a sticker displaying the <b>Chief Engineer's SEAL OF APPROVAL.</b>")
			sticker_key = key

	TEST_ASSERT(eggs_key, "目录里应有 <b>But none of its eggs hatched!</b>（上游改了文案就更新本测试）")
	TEST_ASSERT_NOTEQUAL(zh_cache[eggs_key], en_cache[eggs_key], "该键应已译")

	var/bare_eggs = "But none of its eggs hatched!"
	var/eggs_out = lang_fallback_apply(bare_eggs)
	TEST_ASSERT_NOTEQUAL(eggs_out, bare_eggs, \
		"整句被 <b> 包住的目录键，剥标签后应能被裸句命中，实得原文：[eggs_out]")
	TEST_ASSERT(!findtext(eggs_out, "its eggs"), \
		"不应只被字面 AC 咬掉半句、留下英文残句：[eggs_out]")

	// ② 句中内联标签：切块会把整句切成两个半句，必须由前置 pass 整段查表救回。
	TEST_ASSERT(sticker_key, "目录里应有贴纸检查句（上游改了文案就更新本测试）")
	TEST_ASSERT_NOTEQUAL(zh_cache[sticker_key], en_cache[sticker_key], "该键应已译")

	var/sticker_line = "<span class='notice'>[en_cache[sticker_key]]</span>"
	var/sticker_out = lang_fallback_apply_html(sticker_line)
	TEST_ASSERT(!findtext(sticker_out, "There is a sticker displaying"), \
		"句中内联标签把整句切成了两个查不到的半句：[sticker_out]")
	// 外层 span 必须原样保留——前置 pass 只替换 run 内部，绝不能把聊天样式一起吃掉。
	TEST_ASSERT(findtext(sticker_out, "<span class='notice'>"), \
		"外层 span 被前置 pass 吃掉了，聊天配色会丢：[sticker_out]")

	// ③ **模板**的字面段里嵌着标签时同理走不通：聊天层先按标签切块，送进模板引擎的是纯文本块，
	// 而模板要求逐段 findtext 命中带标签的字面段 → 整条永远验证不过。全仓 859 条已译模板是这
	// 形状（高级健康扫描仪整页、回合总结经济行…），译文早就有、只是这条通道走不通。
	// 登记剥标签变体后，切块出来的纯文本应当命中。
	var/list/tag_templates = list(
		"Genetic Stability: 87%." = "遗传",
		"There were 206628 credits collected by crew this shift." = "本班次",
	)
	for(var/rendered in tag_templates)
		var/out = lang_template_apply(rendered, LANGUAGE_LOCALE_ZH_HANS)
		TEST_ASSERT_NOTEQUAL(out, rendered, \
			"字面段含 HTML 标签的模板没能匹配切块后的纯文本：[rendered]")

	// ③b 字面段**不含**标签、但**渲染出来的句子被标签切开**的子情形。
	// `lore_hint = span_notice("You can [EXAMINE_HINT("look closer")] to learn a little more about [target].")`
	// 渲染成 `You can <b>凑近细看</b> to learn a little more about M64 霰弹枪.`——两个实参早就
	// 各自译好了（EXAMINE_HINT 自带 lang_reverse_text），可切块后 "You can " 和
	// " to learn a little more about " 分落两个 chunk，模板要求两段同时命中 → 整条框架留英文。
	// 玩家看到的正是「你可以 凑近细看 to learn a little more about M64 霰弹枪.」这种半中半英。
	// 只有在**未切块的整行**上跑模板才够得着。
	var/lore_line = "<span class='notice'>You can <b>凑近细看</b> to learn a little more about M64 霰弹枪.</span>"
	var/lore_out = lang_fallback_apply_html(lore_line)
	TEST_ASSERT(!findtext(lore_out, "to learn a little more about"), \
		"模板框架被 <b> 切成两半、整条没命中：[lore_out]")

	// ④ 含 `<a>` 的模板：**不登记剥标签变体**（剥掉链接 = 投票入口消失），改为在
	// 「还没切块」的整行作用域上匹配——那时标签还完整，zh 模板连同自己的 `<a href>` 一起填回去。
	// 正反两面都要验，否则很容易「翻是翻了、链接没了」还以为修好了。
	var/bare_vote = "Type vote or click here to place your votes."
	TEST_ASSERT_EQUAL(lang_template_apply(bare_vote, LANGUAGE_LOCALE_ZH_HANS), bare_vote, \
		"含 <a> 的模板被登记了剥标签变体——那会让投票链接消失。")

	var/vote_key
	for(var/key in en_cache)
		var/en_text = en_cache[key]
		if(findtext(en_text, "to place your votes.") && findtext(en_text, "<a href") && copytext(en_text, 1, 4) == "{0}")
			vote_key = key
			break
	TEST_ASSERT(vote_key, "目录里应有带 <a> 的投票模板（上游改了文案就更新本测试）")
	// 按真实渲染形态构造：模板实参填回去、外面套 span_infoplain 那层。
	var/vote_line = replacetext(replacetext(lang_tpl_normalize(en_cache[vote_key]), \
		"{0}", "<b>Transfer vote started by automatic transfer.</b>"), "{1}", "1 minute")
	vote_line = "<span class='infoplain'>[vote_line]</span>"
	var/vote_out = lang_fallback_apply_html(vote_line)
	TEST_ASSERT(!findtext(vote_out, "to place your votes"), \
		"整行作用域上含 <a> 的模板仍未命中：[vote_out]")
	TEST_ASSERT(findtext(vote_out, "byond://winset?command=vote"), \
		"译文把投票链接弄丢了——玩家将无法点击投票：[vote_out]")

	GLOB.i18n_server_locale = saved_locale
