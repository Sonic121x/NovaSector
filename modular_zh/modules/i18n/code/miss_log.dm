// NovaSector 全量汉化 (i18n) —— 运行期漏翻采集器（miss logger）。
//
// 目的：把「汉化不完靠玩家截图上报」变成「日志自动收割」。全服 locale≠en 且 config
// I18N_LOG_MISSES 开启时，在两个输出边界记录**经过所有翻译层后仍是英文**的多词串：
//   1. lang_fallback_apply 出口（browse/状态栏/公告/maptext/聊天兜底）——模板引擎 + AC
//      替换后残留的连续拉丁词 run；
//   2. lang_reverse_phrase_tgui 的 miss 分支——整串反查 + 模板引擎都没命中的 TGUI 负载值。
// 产出 [log_directory]/i18n_misses.log，去重计数（首次 + 10/100/1000 次时各写一行）；收满上限后停止扫描。
// 离线聚合与归类（在目录=路径没接通 / 不在目录=没进抽取）见 tools/i18n/miss-scan.mjs。
//
// 噪音控制：run 需 ≥3 个拉丁词（或 2 词且含小写开头词——放行 "toggle safety" 类短语、
// 挡掉 "John Smith" 类人名）；单条 ≤240 字符；唯一串数量封顶防内存膨胀。玩家自己输入的
// 聊天本就不过 fallback 层（skip_i18n_fallback / i18n_player_chat_types），不会被记录。

/// 是否启用漏翻采集（默认关）。config I18N_LOG_MISSES 控制（见 config_entries.dm）。
GLOBAL_VAR_INIT(i18n_log_misses, FALSE)

/// 已记录串 -> 出现次数。运行期只增，round 结束随进程回收。
GLOBAL_LIST_EMPTY(i18n_miss_counts)

// 唯一串数量**不设上限**。这是采集工具、不是运行期功能（config I18N_LOG_MISSES 默认关，
// 只在 miss-harvest / 专门开一局采数据时打开），截断带来的唯一后果是「条数不再增长」——
// 而那与「真的采干净了」表现完全一样，是一种会让后续所有分析静默失真的假象。
// 采一轮的量级是几百到几千条去重串，内存代价可以忽略。
/// 单条记录最大长度：更长的多为玩家书写/超长拼接，截断意义不大，直接跳过。
#define I18N_MISS_MAX_LENGTH 240
/// 首次记录时附带的「整行上下文」最大长度。
#define I18N_MISS_CONTEXT_LENGTH 200
// token 分类（lang_i18n_token_kind 返回值）
#define I18N_TOKEN_WORD 1
#define I18N_TOKEN_NEUTRAL 2
#define I18N_TOKEN_BREAK 3

/// 记录一条 miss（去重计数；首次与 10/100/1000 次时写日志行）。
/proc/lang_log_miss(text, source, context)
	if(!istext(text) || length(text) > I18N_MISS_MAX_LENGTH)
		return
	var/list/counts = GLOB.i18n_miss_counts
	var/n = counts[text]
	if(isnull(n))
		counts[text] = 1
		// **首次记录带上整行**：只记英文 run 的话，`The wolf` 这样的片段完全指不出调用点，
		// 排查得靠在源码里 grep 猜（实测为了定位一条 `The mi-go` 翻遍了 emote/say/attack 三条链）。
		// 整行里那些已经翻好的中文正是最强的线索——一眼就能认出是哪句话。
		// 只在首次记，后续 10/100/1000 那几条仍只记 run：整行往往很长，全记会把日志撑爆。
		// 上下文用 ` || ` 分隔，**离线端必须把它切掉再拿 text 去查目录** —— 否则 n=1 那行的键
		// 带着上下文，与目录永远对不上，整批首次记录会被误判成「没进目录」（miss-scan.mjs 守这条）。
		WRITE_LOG("[GLOB.log_directory]/i18n_misses.log", "n=1 src=[source] | [text][context ? " || [context]" : ""]")
		return
	n++
	counts[text] = n
	if(n == 10 || n == 100 || n == 1000)
		WRITE_LOG("[GLOB.log_directory]/i18n_misses.log", "n=[n] src=[source] | [text]")

/// 剥 HTML 标签/实体用（fallback 层文本常是 HTML 片段）。
GLOBAL_VAR_INIT(i18n_miss_tag_regex, regex(@"<[^>]*>|&[#A-Za-z0-9]+;", "g"))

/// 从一段（可能含 HTML/中英混排的）文本提取「连续拉丁词 run」列表。纯函数，单测覆盖。
/// run 判定：≥3 个拉丁词，或恰 2 词且至少一词以小写字母开头；纯数字/标点 token 允许
/// 出现在 run 内部（不计词数、不留边缘）；含 CJK 或其它非拉丁字符的 token 打断 run。
/proc/lang_i18n_extract_runs(text)
	var/list/runs = list()
	if(!istext(text) || !length(text))
		return runs
	var/regex/tag_re = GLOB.i18n_miss_tag_regex
	text = tag_re.Replace(text, " ")
	text = replacetext(replacetext(text, "\n", " "), "\t", " ")
	var/list/tokens = splittext(text, " ")
	// 当前 run 的累积状态
	var/list/run_tokens = list()
	var/word_count = 0
	var/last_word_index = 0 // run_tokens 里最后一个「词」的位置（用于去掉尾部数字/标点）
	var/has_lower_start = FALSE
	for(var/token in tokens)
		var/kind = lang_i18n_token_kind(token)
		if(kind == I18N_TOKEN_WORD)
			run_tokens += token
			word_count++
			last_word_index = length(run_tokens)
			if(text2ascii(token) >= 97 && text2ascii(token) <= 122)
				has_lower_start = TRUE
			continue
		if(kind == I18N_TOKEN_NEUTRAL && word_count) // run 内部的数字/标点，边缘不收
			run_tokens += token
			continue
		// 断点（CJK/空 token/run 未开始的 neutral）：结算当前 run
		lang_i18n_flush_run(runs, run_tokens, word_count, last_word_index, has_lower_start)
		run_tokens = list()
		word_count = 0
		last_word_index = 0
		has_lower_start = FALSE
	lang_i18n_flush_run(runs, run_tokens, word_count, last_word_index, has_lower_start)
	return runs

/// token 分类：拉丁词（可含数字/'/-/尾随标点）/ 中性（纯数字标点）/ 断点（CJK、其它字符、空）。
/proc/lang_i18n_token_kind(token)
	var/len = length(token)
	if(!len)
		return I18N_TOKEN_BREAK
	var/has_alpha = FALSE
	for(var/i in 1 to len)
		var/ch = text2ascii(token, i)
		if(ch > 127) // 非 ASCII（CJK/重音等）一律断
			return I18N_TOKEN_BREAK
		if((ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122))
			has_alpha = TRUE
			continue
		if(ch >= 48 && ch <= 57)
			continue
		switch(ch)
			// 词内/句尾常见符号：' - . , ! ? ; : " ( ) %
			if(39, 45, 46, 44, 33, 63, 59, 58, 34, 40, 41, 37)
				continue
			else
				return I18N_TOKEN_BREAK
	return has_alpha ? I18N_TOKEN_WORD : I18N_TOKEN_NEUTRAL

/// 结算一个 run：去尾部中性 token，按词数门槛决定是否收进 runs。
/proc/lang_i18n_flush_run(list/runs, list/run_tokens, word_count, last_word_index, has_lower_start)
	if(!word_count || !last_word_index)
		return
	if(word_count < 3 && !(word_count == 2 && has_lower_start))
		return
	var/list/trimmed = run_tokens.Copy(1, last_word_index + 1)
	runs += jointext(trimmed, " ")

/// **定点边界**的漏翻采集：与 lang_log_miss_scan 相对。
///
/// 两者的区别是「传进来的是什么」，因此闸门完全不同：
///   · `lang_log_miss_scan` 收的是**整行渲染文本**（聊天/浏览器/公告），里面混着已译中文、玩家
///     自己打的字、人名、数字，所以必须先抽「连续拉丁词 run」再按多词门槛过滤 —— 否则日志会被
///     人名和界面碎片淹掉。代价是**单词漏翻整类看不见**。
///   · 这个收的是**一个语义单元的完整值**（一个 name、一个 LANG 实参、一个模板捕获值）。调用点
///     已经确定了「这就是一段该被翻译的显示文本」，所以不抽 run、不设多词门槛 —— 而现在剩下的
///     主要缺口恰恰是单词名（显示边界的 `wrench`/`beaker`、LANG 实参里的状态词），旧采集器结构
///     性地看不到它们，于是「采集结果很干净」是假象。
///
/// 闸门只挡**形态上不可能是文案**的值：标识符（含 `_` 或 `/`、全大写常量）、无字母串、含 CJK
/// （已经译了）、超长（玩家书写）。单词小写名一律放行 —— 那正是要看的那一类。
/// `origin` 是调用点能提供的最强线索（显示边界给 `src.type`），直接决定该往哪张表补。
/proc/lang_log_miss_value(text, source, origin)
	if(!GLOB.i18n_log_misses || !istext(text))
		return
	var/length_of_text = length(text)
	if(length_of_text < 2 || length_of_text > I18N_MISS_MAX_LENGTH)
		return
	if(!lang_miss_value_candidate(text))
		return
	lang_log_miss(text, source, origin ? "来源: [origin]" : null)

/// 「这个值有没有可能是玩家可见文案」的形态判据。见 lang_log_miss_value。
/proc/lang_miss_value_candidate(text)
	var/has_alpha = FALSE
	var/has_lower = FALSE
	var/length_of_text = length(text)
	for(var/i in 1 to length_of_text)
		var/ch = text2ascii(text, i)
		if(ch > 127) // 非 ASCII：含 CJK/重音 → 要么已经译了，要么不是英文文案
			return FALSE
		if(ch >= 97 && ch <= 122)
			has_alpha = TRUE
			has_lower = TRUE
			continue
		if(ch >= 65 && ch <= 90)
			has_alpha = TRUE
			continue
		switch(ch)
			// 标识符特征：下划线、斜杠（类型路径）、`#`（ref）、`=`（属性串）
			if(95, 47, 35, 61)
				return FALSE
			else
				continue
	if(!has_alpha)
		return FALSE
	// 全大写且无空格：`SOUTH`/`CENTCOM`/`BB_EMOTE_SAY` 展开后那类常量。多词全大写标题
	// （"CRYSTAL DELAMINATION IMMINENT"）含空格，仍然收。
	if(!has_lower && !findtext(text, " "))
		return FALSE
	return TRUE

/// fallback 层出口扫描：对（已过模板引擎 + AC 的）文本提取残留英文 run 并记录。
/proc/lang_log_miss_scan(text, source)
	// 有效 run 至少有两个词；无任何分隔符时避免 regex.Replace + splittext 分配。
	if(!istext(text) || (!findtext(text, " ") && !findtext(text, "\t") && !findtext(text, "\n")))
		return
	// 整行做上下文：剥掉标签与多余空白，截断到可读长度（日志一行装得下、又足够认出是哪句话）。
	var/regex/tag_regex = GLOB.i18n_miss_tag_regex
	var/context = trim(tag_regex.Replace(text, " "))
	if(length(context) > I18N_MISS_CONTEXT_LENGTH)
		context = copytext(context, 1, I18N_MISS_CONTEXT_LENGTH) + "…"
	for(var/run in lang_i18n_extract_runs(text))
		lang_log_miss(run, source, "整行: [context]")

#undef I18N_TOKEN_WORD
#undef I18N_TOKEN_NEUTRAL
#undef I18N_TOKEN_BREAK
#undef I18N_MISS_MAX_LENGTH
#undef I18N_MISS_CONTEXT_LENGTH
