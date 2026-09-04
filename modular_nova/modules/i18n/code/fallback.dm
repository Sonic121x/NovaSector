// NovaSector 全量汉化 (i18n) —— 运行时输出落地层。
//
// 一层：整串精确反查 + 模板逆匹配。聊天由 I18N_CHAT_FALLBACK 门控；browse / 状态栏 /
// 大厅 maptext / 气泡在 locale≠en 时一直走。
// 已被 LANG 处理过的中文在入口按「无拉丁字母」短路，不付切块税。
//
// 这里曾有第二层「字面 Aho-Corasick 子串替换」，已整层删除，理由见 lang_localize_chain。

#define I18N_FALLBACK_CACHE_MAX 2048
#define I18N_FALLBACK_CACHE_MAX_LENGTH 512
/// 「跨内联标签整段查表」前置 pass 的输入上限：聊天行/检查行量级。浏览器整页不走这条路。
#define I18N_INLINE_RUN_MAX_LENGTH 2048
/// `span_tooltip()` 拼出来的提示属性前缀。切块器唯一会去翻的属性（见 lang_localize_tooltip_attrs）。
#define I18N_TOOLTIP_ATTR "data-content=\""

/// locale -> (input -> translated)；有界、不淘汰，避免动态串在长局反复挤压缓存。
GLOBAL_LIST_EMPTY(i18n_fallback_cache)
/// 全中文输出不需要进模板引擎或 rust-g AC。
GLOBAL_VAR_INIT(i18n_ascii_letter_regex, regex(@"[A-Za-z]"))

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

/// 对一段文本应用落地替换。locale 为 null 时用全服 locale；缺省 locale（英文）直接返回。
/// 三条落地链共用的核心：**整串精确 →（剥冠词再精确）→ 模板逆匹配**。
///
/// 从前聊天、TGUI 负载（P1）、显示边界各写了一遍这个顺序，于是：
///   · 顺序只在一处修对过（「整串精确必须排在模板之前」那条，其余两处曾各自被泛化骨架模板劫持）；
///   · 聊天链手写的精确查表只看 exact 表，归一表那批键在聊天路径上永远查不到（实测抓到过）。
/// 现在顺序只有这一处。
///
/// **曾经还有第四层：字面 Aho-Corasick 子串替换，已整层删除。** 两条理由：
///   · 覆盖收益是负的。生产语料实测（40 局 GAME-SAY/EMOTE，496 条英文）：整串精确+模板拿下
///     298 条（60%），只有 AC 能翻的 22 条（4.4%），而那 22 条的产物是「中文碎片嵌在英文句里」
///     （`Arresting level 5 scumbag +Yan+ in the 前部中央主通道.`）—— 比全英文更难看。
///   · 代价是结构性的。字典由反查表自动生成（93,039 条多词模式），每局 `world.Reboot()` 清 GLOB
///     后重建一次：三份列表 + `json_encode` 出两个约 5 MB 的**连续**字符串交给 rust。32 位
///     DreamDaemon 的 brk 堆跑久了满是空洞，这种大块连续分配正是最先失败的那类
///     （生产实测 7 天 18 次 SIGABRT，栈全部落在 librust_g.so，且总在回合切换的瞬间）。
///   另外 AC 没有词边界概念、取最短匹配，历史上反复从单词内部开火（`", Col"` 把
///   `Smith, Colonel` 咬成 `Smith, 列onel`），`lang_fallback_pattern_safe` 那一整套闸门就是
///   为它写的，一并删掉。
///
/// 原先靠 AC 落地的那 21 条大厅/状态栏/法则标签改为**在渲染点整串精确反查**
///（`strings/i18n/*/_chrome.json`，译文逐字未变）。模板引擎自己的锚自动机（`i18n_tpl_*`，
/// 约 1.6 万条锚）不在此列，它是精确的第二层证据、量级也小 30 倍，保留。
/proc/lang_localize_chain(text, locale, allow_template, exact_already_checked = FALSE)
	// 热路径调用方（TGUI 负载）已经跑过更强的精确/归一化/后缀反查；这里再跑一遍会让每次 miss
	// 的归一化与正则工作翻倍（一局数百万次调用，profiler 里 lang_reverse_text_in/lang_collapse_ws
	// 重复计数即此）。
	if(!exact_already_checked)
		. = lang_reverse_text_in(text, locale)
		if(. != text)
			return
	else
		. = text
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
	var/templated = FALSE
	if(allow_template)
		var/after_template = lang_template_apply(text, locale)
		if(after_template != text)
			text = after_template
			templated = TRUE
	if(!templated)
		lang_count_layer_hit(I18N_LAYER_MISS)
	return text

/// 可见文本（剥掉 HTML 标签之后）是否含拉丁字母。标签里的 `span`/`class` 不算——
/// 否则带样式的已译中文行永远付切块税。
/proc/lang_html_visible_has_latin(html)
	var/regex/ascii_letter_regex = GLOB.i18n_ascii_letter_regex
	if(!ascii_letter_regex.Find(html, 1))
		return FALSE
	if(!findtext(html, "<"))
		return TRUE
	return ascii_letter_regex.Find(lang_strip_html_tags(html), 1)

/proc/lang_fallback_apply(text, locale)
	if(!istext(text) || !length(text))
		return text
	if(isnull(locale))
		locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale == DEFAULT_UI_LOCALE)
		return text
	var/source_text = text
	var/list/cache = GLOB.i18n_fallback_cache[locale]
	if(!GLOB.i18n_log_misses && length(text) <= I18N_FALLBACK_CACHE_MAX_LENGTH && islist(cache) && (text in cache))
		return cache[text]
	// 剥掉 BYOND 文本宏 \improper / \proper（0xFF 起头的控制字节）：模板引擎的锚匹配走 rustg，
	// 按 UTF-8 处理字符串，这些非 UTF-8 字节会被替换成 U+FFFD（显示为 ��，如「那是 ��space」）。中文无
	// 大小写，这两个宏（控制后随单词首字母大小写）本就无意义 → 直接剥除。findtext 门控让无宏的
	// 热路径（绝大多数聊天行）零额外开销。
	if(findtext(text, "\improper") || findtext(text, "\proper"))
		text = replacetext(text, "\improper ", "")
		text = replacetext(text, "\proper ", "")
		text = replacetext(text, "\improper", "")
		text = replacetext(text, "\proper", "")
	// 无拉丁字母：精确与模板都不可能命中，直接短路。
	var/regex/ascii_letter_regex = GLOB.i18n_ascii_letter_regex
	if(!ascii_letter_regex.Find(text, 1))
		return lang_fallback_cache_store(locale, source_text, text)
	// 单词/无空白串：整串精确反查仍然要跑（emote 的 `chitters.` 是目录键），但不进模板引擎
	// —— 锚长门槛下它一条也匹配不上，白跑。
	var/has_word_separator = findtext(text, " ") || findtext(text, "\t") || findtext(text, "\n")
	if(!has_word_separator)
		text = lang_localize_chain(text, locale, allow_template = FALSE)
		if(GLOB.i18n_log_misses)
			lang_log_miss_scan(text, "fallback")
		return lang_fallback_cache_store(locale, source_text, text)
	// 整串精确 → 模板逆匹配，顺序由 lang_localize_chain 统一定义。
	// **整串精确必须排在模板之前**：目录里若正好有这一整句，它是最具体的证据。否则先跑的模板
	// 引擎会被泛化骨架劫持——`It appears to {0}`、`{0} produces a {1}.` 这类三两个词的模板会
	// 吞掉任意同形句子，把捕获到的英文原样塞回中文脚手架（「它看起来像be completely inactive.」）。
	text = lang_localize_chain(text, locale, allow_template = TRUE)
	// 漏翻采集：所有层过完仍残留的多词英文 run（config I18N_LOG_MISSES 门控，见 miss_log.dm）。
	if(GLOB.i18n_log_misses)
		lang_log_miss_scan(text, "fallback")
	return lang_fallback_cache_store(locale, source_text, text)

/// 下一句的起点：**句末标点之后**那个空格的下标（找不到返回 0）。
///
/// **必须认全角标点。** 这个 proc 的输入是「已译中文基础句 + 若干英文后缀」拼成的一整行，
/// 基础句结尾是 `。` 而不是 `.`；只认 ASCII 句号的话第一刀会切在 `contractors.` 之后，
/// 于是第一段变成「中文 + 第一条英文后缀」的混合串——它不是任何目录键，整段落不了地，
/// 而第二条后缀恰好独立成段、翻得好好的。表现就是**只有第一条后缀是英文**，
/// 很容易被误读成「那一条漏译」（实测 i18n_real_catalog ⑥c 就是这么红的）。
///
/// **返回的是标点之后的下标，不是标点自身的下标。** `findtext`/`copytext` 按**字节**计
/// （`length("。") == 3`，`length_char` 才是 1），调用侧拿「标点下标 + 1」去切会把全角标点
/// 劈成两半：前一段以半个字符收尾、后一段以两个续行字节开头，两侧都再也匹配不上目录 ——
/// 症状与「压根没切」一模一样（后缀照旧整段英文），排查时极易误判成切点没找到。
/proc/lang_next_sentence_break(text, cursor)
	var/static/list/enders = list(". ", "。 ", "! ", "！ ", "? ", "？ ")
	var/earliest = 0
	. = 0
	for(var/ender in enders)
		var/found = findtext(text, ender, cursor)
		if(!found)
			continue
		if(earliest && found >= earliest)
			continue
		earliest = found
		. = found + length(ender) - 1

/// 把「基础句 + 若干整句后缀」里的后缀**逐句**落地。
///
/// 每个后缀（`" Targetable by contractors."`）各自是目录键，拼起来的整串不是。从前这里靠字面 AC
/// 的子串替换蒙混过去 —— 那一层已整层删除（见 lang_localize_chain），改为按句切开、逐句走整串
/// 精确反查：更准（没有词边界风险、不会从单词内部开火），而且天然支持「其中一句没译」——
/// 那一句保持英文，其余照译，不会像 AC 那样把半句中文塞进英文里。
///
/// 切点由 `lang_next_sentence_break` 给出（半角与全角句末标点都认）：标点连同它属于前一句，
/// 后面那个空格归下一句（中文译文自带标点，接缝不丢）。
/proc/lang_localize_sentence_suffixes(text, locale)
	if(!istext(text) || !length(text))
		return text
	var/text_length = length(text)
	if(text_length < 2)
		return lang_fallback_apply(text, locale)
	var/list/pieces = list()
	var/start = 1
	var/cursor = 1
	while(cursor <= text_length)
		var/split = lang_next_sentence_break(text, cursor)
		if(!split)
			pieces += copytext(text, start)
			break
		pieces += copytext(text, start, split)
		start = split
		cursor = split + 1
	var/list/localized = list()
	for(var/piece in pieces)
		localized += lang_fallback_apply(piece, locale)
	return jointext(localized, "")

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

/// `span_tooltip()` 的提示文字住在 **HTML 属性**里（`<span data-component="Tooltip"
/// data-content="Remove surgically." class="tooltip">`），而 `lang_fallback_apply_html`
/// 按标签切块、只把标签**之间**的纯文本送去查表 —— 属性一律跳过。跳过是对的（`class`/`href`
/// 里是样式名和链接，翻了当场把配色和跳转弄坏），但 `data-content` 是个例外：它按构造就是
/// 给玩家看的散文，别处再没有第二条路径能碰到它。
///
/// 症状很有辨识度：**悬浮提示整条英文，而它锚定的那段正文是中文**（健康扫描仪的断肢/辐射/
/// 异物提示皆然，三条译文一直躺在目录里）。逐个改调用点走不通 —— `conditional_tooltip` 是
/// `#define`，且有一批提示是运行期拼出来的。
///
/// 只认 `data-content`，且只认双引号（`span_tooltip` 就是这么拼的）。内容交给与正文**同一条**
/// 落地链，理由同上：同样的散文不该因为所处位置不同而拿到不同待遇。
/proc/lang_localize_tooltip_attrs(tag, locale)
	var/at = findtext(tag, I18N_TOOLTIP_ATTR)
	if(!at)
		return tag
	var/value_start = at + length(I18N_TOOLTIP_ATTR)
	var/value_end = findtext(tag, "\"", value_start)
	if(!value_end || value_end <= value_start)
		return tag
	var/value = copytext(tag, value_start, value_end)
	var/localized = lang_fallback_apply(value, locale)
	if(localized == value)
		return tag
	return copytext(tag, 1, value_start) + localized + copytext(tag, value_end)

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

/// 整行是不是「**单独一个**纯文本块、且它本身就是目录键」。
///
/// 只被整行模板 pass 用作闸门。要解决的是泛化骨架抢在整块精确查表之前命中：
/// `You feel like {0}.` 把 `<span class='notice'>You feel like you could be safe on your own.</span>`
/// 吃成「你感觉像you could be safe on your own。」——整句译文一直躺在目录里，只是轮不到。
///
/// **判据必须是「整行只有这一个文本块」，不能是「存在某个块命中」**：目录里躺着 `You can` 这类
/// 拼句碎片（当年字面 AC 那几起事故的主角），按「存在即否决」写会把**正经**跨块模板一并否掉——
/// `You can <b>examine closely</b> to learn a little more about {0}.` 的框架分落三个 chunk，
/// 只有整行 pass 够得着它，而 `You can` 恰好命中 → 模板被否 → 玩家看到「你可以 凑近细看 to learn…」。
/// 单块时切块器一定翻得动整行、模板不可能做得更好；多块时模板跨块工作，该让它赢。
/// （i18n_html_tag_keys ③ 与 i18n_real_catalog ①c2 正反两面各守一边。）
/proc/lang_line_is_single_exact_chunk(html, locale)
	var/html_length = length(html)
	var/cursor = 1
	var/seen_text = FALSE
	var/hit = FALSE
	while(cursor <= html_length)
		var/tag_start = findtext(html, "<", cursor)
		var/chunk = trim(copytext(html, cursor, tag_start || 0))
		if(length(chunk))
			if(seen_text)
				return FALSE // 多于一个文本块 → 交给整行模板
			seen_text = TRUE
			// 与 lang_inline_run_lookup 同一条安全线：只认多词整句。
			hit = findtext(chunk, " ") && lang_reverse_text_in(chunk, locale) != chunk
		if(!tag_start)
			break
		var/tag_end = lang_html_tag_end(html, tag_start)
		if(!tag_end)
			break
		cursor = tag_end + 1
	return hit

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
	if(locale == DEFAULT_UI_LOCALE)
		return html
	// 可见文本无拉丁字母 → 零切块。必须在 inline-run / 整行模板 / 切块循环之前。
	// 标签里的 class 名不算（否则带 span 的已译中文行永远走切块器）。
	// 有 tooltip 属性时不能短路：data-content 在标签内部，strip 会把它丢掉，里面可能是英文。
	if(!findtext(html, I18N_TOOLTIP_ATTR) && !lang_html_visible_has_latin(html))
		return html
	// 「整句被内联标签切开」的前置 pass。只对聊天行大小的片段做，且**跳过含原文本元素的文档**
	// （script/style/textarea 的内容绝不能碰）——浏览器整页走原来的切块路径。
	if(locale != DEFAULT_UI_LOCALE && length(html) <= I18N_INLINE_RUN_MAX_LENGTH \
		&& !findtext(html, "<script") && !findtext(html, "<style") && !findtext(html, "<textarea"))
		// **整串精确必须排在模板之前——这条在「整行」这个作用域上曾经漏掉。**
		// lang_localize_inline_runs 跨内联标签把整段文本连起来**整段精确查表**，是这一层里最具体
		// 的证据；而下面那条整行模板 pass 会让目录里「三两个词 + 占位符」的泛化骨架抢先命中，把
		// 捕获到的英文原样塞进中文脚手架：`You feel like {0}.` 把
		// `<span class='notice'>You feel like you could be safe on your own.</span>` 吃成
		// 「你感觉像you could be safe on your own。」——**整句译文一直都在目录里**，只是轮不到。
		// 这与 lang_localize_chain 里那条同源（见 i18n_real_catalog ①c），当时只修了块作用域。
		var/inlined = lang_localize_inline_runs(html, locale)
		if(!isnull(inlined))
			html = inlined
		// 整行模板 pass：目录模板的字面段里带着标签
		// （`{0}<br>Type <b>vote</b> or click <a href='byond://…'>here</a> to place your votes.…`），
		// 只有在这个作用域里它们才与原文逐字节对得上；一旦按标签切块，字面段就再也拼不回来。
		// 这条路对**含 `<a>` 的模板**尤其重要：剥标签变体（见 template_match.dm）会把链接弄没，
		// 所以那 71 条一律不登记变体；而在整行作用域上匹配，zh 模板连同它自己的 `<a href>`
		// 一起填回去，链接与排版都保住。整段精确没命中时它才有机会跑（上面那 pass 未命中会
		// 原样交还），所以两条并不互斥。
		var/templated = lang_template_apply(html, locale)
		// **整串精确赢过泛化模板**，在整行作用域上同样成立。上面那条前置 pass 只管「被内联标签
		// 切开的句子」（lang_inline_run_lookup 要求 saw_inline_tag），而绝大多数聊天行是
		// `<span class='notice'>整句</span>` 这种**没被切开**的形态 —— 它本该由下面的切块器整块
		// 精确查表，却被这条整行模板 pass 抢先吃掉：`You feel like {0}.` 把
		// 「You feel like you could be safe on your own.」变成「你感觉像you could be safe on your own。」，
		// 而整句译文一直躺在目录里。
		// 闸门放在**模板已经命中之后**：只有那时才多走一趟切块扫描去确认「有没有哪一块本来就是
		// 目录键」，命中就丢掉模板结果、把这一行交还给切块器。没有模板命中的行（绝大多数）零额外开销。
		if(templated != html && !lang_line_is_single_exact_chunk(html, locale))
			html = templated
	var/list/output = list()
	var/cursor = 1
	var/html_length = length(html)
	// 上一个发出的标签是不是 `span_name()` 的开标签。聊天行里的名字被包在里面**独立成块**经过
	// 切块器：整句反查与模板引擎都碰不到它（它自己就是一整块），只剩字面 AC —— 而 AC 有多词
	// 门槛，`wolf`/`animal` 这种单词名永远捞不着，玩家看到「The wolf 说，「……」」。
	// 逐个改那 54 个 span_name() 调用点是走不完的（而且新调用点随时会加），所以在**切块器**里
	// 认这个形状：整块就是一个名字 → 走整串精确反查（含剥冠词），不经 AC。
	var/in_name_span = FALSE
	// 整行扫一次，而不是每个标签扫一次：这是每条 to_chat 的必经路径，而带 tooltip 的行是少数。
	var/has_tooltip_attr = locale != DEFAULT_UI_LOCALE && findtext(html, I18N_TOOLTIP_ATTR)
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
		output += has_tooltip_attr ? lang_localize_tooltip_attrs(tag, locale) : tag
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
#undef I18N_TOOLTIP_ATTR
#undef I18N_TAG_NAME_CHARS
#undef I18N_TAG_LEAD_WHITESPACE
