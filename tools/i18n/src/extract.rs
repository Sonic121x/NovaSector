//! DM 字符串抽取。
//!
//! 解析复用 SpacemanDMM 的 dreammaker 解析器（API 与 DreamChecker 一致）。
//! 抽取来源：
//!   1. 类型变量初始化里的玩家可见文本（SINK_VARS：name/desc 等，动态渲染文本主要来源）。
//!   2. proc 体内的汇聚点调用（SINK_CALLS：to_chat / visible_message / balloon_alert 等）。
//! 内插字符串 (Term::InterpString) 与字符串 `+` 拼接被转为 {0}/{1} 占位符模板，
//! 以适配中文语序；span_* 等宏在预处理期已展开为 HTML 包裹 + 内层文本的拼接，
//! 其纯标签片段（如 "<span class='notice'>"）会被过滤掉，只留可翻译文本。
//!
//! 本阶段只做抽取（产出英文主目录）；改写调用点为 LANG/LANGU 是后续阶段。

use anyhow::{Context as _, Result};
use std::collections::HashSet;
use std::path::Path;

use dm::ast::{AssignOp, Expression, Follow, Statement, Term};

use crate::catalog::Catalog;
use crate::keys::{make_key, namespace_for};
use crate::template::{build_template, placeholder_count};

/// 视为玩家可见的变量名。
/// message_* 系列是 /datum/emote 的各形态表情模板（人形/默剧/外星/AI/机器人等），玩家在聊天
/// 高频可见；它们是 var 赋值而非 sink 调用，靠抽取进目录 + /datum/emote/New() 整串反查落地。
const SINK_VARS: &[&str] = &[
    "name",
    "desc",
    "message",
    // /datum/emote 的按物种/形态分支消息：select_message_type() 按 user 选用哪一条，最终都汇到
    // run_emote 的输出边界反查。只列了 message 而漏掉这些分支 → 哑剧演员/异形/赛博格/AI/猴子
    // 的表情整类没进目录、runechat 全英文。不含 message_param（含 %t，由 select_param 在运行期
    // 填入玩家输入，拼完的整串不可能命中目录，得另想办法）。
    "message_mime",
    "message_alien",
    "message_larva",
    "message_robot",
    "message_AI",
    "message_monkey",
    "message_animal_or_basic",
    "flavor_text",
    "title",
    // 其它可靠的玩家可见显示字段（type 变量；非 desc 的别名 / 专有显示串）。
    "description",      // /datum/reagent 等用 description（非 desc）——之前完全漏抽。
    "taste_description", // 试剂味道（"It tastes of …"）。
    // /datum/disease 的两个纯显示字段：form（"Advanced Disease"，医疗扫描的「Warning: … detected」）、
    // agent（"advance microbes"，病毒学面板的病原体名）。全仓无 `== ` 比较，翻显示安全。
    "agent",
    "form",
    // 实验扫描仪的进度行覆盖文案（/datum/experiment/scanning 的 scan_message）：纯显示，
    // 经 TGUI 负载下发，由边界模板引擎落地。
    "scan_message",
    // 污染物气味（Nova pollution 模块）："空气里飘着淡淡的 [scent]" 那句的插值值。纯显示，
    // 与 taste_description 同类。descriptor 那一侧是 #define 常量、走 _state_words。
    "scent",
    // NIFSoft 程序描述（modular_nova 植入物模块，19 处）：在植入物界面里整段展示给玩家，
    // 与 /datum/reagent 的 description 同类，只是换了个变量名 → 整类没进目录
    // （"Connects the user's brain to a database containing the current monetary values…"）。
    "program_desc",
    // ghostrole_on_revive 的招募标题（"a recovered crewmember"）：渲染进「你想扮演 X 吗？」
    // 的询问句，是纯显示短语。
    "revive_title",
    "display_name",     // 机器/发射台等的展示名。
    "wiki_desc",        // wiki 界面描述。
    "war_declaration",  // 核弹战争宣言（全员公告）。
    "explanation_text", // /datum/objective 反派目标文本（反派面板 + 授予时聊天）。
    // /datum/job 的「上级」短语（"Nanotrasen officials and Space Law"/"the Captain"…）：spawn 介绍
    // 「你直接听命于 [supervisors]」行的插值值。模板已译、边界引擎捕获 [supervisors] 为 {N} 后经
    // lang_localize_arg→lang_reverse_text 翻译 → 必须入目录。短语无句末标点，激进 pass 抽不到，故列此。
    "supervisors",
    // /datum/personality 玩法效果行（特质与个性→人格 tab 卡片里的 ±/+/- 描述；经偏好常量 asset 渲染，
    // 由 master_files/code/modules/client/preferences/assets.dm 的 lang_reverse_pref_descriptions 反查）。
    "pos_gameplay_desc",
    "neg_gameplay_desc",
    "neut_gameplay_desc",
    // ② 类「type 变量里的整条消息，经 to_chat 发出」——多为 span_*() 包裹，抽取得到内层文本，
    // 运行时靠聊天 AC 子串层（I18N_CHAT_FALLBACK）在包裹串里命中替换（整串反查会因 span 包裹不匹配）。
    "gain_text",        // 脑创伤等获得时消息（45 处）。
    "lose_text",        // 失去时消息。
    "playstyle_string", // 特殊角色玩法说明。
    // /datum/disease 玩家可见字段（医疗/疫病 UI）。
    "cure_text",
    "spread_text",
    // 物种「占位」描述/背景（大多数未撰写 lore 的物种用 /datum/species 上这两个公共字面量；
    // get_species_description/lore 各自 `return placeholder_description` / `return list(placeholder_lore)`
    // —— 返回的是**变量引用**，proc-return 抽取（build_template/emit_list_strings）解析不出字面量值，
    // 故必须在此按类型变量抽其初始值。运行时 species.dm compile_constant_data 反查落地）。
    "placeholder_description",
    "placeholder_lore",
    // 书本初始标题/正文（/obj/item/book/manual 等；运行时在 book.dm Initialize 整串反查落地）。
    "starting_title",
    "starting_content",
    // /obj 的操作说明（examine 里 `. += span_notice(desc_controls)`，如「Left click to stun, …」；
    // 运行时在 objs.dm examine 处 lang_reverse_text 反查）。
    "desc_controls",
    // 自定义 examine 文本变量：运行时被赋给 desc（在 examine 显示点 lang_reverse_text(desc) 反查落地）。
    // 这类「type 变量持有 examine 文本、运行期 desc=该变量」漏抽长尾——dry_desc（血迹/痕迹变干后的描述）等。
    "dry_desc",
    "extended_desc",
    // 手术操作（/datum/surgery_operation）的**展示**名/描述：手术计算机发 `rnd_name || name` /
    // `rnd_desc || desc`，rnd_name 含手术类别（"Lobectomy (Lung Surgery)"），rnd_desc 是机械版描述。
    // 这两个不是 name/desc → 之前漏抽 → 手术目录里操作名/描述整片英文。运行时在 operating_computer.dm
    // 落地点反查（display-only；搜索/置顶用同一展示名、无英文常量比较=安全）。
    "rnd_name",
    "rnd_desc",
    // ID 卡职务（/datum/id_trim、卡片等的 assignment；HUD/检视/模块服「分配」显示）。多为职业名、
    // 但 Nova 专属职务（"Bluespace Technician" 等）非 job datum → 漏抽。display-only（显示在 ID/HUD）。
    "assignment",
    // 股市事件新闻（/datum/stock_market_event）：经济报告里拼接的 "公司 情况描述 材料" 串。
    // company_name（公司名 list）/ circumstance（情况短语 list）非 name/desc → 漏抽 → 新闻整段英文。
    // 运行时在 create_news 落地点逐成分反查。
    "company_name",
    "circumstance",
    // 售货机出货答谢语（vend_reply，单句，say 出 → 聊天 AC 翻译）。
    "vend_reply",
    // 幽灵生成器（/obj/effect/mob_spawn/ghost_role）的入场介绍三件套：mob_spawn.dm 把它们拼进
    // 一条 to_chat（「你是一名维修无人机」/背景/「你**必须**仔细阅读法则」）。注意 flavour_text
    // 是英式拼写——列表里原有的 flavor_text 是另一个字段，看着像已覆盖，实则整类幽灵角色的入场
    // 文字一条都没抽到。运行时靠聊天 AC 子串层落地。
    "you_are_text",
    "flavour_text",
    "important_text",
    // 说话动词（says/asks/exclaims/whispers/sings/yells 及各 mob 变体如 beeps/signs/hisses；
    // 运行时在 say.dm 的 say_quote 整串反查落地）。
    "verb_say",
    "verb_ask",
    "verb_exclaim",
    "verb_whisper",
    "verb_sing",
    "verb_yell",
    // 攻击动词（每物品/生物：punches/slashes/bites… 连续式 与 punch/slash/bite 简单式）：近战/投掷消息模板
    // 里以 `[user.attack_verb_continuous]` 插值 → LANG 模板的 {N} 实参，经 lang_localize_arg→lang_reverse_text 翻；
    // 之前未抽 → 战斗消息里动词残留英文（「军团 bites 了你！」）。display-only（仅消息显示，非比较/标识符）。
    "attack_verb_continuous",
    "attack_verb_simple",
    // /datum/emote 表情模板变体。
    "message_mime",
    "message_alien",
    "message_larva",
    "message_robot",
    "message_AI",
    "message_monkey",
    "message_animal_or_basic",
    "message_param",
    // /obj/item/stack 的单数名（"cable piece"/"metal"/"glass"…）：堆叠数量行 LANG 模板的 {1} 实参
    // （"There are [n] [singular_name]\s in the stack."），经 lang_localize_arg→lang_reverse_text 翻；
    // 之前未抽 → 数量行里物品名残留英文（如「30 cable piece」）。
    "singular_name",
    // /obj/item/seeds 的 plantname（"Apple Tree"/"Sugarcane"/"Potato Plants"…）：植物分析仪/托盘显示的
    // 植物名，非 name（name 是种子包名）→ 之前漏抽。落地点（plant_analyzer ui_data）也 lang_reverse_text。
    "plantname",
    // /datum/wound 的玩家可见文本（受伤/检视/治疗）：战斗里高频显示（"X's chest is cut open, slowly
    // leaking blood!" 等）。occur_text=受伤时整句、examine_desc=检视伤口、*treat_text=治疗说明。非
    // name/desc → 之前漏抽 → 战斗伤口描述整片英文。多词整句，运行时经 to_chat 聊天 AC 子串层翻译。
    "occur_text",
    "examine_desc",
    "treat_text",
    "treat_text_short", // 健康分析仪伤口条的悬浮治疗提示（scanner tooltip）——漏抽（其它 *treat_text 都在）。
    "simple_treat_text",
    "homemade_treat_text",
];
// 注：基础 mob 闲聊池 speak/emote_hear/emote_see 不在 SINK_VARS——它们是 list 初值，
// 走专门的 is_speech_pool 分支（emit_list_strings 逐元素抽），见变量抽取处。

/// 「句子型」玩家可见文案启发式：多词自然语句（含空格 + 首字母大写 + 含小写字母 + 无占位符）。
/// 用于把「不在 sink 调用处」的玩家可见静态串（config_entry 公告默认值、具名累加器 examine 句）
/// 抽进目录，靠聊天 AC 子串层翻译。含 {0} 的插值模板排除（那需 LANG 改写、且会被 AC 守卫跳过）。
/// examine 信号处理器（COMSIG_ATOM_EXAMINE）的累加器参数名——`examine_list += "…"` 等，
/// 是 examine 输出、必玩家可见，与裸 `.` 同等处理（全抽 + 改写为 LANG）。
/// 当前所在 proc 的语义标记。决定「裸 `.`」和具名累加器该怎么解读。
#[derive(Clone, Copy)]
pub struct ProcCtx {
    /// update_overlays 等：裸 `.` 累加的是 icon_state/标识符，不是文案。
    pub ident: bool,
    /// 「显示描述符」proc：整个 proc 的 return 字面量都是给玩家看的短语。
    pub display_return: bool,
    /// examine 家族：proc 体内**任何**具名累加器收到的字面量都是给玩家看的 examine 行。
    /// 原来只认一张手写的变量名白名单（examine_list/combined_msg/…），于是
    /// `how_cool_are_your_threads += "[src]'s storage opens when…"` 这种局部名一路漏到
    /// 玩家眼前。按 proc 语义界定比按变量名穷举稳，也不会漏到 examine 之外。
    pub examine: bool,
}

/// examine 家族 proc：输出**一定**是玩家可见的检查文本。
pub fn is_examine_proc(proc_name: &str) -> bool {
    matches!(proc_name, "examine" | "examine_more" | "examine_tags")
        || proc_name.starts_with("on_examine")
}

/// 「显示描述符」proc：材料属性等把玩家可见短语从 switch 里 `return` 出来（"very rigid"、
/// "slightly reactive"…）。这些短语无句末标点、首字母小写，激进 pass 的整句闸一律挡掉，于是
/// 材料详检那一长串形容词整类没进目录。按 **proc 名**界定（同 examine 家族的做法），
/// 比按变量名穷举稳。
pub fn is_display_descriptor_proc(proc_name: &str) -> bool {
    matches!(proc_name, "get_descriptor" | "get_tooltip")
}

/// 玩家可见的「显示字段」名：这些字段在 proc 里被 `+=` 追加时，追加内容一定是给玩家看的
/// （desc 补充说明、幽灵角色入场文字的分支段落…），不受整句闸的首字母大写要求限制。
/// `name` 不在其中——它常被 `if(name == "…")` 比较。
pub fn is_display_accumulator_var(id: &str) -> bool {
    matches!(id, "desc" | "description" | "flavour_text" | "flavor_text")
}

pub fn is_examine_accumulator(id: &str) -> bool {
    matches!(
        id,
        // examine 信号处理器累加器 + 自我检查/体检累加器（combined_msg=自我检查、check_list=肢体伤情，
        // 均 `+= span_*("…")` 拼成 to_chat 的玩家可见体检报告）。
        // readout=武器战斗信息标签（weapon_description/baton 等 11 文件，`readout += "…"` 拼成 to_chat 的
        // 「See combat information」面板，含「约需 {0} 击倒敌人」等插值行 → 改 LANG 才能翻插值结构）。
        "examine_list" | "examine_text" | "examine_strings" | "combined_msg" | "check_list" | "readout"
    )
}

/// examine 家族 proc 里具名累加器字面量的准入闸门。
///
/// 比 `is_sentence_like` 松一点：**允许插值占位符**（`{0}'s storage opens when…` 正是要抽的，
/// 它必须走 LANG 才能翻出插值结构）。但仍要求整句形态，否则 examine proc 里那些拼句用的碎片
/// 会被当独立条目抽走——`" and "`、`" (good)"`、`"{0} glass sheets "` 各自翻译只会拼出语序错乱
/// 的中文，而 `"\"nuclear_disk\"."` 之流本就是标识符。
///
/// 三条：含空格；首字符是大写字母或占位符（排除碎片与续写片段）；去掉尾部 `\n`/空白后以句末
/// 标点收尾（排除 `"{0}: {1}\" class=\"tooltip\">{2}"` 这种 HTML 属性片段与半截从句）。
/// 把 `a + b + c` 的字符串拼接链摊平成各操作数；非拼接表达式返回空（调用方另有整条链的处理）。
/// 只在链里**确实有多段文本**时才拆——单段链整条抽就够了，拆了反而多出重复键。
/// 摊平 `"[span_notice("…")]"` —— 内插串里嵌着的表达式。
///
/// `. += "[span_notice("[desc] - growth progress: [growth]%")]"` 这种写法，整条
/// `build_template` 只会得到一个光杆 `{0}`（内插位置就是占位符），真正的句子藏在被插的表达式里，
/// 于是整行漏抽。把嵌入表达式拿出来各自抽一遍。
fn split_interp_parts(expr: &Expression) -> Vec<&Expression> {
    let Expression::Base { term, follow } = expr else {
        return Vec::new();
    };
    if !follow.is_empty() {
        return Vec::new();
    }
    let Term::InterpString(lead, parts) = &term.elem else {
        return Vec::new();
    };
    // **只认「整条就是一个内插」这一种形状**（`"[span_notice("…")]"`：lead 与各段尾巴都是空的）。
    //
    // 放宽到任意内插会捅穿 build_template 的一道正经防线：它对整条去标签后不含字母的表达式返回
    // None。VV 管理面板的 `VV_DROPDOWN_OPTION` 展开成 `"<option value='…[cmd]…'>[name]</option>"`,
    // 正是靠这条被挡在目录外——里面的 [cmd] 是 admin 操作标识符，抽进目录、再被反查改掉就等于
    // 把 VV 面板弄坏。那种形状 lead 非空，这里直接不碰。
    if !lead.as_str().trim().is_empty() {
        return Vec::new();
    }
    if parts.iter().any(|(_, lit)| !lit.trim().is_empty()) {
        return Vec::new();
    }
    let embedded: Vec<&Expression> = parts.iter().filter_map(|(opt, _)| opt.as_ref()).collect();
    if embedded.len() != 1 {
        return Vec::new();
    }
    embedded
}

fn split_concat_parts(expr: &Expression) -> Vec<&Expression> {
    fn flatten<'e>(e: &'e Expression, out: &mut Vec<&'e Expression>) {
        if let Expression::BinaryOp { op: dm::ast::BinaryOp::Add, lhs, rhs } = e {
            flatten(lhs, out);
            flatten(rhs, out);
        } else {
            out.push(e);
        }
    }
    let mut parts = Vec::new();
    flatten(expr, &mut parts);
    if parts.len() < 2 {
        return Vec::new();
    }
    parts
}

fn is_examine_sentence(t: &str) -> bool {
    let trimmed = t.trim();
    if !trimmed.contains(' ') || !trimmed.chars().any(|c| c.is_ascii_lowercase()) {
        return false;
    }
    let starts_ok = trimmed.starts_with('{')
        || trimmed.chars().next().is_some_and(|c| c.is_ascii_uppercase());
    if !starts_ok {
        return false;
    }
    let body = trimmed.trim_end_matches(|c: char| c.is_whitespace());
    let body = body.strip_suffix("\\n").unwrap_or(body).trim_end();
    matches!(body.chars().last(), Some('.') | Some('!') | Some('?') | Some(':'))
}

fn is_sentence_like(s: &str) -> bool {
    let s = s.trim();
    s.contains(' ')
        && !s.contains('{')
        && s.chars().next().is_some_and(|c| c.is_ascii_uppercase())
        && s.chars().any(|c| c.is_ascii_lowercase())
}

/// 去掉模板里的 {N} 占位符（保留其余字面，含非占位符花括号）。
fn strip_placeholders(t: &str) -> String {
    let mut out = String::new();
    let mut chars = t.chars().peekable();
    while let Some(c) = chars.next() {
        if c == '{' {
            let mut probe = chars.clone();
            let mut had_digit = false;
            while probe.peek().is_some_and(|d| d.is_ascii_digit()) {
                probe.next();
                had_digit = true;
            }
            if had_digit && probe.peek() == Some(&'}') {
                probe.next();
                chars = probe;
                continue;
            }
        }
        out.push(c);
    }
    out
}

/// 激进 pass 的「句子型」判定（**允许占位符**，与 is_sentence_like 不同）：玩家可见整句的形态
/// 特征——多词、含小写、句末标点收尾、首字母大写或以占位符开头（"[user] does X."）。
/// **句末标点要求是安全闸门**：act 标识符/枚举名/路径/SQL/keybind 名都不带句末标点 → 不会进
/// 目录 → 不会经反查表/边界引擎被误翻（「标识符耦合显示名」类回归的防线）。
/// 抽进目录后纯串走反查表+字面 AC、插值模板走边界模板逆匹配引擎（template_match.dm）显示，
/// 无需改写调用点——这是 ②类「拼进变量再输出」的系统性出口。
/// 构建 icon_state/标识符/日志串的 proc：这些 proc 里 bare-`.` 累加的字符串**不是玩家可见文本**
/// （update_overlays 的 overlay icon_state、key_name 的 ckey 日志串、rights2text 的权限旗标…），
/// 抽取/LANG 化会直接破坏图像与日志（实测：`{0}_mag` 被 MT 翻成 `{0}_弹匣` → 弹匣 overlay 消失）。
/// 整 proc 排除 bare-`.`/累加器抽取与改写（其余 sink 不受影响）。
/// 清单来自三端策略单一来源 strings/i18n/policy.json 的 `identifier_dot_procs` /
/// `identifier_dot_proc_suffixes`（历史沿革与实例见 policy.json 注释字段：StripMenu 键被译即蓝屏、
/// `{0}_mag` 被译弹匣 overlay 消失）。新增登记只改 policy.json。
pub fn is_identifier_dot_proc(name: &str) -> bool {
    let policy = identifier_policy();
    policy.names.contains(name) || policy.suffixes.iter().any(|s| name.ends_with(s.as_str()))
}

struct IdentifierPolicy {
    names: std::collections::HashSet<String>,
    suffixes: Vec<String>,
}

fn identifier_policy() -> &'static IdentifierPolicy {
    static POLICY: std::sync::OnceLock<IdentifierPolicy> = std::sync::OnceLock::new();
    POLICY.get_or_init(|| {
        // 从仓库根或 tools/i18n（cargo test 的 CWD）都能找到。
        for candidate in ["strings/i18n/policy.json", "../../strings/i18n/policy.json"] {
            let Ok(text) = std::fs::read_to_string(candidate) else {
                continue;
            };
            let Ok(json) = serde_json::from_str::<serde_json::Value>(&text) else {
                continue;
            };
            let read_list = |field: &str| -> Vec<String> {
                json[field]
                    .as_array()
                    .map(|a| {
                        a.iter()
                            .filter_map(|v| v.as_str().map(str::to_string))
                            .collect()
                    })
                    .unwrap_or_default()
            };
            return IdentifierPolicy {
                names: read_list("identifier_dot_procs").into_iter().collect(),
                suffixes: read_list("identifier_dot_proc_suffixes"),
            };
        }
        eprintln!("警告: 找不到 strings/i18n/policy.json —— identifier_dot_procs 黑名单为空，抽取/改写可能误收 icon_state 串");
        IdentifierPolicy {
            names: Default::default(),
            suffixes: Default::default(),
        }
    })
}

/// 选项/按钮列表累加器（`send_off_options += "Send to custom"` 等）：元素是 tgui_alert/
/// tgui_input_list 的 act 回传标识符，进目录会被 lint 判碰撞（is_sentence_like 无句末标点闸，
/// "Send to custom" 这类短语能穿过）。按变量名后缀排除。
fn is_option_accumulator(id: &str) -> bool {
    id.ends_with("options") || id.ends_with("choices") || id.ends_with("buttons")
        || id.ends_with("items")
}

/// 实参是否为 perform_emote / perform_speech 类 AI 行为类型路径（任一路径段命中即可，
/// 兼容子类型如 /datum/ai_behavior/perform_speech/xxx）。供 queue_behavior 专项抽取判别。
fn is_speech_behavior_path(expr: &Expression) -> bool {
    let Expression::Base { term, follow } = expr else {
        return false;
    };
    if !follow.is_empty() {
        return false;
    }
    let Term::Prefab(prefab) = &term.elem else {
        return false;
    };
    prefab.path.iter().any(|(_, seg)| {
        let seg = seg.as_str();
        seg.starts_with("perform_emote") || seg.starts_with("perform_speech")
    })
}

fn is_loose_sentence(template: &str) -> bool {
    let lit_raw = strip_placeholders(template);
    let lit_stripped = crate::template::strip_tags(&lit_raw);
    let lit = lit_stripped.trim();
    if lit.len() < 10 || !lit.contains(' ') {
        return false;
    }
    // 「必须含小写」原本是排标识符/枚举/define 值的粗闸，但它连坐掉了**整整一类**玩家可见文本：
    // SS13 的控制台状态行、广播警报、广告词、喊话全是全大写
    // （`OPERATION FAILED: CANNOT PROBE WHEN BUFFER FULL.` / `BLUESPACE ARTILLERY MALFUNCTION!`
    // / `24-HOUR PIZZA PIE POWER!`）——实测 154 条一条没抽到，玩家报的电信控制台漏译就是这么来的。
    // 全大写放行的额外闸：至少 3 个「词」（≥2 字母），标识符/枚举名不会长成这样，且句末标点
    // 那道闸仍在下面把 SQL/路径/define 值挡在外面。
    if !lit.chars().any(|c| c.is_ascii_lowercase()) {
        let words = lit
            .split_whitespace()
            .filter(|w| w.chars().filter(|c| c.is_ascii_alphabetic()).count() >= 2)
            .count();
        if words < 3 {
            return false;
        }
    }
    let end = lit.trim_end_matches(['"', '\'', ')', ']', '*']);
    if !(end.ends_with(['.', '!', '?', '…']) || end.ends_with("...")) {
        return false;
    }
    let first = lit.chars().next().unwrap();
    first.is_ascii_uppercase() || template.trim_start().starts_with('{')
}

/// 非玩家可见的汇聚点（日志/调试/管理员后台/外部 relay）：其实参不进激进抽取——
/// 写文件的日志必须保持英文，且省 MT。仅抑制激进 pass，不影响既有 sink/累加器抽取路径。
fn is_non_player_sink(name: &str) -> bool {
    name.starts_with("log_")
        || matches!(
            name,
            "stack_trace"
                | "investigate_log"
                | "record_feedback"
                | "message_admins"
                | "send2adminchat"
                | "send2chat"
                | "send2tgs"
                | "testing"
                | "warning"
                | "add_memory_in_range" // 日志型记忆键
        )
}

/// 「安全可改名」的 verb 命令面板显示名启发式（verb 的 `set name = "X"`）。
/// verb 名是 BYOND 编译期元数据、无法运行时按 locale 切换，只能编译期注入译文（见 rewrite::run_verbs）。
/// 仅放行**首字母大写**的显示名（命令面板/右键菜单可见，由面板按名调用，改名自洽）；
/// 排除 keybind/宏按名调用的标识符 verb（以 `.` 开头如 .click、纯小写、小写连字符如 body-chest/
/// quick-equip——被外部按名引用，改名会断快捷键/宏），以及数字前缀 debug 名与含占位符的。
///
/// 「首字母大写」判定前先剥掉**符号装饰前缀**：表情面板用 `> Burp` / `~ Blush` / `| Flip |` 标注
/// 发声/可见/特殊三类，硅基音效用 `< Ping >`，另有 `(Taur) Toggle Laying Down`。不剥的话这
/// 三类共 ~170 条 verb 一条都抽不到（实测：表情/表情+ 两个页签整片英文）——是**遍历缺口**，
/// 不是逐条漏译。装饰符不可能出现在 keybind/宏标识符里（那些形如 .click / body-chest /
/// quick-equip / toggle-walk-run，首字符是 `.` 或小写字母），故剥前缀不会放宽对它们的排除。
/// 裸字符串字面量原样取出（不过 build_template 的「去 HTML 标签后须含字母」闸）。
///
/// 只给 verb 名用。`set name = "< Ping >"` 这类硅基音效表情名会被 strip_tags 当成 HTML 标签
/// 整体剥光 → 去标签后无字母 → build_template 返回 None → 22 条一条都抽不到（实测表情页签
/// 里 `< Alarm >`…`< Slow Clap >` 整片英文）。verb 名是命令面板显示名，永远不会是 HTML 标记，
/// 所以这里直接取字面量。不动 build_template 本身——它是抽取/改写算 key 的唯一真相来源，
/// 改它的判据会牵动整个目录。
pub(crate) fn plain_string(expr: &Expression) -> Option<String> {
    match expr {
        Expression::Base { term, follow } if follow.is_empty() => match &term.elem {
            Term::String(s) => Some(s.clone()),
            _ => None,
        },
        _ => None,
    }
}

pub(crate) fn is_safe_verb_name(s: &str) -> bool {
    let s = s.trim();
    let undecorated = s.trim_start_matches(|c| matches!(c, '>' | '<' | '~' | '|' | '(' | ' '));
    !s.is_empty()
        && !s.contains('{')
        && !s.starts_with('.')
        && undecorated
            .chars()
            .next()
            .is_some_and(|c| c.is_ascii_uppercase())
        && s.chars().any(|c| c.is_alphabetic())
        // 必须是纯 ASCII：run_verbs 注入后源码里的 verb 名是中文，若此时跑 extract 会把**译文**
        // 当英文原文收进 en 目录，下一轮 MT 再译一遍 → 目录污染（实测遗留 "Fax 面板"/"End 弹"
        // 这类半中半英「英文」值，且 --revert 因 zh 一对多而歧义跳过、把中文留在源码里）。
        && s.is_ascii()
        // skin.dmf 宏按「连字符化 verb 名」调用（command = "open-escape-menu" 等）——这些 verb
        // 改名即断 ESC/全屏/状态栏快捷键（实测：注入中文后 ESC 菜单失灵）。与 interface/skin.dmf
        // 的 command 列表对应（`grep 'command = ' interface/skin.dmf`），新增宏 verb 在此登记。
        // 顶栏按钮 Hotkeys / Emotes 走 "Hotkeys-Help" / "Emote-Panel"，同样不能改名。
        && !matches!(
            s,
            "Open Escape Menu"
                | "Toggle Stat Panel"
                | "Toggle Fullscreen"
                | "Connect to Relay"
                | "Hotkeys Help"
                | "Emote Panel"
        )
}

/// 从 list 字面量里抽「多词字符串值」（用于 /datum/aas_config_entry 的 announcement_lines_map
/// 公告模板：`list("Message" = "%PERSON has signed up as %RANK")`）。取 assoc 的**值**(键如
/// "Message"/"RETA Granted" 不抽)；模板用 %VAR 占位符（含空格、无 {），运行时在 compile_announce
/// 用 lang_reverse_text 整条反查、再做 %VAR 替换。
fn emit_message_list(expr: &Expression, ns: &str, catalog: &mut Catalog) {
    let Expression::Base { term, follow } = expr else {
        return;
    };
    if !follow.is_empty() {
        return;
    }
    let args = match &term.elem {
        Term::List(args) => args,
        Term::Call(name, args) if name == "list" => args,
        _ => return,
    };
    for arg in args.iter() {
        let val_expr = if let Expression::AssignOp { rhs, .. } = arg {
            rhs.as_ref()
        } else {
            arg
        };
        if let Some(t) = build_template(val_expr) {
            if t.contains(' ') && !t.contains('{') {
                emit(catalog, ns, &t);
            }
        }
    }
}

/// 递归收集 proc 体里所有 `return <expr>` 的表达式（用于按 proc 名抽返回文本，如物种描述/背景）。
fn collect_returns<'a>(block: &'a [dm::ast::Spanned<Statement>], out: &mut Vec<&'a Expression>) {
    for stmt in block.iter() {
        match &stmt.elem {
            Statement::Return(Some(e)) => out.push(e),
            Statement::If { arms, else_arm } => {
                for (_cond, blk) in arms.iter() {
                    collect_returns(blk, out);
                }
                if let Some(blk) = else_arm {
                    collect_returns(blk, out);
                }
            }
            Statement::Switch { cases, default, .. } => {
                for (_c, blk) in cases.iter() {
                    collect_returns(blk, out);
                }
                if let Some(blk) = default {
                    collect_returns(blk, out);
                }
            }
            Statement::While { block, .. }
            | Statement::ForInfinite { block }
            | Statement::ForLoop { block, .. }
            | Statement::Spawn { block, .. } => collect_returns(block, out),
            _ => {}
        }
    }
}

/// 抽取 list 字面量里的全部字符串元素（物种 lore：`return list("段1", "段2", …)`，每段一条）。
fn emit_list_strings(expr: &Expression, ns: &str, catalog: &mut Catalog) {
    let Expression::Base { term, follow } = expr else {
        return;
    };
    if !follow.is_empty() {
        return;
    }
    let args = match &term.elem {
        Term::List(args) => args,
        Term::Call(name, args) if name == "list" => args,
        _ => return,
    };
    for arg in args.iter() {
        let val = if let Expression::AssignOp { rhs, .. } = arg {
            rhs.as_ref()
        } else {
            arg
        };
        if let Some(t) = build_template(val) {
            emit(catalog, ns, &t);
        }
    }
}

/// 抽取「物种特征(perk)」list 字面量里的 name/description 关联值（SPECIES_PERK_NAME/DESC 宏=这两键）。
/// 递归穿过嵌套 list / `+=` 拼接 / 赋值。静态串进目录；插值串（如 `[plural_form] are…`）抽成模板，
/// 运行时值已填占位符 → 反查不命中、无害（保持英文）。
fn emit_perk_strings(expr: &Expression, ns: &str, catalog: &mut Catalog) {
    match expr {
        Expression::Base { term, follow } if follow.is_empty() => {
            let args = match &term.elem {
                Term::List(args) => args,
                Term::Call(name, args) if name == "list" => args,
                _ => return,
            };
            for arg in args.iter() {
                if let Expression::AssignOp { lhs, rhs, .. } = arg {
                    if matches!(build_template(lhs).as_deref(), Some("name") | Some("description")) {
                        if let Some(t) = build_template(rhs) {
                            emit(catalog, ns, &t);
                        }
                    }
                    emit_perk_strings(rhs, ns, catalog);
                } else {
                    emit_perk_strings(arg, ns, catalog);
                }
            }
        }
        Expression::AssignOp { rhs, .. } => emit_perk_strings(rhs, ns, catalog),
        Expression::BinaryOp { lhs, rhs, .. } => {
            emit_perk_strings(lhs, ns, catalog);
            emit_perk_strings(rhs, ns, catalog);
        }
        _ => {}
    }
}

/// 走 perk proc 体（名含 "perk"），对各语句的表达式应用 emit_perk_strings。
fn walk_perk_block(block: &[dm::ast::Spanned<Statement>], ns: &str, catalog: &mut Catalog) {
    for stmt in block.iter() {
        match &stmt.elem {
            Statement::Expr(e) | Statement::Return(Some(e)) => emit_perk_strings(e, ns, catalog),
            Statement::Var(v) => {
                if let Some(e) = &v.value {
                    emit_perk_strings(e, ns, catalog);
                }
            }
            Statement::Vars(vs) => {
                for v in vs.iter() {
                    if let Some(e) = &v.value {
                        emit_perk_strings(e, ns, catalog);
                    }
                }
            }
            Statement::If { arms, else_arm } => {
                for (_c, blk) in arms.iter() {
                    walk_perk_block(blk, ns, catalog);
                }
                if let Some(blk) = else_arm {
                    walk_perk_block(blk, ns, catalog);
                }
            }
            Statement::Switch { cases, default, .. } => {
                for (_c, blk) in cases.iter() {
                    walk_perk_block(blk, ns, catalog);
                }
                if let Some(blk) = default {
                    walk_perk_block(blk, ns, catalog);
                }
            }
            Statement::While { block, .. }
            | Statement::ForInfinite { block }
            | Statement::ForLoop { block, .. }
            | Statement::Spawn { block, .. } => walk_perk_block(block, ns, catalog),
            _ => {}
        }
    }
}

/// 走 generate_ion_law proc 体，抽全部赋值 RHS 的字符串模板（含插值 → {N}）。
/// 离子法则由 166 条 ALLCAPS 模板句 + strings/ion_laws.json 碎片池运行期拼装：模板无句末
/// 标点（激进 pass 的安全闸挡掉）、也不在 sink 里 → 专项全量抽。显示端由边界模板逆匹配
/// 引擎收口（TGUI 法则面板 exact miss → 模板命中 → 捕获碎片实参反查），碎片池另经
/// flavor 白名单入目录、strings 加载处反查。
fn walk_ion_templates(block: &[dm::ast::Spanned<Statement>], ns: &str, catalog: &mut Catalog) {
    for stmt in block.iter() {
        match &stmt.elem {
            Statement::Expr(Expression::AssignOp { rhs, .. }) => {
                if let Some(t) = build_template(rhs) {
                    emit(catalog, ns, &t);
                }
            }
            Statement::Var(v) => {
                if let Some(e) = &v.value {
                    if let Some(t) = build_template(e) {
                        emit(catalog, ns, &t);
                    }
                }
            }
            Statement::If { arms, else_arm } => {
                for (_c, blk) in arms.iter() {
                    walk_ion_templates(blk, ns, catalog);
                }
                if let Some(blk) = else_arm {
                    walk_ion_templates(blk, ns, catalog);
                }
            }
            Statement::Switch { cases, default, .. } => {
                for (_c, blk) in cases.iter() {
                    walk_ion_templates(blk, ns, catalog);
                }
                if let Some(blk) = default {
                    walk_ion_templates(blk, ns, catalog);
                }
            }
            Statement::While { block, .. }
            | Statement::ForInfinite { block }
            | Statement::ForLoop { block, .. }
            | Statement::Spawn { block, .. } => walk_ion_templates(block, ns, catalog),
            _ => {}
        }
    }
}

/// 走 examine_tags proc 体，抽 `.["tag"] = "悬浮提示文本"` 的字符串值。examine 标签的 hover
/// tooltip（玩家可见），是 IndexAssign 到返回列表 `.`（非 sink/累加器，常规 visit 漏掉）。递归穿控制流。
fn walk_examine_tags(block: &[dm::ast::Spanned<Statement>], ns: &str, catalog: &mut Catalog) {
    for stmt in block.iter() {
        match &stmt.elem {
            Statement::Expr(Expression::AssignOp { lhs, rhs, .. }) => {
                if let Expression::Base { term, follow } = lhs.as_ref() {
                    // `.[...] = "…"`（examine 返回列表）或 `examine_list[...] = "…"`（签名带 examine_list 的
                    // examine 信号处理器，如 slapcrafting 的 get_examine_info）。
                    let is_dot_index = matches!(&term.elem, Term::Ident(id) if id == "." || id == "examine_list")
                        && follow.len() == 1
                        && matches!(&follow[0].elem, Follow::Index(..));
                    if is_dot_index {
                        if let Some(t) = build_template(rhs) {
                            emit(catalog, ns, &t);
                        }
                        // **下标键也是玩家可见文案**。这是全仓唯一一处「assoc 键是显示串」的
                        // 合法形状：examine_tags 返回的 list 里，键是检查面板上那颗标签的文字、
                        // 值是它的悬停 tooltip（既有的 EXAMINE_TAG_* 宏同样是标签文字，早就在
                        // 目录里 —— 只有直接写字面量当键的写法整类漏掉，如 empprotection 的
                        // `examine_list["partially EMP blocking"] = …`）。
                        // 别处的下标键一律是程序查表用的键名，绝不能抽（见 visit_expr 里对
                        // Follow::Index 的整支跳过），所以这条只开在本 proc 语境内。
                        if let Follow::Index(_, idx) = &follow[0].elem {
                            if let Some(t) = build_template(idx) {
                                if !t.contains('{') {
                                    emit(catalog, ns, &t);
                                }
                            }
                        }
                    }
                }
            }
            Statement::If { arms, else_arm } => {
                for (_c, blk) in arms.iter() {
                    walk_examine_tags(blk, ns, catalog);
                }
                if let Some(blk) = else_arm {
                    walk_examine_tags(blk, ns, catalog);
                }
            }
            Statement::Switch { cases, default, .. } => {
                for (_c, blk) in cases.iter() {
                    walk_examine_tags(blk, ns, catalog);
                }
                if let Some(blk) = default {
                    walk_examine_tags(blk, ns, catalog);
                }
            }
            Statement::While { block, .. }
            | Statement::ForInfinite { block }
            | Statement::ForLoop { block, .. }
            | Statement::Spawn { block, .. } => walk_examine_tags(block, ns, catalog),
            _ => {}
        }
    }
}

/// 汇聚点 proc 名 -> 其消息参数下标。
fn sink_message_args(name: &str) -> Option<&'static [usize]> {
    match name {
        "to_chat" => Some(&[1]),
        "balloon_alert" => Some(&[1]),
        // 群发气泡警告：balloon_alert_to_viewers(message, self_message, …) / _to_hearers 同签名。
        // [0]=观众消息 [1]=自身消息，均玩家可见（如阀门 "valve opened"）。与 rewrite.rs 同表。
        "balloon_alert_to_viewers" => Some(&[0, 1]),
        "balloon_alert_to_hearers" => Some(&[0, 1]),
        "visible_message" => Some(&[0, 1, 2]), // [2]=blind_message（盲人可见）。
        "audible_message" => Some(&[0, 1, 3]),
        "say" => Some(&[0]),
        "manual_emote" => Some(&[0]),
        // 提示/对话框（玩家可见）。只取消息+标题；按钮/选项列表/返回值不动，
        // 以免破坏 `if(alert(...) == "Yes")` 之类的比较。原生 alert/input 的位置实参随「有没有 usr」
        // 整体平移一位（有 usr 时 [2]=标题、该抽；无 usr 时 [2]=按钮/默认值、绝不能抽），判据见
        // native_dialog_no_usr。**必须与 rewrite.rs 同表**，否则 rewrite 会生成目录里没有的 key。
        "alert" => Some(&[0, 1, 2]),
        "input" => Some(&[0, 1, 2]),
        "tgui_alert" => Some(&[1, 2]),
        "tgui_input_list" => Some(&[1, 2]),
        "tgui_input_text" => Some(&[1, 2]),
        "tgui_input_number" => Some(&[1, 2]),
        // 中央指挥部/站内公告（玩家可见正文+标题）。[0]=正文 [1]=标题。**非插值**公告仅抽取、显示靠
        // priority_announce.dm 的运行时整串反查 + AC（零 churn）；但 rewrite.rs 对**带 [插值] 的**公告会
        // 改写为 LANG（反查需精确整串、AC 排除占位符，二者都够不着插值公告——典型：安全等级公告
        // `[等级文案]\n\nA summary has been copied…`，文案插值后整串反查 miss、suffix 含 {0} 不进 AC）。
        "priority_announce" => Some(&[0, 1]),
        "minor_announce" => Some(&[0, 1]),
        "print_command_report" => Some(&[0, 1]),
        // 银行卡/账户消息（发薪、转账、错误提示等，玩家可见）：bank_card_talk(message, force)。
        "bank_card_talk" => Some(&[0]),
        // 幽灵招募/事件通知（"An X is ready to hatch in …" 等）：notify_ghosts(message, source, …)。与 rewrite.rs 同表。
        "notify_ghosts" => Some(&[0]),
        // 机器打印到纸上的正文（字面量实参必是作者写的印刷体；玩家书写永远是变量）。与 rewrite.rs 同表。
        "add_raw_text" => Some(&[0]),
        // 手术每一步的可见/痛觉消息。整个 surgery 模块的玩家可见文本几乎都从这两个 proc 出去，
        // 而它们只是包了一层 visible_message/to_chat，通用 sink 检测看不穿 → 整模块没进目录。
        // display_results(surgeon, target, self_message, detailed_message, vague_message, …)
        // display_pain(target, pain_message, …)
        // **只加在 extract 侧**：这些消息全是插值句，进目录后由聊天层的模板逆匹配引擎
        // （lang_template_apply）落地，不需要改写调用点。rewrite.rs 不加，就不会生成目录外的 key。
        "display_results" => Some(&[2, 3, 4]),
        "display_pain" => Some(&[1]),
        _ => None,
    }
}

/// 原生 alert/input 的「无 usr」写法判别：`alert(Message, Title, Button1…)` / `input(Message, Title, Default)`
/// 时 [0] 就是消息字符串字面量，此时 [2] 是按钮/默认值而非标题，**不得抽取**（会污染目录并诱使
/// rewrite 改写返回值/比较值）。与 rewrite.rs 的同名判据保持一致。
fn native_dialog_no_usr(name: &str, args: &[Expression]) -> bool {
    if !matches!(name, "alert" | "input") {
        return false;
    }
    let Some(a0) = args.first() else { return false };
    let mut nodes: Vec<&dm::ast::Spanned<Term>> = Vec::new();
    crate::rewrite::collect_text_nodes(a0, &mut nodes);
    !nodes.is_empty()
}

pub fn run(dme: &Path, out: &Path, dry_run: bool) -> Result<()> {
    let mut context = dm::Context::default();
    context.set_print_severity(Some(dm::Severity::Error));

    let pp = dm::preprocessor::Preprocessor::new(&context, dme.to_path_buf())
        .with_context(|| format!("无法打开 .dme: {}", dme.display()))?;
    let indents = dm::indents::IndentProcessor::new(&context, pp);
    let mut parser = dm::parser::Parser::new(&context, indents);
    parser.enable_procs();
    let (fatal, tree) = parser.parse_object_tree_2();
    if fatal {
        anyhow::bail!("DM 解析出现致命错误，无法继续抽取");
    }

    // pass 1：收集纯函数 proc 名（与 rewrite 一致，按名跳过以覆盖继承纯度的子类型实现）。
    let mut pure_procs: HashSet<String> = HashSet::new();
    for ty in tree.iter_types() {
        for (proc_name, type_proc) in ty.procs.iter() {
            let proc_scope = format!("{}#{}()", ty.path, proc_name);
            for proc_value in type_proc.value.iter() {
                if let Some(block) = &proc_value.code {
                    if block_is_pure(block) {
                        pure_procs.insert(proc_name.clone());
                    }
                }
            }
        }
    }

    let mut catalog = Catalog::new();
    for ty in tree.iter_types() {
        // **完整类型路径**往下传（不是压扁后的命名空间）：命名空间由 Catalog::insert 推导，
        // 完整路径同时被记进 scopes.json 供术语表按语境消歧（`Base` 在 /datum/reagent 下是
        // 「碱」，在 /area 下是「基地」）。从前这里就地压成 "obj"/"datum"，语境信号在下一行
        // 就丢了 —— 一个词多个义项只能靠 MT 猜。
        let namespace = ty.path.clone();
        // 单元测试类型只在 UNIT_TESTS 编译期存在，断言消息玩家永不可见 → 不进激进抽取
        // （既有 sink 路径不变，避免目录 churn）。
        let suppress_aggressive = ty.path.starts_with("/datum/unit_test");

        // 1) 变量初始化（name/desc 等）。
        for (var_name, type_var) in ty.vars.iter() {
            // 语境再细一层：**变量名**。`#name` 是物品名（短名词短语），`#desc` 是描述
            // （整句），`#message` 是发给玩家的话。模型光看类型路径分不出这个，于是
            // 常把物品名翻成一句话。`#` 不影响命名空间推导（namespace_for 按 `/` 取首段），
            // 所以目录 key 不变。
            let var_scope = format!("{}#{}", ty.path, var_name);
            let mut is_sink = SINK_VARS.contains(&var_name.as_str());
            // ADMIN_VERB 宏展开成 `/datum/admin_verb/xxx { name = ##verb_name; … }`，所以管理员
            // 命令的显示名同时是**类型变量**，会绕开 `set name` 那条路上的 is_safe_verb_name 闸
            // 被 SINK_VARS 抽走。译名固化进源码后再跑 extract，这里就会把中文当英文原文收进 en 目录
            // （实测一次 extract 混进 300+ 条中文「英文」值）——与 is_safe_verb_name 的 is_ascii
            // 同一个污染级联，只是第二扇门。verb 名走 `set name` 那条路抽即可，这里让开。
            if var_name == "name" && ty.path.starts_with("/datum/admin_verb") {
                is_sink = false;
            }
            // config_entry 的 default：玩家可见公告/模板（安全等级公告、提示等，从配置加载、非 sink 调用）。
            // 仅 /datum/config_entry 类型且「句子型」default 才抽，避开数字/标志/路径等非显示默认值。
            let is_config_default =
                var_name == "default" && ty.path.starts_with("/datum/config_entry");
            // aas_config_entry 的公告模板（list，含 %VAR 占位符的玩家可见公告）。
            let is_aas_template = var_name == "announcement_lines_map"
                && ty.path.starts_with("/datum/aas_config_entry");
            // AI 法则集（/datum/ai_laws 的 inherent = list("法则1", …)）：lawset 静态法则文本，
            // 玩家可见（AI/赛博格法则面板、show_laws、法则模块），运行时 get_law_list 反查显示。
            // ion/hacked/supplied/zeroth 是离子/黑入/玩家填写的动态法则，不在此静态抽取。
            let is_law_list = var_name == "inherent" && ty.path.starts_with("/datum/ai_laws");
            // 售货机口号/广告：`product_slogans = "口号1;口号2;…"`（分号拼接，Initialize 里 splittext 拆开、
            // say(pick(slogan_list)) 喊出）。整串非单句 → 按 `;` 拆成逐条抽取，靠聊天 AC 子串层翻译。
            let is_slogan = var_name == "product_slogans" || var_name == "product_ads";
            // 基础 mob 闲聊池：`speak/emote_hear/emote_see = list("…")`（~120 处）。表情行小写动词
            // 开头（"jumps in a circle."）→ 激进 pass 首字母大写闸挡掉，且 list 初值走 build_template
            // 返回 None → 必须逐元素抽。显示经 say/manual_emote → 聊天 AC 兜底翻。
            let is_speech_pool = matches!(var_name.as_str(), "speak" | "emote_hear" | "emote_see");
            // 合成配方步骤列表（/datum/crafting_recipe steps = list("步骤1", …)，crafting UI "steps"
            // 字段直发显示、P1 反查）。无句末标点居多 → 逐元素抽。
            let is_steps_list = var_name == "steps" && ty.path.starts_with("/datum/crafting_recipe");
            // 激进 pass：任何类型变量初值里的「句子型」字面量（含 list 元素与插值模板）。
            // 自定义 examine 文本变量（dry_desc 类）、pick 表、未列入 SINK_VARS 的长尾自动入目录
            // （句末标点闸门挡住标识符/枚举名）；显示靠反查表/字面 AC/模板逆匹配引擎。
            if let Some(expr) = &type_var.value.expression {
                let var_ctx = ProcCtx { ident: false, examine: false, display_return: false };
                visit_expr(expr, &var_scope, &mut catalog, suppress_aggressive, var_ctx);
            }
            if !is_sink && !is_config_default && !is_aas_template && !is_law_list && !is_slogan
                && !is_speech_pool && !is_steps_list
            {
                continue;
            }
            if let Some(expr) = &type_var.value.expression {
                if is_aas_template {
                    emit_message_list(expr, &var_scope, &mut catalog);
                    continue;
                }
                if is_steps_list {
                    emit_list_strings(expr, &var_scope, &mut catalog);
                    continue;
                }
                if is_law_list || is_speech_pool {
                    emit_list_strings(expr, &var_scope, &mut catalog);
                    if is_law_list {
                        continue;
                    }
                    // speech pool 偶见纯串形式（speak = "Polly wants a cracker!"）→ 继续走下面的
                    // build_template 抽整串（list 形式 build_template 返回 None，无重复）。
                }
                if is_slogan {
                    // 整串 "口号1;口号2" → 按 `;` 拆，逐条抽（去首尾空白，跳过含占位符/空条）。
                    if let Some(template) = build_template(expr) {
                        for part in template.split(';') {
                            let s = part.trim();
                            if !s.is_empty() && !s.contains('{') {
                                emit(&mut catalog, &var_scope, s);
                            }
                        }
                    }
                    continue;
                }
                if let Some(template) = build_template(expr) {
                    if is_config_default && !is_sentence_like(&template) {
                        continue;
                    }
                    emit(&mut catalog, &var_scope, &template);
                }
            }
        }

        // 2) proc 体内的汇聚点调用（跳过纯函数名的 proc）。
        for (proc_name, type_proc) in ty.procs.iter() {
            if pure_procs.contains(proc_name) {
                continue;
            }
            let proc_scope = format!("{}#{}()", ty.path, proc_name);
            for proc_value in type_proc.value.iter() {
                if let Some(block) = &proc_value.code {
                    let ctx = ProcCtx {
                        ident: is_identifier_dot_proc(proc_name),
                        examine: is_examine_proc(proc_name),
                        display_return: is_display_descriptor_proc(proc_name),
                    };
                    visit_block(block, &proc_scope, &mut catalog, suppress_aggressive, ctx);
                    // **形参默认值**里的玩家可见文案。SINK_VARS 走的是类型变量声明，够不着这一类：
                    // `Initialize(revive_title = "a recovered crewmember", spawn_text = "Recovered Crew",
                    //  you_are_text = "…", flavor_text = "…")` 这种把整套招募文案写在形参默认值里的
                    // 组件（ghostrole_on_revive 等），一条都抽不到 → 玩家看到「你想扮演a recovered
                    // crewmember吗？」这种句子里嵌着英文。
                    // 闸门比 SINK_VARS 本身更严：形参名作 `name`/`message` 时标识符浓度远高于
                    // 作类型变量时（`proc/f(message = "some_key")`），所以再加一道**多词**判定
                    // （复用 LANG 实参那条 is_lang_arg_text），单 token 默认值一律不收。
                    for param in proc_value.parameters.iter() {
                        if !SINK_VARS.contains(&param.name.as_str()) {
                            continue;
                        }
                        let Some(default) = &param.default else {
                            continue;
                        };
                        if let Some(t) = build_template(default) {
                            if !t.contains('{') && is_lang_arg_text(&t) {
                                emit(&mut catalog, &namespace, t.trim());
                            }
                        }
                    }
                    // verb 命令面板显示名：`set name = "X"`（Statement::Setting）。非 sink、非类型变量，
                    // 单独抽。仅安全显示名（is_safe_verb_name 排除 .click/body-chest 等 keybind 标识符）。
                    // 编译期由 rewrite::run_verbs 注入译文（verb 名无法运行时本地化）。
                    for stmt in block.iter() {
                        if let Statement::Setting { name, value, .. } = &stmt.elem {
                            if name.as_str() == "name" {
                                if let Some(t) = build_template(value).or_else(|| plain_string(value))
                                {
                                    if is_safe_verb_name(&t) {
                                        emit(&mut catalog, &namespace, &t);
                                    }
                                }
                            }
                        }
                    }
                    // 物种「描述」与「背景设定」：经偏好物种常量 asset 展示的玩家可见文本，
                    // 但来源是 proc **返回值**（各物种覆盖 get_species_description/lore），非 sink/SINK_VARS。
                    // 运行时在 species.dm 的 compile_constant_data 反查落地。
                    match proc_name.as_str() {
                        "get_species_description" => {
                            let mut rets = Vec::new();
                            collect_returns(block, &mut rets);
                            for r in rets {
                                // 返回可能是裸字符串（多数物种）或 list("段1","段2")（shadekin 等多段描述）。
                                // 裸串走 build_template；list 走 emit_list_strings（与 get_species_lore 一致，
                                // 否则 list 形态的描述完全漏抽——shadekin「描述」即此故仍英文）。
                                if let Some(t) = build_template(r) {
                                    emit(&mut catalog, &namespace, &t);
                                } else {
                                    emit_list_strings(r, &namespace, &mut catalog);
                                }
                            }
                        }
                        "get_species_lore" => {
                            let mut rets = Vec::new();
                            collect_returns(block, &mut rets);
                            for r in rets {
                                emit_list_strings(r, &namespace, &mut catalog);
                            }
                        }
                        // 职业不可用原因（加入菜单 tooltip / tgui_alert）：`get_job_unavailable_error_message`
                        // 的各 `return "[jobtitle] is already filled to capacity."` 是**插值**模板（含 [jobtitle]），
                        // 通用 proc-return 捕获被 is_sentence_like 的「无 {」排除 → 漏抽。专项按模板抽（含占位符），
                        // 由该 proc 手接 LANG（jobtitle 走 lang_reverse_text 整词反查）。
                        // get_captaincy_announcement：`return "Captain [real_name] on deck!"` 同属插值 proc-return
                        // （舰长/代理舰长上岗公告，经 priority_announce 喊出）→ 抽模板，边界引擎在公告输出整句命中。
                        "get_job_unavailable_error_message" | "get_captaincy_announcement" => {
                            let mut rets = Vec::new();
                            collect_returns(block, &mut rets);
                            for r in rets {
                                if let Some(t) = build_template(r) {
                                    emit(&mut catalog, &namespace, &t);
                                }
                            }
                        }
                        // antag opt-in 等级显示串（GLOBAL_LIST_INIT(antag_opt_in_strings) → InitGlobal* proc
                        // 体内 `antag_opt_in_strings = list("2"="Yes - Kill",…)`，值是 #define 展开的显示短语）：
                        // spawn 介绍「强制最低 opt-in 设置为 [值]」行的插值值，模板已译、边界引擎捕获该值为 {N}
                        // 后经 lang_reverse_text 翻译 → 抽其 assoc 值入目录（键 "0".."3" 无字母、emit 自动过滤）。
                        "InitGlobalantag_opt_in_strings" => {
                            for stmt in block.iter() {
                                if let Statement::Expr(Expression::AssignOp { rhs, .. }) = &stmt.elem {
                                    emit_list_strings(rhs, &namespace, &mut catalog);
                                }
                            }
                        }
                        // 门禁权限显示名（ID 控制台/门禁芯片等所有 AccessList UI）：SSid_access 的
                        // setup_access_descriptions 里 `desc_by_access[ACCESS_X] = "Cargo Bay"` 大批赋值
                        // （无句末标点 → 激进 pass 抽不到，整类漏抽）。值纯显示（act 走 "ref"），
                        // 运行时 setup_tgui_lists 构建静态表时整串反查落地（含单词条目）。
                        "setup_access_descriptions" => {
                            for stmt in block.iter() {
                                if let Statement::Expr(Expression::AssignOp { rhs, .. }) = &stmt.elem {
                                    if let Some(t) = build_template(rhs) {
                                        if !t.contains('{') {
                                            emit(&mut catalog, &namespace, &t);
                                        }
                                    }
                                }
                            }
                        }
                        // 离子法则模板（ALLCAPS 拼装句，无句末标点 → 激进 pass 抽不到）。
                        "generate_ion_law" => walk_ion_templates(block, &namespace, &mut catalog),
                        // 物种特征(perk)：create_pref_*_perks / get_species_perks 等，抽 list 里 name/description。
                        n if n.contains("perk") => walk_perk_block(block, &namespace, &mut catalog),
                        // examine 标签的 hover tooltip：`.["tag"] = "提示"`（运行时 atom_examine 反查显示）。
                        // get_examine_info：slapcrafting 的 `examine_list["crafting component"] = "You think…"`
                        // tooltip（插值模板，手接 LANG）。
                        "examine_tags" | "get_examine_info" | "get_examine_tags" => walk_examine_tags(block, &namespace, &mut catalog),
                        // 重量等级 tooltip：examine_tags 里 `.[…] = weight_class_to_tooltip(w_class)`，值是 proc
                        // **返回**的字面量（"This item can fit into pockets…"），非 sink/index-assign → 抽返回值。
                        "weight_class_to_tooltip" => {
                            let mut rets = Vec::new();
                            collect_returns(block, &mut rets);
                            for r in rets {
                                if let Some(t) = build_template(r) {
                                    emit(&mut catalog, &namespace, &t);
                                }
                            }
                        }
                        // 通用兜底：任何 proc 的 `return "<整句>"`，若是句子型玩家可见文案（多词 + 首字母大写
                        // + 含小写 + 无占位符），抽进目录靠聊天 AC 子串层翻译。覆盖 weight_class_to_tooltip 同类
                        // 的「proc 返回字面量、字面量不在 sink 调用处（经 to_chat/alert 的变量参数发出），rewrite
                        // 够不着」长尾：can_*() 的错误原因、穿梭机/天气/投票/实验提示等。含 [插值]→{0} 的返回被
                        // is_sentence_like 排除（那类 AC 也翻不了，需 LANG 改写，已在 sink 处单独处理）。
                        _ => {
                            let mut rets = Vec::new();
                            collect_returns(block, &mut rets);
                            for r in rets {
                                if let Some(t) = build_template(r) {
                                    if is_sentence_like(&t) {
                                        emit(&mut catalog, &namespace, &t);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 3) strings/ flavor 数据文件（tips/ion_laws/junkmail…）并入主目录的 `strings` 命名空间，
    //    使其与 sink/SINK_VARS 走同一翻译界面（运行时在 load 处反查落地，见 _string_lists.dm /
    //    type2type.dm）。strings 根目录由 out（.../strings/i18n/en）回推两级得到。
    if let Some(strings_root) = out.parent().and_then(|p| p.parent()) {
        crate::flavor::extract_flavor(strings_root, &mut catalog);
        // 复印机表单（config/blanks.json + config/nova/blanks.json）：repo 根 = strings_root 的父级。
        if let Some(repo_root) = strings_root.parent() {
            crate::flavor::extract_blanks(repo_root, &mut catalog);
            crate::flavor::extract_interactions(repo_root, &mut catalog);
            crate::flavor::extract_news_stories(repo_root, &mut catalog);
        }
    }

    eprintln!(
        "抽取 {} 条字符串，{} 个命名空间",
        catalog.entry_count(),
        catalog.namespace_count()
    );
    if !dry_run {
        // 译文迁移：趁旧 en 目录还在盘上，把孤儿译文接到新 key（精确继承 + 近似迁移，见 migrate.rs）。
        if let Err(err) = crate::migrate::run(&catalog, out) {
            eprintln!("译文迁移失败（不影响抽取）: {err}");
        }
        // 合并已存在目录：保留已被 rewrite 改写（源码里已不是字面量）的 key（重同步必需）。
        catalog.load_dir(out);
        catalog.write(out)?;
        eprintln!(
            "已写入英文主目录: {}（合并后 {} 条）",
            out.display(),
            catalog.entry_count()
        );
        // key -> 类型路径 sidecar。放 locale 目录的**上一级**（见 write_scopes 注释）。
        let scopes_path = out
            .parent()
            .unwrap_or(out)
            .join("scopes.json");
        catalog.write_scopes(&scopes_path)?;
        eprintln!(
            "已写入语境 sidecar: {}（本次 {} 个 key 带类型路径）",
            scopes_path.display(),
            catalog.scope_count()
        );
    }
    Ok(())
}

/// 该 proc 是否标了 `set SpacemanDMM_should_be_pure`（与 rewrite.rs 一致，跳过不抽取）。
fn block_is_pure(block: &[dm::ast::Spanned<Statement>]) -> bool {
    block.iter().any(|s| {
        matches!(&s.elem, Statement::Setting { name, .. } if name.as_str() == "SpacemanDMM_should_be_pure")
    })
}

/// `type_path` = 完整 DM 类型路径（flavor.rs 等无类型来源传裸命名空间名，见 Catalog::insert）。
/// LANG 实参里的英文字面量。
///
/// 改写把 `"The [x ? "bolt" : "screw"] is [state]."` 变成 `LANG(key, list(x ? "bolt" : "screw", state))`
/// —— 模板进了目录，**被抬成实参的那些字面量却没有任何抽取路径**（它们不再是 sink 实参，也不是
/// 累加器右值）。运行期 `lang_localize_arg` 会拿实参去反查，目录里没有键 → 整句译文里嵌着一截
/// 英文。全仓 800+ 个 LANG 调用点属于这一类（"is secured and ready to be used!"、"hurts!"、
/// "weighs you down." …）。这里把这些字面量按 LANG 的命名空间补进目录，反查即通。
///
/// 必须绕开的两类**非显示**字面量：
///   - 下标键（`ded["name"]`、`data["role"]`）——是程序用的键名，翻了就查不到值。故不下探 `Follow::Index`。
///   - 嵌套 LANG 的 key 本身（`LANG("datum.eb109e14", …)`）——形如 `<ns>.<hash>`，翻了目录就崩。
fn collect_lang_arg_literals(expr: &Expression, out: &mut Vec<String>) {
    match expr {
        Expression::Base { term, follow } => {
            collect_lang_arg_literals_term(&term.elem, out);
            for f in follow.iter() {
                // Follow::Index 的下标是键名，不是文案 —— 整支跳过。
                if let Follow::Call(_, name, args) = &f.elem {
                    let key_idx = lang_format_key_index(name.as_str());
                    for (i, a) in args.iter().enumerate() {
                        if Some(i) == key_idx {
                            continue;
                        }
                        collect_lang_arg_literals(a, out);
                    }
                }
            }
        }
        Expression::BinaryOp { lhs, rhs, .. } => {
            collect_lang_arg_literals(lhs, out);
            collect_lang_arg_literals(rhs, out);
        }
        Expression::AssignOp { rhs, .. } => collect_lang_arg_literals(rhs, out),
        Expression::TernaryOp { cond, if_, else_ } => {
            collect_lang_arg_literals(cond, out);
            collect_lang_arg_literals(if_, out);
            collect_lang_arg_literals(else_, out);
        }
    }
}

/// LANG 实参里**本身就是插值句**的那些（`ask_role ? "Personality requested: \[[ask_role]\]" : ""`）。
///
/// 上面的字面量收集器对 `Term::InterpString` **只下探内插表达式、把字面文本整个丢掉**，所以
/// 这类实参一个字都进不了目录：模板译好了，句子中间却嵌着一截英文（正电子脑的
/// 「Personality requested: \[…\]」即此）。这里按**模板形态**（`Personality requested: {0}`）
/// 补进目录——运行期由整行模板引擎命中，它会捕获角色名再递归本地化。
///
/// 只收模板：带占位符的串**永远不进反查表**，且模板要求全部字面段按序命中，
/// 比裸串反查安全得多；再加一道「去占位符后须多词」的闸门挡住 act/黑板键那类短标识符。
fn collect_lang_arg_templates(expr: &Expression, out: &mut Vec<String>) {
    match expr {
        Expression::Base { term, follow } => {
            match &term.elem {
                Term::InterpString(..) => {
                    if let Some(t) = build_template(expr) {
                        out.push(t);
                    }
                }
                Term::Expr(inner) => collect_lang_arg_templates(inner, out),
                Term::List(args) => {
                    for a in args.iter() {
                        collect_lang_arg_templates(a, out);
                    }
                }
                Term::Call(name, args) => {
                    let key_idx = lang_format_key_index(name.as_str());
                    for (i, a) in args.iter().enumerate() {
                        if Some(i) == key_idx {
                            continue;
                        }
                        collect_lang_arg_templates(a, out);
                    }
                }
                _ => {}
            }
            // 下标键是程序用的键名，与字面量收集器同样整支跳过。
            let _ = follow;
        }
        Expression::TernaryOp { cond, if_, else_ } => {
            collect_lang_arg_templates(cond, out);
            collect_lang_arg_templates(if_, out);
            collect_lang_arg_templates(else_, out);
        }
        Expression::AssignOp { rhs, .. } => collect_lang_arg_templates(rhs, out),
        _ => {}
    }
}

/// 模板形态的 LANG 实参能否入目录：须有占位符，且去掉占位符/标签后是**多词**自然语言。
fn is_lang_arg_template(template: &str) -> bool {
    if placeholder_count(template) == 0 {
        return false;
    }
    let mut text = strip_html_tags(template);
    while let Some(start) = text.find('{') {
        match text[start..].find('}') {
            Some(rel) => text.replace_range(start..start + rel + 1, " "),
            None => break,
        }
    }
    let words: Vec<&str> = text.split_whitespace().collect();
    words.len() >= 2 && text.chars().any(|c| c.is_alphabetic())
}

fn collect_lang_arg_literals_term(term: &Term, out: &mut Vec<String>) {
    match term {
        Term::String(s) => out.push(s.clone()),
        Term::Expr(inner) => collect_lang_arg_literals(inner, out),
        Term::List(args) => {
            for a in args.iter() {
                collect_lang_arg_literals(a, out);
            }
        }
        Term::Call(name, args) => {
            let key_idx = lang_format_key_index(name.as_str());
            for (i, a) in args.iter().enumerate() {
                if Some(i) == key_idx {
                    continue;
                }
                collect_lang_arg_literals(a, out);
            }
        }
        Term::InterpString(_, parts) => {
            for (expr, _) in parts.iter() {
                if let Some(e) = expr {
                    collect_lang_arg_literals(e, out);
                }
            }
        }
        _ => {}
    }
}

/// `lang_format(key, args)` / `lang_format_for(user, key, args)` 的 key 实参下标（LANG/LANGU
/// 是 #define，AST 里已展开成这两个名字）。非 LANG 调用返回 None。
fn lang_format_key_index(name: &str) -> Option<usize> {
    match name {
        "lang_format" => Some(0),
        "lang_format_for" => Some(1),
        _ => None,
    }
}

/// 去掉 HTML 标签（含 `<span class='notice'>` 这种源码里被截断成半截的开标签）。
/// 只用于「这串里还有没有真文案」的判断，不改写入目录的内容。
fn strip_html_tags(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    let mut depth = 0usize;
    for c in s.chars() {
        match c {
            '<' => depth += 1,
            '>' => depth = depth.saturating_sub(1),
            _ if depth == 0 => out.push(c),
            _ => {}
        }
    }
    out
}

/// LANG 实参字面量是否值得进目录。
///
/// 挡掉三类噪音：语法碎片（复数 "s"、空串、纯标点/空白）、目录 key 形态（嵌套 LANG 漏网时的兜底）、
/// 以及一眼是标识符的串（含 `{}` 占位符的模板片段由 LANG 自己管，不在这里重复抽）。
fn is_lang_arg_text(s: &str) -> bool {
    let t = s.trim();
    if t.len() < 3 || t.contains('{') {
        return false;
    }
    // `<ns>.<8 位十六进制>` = 目录 key，绝不能当文案抽。
    if let Some((ns, hash)) = t.split_once('.') {
        if !ns.is_empty()
            && ns.chars().all(|c| c.is_ascii_lowercase() || c == '_')
            && hash.len() == 8
            && hash.chars().all(|c| c.is_ascii_hexdigit())
        {
            return false;
        }
    }
    // **只收多词**。单 token 的 LANG 实参里标识符浓度极高：act/topic/wire 键（`activate`、`attach`、
    // `unlock`、`datumedit`、`targetvar`）、黑板键与 var 名（`all_damage`、`turbine_max_rpm`）、存档路径、
    // 全大写常量（`APC`/`LMB`/`NULL`）。放进目录 = 反查表把它们变异成中文，`switch`/下标比较当场失效
    // ——`nova-i18n lint` 一次就报出 12 条高置信 + 98 条单词类碰撞。而单词类实参本来就有专门的精确
    // 表兜底（`lang_localize_arg` 第一步查 `_state_words.json`：open/closed/lit…），不靠这条路径。
    // 与 P1 多词门槛、AC 字典多词过滤、首字母大写变体是同一条安全线。
    if !t.chars().any(char::is_whitespace) {
        return false;
    }
    // 只有标记、没有文案的串（`span_*` 宏在 AST 里展开成的 `"<span class='notice'>"` 这类半截
    // 标签）必须挡掉：翻了就是把 class 名译成中文、样式直接失效。判据是**剥掉标签之后**还剩不剩字。
    let without_tags = strip_html_tags(t);
    let t = without_tags.trim();
    // 至少要有一段连续两个以上的字母，挡掉 "s"/"es"/"%"/"1/5" 之流。
    let mut run = 0usize;
    for c in t.chars() {
        if c.is_alphabetic() {
            run += 1;
            if run >= 2 {
                return true;
            }
        } else {
            run = 0;
        }
    }
    false
}

pub(crate) fn emit(catalog: &mut Catalog, type_path: &str, template: &str) {
    if !template.chars().any(|c| c.is_alphabetic()) {
        return;
    }
    // key 必须仍按**命名空间**算（`<ns>.<hash>`），否则全目录 key 变更 = 丢光全部译文。
    let key = make_key(&namespace_for(type_path), template);
    catalog.insert(type_path, &key, template);
}

// ---- 语句/表达式遍历：找到汇聚点调用 ----

fn visit_block(block: &[dm::ast::Spanned<Statement>], ns: &str, catalog: &mut Catalog, suppress: bool, ctx: ProcCtx) {
    for stmt in block.iter() {
        visit_stmt(&stmt.elem, ns, catalog, suppress, ctx);
    }
}

fn visit_stmt(stmt: &Statement, ns: &str, catalog: &mut Catalog, suppress: bool, ctx: ProcCtx) {
    match stmt {
        Statement::Expr(e) => visit_expr(e, ns, catalog, suppress, ctx),
        Statement::Return(Some(e)) => {
            if ctx.display_return {
                if let Some(template) = build_template(e) {
                    emit(catalog, ns, &template);
                }
            }
            visit_expr(e, ns, catalog, suppress, ctx)
        }
        Statement::While { condition, block } => {
            visit_expr(condition, ns, catalog, suppress, ctx);
            visit_block(block, ns, catalog, suppress, ctx);
        }
        Statement::If { arms, else_arm } => {
            for (cond, blk) in arms.iter() {
                visit_expr(&cond.elem, ns, catalog, suppress, ctx);
                visit_block(blk, ns, catalog, suppress, ctx);
            }
            if let Some(blk) = else_arm {
                visit_block(blk, ns, catalog, suppress, ctx);
            }
        }
        Statement::ForInfinite { block } => visit_block(block, ns, catalog, suppress, ctx),
        Statement::ForLoop {
            init,
            test,
            inc,
            block,
        } => {
            if let Some(s) = init {
                visit_stmt(s, ns, catalog, suppress, ctx);
            }
            if let Some(e) = test {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            if let Some(s) = inc {
                visit_stmt(s, ns, catalog, suppress, ctx);
            }
            visit_block(block, ns, catalog, suppress, ctx);
        }
        Statement::Switch {
            input,
            cases,
            default,
        } => {
            visit_expr(input, ns, catalog, suppress, ctx);
            // 修复：之前 `..` 漏掉了 cases —— switch 各 case 分支体里的语句全部没被抽取。
            for (_case_conditions, blk) in cases.iter() {
                visit_block(blk, ns, catalog, suppress, ctx);
            }
            if let Some(blk) = default {
                visit_block(blk, ns, catalog, suppress, ctx);
            }
        }
        Statement::Spawn { delay, block } => {
            if let Some(e) = delay {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            visit_block(block, ns, catalog, suppress, ctx);
        }
        Statement::Var(v) => {
            if let Some(e) = &v.value {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
        }
        Statement::Vars(vs) => {
            for v in vs.iter() {
                if let Some(e) = &v.value {
                    visit_expr(e, ns, catalog, suppress, ctx);
                }
            }
        }
        Statement::Setting { value, .. } => visit_expr(value, ns, catalog, suppress, ctx),
        // for-in / for-range / do-while / try-catch / label 体：此前全部落进 `_ => {}` ——
        // **所有 for(x in list) 循环体内的字符串（sink 实参 + 激进 pass）都没被抽取**
        // （实测：bitrunning get_available_domains 的 "Limited scanning capabilities…" 漏抽）。
        // lint.rs / labels.rs 早已覆盖这些变体，唯 extract 漏；rewrite.rs 同样缺失（见 README 已知事项）。
        Statement::DoWhile { block, condition } => {
            visit_block(block, ns, catalog, suppress, ctx);
            visit_expr(&condition.elem, ns, catalog, suppress, ctx);
        }
        Statement::ForList(f) => {
            if let Some(e) = &f.in_list {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            visit_block(&f.block, ns, catalog, suppress, ctx);
        }
        Statement::ForKeyValue(f) => {
            if let Some(e) = &f.in_list {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            visit_block(&f.block, ns, catalog, suppress, ctx);
        }
        Statement::ForRange(f) => {
            visit_expr(&f.start, ns, catalog, suppress, ctx);
            visit_expr(&f.end, ns, catalog, suppress, ctx);
            if let Some(e) = &f.step {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            visit_block(&f.block, ns, catalog, suppress, ctx);
        }
        Statement::TryCatch {
            try_block,
            catch_block,
            ..
        } => {
            visit_block(try_block, ns, catalog, suppress, ctx);
            visit_block(catch_block, ns, catalog, suppress, ctx);
        }
        Statement::Label { block, .. } => visit_block(block, ns, catalog, suppress, ctx),
        _ => {}
    }
}

fn visit_expr(expr: &Expression, ns: &str, catalog: &mut Catalog, suppress: bool, ctx: ProcCtx) {
    match expr {
        Expression::Base { term, follow } => {
            // 激进 pass：独立字符串/插值串字面量，句子型即入目录（含 {N} 模板）。
            // 显示路径：纯串→反查表/字面 AC；插值模板→边界模板逆匹配引擎（template_match.dm）。
            if !suppress
                && follow.is_empty()
                && matches!(&term.elem, Term::String(_) | Term::InterpString(..))
            {
                if let Some(template) = build_template(expr) {
                    if is_loose_sentence(&template) {
                        emit(catalog, ns, &template);
                    }
                }
            }
            // 汇聚点调用检测。
            // 已被 rewrite 改写的字符串，源码里只剩 `LANG("obj.abc123")` —— 字面量没了，
            // 常规抽取产不出它，key 靠 Catalog::load_dir 从旧目录续命。语境同理会丢：
            // 全目录约 28% 的 key（而且恰恰是玩家最常见的 sink 串）会没有类型路径。
            // 这里从 **LANG() 调用点本身**回收 scope —— 比原字面量的定义处更准，
            // 因为它记的是这句话实际被用在哪个类型里。
            if let Term::Call(name, args) = &term.elem {
                // 注意匹配的是**宏展开后**的名字：LANG/LANGU 是 `#define`
                // （code/__DEFINES/~nova_defines/i18n.dm），SpacemanDMM 的预处理器在建 AST
                // 之前就把它们展开成 lang_format/lang_format_for 了，AST 里根本没有 "LANG"。
                let key_arg = lang_format_key_index(name.as_str());
                if let Some(idx) = key_arg {
                    if let Some(key) = args.get(idx).and_then(plain_string) {
                        catalog.note_scope(&key, ns);
                    }
                    // 被改写抬成实参的英文字面量：模板译了、实参还是英文。见
                    // collect_lang_arg_literals 的说明。
                    let mut literals = Vec::new();
                    for (i, a) in args.iter().enumerate() {
                        if i <= idx {
                            continue; // key 及其之前的实参（LANGU 的 user）不是文案
                        }
                        collect_lang_arg_literals(a, &mut literals);
                    }
                    for literal in literals {
                        if is_lang_arg_text(&literal) {
                            emit(catalog, ns, literal.trim());
                        }
                    }
                    // 实参本身就是插值句的那一类（见 collect_lang_arg_templates）。
                    let mut templates = Vec::new();
                    for (i, a) in args.iter().enumerate() {
                        if i <= idx {
                            continue;
                        }
                        collect_lang_arg_templates(a, &mut templates);
                    }
                    for template in templates {
                        if is_lang_arg_template(&template) {
                            emit(catalog, ns, template.trim());
                        }
                    }
                }
            }
            if let Term::Call(name, args) = &term.elem {
                if let Some(indices) = sink_message_args(name.as_str()) {
                    let skip_two = native_dialog_no_usr(name.as_str(), args);
                    for &i in indices {
                        if skip_two && i == 2 {
                            continue;
                        }
                        if let Some(arg) = args.get(i) {
                            if let Some(template) = build_template(arg) {
                                emit(catalog, ns, &template);
                            }
                        }
                    }
                }
            }
            // input() 是专用 Term::Input（非 Call），与 rewrite 保持一致地抽取其消息/标题。
            if let Term::Input { args, .. } = &term.elem {
                if let Some(indices) = sink_message_args("input") {
                    let skip_two = native_dialog_no_usr("input", args);
                    for &i in indices {
                        if skip_two && i == 2 {
                            continue;
                        }
                        if let Some(arg) = args.get(i) {
                            if let Some(template) = build_template(arg) {
                                emit(catalog, ns, &template);
                            }
                        }
                    }
                }
            }
            // 日志/调试/管理员后台调用的实参不进激进抽取（其余抽取路径不受影响）。
            let term_suppress = suppress
                || matches!(&term.elem, Term::Call(name, _) if is_non_player_sink(name.as_str()));
            recurse_term(&term.elem, ns, catalog, term_suppress, ctx);
            for f in follow.iter() {
                recurse_follow(&f.elem, ns, catalog, suppress, ctx);
            }
        }
        Expression::BinaryOp { op, lhs, rhs } => {
            // 字符串 `+` 拼接：整体先按一条模板抽（"A " + x + " B." → "A {0} B."，与 span_* 宏
            // 展开形态一致）；成功后抑制内部碎片（半句单独入目录无意义）。
            let mut child_suppress = suppress;
            if !suppress && matches!(op, dm::ast::BinaryOp::Add) {
                if let Some(template) = build_template(expr) {
                    if is_loose_sentence(&template) {
                        emit(catalog, ns, &template);
                        child_suppress = true;
                    }
                }
            }
            visit_expr(lhs, ns, catalog, child_suppress, ctx);
            visit_expr(rhs, ns, catalog, child_suppress, ctx);
        }
        Expression::AssignOp { op, lhs, rhs } => {
            // examine / 消息累加：`. += <text>`（裸 `.`）原样抽；具名累加器（combined_msg += span_*("…")
            // 等，self-examine、descriptor 等）仅抽「静态句子型」串供聊天 AC 兜底——span 是宏、AST 判不出
            // 包裹，故用内容启发式；插值模板(含 {0})排除（那需 LANG 改写）。
            if matches!(op, AssignOp::AddAssign) {
                // 运行期往**别的对象**的显示字段上追加的后缀：`new_bounty.description += "…high
                // priority…"`、器官手术 desc 的「每个器官只能做一次」等。追加发生在 proc 里、目标是
                // `X.desc` 而不是裸标识符，上面那套累加器规则（只认 `Term::Ident` + 空 follow）看不到，
                // 于是后缀整类没进目录：基础句译好了，拼上后缀之后**整串不再是目录键**，精确反查连
                // 基础句一起 miss → 玩家看到整条英文（三条高优先赏金即此）。
                // 只收 desc/description 这种纯显示字段；`name` 常被 `if(name == "…")` 比较，不能碰。
                if let Expression::Base { term: _, follow } = lhs.as_ref() {
                    if let Some(last) = follow.last() {
                        if let Follow::Field(_, field) = &last.elem {
                            if is_display_accumulator_var(field.as_str()) {
                                if let Some(template) = build_template(rhs) {
                                    emit(catalog, ns, &template);
                                }
                            }
                        }
                    }
                }
                if let Expression::Base { term, follow } = lhs.as_ref() {
                    if follow.is_empty() {
                        if let Term::Ident(id) = &term.elem {
                            // 内插里嵌的表达式是**整条** span_*() 消息（`. += "[span_notice("…")]"`）。
                            // 这一步必须在 build_template 之外做：整条渲染出来是个光杆 `{0}`，
                            // 去标签后不含字母 → build_template 返回 None → 下面整块都进不去，
                            // 于是「{0} - growth progress: {1}%」这类整行 examine 一条都没抽到。
                            if (id == "." && !ctx.ident) || is_examine_accumulator(id) {
                                for part in split_interp_parts(rhs) {
                                    if let Some(t) = build_template(part) {
                                        emit(catalog, ns, &t);
                                    }
                                }
                            }
                            // SINK_VARS 里的**显示字段**在 proc 里 `+=` 追加：整句闸（要求首字母大写）
                            // 会把「续写句」全挡掉——幽灵角色入场文字就是 `flavour_text += "you're an
                            // exile from…"`，是完整句子却以小写开头，四个变体一条都没进目录，玩家看到
                            // 的是「译好的基础段 + 整段英文」。这些字段本就是玩家可见的，无条件抽。
                            if is_display_accumulator_var(id) {
                                if let Some(template) = build_template(rhs) {
                                    emit(catalog, ns, &template);
                                }
                            }
                            if let Some(template) = build_template(rhs) {
                                // 裸 `.` 与 examine 信号处理器的累加器（examine_list/text/strings）：
                                // examine 输出，必玩家可见 → 全抽（含插值，供 LANG）。其它具名累加器只抽静态句供 AC。
                                // ident_proc（update_overlays 等）：bare-`.` 是 icon_state/标识符，不抽。
                                if (id == "." && !ctx.ident)
                                    || is_examine_accumulator(id)
                                    || (ctx.examine && is_examine_sentence(&template))
                                {
                                    // `. += span_notice("A") + "\n" + span_notice("B")`：整条链
                                    // build_template 会把兄弟 span_* 当成 {0}/{1}，抽出
                                    // `"{0}\n{1}\nIt can also be…"` 这种废键——改写侧永远跳过它
                                    // （一行里多个字面量，无从判断该换哪个），于是整段 examine
                                    // 卡在英文。拆开逐段抽，各自成条，显示交给聊天 AC 子串层。
                                    // 拼接链拆出来的段要过整句闸门：链里另一半往往是
                                    // `"\n- "`、`"there is a "` 这种续写碎片，单独入目录后会被
                                    // 聊天 AC 层在半句处替换，拼出语序错乱的中文。
                                    for part in split_concat_parts(rhs) {
                                        if let Some(t) = build_template(part) {
                                            if is_examine_sentence(&t) {
                                                emit(catalog, ns, &t);
                                            }
                                        }
                                    }
                                    emit(catalog, ns, &template);
                                } else if is_sentence_like(&template)
                                    && !is_option_accumulator(id)
                                {
                                    emit(catalog, ns, &template);
                                }
                            }
                        }
                    }
                }
            }
            // 屏幕提示(screentip)：`context[SCREENTIP_CONTEXT_*] = "文本"`（悬停顶部「眩扰/攻击/上楼」等）。
            // 具名 context list 的 index-assign，遍布 add_context/add_item_context/on_requesting_context 等
            // 260+ 文件、非单一 proc → 按 var 名「context」在通用 AssignOp 处抽（运行时 build_context 反查显示）。
            else if matches!(op, AssignOp::Assign) {
                if let Expression::Base { term, follow } = lhs.as_ref() {
                    let is_context_index =
                        matches!(&term.elem, Term::Ident(id) if id == "context")
                            && follow.len() == 1
                            && matches!(&follow[0].elem, Follow::Index(..));
                    if is_context_index {
                        if let Some(template) = build_template(rhs) {
                            emit(catalog, ns, &template);
                        }
                    }
                    // proc 内运行期 `desc = "<字面量>"` 赋值（含插值）：examine 显示点反查只救非插值串,
                    // 插值 desc（"A [dried?…]trail of [X]."）整串非目录键 → 在此抽模板、由 rewrite 改 LANG。
                    // 仅 desc（display-only,安全）；不动 name（常被 `if(name=="…")` 比较,LANG 化会破坏比较）。
                    // spread_text 同理：它在 /datum/disease/advance/set_spread() 里按 flag **在 proc 内**
                    // 重新赋值（"Fluids"/"Skin contact"/"Respiration"…），类型变量初值那条路抽不到，
                    // 而 New() 的反查早在赋值之前就跑完了 → 医疗扫描的「Type:」整类显英文。
                    else if follow.is_empty() {
                        if let Term::Ident(id) = &term.elem {
                            if id == "desc" || id == "spread_text" {
                                if let Some(template) = build_template(rhs) {
                                    if !template.trim().is_empty() {
                                        emit(catalog, ns, &template);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            visit_expr(lhs, ns, catalog, suppress, ctx);
            visit_expr(rhs, ns, catalog, suppress, ctx);
        }
        Expression::TernaryOp {
            cond, if_, else_, ..
        } => {
            visit_expr(cond, ns, catalog, suppress, ctx);
            visit_expr(if_, ns, catalog, suppress, ctx);
            visit_expr(else_, ns, catalog, suppress, ctx);
        }
    }
}

fn recurse_term(term: &Term, ns: &str, catalog: &mut Catalog, suppress: bool, ctx: ProcCtx) {
    match term {
        Term::Expr(e) => visit_expr(e, ns, catalog, suppress, ctx),
        Term::InterpString(_, parts) => {
            for (opt, _) in parts.iter() {
                if let Some(e) = opt {
                    visit_expr(e, ns, catalog, suppress, ctx);
                }
            }
        }
        Term::Call(_, args)
        | Term::SelfCall(args)
        | Term::ParentCall(args)
        | Term::List(args)
        | Term::GlobalCall(_, args) => {
            for a in args.iter() {
                visit_expr(a, ns, catalog, suppress, ctx);
            }
        }
        Term::DynamicCall(a, b) => {
            for e in a.iter() {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            for e in b.iter() {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
        }
        Term::NewImplicit { args } | Term::NewMiniExpr { args, .. } => {
            if let Some(args) = args {
                for e in args.iter() {
                    visit_expr(e, ns, catalog, suppress, ctx);
                }
            }
        }
        Term::NewPrefab { prefab, args } => {
            // 堆叠合成配方标题：`new /datum/stack_recipe("title", …)` / `new /datum/stack_recipe_list("组名", …)`
            // 第 0 构造实参（无句末标点 → 激进 pass 抽不到，此前整类漏抽——StackCrafting 菜单全英文的根因）。
            // 显示端 stack.dm recursively_build_recipes 已对 title 反查（display key，make() act 走 ref）。
            // 含插值的标题（材料模板类）跳过。
            if prefab
                .path
                .iter()
                .any(|(_, seg)| seg.as_str().starts_with("stack_recipe"))
            {
                if let Some(args) = args {
                    if let Some(first) = args.first() {
                        if let Some(t) = build_template(first) {
                            if !t.contains('{') {
                                emit(catalog, ns, &t);
                            }
                        }
                    }
                }
            }
            if let Some(args) = args {
                for e in args.iter() {
                    visit_expr(e, ns, catalog, suppress, ctx);
                }
            }
        }
        Term::Input { args, in_list, .. } => {
            for e in args.iter() {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            if let Some(e) = in_list {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
        }
        Term::Locate { args, in_list } => {
            for e in args.iter() {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            if let Some(e) = in_list {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
        }
        Term::ExternalCall {
            library,
            function,
            args,
        } => {
            if let Some(e) = library {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
            visit_expr(function, ns, catalog, suppress, ctx);
            for e in args.iter() {
                visit_expr(e, ns, catalog, suppress, ctx);
            }
        }
        _ => {}
    }
}

fn recurse_follow(follow: &Follow, ns: &str, catalog: &mut Catalog, suppress: bool, ctx: ProcCtx) {
    match follow {
        Follow::Index(_, e) => visit_expr(e, ns, catalog, suppress, ctx),
        Follow::Call(_, name, args) => {
            // 方法调用形式的汇聚点（`user.visible_message(...)`/`src.say(...)`/`M.balloon_alert(...)` 等）。
            // 此前只检测裸调用 `Term::Call`，漏掉了大量 `X.sink(...)` 形式（战斗/交互可见消息多为此形）。
            if let Some(indices) = sink_message_args(name.as_str()) {
                let skip_two = native_dialog_no_usr(name.as_str(), args);
                for &i in indices {
                    if skip_two && i == 2 {
                        continue;
                    }
                    if let Some(arg) = args.get(i) {
                        if let Some(template) = build_template(arg) {
                            emit(catalog, ns, &template);
                        }
                    }
                }
            }
            // AI 行为队列的说话/表情字面量：`controller.queue_behavior(/datum/ai_behavior/perform_emote,
            // "splashes water all around!")`。消息小写动词开头 → 激进 pass 的首字母大写闸挡掉；
            // queue_behavior 又不能整体当 sink（其它行为的实参是黑板键标识符）→ 只在第一实参是
            // perform_emote/perform_speech 类型路径时抽第二实参。
            if name.as_str() == "queue_behavior" && args.len() >= 2 {
                if is_speech_behavior_path(&args[0]) {
                    if let Some(template) = build_template(&args[1]) {
                        emit(catalog, ns, &template);
                    }
                }
            }
            // 方法形式的日志/后台调用同样抑制激进抽取（如 SSblackbox.record_feedback）。
            let call_suppress = suppress || is_non_player_sink(name.as_str());
            for a in args.iter() {
                visit_expr(a, ns, catalog, call_suppress, ctx);
            }
        }
        _ => {}
    }
}
