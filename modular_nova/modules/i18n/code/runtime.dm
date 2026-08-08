// NovaSector 全量汉化 (i18n) —— 运行时查表与格式化。
//
// 目录文件：strings/i18n/<locale>/<namespace>.json，扁平的 {"key": "模板"}。
// 模板用位置占位符 {0}/{1}…，允许按中文语序重排参数。
//
// 设计要点：目录在「启动时一次性加载」(GLOBAL_LIST_INIT)，之后 LANG 读取路径**只读**，
// 是纯函数——可安全用于标了 SpacemanDMM_should_be_pure 的 proc（如各类 examine 辅助）。

/// 全服默认 locale。中文服在 config 写 I18N_SERVER_LOCALE zh-Hans（见 config_entries.dm）。
GLOBAL_VAR_INIT(i18n_server_locale, DEFAULT_UI_LOCALE)

/// config 是否已加载完（即 i18n_server_locale 是否已是最终值）。由 world.ConfigLoaded() 置位。
///
/// 存在的理由：BYOND 启动顺序是 `Master => GLOB => make_datum_reference_lists()`，**然后**才
/// `world.New() => config.Load()`（见 code/game/world.dm 顶部）。所以在全局初始化期（GLOBAL_LIST_INIT、
/// make_datum_reference_lists 里的各 init_*()、datum 母版表构建）读到的 locale 恒是 en，
/// 此时调 lang_reverse_text 必然原样返回英文——**而且是完全静默的**，代码看着完备、实际从没生效。
/// emote 就这么躺了很久（/datum/emote/New() 里的整段反查是死代码，靠 run_emote 边界兜底才勉强能用）。
/// 有了这个标志，早调用会打一次 stack_trace，下一个同类死钩子在日志里自己现形。
GLOBAL_VAR_INIT(i18n_locale_resolved, FALSE)
/// 早调用告警计数。上限见 I18N_MAX_EARLY_WARNINGS：一次启动最多报这么多条，
/// 既能一轮把存量调用点全列出来（每轮只报一条要跑很多轮），又不至于刷屏。
GLOBAL_VAR_INIT(i18n_early_reverse_warnings, 0)
#define I18N_MAX_EARLY_WARNINGS 10

/// `strings/` 下的**匹配表**：靠字面比对驱动功能，翻译=替换=破坏匹配，一律不反查。
/// （展示型 flavor 表不在此列；口音替换表虽也保英文，但那是内容取舍、不是功能损坏，不登记在这。）
GLOBAL_LIST_INIT(i18n_match_table_files, list("phobia.json"))

/// 恐惧症中文触发词表（类别 -> 词表），来自 strings/i18n/phobia_words.json。
/// 与英文 strings/phobia.json **并存**：英文走原正则（带 \b 词边界），中文走无边界正则。
/// 详见该 JSON 的 _comment（为什么不能并进同一条正则、为什么不能直接翻译英文表）。
GLOBAL_LIST_EMPTY(i18n_phobia_words)
GLOBAL_VAR_INIT(i18n_phobia_words_loaded, FALSE)
/proc/lang_phobia_words(category)
	if(!GLOB.i18n_phobia_words_loaded)
		GLOB.i18n_phobia_words_loaded = TRUE
		var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
		if(locale != DEFAULT_UI_LOCALE)
			var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/phobia_words.json"
			if(fexists(path))
				var/list/decoded = json_decode(file2text(path))
				var/list/for_locale = islist(decoded) ? decoded[locale] : null
				if(islist(for_locale))
					for(var/phobia_category in for_locale)
						GLOB.i18n_phobia_words[phobia_category] = for_locale[phobia_category]
	return GLOB.i18n_phobia_words[category]

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

/// 是否启用聊天层 AC 子串兜底（默认关）。config I18N_CHAT_FALLBACK 控制（见 config_entries.dm + fallback.dm）。
GLOBAL_VAR_INIT(i18n_chat_fallback, FALSE)

/// 聊天 AC 兜底必须跳过的消息类型。两类：
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

/// locale -> (key -> 模板)。启动时加载，运行期只读。
GLOBAL_LIST_INIT(i18n_cache, build_i18n_cache())

/// 扫描 strings/i18n/ 下各 locale 目录，加载全部 .json。仅启动时调用（GLOBAL_LIST_INIT）。
/proc/build_i18n_cache()
	var/list/cache = list()
	var/base = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/"
	if(!fexists(base))
		return cache
	for(var/locale_entry in flist(base))
		if(!findtext(locale_entry, "/", -1)) // 只要目录（flist 给目录名带尾部 "/"）
			continue
		var/locale = copytext(locale_entry, 1, -1) // 去掉尾部 "/"
		var/list/merged = list()
		var/dir = "[base][locale_entry]"
		for(var/filename in flist(dir))
			if(!findtext(filename, ".json", -length(".json")))
				continue
			var/list/decoded = json_decode(file2text("[dir][filename]"))
			if(!islist(decoded))
				continue
			for(var/key in decoded)
				merged[key] = decoded[key]
		cache[locale] = merged
	return cache

/// 纯读：取某 locale 下某 key 的模板；缺失返回 null。
/proc/lang_template(key, locale)
	var/list/catalog = GLOB.i18n_cache[locale]
	return catalog?[key]

/// 把模板里的 {0}/{1}… 用 args 依次替换（args 为 /list，元素按位置对应）。
/// 文本实参经 lang_localize_arg 本地化链（仅全服 locale≠en；en 零额外开销）。
/proc/lang_interpolate(template, list/args)
	if(!length(args))
		return template
	var/localize = GLOB.i18n_server_locale != DEFAULT_UI_LOCALE
	var/result = template
	for(var/i in 1 to length(args))
		var/arg = args[i]
		if(localize && istext(arg))
			arg = lang_localize_arg(arg)
		result = replacetext(result, "{[i - 1]}", "[arg]")
	return result

/// LANG 实参/引擎捕获的统一本地化链：状态词 → 代词/系动词 → 整串反查 → 冠词剥离反查。
/// 解决「模板译了、运行期填进来的实参却是英文」的四类：
///   ① 开关/状态词（open/closed/lit…，`_state_words.json` 精确表）；
///   ② 代词与系动词（p_They()/p_are() 的 They/are → 他们/是，lang_pronoun 专用小表）；
///   ③ 目录里有的整串（安全等级 "green"→绿色、"None"→无——按值精确反查）；
///   ④ 带英文冠词的名字（"\the [src]"/"\a [x]" 渲染出的 "The wall"/"a Monkey"——剥冠词反查
///      余下部分（再试小写），命中则丢冠词：中文无冠词）。
/// 全部是精确匹配，查不到原样保留（玩家名/数字/已中文串零误伤）。
/proc/lang_localize_arg(arg)
	if(!length(arg))
		return arg
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
	return arg

/// **逆向**反查：把「已被反查成译文」的显示串还原回英文原文。用于 act 回传/按英文建键的查表
/// 场景——UI 把翻译过的 name 回传给英文键表（如 GLOB.name2reagent 用 initial(name) 建键，而
/// 实例 name 已被 New() 反查成中文 → 直接查必 miss）。惰性从反查表倒置构建（一对多取首个）；
/// locale==en 或查不到原样返回。**消费侧惯用法**：`map[x] || map[lang_unreverse_text(x)]`
/// （先原样查保英文路径零变化）。
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

/// 惰性加载「状态词 → 译文」表（全服 locale≠en 时读 strings/i18n/<locale>/_state_words.json；en 为空）。
/// 惰性而非 GLOBAL_LIST_INIT：避免在 i18n_server_locale 设置前被钉死成空表。
GLOBAL_LIST_EMPTY(i18n_state_words)
GLOBAL_VAR_INIT(i18n_state_words_loaded, FALSE)
/proc/lang_state_words()
	if(GLOB.i18n_state_words_loaded)
		return GLOB.i18n_state_words
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale != DEFAULT_UI_LOCALE)
		var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/[locale]/_state_words.json"
		if(fexists(path))
			var/list/decoded = json_decode(file2text(path))
			if(islist(decoded))
				for(var/word in decoded)
					GLOB.i18n_state_words[word] = decoded[word]
	GLOB.i18n_state_words_loaded = TRUE
	return GLOB.i18n_state_words

/// 惰性加载「神之声触发正则 → 追加了本地化别名的正则」表（locale≠en 时读 strings/i18n/voice_of_god.json）。
/// 与 _state_words 同样惰性：避免在 i18n_server_locale 设置前被钉死成空表。
///
/// 这张表**刻意不放在 strings/i18n/<locale>/ 目录**——那里的文件会被 build_i18n_cache 全量并进反查表，
/// 而 key 里有 "run"/"sit"/"stand"/"jump" 这类裸单词，进反查表就成了标识符碰撞（任何整串等于它们的
/// 显示文本会被替换成正则）。详见该 JSON 的 _comment。
GLOBAL_LIST_EMPTY(i18n_vog_triggers)
GLOBAL_VAR_INIT(i18n_vog_triggers_loaded, FALSE)
/proc/lang_vog_triggers()
	if(GLOB.i18n_vog_triggers_loaded)
		return GLOB.i18n_vog_triggers
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale != DEFAULT_UI_LOCALE)
		var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/voice_of_god.json"
		if(fexists(path))
			var/list/decoded = json_decode(file2text(path))
			var/list/for_locale = islist(decoded) ? decoded[locale] : null
			if(islist(for_locale))
				for(var/pattern in for_locale)
					GLOB.i18n_vog_triggers[pattern] = for_locale[pattern]
	GLOB.i18n_vog_triggers_loaded = TRUE
	return GLOB.i18n_vog_triggers

/// 把神之声命令的英文触发正则换成「英文 + 本地化别名」版本。未登记的 pattern 原样返回；locale==en 时 no-op。
/// 玩家在中文服里自然会用中文下命令（输入框标题/提示都是中文），只匹配英文等于整个法术失效。
/proc/lang_vog_trigger(pattern)
	if(!istext(pattern))
		return pattern
	var/list/table = lang_vog_triggers()
	return table[pattern] || pattern

/// 护甲防护等级 examine（list_armor 输出）的显示译名（英文名 -> 译名）。
/// 顶层 armor_classes.json，**不进全局反查表**：伤害类型名（ACID/BIOHAZARD/FIRE…）是单词类、且
/// 与 DISEASE_SEVERITY_BIOHAZARD 等 switch 标识符碰撞，进反查表会误伤。这里按 locale 单独读，
/// 只在 clothing/mecha 的 armor readout 落地点用。同 lang_vog_triggers。
GLOBAL_LIST_EMPTY(i18n_armor_classes)
GLOBAL_VAR_INIT(i18n_armor_classes_loaded, FALSE)
/proc/lang_armor_class(name)
	if(!istext(name))
		return name
	if(!GLOB.i18n_armor_classes_loaded)
		GLOB.i18n_armor_classes_loaded = TRUE
		var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
		if(locale != DEFAULT_UI_LOCALE)
			var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/armor_classes.json"
			if(fexists(path))
				var/list/decoded = json_decode(file2text(path))
				var/list/for_locale = islist(decoded) ? decoded[locale] : null
				if(islist(for_locale))
					for(var/class_name in for_locale)
						GLOB.i18n_armor_classes[class_name] = for_locale[class_name]
	return GLOB.i18n_armor_classes[name] || name

/// 「域内显示表」的通用加载器。
///
/// 顶层 `strings/i18n/<file>.json`（形如 `{"zh-Hans": {"英文": "译名"}}`）**不被 build_i18n_cache
/// 合并进全局反查表**——表里的值往往同时是 icon_state / assoc 键 / switch 标识符，而且多是
/// blue、Fire、Power 这类通用单词，进反查表必然误伤（见 `nova-i18n lint` 的单词类碰撞）。
/// 按域分表而不是合成一张大表：同一个词在不同域可以译得不一样，也不会互相污染。
///
/// 新增一个域：放一个 json + 写一个三行的 `lang_xxx()` 包装即可。
/// （armor_classes / voice_of_god / phobia / statpanel 几张老表各有自己的加载逻辑，暂未并过来。）
GLOBAL_LIST_EMPTY(i18n_scoped_tables)
/proc/lang_scoped_table(file_name)
	var/list/cached = GLOB.i18n_scoped_tables[file_name]
	if(islist(cached))
		return cached
	var/list/table = list()
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale != DEFAULT_UI_LOCALE)
		var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/[file_name]"
		if(fexists(path))
			var/list/decoded = json_decode(file2text(path))
			var/list/for_locale = islist(decoded) ? decoded[locale] : null
			if(islist(for_locale))
				for(var/entry in for_locale)
					table[entry] = for_locale[entry]
	GLOB.i18n_scoped_tables[file_name] = table
	return table

/// `english_list()` 的本地化版：**逐项**过 lang_localize_arg（状态词表 → 反查 → 冠词剥离），
/// 再用中文顿号连接。
///
/// 这类「形容词/状态词列表拼成一句」的写法（鱼的健康警告、材料属性详检、伤情列表…）整句永远
/// 不是目录键，而 `english_list` 拼出来的成品里每个词都还是英文——只能逐项翻。连接词也要换：
/// 英文的 " and " 直接留在中文句子里很难看，中文用「、」。locale==en 时原样调 english_list，零变化。
/proc/lang_english_list(list/items, nothing_text = "nothing")
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return english_list(items, nothing_text)
	if(!length(items))
		return lang_localize_arg(nothing_text)
	var/list/localized = list()
	for(var/item in items)
		localized += lang_localize_arg("[item]")
	return jointext(localized, "、")

/// 史莱姆颜色（SLIME_TYPE_* 的值）的显示译名。颜色同时是 icon_state 与突变表键，不能进反查表。
/proc/lang_slime_colour(colour)
	if(!istext(colour))
		return colour
	var/list/table = lang_scoped_table("slime_colours.json")
	return table[colour] || colour

/// 线缆颜色的显示译名。颜色值同时是 act 回传标识符（`wire.color`）与 CSS 颜色名
/// （前端 `labelColor={shownColor.replace(' ','')}`），所以值本身必须留英文；
/// ui_data 里另发一个 shownColorLabel 供前端当 label 用。
/// **不能**图省事塞进 tgui.json：那份也被 build_i18n_cache 读进全局反查表，
/// blue/purple/gold 进去就毒化整个 DM 侧（i18n_real_catalog 抓到过一次）。
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

/// 状态栏页签名/分组标题的显示译名表（英文标识符 -> 译名），发给 statbrowser.js 只用于渲染文字。
/// 同 lang_vog_triggers 放顶层 JSON：键是 Admin/Game/Object 这类裸单词，进全局反查表会造成标识符碰撞。
/// **页签名本身绝不本地化**——它是 button.id、SendTabToByond 回传值、statpanel.dm `stat_tab ==` 比较的
/// 三重标识符，且 split_admin_tabs 靠 JS 里硬编码的 `splitName[0] === 'Admin'` 拆子页签。详见该 JSON 的 _comment。
GLOBAL_LIST_EMPTY(i18n_statpanel_tab_labels)
GLOBAL_VAR_INIT(i18n_statpanel_tab_labels_loaded, FALSE)
/proc/lang_statpanel_tab_labels()
	if(GLOB.i18n_statpanel_tab_labels_loaded)
		return GLOB.i18n_statpanel_tab_labels
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale != DEFAULT_UI_LOCALE)
		var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/statpanel_tabs.json"
		if(fexists(path))
			var/list/decoded = json_decode(file2text(path))
			var/list/for_locale = islist(decoded) ? decoded[locale] : null
			if(islist(for_locale))
				for(var/tab_name in for_locale)
					GLOB.i18n_statpanel_tab_labels[tab_name] = for_locale[tab_name]
	GLOB.i18n_statpanel_tab_labels_loaded = TRUE
	return GLOB.i18n_statpanel_tab_labels

/// BYOND 文法宏（\the \a \improper 等，无参、由引擎按名词上下文在**编译期/输出期**处理）。模板从 JSON
/// 加载后引擎不再处理 → 会字面显示。中文无冠词/复数、且上下文已丢失，直接剥掉。`\b` 防 \theory 等误伤；
/// 已转义的反斜杠（\\）开头不会被这里的单反斜杠模式吃掉。只列已知文法宏，不碰 \n \t \" 等真转义。
// 末尾的 es|s 是 BYOND 复数后缀宏 \s/\es（"[n] apple\s" → 引擎按数量补 "s"）：runtime 构建的 LANG
// 串不被引擎处理 → 字面 \s 漏出（如「30 cable piece\s」）。中文无复数，直接剥除（与冠词/代词宏同处理）。
GLOBAL_VAR_INIT(i18n_text_macro_regex, regex(@"\\(improper|proper|themselves|theirs|himself|herself|itself|their|them|they|roman|Roman|the|The|hers|she|She|her|his|him|its|it|It|he|He|an|An|a|A|es|s)\b", "g"))

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

	. = lang_interpolate(template, args)
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
// 变量初始化（name = "..."）无法改写成 LANG()（DM 变量初值需常量），所以改为：在 Initialize
// 期把英文整串反查成译文。反查表 = 英文原文 -> 译文，仅含「无占位符的纯字符串」（name/desc
// 几乎都是纯字符串）。译文随 Codex/Tolgee 落地自动生效，无需再改代码。

/// locale -> (英文原文 -> 译文)。惰性构建（写 GLOB，仅供 /atom/Initialize 等非纯路径调用）。
GLOBAL_LIST_EMPTY(i18n_reverse)

/// 剥掉 BYOND 文法宏 \improper/\proper，得到「显示形态」串。
/// 两种来源都要剥：① 运行时 name/desc 里是**编译期标记字节**（DM 源写 "\improper" 即该字节，
/// 故 replacetext 用 "\improper" 能匹配）；② 目录 JSON 里存的是**字面** "\improper"（反斜杠+improper，
/// 用 "\\improper" 匹配）。规整到无宏并 trim，使两端对齐（否则带 \improper 的名永远查不中）。
/proc/lang_strip_grammar_macros(text)
	if(!istext(text))
		return text
	text = replacetext(text, "\improper", "") // 运行时标记字节形态
	text = replacetext(text, "\proper", "")
	text = replacetext(text, "\\improper", "") // 目录字面形态
	text = replacetext(text, "\\proper", "")
	return trim(text)

/// 惰性构建某 locale 的反查表（从已加载的 GLOB.i18n_cache 读取）。
/proc/lang_build_reverse(locale)
	if(GLOB.i18n_reverse[locale])
		return GLOB.i18n_reverse[locale]

	var/list/english = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	var/list/localized = GLOB.i18n_cache[locale]
	// i18n_cache 尚未就绪（极早期 GLOBAL_LIST_INIT 期间被调用）：返回空表但**不缓存**，
	// 否则会把空反查表钉死到 GLOB.i18n_reverse[locale]，毒化之后所有反查。
	if(!islist(english) || !islist(localized))
		return list()
	var/list/reverse = list()
	for(var/key in english)
		var/en_text = english[key]
		if(findtext(en_text, "{")) // 带占位符的走 LANG 调用，不走反查
			continue
		var/translated = localized[key]
		if(translated && translated != en_text)
			reverse[en_text] = translated
			// 文法宏对齐：额外登记「剥宏」形态键，让运行时带标记字节的 name（如
			// "\improper Space Cigarettes packet"）也能命中（值同样剥宏，去掉中文里多余的 \improper）。
			if(findtext(en_text, "\\improper") || findtext(en_text, "\\proper"))
				var/stripped_key = lang_strip_grammar_macros(en_text)
				if(stripped_key && !reverse[stripped_key])
					reverse[stripped_key] = lang_strip_grammar_macros(translated)
			// 源码转义对齐：dreammaker 解析器把 `\"`/`\n`/`\t`/`\[`/`\]` 原样保留在目录里（字面反斜杠序列），
			// 但 BYOND 运行时字符串里这些已被解析成裸引号/换行/制表符/字面方括号。反查输入=运行时串 → 查带字面
			// 转义的 key 永不命中 → 额外登记「去转义」形态键（译文同样去转义）。影响所有含这些转义的 name/desc/
			// lore，尤其**多行 desc 的 \n**（如采矿订购台物品描述：目录已译却因换行不匹配而显英文）。
			if(findtext(en_text, "\\"))
				var/unescaped_key = lang_unescape_source(en_text)
				if(unescaped_key != en_text && !reverse[unescaped_key])
					reverse[unescaped_key] = lang_unescape_source(translated)
			// 首字母大小写对齐：DM 里「小写存、显示时 capitalize()」是通用写法（手术名
			// `capitalize(operation.name)`、伤口/器官/试剂名、`"[capitalize(x.name)]"` 拼句…）。
			// 目录键保留源码原样的小写形态，运行期送来的却是首字母大写的串 → 精确反查与 AC 字典
			// 双双 miss，整类「目录里明明有译文却显英文」（外科处理机列出的 Tend wounds/Lobotomize
			// 即此）。这里额外登记首字母大写的变体键，指向同一译文；已有精确键优先，不覆盖。
			// 中文无大小写，值不用变。
			// **只做多词键**：单词键几乎全是标识符形态（"move"/"add"/"clear"/"ready"…），
			// 给它们登记大写变体会把 `switch("Add")`、`if(pick == "Clear")` 这类比较拖进反查面
			// —— 与 P1 的多词门槛、AC 字典的多词过滤是同一条安全线，此处保持一致。
			var/first_char = copytext(en_text, 1, 2)
			if(findtext(en_text, " ") && findtextEx("abcdefghijklmnopqrstuvwxyz", first_char))
				var/capitalized_key = uppertext(first_char) + copytext(en_text, 2)
				if(!reverse[capitalized_key])
					reverse[capitalized_key] = translated

	GLOB.i18n_reverse[locale] = reverse
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
	// config 尚未加载 → locale 还不是最终值 → 下面必然 early-return 英文。静默失效很难查，
	// 这里打一次 stack_trace 把调用点指出来（见 i18n_locale_resolved 的注释）。
	if(!GLOB.i18n_locale_resolved && GLOB.i18n_early_reverse_warnings < I18N_MAX_EARLY_WARNINGS)
		GLOB.i18n_early_reverse_warnings++
		stack_trace("i18n: lang_reverse_text() 在 config 加载前被调用——此刻 locale 恒为 en，本次及此前所有反查都原样返回了英文。若这是 datum 母版表的初始化钩子，它是死代码，应改到显示边界或 SS Initialize 里做。")
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale == DEFAULT_UI_LOCALE)
		return text
	var/list/reverse = GLOB.i18n_reverse[locale] || lang_build_reverse(locale) // PERF: read the cached table directly; only call the builder before it's ready — saves a proc call per atom name/desc reverse at init (~550k calls)
	. = reverse[text]
	if(!isnull(.))
		return .
	// 未直接命中：若含文法宏标记字节，剥宏后再查一次（对齐目录里的剥宏形态键）。
	if(findtext(text, "\improper") || findtext(text, "\proper"))
		. = reverse[lang_strip_grammar_macros(text)]
		if(!isnull(.))
			return .
	// 仍未命中：DM 把 "\" 续行的前导制表符/空格并入字符串、抽取器却归一成单空格 → 折叠后再查一次
	// （不止 \t：多空格续行也会漏）。PERF：collapse_ws 正则只在含 \t 或连续 2+ 空格时才改动文本，
	// 而它是每次反查 miss 都跑的热点（启动期每个 atom name/desc 都过这里）——先用廉价 findtext 守卫，
	// 简单单行名（绝大多数 atom）直接跳过正则。行为等价：守卫覆盖了 collapse_ws 会改动的全部情形。
	if(findtext(text, "\t") || findtext(text, "  "))
		var/collapsed = lang_collapse_ws(text)
		if(collapsed != text)
			. = reverse[collapsed]
			if(!isnull(.))
				return .
	// 仍未命中：strings/ 数据文件的值偶带首尾空白（如 ion_laws.json 的 "BILLION … SHAB-AB-DOOD-ILLION "），
	// 抽取器入目录时按 trim 形态存 → 运行时原样值精确反查失手（strings 加载处反查/模板实参反查都路过这里）。
	// trim 后再查一次，命中则把原首尾空白拼回（离子法则等下游拼接依赖这些空格）。
	// 廉价守卫：首/尾字节是空白才走（513+ 文本 proc 按字节偏移，空白必为 ASCII，UTF-8 续字节 >127 不误伤）。
	var/textlen = length(text)
	if(text2ascii(text, 1) <= 32 || text2ascii(text, textlen) <= 32)
		var/start = 1
		while(start <= textlen && text2ascii(text, start) <= 32)
			start++
		var/end = textlen
		while(end >= start && text2ascii(text, end) <= 32)
			end--
		if(end >= start)
			. = reverse[copytext(text, start, end + 1)]
			if(!isnull(.))
				return copytext(text, 1, start) + . + copytext(text, end + 1)
	// 仍未命中：strings/ 数据值偶带**成对单引号**（ion_laws.json 词池 "'PRETZELS'"），抽取器
	// 入目录存去引号形 → 原样精确失手（暗号生成、离子法则实参都路过）。剥引号再查，命中直接
	// 返回译文（zh 不需要英文式引号强调；与 'Clown'→小丑 的既有目录行为一致）。
	if(textlen > 2 && text2ascii(text, 1) == 39 && text2ascii(text, textlen) == 39)
		. = reverse[copytext(text, 2, textlen)]
		if(!isnull(.))
			return .
	// 仍未命中：`desc = span_alert("…")` 类编译期包裹 → 运行时值带 <span> 外壳，目录存的是内层
	// （抽取器解 span_* 宏）。剥单层 span 反查内层，命中回包（保留原样式）。廉价守卫：< 开头才走正则。
	if(text2ascii(text, 1) == 60)
		var/static/regex/reverse_span_re = regex("^(<span class='\[^']*'>)(.*)(</span>)$")
		if(reverse_span_re.Find(text))
			var/inner = reverse_span_re.group[2]
			var/inner_hit = reverse[inner]
			if(!isnull(inner_hit))
				return reverse_span_re.group[1] + inner_hit + reverse_span_re.group[3]
	return text

/// 显示用「物件名」本地化：先整串精确反查（命中堆叠/单词名/已译名幂等），miss 再走 AC 子串兜
/// 复合名（如 "Robotics Lab APC" → 区域名子串 "Robotics Lab" 被换）。与 screentip（_atom.dm）同款
/// 两步，抽成共用 proc 供「绕过 examine/AC 路径、只发 atom.name 的 UI」复用（如 LootPanel）。
/// 仅用于**纯显示**的名字（act/回传用 ref/path、不用 name 处），翻名不破标识符。locale==en no-op。
/proc/lang_localize_display_name(text)
	if(!istext(text) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return text
	. = lang_reverse_text(text)
	if(. == text) // 精确 miss → 复合名走 AC 子串
		. = lang_fallback_apply(text)

/// 已知会被运行期 `desc +=` 追加的固定后缀（trim 形态）。base + 后缀都是各自独立的目录键，但拼接后
/// 整串非目录键 → exact 反查 miss。这些追加发生在 New()/早期（i18n_cache 未就绪、原地反查会空转），
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

/// 健康分析仪/医疗终端的扫描报告是运行期把大量硬编码英文 HTML 片段 jointext 成一坨、再经
/// to_chat 输出的「绕过 sink/P1」结构：这些结构性 label 无句末标点→抽取器没收，且列头/状态词是
/// 单词→to_chat 的 AC 兜底天然跳过（防碰撞）。故在落地点（jointext 之后）对这份**稳定小集合**
/// 的 label 做带 HTML 锚点的精确替换。用 replacetextEx（大小写敏感）避免误伤 "Burn"↔"burn"、
/// "type:"↔"Type:"。病名/伤名/husk 整句等（有句末标点、已进目录）仍交给 to_chat 的 AC。locale==en no-op。
GLOBAL_LIST_INIT(i18n_health_scan_labels, list(
	// 段落/区段标题（长串在前）
	// 无残疾时 get_quirk_string 返回裸词 "None"（无句末标点→to_chat 的 AC 跳过），故整行锚点须排在下面
	// 的通用 label 之前：lang_apply_label_map 顺序 replacetextEx，通用 label 一旦替换掉前缀，整行就匹配不到了。
	"Subject Major Disabilities: None." = "对象重大残疾: 无。",
	"Subject Minor Disabilities: None." = "对象次要残疾: 无。",
	"Subject Major Disabilities: " = "对象重大残疾: ",
	"Subject Minor Disabilities: " = "对象次要残疾: ",
	"Detected cybernetic modifications:" = "检测到的义体改造:",
	"Analyzing results for " = "正在分析 ",
	"Overall status: " = "总体状态: ",
	"Genetic Stability: " = "基因稳定性: ",
	"Core temperature: " = "核心体温: ",
	"Body temperature: " = "体温: ",
	"Body status:" = "身体状态:",
	"Organ status:" = "器官状态:",
	"Time of Death: " = "死亡时间: ",
	"Fatigue level: " = "疲劳程度: ",
	"Blood level:" = "血液水平:",
	" alcohol content:" = " 酒精含量:",
	"Species: " = "物种: ",
	// 表格列头
	"<b>Damage:</b>" = "<b>损伤:</b>",
	"<b>Suffocation</b>" = "<b>窒息</b>",
	"<b>Overall:</b>" = "<b>总计:</b>",
	"<b>Organ:</b>" = "<b>器官:</b>",
	"<b>Status</b>" = "<b>状态</b>",
	"<b>Brute</b>" = "<b>钝击</b>",
	"<b>Burn</b>" = "<b>灼烧</b>",
	"<b>Toxin</b>" = "<b>毒素</b>",
	"<b>Dmg</b>" = "<b>损伤</b>",
	// 部位单元格（>名:</font> 锚点，颜色在 > 之前不受影响）
	">Head:</font>" = ">头部:</font>",
	">Chest:</font>" = ">胸部:</font>",
	">Left arm:</font>" = ">左臂:</font>",
	">Right arm:</font>" = ">右臂:</font>",
	">Left leg:</font>" = ">左腿:</font>",
	">Right leg:</font>" = ">右腿:</font>",
	// 器官/整体状态词（带标签锚点）
	">Missing</font>" = ">缺失</font>",
	">OK</font>" = ">正常</font>",
	// 器官状态文本（_organ.dm get_status_text：<font color=…>词</font>，tochat 时外层再套 tooltip span；
	// 颜色在 > 之前不受影响 → 锚 >词</font>）。无句末标点→AC 跳过，且未进目录，故在此精确锚点替换。
	">Non-Functional</font>" = ">无功能</font>",
	">Severely Damaged</font>" = ">严重损伤</font>",
	">Mildly Damaged</font>" = ">轻微损伤</font>",
	">Harmful Foreign Body</font>" = ">有害异物</font>",
	">EMP-Derived Failure</font>" = ">EMP 导致的故障</font>",
	// 肢体明细行（healthscan dmgreport）：外伤/异物前缀 + 断肢。conditional_tooltip 的可见文本仍是子串。
	"Physical trauma: " = "外伤: ",
	"Foreign object(s): " = "异物: ",
	"Dismembered" = "已断肢",
	"<b>Deceased</b>" = "<b>已死亡</b>",
	"% healthy</b>" = "% 健康</b>",
	">type: " = ">类型: ",
))

/// 验尸报告（autopsy_scanner）另起一份**自建**报告：格式不同（`<b>标签:</b>`、无颜色）、且印在
/// 纸上（不经 to_chat 的 AC）→ 需独立锚点表。部位单元格用 `<b>名:</b>`（limb.name/parse_zone）。
GLOBAL_LIST_INIT(i18n_autopsy_labels, list(
	// 标题/元信息
	"Autopsy report</br>" = "验尸报告</br>",
	"Time of Autopsy: " = "验尸时间: ",
	"Autopsy Coroner - " = "验尸法医 - ",
	"Analyzing results for " = "正在分析 ",
	"Time of Death - " = "死亡时间 - ",
	"Subject has been dead for " = "对象死亡已持续 ",
	// 身体数据表
	"<u><b>Body Data:</b></u>" = "<u><b>身体数据:</b></u>",
	"<b>Damage:</b>" = "<b>损伤:</b>",
	"<b>Overall:</b>" = "<b>总计:</b>",
	// 列头 / 合计行（合计行带前导空格，独立不冲突）
	"<b>Suffocation</b>" = "<b>窒息</b>",
	"<b>Brute</b>" = "<b>钝击</b>",
	"<b>Burn</b>" = "<b>灼烧</b>",
	"<b>Toxin</b>" = "<b>毒素</b>",
	" Suffocation</b>" = " 窒息</b>",
	" Brute</b>" = " 钝击</b>",
	" Burn</b>" = " 灼烧</b>",
	" Toxin</b>" = " 毒素</b>",
	// 部位单元格
	"<b>Head:</b>" = "<b>头部:</b>",
	"<b>Chest:</b>" = "<b>胸部:</b>",
	"<b>Left arm:</b>" = "<b>左臂:</b>",
	"<b>Right arm:</b>" = "<b>右臂:</b>",
	"<b>Left leg:</b>" = "<b>左腿:</b>",
	"<b>Right leg:</b>" = "<b>右腿:</b>",
	"Physical trauma: " = "外伤: ",
	"<u>Dismembered</u>" = "<u>已断肢</u>",
	"Foreign object(s): " = "异物: ",
	" - Caused by <u>" = " - 造成者 <u>",
	// 器官数据表
	"<u><b>Organ Data:</b></u>" = "<u><b>器官数据:</b></u>",
	"<b>Organ:</b>" = "<b>器官:</b>",
	"<b>Dmg</b>" = "<b>损伤</b>",
	"<b>Status</b>" = "<b>状态</b>",
	"<u>Missing</u>" = "<u>缺失</u>",
	"<td>OK</td>" = "<td>正常</td>",
	"Detected cybernetic modifications:" = "检测到的义体改造:",
	// 基因/物种/体温
	"Genetic Stability:" = "基因稳定性:",
	"<b>Species:</b>" = "<b>物种:</b>",
	"Core temperature:" = "核心体温:",
	"Body temperature:" = "体温:",
	// 枯尸原因
	"Subject is husked by: " = "对象被枯尸化，原因: ",
	"Desiccation, commonly caused by Changelings." = "干尸化，常由拟态怪引起。",
	"Stripped flesh." = "皮肉剥离。",
	"Unknown causes." = "未知原因。",
	"Severe burns." = "严重烧伤。",
	// 血液
	"Blood level:" = "血液水平:",
	", type: " = ", 类型: ",
	" alcohol content:" = " 酒精含量:",
	// 化学/疾病数据
	"<u>Chemical Data:</u>" = "<u>化学数据:</u>",
	" in bloodstream." = " 存在于血液中。",
	"<u>Disease Data:</u>" = "<u>疾病数据:</u>",
	"<b>Disease Name:</b> " = "<b>疾病名称:</b> ",
	"<b>Transmission Type:</b> " = "<b>传播类型:</b> ",
	"<b>Symptoms:</b>" = "<b>症状:</b>",
	"<b>Coroner's Notes:</b>" = "<b>法医备注:</b>",
))

/// 对整份拼好的报告按 label_map 做带 HTML 锚点、大小写敏感的整体替换。locale==en no-op。
/proc/lang_apply_label_map(text, list/label_map)
	if(!istext(text) || (GLOB.i18n_server_locale || DEFAULT_UI_LOCALE) == DEFAULT_UI_LOCALE)
		return text
	for(var/needle in label_map)
		text = replacetextEx(text, needle, label_map[needle])
	return text

/// 见 i18n_health_scan_labels：报告整体拼好后一次性本地化结构性 label。healthscan() 落地点调用。
/proc/lang_localize_health_scan(text)
	return lang_apply_label_map(text, GLOB.i18n_health_scan_labels)

/// 见 i18n_autopsy_labels：验尸报告拼好后本地化。autopsy_scanner 的 jointext 落地点调用。
/proc/lang_localize_autopsy(text)
	return lang_apply_label_map(text, GLOB.i18n_autopsy_labels)

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

/// TGUI 前端目录（en/tgui.json）里的英文串集合。这些串由 TS 端 auto-localize **只翻显示**，
/// 故 P1（lang_reverse_tree）必须跳过它们——很多是 act() 标识符（职业名/怪癖名/配件名…），
/// 改了 ui_data 值会破坏操作；交给 TS 端翻显示、数据保持英文最安全。同时这也覆盖了**单词类**
/// 标识符名（P1 的多词门槛本就漏掉、但 TS 端无门槛能翻）。启动加载、运行只读。
GLOBAL_LIST_INIT(i18n_tgui_strings, build_tgui_string_set())

#define I18N_TGUI_PHRASE_CACHE_MAX 4096
/// 跨 payload 复用精确/模板反查结果；有界且满后不淘汰，避免动态值造成持续分配。
GLOBAL_LIST_EMPTY(i18n_tgui_phrase_cache)

/proc/build_tgui_string_set()
	var/list/result = list()
	var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/[DEFAULT_UI_LOCALE]/tgui.json"
	if(!fexists(path))
		return result
	var/list/decoded = json_decode(file2text(path))
	if(islist(decoded))
		for(var/key in decoded)
			result[key] = TRUE
	return result

/// TGUI 负载专用反查：若该串属于 TGUI 前端目录（TS 端会翻显示），P1 跳过不动数据（保住标识符）；
/// 否则走多词反查（datum 描述等不在前端目录的长文本）。
/proc/lang_reverse_phrase_tgui(text)
	if(!istext(text) || !findtext(text, " "))
		return text
	var/locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	var/list/phrase_cache = GLOB.i18n_tgui_phrase_cache
	var/cache_ready = !GLOB.i18n_log_misses && islist(phrase_cache) && islist(GLOB.i18n_tgui_strings) && islist(GLOB.i18n_cache[locale])
	if(cache_ready && (text in phrase_cache))
		return phrase_cache[text]
	// islist 守卫：i18n_tgui_strings 是 GLOBAL_LIST_INIT，极早期（如 construct_phobia_regex 等全局变量
	// 初始化期）调用 load_strings_file→lang_reverse_tree 时它可能尚未就绪，直接索引会 bad index 崩溃，
	// 进而把加载的串写成 null、破坏 phobia 等早期数据。未就绪时跳过跳过集判断，走多词反查
	// （lang_build_reverse 已加固：cache 未就绪返回空表、原样返回，不崩不污染）。
	if(islist(GLOB.i18n_tgui_strings) && GLOB.i18n_tgui_strings[text])
		. = text
	else
		// lang_reverse_suffixed 而非裸 lang_reverse_text：TGUI 负载里同样有「基础句 + 运行期追加
		// 后缀」的值（赏金 description 加高优先级说明、手术 desc 加「每器官一次」），整串不是目录键，
		// 精确反查会连基础句一起 miss。无后缀时它就是 lang_reverse_text，零行为变化。
		. = lang_reverse_suffixed(text)
	// 整串精确反查未命中的多词串：很多是**运行期拼接/插值后才成形**的句子（Orion 事件 text、研究要求
	// "Scan unique individuals with [desc]." 等经 ui_data 下发的动态串）——exact 反查够不着。补一道边界
	// 模板逆匹配引擎：目录里已译的 {0} 模板按字面段在原串上命中、捕获实参反查后按 zh 模板填充。这样
	// TGUI 负载里的拼接句与聊天/browse 共享同一引擎。en locale / 无锚命中时引擎走快路径原样返回（零开销）。
	if(. == text)
		. = lang_template_apply(text, locale)
		// 漏翻采集：反查 + 模板引擎都没命中的多词 TGUI 负载值（config I18N_LOG_MISSES 门控，见 miss_log.dm）。
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

/// 递归把一个 list（含嵌套 list / 关联 list）里的字符串「值」按多词门槛反查为全服 locale 译文。
/// 用于 TGUI 的 ui_data/ui_static_data 负载：把非 atom datum 的 name/desc/说明等动态内容本地化。
/// key 不动（程序用的标识）；就地改写并返回。幂等（已译的中文不会再匹配英文 key）。
///
/// 循环引用防护（visited）：TGUI 负载是任意游戏状态 list，BYOND 的 list 可以自引用/互引用成**环**
/// （tgstation 亦承认此事，见 /proc/deep_copy_without_cycles、/proc/prepare_lua_editor_list）。原来
/// 无守卫的递归遇到环会一路吃掉 8MB native 栈直到段错误、把整个 DreamDaemon 拖崩（生产实测：玩家
/// 开货运控制台触发，libbyond.so 栈溢出、进程 exit 1，systemd 循环重启）。这里沿用 tgstation 的
/// 惯用法——拿一个 assoc set 记下已访问过的每个 list（BYOND 支持 list 作关联键，O(1)），再遇到就
/// 跳过。比深度上限更准：不截断任何合法有限嵌套，只在真正成环处停手。
/// 注意：本 proc 只是**不再自己崩**；环仍留在 data 里，后续 json_encode 依旧会碰到（tgui 管线对环
/// 不安全，故 tgstation 送 tgui 前会 deep_copy_without_cycles 剥环）。根治须打断产生环的源头。
/proc/lang_reverse_tree(list/data, list/visited)
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
				lang_reverse_tree(value, visited)
			else if(istext(value))
				data[key] = lang_reverse_phrase_tgui(value)
		else
			// flat 元素（无关联值）
			if(islist(key))
				lang_reverse_tree(key, visited)
			else if(istext(key))
				data[i] = lang_reverse_phrase_tgui(key)
	return data

#undef I18N_TGUI_PHRASE_CACHE_MAX

/// 偏好菜单「常量数据 asset」(/datum/asset/json/preferences) 是服务器启动生成一次的静态资源，
/// **不经 get_payload**，故 lang_reverse_tree 永远碰不到它。此 pass 专供该 asset：只反查
/// **纯显示字段**（各种 description）——这些绝非 act() 标识符，可安全整串替换（用 lang_reverse_text
/// 全量匹配，无多词门槛，短描述也能命中）；name/title/choices/department 等是标识符，一律不动。
/// 递归走嵌套 list。全服 locale==en 时 lang_reverse_text 直接原样返回（零行为变化）。
/// 新增纯显示字段：改 strings/i18n/policy.json 的 `pref_desc_keys`（三端策略单一来源）。
GLOBAL_LIST_INIT(i18n_pref_desc_keys, build_i18n_policy_set("pref_desc_keys"))

/proc/lang_reverse_pref_descriptions(list/data)
	if(!islist(data))
		return data
	for(var/i in 1 to length(data))
		var/key = data[i]
		var/value = (istext(key) || ispath(key)) ? data[key] : null
		if(isnull(value))
			if(islist(key))
				lang_reverse_pref_descriptions(key)
			continue
		if(islist(value))
			lang_reverse_pref_descriptions(value)
		else if(istext(value) && GLOB.i18n_pref_desc_keys[key])
			// 先折叠续行制表符对齐目录键（job 描述常用 "\" 续行，运行期带制表符 → 否则连基础句都不命中）。
			var/collapsed = lang_collapse_ws(value)
			var/translated = lang_reverse_text(collapsed)
			// 整串无精确匹配时退到 AC 子串层：command/sec 职业描述在运行期是「基础句 + antag 后缀」拼接
			//（" Targetable by contractors." 等），整串不是目录键，但基础句与各后缀短语都在目录里 → 逐段子串命中。
			if(translated == collapsed)
				translated = lang_fallback_apply(collapsed)
			data[key] = translated
	return data

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
	if(base_zh == base_collapsed) // 精确未命中 → 退 AC 子串
		base_zh = lang_fallback_apply(base_collapsed)
	if(desc == base) // 无 opt-in 后缀
		return base_zh
	// desc = base + suffix：后缀短语（" Targetable by contractors." 等）各自在目录 → AC。
	var/suffix = copytext(desc, length(base) + 1)
	return base_zh + lang_fallback_apply(lang_collapse_ws(suffix))

/// 中文时长格式（无英文复数 / 无 " and " 连接词）。core 的 DisplayTimeText 在全服中文时改调此处。
/// 当前为 zh-Hans 用词（天/小时/分钟/秒）——这是唯一非英文 locale；未来加 locale 时在此分支即可。
/// 与 core DisplayTimeText 的分段逻辑一一对应，只换用词与拼接（中文直接连写）。
/proc/lang_display_time_text(time_value, round_seconds_to = 0.1)
	var/second = FLOOR(time_value * 0.1, round_seconds_to)
	if(!second)
		return "就在此刻"
	if(second < 60)
		return "[second]秒"
	var/minute = FLOOR(second / 60, 1)
	second = FLOOR(MODULUS(second, 60), round_seconds_to)
	var/secondT = second ? "[second]秒" : ""
	if(minute < 60)
		return "[minute]分钟[secondT]"
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS(minute, 60)
	var/minuteT = minute ? "[minute]分钟" : ""
	if(hour < 24)
		return "[hour]小时[minuteT][secondT]"
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/hourT = hour ? "[hour]小时" : ""
	return "[day]天[hourT][minuteT][secondT]"

/// 身体部位名的**专用**反查（避开「chest=胸部 vs 储物箱」这类单词全局碰撞——只在部位语境调用）。
/// 当前 zh-Hans 用词；core 的 parse_zone（部位 define→显示名）与 plaintext_zone（部位文本）显示处调用。
/// locale==en 或非部位串 → 原样返回。键含多词部位（与全局目录值一致，无冲突）+ 单词部位（全局不收）。
/proc/lang_zone(zone_text)
	if(!istext(zone_text) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return zone_text
	var/static/list/zmap = list(
		"chest" = "胸部",
		"head" = "头部",
		"groin" = "腹股沟",
		"left arm" = "左臂",
		"right arm" = "右臂",
		"left leg" = "左腿",
		"right leg" = "右腿",
		"left hand" = "左手",
		"right hand" = "右手",
		"left foot" = "左脚",
		"right foot" = "右脚",
		"mouth" = "嘴",
		"eyes" = "眼睛",
	)
	return zmap[zone_text] || zone_text

/// 材料名的**专用**反查（gold/glass/iron… → 中文）。不走全局反查——单词类材料名与日常词碰撞
/// （gold=黄金/金色、glass=玻璃/杯，MT 全局已按错义译），专用映射只在「确知是材料」的显示处调用
/// （examine 的「由…制成」），零碰撞、按材料义翻。未来加 locale 时在此分支扩展。
/proc/lang_material(material_name)
	if(!istext(material_name) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return material_name
	var/static/list/mmap = list(
		"adamantine" = "精金",
		"alien alloy" = "异星合金",
		"alloy" = "合金",
		"bamboo" = "竹",
		"bananium" = "香蕉合金",
		"biomass" = "生物质",
		"bluespace crystal" = "蓝空间晶体",
		"bone" = "骨",
		"bronze" = "青铜",
		"cardboard" = "瓦楞纸板",
		"diamond" = "钻石",
		"glass" = "玻璃",
		"gold" = "黄金",
		"hauntium" = "怨灵金属",
		"hot ice" = "热冰",
		"iron" = "铁",
		"meat" = "肉",
		"Metal Hydrogen" = "金属氢",
		"mythril" = "秘银",
		"paper" = "纸",
		"pizza" = "披萨",
		"plasma" = "等离子体",
		"plasmaglass" = "等离子玻璃",
		"plasteel" = "等离子铁",
		"plastic" = "塑料",
		"plastitanium" = "等离子钛",
		"plastitanium glass" = "等离子钛玻璃",
		"rock" = "岩石",
		"runed metal" = "符文金属",
		"runite" = "符文矿",
		"sand" = "沙子",
		"sandstone" = "砂岩",
		"silver" = "白银",
		"snow" = "雪",
		"telecrystal" = "电讯水晶",
		"titanium" = "钛",
		"titanium glass" = "钛玻璃",
		"uranium" = "铀",
		"wood" = "木材",
		"zaukerite" = "扎克石",
	)
	return mmap[material_name] || material_name

/// 代词的**专用**反查（he/she/it/is/his/him… → 中文）。不走全局反查——it/is/his 等是极常见短词，
/// 全局整串反查会误伤正好等于这些词的动态数据；专用映射只在代词 proc / 模板代词实参处调用，零碰撞。
/// 只覆盖可干净映射的代词与系动词（is/are→是、has/have→有）；语法后缀（does/do/s/es）保持英文。
/// 大小写无关（中文无大小写）：按小写查，命中返回中文、否则原样（含 capitalize 后的英文回退）。
/proc/lang_pronoun(word)
	if(!istext(word) || GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return word
	var/static/list/pmap = list(
		"he" = "他", "she" = "她", "it" = "它", "they" = "他们",
		"him" = "他", "her" = "她", "them" = "他们",
		"his" = "他的", "hers" = "她的", "its" = "它的", "their" = "他们的", "theirs" = "他们的",
		"himself" = "他自己", "herself" = "她自己", "itself" = "它自己", "themselves" = "他们自己",
		"is" = "是", "are" = "是", "has" = "有", "have" = "有", "was" = "是", "were" = "是",
		// 代词缩写（p_theyre()/p_theyve()/p_theyll() 等输出 "it's"/"they're"/"he's"/"they've"…）：
		// 中文模板已含系动词/无需，统一映到**裸代词**（"It's 45cm long" → "它长45厘米"）。
		"it's" = "它", "he's" = "他", "she's" = "她", "they're" = "他们",
		"i'm" = "我", "we're" = "我们", "you're" = "你",
		"they've" = "他们", "i've" = "我", "we've" = "我们", "you've" = "你",
		"it'll" = "它", "they'll" = "他们", "he'll" = "他", "she'll" = "她",
		"it'd" = "它", "they'd" = "他们", "he'd" = "他", "she'd" = "她",
	)
	return pmap[LOWER_TEXT(word)] || word

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

#undef I18N_MAX_EARLY_WARNINGS
