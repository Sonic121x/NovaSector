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

/// 唯一串数量上限：达到后停止整个扫描，避免继续为正则/分词分配临时 list。
#define I18N_MISS_MAX_UNIQUE 4096
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
		if(length(counts) >= I18N_MISS_MAX_UNIQUE)
			return
		counts[text] = 1
		// **首次记录带上整行**：只记英文 run 的话，`The wolf` 这样的片段完全指不出调用点，
		// 排查得靠在源码里 grep 猜（实测为了定位一条 `The mi-go` 翻遍了 emote/say/attack 三条链）。
		// 整行里那些已经翻好的中文正是最强的线索——一眼就能认出是哪句话。
		// 只在首次记，后续 10/100/1000 那几条仍只记 run：整行往往很长，全记会把日志撑爆。
		WRITE_LOG("[GLOB.log_directory]/i18n_misses.log", "n=1 src=[source] | [text][context ? " || 整行: [context]" : ""]")
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

/// fallback 层出口扫描：对（已过模板引擎 + AC 的）文本提取残留英文 run 并记录。
/proc/lang_log_miss_scan(text, source)
	if(length(GLOB.i18n_miss_counts) >= I18N_MISS_MAX_UNIQUE)
		return
	// 有效 run 至少有两个词；无任何分隔符时避免 regex.Replace + splittext 分配。
	if(!istext(text) || (!findtext(text, " ") && !findtext(text, "\t") && !findtext(text, "\n")))
		return
	// 整行做上下文：剥掉标签与多余空白，截断到可读长度（日志一行装得下、又足够认出是哪句话）。
	var/regex/tag_regex = GLOB.i18n_miss_tag_regex
	var/context = trim(tag_regex.Replace(text, " "))
	if(length(context) > I18N_MISS_CONTEXT_LENGTH)
		context = copytext(context, 1, I18N_MISS_CONTEXT_LENGTH) + "…"
	for(var/run in lang_i18n_extract_runs(text))
		lang_log_miss(run, source, context)

#undef I18N_TOKEN_WORD
#undef I18N_TOKEN_NEUTRAL
#undef I18N_TOKEN_BREAK
#undef I18N_MISS_MAX_UNIQUE
#undef I18N_MISS_MAX_LENGTH
#undef I18N_MISS_CONTEXT_LENGTH
