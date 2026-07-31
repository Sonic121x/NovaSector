// NovaSector 全量汉化 (i18n) —— 运行时英→中兜底层（Aho-Corasick）。
//
// 对「尚未被 LANG/LANGU 改写」或「无法静态抽取」的残留英文，在输出边界做一次多模式
// 子串替换。字典两来源：
//   1. 主字典——内存反查表 lang_build_reverse(locale)（即已翻译的 name/desc/message/title 等
//      无占位符整串），**仅取含空格的多词短语**：单词做子串替换会误伤（"Door"→"Doorknob"），
//      单词类名靠源头 lang_reverse_text 整串反查覆盖（见 runtime.dm / 各 New() 反查）。
//   2. 可选人工补充——strings/i18n/<locale>/_fallback.json，扁平 {"english": "中文"}（不受多词
//      过滤限制，人工显式覆盖）。
// 注意：纯子串替换，不保证语序正确，仅用于过渡期与长尾「不漏英文」。已被 LANG 处理过的
// 文本不应再过此层（中文不匹配英文 pattern，天然 no-op，但仍尽量避免二次过）。

#define I18N_FALLBACK_CACHE_MAX 2048
#define I18N_FALLBACK_CACHE_MAX_LENGTH 512

/// locale -> "ready" | "none"，避免重复读盘/重复 setup。
GLOBAL_LIST_EMPTY(i18n_fallback_state)
/// locale -> "ready" | "none"；人工 _fallback 中无空白 pattern 的独立 AC 字典。
GLOBAL_LIST_EMPTY(i18n_fallback_single_state)
/// locale -> (input -> translated)；有界、不淘汰，避免动态串在长局反复挤压缓存。
GLOBAL_LIST_EMPTY(i18n_fallback_cache)
/// 全中文输出不需要进模板引擎或 rust-g AC。
GLOBAL_VAR_INIT(i18n_ascii_letter_regex, regex(@"[A-Za-z]"))

/// 惰性为某 locale 注册 AC 字典；返回是否可用。
/proc/lang_fallback_setup(locale)
	var/state = GLOB.i18n_fallback_state[locale]
	if(state)
		return state == "ready"
	GLOB.i18n_fallback_cache[locale] = list()

	// 主字典：内存反查表里「含空格的多词短语」（单词排除，避免子串误伤）。
	var/list/dict = list()
	var/list/reverse = lang_build_reverse(locale)
	for(var/english in reverse)
		if(!findtext(english, " "))
			continue
		dict[english] = reverse[english]

	// 可选人工补充/覆盖（不受多词过滤限制）。
	var/list/single_patterns = list()
	var/list/single_replacements = list()
	var/path = "[STRING_DIRECTORY]/[I18N_SUBDIRECTORY]/[locale]/_fallback.json"
	if(fexists(path))
		var/list/manual = json_decode(file2text(path))
		if(islist(manual))
			for(var/english in manual)
				dict[english] = manual[english]
				if(!findtext(english, " ") && !findtext(english, "\t") && !findtext(english, "\n"))
					single_patterns += english
					single_replacements += manual[english]

	// **匹配模式必须是 LeftmostLongest**（默认 Standard = 一命中就替换，即最短匹配）。
	// 目录里大量存在「一个词是另一个词前缀」的情况，最短匹配会把长词切坏：
	//   "Security Officer"（安保官）里先命中 "Security Office"（安保办公室，区域名）
	//   → 输出「安保办公室r」，末尾那个 r 就是被切剩的。
	// LeftmostLongest 在同一起点取最长匹配，长词优先，这类前缀冲突全部消失。
	var/static/list/ac_options = list("match_kind" = "LeftmostLongest")

	if(length(single_patterns))
		rustg_setup_acreplace_with_options("i18n_single_[locale]", ac_options, single_patterns, single_replacements)
		GLOB.i18n_fallback_single_state[locale] = "ready"
	else
		GLOB.i18n_fallback_single_state[locale] = "none"

	if(!length(dict))
		GLOB.i18n_fallback_state[locale] = "none"
		return FALSE

	var/list/patterns = list()
	var/list/replacements = list()
	for(var/english in dict)
		patterns += english
		replacements += dict[english]

	rustg_setup_acreplace_with_options("i18n_[locale]", ac_options, patterns, replacements)
	GLOB.i18n_fallback_state[locale] = "ready"
	return TRUE

/// 只缓存有界的完整输入；miss 采集开启时不缓存，保留准确的频次计数。
/proc/lang_fallback_cache_store(locale, source_text, translated_text)
	if(GLOB.i18n_log_misses || length(source_text) > I18N_FALLBACK_CACHE_MAX_LENGTH)
		return translated_text
	var/list/cache = GLOB.i18n_fallback_cache[locale]
	if(!islist(cache))
		cache = list()
		GLOB.i18n_fallback_cache[locale] = cache
	if(length(cache) < I18N_FALLBACK_CACHE_MAX && !(source_text in cache))
		cache[source_text] = translated_text
	return translated_text

/// 对一段文本应用兜底替换。locale 为 null 时用全服 locale；缺省 locale（英文）直接返回。
/proc/lang_fallback_apply(text, locale)
	if(!istext(text) || !length(text))
		return text
	if(isnull(locale))
		locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale == DEFAULT_UI_LOCALE)
		return text
	if(!lang_fallback_setup(locale))
		return text
	var/source_text = text
	var/list/cache = GLOB.i18n_fallback_cache[locale]
	if(!GLOB.i18n_log_misses && length(text) <= I18N_FALLBACK_CACHE_MAX_LENGTH && islist(cache) && (text in cache))
		return cache[text]
	// 剥掉 BYOND 文本宏 \improper / \proper（0xFF 起头的控制字节）：rustg_acreplace 按 UTF-8
	// 处理字符串，这些非 UTF-8 字节会被替换成 U+FFFD（显示为 ��，如「那是 ��space」）。中文无
	// 大小写，这两个宏（控制后随单词首字母大小写）本就无意义 → 直接剥除。findtext 门控让无宏的
	// 热路径（绝大多数聊天行）零额外开销。
	if(findtext(text, "\improper") || findtext(text, "\proper"))
		text = replacetext(text, "\improper ", "")
		text = replacetext(text, "\proper ", "")
		text = replacetext(text, "\improper", "")
		text = replacetext(text, "\proper", "")
	// 无拉丁字母的已译输出直接返回，避免跨 FFI 创建新字符串。
	var/regex/ascii_letter_regex = GLOB.i18n_ascii_letter_regex
	if(!ascii_letter_regex.Find(text))
		return lang_fallback_cache_store(locale, source_text, text)
	var/has_word_separator = findtext(text, " ") || findtext(text, "\t") || findtext(text, "\n")
	// 模板锚和主字典都是多词 pattern；无空白输入只跑人工单词字典。
	// _fallback.json 新增无空白条目会在 setup 时自动进该字典，无需改代码。
	if(!has_word_separator)
		if(GLOB.i18n_fallback_single_state[locale] == "ready")
			text = rustg_acreplace("i18n_single_[locale]", text)
		return lang_fallback_cache_store(locale, source_text, text)
	// 先过模板逆匹配（插值句：目录里已译的 {0} 模板按字面段在原文上命中、捕获实参反查后按
	// zh 模板重排填充，见 template_match.dm），再过字面 AC 收剩余短语。
	text = lang_template_apply(text, locale)
	text = rustg_acreplace("i18n_[locale]", text)
	// 漏翻采集：所有层过完仍残留的多词英文 run（config I18N_LOG_MISSES 门控，见 miss_log.dm）。
	if(GLOB.i18n_log_misses)
		lang_log_miss_scan(text, "fallback")
	return lang_fallback_cache_store(locale, source_text, text)

#undef I18N_FALLBACK_CACHE_MAX
#undef I18N_FALLBACK_CACHE_MAX_LENGTH
