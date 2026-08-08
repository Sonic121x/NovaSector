// NovaSector 全量汉化 (i18n) —— 边界层「模板逆匹配」引擎。
//
// 问题：反查表只收无占位符纯串、字面 AC 字典只收多词字面短语——目录里上万条**已译插值模板**
// （"{0} is already filled to capacity." 等）对边界层完全不可见：运行期实参填进占位符后，
// 整串既不是反查键、含占位符的模板又被 AC 守卫排除 → 凡「拼进变量再输出」「改写器够不着的
// 调用形状」一律漏翻，只能逐点打补丁（AGENTS.md 排查规律节的大半条目即此类）。
//
// 本引擎把这些模板变成运行时可匹配的「逆模板」，流程：
//   1. setup（惰性、每 locale 一次）：取每条已译 en 模板的字面段序列，选「最长多词段」做
//      AC 锚（rustg Aho-Corasick），锚 → 候选模板 id 集。
//   2. apply：输出文本先过锚检测（一次 acreplace 把锚换成 sentinel；无锚命中即近零成本返回，
//      绝大多数行走此快路径）。
//   3. 命中后按字面段序列在**原文**上验证完整模板（findtext 逐段；段间文本=捕获的实参）。
//   4. 捕获实参递归本地化：整串反查 → 状态词表 → 多词字面 AC（名字/状态词/短语都能翻）。
//   5. 按 zh 模板填充（{N} 可按中文语序重排）并替换原文里的命中区间。
//
// 挂接：lang_fallback_apply（fallback.dm）内、字面 AC 之前——聊天/browse/状态栏/公告/maptext/
// 职业描述等全部边界一次获得插值句翻译能力。locale==en 零开销；已译中文不再匹配英文锚，天然幂等。
//
// 安全性：要求模板全部字面段按序命中 + 锚为多词长段（≥10 字符含空格）+ 捕获不跨行，误匹配
// 概率极低；相邻占位符（捕获边界不可定）与短锚模板在 setup 期剔除，交还给 LANG/反查路径。

/// 锚段最低长度（字节）。短于此或不含空格的模板不进引擎（误匹配风险高，留给 LANG 改写）。
#define I18N_TPL_MIN_ANCHOR 10
/// 单次 apply 最多替换次数 / 单模板最多重复匹配次数 / 捕获最大长度（防病态输入）。
#define I18N_TPL_MAX_REPLACE 8
#define I18N_TPL_MAX_REPEAT 4
#define I18N_TPL_MAX_CAPTURE 300

// 模板记录字段下标（GLOB.i18n_tpl_records[locale] 的每条 = list(segs, order, zh, lit_len)）。
#define I18N_TPL_SEGS 1
#define I18N_TPL_ORDER 2
#define I18N_TPL_ZH 3
#define I18N_TPL_LITLEN 4

/// locale -> "ready" | "none"。
GLOBAL_LIST_EMPTY(i18n_tpl_state)
/// locale -> 模板记录列表（id = 下标）。
GLOBAL_LIST_EMPTY(i18n_tpl_records)
/// locale -> 锚序号 -> 候选模板 id 列表（与 AC sentinel 编号对应）。
GLOBAL_LIST_EMPTY(i18n_tpl_anchor_ids)
/// sentinel 定界符。不能用控制字节（STX/ETX）：JSON 规范禁止字符串里出现未转义控制符，
/// BYOND json_encode 的产物会让 rust 端 setup_acreplace 静默失败（acreplace 此后返回空串）。
/// 改用罕见的可打印数学括号 ⟦⟧（U+27E6/27E7）；即使游戏文本撞上，候选 id 只是提示，
/// 验证阶段仍以原文逐字面段校验，最多多一次无效尝试、不会错翻。
GLOBAL_VAR_INIT(i18n_tpl_stx, "⟦")
GLOBAL_VAR_INIT(i18n_tpl_etx, "⟧")

/// 目录模板「字面形态」→「运行时形态」归一：JSON 目录里保留着 dreammaker 源码转义
/// （字面 \n / \" / \improper），运行时字符串里是真换行/裸引号/无宏——不归一则永远匹配不上。
/proc/lang_tpl_normalize(text)
	if(findtext(text, "\\"))
		text = replacetext(text, "\\\"", "\"")
		text = replacetext(text, "\\n", "\n")
		text = replacetext(text, "\\t", "\t")
		text = replacetext(text, "\\improper", "")
		text = replacetext(text, "\\proper", "")
	return text

/// 把模板拆为「字面段序列 + 占位符序号序列」：segs 比 order 多 1（首段/末段可为空 =
/// 模板以占位符开头/结尾）。非 {数字} 的花括号按字面处理。
/proc/lang_tpl_parse(template)
	var/list/segs = list()
	var/list/order = list()
	var/seg_start = 1
	var/pos = 1
	var/len = length(template)
	while(pos <= len)
		var/brace = findtext(template, "{", pos)
		if(!brace)
			break
		var/close = findtext(template, "}", brace + 1)
		if(!close || close - brace > 3) // 只认 {N}/{NN}
			pos = brace + 1
			continue
		var/numtext = copytext(template, brace + 1, close)
		if(!lang_tpl_all_digits(numtext))
			pos = brace + 1
			continue
		segs += copytext(template, seg_start, brace)
		order += text2num(numtext)
		seg_start = close + 1
		pos = seg_start
	segs += copytext(template, seg_start) // 末段（可为空串）
	return list(segs, order)

/proc/lang_tpl_all_digits(text)
	var/len = length(text)
	if(!len)
		return FALSE
	for(var/i in 1 to len)
		var/ch = text2ascii(text, i)
		if(ch < 48 || ch > 57)
			return FALSE
	return TRUE

/// 惰性构建某 locale 的逆模板库与锚自动机；返回是否可用。
/proc/lang_tpl_setup(locale)
	var/state = GLOB.i18n_tpl_state[locale]
	if(state)
		return state == "ready"
	var/list/english = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	var/list/localized = GLOB.i18n_cache[locale]
	if(!islist(english) || !islist(localized) || !length(english))
		return FALSE // cache 未就绪：不缓存状态，防极早期调用毒化（同 lang_build_reverse 加固）
	var/list/records = list()
	var/list/anchors = list() // 锚文本 -> 候选 id 列表
	for(var/key in english)
		var/en_t = english[key]
		if(!findtext(en_t, "{"))
			continue // 纯串走反查/字面 AC
		var/zh_t = localized[key]
		if(!zh_t || zh_t == en_t)
			continue
		en_t = lang_tpl_normalize(en_t)
		var/list/parsed = lang_tpl_parse(en_t)
		var/list/segs = parsed[1]
		var/list/order = parsed[2]
		if(!length(order))
			continue
		var/nsegs = length(segs)
		var/bad = FALSE
		var/lit_len = 0
		var/anchor = ""
		for(var/i in 1 to nsegs)
			var/seg = segs[i]
			var/seg_len = length(seg)
			lit_len += seg_len
			if(!seg_len && i != 1 && i != nsegs) // 相邻占位符：捕获边界不可定
				bad = TRUE
				break
			if(seg_len > length(anchor) && findtext(seg, " "))
				anchor = seg
		if(bad || length(anchor) < I18N_TPL_MIN_ANCHOR)
			continue
		var/zh_runtime = zh_t
		if(findtext(zh_runtime, "\\"))
			zh_runtime = lang_process_text_escapes(zh_runtime)
		if(findtext(zh_runtime, anchor)) // 半翻译（zh 仍含英文锚段，bad-MT 类）：替换无意义且会自匹配
			continue
		records += list(list(segs, order, zh_runtime, lit_len))
		var/id = length(records)
		var/list/ids = anchors[anchor]
		if(ids)
			ids += id
		else
			anchors[anchor] = list(id)
	if(!length(anchors))
		GLOB.i18n_tpl_state[locale] = "none"
		return FALSE
	var/list/patterns = list()
	var/list/replacements = list()
	var/list/anchor_ids = list()
	var/stx = GLOB.i18n_tpl_stx
	var/etx = GLOB.i18n_tpl_etx
	var/idx = 0
	for(var/anchor in anchors)
		idx++
		patterns += anchor
		replacements += "[stx][idx][etx]"
		anchor_ids += list(anchors[anchor])
	GLOB.i18n_tpl_records[locale] = records
	GLOB.i18n_tpl_anchor_ids[locale] = anchor_ids
	// **必须 LeftmostLongest**。默认的 Standard 在同一起点取**最短**匹配，而锚之间大量互为前缀：
	// "{0} begins to make an incision in {1}." 的锚 " begins to make an incision in " 会把
	// "{0} begins to make an incision in the organs within {1}." 那条更长的锚整个遮住，甚至更短的
	// 通用锚（" begins to "…）会把两条都遮住。被遮住的锚**不进候选**，于是唯一能匹配的那条模板
	// 根本不会被尝试，整句原样留英文——手术台上每一步的可见消息就是这么全程没翻（i18n_real_catalog
	// 守这条）。原注释说「只是少收一个候选、不影响正确性」，不成立：少收的正是对的那个。
	// 与 fallback.dm 的字面 AC 同款选项。
	var/static/list/tpl_ac_options = list("match_kind" = "LeftmostLongest")
	rustg_setup_acreplace_with_options("i18n_tpl_[locale]", tpl_ac_options, patterns, replacements)
	GLOB.i18n_tpl_state[locale] = "ready"
	return TRUE

/// 对一段输出文本应用模板逆匹配。locale 为 null 用全服 locale；en/未就绪原样返回。
/proc/lang_template_apply(text, locale)
	if(isnull(locale))
		locale = GLOB.i18n_server_locale || DEFAULT_UI_LOCALE
	if(locale == DEFAULT_UI_LOCALE || !istext(text) || !length(text))
		return text
	if(!lang_tpl_setup(locale))
		return text
	var/marked = rustg_acreplace("i18n_tpl_[locale]", text)
	if(marked == text)
		return text // 无锚命中：快路径
	// 解析 sentinel，按出现顺序收集去重候选 id。
	var/list/anchor_ids = GLOB.i18n_tpl_anchor_ids[locale]
	var/list/records = GLOB.i18n_tpl_records[locale]
	var/stx = GLOB.i18n_tpl_stx
	var/etx = GLOB.i18n_tpl_etx
	var/list/candidates = list()
	var/stx_len = length(stx) // 多字节 UTF-8 定界符：必须按字节长推进，s+1 会切进字符中间
	var/etx_len = length(etx)
	var/pos = 1
	while(TRUE)
		var/s = findtext(marked, stx, pos)
		if(!s)
			break
		var/e = findtext(marked, etx, s + stx_len)
		if(!e)
			break
		var/aidx = text2num(copytext(marked, s + stx_len, e))
		pos = e + etx_len
		if(!aidx || aidx > length(anchor_ids))
			continue
		for(var/id in anchor_ids[aidx])
			candidates |= id
	if(!length(candidates))
		return text
	// 字面量总长降序：防短模板抢走长模板的一段。
	if(length(candidates) > 1)
		var/list/sorted = list()
		for(var/id in candidates)
			var/list/record = records[id]
			var/inserted = FALSE
			for(var/i in 1 to length(sorted))
				var/list/other = records[sorted[i]]
				if(record[I18N_TPL_LITLEN] > other[I18N_TPL_LITLEN])
					sorted.Insert(i, id)
					inserted = TRUE
					break
			if(!inserted)
				sorted += id
		candidates = sorted
	var/replaced = 0
	for(var/id in candidates)
		var/list/record = records[id]
		var/guard = 0
		while(guard++ < I18N_TPL_MAX_REPEAT)
			var/list/m = lang_tpl_match(text, record[I18N_TPL_SEGS], record[I18N_TPL_ORDER], record[I18N_TPL_ZH], locale)
			if(!m)
				break
			text = copytext(text, 1, m[1]) + m[3] + copytext(text, m[2])
			if(++replaced >= I18N_TPL_MAX_REPLACE)
				return text
	return text

/// 在 text 上验证一条逆模板。命中返回 list(起点, 终点(开区间), 替换文本)；否则 null。
/proc/lang_tpl_match(text, list/segs, list/order, zh_template, locale)
	var/nsegs = length(segs)
	var/leading_ph = (segs[1] == "")
	var/trailing_ph = (segs[nsegs] == "")
	var/first_lit_idx = leading_ph ? 2 : 1
	var/first_lit = segs[first_lit_idx]
	var/p = findtext(text, first_lit)
	if(!p)
		return null
	var/list/captures = list()
	var/match_start
	var/cursor = p + length(first_lit)
	if(leading_ph)
		// 前导占位符：捕获从最近的行首/句界开始，再把打头的完整 HTML 标签与空白留在替换区外。
		var/cap_start = 1
		var/best = 0
		for(var/boundary in list("\n", ". ", "! ", "? "))
			var/b = findlasttext(text, boundary, p)
			if(b && b + length(boundary) > best)
				best = b + length(boundary)
		if(best)
			cap_start = best
		var/lead = copytext(text, cap_start, p)
		var/skip = lang_tpl_leading_skip(lead)
		match_start = cap_start + skip
		var/capture = copytext(lead, skip + 1)
		if(length(capture) > I18N_TPL_MAX_CAPTURE)
			return null
		captures += capture
	else
		match_start = p
	// 中间段：依序定位，段间即捕获。
	for(var/i in (first_lit_idx + 1) to (trailing_ph ? nsegs - 1 : nsegs))
		var/seg = segs[i]
		var/q = findtext(text, seg, cursor)
		if(!q)
			return null
		var/capture = copytext(text, cursor, q)
		if(length(capture) > I18N_TPL_MAX_CAPTURE || findtext(capture, "\n"))
			return null
		captures += capture
		cursor = q + length(seg)
	var/match_end = cursor
	if(trailing_ph)
		// 尾随占位符：捕获到最近的行尾/句界，再把结尾的闭合标签与空白留在替换区外。
		var/cap_end = length(text) + 1
		for(var/boundary in list("\n", ". ", "! ", "? "))
			var/b = findtext(text, boundary, cursor)
			if(b && b < cap_end)
				cap_end = b
		var/capture = copytext(text, cursor, cap_end)
		var/trail_skip = lang_tpl_trailing_skip(capture)
		capture = copytext(capture, 1, length(capture) - trail_skip + 1)
		if(length(capture) > I18N_TPL_MAX_CAPTURE)
			return null
		captures += capture
		match_end = cursor + length(capture)
	// 填充 zh 模板：captures 按 en 占位符出现顺序，对应 order[i] 号。
	var/result = zh_template
	for(var/i in 1 to length(order))
		result = replacetext(result, "{[order[i]]}", lang_tpl_localize_arg(captures[i], locale))
	if(findtext(result, "\\"))
		result = lang_process_text_escapes(result)
	return list(match_start, match_end, result)

/// 前导捕获里打头的「完整 HTML 标签 + 空白」长度（这部分不属于实参，留在替换区外）。
/proc/lang_tpl_leading_skip(text)
	var/len = length(text)
	var/i = 1
	while(i <= len)
		var/ch = text2ascii(text, i)
		if(ch == 32 || ch == 9) // 空格/制表符
			i++
			continue
		if(ch == 60) // "<"
			var/close = findtext(text, ">", i + 1)
			if(!close)
				break
			i = close + 1
			continue
		break
	return i - 1

/// 尾随捕获里结尾的「完整闭合标签 + 空白」长度（同上，从尾部数）。
/proc/lang_tpl_trailing_skip(text)
	var/len = length(text)
	var/i = len
	while(i >= 1)
		var/ch = text2ascii(text, i)
		if(ch == 32 || ch == 9)
			i--
			continue
		if(ch == 62) // ">"
			var/open = findlasttext(text, "<", i)
			if(!open)
				break
			i = open - 1
			continue
		break
	return len - i

/// 捕获实参本地化：统一链（状态词→代词→整串反查→冠词剥离，见 runtime.dm 的 lang_localize_arg）
/// → 多词捕获再退字面 AC。查不到原样保留（数字/已中文/玩家名）。
/proc/lang_tpl_localize_arg(capture, locale)
	if(!istext(capture) || !length(capture))
		return capture
	var/zh = lang_localize_arg(capture)
	if(zh != capture)
		return zh
	if(findtext(capture, " ") && lang_fallback_setup(locale))
		return rustg_acreplace("i18n_[locale]", capture)
	return capture

#undef I18N_TPL_MIN_ANCHOR
#undef I18N_TPL_MAX_REPLACE
#undef I18N_TPL_MAX_REPEAT
#undef I18N_TPL_MAX_CAPTURE
#undef I18N_TPL_SEGS
#undef I18N_TPL_ORDER
#undef I18N_TPL_ZH
#undef I18N_TPL_LITLEN
