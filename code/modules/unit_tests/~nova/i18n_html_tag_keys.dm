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

	GLOB.i18n_server_locale = saved_locale
