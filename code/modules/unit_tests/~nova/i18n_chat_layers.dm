/// 聊天落地层的契约。字面 AC 整层删除之后，这里守的是「**没有**子串替换层」这件事本身。
///
/// 守三条：
///   a. 无拉丁可见文本的中文 HTML（带 span）在入口短路，原样返回、不切块；
///   b. 整句精确反查命中；而同一个词组出现在**更长的句子中间**时必须原样保留英文——
///      这正是字面 AC 会做、而落地层现在**不该**做的事（AC 无词边界、取最短匹配，
///      产出「中文碎片嵌在英文句里」，生产语料实测比全英文更难看）；
///   c. 注入的 locale 必须在 Destroy() 恢复——TEST_ASSERT 失败会 return，恢复不能写在 Run() 末尾。
/datum/unit_test/i18n_chat_layers
	/// 注入前的 i18n 全局态，Destroy() 里恢复。
	var/saved_locale
	var/list/injected_en_keys

#define I18N_CHAT_LAYERS_LOCALE "i18n-chat-layers-unittest"
#define I18N_CHAT_LAYERS_EXACT "Zzqv Unique Gadget is online."
#define I18N_CHAT_LAYERS_EXACT_ZH "合成装置已上线。"
#define I18N_CHAT_LAYERS_PHRASE "Zzqv Unique Gadget"
#define I18N_CHAT_LAYERS_PHRASE_ZH "合成装置"
#define I18N_CHAT_LAYERS_CARRIER "Please deploy the Zzqv Unique Gadget immediately!"
#define I18N_CHAT_LAYERS_CHINESE_INNER "你仔细查看了这块合成地板。"
#define I18N_CHAT_LAYERS_CHINESE_HTML "<span class='notice'>你仔细查看了这块合成地板。</span>"

/datum/unit_test/i18n_chat_layers/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_server_locale = saved_locale
		var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
		if(islist(en_cache) && islist(injected_en_keys))
			for(var/key in injected_en_keys)
				en_cache -= key
		GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET] -= I18N_CHAT_LAYERS_LOCALE
		GLOB.i18n_runtime_domains -= I18N_CHAT_LAYERS_LOCALE
		GLOB.i18n_reverse -= I18N_CHAT_LAYERS_LOCALE
		GLOB.i18n_reverse_norm -= I18N_CHAT_LAYERS_LOCALE
		GLOB.i18n_fallback_cache -= I18N_CHAT_LAYERS_LOCALE
		saved_locale = null
	return ..()

/datum/unit_test/i18n_chat_layers/Run()
	// 记录恢复所需的状态**再**改全局：Destroy() 靠 saved_locale 非空判断该不该恢复。
	saved_locale = GLOB.i18n_server_locale

	var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE] = en_cache

	var/list/test_pairs = list(
		"unittest.chat_layers_exact" = list(I18N_CHAT_LAYERS_EXACT, I18N_CHAT_LAYERS_EXACT_ZH),
		"unittest.chat_layers_phrase" = list(I18N_CHAT_LAYERS_PHRASE, I18N_CHAT_LAYERS_PHRASE_ZH),
	)
	injected_en_keys = test_pairs.Copy()
	var/list/test_cache = list()
	for(var/key in test_pairs)
		var/list/pair = test_pairs[key]
		en_cache[key] = pair[1]
		test_cache[key] = pair[2]

	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][I18N_CHAT_LAYERS_LOCALE] = test_cache
	GLOB.i18n_runtime_domains -= I18N_CHAT_LAYERS_LOCALE
	GLOB.i18n_reverse -= I18N_CHAT_LAYERS_LOCALE
	GLOB.i18n_reverse_norm -= I18N_CHAT_LAYERS_LOCALE
	GLOB.i18n_fallback_cache -= I18N_CHAT_LAYERS_LOCALE
	GLOB.i18n_server_locale = I18N_CHAT_LAYERS_LOCALE

	// a. 无拉丁中文 HTML（带 span）入口短路：输出 === 输入，且内层文本未进 fallback cache
	// （进了 cache 说明切块器把内层交给了 lang_fallback_apply）。
	var/chinese_out = lang_fallback_apply_html(I18N_CHAT_LAYERS_CHINESE_HTML, I18N_CHAT_LAYERS_LOCALE)
	TEST_ASSERT_EQUAL(chinese_out, I18N_CHAT_LAYERS_CHINESE_HTML, \
		"无拉丁中文 HTML 应原样返回，实得 [chinese_out]")
	var/list/cache = GLOB.i18n_fallback_cache[I18N_CHAT_LAYERS_LOCALE]
	TEST_ASSERT(!islist(cache) || !(I18N_CHAT_LAYERS_CHINESE_INNER in cache), \
		"切块器跑了：内层中文被写入 fallback cache，说明 apply_html 入口没有无拉丁短路")

	// b. 整句精确反查命中。
	var/exact_out = lang_fallback_apply(I18N_CHAT_LAYERS_EXACT, I18N_CHAT_LAYERS_LOCALE)
	TEST_ASSERT_EQUAL(exact_out, I18N_CHAT_LAYERS_EXACT_ZH, \
		"整句精确反查应命中：[I18N_CHAT_LAYERS_EXACT] 实得 [exact_out]")

	// b. 同一个词组在更长句子中间：**必须原样保留英文**。
	//    这条是字面 AC 已被整层删除的回归门禁 —— 词组本身在目录里、也译好了，
	//    但落地层没有任何子串替换能力，只做整串精确与模板逆匹配。
	//    若哪天有人重新引入子串层，这里会立刻变红。
	var/carrier_out = lang_fallback_apply(I18N_CHAT_LAYERS_CARRIER, I18N_CHAT_LAYERS_LOCALE)
	TEST_ASSERT_EQUAL(carrier_out, I18N_CHAT_LAYERS_CARRIER, \
		"句中词组不得被子串替换：[I18N_CHAT_LAYERS_CARRIER] 实得 [carrier_out]")
	TEST_ASSERT(!findtext(carrier_out, I18N_CHAT_LAYERS_PHRASE_ZH), \
		"落地层不应把中文碎片塞进英文句子里，实得 [carrier_out]")

#undef I18N_CHAT_LAYERS_LOCALE
#undef I18N_CHAT_LAYERS_EXACT
#undef I18N_CHAT_LAYERS_EXACT_ZH
#undef I18N_CHAT_LAYERS_PHRASE
#undef I18N_CHAT_LAYERS_PHRASE_ZH
#undef I18N_CHAT_LAYERS_CARRIER
#undef I18N_CHAT_LAYERS_CHINESE_INNER
#undef I18N_CHAT_LAYERS_CHINESE_HTML
