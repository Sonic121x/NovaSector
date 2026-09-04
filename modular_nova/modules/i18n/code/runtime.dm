// NovaSector 全量汉化 (i18n) —— 运行时查表与格式化。
//
// locale 目录只放玩家可见目录；文件属于哪个运行时域由顶层 catalog-domains.json 显式声明。
// 启动期只解码 English bootstrap，ConfigLoaded 再加载 active locale 并一次性预热全部索引。

/// 全服 locale。ConfigLoaded 的唯一入口 lang_initialize_runtime() 从 config 解析并固定它。
GLOBAL_VAR_INIT(i18n_server_locale, DEFAULT_UI_LOCALE)

/// 单一生命周期：BOOTSTRAP（只有英文）→ INITIALIZING（active locale + indexes）→ READY。
/// 所有惰性构建器都以它为门；BOOTSTRAP 期的早调用只返回英文，绝不登记空 cache/state。
GLOBAL_VAR_INIT(i18n_runtime_state, I18N_RUNTIME_BOOTSTRAP)

/// 早调用告警计数。一次启动最多 I18N_MAX_EARLY_WARNINGS 条。
GLOBAL_VAR_INIT(i18n_early_reverse_warnings, 0)

/// 每一层实际命中次数。miss 只在完整 exact→normalized→template→AC 链全部未命中时计数。
GLOBAL_LIST_INIT(i18n_layer_hits, list(
	I18N_LAYER_EXACT = 0,
	I18N_LAYER_NORMALIZED = 0,
	I18N_LAYER_TEMPLATE = 0,
	I18N_LAYER_MISS = 0,
))

/// `strings/` 下的**匹配表**：靠字面比对驱动功能，翻译=替换=破坏匹配，一律不反查。
/// （展示型 flavor 表不在此列；口音替换表虽也保英文，但那是内容取舍、不是功能损坏，不登记在这。）
GLOBAL_LIST_INIT(i18n_match_table_files, list("phobia.json"))

/// 恐惧症中文触发词表（类别 -> 词表）是显式 scoped:phobia_words 域。
/proc/lang_phobia_words(category)
	var/list/table = lang_scoped_table("phobia_words.json")
	return table[category]

/// 恐惧症类别的**显示标签**（类别 -> 一个词），显式 scoped:phobia_labels 域。
///
/// 类别名本身是标识符（GLOB.phobia_types 的键、phobia_regexes 的下标、phobia.json 的匹配键），
/// 所以绝不能进 strings/i18n/<locale>/ 目录 —— 那里的每个 .json 都会被 build_i18n_cache 合并进
/// **全局反查表**，clowns / robots / lizards 这种常见单词一旦进去就是线缆颜色那类事故。
/// 未登记（含 locale==en）时原样返回，调用点无需分支。
/proc/lang_phobia_label(category)
	if(!istext(category))
		return category
	var/list/table = lang_scoped_table("phobia_labels.json")
	return table[category] || category

/// 为某恐惧症类别构建「本地化触发词」正则；无登记词则返回 null。
///
/// 分组布局刻意与 construct_phobia_regex 保持一致——消费方用 `group[2]` 取命中词、用 `$2`/`$3`
/// 做高亮替换（见 datums/components/fearful/sources/phobia.dm）。这里 group1/group3 是空组，
/// 于是 `$3` 为空串、`group[2]` 仍是命中词，两条正则可以互换使用。
/// 中文不需要词边界，直接子串匹配即正确（也只能如此，理由见 phobia_words.json 的 _comment）。
/proc/construct_phobia_regex_localized(category)
	var/list/words = lang_phobia_words(category)
	if(!length(words))
		return null
	var/words_match = ""
	for(var/word in words)
		words_match += "[REGEX_QUOTE(word)]|"
	words_match = copytext(words_match, 1, -1)
	// 分组必须与英文正则**逐组同构**：group3 用 `('?s*)`（而不是空组 `()`）——BYOND 里不参与匹配的
	// 空组返回 null，消费侧 `Replace(…, "$2$3")` 拿到的就不是空串（单测 i18n_phobia_localized_regex
	// 抓到过这点）。`'?s*` 在中文位置匹配空串但**组本身参与**，于是 group[3] == ""，两条正则可互换。
	return regex("()([words_match])('?s*)", "i")

/// 补反查早于 config 建好的 flavor 字符串表。由 world.ConfigLoaded() 调用。
///
/// `GLOBAL_LIST_INIT(fishing_tips, world.file2list("strings/fishing_tips.txt"))` 这类在 GLOB 阶段就
/// 建表，而 file2list 里的反查那时 locale 恒为 en → 整表原样存了英文，之后再没人翻。实测
/// fishing_tips 62 条、junkmail 39 条**目录里全都有译文却从来没显示过**。
///
/// **只补已进目录的 flavor 表**：names/形容词/动词/音标表等一律不碰——它们是单词池，整串反查会
/// 和目录里的单词条目撞车（姓 Cook / Baker 被当职业名译掉是同一类事故）。
/proc/lang_relocalize_early_string_lists()
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return
	for(var/list/pool in list(GLOB.fishing_tips, GLOB.junkmail_messages, GLOB.wisdoms))
		if(!islist(pool))
			continue
		for(var/i in 1 to length(pool))
			pool[i] = lang_reverse_phrase(pool[i])

	// 同理，config 之前 load_strings_file 进 string_cache 的 JSON 也没被翻。**但要跳过匹配表**：
	// phobia.json 是靠字面比对触发的**功能表**，不是展示文本——翻译它等于把英文词替换掉，英文玩家
	// 说 "chief medical officer" 反而不再触发（实测该表 3 条多词触发词与目录里的 UI 串重名：
	// chief medical officer / gas mask / holding cell）。tools/i18n/src/flavor.rs 已把 phobia 触发词
	// 排除在抽取之外，此处与之对齐。中文触发靠 strings/i18n/phobia_words.json **另加**一条无边界
	// 正则实现（见 lang_phobia_words），新增而非替换。
	for(var/filepath in GLOB.string_cache)
		if(filepath in GLOB.i18n_match_table_files)
			continue
		if(islist(GLOB.string_cache[filepath]))
			lang_reverse_tree(GLOB.string_cache[filepath])

	// 试剂单例同属「GLOB 阶段就建好」的一类：`GLOBAL_LIST_INIT(chemical_reagents_list, ...)` 里
	// 每个 `New()` 都跑在 config 之前。绝大多数试剂描述由 TGUI 负载 overlay 翻，不需要就地反查；
	// 只有**在 New() 里把 `%VAR%` 替换掉**的那几个例外 —— 替换之后整串不再等于任何目录键，
	// overlay 与反查双双 miss。它们各自实现 lang_relocalize_description()，这里统一回调。
	// `chemical_reagents_list` 是 assoc（类型路径 → 单例），直接 `in` 迭代拿到的是**键**。
	for(var/reagent_type in GLOB.chemical_reagents_list)
		var/datum/reagent/reagent = GLOB.chemical_reagents_list[reagent_type]
		reagent.lang_relocalize_description()

/// 是否启用聊天落地层（HTML 切块 + 精确反查 + 模板）。config I18N_CHAT_FALLBACK。
GLOBAL_VAR_INIT(i18n_chat_fallback, FALSE)

/// 聊天落地层必须跳过的消息类型。两类：
/// 1. 玩家/管理员**自己输入**的聊天——用户原话，误翻会把玩家说的英文短语换掉（如 "the bridge" →「舰桥」）。
///    本地 say/电台是 null 类型、不走这里，由 to_chat 的 skip_i18n_fallback 参数（经 show_message 从
///    /mob/living/Hear 传入）豁免。
/// 2. 管理员日志/调试类（adminlog/attacklog/debug）——政策上保英文（排查用），AC 最短匹配还会把日志行
///    拆碎、并大量污染 miss 采集（Explosion with size / Playing as / build mode 等全来自这里）。
GLOBAL_LIST_INIT(i18n_player_chat_types, list(
	MESSAGE_TYPE_LOCALCHAT = TRUE,
	MESSAGE_TYPE_RADIO = TRUE,
	MESSAGE_TYPE_OOC = TRUE,
	MESSAGE_TYPE_DEADCHAT = TRUE,
	MESSAGE_TYPE_ADMINPM = TRUE,
	MESSAGE_TYPE_ADMINCHAT = TRUE,
	MESSAGE_TYPE_MODCHAT = TRUE,
	MESSAGE_TYPE_MENTOR = TRUE,
	MESSAGE_TYPE_PRAYER = TRUE,
	MESSAGE_TYPE_ADMINLOG = TRUE,
	MESSAGE_TYPE_ATTACKLOG = TRUE,
	MESSAGE_TYPE_DEBUG = TRUE,
))

/// Manifest root: locale files plus explicit top-level scoped files. Loaded before the English catalog.
GLOBAL_LIST_INIT(i18n_catalog_manifest, lang_load_catalog_manifest())

/// Runtime catalog storage. Only English is decoded here; ConfigLoaded adds exactly the active locale.
/// TGUI files are validated against the manifest but never decoded by DM.
GLOBAL_LIST_INIT(i18n_catalogs, lang_bootstrap_catalogs())

/// locale -> runtime domain -> source text -> translated text. Built only after config is resolved.
GLOBAL_LIST_EMPTY(i18n_runtime_domains)

/// locale -> ambiguous English source -> conflicting forward origins. Ambiguous fallback text is
/// deliberately omitted from global reverse lookup; keyed LANG calls remain context-correct.
GLOBAL_LIST_EMPTY(i18n_reverse_ambiguities)
/// locale -> normalized English source -> conflicting origins. Ambiguous normalized aliases are
/// omitted, while exact source lookup remains available.
GLOBAL_LIST_EMPTY(i18n_reverse_norm_ambiguities)

/proc/lang_runtime_is_ready()
	return GLOB.i18n_runtime_state == I18N_RUNTIME_READY

/proc/lang_runtime_can_build_indexes()
	return GLOB.i18n_runtime_state >= I18N_RUNTIME_INITIALIZING

/proc/lang_count_layer_hit(layer)
	if(layer in GLOB.i18n_layer_hits)
		GLOB.i18n_layer_hits[layer]++

/proc/lang_layer_hit_count(layer)
	return GLOB.i18n_layer_hits[layer] || 0

/// Loads and validates the explicit catalog-domain manifest.
/proc/lang_load_catalog_manifest()
	var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/[I18N_CATALOG_DOMAIN_MANIFEST]"
	if(!fexists(path))
		CRASH("i18n: required catalog domain manifest is missing: [path]")
	var/list/root = json_decode(file2text(path))
	if(!islist(root) || root["version"] != 2 || !islist(root["files"]) || !islist(root["scoped_files"]))
		CRASH("i18n: [path] must be a version 2 object with files and scoped_files objects")
	var/list/files = root["files"]
	for(var/file_name in files)
		if(!istext(file_name) || copytext(file_name, -5) != ".json" || findtext(file_name, "/") || findtext(file_name, "\\"))
			CRASH("i18n: invalid locale catalog filename in [path]: [file_name]")
		var/list/config = files[file_name]
		if(!islist(config))
			CRASH("i18n: manifest entry [file_name] must be an object")
		var/domain = config["domain"]
		var/is_scoped = istext(domain) && findtext(domain, I18N_DOMAIN_SCOPED_PREFIX) == 1 && length(domain) > length(I18N_DOMAIN_SCOPED_PREFIX)
		if(domain != I18N_DOMAIN_FORWARD && domain != I18N_DOMAIN_MANUAL_FORWARD && domain != I18N_DOMAIN_GLOBAL_REVERSE && domain != I18N_DOMAIN_TGUI && !is_scoped)
			CRASH("i18n: manifest entry [file_name] has invalid domain '[domain]'")
		var/owner = config["owner"]
		if(owner != "extract" && owner != "manual" && owner != "tgui")
			CRASH("i18n: manifest entry [file_name] has invalid owner '[owner]'")
		if(config["locale_only"] && !is_scoped)
			CRASH("i18n: locale_only is valid only for scoped domains ([file_name])")
	var/list/scoped_domains = list()
	var/list/scoped_files = root["scoped_files"]
	for(var/file_name in scoped_files)
		if(!istext(file_name) || copytext(file_name, -5) != ".json" || findtext(file_name, "/") || findtext(file_name, "\\"))
			CRASH("i18n: invalid top-level scoped filename in [path]: [file_name]")
		var/list/config = scoped_files[file_name]
		var/domain = config?["domain"]
		if(!istext(domain) || findtext(domain, I18N_DOMAIN_SCOPED_PREFIX) != 1 || length(domain) <= length(I18N_DOMAIN_SCOPED_PREFIX))
			CRASH("i18n: top-level file [file_name] must declare a named scoped domain")
		if(domain in scoped_domains)
			CRASH("i18n: duplicate top-level scoped domain '[domain]' in [path]")
		scoped_domains[domain] = file_name
		if(config["owner"] != "manual")
			CRASH("i18n: top-level scoped file [file_name] must be manual-owned")
	return root

/proc/lang_forward_key_is_valid(key)
	if(!istext(key))
		return FALSE
	var/dot = findtext(key, ".")
	if(dot < 2 || length(key) - dot != 16 || findtext(key, ".", dot + 1))
		return FALSE
	if(spantext(key, "abcdefghijklmnopqrstuvwxyz_", 1) < 1)
		return FALSE
	if(spantext(key, "abcdefghijklmnopqrstuvwxyz0123456789_", 1) != dot - 1)
		return FALSE
	return spantext(key, "0123456789abcdef", dot + 1) == 16

/// Bootstrap is deliberately narrow: load English and no other locale directory.
/proc/lang_bootstrap_catalogs()
	var/list/catalogs = list(
		I18N_CATALOG_FORWARD_BUCKET = list(),
		I18N_CATALOG_MANUAL_BUCKET = list(),
		I18N_CATALOG_PAIRED_BUCKET = list(),
		I18N_CATALOG_DIRECT_BUCKET = list(),
	)
	lang_load_catalog_locale(DEFAULT_UI_LOCALE, catalogs)
	return catalogs

/proc/lang_catalog_locale_is_loaded(locale)
	var/list/forward_by_locale = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET]
	return islist(forward_by_locale?[locale])

/// Decodes one locale according to the manifest. Unknown or missing required files are fatal:
/// silently dropping a file would silently drop translations and recreate filename-based domains.
/proc/lang_load_catalog_locale(locale, list/catalogs)
	var/list/forward_by_locale = catalogs[I18N_CATALOG_FORWARD_BUCKET]
	if(islist(forward_by_locale?[locale]))
		return
	var/dir = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/[locale]/"
	if(!fexists(dir))
		CRASH("i18n: configured locale directory does not exist: [dir]")
	var/list/actual_files = list()
	var/list/manifest_files = GLOB.i18n_catalog_manifest["files"]
	for(var/file_name in flist(dir))
		if(copytext(file_name, -1) == "/")
			continue
		if(copytext(file_name, -5) != ".json")
			continue
		if(!manifest_files[file_name])
			CRASH("i18n: locale [locale] contains unknown catalog file [file_name]; classify it in [I18N_CATALOG_DOMAIN_MANIFEST]")
		actual_files[file_name] = TRUE
	for(var/file_name in manifest_files)
		var/list/config = manifest_files[file_name]
		if(!config["optional"] && !actual_files[file_name])
			CRASH("i18n: locale [locale] is missing required catalog file [file_name]")

	var/list/forward = list()
	var/list/manual_forward = list()
	var/list/paired = list()
	var/list/direct = list()
	for(var/file_name in actual_files)
		var/list/config = manifest_files[file_name]
		var/domain = config["domain"]
		if(domain == I18N_DOMAIN_TGUI)
			continue
		var/list/decoded = json_decode(file2text("[dir][file_name]"))
		if(!islist(decoded))
			CRASH("i18n: [locale]/[file_name] must contain a JSON object")
		var/list/target
		if(domain == I18N_DOMAIN_FORWARD)
			target = forward
		else if(domain == I18N_DOMAIN_MANUAL_FORWARD)
			target = manual_forward
		else
			var/list/bucket = config["locale_only"] ? direct : paired
			target = bucket[domain]
			if(!islist(target))
				target = list()
				bucket[domain] = target
		for(var/key in decoded)
			var/value = decoded[key]
			if(!istext(key) || !istext(value))
				CRASH("i18n: [locale]/[file_name] contains a non-text key or value")
			if(domain == I18N_DOMAIN_FORWARD && !lang_forward_key_is_valid(key))
				CRASH("i18n: forward key '[key]' in [locale]/[file_name] is not <namespace>.<16 lowercase hex>")
			if(domain == I18N_DOMAIN_MANUAL_FORWARD && lang_forward_key_is_valid(key))
				CRASH("i18n: hashed key '[key]' belongs in the automatic forward domain, not [locale]/[file_name]")
			if(key in target)
				var/existing = target[key]
				if(existing != value)
					CRASH("i18n: conflicting key '[key]' in runtime domain '[domain]' while loading [locale]/[file_name]")
				continue
			target[key] = value
	forward_by_locale[locale] = forward
	var/list/manual_by_locale = catalogs[I18N_CATALOG_MANUAL_BUCKET]
	manual_by_locale[locale] = manual_forward
	var/list/paired_by_locale = catalogs[I18N_CATALOG_PAIRED_BUCKET]
	var/list/direct_by_locale = catalogs[I18N_CATALOG_DIRECT_BUCKET]
	paired_by_locale[locale] = paired
	direct_by_locale[locale] = direct

/// Adds a source mapping while detecting the exact failure that used to be last-write-wins.
/proc/lang_add_domain_value(list/seen, list/origins, list/output, source, translated, domain, origin, include_templates = TRUE)
	if(source in seen)
		if(seen[source] != translated)
			CRASH("i18n: conflicting translations for '[source]' inside runtime domain '[domain]': [origins[source]] vs [origin]")
		return
	seen[source] = translated
	origins[source] = origin
	if(translated != source && (include_templates || !findtext(source, "{")))
		output[source] = translated

/// Automatic forward catalogs are context-keyed. If the same English source has different keyed
/// translations, there is no correct context-free reverse answer: omit it instead of choosing by
/// file order. Explicit global_reverse supplements may still provide a deliberate canonical value.
/proc/lang_add_forward_reverse_value(list/seen, list/origins, list/ambiguous, list/output, source, translated, origin)
	if(translated == source)
		return
	if(source in ambiguous)
		ambiguous[source] += origin
		return
	if(source in seen)
		if(seen[source] == translated)
			return
		ambiguous[source] = list(origins[source], origin)
		output -= source
		return
	seen[source] = translated
	origins[source] = origin
	if(translated != source && !findtext(source, "{"))
		output[source] = translated

/proc/lang_validate_localized_keys(list/english, list/localized, locale, domain)
	if(!islist(localized))
		return
	for(var/key in localized)
		if(!(key in english))
			CRASH("i18n: locale [locale] domain '[domain]' contains key '[key]' with no English source")

/proc/lang_validate_manual_forward(locale)
	var/list/manual_by_locale = GLOB.i18n_catalogs[I18N_CATALOG_MANUAL_BUCKET]
	var/list/english = manual_by_locale[DEFAULT_UI_LOCALE]
	var/list/localized = manual_by_locale[locale]
	lang_validate_localized_keys(english, localized, locale, I18N_DOMAIN_MANUAL_FORWARD)

/// Builds one named domain. global_reverse is the union of automatic forward sources and explicit
/// supplements; a supplement deterministically overrides the automatic fallback for that source.
/proc/lang_build_runtime_domain(domain, locale)
	var/list/by_locale = GLOB.i18n_runtime_domains[locale]
	if(islist(by_locale) && islist(by_locale[domain]))
		return by_locale[domain]
	if(!lang_runtime_can_build_indexes() || !lang_catalog_locale_is_loaded(locale))
		return null
	if(!islist(by_locale))
		by_locale = list()
		GLOB.i18n_runtime_domains[locale] = by_locale
	var/list/output = list()
	var/list/seen = list()
	var/list/origins = list()
	var/list/ambiguous = list()
	var/list/forward_by_locale = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET]
	var/list/paired_by_locale = GLOB.i18n_catalogs[I18N_CATALOG_PAIRED_BUCKET]
	var/list/direct_by_locale = GLOB.i18n_catalogs[I18N_CATALOG_DIRECT_BUCKET]
	if(domain == I18N_DOMAIN_GLOBAL_REVERSE)
		var/list/english_forward = forward_by_locale[DEFAULT_UI_LOCALE]
		var/list/localized_forward = forward_by_locale[locale]
		lang_validate_localized_keys(english_forward, localized_forward, locale, domain)
		for(var/key in english_forward)
			var/source = english_forward[key]
			var/translated = localized_forward[key]
			if(isnull(translated))
				translated = source
			lang_add_forward_reverse_value(seen, origins, ambiguous, output, source, translated, "forward key [key]")
		if(length(ambiguous))
			GLOB.i18n_reverse_ambiguities[locale] = ambiguous
			for(var/source in ambiguous)
				seen -= source
				origins -= source
	// Explicit global_reverse files are the canonical context-free decision layer. Reset conflict
	// tracking so they may override automatic forward candidates, while conflicts between two
	// supplements still fail instead of depending on file iteration order.
	if(domain == I18N_DOMAIN_GLOBAL_REVERSE)
		seen = list()
		origins = list()
	var/list/english_domains = paired_by_locale[DEFAULT_UI_LOCALE]
	var/list/localized_domains = paired_by_locale[locale]
	var/list/english = english_domains?[domain]
	var/list/localized = localized_domains?[domain]
	if(islist(english))
		lang_validate_localized_keys(english, localized, locale, domain)
		for(var/key in english)
			var/source = english[key]
			var/translated = localized?[key]
			if(isnull(translated))
				translated = source
			lang_add_domain_value(seen, origins, output, source, translated, domain, "catalog key [key]", include_templates = domain != I18N_DOMAIN_GLOBAL_REVERSE)
	var/list/direct_domains = direct_by_locale[locale]
	var/list/direct = direct_domains?[domain]
	if(islist(direct))
		for(var/source in direct)
			lang_add_domain_value(seen, origins, output, source, direct[source], domain, "locale-only key [source]")
	by_locale[domain] = output
	return output

/proc/lang_runtime_domain(name, locale)
	if(isnull(locale))
		locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	var/domain = findtext(name, I18N_DOMAIN_SCOPED_PREFIX) == 1 ? name : "[I18N_DOMAIN_SCOPED_PREFIX][name]"
	var/list/table = lang_build_runtime_domain(domain, locale)
	if(islist(table))
		return table
	var/static/list/empty = list()
	return empty

/proc/lang_runtime_domain_text(domain, text, locale)
	if(!istext(text))
		return text
	var/mapped = lang_runtime_domain(domain, locale)[text]
	return isnull(mapped) ? text : mapped

/proc/lang_prewarm_runtime_domains(locale)
	var/list/done = list()
	var/list/manifest_files = GLOB.i18n_catalog_manifest["files"]
	for(var/file_name in manifest_files)
		var/list/config = manifest_files[file_name]
		var/domain = config["domain"]
		if(domain == I18N_DOMAIN_FORWARD || domain == I18N_DOMAIN_MANUAL_FORWARD || domain == I18N_DOMAIN_TGUI || done[domain])
			continue
		lang_build_runtime_domain(domain, locale)
		done[domain] = TRUE
	// The automatic forward catalog feeds this domain even when there are no supplement files.
	if(!done[I18N_DOMAIN_GLOBAL_REVERSE])
		lang_build_runtime_domain(I18N_DOMAIN_GLOBAL_REVERSE, locale)

/// ConfigLoaded's only i18n entrypoint. When it returns, zh-Hans has no player-visible lazy setup left.
/proc/lang_initialize_runtime(configured_locale, configured_chat_fallback)
	if(GLOB.i18n_runtime_state != I18N_RUNTIME_BOOTSTRAP)
		CRASH("i18n: lang_initialize_runtime() may be called exactly once")
	if(!istext(configured_locale) || !length(configured_locale) || findtext(configured_locale, "/") || findtext(configured_locale, "\\") || findtext(configured_locale, ".."))
		CRASH("i18n: invalid configured locale '[configured_locale]'")
	GLOB.i18n_runtime_state = I18N_RUNTIME_INITIALIZING
	GLOB.i18n_server_locale = configured_locale
	GLOB.i18n_chat_fallback = !!configured_chat_fallback
	if(!lang_catalog_locale_is_loaded(configured_locale))
		lang_load_catalog_locale(configured_locale, GLOB.i18n_catalogs)
	lang_validate_manual_forward(configured_locale)
	lang_prewarm_runtime_domains(configured_locale)
	lang_prewarm_scoped_tables()
	if(configured_locale != DEFAULT_UI_LOCALE)
		lang_build_reverse(configured_locale)
		lang_type_name_keys() // loads name and desc type indexes together
		lang_tpl_setup(configured_locale)
		lang_relocalize_early_string_lists()
	GLOB.i18n_runtime_state = I18N_RUNTIME_READY

/// Pure exact lookup: automatic v2 forward wins, then manual named LANG keys. Manual entries never
/// feed reverse/template/AC indexes.
/proc/lang_template(key, locale)
	var/list/forward_by_locale = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET]
	var/template = forward_by_locale?[locale]?[key]
	if(!isnull(template))
		return template
	var/list/manual_by_locale = GLOB.i18n_catalogs[I18N_CATALOG_MANUAL_BUCKET]
	return manual_by_locale?[locale]?[key]

/// 把模板里的 {0}/{1}… 用 args 依次替换（args 为 /list，元素按位置对应）。
/// 文本实参经 lang_localize_arg 本地化链（仅全服 locale≠en；en 零额外开销）。
///
/// **单趟扫描，不是「每个实参跑一遍 replacetext」**。旧写法按序替换 {0}、{1}…，于是**上一个实参
/// 的内容会被下一轮当成模板的一部分再扫一次**：只要某个实参的值里恰好含 `{1}`（纸张文本、玩家
/// 起的物品名、任何玩家可控串都做得到），它就会被后一个实参的值顶掉，输出一句错乱的话。
/// 单趟扫描时实参写进输出后不再参与匹配，这类自吞死掉；顺带还省掉了「模板里根本没有该占位符时
/// 仍然白跑一遍 lang_localize_arg + 全串 replacetext」的开销（LANG 是全仓三万余处调用的热点）。
/// 「扫过这段字面文本之后，光标是不是落在某个 HTML 标签内部」。见 lang_interpolate 里
/// 「占位符落在标签内部 = 实参是标识符」那条：状态要跨字面段累积，所以单独抽出来。
/// 段内没有 `<`/`>` 时状态不变；有则以**最后出现**的那个为准。
/proc/lang_tag_state_after(text, in_tag)
	var/last_open = findlasttext(text, "<")
	var/last_close = findlasttext(text, ">")
	if(!last_open && !last_close)
		return in_tag
	return last_open > last_close

/proc/lang_interpolate(template, list/args, origin)
	var/arg_count = length(args)
	if(!arg_count || !findtext(template, "{"))
		return template
	var/localize = GLOB.i18n_server_locale != DEFAULT_UI_LOCALE
	var/list/output = list()
	var/template_length = length(template)
	var/cursor = 1
	// **占位符落在标签内部时，实参是标识符而不是文案**：幻觉心灵感应那条模板长这样
	// `<span class='{0}'>…</span><span class='{1}'> {2}</span>`，{0}/{1} 收的是 span 的 CSS 类名
	// （`boldnotice`/`alien`）。把它们送进 lang_localize_arg 轻则在漏翻日志里刷噪音，重则某天目录里
	// 恰好有个同形条目 —— 中文就被写进 class 属性，聊天配色当场全丢。调用点无从分辨（同一条模板里
	// {2} 才是真文案），但**形态**分得清：只有 `<` 与 `>` 之间的占位符是属性值。
	// has_tags 预判一次，无标签的模板（绝大多数）零额外开销。
	var/has_tags = findtext(template, "<")
	var/in_tag = FALSE
	while(cursor <= template_length)
		var/brace = findtext(template, "{", cursor)
		if(!brace)
			break
		var/close = findtext(template, "}", brace + 1)
		// 非 {N}/{NN} 形态（含未闭合、过长）：按字面处理，越过这个 `{` 继续找。
		if(!close || close - brace > 3 || !lang_tpl_all_digits(copytext(template, brace + 1, close)))
			output += copytext(template, cursor, brace + 1)
			cursor = brace + 1
			continue
		var/index = text2num(copytext(template, brace + 1, close)) + 1
		if(index < 1 || index > arg_count) // 越界占位符：与旧行为一致，原样留在输出里
			output += copytext(template, cursor, close + 1)
			cursor = close + 1
			continue
		var/lead = copytext(template, cursor, brace)
		output += lead
		if(has_tags)
			in_tag = lang_tag_state_after(lead, in_tag)
		var/arg = args[index]
		if(localize && !in_tag)
			if(istext(arg))
				arg = lang_localize_arg(arg, origin)
			else if(isatom(arg))
				// **非文本实参从前完全没被本地化**：rewrite 把 `[src]` 抬成 LANG 实参时给的是 atom
				// 本身（`list(src)` 一种形状全仓 3000+ 处），而这里只对 istext 分支调 lang_localize_arg
				// → `"[arg]"` 插进去的是**英文名**，只能指望聊天层的字面 AC 去捞（那条有多词门槛，
				// 单词名永远捞不着，于是「你仔细查看The floor」）。
				// 顺带解决冠词：`"[atom]"` 会让 BYOND 自己补 "The "（模板里的 `\the` 是另一回事，
				// 由 lang_process_text_escapes 剥），中文不需要冠词，走显示边界拿到的就是干净的名字。
				var/atom/atom_arg = arg
				arg = atom_arg.lang_localize_name_for_display(atom_arg.name)
		output += "[arg]"
		cursor = close + 1
	output += copytext(template, cursor)
	return output.Join()

/// LANG 实参/引擎捕获的统一本地化链：状态词 → 代词/系动词 → 整串反查 → 冠词剥离反查。
/// 解决「模板译了、运行期填进来的实参却是英文」的四类：
///   ① 开关/状态词（open/closed/lit…，`_state_words.json` 精确表）；
///   ② 代词与系动词（p_They()/p_are() 的 They/are → 他们/是，lang_pronoun 专用小表）；
///   ③ 目录里有的整串（安全等级 "green"→绿色、"None"→无——按值精确反查）；
///   ④ 带英文冠词的名字（"\the [src]"/"\a [x]" 渲染出的 "The wall"/"a Monkey"——剥冠词反查
///      余下部分（再试小写），命中则丢冠词：中文无冠词）。
/// 全部是精确匹配，查不到原样保留（玩家名/数字/已中文串零误伤）。
/// 当前全服 locale 是否是**中文**。
///
/// 判据不能写成「locale != en」：伪 locale（qps-ploc）与将来任何其它语言都会命中那条，于是
/// 中文专用的拟声替换表会被套到英文文本上 —— 上游的 speech_modifiers 单测当场抓到过一次
/// （蜥蜴人的 `s→sss` 断言在伪 locale 下拿到了未变形的英文）。
/// 文本里是否含中日韩统一表意文字。用于「按字切」这类**形态判据**（比 locale 判据稳：
/// 中英混排、伪 locale 都不会误伤）。
/proc/lang_contains_cjk(text)
	var/static/regex/cjk_regex = regex(@"[一-鿿]")
	return istext(text) && cjk_regex.Find(text)

/// 语音替换词表的**按 locale 取表**入口（`speechmod` 组件的 `replacements`）。
///
/// 这批表（chav/elvis/ork/crustacean…）的**键是英文单词**，靠 `replacetextEx` 在消息里做子串替换。
/// 中文句子里那些键永不出现 → 整类突变在中文服上是空转（而它们的 `end_string` 后缀却照常追加，
/// 于是表现为「中文句子后挂一条英文尾巴」）。中文表放在 `strings/zh-Hans/` 下同名文件，
/// 有就用、没有就退回英文表 —— 这样新增一门语言只是加文件，不用改任何调用点。
///
/// 中文表的键必须是**多字词**：`replacetextEx` 是无词边界的子串替换，拿单字当键（「下」「是」）
/// 会在词内开火，把「下面」「不是」也一起改掉 —— 与字面 AC 那些事故同一个形态。
/// 词池（`world.file2list` 读的纯文本表）按 locale 取表：`<名>.<locale>.txt` 与英文表同目录，
/// 有就用、没有就退回英文表 —— 新增语言只加文件、不改调用点。与 lang_speech_replacements 同一
/// 条路子（那是 strings/ 的 JSON 版），但**不能走 GLOB.string_cache**：这些表是 file2list 直接
/// 读的，不经 load_strings_file。
///
/// 为什么不把词入目录：这些池子是**极常见的英文单词**（`hot`/`in`/`real`/`kind`/`solid`…），
/// 进全局反查表就是凭空扩大整个 DM 侧的误翻面（线缆颜色那次事故的形态）。而它们的用途是纯
/// flavor 拼句，按 locale 换整张表既覆盖完全、又零全局风险。
///
/// **必须惰性**：GLOBAL_LIST_INIT 跑在 locale 读入之前（见 memory「i18n 初始化时序死钩子」），
/// 在 GLOB 初始化期按 locale 选表只会静默拿到英文表。
GLOBAL_LIST_EMPTY(i18n_word_pools)

/proc/lang_word_pool(filepath, list/fallback)
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return fallback
	var/cache_key = "[filepath]|[GLOB.i18n_server_locale]"
	var/list/cached = GLOB.i18n_word_pools[cache_key]
	if(cached)
		return cached
	var/list/pool = fallback
	var/localized_path = "[copytext(filepath, 1, findtextEx(filepath, ".txt"))].[GLOB.i18n_server_locale].txt"
	if(fexists(localized_path))
		var/list/localized = world.file2list(localized_path)
		// file2list 会把末尾换行读成一个空元素，pick() 抽到就是一句空文本。
		// **循环着删**：DM 的 `Remove()` 每个实参只摘一个实例（`list -= null` 那条同源），
		// 文件里有两处空行就会漏掉一个。
		while(("" in localized))
			localized -= ""
		if(length(localized))
			pool = localized
	GLOB.i18n_word_pools[cache_key] = pool
	return pool

/proc/lang_speech_replacements(filepath, key)
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		// **同目录、locale 后缀命名**（`chav_replacement.zh-Hans.json`），不能放 `strings/<locale>/` 下：
		// `GLOB.string_cache` 只按**文件名**索引、不含目录，同名文件会互相覆盖 —— 谁先加载谁赢，
		// 另一边静默拿到错表。
		var/localized_path = "[copytext(filepath, 1, findtextEx(filepath, ".json"))].[GLOB.i18n_server_locale].json"
		if(fexists("[STRING_DIRECTORY]/[localized_path]"))
			var/list/localized = strings(localized_path, key)
			if(length(localized))
				// **叠加而非替换**：英文键只在拉丁文本上匹配、中文键只在中文文本上匹配，两套规则
				// 互不干扰。整张换掉会让中文服上的英文发言（玩家打英文、机器播报）丢掉整个效果
				// —— 与蜥蜴/苍蝇拟声表那条同一个道理，见 lang_merge_speech_replacements。
				return lang_merge_speech_replacements(strings(filepath, key), localized)
	return strings(filepath, key)

/// 中文拟声表**叠加**在英文表之上，而不是替换它。
///
/// 这两张表是**字母级**与**汉字级**两套互不相干的规则：`s→sss` 只在拉丁字母上开火，`。→嘶。`
/// 只在中文标点上开火。原来写成「中文服就整张换掉英文表」，代价有两个，第二个是硬伤：
///   · 中文服上的英文发言（玩家打英文、机器播报）丢掉了效果；
///   · **上游的 speech_modifiers 单测直接红**——它断言蜥蜴人把 "She is so sassy" 念成
///     "SSShe isss ssso sssasssy"，而那条断言在中文 locale 下拿到的是未变形的原句。
/// 叠加之后两套规则各管各的文本形态，互不干扰（半角标点那三条已按前置汉字锚定，见各自的表）。
///
/// 不能用 `base + extra`：DM 的 list `+` 对关联列表只并键、**不带值**，合出来的表每条规则都映到 null。
/proc/lang_merge_speech_replacements(list/base, list/extra)
	. = base.Copy()
	for(var/key in extra)
		.[key] = extra[key]

/proc/lang_locale_is_chinese()
	return findtext(GLOB.i18n_server_locale, "zh") == 1

/// 见 lang_localize_arg 末尾的 HTML 兜底：那条路会经模板引擎绕回自身，用它挡住失控下探。
GLOBAL_VAR_INIT(i18n_arg_html_depth, 0)

/proc/lang_localize_arg(arg, origin)
	if(!length(arg))
		return arg
	// span_*() 包裹的实参：改写后的调用形如
	// `LANG(key, list(span_bold("[read_only ? "protected" : "unprotected"]")))`，
	// 运行期传进来的是 `<b>unprotected</b>` —— 整串既不是状态词也不是目录键，下面每一步精确
	// 匹配都会 miss，于是中文句子里嵌着一个英文状态词（软盘的「写保护标签设置为unprotected。」）。
	// 剥掉首尾标签、对内层递归本地化，命中后把标签原样套回去（加粗等排版不丢）。
	// 内层已无标签，递归必然终止。
	if(findtext(arg, "<"))
		var/static/regex/wrapped_arg = regex(@"^((?:<[^>]+>)+)(.*?)((?:</[^>]+>)+)$")
		if(wrapped_arg.Find(arg))
			var/inner = wrapped_arg.group[2]
			var/inner_translated = lang_localize_arg(inner, origin)
			if(inner_translated != inner)
				return wrapped_arg.group[1] + inner_translated + wrapped_arg.group[3]
	var/list/state_words = lang_state_words()
	var/translated = state_words[arg]
	if(translated)
		return translated
	translated = lang_pronoun(arg)
	if(translated != arg)
		return translated
	translated = lang_reverse_text(arg)
	if(translated != arg)
		return translated
	var/stripped = lang_strip_article(arg)
	if(stripped)
		translated = lang_reverse_text(stripped)
		if(translated != stripped)
			return translated
		var/lowered = LOWER_TEXT(stripped)
		if(lowered != stripped)
			translated = lang_reverse_text(lowered)
			if(translated != lowered)
				return translated
	// 小写形实参（"The [special_role_text] has failed!" 的 LOWER_TEXT 角色名等）：目录按原始
	// 大写形收录（"Traitor"）→ 首字母大写后再试一次。
	var/capped = capitalize(arg)
	if(capped != arg)
		translated = lang_reverse_text(capped)
		if(translated != capped)
			return translated
	// 「裸文本 + span 包裹」的混合实参（`" and [EXAMINE_HINT("secured with metal cables")]"`）：
	// 上面那条剥外壳的分支要求整串**首尾**都是标签，多一个前导 " and " 就整条 miss，于是连里面
	// 那句本来译得好好的也一起留成英文。这类形状交给聊天路径同款的切块器：按标签切开、每块各自
	// 精确反查（" and " 这种连接碎片在目录里有独立条目，整串反查够得着；AC 的词内开火风险由
	// lang_fallback_apply 自己的多词闸门挡）。仅在含标签时才跑，普通实参零额外开销。
	// 英文复数形式：中文没有复数，去掉词尾再精确查一次。运行期拼出来的复数（物种的
	// `plural_form = "[name]\s"` → `Voxs`/`Akulae`、各种 `"[x]s"`）整串永远不是目录键，而单数
	// 早就在目录里 —— 采集里 `Golems`/`Ethereals`/`Skrells` 一整排都是这一类。
	// 安全线是「**单数必须整串精确命中目录**」：碰不上就原样返回，不做任何形态猜测。
	var/length_of_arg = length(arg)
	if(length_of_arg > 2 && text2ascii(arg, length_of_arg) == 115) // 以 s 结尾
		var/singular = copytext(arg, 1, length_of_arg)
		translated = lang_reverse_text(singular)
		if(translated != singular)
			return translated
		if(copytext(arg, -2) == "es")
			singular = copytext(arg, 1, length_of_arg - 1)
			translated = lang_reverse_text(singular)
			if(translated != singular)
				return translated
	// 深度守卫：这条路存在一个**环**（arg → 切块器 → 模板逆匹配 → 捕获值又回到 lang_localize_arg）。
	// 每一跳处理的都是严格更短的子串，理论上必然收敛；但它跑在聊天热路径上，栈爆的代价太大，
	// 所以显式钉一个上限，超了就不再下探（退化成原样返回，行为与从前一致）。
	if(findtext(arg, "<") && GLOB.i18n_arg_html_depth < I18N_ARG_HTML_MAX_DEPTH)
		GLOB.i18n_arg_html_depth++
		translated = lang_fallback_apply_html(arg, GLOB.i18n_server_locale)
		GLOB.i18n_arg_html_depth--
		if(translated != arg)
			return translated
	// 漏翻采集：整条链都没命中的 LANG 实参。**模板译好了、实参漏出来**是「中文句子里嵌英文词」
	// 的头号成因，而实参多半是单词（状态词、单词名），旧的 run 采集器按多词门槛结构性看不见。
	lang_log_miss_value(arg, "arg", origin)
	return arg

/// **逆向**反查：把显示边界产生的译名还原成英文原文。用于 act 回传/按英文建键的查表场景——
/// TGUI 只翻显示字段，但部分旧界面仍会把显示名回传给 canonical English 键表；直接查会 miss。
/// 惰性从反查表倒置构建（一对多取首个）；locale==en 或查不到原样返回。
/// **消费侧惯用法**：`map[x] || map[lang_unreverse_text(x)]`（先原样查保英文路径零变化）。
GLOBAL_LIST_EMPTY(i18n_unreverse)
/proc/lang_unreverse_text(text)
	if(!istext(text) || !length(text))
		return text
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale == DEFAULT_UI_LOCALE)
		return text
	var/list/unrev = GLOB.i18n_unreverse[locale]
	if(!unrev)
		var/list/reverse = lang_build_reverse(locale)
		if(!length(reverse))
			return text // 反查表未就绪：原样返回且不缓存（同 lang_build_reverse 加固）
		unrev = list()
		for(var/en in reverse)
			var/translated = reverse[en]
			if(!unrev[translated])
				unrev[translated] = en
		GLOB.i18n_unreverse[locale] = unrev
	return unrev[text] || text

/// 地图名的**显示**译名：有译文时返回「译名-英文」（如「蓝移-Blueshift」），无译文时原样返回英文。
///
/// 为什么保留英文后缀：地图英文名是 wiki 查询 / 投票辨识的锚（玩家要对着英文查全站地图、投票选图）。
/// 为什么只用于显示：map_name 本身是**标识符**——config/maps.txt 的 feedbacklink/webmap_url 按它比对
/// （configuration.dm），SSmap_vote 也按它匹配当前图（map_vote.dm）。绝不能改 map_name 变量，只在
/// 落地渲染点过这个助手。locale==en 或无译文时无后缀、无行为变化。
/proc/lang_map_display_name(map_name)
	if(!istext(map_name) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return map_name
	var/localized = lang_reverse_text(map_name)
	if(localized == map_name) // 无译文：只显示英文，避免「Blueshift-Blueshift」
		return map_name
	return "[localized]-[map_name]"

/// 若文本以英文冠词开头（the/a/an，含大写），返回去冠词后的余部；否则 null。
/proc/lang_strip_article(text)
	var/static/list/articles = list("the ", "The ", "a ", "an ", "A ", "An ")
	for(var/article in articles)
		var/alen = length(article)
		if(length(text) > alen && findtextEx(text, article, 1, alen + 1))
			return copytext(text, alen + 1)
	return null

/// `_state_words.json` is a named scoped domain. It is preloaded with the active locale but never
/// contributes to global reverse lookup.
/proc/lang_state_words()
	return lang_runtime_domain("state_words")

/// 神之声触发正则是显式 scoped:voice_of_god 域。
/proc/lang_vog_triggers()
	return lang_scoped_table("voice_of_god.json")

/// 把神之声命令的英文触发正则换成「英文 + 本地化别名」版本。未登记的 pattern 原样返回；locale==en 时 no-op。
/// 玩家在中文服里自然会用中文下命令（输入框标题/提示都是中文），只匹配英文等于整个法术失效。
/proc/lang_vog_trigger(pattern)
	if(!istext(pattern))
		return pattern
	var/list/table = lang_vog_triggers()
	return table[pattern] || pattern

/// 护甲防护等级 examine（list_armor 输出）只从 scoped:armor_classes 域取显示译名。
/proc/lang_armor_class(name)
	if(!istext(name))
		return name
	var/list/table = lang_scoped_table("armor_classes.json")
	return table[name] || name

/// Explicit top-level scoped catalog loader. Bootstrap calls return an uncached empty table; all
/// declared files are decoded and cached during INITIALIZING.
GLOBAL_LIST_EMPTY(i18n_scoped_tables)
/proc/lang_scoped_table(file_name)
	if(!lang_runtime_can_build_indexes())
		var/static/list/empty = list()
		return empty
	var/list/scoped_files = GLOB.i18n_catalog_manifest["scoped_files"]
	if(!scoped_files[file_name])
		CRASH("i18n: unknown top-level scoped catalog '[file_name]'; classify it in [I18N_CATALOG_DOMAIN_MANIFEST]")
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	var/list/by_locale = GLOB.i18n_scoped_tables[file_name]
	if(!islist(by_locale))
		by_locale = list()
		GLOB.i18n_scoped_tables[file_name] = by_locale
	var/list/cached = by_locale[locale]
	if(islist(cached))
		return cached
	var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/[file_name]"
	if(!fexists(path))
		CRASH("i18n: declared top-level scoped catalog is missing: [path]")
	var/list/decoded = json_decode(file2text(path))
	if(!islist(decoded))
		CRASH("i18n: top-level scoped catalog must contain a locale object: [path]")
	var/list/table = list()
	var/list/for_locale = decoded[locale]
	if(islist(for_locale))
		for(var/entry in for_locale)
			table[entry] = for_locale[entry]
	by_locale[locale] = table
	return table

/proc/lang_prewarm_scoped_tables()
	var/list/scoped_files = GLOB.i18n_catalog_manifest["scoped_files"]
	for(var/file_name in scoped_files)
		lang_scoped_table(file_name)

/// 「数量 + 部件名」的显示片段（`"[2] [beaker]\s"` → 「2 烧杯」）。
///
/// 部件名来自 `initial(x.name)`，是 canonical English —— 显示边界化之后本该如此，翻译只在显示处做。
/// 这类清单（机器框架、电路板、弹药工作台…）过去只剩字面 AC 一条落地路径，而 AC 有多词门槛，
/// 于是同一行里 `玻璃板` 是中文、`micro-servo`/`beakers` 是英文 —— 「一份清单里按名字词数分成
/// 两半」这个反差就是判据。
///
/// 译出中文时**丢掉 `\s`**：中文名词没有复数，留着 BYOND 会照数量渲染出多余的 "s"（「2 烧杯s」）。
/// 没翻动的项保持原样，英文复数照常工作。
/proc/lang_component_tally(amount, component_name)
	if(!istext(component_name))
		return "[amount] [component_name]\s"
	var/localized = lang_localize_display_name(component_name)
	if(localized == component_name)
		return "[amount] [component_name]\s"
	return "[amount] [localized]"

/// `english_list()` 的 locale-neutral 本地化版：逐项过显示边界，再按显式域表连接。
///
/// `list_formatting.json` 提供 separator、default_conjunction 与 canonical 英文连接词映射；
/// 缺少当前 locale 的格式表时，仍本地化各项，但保留 `english_list()` 的 canonical 连接行为。
/// 这样新增 locale 只需添加域数据，不需要在 DM 控制流里增加 locale 分支。
/// `final_comma_text` 是英文的牛津逗号（"a, b, and c" 里 and 前那个逗号），本地化分支不使用它：
/// 中文用顿号连接、也没有这个成分，与「译文不引用英文复数 `\s` 占位符」同一条道理。
/// 但形参必须与 `english_list()` 逐一对应 —— rewrite 是就地把调用换成本 proc 的，
/// 上游任何一个具名实参我们缺一个，那个调用点当场编译不过。
/proc/lang_english_list(list/items, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "")
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return english_list(items, nothing_text, and_text, comma_text, final_comma_text)
	if(!length(items))
		return lang_localize_arg(nothing_text)
	var/list/localized = list()
	for(var/item in items)
		localized += lang_localize_arg("[item]")
	if(length(localized) < 2)
		return localized.Join()
	var/list/formatting = lang_scoped_table("list_formatting.json")
	var/separator = formatting["separator"]
	var/list/conjunctions = formatting["conjunctions"]
	if(!istext(separator) || !islist(conjunctions))
		return english_list(localized, nothing_text, and_text, comma_text, final_comma_text)
	var/conjunction_key = trim(replacetext(and_text, ",", ""))
	var/joiner = conjunctions[conjunction_key]
	if(isnull(joiner))
		joiner = formatting["default_conjunction"]
	if(!istext(joiner))
		joiner = and_text
	var/tail = localized[length(localized)]
	localized.Cut(length(localized))
	return "[jointext(localized, separator)][joiner][tail]"

/// 史莱姆颜色（SLIME_TYPE_* 的值）的显示译名。颜色同时是 icon_state 与突变表键，不能进反查表。
/proc/lang_slime_colour(colour)
	if(!istext(colour))
		return colour
	var/list/table = lang_scoped_table("slime_colours.json")
	return table[colour] || colour

/// 化学反应在「没有产物试剂」时的兜底显示名（`ui_data.dm` 从类型路径末段现切出来的那个）。
///
/// 走**域内表**而不是主目录：这些值按定义是类型路径末段、标识符形态，全仓 117 条里混着
/// `heat` / `holy` / `life` / `soup` / `foam` 这类通用单词，塞进全局反查表当场把
/// `nova-i18n lint` 的碰撞告警顶上去（实测 54 → 61）。顶层表只由这一个显示点查。
/// 表由 `node tools/i18n/reaction-names.mjs` 生成骨架，未填译文的保持英文。
/proc/lang_reaction_name(reaction_name)
	if(!istext(reaction_name))
		return reaction_name
	var/list/table = lang_scoped_table("reaction_names.json")
	return table[reaction_name] || reaction_name

/// 线缆颜色的显示译名。颜色值同时是 act 回传标识符（`wire.color`）与 CSS 颜色名
/// （前端 `labelColor={shownColor.replace(' ','')}`），所以值本身必须留英文；
/// ui_data 里另发一个 shownColorLabel 供前端当 label 用。
/// `tgui.json` is now an explicit TGUI-only domain and is never decoded by DM.
/proc/lang_wire_colour(colour)
	if(!istext(colour))
		return colour
	var/list/table = lang_scoped_table("wire_colours.json")
	return table[colour] || colour

/// 警报类别（ALARM_* 的值）的显示译名。这些值是 `alarm_types_show/clear` 的 assoc **键**，
/// 且是 Fire/Power/Camera/Motion 这种通用单词，同样不能进反查表。
/proc/lang_alarm_type(alarm_type)
	if(!istext(alarm_type))
		return alarm_type
	var/list/table = lang_scoped_table("alarm_types.json")
	return table[alarm_type] || alarm_type

/// 反查后的文本要当**关联列表的 key**（= 显示标签）时的防撞车包装。
///
/// 不同英文标题完全可能译成同一个中文——`wooden barrel` 和 `wooden bucket` 都是「木桶」——
/// 而 assoc list 同 key 会**互相覆盖**，后写的顶掉先写的，于是配方从菜单里凭空消失（没有任何报错）。
/// 撞车时附上英文原名消歧，既保证唯一、又仍是可读的显示文本。locale==en 时 lang_reverse_text 是
/// no-op，label 恒等于原标题，行为与从前完全一致。
/proc/lang_unique_display_key(list/target, text)
	var/label = lang_reverse_text("[text]")
	if(!(label in target))
		return label
	// 译名已被占用：加英文原名区分。极端情况下（同一英文标题在同一层出现两次）再补序号。
	var/candidate = "[label]（[text]）"
	var/index = 2
	while(candidate in target)
		candidate = "[label]（[text] [index]）"
		index++
	return candidate

/// 状态栏页签名/分组标题只从 scoped:statpanel_tabs 取显示译名。页签名本身仍是
/// button.id / SendTabToByond 回传值 / stat_tab 比较标识符，绝不原地本地化。
/proc/lang_statpanel_tab_labels()
	return lang_scoped_table("statpanel_tabs.json")

/// BYOND 文法宏（\the \a \improper 等，无参、由引擎按名词上下文在**编译期/输出期**处理）。模板从 JSON
/// 加载后引擎不再处理 → 会字面显示。中文无冠词/复数、且上下文已丢失，直接剥掉。`\b` 防 \theory 等误伤；
/// 已转义的反斜杠（\\）开头不会被这里的单反斜杠模式吃掉。只列已知文法宏，不碰 \n \t \" 等真转义。
// 末尾的 es|s 是 BYOND 复数后缀宏 \s/\es（"[n] apple\s" → 引擎按数量补 "s"）：runtime 构建的 LANG
// 串不被引擎处理 → 字面 \s 漏出（如「30 cable piece\s」）。中文无复数，直接剥除（与冠词/代词宏同处理）。
GLOBAL_VAR_INIT(i18n_text_macro_regex, regex(@"\\(themselves|theirs|himself|herself|itself|their|them|they|roman|Roman|hers|she|She|her|his|him|its|it|It|he|He|es|s)\b", "g"))

/// 冠词/专名前缀宏单独一条，因为要**连同后面那个空格一起吃掉**：`\improper 兹克夫单元` 剥完
/// 若只去宏就剩「 兹克夫单元」（玩家实测里的「那是  地板.」「你拉了拉  某物」双空格即此）。
/// 中文不需要冠词，宏与其分隔空格一起消失才是正确形态。
/// **不能**把这条规则套到上面那张表：`\s`（复数）紧贴单词、后面那个空格是句子本身的
/// （`"[n] wire\s are"` → 吃掉就成了「wireare」）。
GLOBAL_VAR_INIT(i18n_article_macro_regex, regex(@"\\(improper|proper|the|The|an|An|a|A)\b ?", "g"))

/// 处理从 JSON 模板带出的 BYOND 转义/文法宏（rewrite 把编译期字面量改成 LANG 后，这些转义不再被引擎
/// 处理）：① 剥文法宏；② 还原转义引号 \" → "；③ 还原 \n → 换行、\t → 制表符。
/// 源码里 `"\n"` 是 DM 编译期换行转义；抽取器把它当**字面 2 字符** `\n` 存进 JSON（`"\\n"`），LANG 从
/// JSON 取回后引擎不再解释 → 会字面显示 `\n`（如警棍 examine「\n它当前为…」）。在此还原。仅在串含反斜杠时调用。
/// 源码转义还原（不碰文法宏）：把 dreammaker 解析器原样保留在目录里的 `\"`/`\n`/`\t`/`\[`/`\]`
/// 还原成 BYOND 运行时形态（裸引号/换行/制表符/字面方括号）。lang_build_reverse 据此额外登记「去转义」
/// 形态键，让运行时串（已是解析后形态）能命中含这些转义的 name/desc/lore（尤其多行 desc 的 \n）。
/proc/lang_unescape_source(text)
	if(!istext(text))
		return text
	text = replacetext(text, "\\\"", "\"") // \" → "
	text = replacetext(text, "\\n", "\n") // 字面 \n → 换行
	text = replacetext(text, "\\t", "\t") // 字面 \t → 制表符
	text = replacetext(text, "\\\[", "\[") // 字面 \[ → [
	text = replacetext(text, "\\\]", "\]") // 字面 \] → ]
	return text

/proc/lang_process_text_escapes(text)
	if(!istext(text))
		return text
	var/regex/article_re = GLOB.i18n_article_macro_regex
	text = article_re.Replace(text, "")
	var/regex/macro_re = GLOB.i18n_text_macro_regex
	text = macro_re.Replace(text, "")
	text = replacetext(text, "\\\"", "\"") // \" → "
	text = replacetext(text, "\\n", "\n") // 字面 \n → 换行
	text = replacetext(text, "\\t", "\t") // 字面 \t → 制表符
	// BYOND 的 `\[` / `\]` 是「字面方括号」转义（防被当插值），只在编译期字面量生效；LANG 运行期取回
	// 后引擎不再处理 → 字面显示反斜杠（记录面板「\[查看怪癖\]」即此）。在此还原为 [ ]。
	text = replacetext(text, "\\\[", "\[") // 字面 \[ → [（DM 里 \[ 是字面方括号转义，故需 \\\[ 匹配反斜杠+括号）
	text = replacetext(text, "\\\]", "\]") // 字面 \] → ]
	return text

/// 核心（纯函数）：按 locale 查模板（缺则回退英文，再缺则返回 key），最后做占位符替换。
/proc/lang_resolve(key, list/args, locale)
	if(isnull(locale))
		locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE

	var/template = lang_template(key, locale)
	if(isnull(template) && locale != DEFAULT_UI_LOCALE)
		template = lang_template(key, DEFAULT_UI_LOCALE) // 回退到英文源串

	if(isnull(template))
		return key // 兜底：返回 key，避免崩溃

	. = lang_interpolate(template, args, key)
	if(findtext(., "\\")) // 仅含反斜杠（文法宏/转义）时才处理，绝大多数消息直接返回
		. = lang_process_text_escapes(.)

/// 全服 locale 版本（广播类文本用）。见 LANG 宏。
/proc/lang_format(key, list/args)
	return lang_resolve(key, args, null)

/// 兼容旧调用的单接收者入口；当前部署模式强制使用全服 locale。
/proc/lang_format_for(mob/user, key, list/args)
	return lang_resolve(key, args, null)

// ---- 反查表（name/desc 等「变量类」文本接入运行时）----
//
// 变量初始化（name = "..."）无法改写成 LANG()（DM 变量初值需常量）。atom/turf 实例保持
// canonical English，避免改写 BYOND appearance；examine、hover 与纯显示 TGUI 字段在输出边界
// 用此表把英文整串映射为译文。表只含「无占位符的纯字符串」。

/// locale -> (英文原文 -> 译文)。惰性构建并缓存到 GLOB，供各显示边界复用。
GLOBAL_LIST_EMPTY(i18n_reverse)

/// 剥掉 BYOND 文法宏 \improper/\proper，得到「显示形态」串。
/// 两种来源都要剥：① 运行时 name/desc 里是**编译期标记字节**（DM 源写 "\improper" 即该字节，
/// 故 replacetext 用 "\improper" 能匹配）；② 目录 JSON 里存的是**字面** "\improper"（反斜杠+improper，
/// 用 "\\improper" 匹配）。规整到无宏并 trim，使两端对齐（否则带 \improper 的名永远查不中）。
/// 剥掉 HTML 标签，只留可见文本，并把标签留下的空白折叠/修边。
/// 用于给「键里嵌着标签」的目录条目登记一个能被 lang_fallback_apply_html 切块后命中的变体键。
/proc/lang_strip_html_tags(text)
	if(!istext(text))
		return text
	var/static/regex/html_tag = regex(@"<[^>]*>", "g")
	var/static/regex/ws_run = regex(@"[ \t]+", "g")
	return trim(ws_run.Replace(html_tag.Replace(text, ""), " "))

/proc/lang_strip_grammar_macros(text)
	if(!istext(text))
		return text
	text = replacetext(text, "\improper", "") // 运行时标记字节形态
	text = replacetext(text, "\proper", "")
	text = replacetext(text, "\\improper", "") // 目录字面形态
	text = replacetext(text, "\\proper", "")
	return trim(text)

/// Reverse indexes are built from the explicit global_reverse runtime domain: forward catalog source
/// values plus only the supplements named global_reverse in catalog-domains.json.
/// 反查表的**归一化形态**表：`normalize(英文) → 可直接显示的译文`。
GLOBAL_LIST_EMPTY(i18n_reverse_norm)

/// 反查用的归一化：把「同一句话的各种运行期形态」压到同一个键上。
///
/// 每一条都对应一类**实测踩过的**形态差异（详见各自注释）：
///   · 文法宏：目录存字面 `\improper`，运行期是控制字节；
///   · 源码转义：目录存字面 `\n`/`\t`/`\"`/`\[`，运行期已是真换行/裸引号/字面括号；
///   · 空白：DM 的 `\` 续行会把前导制表符并进串里，抽取器归一成单空格；
///   · 首尾空白与成对单引号：strings/ 数据文件的值常带这些，目录里存的是 trim/去引号形态；
///   · 首字母大小写：DM 惯例「小写存、显示时 `capitalize()`」。**只对多词生效**——单词键几乎全是
///     标识符形态（move/clear/ready），给它们做大小写归一会把 `switch("Clear")` 这类比较拖进反查面。
///     这条安全线与 P1、AC 字典、`lint.rs` 的碰撞集合是同一条，改动要一起改。
/proc/lang_normalize_lookup(text)
	if(!istext(text) || !length(text))
		return text
	if(findtext(text, "\improper") || findtext(text, "\proper") || findtext(text, "\\improper") || findtext(text, "\\proper"))
		text = lang_strip_grammar_macros(text)
	if(findtext(text, "\\"))
		text = lang_unescape_source(text)
	if(findtext(text, "\t") || findtext(text, "  "))
		text = lang_collapse_ws(text)
	text = trim(text)
	var/length_of_text = length(text)
	if(length_of_text > 2 && text2ascii(text, 1) == 39 && text2ascii(text, length_of_text) == 39)
		text = copytext(text, 2, length_of_text)
	var/first_char = copytext(text, 1, 2)
	if(findtext(text, " ") && findtextEx("ABCDEFGHIJKLMNOPQRSTUVWXYZ", first_char))
		text = LOWER_TEXT(first_char) + copytext(text, 2)
	return text

/proc/lang_add_normalized_reverse(list/reverse_norm, list/origins, list/ambiguous, normalized, translated, origin)
	if(normalized in ambiguous)
		ambiguous[normalized] += origin
		return
	if(normalized in reverse_norm)
		if(reverse_norm[normalized] == translated)
			return
		ambiguous[normalized] = list(origins[normalized], origin)
		reverse_norm -= normalized
		origins -= normalized
		return
	reverse_norm[normalized] = translated
	origins[normalized] = origin

/proc/lang_build_reverse(locale)
	if(locale in GLOB.i18n_reverse)
		return GLOB.i18n_reverse[locale]
	if(!lang_runtime_can_build_indexes() || !lang_catalog_locale_is_loaded(locale))
		return list()
	var/list/domain = lang_build_runtime_domain(I18N_DOMAIN_GLOBAL_REVERSE, locale)
	if(!islist(domain))
		return list()
	var/list/reverse = list()
	var/list/reverse_norm = list()
	var/list/norm_origins = list()
	var/list/norm_ambiguous = list()
	for(var/en_text in domain)
		var/translated = domain[en_text]
		reverse[en_text] = translated
		var/norm_key = lang_normalize_lookup(en_text)
		if(norm_key != en_text)
			lang_add_normalized_reverse(reverse_norm, norm_origins, norm_ambiguous, norm_key, lang_display_value(translated), "source '[en_text]'")
		// Chat/browser output is split around formatting tags. Register the visible multi-word form,
		// but never strip functional links.
		if(findtext(en_text, "<") && findtext(en_text, ">"))
			var/bare_key = lang_normalize_lookup(lang_strip_html_tags(en_text))
			if(length(bare_key) && findtext(bare_key, " ") && !(bare_key in reverse))
				lang_add_normalized_reverse(reverse_norm, norm_origins, norm_ambiguous, bare_key, lang_strip_html_tags(lang_display_value(translated)), "tagged source '[en_text]'")
	if(length(norm_ambiguous))
		GLOB.i18n_reverse_norm_ambiguities[locale] = norm_ambiguous
	GLOB.i18n_reverse[locale] = reverse
	GLOB.i18n_reverse_norm[locale] = reverse_norm
	return reverse

/// 把一段英文整串反查为全服 locale 的译文；查不到/缺省 locale 时原样返回。
/// 把连续空格/制表符折叠成单空格，对齐抽取器对 DM "\" 续行的归一：源码里
/// `"… foo \`<换行><制表符>`bar …"` 在 DM 运行时会把续行的前导制表符并入字符串
/// （变成 "foo \t\tbar"），而抽取器把它归一成单空格（"foo bar"）→ 整串反查不命中。
/// 只折叠空格/制表符，保留换行（有意的多段 \n 不动）。
/proc/lang_collapse_ws(text)
	if(!istext(text))
		return text
	var/static/regex/ws_run = regex(@"[ \t]+", "g")
	return ws_run.Replace(text, " ")

/proc/lang_reverse_text(text)
	if(!text)
		return text
	// Bootstrap calls must stay English and must not poison any index. Keep a bounded diagnostic.
	if(!lang_runtime_can_build_indexes() && GLOB.i18n_early_reverse_warnings < I18N_MAX_EARLY_WARNINGS)
		GLOB.i18n_early_reverse_warnings++
		stack_trace("i18n: lang_reverse_text() was called before ConfigLoaded initialized the active locale; returning English without caching")
	return lang_reverse_text_in(text, GLOB.i18n_server_locale || DEFAULT_UI_LOCALE)

/// 整串精确反查的 **locale 参数化**核心。聊天链带着自己的 locale 参数（单测注入合成 locale 靠它），
/// 从前它手写了一份「只查 exact 表」的查表，于是归一表那批键在聊天路径上永远查不到 —— 三条落地链
/// 各写一遍同一件事的典型代价。
/proc/lang_reverse_text_in(text, locale)
	if(!text || locale == DEFAULT_UI_LOCALE)
		return text
	var/list/reverse = GLOB.i18n_reverse[locale]
	if(!islist(reverse))
		reverse = lang_build_reverse(locale)
	if(!islist(reverse))
		return text
	. = reverse[text]
	if(!isnull(.))
		lang_count_layer_hit(I18N_LAYER_EXACT)
		return lang_display_value(.)
	// 精确 miss → 归一化后再查一次。归一表把「同一句话的各种运行期形态」（文法宏 / 源码转义 /
	// 续行空白 / 首尾空白 / 成对单引号 / capitalize 过的首字母）压到同一个键上；从前这里是五段
	// 各自为政的重试、建表侧还有四条变体登记，且**变体之间不能组合**。
	// 注意**不能**加「归一化后与原串相同就跳过」的短路：归一表里还有一类键本身就是归一化产物
	// （剥标签形态），查询侧是裸句、归一化对它是恒等变换 —— 跳过就等于那类永远查不到。
	var/normalized = lang_normalize_lookup(text)
	var/hit
	// **先拿归一化结果查一次精确表。** 建表侧对「归一化后与源串相同」的条目**不登记**归一表
	// （见 lang_build_reverse 里那个 `if(norm_key != en_text)`），它们只活在精确表里。少了这一步，
	// 任何只差首尾空白/文法宏的运行期串都落不了地 —— 而切块器切出来的块极常带前导空格
	// （`</b>` 到 `</span>` 之间那段），实测 emote 整行的动作词就是这么漏的：
	// `<span class='emote'><b>蟑螂</b> chitters.</span>`，名字翻了、动作没翻。
	// 放在归一表之前：精确表是更具体的证据，且这一步 O(1)、不占额外内存。
	if(normalized != text)
		hit = reverse[normalized]
		// 精确表存的是**源码字面形态**（`\improper` / `\n`），显示化在读侧做（见上面那条 exact 命中）；
		// 归一表存的已经是显示化过的值（建表时就过了 lang_display_value）。走精确表这条就得自己补，
		// 否则玩家看到「\improper 太阳系精品热饮」。
		if(!isnull(hit))
			hit = lang_display_value(hit)
	if(isnull(hit))
		var/list/reverse_norm = GLOB.i18n_reverse_norm[locale]
		if(islist(reverse_norm))
			hit = reverse_norm[normalized]
	if(!isnull(hit))
		lang_count_layer_hit(I18N_LAYER_NORMALIZED)
		// 归一化会吃掉首尾空白：命中后按原串的首尾空白拼回（离子法则等下游拼接依赖那些空格）。
		var/text_length = length(text)
		if(text2ascii(text, 1) <= 32 || text2ascii(text, text_length) <= 32)
			var/start_index = 1
			while(start_index <= text_length && text2ascii(text, start_index) <= 32)
				start_index++
			var/end_index = text_length
			while(end_index >= start_index && text2ascii(text, end_index) <= 32)
				end_index--
			return copytext(text, 1, start_index) + hit + copytext(text, end_index + 1)
		return hit
	// 仍未命中：`desc = span_alert("…")` 类编译期包裹 → 运行时值带 <span> 外壳，目录存的是内层
	// （抽取器解 span_* 宏）。剥单层 span 反查内层，命中**回包**（保留原样式）——所以它不能并进
	// 归一化那条路：那条会把标签直接吃掉、配色就丢了。
	if(text2ascii(text, 1) == 60)
		var/static/regex/reverse_span_re = regex("^(<span class='\[^']*'>)(.*)(</span>)$")
		if(reverse_span_re.Find(text))
			var/inner = reverse_span_re.group[2]
			var/inner_hit = reverse[inner]
			if(!isnull(inner_hit))
				lang_count_layer_hit(I18N_LAYER_EXACT)
			else
				inner_hit = GLOB.i18n_reverse_norm[locale]?[lang_normalize_lookup(inner)]
				if(!isnull(inner_hit))
					lang_count_layer_hit(I18N_LAYER_NORMALIZED)
			if(!isnull(inner_hit))
				return reverse_span_re.group[1] + lang_display_value(inner_hit) + reverse_span_re.group[3]
	return text

/// 显示用「物件名」本地化：先整串精确反查（命中堆叠/单词名/已译名幂等），miss 再走 AC 子串兜
/// 复合名（如 "Robotics Lab APC" → 区域名子串 "Robotics Lab" 被换）。与 screentip（_atom.dm）同款
/// 两步，抽成共用 proc 供「绕过 examine/AC 路径、只发 atom.name 的 UI」复用（如 LootPanel）。
/// 仅用于**纯显示**的名字（act/回传用 ref/path、不用 name 处），翻名不破标识符。locale==en no-op。
/proc/lang_localize_display_name(text, origin)
	if(!istext(text) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return text
	// 显示边界**不过字面 AC**：名字要么整串命中、要么是「区域名 + 类型名」那种可拆的合成名
	// （lang_localize_area_prefixed_name 分段精确翻）。AC 是无词边界的子串替换，在这么短的串上
	// 只会带来误伤（「You can」咬进「You can't」那一类的名字版）。
	. = lang_localize_chain(text, GLOB.i18n_server_locale || DEFAULT_UI_LOCALE, allow_template = TRUE)
	// 漏翻采集：显示边界（examine 名/描述、悬停 screentip、径向菜单、tgui_input_list 选项）整条
	// miss。这一面的缺口几乎全是**单词名**，run 采集器看不到；而它又最容易行动 —— 拿 origin 里的
	// 类型路径直接对着 labels.rs TYPE_VAR_RULES / type_vars.json 补一条即可。
	if(GLOB.i18n_log_misses && . == text)
		lang_log_miss_value(text, "display", origin)

/// 类型显示名/描述表：`strings/i18n/type_vars.json`（`nova-i18n extract` 产出，DM 继承已在 build 期展开）。
/// `type` → 目录 key。显示边界拿到的 name/desc 若仍是类型标签，就**按类型直接取键**走正向目录，
/// 而不是拿运行期字符串倒查反查表。三点收益：
///   · 没有多词门槛 —— 单词名（`limb`/`beaker`/`Water`）第一次能落地，反查侧那条闸门永远够不到它们；
///   · 没有同形异义碰撞 —— 键由类型决定，`smell`（名词/动词）、`Clear`/`Move` 这类不再需要定点表钉词性；
///   · O(1)，不经模板引擎与字面 AC。
///
/// **实例数据永不改写**：类型变量声明不在 rewrite 的遍历范围内（rewrite 只走 `ty.procs`），
/// `X.name` 在任何比较/查表处都还是 canonical English。这张表只在显示边界产出**新字符串**。
/// 该不变量由 `nova-i18n lint` 的「类型变量声明不得含 LANG」规则守。
///
/// Loaded exactly once during INITIALIZING for non-English servers; bootstrap calls return without
/// setting the loaded flag, so an early display hook cannot pin an empty type index.
GLOBAL_LIST_EMPTY(i18n_type_name_keys)
GLOBAL_LIST_EMPTY(i18n_type_desc_keys)
GLOBAL_VAR_INIT(i18n_type_var_tables_loaded, FALSE)

/proc/lang_load_type_var_tables()
	if(GLOB.i18n_type_var_tables_loaded)
		return
	if(!lang_runtime_can_build_indexes())
		return
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale == DEFAULT_UI_LOCALE)
		return
	var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/type_vars.json"
	if(!fexists(path))
		CRASH("i18n: required type index metadata is missing: [path]")
	var/list/decoded = json_decode(file2text(path))
	if(!islist(decoded))
		CRASH("i18n: type index metadata must be a JSON object: [path]")
	lang_fill_type_var_table(decoded["name"], GLOB.i18n_type_name_keys)
	lang_fill_type_var_table(decoded["desc"], GLOB.i18n_type_desc_keys)
	GLOB.i18n_type_var_tables_loaded = TRUE

/// JSON 里的键是类型**文本**，运行期查表用的是 `A.type`（路径）。一次性转成路径键，省掉每次
/// 查表的 `"[type]"` 插值分配（hover screentip 是每次 MouseEntered 都走的路径）。
/// 解析不出路径的条目（上游删过的类型等）直接丢，绝不留文本键——那会静默永不命中。
/proc/lang_fill_type_var_table(list/entries, list/target)
	if(!islist(entries) || !islist(target))
		return
	for(var/type_text in entries)
		var/type_path = text2path(type_text)
		if(isnull(type_path))
			continue
		target[type_path] = entries[type_text]

/proc/lang_type_name_keys()
	lang_load_type_var_tables()
	return GLOB.i18n_type_name_keys

/proc/lang_type_desc_keys()
	lang_load_type_var_tables()
	return GLOB.i18n_type_desc_keys

/// 按类型取译文。无表项 / 该 key 在当前 locale 没有译文 → 返回 null，调用方回落既有反查链
/// （形态不在表里的：地图实例覆盖、运行期拼接、子类型自己声明了非字面量…）。
/proc/lang_type_display_text(atom/target, list/table)
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE || !length(table))
		return null
	var/key = table[target.type]
	if(!key)
		return null
	return lang_display_value(lang_template(key, GLOB.i18n_server_locale))

/// 把「直接取自目录的值」变成可以显示的串：目录里存的是**源码字面形态**，含 `\improper`、`\n`、
/// `\[` 这类 BYOND 转义/文法宏。它们只在编译期字面量里被引擎处理；运行期从 JSON 取回后是**字面
/// 字符**，直接显示就是「\improper 太阳系精品热饮」。LANG 路径早有这道处理（lang_resolve 末尾），
/// 按类型取键这条新路当时漏了。仅在含反斜杠时才跑。
/proc/lang_display_value(text)
	if(istext(text) && findtext(text, "\\"))
		return lang_process_text_escapes(text)
	return text

/// Localize an atom name only when it is still a static type label. Runtime/player-assigned identity names
/// must remain byte-for-byte unchanged even when they collide with a catalog phrase.
/atom/proc/lang_localize_name_for_display(display_name)
	if(HAS_TRAIT(src, TRAIT_WAS_RENAMED))
		return display_name
	// 仍等于类型初值 = 类型标签 → 按类型取键（精确、含单词名）。其余形态（地图实例覆盖 desc/name、
	// 运行期拼接名）表里没有，回落既有反查链，行为与从前一致。
	if(display_name == initial(name))
		var/typed_name = lang_type_display_text(src, lang_type_name_keys())
		if(typed_name)
			return typed_name
	else
		// 运行期把**区域名**拼进 name 的那批（APC 的 `"\improper [区域名] APC"`、空气警报的
		// `"[区域名] Air Alarm"`、火警器与防火门的 `"[区域名] [类型名] [id]"`）：整串既不是目录键、
		// 又常以单词结尾，精确反查与字面 AC 双双够不着 → 实测里的「Courtroom APC」「Brig 空气警报」。
		// 按区域名拆开分别翻，拼回原样。
		var/split_name = lang_localize_area_prefixed_name(src, display_name)
		if(split_name)
			return split_name
		var/affixed_name = lang_localize_type_affixed_name(display_name)
		if(affixed_name)
			return affixed_name
		var/material_name = lang_localize_material_prefixed_name(display_name)
		if(material_name)
			return material_name
	return lang_localize_display_name(display_name, "[type]")

/// 血迹类污渍的运行期拼名（见 master_files 的 /obj/effect/decal/cleanable/blood 覆写）。
///
/// 只在 display_name 与「按英文构件拼出来的形态」逐字节相同时才动手 —— 那证明这一串确实是
/// update_name() 拼的，而不是地图实例覆盖或别处改的名。任一构件翻不动就返回 null，由调用方
/// 回落默认链；中文各构件之间不加空格。
/proc/lang_localize_blood_decal_name(obj/effect/decal/cleanable/blood/decal, display_name)
	if(!istext(display_name) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return null
	var/list/table = lang_scoped_table("blood_decal_names.json")
	if(!length(table))
		return null
	var/blood_string = decal.get_blood_string()
	if(!istext(blood_string) || !length(blood_string))
		return null

	// 先按英文重拼一遍，确认这串就是 update_name() 的产物。
	var/rebuilt = initial(decal.name)
	if(decal.base_name)
		rebuilt = "[decal.base_name] [blood_string]"
	if(decal.base_suffix)
		rebuilt = "[decal.base_name ? rebuilt : blood_string] [decal.base_suffix]"
	if(decal.dried && decal.dry_prefix)
		rebuilt = "[decal.dry_prefix] [rebuilt]"
	if(rebuilt != display_name)
		return null

	var/localized_blood = lang_reverse_text(blood_string)
	if(localized_blood == blood_string)
		return null
	. = localized_blood
	if(decal.base_name)
		var/list/bases = table["base_name"]
		var/base = bases?[decal.base_name]
		if(!base)
			return null
		. = "[base][.]"
	if(decal.base_suffix)
		var/list/suffixes = table["base_suffix"]
		var/suffix = suffixes?[decal.base_suffix]
		if(!suffix)
			return null
		. = "[.][suffix]"
	if(decal.dried && decal.dry_prefix)
		var/list/prefixes = table["dry_prefix"]
		var/prefix = prefixes?[decal.dry_prefix]
		if(!prefix)
			return null
		. = "[prefix][.]"

/// 运行期在**类型名两侧加缀**的实例名：AI 法则架的 `"\proper core module rack 'alpha'"`、
/// 贴标机改过的 `"beaker (盐)"`、各种 `"[name] #3"`。整串不是目录键，类型表按 `initial(name)`
/// 判定也对不上 → 精确反查与类型表双双 miss，只剩聊天层的字面 AC（多词才走、无词边界）。
///
/// 判据只有一条：**去掉文法宏之后，initial(name) 逐字节地是它的前缀**。前缀走类型表（单词名也能翻），
/// 其余原样保留。mob 侧另有一条更严的同类规则（只放行 `" (…)"` 后缀）——那里 name 是身份，
/// 不能放宽；obj/turf 的 name 从来只是类型标签，按前缀拆是安全的。
/atom/proc/lang_localize_type_affixed_name(display_name)
	var/base = initial(name)
	var/base_length = length(base)
	if(!base_length)
		return null
	// `"\proper [name] '…'"` 运行时是**标记字节 + 空格 + 名字**；不剥掉就永远匹配不上前缀，
	// 而且那个空格会一路漏到玩家眼前（examine 的「那是  核心模块架」）。
	var/stripped = lang_strip_grammar_macros(display_name)
	if(length(stripped) <= base_length || findtext(stripped, base) != 1)
		return null
	var/tail = copytext(stripped, base_length + 1)
	var/localized_base = lang_type_display_text(src, lang_type_name_keys()) || lang_localize_display_name(base, "[type]")
	return "[localized_base][tail]"

/// 运行期把**材料名**拼在类型名**前面**的那批（`/obj/item/coin/gold` 的 `"gold coin"`、
/// 各种材料造物）。与 lang_localize_type_affixed_name 同源但方向相反：那条认 `initial(name)`
/// 是前缀，这条认它是**后缀**。两条都必要——材料在前、编号/标签在后。
///
/// 闸门是「前缀必须是**已登记的材料名**」（`lang_material` 认得）。不设这条就等于放行任意
/// 运行期前缀，而材料域正是为 `gold`/`glass`/`iron` 这些歧义单词准备的：它们只在材料语境翻，
/// 不进全局反查表。中文不需要那个分隔空格，直接拼。
/atom/proc/lang_localize_material_prefixed_name(display_name)
	var/base = initial(name)
	var/base_length = length(base)
	if(!base_length)
		return null
	var/stripped = lang_strip_grammar_macros(display_name)
	var/stripped_length = length(stripped)
	if(stripped_length <= base_length)
		return null
	if(copytext(stripped, stripped_length - base_length + 1) != base)
		return null
	var/prefix = trim(copytext(stripped, 1, stripped_length - base_length + 1))
	if(!length(prefix))
		return null
	var/localized_prefix = lang_material(prefix)
	if(localized_prefix == prefix) // 不是登记过的材料 —— 这个形状不归本条管
		return null
	var/localized_base = lang_type_display_text(src, lang_type_name_keys()) || lang_localize_display_name(base, "[type]")
	return "[localized_prefix][localized_base]"

/// 拆「区域名 + 其余」型实例名并分别本地化；不是这个形状时返回 null（调用方回落原链）。
///
/// 三段各有各的译法，混在一起整串查是查不到的：
///   · 区域名 —— 区域也是 atom，走它自己的显示边界（类型表 / `_map_names` 手工表都在那条路上）；
///   · 类型名 —— 优先按**本类型**取键（`APC` 这种单词只有类型表够得着），miss 再整串反查；
///   · 尾巴（`id_tag` 之类）—— 原样保留，它本来就不是文案。
/atom/proc/lang_localize_area_prefixed_name(atom/source, display_name)
	var/area/source_area = get_area(source)
	if(isnull(source_area))
		return null
	var/area_name = source_area.name
	if(!length(area_name))
		return null
	var/at = findtext(display_name, area_name)
	if(at != 1) // 只认前缀形态；出现在中间的多半是巧合
		return null
	var/rest = copytext(display_name, length(area_name) + 1)
	if(!length(rest))
		return null
	var/localized_area = source_area.lang_localize_name_for_display(area_name)
	// 其余部分：先看是不是「类型名 + 尾巴」（火警器 `[区域] [类型名] [id]`）。
	var/base = initial(name)
	var/trimmed_rest = trim(rest)
	if(length(base) && findtext(trimmed_rest, base) == 1)
		var/tail = copytext(trimmed_rest, length(base) + 1)
		var/localized_base = lang_type_display_text(source, lang_type_name_keys()) || lang_localize_display_name(base, "[source.type]")
		return "[localized_area] [localized_base][tail]"
	var/localized_rest = lang_localize_display_name(trimmed_rest, "[source.type]")
	return "[localized_area] [localized_rest]"

/// examine 的 desc 显示边界。与 name 同构：仍等于类型初值 → 按类型取键；其余（地图实例覆盖的
/// desc、运行期 `desc = …` / `desc +=`）回落既有反查链，行为与从前一致。
/atom/proc/lang_localize_desc_for_display(display_desc)
	if(display_desc == initial(desc))
		var/typed_desc = lang_type_display_text(src, lang_type_desc_keys())
		if(typed_desc)
			return typed_desc
	. = lang_reverse_text(display_desc)
	if(GLOB.i18n_log_misses && . == display_desc)
		lang_log_miss_value(display_desc, "desc", "[type]")

/// mob 的 `name` 是**身份**（角色名、宠物挂牌名、赛博编号、ERT 头衔…），一律不翻——哪怕它恰好
/// 撞上目录短语。判据只用「是否仍等于类型声明的初值」：任何运行期赋值（`fully_replace_character_name`
/// 与各处裸 `name = …`）都会偏离 initial(name)；而被改回 initial(name) 的（宠物摘掉项圈还原）此刻
/// 又确实是类型标签、该翻。不另设标志位：标志位只能覆盖走 proc 的那条改名路径，还得跟父级的
/// early-return 保持同步，反而比这条判据弱。
/mob/lang_localize_name_for_display(display_name)
	if(display_name == initial(name))
		return ..()
	// `set_name()` 家族把类型名拼成 `"alien larva (123)"`（异种/蜂/皮层蠕虫/无人机/血虫…都走这条），
	// 整串不等于 initial(name)、按上面的判据会被当身份名拒翻 → 例检里显英文。这里只放行一种形态：
	// **前缀与 initial(name) 逐字节相同、其余部分是括号后缀**。玩家自己起的名字不可能满足这个形状
	// （除非他刚好把名字起成「类型名 (…)」，那时翻前缀也无害），所以不放宽身份名的保护面。
	var/base = initial(name)
	var/base_length = length(base)
	if(!base_length || length(display_name) <= base_length + 2)
		return display_name
	if(copytext(display_name, 1, base_length + 1) != base)
		return display_name
	var/suffix = copytext(display_name, base_length + 1)
	if(copytext(suffix, 1, 3) != " (" || copytext(suffix, -1) != ")")
		return display_name
	// 递归回本边界：base 此刻等于 initial(name)，走类型表那条快路（前缀单词名也能翻）。
	return lang_localize_name_for_display(base) + suffix

/// 已知会被运行期 `desc +=` 追加的固定后缀（trim 形态）。base + 后缀都是各自独立的目录键，但拼接后
/// 整串非目录键 → exact 反查 miss。这些追加发生在 bootstrap/New() 早期，原地反查只会返回英文，
/// 故在**使用点**（如手术计算机）用 lang_reverse_suffixed 拆开 base + 后缀分别精确反查（避免 AC 蚕食）。
GLOBAL_LIST_INIT(i18n_appended_suffixes, list(
	"This procedure can only be performed once per organ.",
	// 高优先级赏金说明：`update_global_bounty_list()` 在 description 后面追加。三条被上报的
	// 高优先级赏金整条显英文就是它拖的——基础句本身早就译好了。
	"</br>This bounty is marked as <b>high priority</b>, and will reward <b>1.5x</b> the normal payout!",
))

/// 反查「base + 已知追加后缀」型字符串：先整串精确（rnd_desc 等无后缀的直接命中）；miss 时若以某
/// 已知后缀结尾，拆成 base + 后缀各自精确反查再拼回（均为目录键 → 干净、不经 AC）。locale==en no-op。
/proc/lang_reverse_suffixed(text)
	if(!istext(text) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return text
	. = lang_reverse_text(text)
	if(. != text)
		return . // 整串精确命中
	// Every registered suffix is a sentence containing spaces. A single token cannot possibly match one;
	// avoid allocating a collapsed copy and walking the suffix table on the TGUI single-word hot path.
	if(!findtext(text, " "))
		return .
	// 追加点的分隔各式各样：手术 desc 是一个空格，赏金是 `"</br>\<换行><制表符>…"`（DM 续行把制表符
	// 并进串里）。先把空白折叠成单空格再比（目录键本身就是折叠形态），分隔空格按原样还回拼接处。
	var/collapsed = lang_collapse_ws(text)
	var/collapsed_length = length(collapsed)
	for(var/suffix in GLOB.i18n_appended_suffixes)
		// 目录键与运行期串的**接缝空白**不保证一致：手术那条源码里自带前导空格，赏金那条靠 DM 续行
		// （`"</br>\` + 换行 + 制表符），抽取器把续行空白吃掉了、运行期不一定。所以两种形态都试。
		var/list/needles = list(lang_collapse_ws(suffix), " [lang_collapse_ws(suffix)]")
		for(var/needle in needles)
			var/needle_length = length(needle)
			if(collapsed_length <= needle_length)
				continue
			if(copytext(collapsed, collapsed_length - needle_length + 1) != needle)
				continue
			var/base = copytext(collapsed, 1, collapsed_length - needle_length + 1)
			var/separator = ""
			if(copytext(needle, 1, 2) == " ")
				needle = copytext(needle, 2)
				separator = " "
			return "[lang_reverse_text(base)][separator][lang_reverse_text(needle)]"
	return .

/// 完整句聊天行反查：用于「先 `list += span_*("整句")` 累加、再 jointext 进一个 boxed_message
/// 经 to_chat 输出」的场景（如职业出生提示 get_spawn_message）。整盒在 to_chat 只走 AC 子串，而
/// rustg AC 是**最短匹配**：当完整句与其子短语都在目录时，长句会被拆成「已译子短语 + 中间留英文」
/// （典型：skeleton crew 那句）。在落地前对**每条完整行**整串反查目录译文，AC 便不再蚕食。
/// 处理 `<span class='x'>整句</span>` 包裹：剥壳反查内层再回包。插值行整串 miss、原样返回，
/// 留待 to_chat 的模板逆匹配引擎（lang_template_apply）处理。locale==en 时直接返回（零开销）。
/proc/lang_localize_chat_sentence(line)
	if(!istext(line))
		return line
	if((GLOB.i18n_server_locale || DEFAULT_UI_LOCALE) == DEFAULT_UI_LOCALE)
		return line
	// 无 span 包裹的纯句：直接整串反查。
	var/hit = lang_reverse_text(line)
	if(hit != line)
		return hit
	// 形如 <span class='x'>INNER</span>：剥单层 span 反查内层，命中则回包。
	var/static/regex/span_re = regex("^(<span class='\[^']*'>)(.*)(</span>)$")
	if(span_re.Find(line))
		var/inner = span_re.group[2]
		var/inner_hit = lang_reverse_text(inner)
		if(inner_hit != inner)
			return span_re.group[1] + inner_hit + span_re.group[3]
	return line

/// 健康扫描与验尸报告由运行期拼接结构性 HTML label；这些短词与部位词不能进入全局反查。
/// 各报告的大小写敏感锚点表分别由顶层 health_scan_labels.json / autopsy_labels.json 提供，
/// 并保留 JSON 键顺序，使更长、更具体的锚先于通用前缀应用。

/// 对整份拼好的报告按 label_map 做带 HTML 锚点、大小写敏感的整体替换。locale==en no-op。
/proc/lang_apply_label_map(text, list/label_map)
	if(!istext(text) || (GLOB.i18n_server_locale || DEFAULT_UI_LOCALE) == DEFAULT_UI_LOCALE)
		return text
	for(var/needle in label_map)
		text = replacetextEx(text, needle, label_map[needle])
	return text

/// 健康报告整体拼好后，一次性应用显式域中的结构性 label。
/proc/lang_localize_health_scan(text)
	return lang_apply_label_map(text, lang_scoped_table("health_scan_labels.json"))

/// 验尸报告整体拼好后，一次性应用独立显式域中的结构性 label。
/proc/lang_localize_autopsy(text)
	return lang_apply_label_map(text, lang_scoped_table("autopsy_labels.json"))

/// 消息是否以「双感叹」结尾（大喊）。全角 ！ 与半角 ! 等价（含混排 !！/！!）——
/// 中文输入法默认全角标点，原判定只认半角导致中文玩家喊不出来。say_mod/say_quote/runechat 共用。
/proc/lang_yell_ending(text)
	var/last_two = copytext_char(text, -2)
	return last_two == "!!" || last_two == "！！" || last_two == "!！" || last_two == "！!"

/// 「多词」门槛的反查：仅含空白（多词/短语）的串才查表，避免把 On/None/枚举值/ckey 这类
/// 单词误翻（动态数据常正好等于某常见词）。短语类（datum 的 desc、多词 name）才反查。
/proc/lang_reverse_phrase(text)
	if(!istext(text) || !findtext(text, " "))
		return text
	return lang_reverse_text(text)


#define I18N_TGUI_PHRASE_CACHE_MAX 4096
/// 跨 payload 复用精确/模板反查结果；有界且满后不淘汰，避免动态值造成持续分配。
GLOBAL_LIST_EMPTY(i18n_tgui_phrase_cache)

/// TGUI 负载专用本地化：返回该串的译文（**调用方决定**是就地改写还是记进 overlay，见 lang_reverse_tree）。
///
/// 从前这里有两道闸门，都是为了「不把标识符改坏」——负载改成不动数据之后，两道都失去了理由：
///   · **多词门槛**（`findtext(text, " ")`）：单词值一律不查。它挡的是「把 `Water`/`Move` 这类
///     标识符改成中文导致回传对不上」，而现在回传的永远是英文原值。放开之后，「TGUI 里单词名
///     恒为英文」那一整类（线缆颜色、突变名、试剂/材料/设计名…）第一次有解。
///   · **「值本身是 tgui 目录键就原样返回」**：那是把显示权交给 TS、以保住数据；现在数据本来就
///     不动，跳过只会让这批值进不了 overlay、白白多绕一圈静态目录。
///
/// 单词值只走**整串精确反查**：模板逆匹配是给句子用的，单词过去只会徒增误伤。
/proc/lang_reverse_phrase_tgui(text)
	if(!istext(text) || length(text) < 2)
		return text
	var/multiword = findtext(text, " ")
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	// Single-token payload values are overwhelmingly refs, enum values, icon states and other identifiers.
	// The contract above says they only get an exact lookup, but the old implementation called
	// lang_reverse_suffixed() and then lang_localize_chain(), causing two exact/normalized lookups plus suffix/
	// article work for every miss. It also cached those effectively unbounded identifiers until they crowded
	// useful multi-word results out of the fixed 4096-entry cache. Keep one exact/normalized lookup so existing
	// catalog forms with quotes, grammar macros or source escapes retain their translations, but skip the
	// suffix/template/AC chain and miss cache.
	if(!multiword)
		return lang_reverse_text_in(text, locale)
	var/list/phrase_cache = GLOB.i18n_tgui_phrase_cache
	var/cache_ready = !GLOB.i18n_log_misses && islist(phrase_cache) && lang_runtime_is_ready() && lang_catalog_locale_is_loaded(locale)
	if(cache_ready && (text in phrase_cache))
		return phrase_cache[text]
	// lang_reverse_suffixed 而非裸 lang_reverse_text：TGUI 负载里同样有「基础句 + 运行期追加
	// 后缀」的值（赏金 description 加高优先级说明、手术 desc 加「每器官一次」），整串不是目录键，
	// 精确反查会连基础句一起 miss。无后缀时它就是 lang_reverse_text，零行为变化。
	. = lang_reverse_suffixed(text)
	if(. == text)
		// 精确（含归一化/后缀拆分）已查过且 miss，直接从冠词/模板阶段继续。过去这里又从 exact
		// 开头完整跑一遍，是 profiler 里 lang_reverse_text_in/lang_collapse_ws 重复翻倍的来源。
		// 单词值在上面就 return 了，走到这里必定是多词，所以模板照常开。
		. = lang_localize_chain(text, locale, allow_template = TRUE, exact_already_checked = TRUE)
	// 漏翻采集：反查与模板引擎都没命中的 TGUI 负载值（config I18N_LOG_MISSES 门控，见 miss_log.dm）。
	if(GLOB.i18n_log_misses && . == text && locale != DEFAULT_UI_LOCALE)
		lang_log_miss_scan(text, "tgui")
	if(cache_ready && length(phrase_cache) < I18N_TGUI_PHRASE_CACHE_MAX)
		phrase_cache[text] = .

/// TGUI 负载里必须保持原值的标识符字段/子树，以及**既是显示又是 act() 回传标识符**的列表键。
/// 这些 list 的字符串元素会原样回传给
/// 服务端做相等校验（tgui_alert 的 buttons 经 `act('choose',{choice:button})` 校验 `in buttons`；
/// tgui_input_list 的 items 经 `act('choose',{entry})` 校验 `in items`）。若 P1 把它们译成中文，
/// 前端回传中文、服务端用英文校验 → tgui_alert 直接 CRASH「non-existent button choice」、list 静默失败。
/// 故 lang_reverse_tree 必须**跳过这些键的值**（保持英文标识符）；显示交给 TS 端 auto-localize 翻
/// （`{button}` 文本节点过前端目录），值不动。新增同类回传列表键：改 strings/i18n/policy.json 的
/// `payload_skip_keys`（三端策略单一来源），不要改这里。
GLOBAL_LIST_INIT(i18n_payload_skip_keys, build_i18n_policy_set("payload_skip_keys"))

/// P1 允许**就地改写**的键（其余值不动数据、只进 overlay 交给 TS 渲染期翻）。
/// 见 strings/i18n/policy.json 的 `_payload_prose_keys`：只有「证明不可能是标识符」的长散文才配留在这里。
GLOBAL_LIST_INIT(i18n_payload_prose_keys, build_i18n_policy_set("payload_prose_keys"))

/// 从策略单一来源 strings/i18n/policy.json 读一个字符串数组字段，转关联 set（值=TRUE）。
/// 三端（DM/TS/Rust）共读同一份 policy —— 新增登记只改 policy.json（见其 _comment）。
/proc/build_i18n_policy_set(field)
	var/list/result = list()
	var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/policy.json"
	if(!fexists(path))
		return result
	var/list/decoded = json_decode(file2text(path))
	if(!islist(decoded))
		return result
	var/list/values = decoded[field]
	if(islist(values))
		for(var/value in values)
			result[value] = TRUE
	return result

/// 把一个负载字符串的译文「落地」：散文键（或无 overlay 的旧调用）就地改写；其余只登记进 overlay。
/// `index` 对关联项是键、对 flat 元素是下标 —— 两者都能直接给 `data[index] = …` 用。
/proc/lang_payload_localize(list/data, index, text, list/overlay, in_place)
	var/localized = lang_reverse_phrase_tgui(text)
	if(localized == text)
		return
	if(in_place || isnull(overlay))
		data[index] = localized
		return
	overlay[text] = localized

/// 递归把一个 list（含嵌套 list / 关联 list）里的字符串「值」按多词门槛反查为全服 locale 译文。
/// 用于 TGUI 的 ui_data/ui_static_data 负载：把非 atom datum 的 name/desc/说明等动态内容本地化。
/// key 不动（程序用的标识）。幂等（已译的中文不会再匹配英文 key）。
///
/// **两种落地方式，由 `overlay` 决定**：
///   · `overlay` 为 null（早期 string_cache 那类调用）→ 一律就地改写，行为与从前完全一致。
///   · 传了 `overlay`（TGUI 负载）→ 只有 `i18n_payload_prose_keys` 里的散文键就地改写，其余把
///     「英文 → 译文」记进 overlay、**值原样不动**，由 TS 在渲染期查表显示。
///
/// 为什么要分这一刀：就地改写是**破坏性**的——负载里那些「既是显示又是回传标识符」的值（`name`、
/// 扁平串列表…）一旦变成中文，客户端回传的就是中文，而服务端仍拿英文比较/查表 → `ui_act` 静默
/// 失败、连报错都没有（出生管理器、DNA 染色体、大气警报清除都栽在这上面）。启发式再准也挡不住这类，
/// 因为猜错的代价被放大成了功能故障；不动数据则代价退回「某处没翻」。散文键是唯一的例外：它们
/// 常被渲染在 auto-localize 够不到的位置（模板串、dangerouslySetInnerHTML），而散文不可能被
/// `act()` 拿去比较，就地翻是安全的。
///
/// 循环引用防护（visited）：TGUI 负载是任意游戏状态 list，BYOND 的 list 可以自引用/互引用成**环**
/// （tgstation 亦承认此事，见 /proc/deep_copy_without_cycles、/proc/prepare_lua_editor_list）。原来
/// 无守卫的递归遇到环会一路吃掉 8MB native 栈直到段错误、把整个 DreamDaemon 拖崩（生产实测：玩家
/// 开货运控制台触发，libbyond.so 栈溢出、进程 exit 1，systemd 循环重启）。这里沿用 tgstation 的
/// 惯用法——拿一个 assoc set 记下已访问过的每个 list（BYOND 支持 list 作关联键，O(1)），再遇到就
/// 跳过。比深度上限更准：不截断任何合法有限嵌套，只在真正成环处停手。
/// 注意：本 proc 只是**不再自己崩**；环仍留在 data 里，后续 json_encode 依旧会碰到（tgui 管线对环
/// 不安全，故 tgstation 送 tgui 前会 deep_copy_without_cycles 剥环）。根治须打断产生环的源头。
/proc/lang_reverse_tree(list/data, list/visited, list/overlay)
	if(!islist(data))
		return data
	if(isnull(visited))
		visited = list()
	else if(visited[data]) // 已访问过这个 list（成环/DAG 复用）——跳过，避免无限递归撑爆 native 栈。
		return data
	visited[data] = TRUE
	for(var/i in 1 to length(data))
		var/key = data[i]
		var/value = (istext(key) || ispath(key)) ? data[key] : null
		if(!isnull(value))
			// 标识符字段/子树与 act 回传列表（id/ref/icon/buttons/items/…）保持原值，并跳过无效遍历。
			// islist 守卫：早期 load_strings_file→lang_reverse_tree 调用时该 GLOBAL_LIST_INIT 可能未就绪。
			if(istext(key) && islist(GLOB.i18n_payload_skip_keys) && GLOB.i18n_payload_skip_keys[key])
				continue
			// 关联项：key -> value，只本地化 value
			if(islist(value))
				lang_reverse_tree(value, visited, overlay)
			else if(istext(value))
				lang_payload_localize(data, key, value, overlay, istext(key) && GLOB.i18n_payload_prose_keys?[key])
		else
			// flat 元素（无关联值）
			if(islist(key))
				lang_reverse_tree(key, visited, overlay)
			else if(istext(key))
				// flat 元素没有键语境 → 一律按「可能是标识符」处理（大气警报的区域名列表即此）。
				lang_payload_localize(data, i, key, overlay, FALSE)
	return data

#undef I18N_TGUI_PHRASE_CACHE_MAX

/// 职业描述本地化（偏好菜单职业 tab 的 tooltip）。antag_opt_in 模块把「opt-in 后缀句」拼到
/// description 末尾（`description = initial(description) + suffix`，见 antag_opt_in/code/job.dm），
/// 于是运行期整串 = 基础句 + 后缀，**整串非目录键** → lang_reverse_pref_descriptions 的整串精确
/// 反查必然 miss，AC 子串对长基础句也不稳。这里用 initial() 取回**基础句**单独精确反查（基础句是
/// 目录键，折叠续行制表符后命中），后缀短语各自在目录里 → 走 AC；拼回。无后缀的职业直接整串反查。
/// 全服 locale==en 时原样返回（零行为变化）。供 middleware/jobs.dm 调用。
/proc/lang_localize_job_description(datum/job/job)
	var/desc = job.description
	if(!istext(desc) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return desc
	var/base = initial(job.description)
	var/base_collapsed = lang_collapse_ws(base)
	var/base_zh = lang_reverse_text(base_collapsed)
	if(base_zh == base_collapsed) // 精确未命中 → 退模板逆匹配
		base_zh = lang_fallback_apply(base_collapsed)
	if(desc == base) // 无 opt-in 后缀
		return base_zh
	// desc = base + suffix：后缀短语（" Targetable by contractors." 等）**各自**是目录键，
	// 拼起来的整串不是 → 按句切开逐句精确反查（从前靠字面 AC 的子串替换，那一层已删）。
	var/suffix = copytext(desc, length(base) + 1)
	return base_zh + lang_localize_sentence_suffixes(lang_collapse_ws(suffix))

/// 按 duration_formatting.json 的显式 locale 域格式化时长。
/// 缺少当前 locale 或 schema 不完整时返回 null，让 core DisplayTimeText 保留 canonical English 路径。
/proc/lang_display_time_text(time_value, round_seconds_to = 0.1)
	var/list/formatting = lang_scoped_table("duration_formatting.json")
	var/list/units = formatting["units"]
	var/now = formatting["now"]
	var/separator = formatting["separator"]
	var/last_separator = formatting["last_separator"]
	if(!islist(units) || !istext(now) || !istext(separator) || !istext(last_separator))
		return null
	if(!istext(units["day"]) || !istext(units["hour"]) || !istext(units["minute"]) || !istext(units["second"]))
		return null
	var/second = FLOOR(time_value * 0.1, round_seconds_to)
	if(!second)
		return now
	if(second < 60)
		return lang_format_duration_unit(units["second"], second)
	var/minute = FLOOR(second / 60, 1)
	second = FLOOR(MODULUS(second, 60), round_seconds_to)
	if(minute < 60)
		var/list/minute_parts = list(lang_format_duration_unit(units["minute"], minute))
		if(second)
			minute_parts += lang_format_duration_unit(units["second"], second)
		return lang_join_duration_parts(minute_parts, separator, last_separator)
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS(minute, 60)
	if(hour < 24)
		var/list/hour_parts = list(lang_format_duration_unit(units["hour"], hour))
		if(minute)
			hour_parts += lang_format_duration_unit(units["minute"], minute)
		if(second)
			hour_parts += lang_format_duration_unit(units["second"], second)
		return lang_join_duration_parts(hour_parts, separator, last_separator)
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/list/day_parts = list(lang_format_duration_unit(units["day"], day))
	if(hour)
		day_parts += lang_format_duration_unit(units["hour"], hour)
	if(minute)
		day_parts += lang_format_duration_unit(units["minute"], minute)
	if(second)
		day_parts += lang_format_duration_unit(units["second"], second)
	return lang_join_duration_parts(day_parts, separator, last_separator)

/proc/lang_format_duration_unit(template, value)
	return replacetextEx(template, "{0}", "[value]")

/proc/lang_join_duration_parts(list/parts, separator, last_separator)
	if(length(parts) < 2)
		return parts.Join()
	var/tail = parts[length(parts)]
	parts.Cut(length(parts))
	return "[jointext(parts, separator)][last_separator][tail]"

/// 身体部位显示名的显式域查询。chest/head 等歧义单词只在部位语境翻译。
/proc/lang_zone(zone_text)
	if(!istext(zone_text) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return zone_text
	var/list/table = lang_scoped_table("zones.json")
	return table[zone_text] || zone_text

/// 材料显示名的显式域查询。gold/glass/iron 等歧义单词只在材料语境翻译。
/proc/lang_material(material_name)
	if(!istext(material_name) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return material_name
	var/list/table = lang_scoped_table("materials.json")
	return table[material_name] || material_name

/// 代词、系动词与语法一致性 token 的显式域查询。
/// 小写查找保持原有大小写无关行为；空译文是有效结果，用 isnull 区分未登记项。
/proc/lang_pronoun(word)
	if(!istext(word) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return word
	var/list/table = lang_scoped_table("grammar_tokens.json")
	var/mapped = table[LOWER_TEXT(word)]
	return isnull(mapped) ? word : mapped

/// 物种「描述」可能是字符串（多数物种 `return placeholder_description` / 单段裸串）或字符串列表
/// （shadekin 等多段 `return list("段1","段2")`）——按类型分派反查。get_species_description 两种返回
/// 都有，单用 lang_reverse_text 会漏掉 list 形态（且对 list 反查无意义）。
/proc/lang_reverse_text_or_list(value)
	if(islist(value))
		return lang_reverse_string_list(value)
	return lang_reverse_text(value)

/// 反查一个字符串列表的每个元素（用于物种 lore：list("段1", "段2", …) 逐段整串反查）。
/// 全服中文时就地改写并返回；locale==en 原样返回。
/proc/lang_reverse_string_list(list/strings)
	if(!islist(strings) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return strings
	for(var/i in 1 to length(strings))
		if(istext(strings[i]))
			strings[i] = lang_reverse_text(strings[i])
	return strings

/// 反查物种特征(perk)结构里的 name/description（结构：assoc[perk_type] = list of perk(assoc)）。
/// 静态 perk 串命中目录即译；perk 描述经 rewrite 已 LANG 化（模板可译），但插值实参里的**物种名**
/// （[name]/[plural_form]）运行时填的是英文 → 此处按物种名整词替换为中文译名（物种名在目录已译）。
/// 传入 species 以取其 name/plural_form。就地改写并返回。
/proc/lang_reverse_perks(list/perks, datum/species/species)
	if(!islist(perks) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return perks
	// 预编译「英文物种名 -> 中文译名」的整词正则（`\b` 词界防 Human→Humanoid 这类子串误伤）。
	var/list/name_subs = list() // regex -> 中文
	if(istype(species))
		for(var/en_name in list(species.name, species.plural_form))
			if(!istext(en_name) || !length(en_name))
				continue
			var/zh = lang_reverse_text(en_name)
			if(zh != en_name && !(en_name in name_subs)) // 已译且未登记
				name_subs[regex("\\b[en_name]\\b")] = zh
	for(var/perk_type in perks)
		var/list/perk_list = perks[perk_type]
		if(!islist(perk_list))
			continue
		for(var/list/perk in perk_list)
			if(!islist(perk))
				continue
			perk[SPECIES_PERK_NAME] = lang_localize_perk_text(perk[SPECIES_PERK_NAME], name_subs)
			perk[SPECIES_PERK_DESC] = lang_localize_perk_text(perk[SPECIES_PERK_DESC], name_subs)
	return perks

/// 单条 perk 文本本地化：先整串反查（兼容未 LANG 化的静态 perk），再按预编译正则替换物种名。
/proc/lang_localize_perk_text(text, list/name_subs)
	if(!istext(text))
		return text
	text = lang_reverse_text(text)
	for(var/regex/word_re in name_subs)
		text = word_re.Replace(text, name_subs[word_re])
	return text
