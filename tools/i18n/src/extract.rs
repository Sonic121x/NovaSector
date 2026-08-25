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
use crate::keys::{is_v2_key, make_key, namespace_for};
use crate::semantics::{block_is_pure, native_dialog_no_usr, resolve_sink_arg, sink_message_args};
use crate::template::{build_sink_template, build_tag_chunk_templates, build_template, placeholder_count};

/// 视为玩家可见的变量名。
/// message_* 系列是 /datum/emote 的各形态表情模板（人形/默剧/外星/AI/机器人等），玩家在聊天
/// 高频可见；它们是 var 赋值而非 sink 调用，靠抽取进目录 + /datum/emote/New() 整串反查落地。
/// 显示名/描述的「类型 → 目录 key」表（产出 strings/i18n/type_vars.json）。
///
/// 运行期在**显示边界**按类型直接取键、走正向目录，替代「拿运行期字符串倒查目录」那条路：
/// 无多词门槛（单词名第一次能落地）、无同形异义碰撞、O(1)。**数据本身永不改写** ——
/// 类型变量声明不在 rewrite 的遍历范围内（rewrite 只走 ty.procs），实例的 name/desc 始终是
/// canonical English，`if(X.name == "…")` / `GLOB.foo[X.name]` 逐字节不变。
const TYPE_VAR_TABLE_VARS: &[&str] = &["name", "desc"];

/// 只展开 atom 子树：/datum 的 name 多是标识符或走前端目录桥（labels.rs），不经显示边界。
const TYPE_VAR_TABLE_ROOTS: &[&str] = &["/obj", "/turf", "/mob", "/area"];

/// 收集「类型#变量 → key」，供继承展开。
#[derive(Default)]
struct TypeVarKeys {
    /// 本类型自己声明、且抽到了目录 key。
    declared: std::collections::BTreeMap<(String, String), String>,
    /// 本类型声明了该变量但**抽不出键**（非字面量/含占位符/无字母）。继承链必须在此截断：
    /// 沿用祖先的键会把父类型的名字挂到子类型上（`initial(name)` 取的是子类型自己的值）。
    opaque: HashSet<(String, String)>,
}

/// 攻击动词池里**同时被当标识符用**的那批（`nova-i18n lint` 的碰撞规则实测报出来的 37 条）。
///
/// 它们进主目录就等于往**全局反查表**里塞 `scan`/`heal`/`ban`/`update` 这种词对 —— 线缆颜色那次
/// 事故的形态：运行期 `switch("scan")` 拿到的值被反查成中文，比较永远不相等、功能静默失效。
/// 攻击动词的正确去处是 `strings/i18n/<locale>/_state_words.json`（手维护的**域内**表，只在
/// LANG 实参/模板捕获这个受限范围内生效，从不写回数据），所以这里只是把它们挡在主目录之外。
///
/// **维护方式是可证伪的**：改动这张表之后跑 `nova-i18n lint`，碰撞告警数不许比基线多。
const ATTACK_VERB_IDENT_BLOCKLIST: &[&str] = &[
    "ban",
    "beep",
    "burn",
    "call",
    "calls",
    "charge",
    "colour",
    "dump",
    "filter",
    "filters",
    "grind",
    "hack",
    "hammer",
    "heal",
    "hug",
    "nuke",
    "pierce",
    "plants",
    "play",
    "plays",
    "probe",
    "scan",
    "shear",
    "shred",
    "siphon",
    "smite",
    "socks",
    "stamp",
    "stomp",
    "strike",
    "stun",
    "surgeries",
    "surgery",
    "swords",
    "tong",
    "update",
    "warn",
];

const SINK_VARS: &[&str] = &[
    "name",
    "desc",
    "message",
    // 生物死亡消息（`death_message = "snarls its last and perishes."`，74 处）。它经
    // visible_message 广播、场上所有人可见，是**漏翻采集里出现频次最高的一类**（计数直接打满上限）。
    // 从前只靠激进 pass 的整句闸门捡漏：以小写动词开头的（"snarls its last…"）一条都过不了。
    "death_message",
    // 同族：`deathmessage`（老写法）与 gib/分解消息。
    "deathmessage",
    // 配装预览名（`preview_name = "Croptop Bomber Jacket Plain"`，363 处）：偏好菜单里逐件显示，
    // 漏翻采集在 tgui 那一侧大量命中。名字型短语过不了激进 pass 的整句闸门。
    "preview_name",
    // 物种复数名（`plural_form = "Flypeople"`）。它进 LANG 实参（物种 perk 描述、地面残留物
    // 检查）与偏好菜单，是纯显示串。没写的那些由 `"[name]\s"` 在运行期拼出来，那一类靠
    // lang_localize_arg 的复数回退落地（中文无复数，去词尾查单数）。
    "plural_form",
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
    // 线路面板的设备名（`/datum/wires/proper_name`，45 处）：面板标题与 AI 的线路目录都显示它。
    // 类型变量、纯显示（唯一一处比较是 `proper_name != "Unknown"`，比的是数据本身，不受影响）。
    // 45 条里有 24 条恰好因为同名机器在别处入过目录而能落地，另外 21 条整齐地留在英文 ——
    // 「同一份列表里一半中文一半英文」这个反差就是判据。
    "proper_name",
    // 注：`APC` 这条 proper_name 由 CATALOG_VALUE_BLOCKLIST 挡掉（既是设备缩写又是
    // polycircuit 的 switch 键，进目录当场触发 lint 的高置信碰撞）。
    // 「回收船员」苏醒时逐条播出的身世（`lost_crew`）：`job_lore = "I was employed as a doctor"`、
    // `area_lore = "I was working in a space station"`、`cause_of_death = "when I got bit by a
    // spider!"`。三个都是**类型变量**、纯叙事文本，经 to_chat 一行一行发出来，落地靠整串反查
    // —— 但从没进过目录。以小写从句开头（`when I …`）的那批连激进 pass 的整句闸门都过不了。
    // 反派面板 / 幽灵环绕菜单的分组标题（`antagpanel_category = "Icemoon Dwellers"`，19 个值）。
    // 纯分组标签，玩家在环绕菜单里逐条看到。
    "antagpanel_category",
    // DNA 注入书的说明字段（`/datum/infuser_entry`，源码注释直接写着 "Vars for DNA Infusion Book"）。
    // `threshold_desc` 是突破阈值后的整句、`infuse_mob_name` 是「注入 X 的 DNA」里的那个 X、
    // `infusion_desc` 是被注入时的感受词。三个都是纯显示、从不参与比较；`qualities`（特性列表）
    // 是 list，走下面的 is_display_pool 分支逐元素抽。
    "threshold_desc",
    "infuse_mob_name",
    "infusion_desc",
    // 基础生物的交互动词（`response_help_continuous = "brushes"` / `response_harm_simple = "kick"`…
    // 六个字段）。它们是**纯显示动词**，经 `[user] [动词] [target]` 这类第三人称消息与自身消息
    // 显示，从不参与比较。全仓 150 个值里此前只有 45 个**恰好**因为同名 attack_verb 入过目录，
    // 其余整齐地留在英文；而已入目录的那批里 `brush` 撞上了考古刷子的名字（译成「刷子」）——
    // 把整族收进来之后 `brush` 变成跨命名空间歧义，反查表按设计整条略过，回落英文，比错译好。
    "response_help_continuous",
    "response_help_simple",
    "response_harm_continuous",
    "response_harm_simple",
    "response_disarm_continuous",
    "response_disarm_simple",
    "job_lore",
    "area_lore",
    "cause_of_death",
    "flavor_text",
    "title",
    // 其它可靠的玩家可见显示字段（type 变量；非 desc 的别名 / 专有显示串）。
    "description",       // /datum/reagent 等用 description（非 desc）——之前完全漏抽。
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
    // 披萨盒标签（/obj/item/food/pizza 的 boxtag，"Margherita Deluxe"/"Honolulu Chew"…）：
    // 盒子的 desc 由 `LANG(key, list(desc, "top box", box.boxtag))` 拼出，boxtag 走 lang_localize_arg
    // 的整串精确反查落地。它既不是 name/desc 也不在任何 sink 调用里 → 整类没进目录，玩家看到
    // 中文描述里嵌着英文标签。玩家自己写的标签（tgui_input_text 追加）查不到、原样保留。
    "boxtag",
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
        // 医疗扫描仪的渲染 proc：整个 proc 体就是往 `render_list` 里拼玩家可见的报告行，
        // 与 examine 累加器同性质（只是累加器叫 render_list 而不是 `.`）。收进来是为了让下面
        // 那道「冒号收尾」的闸门在这里允许占位符 —— 日志/管理面板不会长在这类 proc 里。
        || matches!(
            proc_name,
            "healthscan" | "chemscan" | "woundscan" | "diseasescan"
        )
}

/// 「显示描述符」proc：材料属性等把玩家可见短语从 switch 里 `return` 出来（"very rigid"、
/// "slightly reactive"…）。这些短语无句末标点、首字母小写，激进 pass 的整句闸一律挡掉，于是
/// 材料详检那一长串形容词整类没进目录。按 **proc 名**界定（同 examine 家族的做法），
/// 比按变量名穷举稳。
pub fn is_display_descriptor_proc(proc_name: &str) -> bool {
    matches!(
        proc_name,
        "get_descriptor"
            | "get_tooltip"
            // 工具用途显示名（`tool_behaviour_name(TOOL_KNIFE)` → "a cutting tool"）：这批 switch
            // 返回值被当作 LANG 实参包在 span_bold 里显示（「它可以用 **a cutting tool** 变成…」），
            // examine 抽样里是残留英文的头号来源（4155 个类型里命中 38 次）。
            | "tool_behaviour_name"
            // 餐厅顾客的点单台词（`"I'll take a [份量] of [试剂名]"`）：整句经 say() 说出来，
            // 但它是 proc 返回值、不是 sink 实参，抽取器够不着。
            | "get_order_line"
            // 手术推荐工具名：基类走 `tool::name`（在 obj 目录里），但子类可以**覆盖成字面量**
            // （`get_recommended_tool()` 直接 `return "cybernetic limb"`）。同一列里别的行是中文、
            // 这一行英文，就是这个差别。`get_any_tool()` 的 "Any item" 早就手工收进 _surgery.json，
            // 属同一形状 —— 与其继续一条条手工补，不如把这两个 proc 一起认下来。
            | "get_recommended_tool"
            | "get_any_tool"
            // 照片检查文本：`"You can also see [src] on the photo[受伤 ? ", looking a bit hurt" : ""]…"`
            // 是各 mob 覆盖的 proc 返回值，既不是 sink 实参也不是类型变量，整类够不着。
            | "get_photo_description"
            // 伤口的检查描述（`/datum/wound/…/get_wound_description()`）：整句由各伤口类型覆盖
            // 返回，玩家每次检查伤者都会看到。同为 proc 返回值，抽取器够不着。
            | "get_wound_description"
    )
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
        "examine_list"
            | "examine_text"
            | "examine_strings"
            | "combined_msg"
            | "check_list"
            | "readout"
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
        if let Expression::BinaryOp {
            op: dm::ast::BinaryOp::Add,
            lhs,
            rhs,
        } = e
        {
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
        || trimmed
            .chars()
            .next()
            .is_some_and(|c| c.is_ascii_uppercase());
    if !starts_ok {
        return false;
    }
    let body = trimmed.trim_end_matches(|c: char| c.is_whitespace());
    let body = body.strip_suffix("\\n").unwrap_or(body).trim_end();
    matches!(
        body.chars().last(),
        Some('.') | Some('!') | Some('?') | Some(':')
    )
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
    id.ends_with("options")
        || id.ends_with("choices")
        || id.ends_with("buttons")
        || id.ends_with("items")
}

/// `AddElement(/datum/element/xxx, …)` 里**哪几个位置实参是玩家可见文案**。
///
/// element/component 的构造参数是这个代码库里一整类漏抽：既不是 sink 实参、也不是类型变量，
/// 而 `AddElement` 的位置实参里标识符浓度很高（`chav_replacement.json`、`snow_monkey_alive`、
/// `bayonet_thin`、`mobs_killed_mining`），所以**不能按「长字面量」一刀切**（实测全仓 64 条里
/// 一半是标识符）。按 element 类型逐个登记 —— 与 TGUI 侧 `COMPONENT_PROP_LABELS` 同一条路子。
fn element_display_args(expr: &Expression) -> Option<&'static [usize]> {
    let Expression::Base { term, follow } = expr else {
        return None;
    };
    if !follow.is_empty() {
        return None;
    }
    let Term::Prefab(prefab) = &term.elem else {
        return None;
    };
    // 按**末段**匹配：prefab.path 的前导 `/` 在 AST 里不产生空段，而 element 类型名本身足够独特。
    let path: Vec<&str> = prefab.path.iter().map(|(_, seg)| seg.as_str()).collect();
    match path.last().copied().unwrap_or_default() {
        // 「植入器官」的检查描述：`AddElement(/datum/element/noticable_organ,
        // "%PRONOUN_Their eyes move with machine precision…", BODY_ZONE_PRECISE_EYES)`。
        // 每次检查带改造的人都会显示，全仓 25 条。
        "noticable_organ" => Some(&[1]),
        _ => None,
    }
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

/// 去掉 `{N}` 占位符与 DM 文法宏（`\improper` / `\the` / `\a` / `\s` …）后，是否还剩下真词。
fn has_translatable_words(template: &str) -> bool {
    let without_slots = strip_placeholders(template);
    let mut letters = 0usize;
    let mut chars = without_slots.chars().peekable();
    while let Some(c) = chars.next() {
        if c == '\\' {
            // 文法宏：反斜杠后面那串字母整段跳过。
            while chars.peek().is_some_and(|n| n.is_ascii_alphabetic()) {
                chars.next();
            }
            continue;
        }
        if c.is_alphabetic() {
            letters += 1;
            if letters >= 3 {
                return true;
            }
        }
    }
    false
}

fn is_loose_sentence(template: &str, in_examine: bool) -> bool {
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
    // 尾部的 DM 转义要先剥掉：AST 里 `"…sentenced to:<BR>\n<BR>\n"` 的 `\n` 是**反斜杠加字母 n
    // 两个字符**，去标签之后整串以字母 `n` 收尾，句末标点闸门当场判否 —— 而运行期玩家看到的
    // 是「…判处：」加两个换行。同文件的 is_examine_sentence 一直在剥一个 `\n`，这条漏了。
    // 实测 default_raw_text（预制纸张正文）154 条里有 109 条靠这条闸门进目录，剩下的一批
    // 就卡在这里 —— 法庭「审判」纸的整句判决即此。
    let mut end = lit.trim_end();
    loop {
        let trimmed = end
            .strip_suffix("\\n")
            .or_else(|| end.strip_suffix("\\t"))
            .map(str::trim_end);
        match trimmed {
            Some(next) => end = next,
            None => break,
        }
    }
    let end = end.trim_end_matches(['"', '\'', ')', ']', '*']);
    // 冒号收尾的**标签行**同样是玩家可见文本，而这道闸门原本只认句号/叹号/问号 ——
    // 于是「扫描仪/记录/回合结算」那一整类整齐地漏在外面。同文件的 is_examine_sentence 一直认
    // 冒号，两条闸门对同一种形状给出相反判定，判据就是这么分叉的。实测同 proc 内的对比：
    //   `Subject contains no reagents in their stomach.`   → 在目录
    //   `Subject contains the following reagents in their stomach:` → 不在
    // 冒号不会放宽标识符面：前面已经要求「≥10 字符 + 含空格 + 首字母大写」，而 `switch` 键、
    // 黑板键、图标名不长这样。
    if !(end.ends_with(['.', '!', '?', '…']) || end.ends_with("...")) {
        // 冒号收尾的**标签行**同样是玩家可见文本（`Subject contains the following reagents in
        // their stomach:`、回合结算的 `Station Economic Summary:`），而这道闸门原本只认句号系，
        // 于是「扫描仪 / 记录 / 结算」那一整类整齐地漏在外面 —— 同一个 proc 里句号那行在目录、
        // 冒号那行不在。同文件的 is_examine_sentence 一直是认冒号的，两条闸门对同一种形状给出
        // 相反判定。
        //
        // 但**只放行不含占位符的**。实测直接开冒号会涌进 511 条，绝大多数是管理员日志与调试断言
        // （`{0} Invalid timer state: …`、`{0}:{1}:Assertion failed: {2}{3}`、watchlist 通报）——
        // 它们走的是 message_admins/CRASH 这些 is_non_player_sink 够不着的汇聚点，而「冒号 +
        // 插值」正是日志行的典型形状。纯静态的冒号标签行没有这个问题。
        // 例外：examine/扫描仪渲染 proc 内允许「冒号 + 占位符」。上面那条闸门挡的是日志行，
        // 而日志不会写在 examine 家族的 proc 里。实测反差就在同一个 proc 的相邻两行：
        //   `Subject contains no reagents in their {0}stream.`        → 句号，在目录
        //   `Subject contains the following reagents in their {0}stream:` → 冒号 + 占位符，不在
        // 全局放开这一条会涌进 366 条管理面板/调试行（TGS 版本、admin 表单、PM 日志），实测过。
        if !end.ends_with(':') || (template.contains('{') && !in_examine) {
            return false;
        }
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
/// emit_list_strings 的带黑名单变体：攻击动词池用它挡掉「同时被当标识符」的那批
/// （见 ATTACK_VERB_IDENT_BLOCKLIST）。
fn emit_list_strings_filtered(
    expr: &Expression,
    ns: &str,
    catalog: &mut Catalog,
    blocklist: &[&str],
) {
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
            if blocklist.contains(&t.as_str()) {
                continue;
            }
            emit(catalog, ns, &t);
        }
    }
}

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
                    if matches!(
                        build_template(lhs).as_deref(),
                        Some("name") | Some("description")
                    ) {
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

/// 语句里的顶层表达式（不下探子块）。给 walk_lang_arg_locals 的两趟扫描共用。
fn for_each_statement_expr(stmt: &Statement, f: &mut impl FnMut(&Expression)) {
    match stmt {
        Statement::Expr(e) => f(e),
        Statement::Return(Some(e)) | Statement::Throw(e) | Statement::Del(e) => f(e),
        Statement::If { arms, .. } => {
            for (cond, _) in arms.iter() {
                f(&cond.elem);
            }
        }
        Statement::Switch { input, .. } => f(input),
        Statement::While { condition, .. } => f(condition),
        Statement::DoWhile { condition, .. } => f(&condition.elem),
        _ => {}
    }
}

/// 语句里的子块（控制流）。
fn for_each_statement_block(stmt: &Statement, f: &mut impl FnMut(&[dm::ast::Spanned<Statement>])) {
    match stmt {
        Statement::If { arms, else_arm } => {
            for (_c, blk) in arms.iter() {
                f(blk);
            }
            if let Some(blk) = else_arm {
                f(blk);
            }
        }
        Statement::Switch { cases, default, .. } => {
            for (_c, blk) in cases.iter() {
                f(blk);
            }
            if let Some(blk) = default {
                f(blk);
            }
        }
        Statement::While { block, .. }
        | Statement::DoWhile { block, .. }
        | Statement::ForInfinite { block }
        | Statement::ForLoop { block, .. }
        | Statement::Spawn { block, .. } => f(block),
        _ => {}
    }
}

/// proc 体内的 `name = "字面量"` / `desc = "…"` 赋值。
///
/// 类型变量那条路（SINK_VARS）只看**声明**，够不着 `switch(caste)` 里按分支改名的那批：
/// `if(ALIEN_RAVAGER) name = "alien ravager"`。实例名偏离 `initial(name)` 之后，显示边界的类型表
/// 也对不上（那张表按 `initial(name)` 取键）→ 只剩整串反查，而这串从没进过目录，玩家看到
/// 「The alien ravager」（实测计数直接打满）。
///
/// 两道闸门：
///   · **多词**：`name = "Show"` / `"Hide"` / `"Zip"` 这类是 UI 开关词与标识符，单词一律不收；
///   · **类型是 atom**（`/obj`|`/mob`|`/turf`|`/area`）：atom 的 name/desc 按定义是显示文本，
///     而 `/datum/...` 的 name 里标识符浓度很高（verb 元数据、资源 id）—— 与 MT 那条 atom-scope
///     判据同源，都是「`#name` 本身不足以证明它是文案」。
fn walk_name_assignments(block: &[dm::ast::Spanned<Statement>], ns: &str, catalog: &mut Catalog) {
    for stmt in block.iter() {
        for_each_statement_expr(&stmt.elem, &mut |expr| {
            let Expression::AssignOp { lhs, rhs, .. } = expr else {
                return;
            };
            let Expression::Base { term, follow } = lhs.as_ref() else {
                return;
            };
            let target = match (&term.elem, follow.first().map(|f| &f.elem)) {
                (Term::Ident(name), None) => Some(name.as_str()),
                // `src.name = …` / `holder.name = …`
                (_, Some(Follow::Field(_, field))) => Some(field.as_str()),
                _ => None,
            };
            if !matches!(target, Some("name") | Some("desc")) {
                return;
            }
            // 插值模板同样要收：这些行几乎都是 `"remove [initial(organ.name)]"` 这种运行期拼的
            // （`build_template` 对「去标签后不含字母」的表达式返回 None，纯占位符的形状自然被挡）。
            let Some(text) = plain_string(rhs) else {
                return;
            };
            if !text.trim().contains(' ') {
                return;
            }
            emit(catalog, ns, text.trim());
        });
        for_each_statement_block(&stmt.elem, &mut |inner| {
            walk_name_assignments(inner, ns, catalog)
        });
    }
}

/// `X.info = "…"`：径向菜单选项（`/datum/radial_menu_choice`）的悬停说明。
///
/// 与 `name`/`desc` 分开走，因为闸门不同：
///   · `name`/`desc` 只收**纯字符串**、且只对 atom 开 —— `/datum/…#name` 里标识符浓度高，
///     而运行期拼出来的合成名（`"\improper [区域] APC"`、`"burnt [x]"`）由显示边界按段处理，
///     收进目录既没用又会把 lint 的碰撞告警顶上去（实测 226 条新增、告警 54 → 63）。
///   · `info` 是纯显示字段（选项标识符走同一 list 里的 OPERATION_ACTION），而且几乎都是
///     `"Remove [initial(organ.name)] from the patient."` 这种插值模板 —— 不收模板就等于没收。
fn walk_info_assignments(block: &[dm::ast::Spanned<Statement>], ns: &str, catalog: &mut Catalog) {
    // 先找出这个 proc 里**被赋过 `.info` 的变量**——那就是径向菜单选项。它的 `.name`（切片上的
    // 短标签，`"remove [器官名]"`）同样是显示文本，但对**所有** `.name` 放开插值模板太宽
    // （合成名整片涌进来），所以用「同一个变量也设了 info」当准入证据。
    let mut choice_idents = std::collections::HashSet::new();
    collect_info_assigned_idents(block, &mut choice_idents);
    walk_choice_display_fields(block, ns, catalog, &choice_idents);
}

fn collect_info_assigned_idents(
    block: &[dm::ast::Spanned<Statement>],
    out: &mut std::collections::HashSet<String>,
) {
    for stmt in block.iter() {
        for_each_statement_expr(&stmt.elem, &mut |expr| {
            let Expression::AssignOp { lhs, .. } = expr else {
                return;
            };
            let Expression::Base { term, follow } = lhs.as_ref() else {
                return;
            };
            let Term::Ident(name) = &term.elem else {
                return;
            };
            if matches!(follow.first().map(|f| &f.elem), Some(Follow::Field(_, field)) if field == "info")
            {
                out.insert(name.clone());
            }
        });
        for_each_statement_block(&stmt.elem, &mut |inner| collect_info_assigned_idents(inner, out));
    }
}

fn walk_choice_display_fields(
    block: &[dm::ast::Spanned<Statement>],
    ns: &str,
    catalog: &mut Catalog,
    choices: &std::collections::HashSet<String>,
) {
    for stmt in block.iter() {
        for_each_statement_expr(&stmt.elem, &mut |expr| {
            let Expression::AssignOp { lhs, rhs, .. } = expr else {
                return;
            };
            let Expression::Base { term, follow } = lhs.as_ref() else {
                return;
            };
            let Term::Ident(ident) = &term.elem else {
                return;
            };
            let Some(Follow::Field(_, field)) = follow.first().map(|f| &f.elem) else {
                return;
            };
            let wanted = match field.as_str() {
                "info" => true,
                "name" => choices.contains(ident.as_str()),
                _ => false,
            };
            if !wanted {
                return;
            }
            let Some(template) = build_template(rhs) else {
                return;
            };
            let trimmed = template.trim();
            if !trimmed.contains(' ') || !has_translatable_words(trimmed) {
                return;
            }
            emit(catalog, ns, trimmed);
        });
        for_each_statement_block(&stmt.elem, &mut |inner| {
            walk_choice_display_fields(inner, ns, catalog, choices)
        });
    }
}

/// 「局部变量一跳」：proc 里赋给**后来被当作 LANG 实参**的局部变量的字符串字面量。
///
/// 这是复发过好几次的一类。上游把一句话拆成
/// ```dm
/// var/subject
/// switch(kind)
///     if("left")  subject = "the left side of your body"
/// to_chat(user, LANG("mob.xxxx", list(subject)))
/// ```
/// 之后：模板抽到了、也译了，而 `subject` 的那几个字面量既不是 sink 实参、也不是类型变量、
/// 更不是 LANG 实参子树里的字面量（子树里只有标识符 `subject`）→ **一条都进不了目录**，
/// 玩家看到的是「你的{中文模板}the left side of your body」。
/// 同形的还有 `suffixes += " Targetable by contractors."` 这类局部累加器。
///
/// 两趟：先收集「在 LANG 实参位置出现过的裸标识符」，再收集赋给这些标识符的字面量。
/// 闸门复用 LANG 实参那条 `is_lang_arg_text`（去标签后须多词）—— 局部变量名下的标识符浓度
/// 比类型变量高得多（`var/action = "toggle"`），单 token 一律不收。
fn walk_lang_arg_locals(
    block: &[dm::ast::Spanned<Statement>],
    ns: &str,
    catalog: &mut Catalog,
    in_unit_tests: bool,
) {
    // 单测里的断言字面量（`"SSShe isss ssso sssasssy"`）同样是「赋给局部变量、再插进一条消息」的
    // 形状。step 1 的类型变量那条路早就按**声明所在文件**排除了 unit_tests，proc 体这条路没有 ——
    // 不挡就会把测试夹具串永久写进只增不减的目录。
    if in_unit_tests {
        return;
    }
    let mut names = std::collections::HashSet::new();
    collect_lang_arg_idents_block(block, &mut names);
    collect_examine_accumulator_idents(block, &mut names);
    if names.is_empty() {
        return;
    }
    // **一跳往往不够**：`magnitude` → `label_line` → `readout`（examine 累加器）这种两跳链上，
    // 中间那个变量才是显示位置认得的那个，末端的字面量还差一层。把「赋给已收集变量的值里，
    // 插值槽中的裸标识符」也收进来，反复到不动点为止。
    //
    // 准入面**没有**因此放宽：种子仍然只有「出现在 LANG 实参 / sink 显示槽里的标识符」，
    // 闸门仍然是 is_lang_arg_text（多词）。放宽的只是「离显示位置几跳」。
    for _ in 0..4 {
        let mut next = names.clone();
        collect_assigned_slot_idents(block, &names, &mut next);
        if next.len() == names.len() {
            break;
        }
        names = next;
    }
    // 注：**「同槽兄弟」这条判据不能从 pick 词池搬到普通局部变量上**。词池的成员按构造可以
    // 互换，所以整池同性质；而一个在分支里被反复赋值的局部变量，常常一支放句子、另一支放
    // 模式键。实测放开后涌进 `imported_abilities` / `OOC` / `PRAYER` / `Warrant` / `cold` /
    // `hot` / `low` / `high` 这些，lint 当场 1 错误 + 8 条新碰撞。
    // 例外与 pick 词池同源：变量被喂进 `plural_s()` 就证明它装的是**显示动词**（那个 proc 只对
    // 要跟主语数配合的英文动词有意义，查表键不会经过它），于是它那些单 token 值也放行。
    // 投掷消息里 `verb_text` 先 `pick(…)` 再 `if(prob(0.5)) verb_text = "yeet"` —— 池收进来了，
    // 这条直接赋值的没有，玩家看到「你yeet廉价打火机。」。
    let mut pluralized = std::collections::HashSet::new();
    collect_pluralized_idents(block, &mut pluralized);
    let mut grouped = std::collections::BTreeMap::new();
    collect_local_assign_groups(block, &names, &mut grouped);
    for (var_name, group) in grouped {
        let verb_slot = pluralized.contains(&var_name);
        for literal in group {
            if is_lang_arg_text(&literal) || (verb_slot && !literal.trim().is_empty()) {
                emit(catalog, ns, literal.trim());
            }
        }
    }
    let mut literals = Vec::new();
    collect_local_list_literal_values(block, &names, &mut literals);
    for literal in literals {
        if is_lang_arg_text(&literal) {
            emit(catalog, ns, literal.trim());
        }
    }
    // `var/cause = pick("space being cold", "climate change", …)` 之后 `LANG(key, list(cause))`：
    // 词池整条是 flavor 备选，本来就是给玩家看的，但它既过不了激进 pass 的整句闸门（无句末标点、
    // 小写起头），赋值右侧又是 `pick` 而不是字符串 —— 上面那一跳看不见它。症状是模板译好、实参
    // 全英文：「由于space being cold，a pack of squeaking things已migrated到maintenance tunnels。」
    //
    // 这里**不用**多词闸门，改用**同池兄弟**做判据：只要池里有一条是多词显示文本，整池就一起收。
    // 道理是词池的成员按构造可以互换 —— 一个位置既能填 "squeaking things" 又能填 "mice"，那它
    // 就是个显示槽，不可能同时是标识符槽。多词闸门在这里恰恰会切出最难看的结果（长的译了、
    // 短的没译，`已migrated到`）。全池皆单词的（`pick("attack", "disarm")`）不收。
    let mut compared = std::collections::HashSet::new();
    collect_compared_idents(block, &mut compared);
    let mut pools = Vec::new();
    collect_local_pick_pools(block, &names, &mut pools);
    for (var_name, pool) in pools {
        // **被比较过的变量，它的池是标识符池**。`var/brand = pick("Ebisu Super Dry", …)` 紧接着
        // `switch(brand) if("Ebisu Super Dry")` —— 品牌名同时是查表键，进目录就多一条全局反查
        // 面（`nova-i18n lint` 的碰撞规则当场报）。这是抽取期就能做的、与 lint 同一个判断。
        if compared.contains(&var_name) {
            continue;
        }
        // 准入证据有两条，满足其一即可：
        //  ① 同池里有多词显示文本 —— 池成员按构造可以互换，一个位置既能填 `squeaking things`
        //     又能填 `mice`，那它就是显示槽。
        //  ② 这个变量被喂进了**英文动词一致性助手**（`plural_s`/`p_s`/`p_es`）。那类 proc 只对
        //     「要跟主语数配合的动词」才有意义，程序查表的键不会经过它 —— 于是它就是「这是显示
        //     动词」的结构性证明，全池皆单词也放行。投掷动词池
        //     `pick("throw","toss","hurl","chuck","fling")` 即此：模板早就 LANG 化也译好了，
        //     填进去的动词却一直是英文（玩家看到「你chuck廉价打火机。」）。
        if !pool.iter().any(|literal| is_lang_arg_text(literal)) && !pluralized.contains(&var_name)
        {
            continue;
        }
        for literal in pool {
            emit(catalog, ns, literal.trim());
        }
    }
}

/// 在本 proc 里被喂进**英文动词一致性助手**的裸标识符（`plural_s(x)` / `p_s(x)` / `p_es(x)`）。
///
/// 这几个 proc 的职责是给英文动词补主语一致的词尾，只有「显示动词」才会经过它们 —— 程序查表
/// 用的键、act 回传值、黑板键都不会。所以它是一条比「同池有没有多词兄弟」更强的准入证据，
/// 足以让**全池皆单词**的动词池也进目录。
fn collect_pluralized_idents(
    block: &[dm::ast::Spanned<Statement>],
    out: &mut std::collections::HashSet<String>,
) {
    fn scan(expr: &Expression, out: &mut std::collections::HashSet<String>) {
        match expr {
            Expression::BinaryOp { lhs, rhs, .. } => {
                scan(lhs, out);
                scan(rhs, out);
            }
            Expression::AssignOp { rhs, .. } => scan(rhs, out),
            Expression::TernaryOp { cond, if_, else_ } => {
                scan(cond, out);
                scan(if_, out);
                scan(else_, out);
            }
            Expression::Base { term, .. } => match &term.elem {
                Term::Call(name, args) => {
                    if matches!(name.as_str(), "plural_s" | "p_s" | "p_es") {
                        for arg in args.iter() {
                            if let Expression::Base { term, follow } = arg {
                                if follow.is_empty() {
                                    if let Term::Ident(ident) = &term.elem {
                                        out.insert(ident.clone());
                                    }
                                }
                            }
                        }
                    }
                    for arg in args.iter() {
                        scan(arg, out);
                    }
                }
                Term::Expr(inner) => scan(inner, out),
                Term::List(args) => {
                    for arg in args.iter() {
                        scan(arg, out);
                    }
                }
                _ => {}
            },
        }
    }
    for stmt in block.iter() {
        for_each_statement_expr(&stmt.elem, &mut |expr| scan(expr, out));
        for_each_statement_block(&stmt.elem, &mut |b| collect_pluralized_idents(b, out));
    }
}

/// 在本 proc 里被拿去**比较**的裸标识符：`switch(x)` 的主语，以及 `x == …` / `… == x`。
fn collect_compared_idents(
    block: &[dm::ast::Spanned<Statement>],
    out: &mut std::collections::HashSet<String>,
) {
    fn note(expr: &Expression, out: &mut std::collections::HashSet<String>) {
        if let Expression::Base { term, follow } = expr {
            if follow.is_empty() {
                if let Term::Ident(name) = &term.elem {
                    out.insert(name.clone());
                }
            }
        }
    }
    fn scan(expr: &Expression, out: &mut std::collections::HashSet<String>) {
        match expr {
            Expression::BinaryOp { op, lhs, rhs } => {
                if matches!(op, dm::ast::BinaryOp::Eq | dm::ast::BinaryOp::NotEq) {
                    note(lhs, out);
                    note(rhs, out);
                }
                // `fluid_type in GLOB.fish_compatible_fluid_types[…]`：成员判定同样说明这个值是
                // 程序查表用的键。鱼类赏金的 `pick(AQUARIUM_FLUID_FRESHWATER, …)` 就是这形状 ——
                // 它既进 name/description 显示，又拿去 `in` 判定，是典型的「值兼标识符」。
                if matches!(op, dm::ast::BinaryOp::In) {
                    note(lhs, out);
                }
                scan(lhs, out);
                scan(rhs, out);
            }
            Expression::AssignOp { rhs, .. } => scan(rhs, out),
            Expression::TernaryOp { cond, if_, else_ } => {
                scan(cond, out);
                scan(if_, out);
                scan(else_, out);
            }
            Expression::Base { term, .. } => {
                if let Term::Expr(inner) = &term.elem {
                    scan(inner, out);
                }
            }
        }
    }
    for stmt in block.iter() {
        if let Statement::Switch { input, .. } = &stmt.elem {
            note(input, out);
        }
        for_each_statement_expr(&stmt.elem, &mut |e| scan(e, out));
        for_each_statement_block(&stmt.elem, &mut |b| collect_compared_idents(b, out));
    }
}

/// 赋给目标标识符的 `pick(...)` 词池成员（含权重语法 `pick(50;"a", 50;"b")` 的值那一侧）。
fn collect_local_pick_pools(
    block: &[dm::ast::Spanned<Statement>],
    names: &std::collections::HashSet<String>,
    out: &mut Vec<(String, Vec<String>)>,
) {
    fn push_pool(name: &str, expr: &Expression, out: &mut Vec<(String, Vec<String>)>) {
        let Expression::Base { term, follow } = expr else {
            return;
        };
        if !follow.is_empty() {
            return;
        }
        match &term.elem {
            Term::Pick(args) => {
                let mut pool = Vec::new();
                for (_, value) in args.iter() {
                    push_assigned_literals(value, &mut pool);
                }
                if !pool.is_empty() {
                    out.push((name.to_owned(), pool));
                }
            }
            Term::Expr(inner) => push_pool(name, inner, out),
            _ => {}
        }
    }
    for stmt in block.iter() {
        if let Statement::Var(var_stmt) = &stmt.elem {
            if names.contains(&var_stmt.name) {
                if let Some(value) = &var_stmt.value {
                    push_pool(&var_stmt.name, value, out);
                }
            }
        }
        // **只认 `var/x = pick(...)` 这种 proc 内声明**，不认对已有变量的赋值。
        // `fluid_type = pick(AQUARIUM_FLUID_FRESHWATER, …)` 里 fluid_type 是 datum 的类型变量，
        // 值会逃出本 proc、在**别的 proc** 里被 `in` 判定（`can_ship_fish`）—— 本 proc 内的
        // 「有没有被比较过」扫描根本看不见它。局部声明的变量生命周期完整可见，才敢按池收。
        for_each_statement_block(&stmt.elem, &mut |b| collect_local_pick_pools(b, names, out));
    }
}

/// 收集**插值串的槽**里的字符串字面量（穿过 `span_*()` 包装与三元/pick 分支）。
///
/// `poll_question = "Do you want to be a [span_green("[cond ? \"mindless zombie\" : \"zombie\"]")]?"`：
/// 整句模板早就进目录、也译好了，可槽里那两个字面量既不是 sink 实参也不是类型变量 ——
/// 运行期模板引擎逆匹配捕获到的正是它们，于是玩家看到「你想成为一个 mindless zombie 吗？」。
/// 闸门沿用 LANG 实参那条（多词），单 token 不收。
fn collect_interp_slot_literals(expr: &Expression, out: &mut Vec<String>) {
    match expr {
        Expression::Base { term, .. } => match &term.elem {
            Term::InterpString(_, parts) => {
                for (opt, _) in parts.iter() {
                    if let Some(e) = opt {
                        push_assigned_literals(e, out);
                        collect_interp_slot_literals(e, out);
                    }
                }
            }
            Term::Call(_, args) | Term::List(args) => {
                for a in args.iter() {
                    collect_interp_slot_literals(a, out);
                }
            }
            Term::Expr(inner) => collect_interp_slot_literals(inner, out),
            _ => {}
        },
        Expression::BinaryOp { lhs, rhs, .. } => {
            collect_interp_slot_literals(lhs, out);
            collect_interp_slot_literals(rhs, out);
        }
        Expression::TernaryOp { if_, else_, .. } => {
            collect_interp_slot_literals(if_, out);
            collect_interp_slot_literals(else_, out);
        }
        _ => {}
    }
}

/// 收集**插值串的槽**里的裸标识符（穿过 `span_*()` 之类的包装调用）。
/// 与 `collect_bare_idents` 的区别：那个收的是整棵实参子树里的裸 ident，这个只下探到插值槽。
fn collect_interp_slot_idents(expr: &Expression, out: &mut std::collections::HashSet<String>) {
    match expr {
        Expression::Base { term, .. } => match &term.elem {
            Term::InterpString(_, parts) => {
                for (opt, _) in parts.iter() {
                    if let Some(e) = opt {
                        collect_bare_idents(e, out);
                    }
                }
            }
            // `span_warning("…[x]…")` / `"[a]" + "[b]"` 之类的包装。
            Term::Call(_, args) | Term::List(args) => {
                for a in args.iter() {
                    collect_interp_slot_idents(a, out);
                }
            }
            Term::Expr(inner) => collect_interp_slot_idents(inner, out),
            _ => {}
        },
        Expression::BinaryOp { lhs, rhs, .. } => {
            collect_interp_slot_idents(lhs, out);
            collect_interp_slot_idents(rhs, out);
        }
        Expression::TernaryOp { if_, else_, .. } => {
            collect_interp_slot_idents(if_, out);
            collect_interp_slot_idents(else_, out);
        }
        _ => {}
    }
}

/// examine 累加器 `+=` 右值里的裸标识符 —— 与 LANG 实参、sink 显示槽同为「显示位置」。
///
/// `readout += label_line` 这种把整行先攒在一个局部变量里、最后一次性追加的写法很常见；
/// 不把 `label_line` 当种子，它上游的 `magnitude`（switch 里赋的形容词）就永远差一跳。
fn collect_examine_accumulator_idents(
    block: &[dm::ast::Spanned<Statement>],
    out: &mut std::collections::HashSet<String>,
) {
    for stmt in block.iter() {
        for_each_statement_expr(&stmt.elem, &mut |e| {
            let Expression::AssignOp { lhs, rhs, .. } = e else {
                return;
            };
            let Expression::Base { term, follow } = lhs.as_ref() else {
                return;
            };
            if !follow.is_empty() {
                return;
            }
            let Term::Ident(name) = &term.elem else {
                return;
            };
            if name == "." || is_examine_accumulator(name) {
                collect_bare_idents(rhs, out);
            }
        });
        for_each_statement_block(&stmt.elem, &mut |b| collect_examine_accumulator_idents(b, out));
    }
}

fn collect_lang_arg_idents_block(
    block: &[dm::ast::Spanned<Statement>],
    out: &mut std::collections::HashSet<String>,
) {
    for stmt in block.iter() {
        // `gain_text = span_warning("You can't feel [subject] anymore!")`：赋给 **SINK_VARS 同名
        // 变量**的插值串同样会进目录（那批变量名就是「玩家可见文案」的定义），槽里的局部变量照收。
        if let Statement::Expr(Expression::AssignOp { lhs, rhs, .. }) = &stmt.elem {
            if let Expression::Base { term, follow } = lhs.as_ref() {
                let name = match &term.elem {
                    Term::Ident(name) if follow.is_empty() => Some(name.as_str()),
                    Term::Ident(_) => match follow.first().map(|f| &f.elem) {
                        Some(Follow::Field(_, field)) => Some(field.as_str()),
                        _ => None,
                    },
                    _ => None,
                };
                if name.is_some_and(|n| SINK_VARS.contains(&n)) {
                    collect_interp_slot_idents(rhs, out);
                }
            }
        }
        // **`var/x = <含 LANG 的表达式>` 的初值也要看**：`for_each_statement_expr` 不覆盖
        // Statement::Var 的初始化式（`collect_local_assign_groups` 之所以要单独处理 Var，就是
        // 这个原因）。漏掉它的后果很隐蔽：`var/t = cond ? LANG(key, list(magnitude)) : ""`
        // 里的 `magnitude` 收不进种子 → 它那几个 switch 分支的形容词一条都不进目录，
        // 而模板早已译好 —— 又是「模板中文、实参英文」。
        if let Statement::Var(var_stmt) = &stmt.elem {
            if let Some(value) = &var_stmt.value {
                collect_lang_arg_idents_expr(value, out);
            }
        }
        for_each_statement_expr(&stmt.elem, &mut |e| collect_lang_arg_idents_expr(e, out));
        for_each_statement_block(&stmt.elem, &mut |b| collect_lang_arg_idents_block(b, out));
    }
}

fn collect_lang_arg_idents_expr(expr: &Expression, out: &mut std::collections::HashSet<String>) {
    match expr {
        Expression::Base { term, follow } => {
            if let Term::Call(name, args) = &term.elem {
                // 插值槽里的局部变量：`gain_text = span_warning("You can't feel [subject] anymore!")`。
                // 整句作为模板早就在目录里、也译好了，运行期由模板引擎逆匹配捕获 `{0}` 再递归本地化
                // —— 但捕获到的是 `subject` 里那个**英文字面量**，而它从没进过目录。
                //
                // 准入面**必须限死在「本来就会进目录的显示模板」上**：一开始写成「proc 里任何插值串
                // 的槽」，一次抽取就混进单测断言串（`SSShe isss ssso sssasssy`）、单位格式化的期望值
                // （`535 mA`）、管理面板 HTML 骨架、`callback.object is null.` 这类调试串 —— 而目录
                // 只增不减，脏键进去就永久留着。只认 sink 调用的实参这一种形状。
                if let Some(indices) = sink_message_args(name.as_str()) {
                    let skip_two = native_dialog_no_usr(name.as_str(), args);
                    for &idx in indices {
                        if skip_two && idx == 2 {
                            continue;
                        }
                        if let Some((_, arg)) = resolve_sink_arg(name.as_str(), idx, args) {
                            collect_interp_slot_idents(arg, out);
                        }
                    }
                }
                if let Some(idx) = lang_format_key_index(name.as_str()) {
                    for (i, a) in args.iter().enumerate() {
                        if i > idx {
                            collect_bare_idents(a, out);
                        }
                    }
                }
                for a in args.iter() {
                    collect_lang_arg_idents_expr(a, out);
                }
            }
            if let Term::Expr(inner) = &term.elem {
                collect_lang_arg_idents_expr(inner, out);
            }

            if let Term::List(args) | Term::SelfCall(args) | Term::ParentCall(args) = &term.elem {
                for a in args.iter() {
                    collect_lang_arg_idents_expr(a, out);
                }
            }
            for f in follow.iter() {
                if let Follow::Call(_, name, args) = &f.elem {
                    if let Some(indices) = sink_message_args(name.as_str()) {
                        let skip_two = native_dialog_no_usr(name.as_str(), args);
                        for &idx in indices {
                            if skip_two && idx == 2 {
                                continue;
                            }
                            if let Some((_, arg)) = resolve_sink_arg(name.as_str(), idx, args) {
                                collect_interp_slot_idents(arg, out);
                            }
                        }
                    }
                    if let Some(idx) = lang_format_key_index(name.as_str()) {
                        for (i, a) in args.iter().enumerate() {
                            if i > idx {
                                collect_bare_idents(a, out);
                            }
                        }
                    }
                    for a in args.iter() {
                        collect_lang_arg_idents_expr(a, out);
                    }
                }
            }
        }
        Expression::BinaryOp { lhs, rhs, .. } => {
            collect_lang_arg_idents_expr(lhs, out);
            collect_lang_arg_idents_expr(rhs, out);
        }
        Expression::AssignOp { rhs, .. } => collect_lang_arg_idents_expr(rhs, out),
        Expression::TernaryOp { cond, if_, else_ } => {
            collect_lang_arg_idents_expr(cond, out);
            collect_lang_arg_idents_expr(if_, out);
            collect_lang_arg_idents_expr(else_, out);
        }
    }
}

/// LANG 实参子树里的**裸标识符**（`subject`、`suffix`）。`x.y` 这种带 follow 的不收：
/// 那是别人的字段，赋值点不在本 proc 里，回收它只会把无关字面量拖进来。
fn collect_bare_idents(expr: &Expression, out: &mut std::collections::HashSet<String>) {
    match expr {
        Expression::Base { term, follow } => {
            if follow.is_empty() {
                if let Term::Ident(name) = &term.elem {
                    out.insert(name.clone());
                }
            }
            // `ops[mode]`：**局部查表**的显示标签。`x.y` 不收是因为赋值点不在本 proc，但下标查的
            // 那张表往往就在同一个 proc 里（`var/static/list/ops = list(WAND_OPEN = "Open Door", …)`
            // 再 `LANG(key, list(ops[mode]))`）。模板译好了、实参永远是英文 —— 安保门遥控器那条
            // 「模式：Open Door」即此。收集名字，值由 collect_local_list_literal_values 去取。
            if follow.len() == 1 && matches!(&follow[0].elem, Follow::Index(..)) {
                if let Term::Ident(name) = &term.elem {
                    out.insert(name.clone());
                }
            }
            match &term.elem {
                Term::Expr(inner) => collect_bare_idents(inner, out),
                Term::List(args) => {
                    for a in args.iter() {
                        collect_bare_idents(a, out);
                    }
                }
                Term::Call(name, args) => {
                    let key_idx = lang_format_key_index(name.as_str());
                    for (i, a) in args.iter().enumerate() {
                        if Some(i) == key_idx {
                            continue;
                        }
                        collect_bare_idents(a, out);
                    }
                }
                _ => {}
            }
        }
        Expression::BinaryOp { lhs, rhs, .. } => {
            collect_bare_idents(lhs, out);
            collect_bare_idents(rhs, out);
        }
        Expression::AssignOp { rhs, .. } => collect_bare_idents(rhs, out),
        Expression::TernaryOp { cond, if_, else_ } => {
            collect_bare_idents(cond, out);
            collect_bare_idents(if_, out);
            collect_bare_idents(else_, out);
        }
    }
}

/// `name = "…"` / `name += "…"`（含 `var/name = "…"` 声明初值）里赋给目标标识符的字面量。
fn collect_local_assign_literals(
    block: &[dm::ast::Spanned<Statement>],
    names: &std::collections::HashSet<String>,
    out: &mut Vec<String>,
) {
    let mut by_variable = std::collections::BTreeMap::new();
    collect_local_assign_groups(block, names, &mut by_variable);
    for literals in by_variable.into_values() {
        out.extend(literals);
    }
}

/// 同上，但**按变量分组**——单词值的准入要看同一个槽里的兄弟值（见 walk_lang_arg_locals）。
fn collect_local_assign_groups(
    block: &[dm::ast::Spanned<Statement>],
    names: &std::collections::HashSet<String>,
    out: &mut std::collections::BTreeMap<String, Vec<String>>,
) {
    for stmt in block.iter() {
        if let Statement::Var(var_stmt) = &stmt.elem {
            if names.contains(&var_stmt.name) {
                if let Some(value) = &var_stmt.value {
                    push_assigned_literals(value, out.entry(var_stmt.name.clone()).or_default());
                }
            }
        }
        for_each_statement_expr(&stmt.elem, &mut |e| {
            if let Expression::AssignOp { lhs, rhs, .. } = e {
                if let Expression::Base { term, follow } = lhs.as_ref() {
                    if follow.is_empty() {
                        if let Term::Ident(name) = &term.elem {
                            if names.contains(name) {
                                push_assigned_literals(rhs, out.entry(name.clone()).or_default());
                            }
                        }
                    }
                }
            }
        });
        for_each_statement_block(&stmt.elem, &mut |b| {
            collect_local_assign_groups(b, names, out)
        });
    }
}

/// 「赋给已收集变量的值」里，**插值槽**中的裸标识符 —— 局部变量链的下一跳。
fn collect_assigned_slot_idents(
    block: &[dm::ast::Spanned<Statement>],
    names: &std::collections::HashSet<String>,
    out: &mut std::collections::HashSet<String>,
) {
    for stmt in block.iter() {
        if let Statement::Var(var_stmt) = &stmt.elem {
            if names.contains(&var_stmt.name) {
                if let Some(value) = &var_stmt.value {
                    collect_interp_slot_idents(value, out);
                }
            }
        }
        for_each_statement_expr(&stmt.elem, &mut |e| {
            if let Expression::AssignOp { lhs, rhs, .. } = e {
                if let Expression::Base { term, follow } = lhs.as_ref() {
                    if follow.is_empty() {
                        if let Term::Ident(name) = &term.elem {
                            if names.contains(name) {
                                collect_interp_slot_idents(rhs, out);
                            }
                        }
                    }
                }
            }
        });
        for_each_statement_block(&stmt.elem, &mut |b| collect_assigned_slot_idents(b, names, out));
    }
}

/// 赋给目标标识符的 **list 字面量的值**（`ops = list(WAND_OPEN = "Open Door", …)`）。
///
/// 只取值，不取键：这里的键是 `#define` 出来的模式常量（`WAND_OPEN`），是程序查表用的。
/// 与「值是类型路径 ⇒ 键才是标签」那条规则正好互为反面 —— 判据是**哪一边被当作 LANG 实参
/// 送出去显示**，而不是形状。闸门仍由调用方的 `is_lang_arg_text`（多词）把关。
fn collect_local_list_literal_values(
    block: &[dm::ast::Spanned<Statement>],
    names: &std::collections::HashSet<String>,
    out: &mut Vec<String>,
) {
    fn push_list_values(expr: &Expression, out: &mut Vec<String>) {
        let Expression::Base { term, follow } = expr else {
            return;
        };
        if !follow.is_empty() {
            return;
        }
        let Term::List(args) = &term.elem else {
            return;
        };
        for arg in args.iter() {
            match arg {
                Expression::AssignOp { rhs, .. } => push_assigned_literals(rhs, out),
                other => push_assigned_literals(other, out),
            }
        }
    }
    for stmt in block.iter() {
        if let Statement::Var(var_stmt) = &stmt.elem {
            if names.contains(&var_stmt.name) {
                if let Some(value) = &var_stmt.value {
                    push_list_values(value, out);
                }
            }
        }
        for_each_statement_expr(&stmt.elem, &mut |e| {
            if let Expression::AssignOp { lhs, rhs, .. } = e {
                if let Expression::Base { term, follow } = lhs.as_ref() {
                    if follow.is_empty() {
                        if let Term::Ident(name) = &term.elem {
                            if names.contains(name) {
                                push_list_values(rhs, out);
                            }
                        }
                    }
                }
            }
        });
        for_each_statement_block(&stmt.elem, &mut |b| {
            collect_local_list_literal_values(b, names, out)
        });
    }
}

fn push_assigned_literals(expr: &Expression, out: &mut Vec<String>) {
    match expr {
        Expression::Base { term, follow } if follow.is_empty() => match &term.elem {
            Term::String(text) => out.push(text.clone()),
            Term::Expr(inner) => push_assigned_literals(inner, out),
            _ => {}
        },
        Expression::TernaryOp { if_, else_, .. } => {
            push_assigned_literals(if_, out);
            push_assigned_literals(else_, out);
        }
        _ => {}
    }
}

/// 走 examine_tags proc 体，抽 `.["tag"] = "悬浮提示文本"` 的字符串值。examine 标签的 hover
/// tooltip（玩家可见），是 IndexAssign 到返回列表 `.`（非 sink/累加器，常规 visit 漏掉）。递归穿控制流。
fn walk_examine_tags(
    block: &[dm::ast::Spanned<Statement>],
    ns: &str,
    catalog: &mut Catalog,
    emit_keys: bool,
) {
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
                        // `emit_keys=false` 的 proc（loadout 的 get_item_information）下标键是
                        // **图标标识符**（`FA_ICON_*` 宏展开成 "fa-hat-cowboy" 这类串），抽进目录
                        // 就是往反查表里塞标识符。键当文案只在 examine_tags 那一族成立。
                        if emit_keys {
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
            }
            Statement::If { arms, else_arm } => {
                for (_c, blk) in arms.iter() {
                    walk_examine_tags(blk, ns, catalog, emit_keys);
                }
                if let Some(blk) = else_arm {
                    walk_examine_tags(blk, ns, catalog, emit_keys);
                }
            }
            Statement::Switch { cases, default, .. } => {
                for (_c, blk) in cases.iter() {
                    walk_examine_tags(blk, ns, catalog, emit_keys);
                }
                if let Some(blk) = default {
                    walk_examine_tags(blk, ns, catalog, emit_keys);
                }
            }
            Statement::While { block, .. }
            | Statement::ForInfinite { block }
            | Statement::ForLoop { block, .. }
            | Statement::Spawn { block, .. } => walk_examine_tags(block, ns, catalog, emit_keys),
            _ => {}
        }
    }
}

pub fn run(dme: &Path, out: &Path, dry_run: bool) -> Result<Catalog> {
    let mut context = dm::Context::default();
    context.set_print_severity(Some(dm::Severity::Error));

    let pp = dm::preprocessor::Preprocessor::new(&context, dme.to_path_buf())
        .with_context(|| format!("无法打开 .dme: {}", dme.display()))?;
    let indents = dm::indents::IndentProcessor::new(&context, pp);
    let mut parser = dm::parser::Parser::new(&context, indents);
    parser.enable_procs();
    let (fatal, tree) = parser.parse_object_tree_2();
    let error_count = context
        .errors()
        .iter()
        .filter(|error| error.severity() == dm::Severity::Error)
        .count();
    if fatal || error_count != 0 {
        anyhow::bail!("DM 解析出现错误，无法继续抽取（{error_count} 条 error 级诊断）");
    }

    // pass 1：收集纯函数 proc 名（与 rewrite 一致，按名跳过以覆盖继承纯度的子类型实现）。
    let mut pure_procs: HashSet<String> = HashSet::new();
    for ty in tree.iter_types() {
        for (proc_name, type_proc) in ty.procs.iter() {
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
    let mut type_var_keys = TypeVarKeys::default();
    for ty in tree.iter_types() {
        // **完整类型路径**往下传（不是压扁后的命名空间）：命名空间由 Catalog::insert 推导，
        // 完整路径同时被记进 scopes.json 供术语表按语境消歧（`Base` 在 /datum/reagent 下是
        // 「碱」，在 /area 下是「基地」）。从前这里就地压成 "obj"/"datum"，语境信号在下一行
        // 就丢了 —— 一个词多个义项只能靠 MT 猜。
        let namespace = ty.path.clone();
        // 单元测试类型只在 UNIT_TESTS 编译期存在，断言消息玩家永不可见 → 不进激进抽取
        // （既有 sink 路径不变，避免目录 churn）。
        let suppress_aggressive = ty.path.starts_with("/datum/unit_test");
        // 单测 fixture（`/obj/item/i18n_..._test` 这类）声明在 unit_tests 目录里，但类型路径不在
        // /datum/unit_test 之下，suppress_aggressive 挡不住它们 —— 于是「Welding Fuel」这种
        // 纯测试串会进目录（目录只合并从不裁剪，一旦进去就永远留着）。按**声明所在文件**排除。
        let in_unit_tests = |loc: dm::Location| -> bool {
            context
                .file_path(loc.file)
                .components()
                .any(|c| c.as_os_str() == "unit_tests")
        };

        // 1) 变量初始化（name/desc 等）。
        for (var_name, type_var) in ty.vars.iter() {
            // 语境再细一层：**变量名**。`#name` 是物品名（短名词短语），`#desc` 是描述
            // （整句），`#message` 是发给玩家的话。模型光看类型路径分不出这个，于是
            // 常把物品名翻成一句话。`#` 不影响命名空间推导（namespace_for 按 `/` 取首段），
            // 所以目录 key 不变。
            if in_unit_tests(type_var.value.location) {
                continue;
            }
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
            // 类型显示名/描述表：与下面 emit 的 key 完全同源（同一个 build_template + 同一个
            // var_scope），否则表里的键会指向目录里不存在的条目。
            if is_sink && TYPE_VAR_TABLE_VARS.contains(&var_name.as_str()) {
                let entry = (ty.path.clone(), var_name.clone());
                match type_var.value.expression.as_ref() {
                    None => {}
                    Some(expr) => match build_template(expr) {
                        Some(t) if !t.contains('{') && t.chars().any(|c| c.is_alphabetic()) => {
                            let key = make_key(&namespace_for(&var_scope), &t);
                            type_var_keys.declared.insert(entry, key);
                        }
                        _ => {
                            type_var_keys.opaque.insert(entry);
                        }
                    },
                }
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
            // 动物面具的叫声池（`animal_sounds = list("Oink!", …)`，23 处）与 AI 行为的发声池同类：
            // 元素是单词感叹词，过不了激进 pass 的整句闸门，必须按变量名专门收。
            let is_speech_pool = matches!(
                var_name.as_str(),
                "speak"
                    | "emote_hear"
                    | "emote_see"
                    | "animal_sounds"
                    | "animal_sounds_alt"
                    // 说话动词池（`speak_emote = list("brays")`）。走 say.dm 的 `lang_reverse_text(say_mod)`
                    // 落地，是**整串精确**反查，所以单词条目在这里安全（不进字面 AC 的多词字典）。
                    | "speak_emote"
            );
            // 攻击动词池（`attack_verb_continuous = list("smashes", "bashes", …)`）。这两个变量**已经在
            // SINK_VARS 里**，看着像早就覆盖了——但 SINK_VARS 那条路对 list 初值走 build_template，
            // 而 build_template 对 list 返回 None；激进 pass 又要求句末标点，小写单词动词一条都过不了。
            // 于是「表里有名字、目录里没条目」，战斗消息里动词整片英文（某 mob sink key 下的
            // strikes/roasts/scorches 即此）。落地与 speak_emote 同路：作为 LANG 实参走**整串精确**反查
            // （lang_localize_arg 无多词门槛），不进字面 AC 的多词字典，所以单词条目在这里安全。
            let is_attack_verb_pool = matches!(
                var_name.as_str(),
                "attack_verb_continuous" | "attack_verb_simple"
            );
            // 合成配方步骤列表（/datum/crafting_recipe steps = list("步骤1", …)，crafting UI "steps"
            // 字段直发显示、P1 反查）。无句末标点居多 → 逐元素抽。
            let is_steps_list =
                var_name == "steps" && ty.path.starts_with("/datum/crafting_recipe");
            // DNA 注入书的「特性」列表（`qualities = list("cheesy lines", "frail but quick", …)`）。
            // 与 attack_verb 池同形：list 初值 build_template 返回 None，元素又是无句末标点的
            // 小写短语，两道闸门都过不了 → 整类留英文（书里那几行「特性：」下面全是英文）。
            let is_display_pool =
                var_name == "qualities" && ty.path.starts_with("/datum/infuser_entry");
            // 激进 pass：任何类型变量初值里的「句子型」字面量（含 list 元素与插值模板）。
            // 自定义 examine 文本变量（dry_desc 类）、pick 表、未列入 SINK_VARS 的长尾自动入目录
            // （句末标点闸门挡住标识符/枚举名）；显示靠反查表/字面 AC/模板逆匹配引擎。
            if let Some(expr) = &type_var.value.expression {
                let var_ctx = ProcCtx {
                    ident: false,
                    examine: false,
                    display_return: false,
                };
                visit_expr(expr, &var_scope, &mut catalog, suppress_aggressive, var_ctx);
            }
            if !is_sink
                && !is_config_default
                && !is_aas_template
                && !is_law_list
                && !is_slogan
                && !is_speech_pool
                && !is_steps_list
                && !is_attack_verb_pool
                && !is_display_pool
            {
                continue;
            }
            if let Some(expr) = &type_var.value.expression {
                if is_aas_template {
                    emit_message_list(expr, &var_scope, &mut catalog);
                    continue;
                }
                if is_steps_list || is_display_pool {
                    emit_list_strings(expr, &var_scope, &mut catalog);
                    continue;
                }
                if is_attack_verb_pool {
                    emit_list_strings_filtered(
                        expr,
                        &var_scope,
                        &mut catalog,
                        ATTACK_VERB_IDENT_BLOCKLIST,
                    );
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
                                if let Some(t) =
                                    build_template(value).or_else(|| plain_string(value))
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
                    // 「局部变量一跳」：赋给 LANG 实参标识符的字面量（见 walk_lang_arg_locals）。
                    // 与下面按 proc 名分派的规则正交，所有 proc 都要走一遍。
                    walk_lang_arg_locals(
                        block,
                        &namespace,
                        &mut catalog,
                        suppress_aggressive || in_unit_tests(proc_value.location),
                    );
                    // 运行期改名（`switch(caste)` 里的 `name = "alien ravager"`）。只对 atom 开。
                    if !suppress_aggressive
                        && !in_unit_tests(proc_value.location)
                        && matches!(
                            ty.path.split('/').nth(1),
                            Some("obj") | Some("mob") | Some("turf") | Some("area")
                        )
                    {
                        walk_name_assignments(block, &namespace, &mut catalog);
                    }
                    if !suppress_aggressive && !in_unit_tests(proc_value.location) {
                        walk_info_assignments(block, &namespace, &mut catalog);
                    }

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
                        // 恐惧症显示名（GLOBAL_LIST_INIT(phobia_types) → `"space" = "Astrophobia"`）:
                        // **键是触发词标识符**（`pick(GLOB.phobia_types)` 取的是键，`phobia_regexes`
                        // 按它索引，phobia.json 那张匹配表也按它匹配），**值是纯显示名** —— SDSM-35
                        // 手册与偏好菜单里那一列就是它。值是单个造词（Astrophobia/Coulrophobia），
                        // 无空格无标点，激进 pass 的整句闸门一条都收不到 → 整类留英文，而同一页上
                        // 由 SINK_VARS 覆盖的 brain_trauma 名字（幽闭恐惧症/失语症）全是中文，
                        // 「同一列表里一半中文一半英文」就是判据。
                        "InitGlobalphobia_types" | "InitGlobalantag_opt_in_strings" => {
                            for stmt in block.iter() {
                                if let Statement::Expr(Expression::AssignOp { rhs, .. }) =
                                    &stmt.elem
                                {
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
                                if let Statement::Expr(Expression::AssignOp { rhs, .. }) =
                                    &stmt.elem
                                {
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
                        "examine_tags" | "get_examine_info" | "get_examine_tags" => {
                            walk_examine_tags(block, &namespace, &mut catalog, true)
                        }
                        // 配装项的补充信息：`.[FA_ICON_*] = "Top of Head"`，**键是图标标识符、
                        // 值才是玩家可见标签** —— 与 examine_tags 正好相反，故只抽值。
                        "get_item_information" => {
                            walk_examine_tags(block, &namespace, &mut catalog, false)
                        }
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
    catalog.ensure_no_collisions()?;

    eprintln!(
        "抽取 {} 条字符串，{} 个命名空间",
        catalog.entry_count(),
        catalog.namespace_count()
    );
    if !dry_run {
        // load_dir 之前定格 live key 集合：合并进来的历史条目此后与本次抽取无从区分，
        // 而 sidecar 的裁剪需要「本次抽出的 ∪ 源码里仍被 LANG 引用的」这一集合（与
        // catalog-audit 的 live_keys 同一判据）。
        let live_keys: std::collections::BTreeSet<String> = catalog
            .keys()
            .chain(catalog.referenced_keys())
            .map(str::to_owned)
            .collect();
        // 译文迁移：趁旧 en 目录还在盘上，把孤儿译文接到新 key（精确继承 + 近似迁移，见 migrate.rs）。
        if let Err(err) = crate::migrate::run(&catalog, out) {
            eprintln!("译文迁移失败（不影响抽取）: {err}");
        }
        // 合并已存在目录：保留已被 rewrite 改写（源码里已不是字面量）的 key（重同步必需）。
        catalog.load_dir(out)?;
        catalog.write(out)?;
        eprintln!(
            "已写入英文主目录: {}（合并后 {} 条）",
            out.display(),
            catalog.entry_count()
        );
        // key -> 类型路径 sidecar。放 locale 目录的**上一级**（见 write_scopes 注释）。
        let scopes_path = out.parent().unwrap_or(out).join("scopes.json");
        catalog.write_scopes(&scopes_path, &live_keys)?;
        eprintln!(
            "已写入语境 sidecar: {}（本次 {} 个 key 带类型路径）",
            scopes_path.display(),
            catalog.scope_count()
        );
        // 类型显示名表（继承已展开）。与 scopes.json 同级：**不能**放进 locale 目录，
        // build_i18n_cache 会把 locale 目录下每个 .json 全量并进反查表。
        let table = expand_type_var_table(&tree, &type_var_keys);
        let type_vars_path = out.parent().unwrap_or(out).join("type_vars.json");
        write_type_var_table(&type_vars_path, &table)?;
        let counts: Vec<String> = TYPE_VAR_TABLE_VARS
            .iter()
            .map(|v| format!("{}={}", v, table.get(*v).map_or(0, |m| m.len())))
            .collect();
        eprintln!(
            "已写入类型显示名表: {}（声明 {} 条，展开后 {}）",
            type_vars_path.display(),
            type_var_keys.declared.len(),
            counts.join(" ")
        );
    }
    Ok(catalog)
}

/// Collect the exact current extracted/LANG-referenced key set without loading or writing catalogs.
///
/// Catalog governance uses this instead of generated sidecars, which may be stale. Parser
/// diagnostics and hash collisions propagate as hard errors, so partial parses cannot masquerade
/// as complete liveness data.
pub fn live_keys(dme: &Path, out: &Path) -> Result<std::collections::BTreeSet<String>> {
    let catalog = run(dme, out, true)?;
    let mut keys: std::collections::BTreeSet<String> = catalog.keys().map(str::to_owned).collect();
    keys.extend(catalog.referenced_keys().map(str::to_owned));
    Ok(keys)
}

/// 把「自己声明了 name/desc」的类型表按 DM 继承语义展开到每个 atom 子类型。
///
/// 展开而不是运行期向上走父类型：DM 侧拿不到类型的 parent_type，运行期只能 O(1) 查表。
/// 截断规则见 TypeVarKeys::opaque —— 子类型自己声明了但抽不出键时，绝不沿用祖先的键。
fn expand_type_var_table(
    tree: &dm::objtree::ObjectTree,
    keys: &TypeVarKeys,
) -> std::collections::BTreeMap<String, std::collections::BTreeMap<String, String>> {
    let mut out: std::collections::BTreeMap<String, std::collections::BTreeMap<String, String>> =
        std::collections::BTreeMap::new();
    for ty in tree.iter_types() {
        if !TYPE_VAR_TABLE_ROOTS
            .iter()
            .any(|root| ty.path == *root || ty.path.starts_with(&format!("{root}/")))
        {
            continue;
        }
        for var in TYPE_VAR_TABLE_VARS {
            let mut cur = Some(ty);
            while let Some(t) = cur {
                let entry = (t.path.clone(), (*var).to_string());
                if keys.opaque.contains(&entry) {
                    break;
                }
                if let Some(key) = keys.declared.get(&entry) {
                    out.entry((*var).to_string())
                        .or_default()
                        .insert(ty.path.clone(), key.clone());
                    break;
                }
                cur = t.parent_type_without_root();
            }
        }
    }
    out
}

fn write_type_var_table(
    path: &Path,
    table: &std::collections::BTreeMap<String, std::collections::BTreeMap<String, String>>,
) -> Result<()> {
    if let Some(dir) = path.parent() {
        std::fs::create_dir_all(dir)?;
    }
    let mut buf = String::from("{\n");
    let last_var = table.len().saturating_sub(1);
    for (i, (var, entries)) in table.iter().enumerate() {
        buf.push_str("  ");
        buf.push_str(&serde_json::to_string(var)?);
        buf.push_str(": {\n");
        let last = entries.len().saturating_sub(1);
        for (j, (ty, key)) in entries.iter().enumerate() {
            buf.push_str("    ");
            buf.push_str(&serde_json::to_string(ty)?);
            buf.push_str(": ");
            buf.push_str(&serde_json::to_string(key)?);
            if j != last {
                buf.push(',');
            }
            buf.push('\n');
        }
        buf.push_str("  }");
        if i != last_var {
            buf.push(',');
        }
        buf.push('\n');
    }
    buf.push_str("}\n");
    std::fs::write(path, buf)?;
    Ok(())
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
///   - 嵌套 LANG 的 key 本身（`LANG("datum.0123456789abcdef", …)`）——形如 `<ns>.<hash>`，翻了目录就崩。
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
    // v2 `<ns>.<16 lowercase hex>` = 目录 key，绝不能当文案抽。
    if is_v2_key(t) {
        return false;
    }
    // **只收多词**。单 token 的 LANG 实参里标识符浓度极高：act/topic/wire 键（`activate`、`attach`、
    // `unlock`、`datumedit`、`targetvar`）、黑板键与 var 名（`all_damage`、`turbine_max_rpm`）、存档路径、
    // 全大写常量（`APC`/`LMB`/`NULL`）。放进目录 = 反查表把它们变异成中文，`switch`/下标比较当场失效
    // ——`nova-i18n lint` 一次就报出 12 条高置信 + 98 条单词类碰撞。而单词类实参本来就有专门的精确
    // 表兜底（`lang_localize_arg` 第一步查 `_state_words.json`：open/closed/lit…），不靠这条路径。
    // 与 P1 多词门槛、AC 字典多词过滤、首字母大写变体是同一条安全线。
    // 例外：**以句末标点收尾**的单 token 是句子残句（`" flimsily."`、`" really hard!"` 的兄弟），
    // 不可能是 act/topic/黑板键 —— 那些永远不带句号叹号。投掷消息的力度后缀即此：同一个变量的
    // 三个分支里多词那条进了目录、单词那条没有，玩家看到「你抛货运部数据磁盘 flimsily.」。
    let ends_sentence = t.ends_with('.') || t.ends_with('!') || t.ends_with('?') || t.ends_with('…');
    if !t.chars().any(char::is_whitespace) && !ends_sentence {
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

/// sink 消息框架专用的 emit：**跳过 `emit` 的「必须含字母」闸门**。
///
/// 那道闸门与 `build_template` 里那道是同一个判断，理由也一样（纯标签/纯占位符不是文案）；
/// 但对 `build_sink_template` 放行的那一类（`"{0} {1}{2} {3}{4}"`）它是**第二次**否决，
/// 而这一类恰恰需要成为模板 —— 中文要靠它丢掉英文复数槽、调换语序，实参也要靠这条调用
/// 变成 LANG 之后才走得到 `lang_localize_arg`。准入面由 build_sink_template 的 ≥3 占位符
/// 闸门界定，这里只是不再重复否决。
fn emit_sink_frame(catalog: &mut Catalog, type_path: &str, template: &str) {
    if template.chars().any(|c| c.is_alphabetic()) {
        emit(catalog, type_path, template);
        return;
    }
    if template.trim().chars().count() < 2 {
        return;
    }
    let key = make_key(&namespace_for(type_path), template);
    let _ = catalog.insert(type_path, &key, template);
}

pub(crate) fn emit(catalog: &mut Catalog, type_path: &str, template: &str) {
    if !template.chars().any(|c| c.is_alphabetic()) {
        return;
    }
    // 单字符串（`preview_name = "X"` 这种）永远不是值得翻译的文案，却是**标识符碰撞的高发区**：
    // 进目录之后反查表会把任何恰好等于 "X" 的显示值改掉，而 `switch("X")` 这类比较随处都是
    // （lint 的碰撞规则当场抓到 admin/topic.dm）。按字符数（不是字节）判，中文单字同样挡掉——
    // 单个汉字的显示串也只可能是标识符或图标标签。
    if template.trim().chars().count() < 2 {
        return;
    }
    if CATALOG_VALUE_BLOCKLIST.contains(&template.trim()) {
        return;
    }
    // key 必须仍按**命名空间**算（`<ns>.<hash>`），否则全目录 key 变更 = 丢光全部译文。
    let key = make_key(&namespace_for(type_path), template);
    // Visitor callbacks deliberately stay infallible; Catalog retains the source-attributed
    // collision and `run` turns it into a hard error before any output is written.
    let _ = catalog.insert(type_path, &key, template);
}

// ---- 语句/表达式遍历：找到汇聚点调用 ----

fn visit_block(
    block: &[dm::ast::Spanned<Statement>],
    ns: &str,
    catalog: &mut Catalog,
    suppress: bool,
    ctx: ProcCtx,
) {
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
                    // 整句作为模板进目录了，槽里的字面量也必须进 —— 模板逆匹配捕获到的正是它们。
                    // `"You can also see [src] on the photo[受伤 ? ", looking a bit hurt" : ""]…"`
                    // 即此：框架译好了，玩家看到「照片上你还可以看到 X, looking a bit hurt。」。
                    let mut slots = Vec::new();
                    collect_interp_slot_literals(e, &mut slots);
                    for literal in slots {
                        if is_lang_arg_text(&literal) {
                            emit(catalog, ns, literal.trim());
                        }
                    }
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

/// AI 黑板里的发声词池键（`BB_EMOTE_SAY` 等是 `#define`，AST 里已展开成这些字符串）。
///
/// `speak`/`emote_hear`/`emote_see` 那条 is_speech_pool 分支只认**类型变量名**，够不着
/// `blackboard = list(BB_EMOTE_SAY = list("Borf!", "Bork!"))` 这种**关联项**形态 —— 全仓 31 处、
/// 而它正是宠物/简单生物叫声的主要来源（生产日志里 92 条没进目录的拟声词几乎全出自这里）。
/// 词池元素是单词感叹词，过不了激进 pass 的整句闸门，所以必须专门收。
fn is_speech_blackboard_key(key: &str) -> bool {
    // `salute_messages`：机器人向权限人员致意的短语池（`BB_SALUTE_MESSAGES`）。与 emote 池同性质
    // ——`bot_subtrees.dm` 把 pick 出来的那条拼进 manual_emote，玩家实测看到「医疗机器人
    // performs an elaborate salute for 哔斯基警官!」（名字翻了、短语没翻）。
    matches!(
        key,
        "emote_say" | "emote_hear" | "emote_see" | "salute_messages"
    )
}

/// `"显示名" = /类型/路径` 里的 rhs 是不是**光秃秃的类型路径**（无构造实参、无后续下标）。
/// 见 visit_expr 里那条规则：值是类型路径就证明键是展示标签而不是数据键。
/// 走 `name`/`label`/`title` 槽位、但**同时被当标识符**用的值（`nova-i18n lint` 碰撞规则实测）。
/// `FISH_SOURCE_AUTOWIKI_NAME = "Other Stuff"` 是 autowiki（文档生成）的分组键，不是玩家可见文案，
/// 而 `FISH_SOURCE_AUTOWIKI_OTHER` 拿同一个串做比较。
/// **维护方式可证伪**：改这张表之后跑 `nova-i18n lint`，碰撞告警数不许比基线多。
const DISPLAY_SLOT_BLOCKLIST: &[&str] = &["Other Stuff"];

/// **必须留在英文**的目录值：既是玩家可见文案、又被当标识符比较。按值（而不是按规则）挡，
/// 因为供给它的那条规则其余几十条都是正常显示名 —— 为一条值退让整条规则代价太大。
/// 新增前先跑 `nova-i18n lint`：报「高置信碰撞」的才该进来。
const CATALOG_VALUE_BLOCKLIST: &[&str] = &[
    // `/datum/wires/proper_name` 的设备缩写，同时是 polycircuit.dm 的 switch 键。
    "APC",
    // `antagpanel_category` 的分组名，同时是 `ROLE_MALF` 这个 define 的值（`antag_flag ==` 比较）。
    "Malf AI",
    // `response_*` 交互动词里与 DM 标识符同形的三个（`stamp` 是纸张印章类型与 icon_state、
    // `stomp` 是 AI 行为/技能 id、`strike` 是雷击与工会事件 id）。与 ATTACK_VERB_IDENT_BLOCKLIST
    // 同一条安全线：宁可少译一个动词，也不要往全局反查表里塞这种词对。
    "stamp",
    "stomp",
    "strike",
    // `robust` 在这个仓库里是三种东西：工具箱的攻击/交互动词（SS13 黑话「暴揍」）、
    // `icon_state = "robust"`、以及**物品检查里的力度描述词** `force_string = "robust"`（那里是
    // 「结实」的本义）。后两者与动词义互斥，任何一条译文都会在另一处出错 —— 同形异义，不收。
    "robust",
    // 老鼠注入的 `infusion_desc`，同时是 `TRAIT_SKITTISH` 这个 define 的值（特质表的键）。
    "skittish",
];

/// 「这个串是选项表里的**显示标签**」：多词 + **首字母大写**。
///
/// 首字母大写这道闸是实测逼出来的：只要求「多词」时一次抽取涌进 868 条，里面混着机甲日志碎片
/// （`secured servo`、`added smile`、`removed weapon control module`）、乐谱字符串（`BPM: 200\nC4/0,14,…`）
/// 这类同样「一边像标识符、另一边是多词」的形状。菜单标签在这个代码库里一律是 Title Case，
/// 日志碎片一律小写开头 —— 这条把两者分得很干净。
fn is_option_label(s: &str) -> bool {
    if !is_lang_arg_text(s) {
        return false;
    }
    let t = s.trim();
    // 含换行/制表的多半是数据块（乐谱、模板文本），不是菜单标签。
    if t.contains('\n') || t.contains('\t') || t.contains("\\n") {
        return false;
    }
    t.chars().next().is_some_and(|c| c.is_ascii_uppercase())
}

/// assoc 的键是不是屏幕提示的按键槽（`SCREENTIP_CONTEXT_*`）。
///
/// 那些是 `#define`，预处理器建 AST 之前就展开成 `"Ctrl-LMB"` 这类字符串了 —— 按定义名匹配
/// 永远 0 命中，只能认展开后的值（与 `BB_EMOTE_*` 黑板键同一条路子）。
///
/// `context[SCREENTIP_CONTEXT_LMB] = "…"` 那种下标写法早就抽到了（IndexAssign 那条规则），
/// 但**写在 list 字面量里**的没有：`list(/mob/living/silicon = list(SCREENTIP_CONTEXT_CTRL_LMB
/// = "Toggle power", …))`。全仓 38 条这么漏着，APC 给 AI 看的那几条即此。
fn is_screentip_slot_key(key: &str) -> bool {
    matches!(
        key,
        "LMB"
            | "RMB"
            | "Shift-LMB"
            | "Ctrl-LMB"
            | "Ctrl-RMB"
            | "Alt-LMB"
            | "Alt-RMB"
            | "Ctrl-Shift-LMB"
    )
}

fn rhs_is_bare_type_path(rhs: &Expression) -> bool {
    let Expression::Base { term, follow } = rhs else {
        return false;
    };
    if !follow.is_empty() {
        return false;
    }
    matches!(&term.elem, Term::Prefab(prefab) if prefab.vars.is_empty())
}

/// rhs 是不是「一张全是类型路径的小表」——
/// `"Caccavo Guaranteed Quality Tequila" = list("bottlepath" = /obj/…, "reagent" = /datum/…)`。
/// 与 rhs_is_bare_type_path 同一条判据的一层嵌套版：**值全是类型路径**同样证明外层键是展示标签。
/// 内层的 `"bottlepath"`/`"reagent"` 是数据键，但它们是单 token，被 `is_lang_arg_text` 的多词闸门
/// 挡住（那条规则对每个 AssignOp 都会跑一遍，包括内层这些）。
fn rhs_is_type_path_table(rhs: &Expression) -> bool {
    if rhs_is_bare_type_path(rhs) {
        return true;
    }
    let Expression::Base { term, follow } = rhs else {
        return false;
    };
    if !follow.is_empty() {
        return false;
    }
    let args = match &term.elem {
        Term::List(args) => args,
        Term::Call(name, args) if name == "list" => args,
        _ => return false,
    };
    if args.is_empty() {
        return false;
    }
    args.iter().all(|a| match a {
        Expression::AssignOp { rhs, .. } => rhs_is_bare_type_path(rhs),
        other => rhs_is_bare_type_path(other),
    })
}

fn visit_expr(expr: &Expression, ns: &str, catalog: &mut Catalog, suppress: bool, ctx: ProcCtx) {
    if let Expression::AssignOp { lhs, rhs, .. } = expr {
        if let Some(key) = plain_string(lhs) {
            if is_speech_blackboard_key(&key) {
                emit_list_strings(rhs, ns, catalog);
            }
            // **`"显示名" = /类型/路径` 形态：键就是文案**。午餐盒菜单、怪癖赠品选项这类
            // `GLOBAL_LIST_INIT(x, list("Space Beer (Canned)" = /obj/…, …))` 里，键是玩家在偏好
            // 菜单看到的标签、值是要生成的类型。`emit_list_strings` 对 AssignOp 取的是 **rhs**
            // （类型路径不是字符串 → 跳过），键就整类丢了 —— 漏翻采集 tgui 桶里的食物/饮料名
            // 几乎全是这一批。
            //
            // 这个形状之所以安全：**值是类型路径**就证明键不是程序查表用的数据键，而是一张
            // 「标签 → 类型」的展示表（`examine_tags` 那条「assoc 键即文案」的另一种形态）。
            // 键同时被当 act 回传标识符用（`GLOB.x[value]`）不影响——负载不动数据，译文随 overlay
            // 下发，前端只翻显示。仍走多词闸门：单 token 键标识符浓度太高。
            if !suppress && is_lang_arg_text(&key) && rhs_is_type_path_table(rhs) {
                emit(catalog, ns, &key);
            }
            // **显示槽位键**：`list("name" = "Plastic Jungle Rocks", "path" = /obj/…)`。
            // RCD/RTD 这类手持造物设备的菜单是一张张「记录」，`name` 槽就是玩家在界面上看到的名字，
            // 而它是**assoc 值**、不是类型变量，也不在任何 sink 实参位置 → 整类没进目录。
            //
            // **只认 `name`/`label`/`title` 这几个槽位名**。一开始写成对称形状判据（「一边是单
            // token 标识符、另一边是多词文本，多词那边就是标签」），一次抽取 686 条，`nova-i18n
            // lint` 当场报 **1 个错误 + 20 条新碰撞**：化学反应的参数标签（`Optimal Max Ph` =
            // `optimal_max_ph`）、性能面板（`SendMaps: Cleanup` = `cleanup`）都长这个形状，而它们
            // 的「标签」正是程序拿去查表的键。槽位名把这些一条不落地挡在外面。
            // 屏幕提示按键槽：键是展开后的 `"Ctrl-LMB"` 之类，值就是那条动作提示。
            if !suppress && is_screentip_slot_key(key.as_str()) {
                if let Some(value) = plain_string(rhs) {
                    let trimmed = value.trim();
                    if trimmed.contains(' ') || trimmed.chars().filter(|c| c.is_alphabetic()).count() >= 3
                    {
                        emit(catalog, ns, trimmed);
                    }
                }
            }
            if !suppress && matches!(key.as_str(), "name" | "label" | "title") {
                if let Some(value) = plain_string(rhs) {
                    if is_option_label(&value) && !DISPLAY_SLOT_BLOCKLIST.contains(&value.as_str())
                    {
                        emit(catalog, ns, &value);
                    }
                }
            }
        }
        // 具名实参 `AddComponent(…, end_string = ", mate")`：语音突变的**无条件后缀**。词表的 key 是
        // 英文单词、在中文句子里永不匹配，所以中文服上这类突变只剩这条尾巴 —— 它必须进目录。
        // 具名实参是 AssignOp（lhs 是标识符而非字符串），激进 pass 的整句闸门收不到这种短后缀。
        if let Expression::Base { term, follow } = &**lhs {
            if follow.is_empty() {
                if let Term::Ident(name) = &term.elem {
                    // `AddElement(/datum/element/contextual_screentip_bare_hands,
                    //   lmb_text = "Toggle Resampler", rmb_text = "Flush Soup")`：悬停时的动作提示。
                    // `context[SCREENTIP_CONTEXT_LMB] = "…"` 那种下标写法早就抽到了（全仓 577 条
                    // 在目录），只有走具名实参的这批漏着 —— 同一个显示面，两种写法两种待遇。
                    // 幽灵征召的提问（`poll_ghost_candidates(..., poll_question = "Do you want to be
                    // a [span_green(...)]?")`）：整句模板早就在目录里、也译好了，但插值槽里那几个
                    // 字面量（`"mindless zombie"` / `"zombie"`）既不是 sink 实参、也不是类型变量
                    // —— 玩家看到「你想成为一个 mindless zombie 吗？」。
                    if matches!(
                        name.as_str(),
                        "end_string" | "lmb_text" | "rmb_text" | "poll_question"
                    ) {
                        emit_list_strings(rhs, ns, catalog);
                        if let Some(template) = build_template(rhs) {
                            if !template.contains('{') {
                                emit(catalog, ns, &template);
                            }
                        }
                        let mut slots = Vec::new();
                        collect_interp_slot_literals(rhs, &mut slots);
                        for literal in slots {
                            if is_lang_arg_text(&literal) {
                                emit(catalog, ns, literal.trim());
                            }
                        }
                    }
                }
            }
        }
    }
    match expr {
        Expression::Base { term, follow } => {
            // 激进 pass：独立字符串/插值串字面量，句子型即入目录（含 {N} 模板）。
            // 显示路径：纯串→反查表/字面 AC；插值模板→边界模板逆匹配引擎（template_match.dm）。
            if !suppress
                && follow.is_empty()
                && matches!(&term.elem, Term::String(_) | Term::InterpString(..))
            {
                if let Some(template) = build_template(expr) {
                    if is_loose_sentence(&template, ctx.examine) {
                        emit(catalog, ns, &template);
                    }
                }
            }
            // 汇聚点调用检测。
            // 已被 rewrite 改写的字符串，源码里只剩 `LANG("obj.0123456789abcdef")` —— 字面量没了，
            // 常规抽取产不出它，key 靠 Catalog::load_dir 从旧目录续命。语境同理会丢：
            // 全目录约 28% 的 key（而且恰恰是玩家最常见的 sink 串）会没有类型路径。
            // 这里从 **LANG() 调用点本身**回收 scope —— 比原字面量的定义处更准，
            // 因为它记的是这句话实际被用在哪个类型里。
            if let Term::Call(name, args) = &term.elem {
                // `AddElement(/datum/element/xxx, "…")`：按 element 类型登记的显示实参。
                //
                // **AST 里没有 "AddElement"**：它是 `#define AddElement(arguments...)
                // _AddElement(list(##arguments))`，预处理器在建 AST 之前就展开了，实参也被裹进
                // 一层 `list(...)`。与 LANG/LANGU 那条坑同源 —— 按源码里写的名字匹配永远 0 命中。
                if matches!(name.as_str(), "_AddElement" | "_AddComponent") {
                    let inner = args.first().and_then(|arg| match arg {
                        Expression::Base { term, follow } if follow.is_empty() => match &term.elem {
                            Term::List(items) => Some(items.as_ref()),
                            Term::Call(callee, items) if callee == "list" => Some(items.as_ref()),
                            _ => None,
                        },
                        _ => None,
                    });
                    if let Some(inner) = inner {
                        if let Some(indices) = inner.first().and_then(element_display_args) {
                            for &idx in indices {
                                if let Some(template) = inner.get(idx).and_then(build_template) {
                                    emit(catalog, ns, &template);
                                }
                            }
                        }
                    }
                }
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
                        if let Some((_, arg)) = resolve_sink_arg(name.as_str(), i, args) {
                            // 拼接链先按标签单元拆（见 build_tag_chunk_templates）；拆不动才折成整条。
                            if let Some(chunks) = build_tag_chunk_templates(arg) {
                                for chunk in chunks {
                                    emit(catalog, ns, &chunk);
                                }
                            } else if let Some(template) = build_sink_template(arg) {
                                emit_sink_frame(catalog, ns, &template);
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
                        if let Some((_, arg)) = resolve_sink_arg("input", i, args) {
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
                    if is_loose_sentence(&template, ctx.examine) {
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
                                    // 整句已经作为模板进目录了，那么**槽里的字面量也必须进**：
                                    // 运行期模板引擎逆匹配捕获到的就是它们，捕获值再走
                                    // lang_localize_arg —— 查不到就原样留在中文句子里。
                                    // `"Its all wired up[cell ? " and ready for usage" : ""].\n"`
                                    // 就是这形状：模板译好了，玩家看到「它已经全部接好了线 and
                                    // ready for usage。」。「整句会进目录」本身就是准入证据 ——
                                    // 与 LANG 实参那条同一条道理，闸门也同一条（多词）。
                                    let mut slots = Vec::new();
                                    collect_interp_slot_literals(rhs, &mut slots);
                                    for literal in slots {
                                        if is_lang_arg_text(&literal) {
                                            emit(catalog, ns, literal.trim());
                                        }
                                    }
                                } else if is_sentence_like(&template) && !is_option_accumulator(id)
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
                    let is_context_index = matches!(&term.elem, Term::Ident(id) if id == "context")
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
        // **`pick()` 是独立的 AST 节点，不是 Term::Call** —— 因为 DM 支持权重语法
        // `pick(50;"a", 50;"b")`，解析器给了它 `Term::Pick(Box<[(Option<Expression>, Expression)]>)`。
        // 少了这一支，**全仓所有 `pick(...)` 里的字面量都进不了目录**：`to_chat(x,
        // span_notice("[pick(\"You feel pumped!\", …)]"))` 这类随机 flavor 消息是 DM 里最常见的写法之一。
        // 实测一个文件里 146/147 条普通句子都在目录，pick 里的 8 条一条都不在 —— 这个反差就是判据。
        // （普通句子靠 sink 路径的 build_template 抽到，与激进 pass 无关，所以缺口只在 pick 上显形。）
        Term::Pick(args) => {
            for (weight, value) in args.iter() {
                if let Some(w) = weight {
                    visit_expr(w, ns, catalog, suppress, ctx);
                }
                visit_expr(value, ns, catalog, suppress, ctx);
            }
        }
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
                    if let Some((_, arg)) = resolve_sink_arg(name.as_str(), i, args) {
                        if let Some(template) = build_sink_template(arg) {
                            emit_sink_frame(catalog, ns, &template);
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
