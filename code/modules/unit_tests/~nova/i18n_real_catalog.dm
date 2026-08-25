/// 用**真目录**跑一遍显示链路的端到端抽查。
///
/// i18n_template_match 注入合成模板验证引擎逻辑，i18n_unreverse 验证反查往返——两者都用假数据，
/// 所以「引擎没问题、真目录里那条却翻不出来」这一格是空的。玩家上报的漏译十有八九落在这一格：
/// 键在、译文在、调用点也对，中间某一环（转义、锚长门槛、半翻译自匹配…）把它悄悄吃掉。
///
/// 这里挑几条**形态各异**的真实条目，按它们在游戏里的实际渲染形态喂进落地层，断言出来是中文：
///   ① 插值句经模板逆匹配（手术可见消息，span 包裹 + 两个实参）；
///   ② 纯串经整串反查（LANG 实参碎片）；
///   ③ 域内表（史莱姆颜色、警报类别，故意不在全局反查表里）。
/// 目录条目被删或被改成半翻译时这里会红——比等玩家截图快。
/datum/unit_test/i18n_real_catalog

/datum/unit_test/i18n_real_catalog/Run()
	var/saved_locale = GLOB.i18n_server_locale
	if(!islist(GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][LANGUAGE_LOCALE_ZH_HANS]))
		return // 该 locale 目录不存在（精简签出）：跳过而不是误报。
	GLOB.i18n_server_locale = LANGUAGE_LOCALE_ZH_HANS

	// ① 插值句：手术台上每一步都长这样（display_results → visible_message → to_chat 的 AC/模板层）。
	// 分层断言：目录 → 引擎就绪 → 裸句 → 带 span 的整条。哪一层断的一目了然。
	var/list/en_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][DEFAULT_UI_LOCALE]
	var/list/zh_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][LANGUAGE_LOCALE_ZH_HANS]
	TEST_ASSERT_EQUAL(en_cache["datum.67ca09d3877d7907"], "{0} begins to make an incision in the organs within {1}.", "目录里的英文模板应仍是这条（键换了就更新本测试）")
	TEST_ASSERT_NOTEQUAL(zh_cache["datum.67ca09d3877d7907"], en_cache["datum.67ca09d3877d7907"], "该键应已译")
	TEST_ASSERT(lang_tpl_setup(LANGUAGE_LOCALE_ZH_HANS), "zh-Hans 的模板逆匹配索引应能建起来")

	var/bare = "Isshiki Iroha begins to make an incision in the organs within YC Bond's chest."
	var/marked = rustg_acreplace("i18n_tpl_[LANGUAGE_LOCALE_ZH_HANS]", bare)
	TEST_ASSERT_NOTEQUAL(marked, "", "锚自动机返回空串 = setup 静默失败（见 i18n_tpl_stx 注释里那次 JSON 控制符事故）")
	TEST_ASSERT_NOTEQUAL(marked, bare, "句中应至少命中一个模板锚；记录数 [length(GLOB.i18n_tpl_records[LANGUAGE_LOCALE_ZH_HANS])]")
	TEST_ASSERT_NOTEQUAL(lang_template_apply(bare, LANGUAGE_LOCALE_ZH_HANS), bare, "裸句应被模板逆匹配翻译")

	var/incision = "<span class='notice'>[bare]</span>"
	var/incision_out = lang_fallback_apply_html(incision)
	TEST_ASSERT_NOTEQUAL(incision_out, incision, "带 span 的整条同样应被翻译（聊天落地形态）")

	// ①b 同一把锚下的**短模板**。上面那条是「organs within」长模板，它自带一段极长的独占锚，
	// 就算候选排序出问题也容易蒙对；真正脆的是共用前缀锚 " begins to make an incision in " 的
	// 那一组——候选里按字面量总长排在前面的是 "…{1}'s reagent processor…"，必须先验证失败、
	// 再轮到通用的那条。玩家实报「Default Cyborg-973 begins to make an incision in Orange's head.」
	// 整句留英文，就是这一格塌了；organs within 那条同时还是好的，所以只测长模板看不出来。
	var/list/short_lines = list(
		"Default Cyborg-973 begins to make an incision in Orange's head.",
		"Default Cyborg-973 begins to retract the skin in Orange's head.",
		"Default Cyborg-973 begins to mend the incision in Orange's chest.",
		"Default Cyborg-973 searches for implants in Orange.",
		"Default Cyborg-973 succeeds!",
	)
	for(var/line in short_lines)
		var/out = lang_template_apply(line, LANGUAGE_LOCALE_ZH_HANS)
		TEST_ASSERT_NOTEQUAL(out, line, "手术可见消息应被模板逆匹配翻译，实得原文：[line]")

	// ②a 碎片**绝不能**在单词内部开火（见 i18n_ac_fragment 的闸门）。这里用真目录再守一道：
	// 线上表现是「But n其中一只 its eggs hatched!」「searches for植入了in Orange」。
	var/eggs = "But none of its eggs hatched!"
	TEST_ASSERT(!findtext(lang_fallback_apply(eggs), "n其中一只"), \
		"碎片 pattern 在单词内部开火：[lang_fallback_apply(eggs)]")

	// ①c 整串精确反查必须**赢过**泛化模板。目录里同时存在整句键和「三两个词 + 占位符」的骨架
	// 模板时，若模板先跑就会劫持整句、把捕获到的英文塞回中文脚手架：
	//   `It appears to {0}`→`它看起来像{0}` 把正电子脑那句吃成「它看起来像be completely inactive.」
	//   `{0} produces a {1}.`→`{0}产出{1}。` 把金史莱姆那句吃成「Fully heals the target and产出random coin。」
	// 两句的整句译文一直都在目录里，只是排在模板之后永远轮不到。
	var/list/whole_sentences = list(
		"It appears to be completely inactive. The reset light is blinking.",
		"Fully heals the target and produces a random coin.",
	)
	var/regex/ascii_letters = GLOB.i18n_ascii_letter_regex
	for(var/sentence in whole_sentences)
		var/out = lang_fallback_apply(sentence)
		TEST_ASSERT_NOTEQUAL(out, sentence, "整句在目录里却没被翻译：[sentence]")
		TEST_ASSERT(!ascii_letters.Find(out), \
			"整句被泛化模板劫持、译文里还裹着英文残句：[out]")

	// ①c2 同一条规则在**整行（未切块）作用域**上也必须成立。lang_fallback_apply_html 为了让
	// 「字面段里带标签」的模板（含 `<a href>` 的投票行）能匹配，会先在整行上跑一遍模板引擎；
	// 那条 pass 一度排在整段精确查表**之前**，于是 `You feel like {0}.` 把这两句整句劫持成
	// 「你感觉像you could be safe on your own。」——译文一直在目录里，只是轮不到。
	// **按真实渲染形态构造**（span_notice 包裹），别手写等价物：少一层标签就走不到那条 pass。
	var/list/wrapped_sentences = list(
		span_notice("You feel like you could be safe on your own."),
		span_notice("You feel like a fog was lifted from your mind."),
	)
	for(var/wrapped in wrapped_sentences)
		var/out = lang_fallback_apply_html(wrapped)
		TEST_ASSERT_NOTEQUAL(out, wrapped, "带 span 的整句在目录里却没被翻译：[wrapped]")
		TEST_ASSERT(findtext(out, "<span class='notice'>"), \
			"整行 pass 把 span 外壳吃掉了：[out]")
		TEST_ASSERT(!ascii_letters.Find(lang_strip_html_tags_raw(out)), \
			"整句被整行模板 pass 劫持、中文脚手架里裹着英文：[out]")

	// ② 纯串：被改写抬成 LANG 实参的碎片，经 lang_localize_arg 的整串反查。
	TEST_ASSERT_NOTEQUAL(lang_localize_arg("is secured and ready to be used!"), "is secured and ready to be used!", "LANG 实参碎片应整串反查命中")

	// ③ 逐项翻的状态词列表（鱼的健康警告、材料属性详检）：整句拼完不是目录键，只能逐项过
	// lang_localize_arg 再用顿号连接。断言的是**这条通道**，不是 AC——拿裸碎片喂 AC 本来就不该命中。
	TEST_ASSERT_NOTEQUAL(lang_localize_arg("drowning"), "drowning", "鱼的状态词应经 _state_words 翻译")
	TEST_ASSERT_NOTEQUAL(lang_english_list(list("starving", "drowning")), "starving and drowning", "状态词列表应逐项翻并用顿号连接")

	// ②b **落在标签内部的占位符收的是标识符，不能翻**。幻觉心灵感应那条模板是
	// `<span class='{0}'>…</span><span class='{1}'> {2}</span>`，{0}/{1} 是 span 的 CSS 类名 ——
	// 一旦被当文案翻掉，中文就写进 class 属性、聊天配色当场全丢。这里故意拿一个**确实翻得动**的
	// 值（上一行刚断言过 "drowning" 会被译）当类名：不翻才说明闸门生效，换个查不到的词就测不出东西。
	var/tagged = lang_interpolate("<span class='{0}'>{1}</span>", list("drowning", "drowning"))
	TEST_ASSERT(findtext(tagged, "class='drowning'"), "标签属性里的实参被当文案翻掉了：[tagged]")
	TEST_ASSERT(!findtext(tagged, ">drowning<"), "标签**外**的实参反而没翻：[tagged]")

	// ②c 幻觉无线电句式：碎片池与框架**必须同时到位**。框架从前是裸字面量、按英文语序拼
	// （`"[threat] in [location]!"`），只译碎片会产出「舰长 is 叛徒!」，比全英文更糟。
	// 威胁那条的中文语序与英文相反（"Bomb in cargo" → 「货舱有炸弹」），所以这里同时验两件事：
	// 译文确实是中文，且**占位符被调了序**（{1} 排在 {0} 前面）—— 只断言"是中文"的话，
	// 有人把 zh 模板改回 `{0}在{1}` 也照样过。
	var/threat_line = LANG("datum.28e3a12eb168e201", list("Zxqv", "Qwrp"))
	TEST_ASSERT(findtext(threat_line, "Qwrp") < findtext(threat_line, "Zxqv"), \
		"威胁句式的占位符没有按中文语序调换：[threat_line]")
	TEST_ASSERT_NOTEQUAL(lang_reverse_text("a changeling"), "a changeling", "幻觉指控碎片应已入目录并译出")

	// ④ 域内表：这些**故意**不在全局反查表里，只能经各自的 lang_* 落地。
	TEST_ASSERT_NOTEQUAL(lang_slime_colour("purple"), "purple", "史莱姆颜色应经域内表翻译")
	TEST_ASSERT_EQUAL(lang_reverse_text("purple"), "purple", "史莱姆颜色**不应**进全局反查表（会误伤 icon_state/switch）")
	TEST_ASSERT_NOTEQUAL(lang_alarm_type("Power"), "Power", "警报类别应经域内表翻译")
	TEST_ASSERT_NOTEQUAL(lang_wire_colour("crimson"), "crimson", "线缆颜色应经域内表翻译")
	TEST_ASSERT_EQUAL(lang_reverse_text("crimson"), "crimson", "线缆颜色**不应**进全局反查表（同时是 CSS 颜色名与 act 标识符）")
	// 反应兜底名：`/datum/chemical_reaction` 没有 name 变量，反应查询界面对无产物的反应
	// 从类型路径末段现切显示名 —— 源码里没有字面量可抽，只能走域内表。同一批里有
	// heat/holy/life/soup 这类通用单词，进全局反查表会把 lint 的碰撞告警顶上去。
	TEST_ASSERT_NOTEQUAL(lang_reaction_name("omegasoapification"), "omegasoapification", "反应兜底名应经域内表翻译")
	TEST_ASSERT_EQUAL(lang_reverse_text("holy"), "holy", "反应兜底名**不应**进全局反查表（末段按定义是标识符形态）")
	// 恐惧症类别词：同一个串既是 phobia_regexes 的下标 / phobia.json 的匹配键（标识符），
	// 又要填进「你开始觉得{0}非常令人不安……」「{0}恐惧症」这些已译模板里（显示）。
	TEST_ASSERT_NOTEQUAL(lang_phobia_label("clowns"), "clowns", "恐惧症类别词应经域内表翻译")
	TEST_ASSERT_EQUAL(lang_reverse_text("clowns"), "clowns", "恐惧症类别词**不应**进全局反查表（是匹配表的键）")
	TEST_ASSERT_EQUAL(lang_phobia_label("not_a_phobia"), "not_a_phobia", "未登记类别应原样返回")

	// ④b emote 整行：`manual_emote()` 经 visible_message 拼成 `<span class='emote'><b>名字</b> 动作</span>`。
	// 玩家实测报「蟑螂 chitters.」—— 名字翻了、动作没翻，**同一行两块不同待遇**就是判据。
	// 分层断言，红了能一眼看出断在哪一层：目录 → 反查表 → 切块器整行。
	TEST_ASSERT_NOTEQUAL(lang_reverse_text("chitters."), "chitters.", "emote 动作词应在目录且进了反查表")
	TEST_ASSERT_NOTEQUAL(lang_reverse_text("cockroach"), "cockroach", "emote 名字应在目录且进了反查表")
	var/emote_line = "<span class='emote'><b>cockroach</b> chitters.</span>"
	var/emote_out = lang_fallback_apply_html(emote_line, LANGUAGE_LOCALE_ZH_HANS)
	TEST_ASSERT(!findtext(emote_out, "chitters"), "emote 动作词应被整块反查翻掉：[emote_out]")
	TEST_ASSERT(!findtext(emote_out, "cockroach"), "emote 名字应被整块反查翻掉：[emote_out]")
	TEST_ASSERT(findtext(emote_out, "<span class='emote'>"), "外层 span 必须原样保留：[emote_out]")
	// 头顶气泡拿的是**标签包装之前**的那份 raw_msg，所以聊天框翻好了不代表气泡也翻了
	// （chatmessage.dm 里那段 emote 专用的落地层调用守的就是这条）。
	TEST_ASSERT_NOTEQUAL(lang_fallback_apply("chitters.", LANGUAGE_LOCALE_ZH_HANS), "chitters.", \
		"emote 的裸文本（气泡形态）也必须翻得动")

	// ④c 血迹类污渍的运行期拼名：`"[base_name] [血液名]"` 整串不是目录键，类型表按
	// initial(name) 也对不上（oil 的 initial 是 "motor oil"）。默认血看着正常纯属巧合。
	var/obj/effect/decal/cleanable/blood/oil/oil_decal = allocate(/obj/effect/decal/cleanable/blood/oil)
	var/oil_name = oil_decal.lang_localize_name_for_display(oil_decal.name)
	TEST_ASSERT(!findtext(oil_name, "pool of"), "血迹拼名的前缀应经域内表翻掉：[oil_name]")
	TEST_ASSERT(!findtext(oil_name, "oil"), "血迹拼名的血液词应经整串反查翻掉：[oil_name]")

	// ⑤ 回合总结的反派目标行：explanation_text 是**裸插值**赋值（objective.dm 没走 LANG），
	// 只能靠边界模板逆匹配救。锚遮蔽修好之前它是半翻译（内层换成中文、外层留英文）。
	var/objective_line = "Prevent Kabu Weien, the Cargo Technician, from escaping alive."
	var/objective_out = lang_template_apply(objective_line, LANGUAGE_LOCALE_ZH_HANS)
	TEST_ASSERT_NOTEQUAL(objective_out, objective_line, "反派目标行应被模板逆匹配整条翻译")
	TEST_ASSERT(!findtext(objective_out, "from escaping alive"), "不应只翻一半、留下英文残句：[objective_out]")

	// ⑥ 两段**运行期追加后缀**被 jointext 拼在一起（职业描述的 antag opt-in 段）。两段各自都是
	// 目录键、也都译好了，拼起来的整串不是键 → 只能靠字面 AC 分别做子串替换。分层断言：
	// 先确认闸门放行（能进 AC 字典），再确认整条真的被替换。
	// 漏翻采集里它长期以「基础句已是中文、后缀整段英文」的形态出现。
	TEST_ASSERT(lang_fallback_pattern_safe(" Targetable by contractors."), "该后缀应能进 AC 字典（多词 + 句末标点）")
	var/joined_suffix = " Targetable by contractors. Targetable by heretics."
	var/joined_out = lang_fallback_apply(joined_suffix, LANGUAGE_LOCALE_ZH_HANS)
	TEST_ASSERT(!findtext(joined_out, "Targetable by"), "拼接后的两段后缀应各自被 AC 替换：[joined_out]")
	// ⑥b 真实形态是「基础句 + 两段后缀」拼成一整行。基础句是**带占位符的模板**，模板引擎会命中它；
	// 而链在模板命中后**提前返回**、不再跑 AC → 同一串里剩下的英文永远落不了地。
	// 症状：基础句已是中文、后缀整段英文（漏翻采集里长期就是这个形态）。
	var/opt_in_line = "Forces a minimum of Yes - Kill antag opt-in. Targetable by contractors. Targetable by heretics."
	var/opt_in_out = lang_fallback_apply(opt_in_line, LANGUAGE_LOCALE_ZH_HANS)
	TEST_ASSERT(!findtext(opt_in_out, "Targetable by"), "模板命中之后，同一串里剩下的英文仍应过 AC：[opt_in_out]")
	// ⑥b2 **带前导空格**的同一串。目录模板是 `" Forces a minimum of {0} antag opt-in."`（前导空格是
	// 字面段的一部分），少一个空格锚就匹配不上、于是上面那条走了 AC 全都翻掉、看着是通过的。
	// 真实调用（lang_localize_job_description 把三段后缀一起喂进来）带着那个空格 → 模板命中
	// → 链**提前返回**、AC 不再跑 → 后两段纯串后缀永远英文。
	// 一个空格的差别就能让测试走另一条路 —— 照抄真实形态，别手写等价物。
	var/opt_in_spaced = " Forces a minimum of Yes - Kill antag opt-in. Targetable by contractors. Targetable by heretics."
	var/opt_in_spaced_out = lang_fallback_apply(opt_in_spaced, LANGUAGE_LOCALE_ZH_HANS)
	TEST_ASSERT(!findtext(opt_in_spaced_out, "Targetable by"), "模板命中之后，同一串里剩下的英文仍应过 AC：[opt_in_spaced_out]")
	// ⑥c 漏翻日志里**逐字节**的那一行：基础句已经由 LANG 路径翻成中文，后缀还是英文。
	// 前两条都过而线上仍漏，说明差别就在「输入里已经混着中文」这一点上——照抄真实形态才测得出。
	var/mixed_line = "强制至少是 - 杀死名玩家选择反派身份。 Targetable by contractors. Targetable by heretics."
	var/mixed_out = lang_fallback_apply(mixed_line, LANGUAGE_LOCALE_ZH_HANS)
	TEST_ASSERT(!findtext(mixed_out, "Targetable by"), "中英混排行里的英文后缀仍应被 AC 替换：[mixed_out]")

	// ⑥d AC 字典的**建表时序**：i18n_cache 还没就绪时 lang_build_reverse 会「返回空表但不缓存」，
	// 而 lang_fallback_setup 从前拿到空表就把 state 钉成 "none" —— 那是**永久**的，整局字面 AC
	// 无声关闭。这里模拟那一刻：清掉 state 与 cache 再 setup，必须**不写 state**（留待下次重试）。
	var/list/saved_cache = GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][LANGUAGE_LOCALE_ZH_HANS]
	// 这一格**故意**制造「目录未就绪」，会撞响 lang_fallback_setup 的早调用哨兵；
	// 而 stack_trace 在单测里算 runtime = 直接判失败。先把告警配额打满，测完复原。
	var/saved_warnings = GLOB.i18n_fallback_early_warnings
	GLOB.i18n_fallback_early_warnings = I18N_MAX_EARLY_WARNINGS
	GLOB.i18n_fallback_state -= LANGUAGE_LOCALE_ZH_HANS
	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET] -= LANGUAGE_LOCALE_ZH_HANS
	TEST_ASSERT(!lang_fallback_setup(LANGUAGE_LOCALE_ZH_HANS), "目录未就绪时 setup 应返回 FALSE")
	TEST_ASSERT(isnull(GLOB.i18n_fallback_state[LANGUAGE_LOCALE_ZH_HANS]), "目录未就绪时**不得**把 state 钉成 none —— 那会让整局 AC 永久关闭")
	GLOB.i18n_catalogs[I18N_CATALOG_FORWARD_BUCKET][LANGUAGE_LOCALE_ZH_HANS] = saved_cache
	GLOB.i18n_fallback_state -= LANGUAGE_LOCALE_ZH_HANS
	TEST_ASSERT(lang_fallback_setup(LANGUAGE_LOCALE_ZH_HANS), "目录就绪后 setup 应能重新建起字典")
	GLOB.i18n_fallback_early_warnings = saved_warnings

	GLOB.i18n_server_locale = saved_locale

/datum/unit_test/i18n_reverse_ambiguity

/datum/unit_test/i18n_reverse_ambiguity/Run()
	var/list/seen = list()
	var/list/origins = list()
	var/list/ambiguous = list()
	var/list/output = list()
	var/source = "Zxqv shared source"

	lang_add_forward_reverse_value(seen, origins, ambiguous, output, source, source, "untranslated key")
	TEST_ASSERT(isnull(output[source]), "未译 identity 候选不应污染全局反查")
	lang_add_forward_reverse_value(seen, origins, ambiguous, output, source, "甲", "datum key")
	TEST_ASSERT_EQUAL(output[source], "甲", "单一 forward 候选应进入全局反查")
	lang_add_forward_reverse_value(seen, origins, ambiguous, output, source, "乙", "obj key")
	TEST_ASSERT(isnull(output[source]), "不同上下文译文不得按文件顺序任选一个进入全局反查")
	TEST_ASSERT_EQUAL(length(ambiguous[source]), 2, "歧义来源必须保留两个 origin 供诊断")

	// 显式 global_reverse 条目是维护者给出的 canonical 决策，可以接管歧义源串。
	seen -= source
	origins -= source
	lang_add_domain_value(seen, origins, output, source, "规范译文", I18N_DOMAIN_GLOBAL_REVERSE, "manual override")
	TEST_ASSERT_EQUAL(output[source], "规范译文", "显式 global_reverse 条目应能解决 forward 歧义")

	var/list/norm_origins = list()
	var/list/norm_ambiguous = list()
	var/list/norm_output = list()
	lang_add_normalized_reverse(norm_output, norm_origins, norm_ambiguous, "zxqv shared alias", "甲", "first source")
	lang_add_normalized_reverse(norm_output, norm_origins, norm_ambiguous, "zxqv shared alias", "乙", "second source")
	TEST_ASSERT(isnull(norm_output["zxqv shared alias"]), "冲突的归一化别名必须被省略，不能按目录顺序任选")
	TEST_ASSERT_EQUAL(length(norm_ambiguous["zxqv shared alias"]), 2, "归一化冲突必须保留来源供诊断")
