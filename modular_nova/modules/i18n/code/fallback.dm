// NovaSector 全量汉化 (i18n) —— 运行时英→中兜底层（Aho-Corasick）。
//
// 对「尚未被 LANG/LANGU 改写」或「无法静态抽取」的残留英文，在输出边界做一次多模式
// 子串替换。字典两来源：
//   1. 主字典——内存反查表 lang_build_reverse(locale)（即已翻译的 name/desc/message/title 等
//      无占位符整串），**仅取含空格的多词短语**：单词做子串替换会误伤（"Door"→"Doorknob"），
//      单词类名靠 examine/hover/TGUI 等显示边界调用 lang_reverse_text 精确反查覆盖（见 runtime.dm）。
//   2. 可选人工补充——strings/i18n/<locale>/_fallback.json，扁平 {"english": "中文"}（不受多词
//      过滤限制，人工显式覆盖）。
// 注意：纯子串替换，不保证语序正确，仅用于过渡期与长尾「不漏英文」。已被 LANG 处理过的
// 文本不应再过此层（中文不匹配英文 pattern，天然 no-op，但仍尽量避免二次过）。

#define I18N_FALLBACK_CACHE_MAX 2048
#define I18N_FALLBACK_CACHE_MAX_LENGTH 512
/// 「跨内联标签整段查表」前置 pass 的输入上限：聊天行/检查行量级。浏览器整页不走这条路。
#define I18N_INLINE_RUN_MAX_LENGTH 2048

/// locale -> "ready" | "none"，避免重复读盘/重复 setup。
GLOBAL_LIST_EMPTY(i18n_fallback_state)
/// locale -> "ready" | "none"；人工 _fallback 中无空白 pattern 的独立 AC 字典。
GLOBAL_LIST_EMPTY(i18n_fallback_single_state)
/// locale -> (input -> translated)；有界、不淘汰，避免动态串在长局反复挤压缓存。
GLOBAL_LIST_EMPTY(i18n_fallback_cache)
/// 全中文输出不需要进模板引擎或 rust-g AC。
GLOBAL_VAR_INIT(i18n_ascii_letter_regex, regex(@"[A-Za-z]"))

/// 拼句碎片作为 **AC 子串 pattern** 的黑名单虚词。整句可以用它们开头（"The door is locked."），
/// 但一条不带句末标点的短短语若以虚词起/收，几乎必然是 `. += "…" + " and " + "…"` 这类拼句
/// 碎片，而不是一个完整的显示串。
GLOBAL_LIST_INIT(i18n_fallback_stopwords, list(
	"a", "an", "the", "and", "or", "of", "in", "on", "at", "to", "is", "are",
	"was", "were", "be", "by", "for", "with", "from", "as", "it", "its",
	"one", "no", "not", "but", "that", "this", "their", "his", "her",
	// 代词 + 情态/助动词。少了这批，`"You can"→"你可以"` 这种**没有句末标点的两词碎片**会进 AC 字典，
	// 然后在任意句子中间开火：`You can|'t stop me, Owl!` → 「你可以't stop me, Owl!」。
	// 判据同上：碎片留在目录里供各自调用点精确查表，只是不再获得在任意文本上开火的权力。
	"you", "your", "yours", "i", "we", "our", "they", "them", "he", "she", "him",
	"can", "cant", "will", "wont", "would", "could", "should", "shall", "may",
	"might", "must", "do", "does", "did", "done", "have", "has", "had", "am",
	"been", "being", "get", "gets", "got", "let", "lets", "make", "makes",
	"if", "when", "while", "then", "there", "here", "what", "which", "who",
	"how", "why", "all", "any", "some", "more", "most", "very", "just", "also",
	"too", "so", "such", "about", "into", "onto", "out", "up", "down", "off", "over",
))

/// 某条已译目录项能否进**字面 AC 子串字典**。
///
/// 反查表喂给两条完全不同的路：`lang_reverse_text` 的**整串精确**反查（碎片在那里无害——只有
/// 整个字符串等于它才命中），和这里的**子串替换**（碎片会在任意句子中间开火）。两条路共用一张
/// 表，是「玩家看到半句乱码」的结构性来源，且比不翻译严重得多：
///   · `"one of"→"其中一只"`（目录里一条**没有调用点**的悬空项）把 `But n|one of| its eggs
///     hatched!` 从单词中间切开 → 「But n其中一只 its eggs hatched!」；
///   · `" and "→" 和 "`（carbon_examine 的伤情拼句碎片）让整段 NPC 检查文本变成
///     「…on the console 和 he is constantly twitching…」。
/// rustg 的 AC 没有词边界概念，LeftmostLongest 只解决「同起点取最长」，管不了「起点落在单词
/// 内部」。所以闸门必须设在**建字典这一步**：碎片继续留在目录里供各自调用点精确查表，只是
/// 不再获得在任意文本上开火的权力。
/proc/lang_fallback_pattern_safe(english)
	// 去掉首尾空白后仍须是多词短语。`" and "` / `"and "` 这种「靠 padding 才含空格」的单词
	// 碎片，正是 findtext(english, " ") 这条旧闸门唯一漏掉的形状。
	var/trimmed = trim(english)
	if(!findtext(trimmed, " "))
		return FALSE
	// 整句（有句末标点）一律放行：它们不会成为更长单词的一部分。
	var/last_character = copytext(trimmed, length(trimmed))
	if(findtext(".!?:;\"')", last_character))
		return TRUE
	var/list/words = splittext(trimmed, " ")
	if(length(words) > 3)
		return TRUE
	var/list/stopwords = GLOB.i18n_fallback_stopwords
	if((LOWER_TEXT(words[1]) in stopwords) || (LOWER_TEXT(words[length(words)]) in stopwords))
		return FALSE
	return TRUE

/// AC 字典的早调用告警计数（与 lang_reverse_text 那个哨兵同源，上限同一个 define）。
GLOBAL_VAR_INIT(i18n_fallback_early_warnings, 0)

/// 惰性为某 locale 注册 AC 字典；返回是否可用。
/proc/lang_fallback_setup(locale)
	var/state = GLOB.i18n_fallback_state[locale]
	if(state)
		return state == "ready"
	GLOB.i18n_fallback_cache[locale] = list()

	// **i18n_cache 未就绪时必须直接退出、且不写 state**。`lang_build_reverse` 在那种情况下
	// 特意「返回空表但不缓存」（免得把空反查表钉死），可这里拿到空表会一路走到下面把 state 钉成
	// "none" —— 那是**永久**的：`lang_fallback_setup` 此后一律返回 FALSE，整局的字面 AC 层
	// 无声关闭。同一个「别把未就绪状态缓存起来」的道理，上一层做了、这一层漏了。
	if(!islist(GLOB.i18n_cache[DEFAULT_UI_LOCALE]) || !islist(GLOB.i18n_cache[locale]))
		// **静默失败在这里是最坏的形态**：AC 层不跑、文本原样返回、玩家看到英文，而日志上
		// 只表现为「某几条串没翻」——与「目录里没这条」长得一模一样，查起来会一路查到目录去。
		// 拿真目录写的四条断言全过而线上照漏，就是被这个形态骗了一轮。把调用点打出来。
		if(GLOB.i18n_fallback_early_warnings < I18N_MAX_EARLY_WARNINGS)
			GLOB.i18n_fallback_early_warnings++
			stack_trace("i18n: lang_fallback_setup([locale]) 在目录就绪前被调用——本次字面 AC 层不跑，该文本会原样留英文。若这是启动期的某个渲染点，它应改到 SS Initialize 之后，或改走 LANG。")
		return FALSE

	// 主字典：内存反查表里「含空格的多词短语」（单词排除，避免子串误伤）。
	var/list/dict = list()
	var/list/reverse = lang_build_reverse(locale)
	for(var/english in reverse)
		if(!lang_fallback_pattern_safe(english))
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
/// 三条落地链共用的核心：**整串精确 → 模板逆匹配 → 字面 AC**，按 scope 决定放行到哪一层。
///
/// 从前聊天、TGUI 负载（P1）、显示边界各写了一遍这个顺序，于是：
///   · 顺序只在一处修对过（「整串精确必须排在模板之前」那条，其余两处曾各自被泛化骨架模板劫持）；
///   · 聊天链手写的精确查表只看 exact 表，归一表那批键在聊天路径上永远查不到（本次实测抓到）。
/// 现在顺序只有这一处，三个调用点只是传不同的 scope。
///
/// `ac_mode`：
///   · `I18N_AC_NONE`  —— 不过字面 AC。显示边界用这个：名字要么整串命中、要么是「区域名 + 类型名」
///     那种可拆的合成名（各自精确翻），子串替换在这里只会带来误伤（AC 无词边界概念）。
///   · `I18N_AC_PROSE` —— 只有长散文（≥80 字符且有句末标点）才过 AC。TGUI 负载用这个：
///     act() 回传标识符、图标名、黑板键永远不是这个形状。
///   · `I18N_AC_FULL`  —— 聊天/浏览器用这个：整行文本本来就是散文。
/proc/lang_localize_chain(text, locale, allow_template, ac_mode)
	. = lang_reverse_text_in(text, locale)
	if(. != text)
		return
	// 整串 miss 之后、模板之前：**剥掉英文冠词再精确查一次**。
	//
	// BYOND 对非专有名词自动补 "The"/"a"（`"[atom]"` 的渲染），于是名字到达落地层时是
	// `The mi-go`、`a wrench` —— 整串不是目录键，而剥掉冠词的余下部分早就在目录里。
	// 从前只有 `lang_localize_arg` 和聊天的 name-span 分支各自做了这件事，于是「名字独立成块、
	// 但包在 name span 以外的标签里」（`<b>[src]</b>` 那类）整块落不了地：实测 `The mi-go` /
	// `The alien runner` 各 100 次打满计数，判据是漏翻记录里**片段与整块逐字节相同**。
	// 与其继续猜是哪个标签，不如把这条并进共用链 —— 它要求**余下部分整串精确命中目录**，
	// 比模板逆匹配和字面 AC 都保守，放在这个位置不会抢走任何更具体的证据。中文无冠词，丢掉即可。
	var/stripped = lang_strip_article(text)
	if(stripped)
		. = lang_reverse_text_in(stripped, locale)
		if(. != stripped)
			return
		. = text
	// 模板命中**不再提前返回**（只在 AC 不跑的两个 scope 下直接返回）。
	//
	// 一整行里可以既有「带占位符的模板」又有「纯串」：职业描述的 antag opt-in 段就是三段后缀
	// 拼在一起——第一段 `" Forces a minimum of {0} antag opt-in."` 是模板、后两段
	// `" Targetable by contractors."` / `" Targetable by heretics."` 是纯串。模板命中就返回，
	// 后两段永远轮不到 AC，玩家看到「第一段中文、后两段英文」。
	// 已翻好的中文部分不含拉丁字母，AC 不会再碰它；剩下的英文正是该它管的。
	var/templated = FALSE
	if(allow_template)
		var/after_template = lang_template_apply(text, locale)
		if(after_template != text)
			text = after_template
			templated = TRUE
	if(ac_mode == I18N_AC_NONE)
		return text
	if(ac_mode == I18N_AC_PROSE && !lang_tgui_prose_candidate(text))
		return text
	if(!lang_fallback_setup(locale))
		return text
	. = rustg_acreplace("i18n_[locale]", text)
	// AC 一无所获时把模板那一步的成果原样交出去（`.` 与 text 此刻相同，写清楚免得读者以为丢了）。
	return templated || . != text ? . : text

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
	// 整串精确 → 模板逆匹配 → 字面 AC，顺序由 lang_localize_chain 统一定义。
	// **整串精确必须排在模板之前**：目录里若正好有这一整句，它是最具体的证据。否则先跑的模板
	// 引擎会被泛化骨架劫持——`It appears to {0}`、`{0} produces a {1}.` 这类三两个词的模板会
	// 吞掉任意同形句子，把捕获到的英文原样塞回中文脚手架（「它看起来像be completely inactive.」）。
	text = lang_localize_chain(text, locale, allow_template = TRUE, ac_mode = I18N_AC_FULL)
	// 漏翻采集：所有层过完仍残留的多词英文 run（config I18N_LOG_MISSES 门控，见 miss_log.dm）。
	if(GLOB.i18n_log_misses)
		lang_log_miss_scan(text, "fallback")
	return lang_fallback_cache_store(locale, source_text, text)

/// `<span class='name'>` 里那一整块的本地化。只做**整串精确**反查（外加剥冠词后再试一次），
/// 不过模板引擎、不过字面 AC：这里的内容要么是类型标签（该翻），要么是玩家角色名（绝不能碰），
/// 子串替换在这么短的串上只有误伤。名字到达这里时常常已经带了 BYOND 自动补的冠词
/// （`get_voice()` 返回 `"[src]"`，引擎对非专名补 "The"）—— 而玩家角色名是专名、永不带冠词，
/// 所以「带冠词」本身就证明了它不是身份名。
/proc/lang_localize_name_chunk(text, locale)
	if(!istext(text) || !length(text) || locale == DEFAULT_UI_LOCALE)
		return text
	. = lang_reverse_text_in(text, locale)
	if(. != text)
		return
	var/stripped = lang_strip_article(text)
	if(!stripped)
		return text
	. = lang_reverse_text_in(stripped, locale)
	if(. != stripped)
		return
	// 漏翻采集：聊天里的说话者/emote 名字整块没翻。单词名（wolf/animal）在这里最常见，
	// 而 run 采集器的多词门槛正好把它们全挡了 —— 这一类只有在这里才看得见。
	lang_log_miss_value(text, "namespan")
	return text

/// Finds the closing `>` for an HTML tag without treating a quoted `>` as the end of the tag.
///
/// PERF：原实现按**字节**推进（`copytext(html, i, i+1)` 每字节分配一个新字符串），而本 proc 是
/// `lang_fallback_apply_html` 的内循环——每条 to_chat、每个浏览器页面的**每一个标签**都要跑一遍，
/// 且跑两遍（内联 run 前置 pass + 切块器各一次）。记录台/健康扫描那种几十 KB、上千标签的页面，
/// 光这里就是几十万次字符串分配。改成用 findtext 直接跳到下一个 `>` / 引号：native 扫描、
/// 每个标签常数次调用，逐字节行为等价（引号内的 `>` 仍不算结束）。
/proc/lang_html_tag_end(html, tag_start)
	var/index = tag_start + 1
	while(TRUE)
		var/close = findtext(html, ">", index)
		if(!close)
			return
		// 取 `>` 之前最早出现的引号；没有（或在 `>` 之后）说明这个 `>` 就是标签结束。
		var/single_quote = findtext(html, "'", index)
		var/double_quote = findtext(html, "\"", index)
		var/quote_at
		if(single_quote && (!double_quote || single_quote < double_quote))
			quote_at = single_quote
		else
			quote_at = double_quote
		if(!quote_at || quote_at > close)
			return close
		// 引号先开：整段引号内容跳过（属性值里的 `>` 不是标签结束）。
		var/quote_end = findtext(html, copytext(html, quote_at, quote_at + 1), quote_at + 1)
		if(!quote_end)
			return
		index = quote_end + 1

/// 标签名允许的字符集，喂给 native 的 spantext（见下）。
#define I18N_TAG_NAME_CHARS "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
#define I18N_TAG_LEAD_WHITESPACE " \t\n"

/// Returns the name of an HTML raw-text element whose body must never be localized.
///
/// PERF：同 lang_html_tag_end——原实现逐字节 `copytext` 扫名字。`spantext(串, 字符集, 起点)`
/// 是 native 的「从起点开始有多少个连续字符属于该集合」，一次调用顶掉整个循环，零中间分配。
/proc/lang_html_raw_text_tag_name(tag)
	var/index = 2 + spantext(tag, I18N_TAG_LEAD_WHITESPACE, 2)
	var/first_character = copytext(tag, index, index + 1)
	if(first_character == "/" || first_character == "!" || first_character == "?")
		return
	var/name_end = index + spantext(tag, I18N_TAG_NAME_CHARS, index)
	var/tag_name = LOWER_TEXT(copytext(tag, index, name_end))
	switch(tag_name)
		if("script", "style", "textarea")
			return tag_name

/// 「纯排版」内联标签：夹在句子中间、不打断一句话的那些。用于把被它们切开的文本重新连成整句
/// 再查表（见 lang_localize_inline_runs）。`a` 不在内，链接文本常是独立的可点标识符。
GLOBAL_LIST_INIT(i18n_inline_tags, list(
	"b", "i", "u", "em", "strong", "span", "font", "small", "big", "sub", "sup",
))

/// 取标签名与「是否闭合标签」。`<b>`→("b", FALSE)，`</b>`→("b", TRUE)，`<br/>`→("br", FALSE)。
/proc/lang_html_tag_parts(tag)
	var/index = 2
	var/closing = FALSE
	if(copytext(tag, index, index + 1) == "/")
		closing = TRUE
		index++
	var/name_end = index + spantext(tag, I18N_TAG_NAME_CHARS, index) // PERF: native 扫名字，见 lang_html_raw_text_tag_name
	return list(LOWER_TEXT(copytext(tag, index, name_end)), closing)

/// 目录键里**夹着内联标签**的整句，切块后两半都查不到。
///
/// `lang_fallback_apply_html` 按标签切块、只把标签之间的纯文本送去查表，而目录键是照抄源码
/// 字面量的，标签就嵌在句子中间：
///   `examine_text = "There is a sticker displaying the <b>Chief Engineer's SEAL OF APPROVAL.</b>"`
/// 切出来是 "There is a sticker displaying the " 和 "Chief Engineer's SEAL OF APPROVAL." 两个
/// 半句，谁都不是目录键 → 整句回退英文，还会被字面 AC 只咬中间那个职业名（玩家看到的
/// 「There is a sticker displaying the 总工程师's SEAL OF APPROVAL」就是这么来的）。
///
/// 这里先做一遍「跨内联标签把整段文本连起来、整段精确查表」。命中就整段换成译文（内联排版
/// 随之丢失——一句完整译文远比一个加粗重要）；**没命中则原样交还给切块器**，行为与从前逐字节
/// 一致，所以这道前置 pass 不会引入新的误翻面。
/// depth 用来保证 run 不会跨出它所在的元素：闭合一个 run 之前就已打开的标签（如外层
/// `<span class='notice'>` 的 `</span>`）时，run 到此为止，外层标签仍由切块器原样输出。
/// 一段 run 的整段查表。命中返回译文；不该查或查不到返回 null（调用方原样保留）。
/// 只查**含内联标签且标签配平**的多词整段——单词段与不配平段交还切块器，避免新增误翻面。
/proc/lang_inline_run_lookup(run_text, saw_inline_tag, depth, locale)
	if(!saw_inline_tag || depth || !length(run_text))
		return null
	var/stripped = lang_strip_html_tags(run_text)
	if(!length(stripped) || !findtext(stripped, " "))
		return null
	// 走 lang_reverse_text_in 而不是直接索引 exact 表：归一表（剥标签/剥宏/大小写…）也要能命中，
	// 否则「目录键里嵌着标签、运行期送来的是裸句」那一类在这条前置 pass 上照样查不到。
	var/hit = lang_reverse_text_in(stripped, locale)
	return hit == stripped ? null : hit

/proc/lang_localize_inline_runs(html, locale)
	var/list/reverse = GLOB.i18n_reverse[locale] || lang_build_reverse(locale)
	if(!length(reverse))
		return null
	var/list/output = list()
	var/html_length = length(html)
	var/cursor = 1
	var/run_start = 1
	var/depth = 0
	var/saw_inline_tag = FALSE
	var/changed = FALSE

	while(cursor <= html_length)
		var/tag_start = findtext(html, "<", cursor)
		if(!tag_start)
			break
		var/tag_end = lang_html_tag_end(html, tag_start)
		if(!tag_end)
			break
		var/tag = copytext(html, tag_start, tag_end + 1)
		var/list/parts = lang_html_tag_parts(tag)
		var/tag_name = parts[1]
		var/closing = parts[2]
		var/breaks_run = TRUE
		if(tag_name in GLOB.i18n_inline_tags)
			// run 必须是某个元素的**内容**，不能跨过该元素自己的边界标签，否则整条替换会把外层
			// `<span class='notice'>…</span>` 一起吃掉、聊天配色全丢（i18n_html_tag_keys 抓的就是这个）。
			// 判据：run 至今还没有任何非空白文本时遇到的**开标签**，属于外壳而不是句子的一部分
			// —— 让它成为边界、run 从它之后重新开始；这样它的闭合标签也会在 depth==0 时收尾。
			// 已经有文本之后遇到的开标签才是句中排版（`… the <b>SEAL</b>`），吸收进 run。
			if(!closing)
				// PERF：只需判断「run 至今有没有非空白文本」，原写法为此切一份子串再 trim 一份
				// （每条聊天行的每个内联开标签两次分配）。spantext 直接在原串上数空白，无分配。
				if(run_start + spantext(html, I18N_TAG_LEAD_WHITESPACE, run_start) < tag_start)
					depth++
					saw_inline_tag = TRUE
					breaks_run = FALSE
			else if(depth)
				depth--
				saw_inline_tag = TRUE
				breaks_run = FALSE
		if(breaks_run)
			var/run_text = copytext(html, run_start, tag_start)
			var/translated = lang_inline_run_lookup(run_text, saw_inline_tag, depth, locale)
			if(translated)
				output += translated
				changed = TRUE
			else
				output += run_text
			output += tag
			run_start = tag_end + 1
			depth = 0
			saw_inline_tag = FALSE
		cursor = tag_end + 1

	var/tail = copytext(html, run_start)
	var/tail_translated = lang_inline_run_lookup(tail, saw_inline_tag, depth, locale)
	if(tail_translated)
		output += tail_translated
		changed = TRUE
	else
		output += tail

	if(!changed)
		return null
	return output.Join()

/// Localizes visible HTML text while preserving tags, attributes, scripts, styles, and form values.
/proc/lang_fallback_apply_html(html, locale)
	if(!istext(html) || !length(html))
		return html
	if(isnull(locale))
		locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	// 「整句被内联标签切开」的前置 pass。只对聊天行大小的片段做，且**跳过含原文本元素的文档**
	// （script/style/textarea 的内容绝不能碰）——浏览器整页走原来的切块路径。
	if(locale != DEFAULT_UI_LOCALE && length(html) <= I18N_INLINE_RUN_MAX_LENGTH \
		&& !findtext(html, "<script") && !findtext(html, "<style") && !findtext(html, "<textarea"))
		// **先在「还没切块」的整行上跑一遍模板引擎。** 目录模板的字面段里带着标签
		// （`{0}<br>Type <b>vote</b> or click <a href='byond://…'>here</a> to place your votes.…`），
		// 只有在这个作用域里它们才与原文逐字节对得上；一旦按标签切块，字面段就再也拼不回来。
		// 这条路对**含 `<a>` 的模板**尤其重要：剥标签变体（见 template_match.dm）会把链接弄没，
		// 所以那 71 条一律不登记变体；而在整行作用域上匹配，zh 模板连同它自己的 `<a href>`
		// 一起填回去，链接与排版都保住。
		var/templated = lang_template_apply(html, locale)
		if(templated != html)
			html = templated
		var/inlined = lang_localize_inline_runs(html, locale)
		if(!isnull(inlined))
			html = inlined
	var/list/output = list()
	var/cursor = 1
	var/html_length = length(html)
	// 上一个发出的标签是不是 `span_name()` 的开标签。聊天行里的名字被包在里面**独立成块**经过
	// 切块器：整句反查与模板引擎都碰不到它（它自己就是一整块），只剩字面 AC —— 而 AC 有多词
	// 门槛，`wolf`/`animal` 这种单词名永远捞不着，玩家看到「The wolf 说，「……」」。
	// 逐个改那 54 个 span_name() 调用点是走不完的（而且新调用点随时会加），所以在**切块器**里
	// 认这个形状：整块就是一个名字 → 走整串精确反查（含剥冠词），不经 AC。
	var/in_name_span = FALSE
	while(cursor <= html_length)
		var/tag_start = findtext(html, "<", cursor)
		if(!tag_start)
			output += lang_fallback_apply(copytext(html, cursor), locale)
			break
		if(tag_start > cursor)
			var/chunk = copytext(html, cursor, tag_start)
			output += in_name_span ? lang_localize_name_chunk(chunk, locale) : lang_fallback_apply(chunk, locale)
		var/tag_end = lang_html_tag_end(html, tag_start)
		if(!tag_end)
			output += lang_fallback_apply(copytext(html, tag_start), locale)
			break
		var/tag = copytext(html, tag_start, tag_end + 1)
		output += tag
		cursor = tag_end + 1
		in_name_span = findtext(tag, "class='name'") || findtext(tag, "class=\"name\"")

		var/raw_text_tag = lang_html_raw_text_tag_name(tag)
		if(!raw_text_tag)
			continue
		var/closing_tag_start = findtext(html, "</[raw_text_tag]", cursor)
		if(!closing_tag_start)
			output += copytext(html, cursor)
			break
		output += copytext(html, cursor, closing_tag_start)
		var/closing_tag_end = lang_html_tag_end(html, closing_tag_start)
		if(!closing_tag_end)
			output += copytext(html, closing_tag_start)
			break
		output += copytext(html, closing_tag_start, closing_tag_end + 1)
		cursor = closing_tag_end + 1
	return output.Join()

#undef I18N_FALLBACK_CACHE_MAX
#undef I18N_FALLBACK_CACHE_MAX_LENGTH
#undef I18N_INLINE_RUN_MAX_LENGTH
#undef I18N_TAG_NAME_CHARS
#undef I18N_TAG_LEAD_WHITESPACE
