/// 守护 TGUI 负载的**非破坏性**本地化：负载值保持 canonical English，译文单独走 overlay
/// （`json_data["i18n"]`），由 TS 在渲染期查表显示。
///
/// 为什么这条必须有测试：破坏性改写的失败形态是**静默**的 —— 前端把被译成中文的显示值原样回传，
/// 服务端仍拿英文比较/查表，`ui_act` 直接 return，玩家看到「点了没反应、无任何报错」。出生管理器、
/// DNA 控制台染色体、大气警报「清除」都栽在这上面，而且只有**多词**值坏（单词过不了多词门槛），
/// 极易被当成个别条目漏译。
///
/// 断言：
///   ① 普通键（可能兼作标识符）：值**原样不动**，译文进 overlay；
///   ② 扁平串列表元素（大气警报的区域名列表即此形态）：同样不动 + 进 overlay；
///   ③ `payload_prose_keys` 里的散文键：仍就地改写（它们渲染在 auto-localize 够不到的位置，
///      且散文不可能被 act() 拿去比较），且**不**进 overlay；
///   ④ `payload_skip_keys` 子树：完全不碰；
///   ⑤ 不传 overlay 的旧调用（早期 string_cache 那条路）：行为与从前一致，一律就地改写。
/datum/unit_test/i18n_payload_overlay
	var/saved_locale
	var/saved_locale_resolved
	var/list/injected_en_keys

#define I18N_OVERLAY_LOCALE "i18n-overlay-unittest"
// 生造词：真实英文词会在真目录/伪 locale 下被译掉，断言就从「测落地逻辑」变成「测目录内容」。
#define I18N_OVERLAY_NAME "Zxqv Thranok Unit"
#define I18N_OVERLAY_PROSE "Zxqv thranok drifts through the quiet dark."
#define I18N_OVERLAY_FLAT "Zxqv Thranok Sector"

/datum/unit_test/i18n_payload_overlay/Destroy()
	if(!isnull(saved_locale))
		GLOB.i18n_server_locale = saved_locale
		GLOB.i18n_runtime_state = saved_locale_resolved
		var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
		if(islist(en_cache))
			for(var/key in injected_en_keys)
				en_cache -= key
		GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET] -= I18N_OVERLAY_LOCALE
		GLOB.i18n_runtime_domains -= I18N_OVERLAY_LOCALE
		GLOB.i18n_reverse -= I18N_OVERLAY_LOCALE
		GLOB.i18n_unreverse -= I18N_OVERLAY_LOCALE
		GLOB.i18n_tgui_phrase_cache.Cut()
		saved_locale = null
	return ..()

/datum/unit_test/i18n_payload_overlay/Run()
	var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE] = en_cache

	var/list/test_pairs = list(
		"unittest.overlay_name" = list(I18N_OVERLAY_NAME, "兹克夫单元"),
		"unittest.overlay_prose" = list(I18N_OVERLAY_PROSE, "兹克夫漂过寂静的黑暗。"),
		"unittest.overlay_flat" = list(I18N_OVERLAY_FLAT, "兹克夫星区"),
	)
	var/list/test_cache = list()
	for(var/key in test_pairs)
		var/list/pair = test_pairs[key]
		en_cache[key] = pair[1]
		test_cache[key] = pair[2]
	saved_locale = GLOB.i18n_server_locale
	saved_locale_resolved = GLOB.i18n_runtime_state
	injected_en_keys = test_pairs.Copy()
	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][I18N_OVERLAY_LOCALE] = test_cache
	GLOB.i18n_runtime_domains -= I18N_OVERLAY_LOCALE
	GLOB.i18n_server_locale = I18N_OVERLAY_LOCALE
	GLOB.i18n_runtime_state = I18N_RUNTIME_READY
	GLOB.i18n_reverse -= I18N_OVERLAY_LOCALE
	GLOB.i18n_unreverse -= I18N_OVERLAY_LOCALE
	// 短语缓存跨 locale 复用会把上一个 locale 的结果喂回来。
	GLOB.i18n_tgui_phrase_cache.Cut()

	var/list/payload = list(
		"name" = I18N_OVERLAY_NAME,
		"desc" = I18N_OVERLAY_PROSE,
		"zones" = list(I18N_OVERLAY_FLAT),
		"id" = I18N_OVERLAY_NAME, // payload_skip_keys 成员
	)
	var/list/overlay = list()
	lang_reverse_tree(payload, null, overlay)

	// ① 普通键：值不动，译文进 overlay。
	TEST_ASSERT_EQUAL(payload["name"], I18N_OVERLAY_NAME, "负载值被就地改写了：回传的标识符会变成中文，ui_act 会静默失败")
	TEST_ASSERT_EQUAL(overlay[I18N_OVERLAY_NAME], "兹克夫单元", "译文没有进 overlay：前端拿不到，界面会退回英文")

	// ② 扁平串列表元素。
	var/list/zones = payload["zones"]
	TEST_ASSERT_EQUAL(zones[1], I18N_OVERLAY_FLAT, "扁平串列表元素被就地改写了（大气警报「清除」就是这么坏的）")
	TEST_ASSERT_EQUAL(overlay[I18N_OVERLAY_FLAT], "兹克夫星区", "扁平串列表元素的译文没有进 overlay")

	// ③ 散文键：就地改写，不进 overlay。
	TEST_ASSERT_EQUAL(payload["desc"], "兹克夫漂过寂静的黑暗。", "散文键应就地改写（它渲染在 auto-localize 够不到的位置）")
	TEST_ASSERT(isnull(overlay[I18N_OVERLAY_PROSE]), "散文键不应重复进 overlay")

	// ④ skip keys 子树完全不碰。
	TEST_ASSERT_EQUAL(payload["id"], I18N_OVERLAY_NAME, "payload_skip_keys 的值不应被碰")

	// ⑤ 不传 overlay 的旧调用：一律就地改写（早期 string_cache 那条路依赖此行为）。
	var/list/legacy = list("name" = I18N_OVERLAY_NAME)
	lang_reverse_tree(legacy)
	TEST_ASSERT_EQUAL(legacy["name"], "兹克夫单元", "不传 overlay 时应保持旧的就地改写行为")

#undef I18N_OVERLAY_LOCALE
#undef I18N_OVERLAY_NAME
#undef I18N_OVERLAY_PROSE
#undef I18N_OVERLAY_FLAT
