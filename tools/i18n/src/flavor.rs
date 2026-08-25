//! `strings/` flavor 数据文件抽取（与 sink/SINK_VARS 走同一主目录）。
//!
//! 只纳入**展示型 flavor**（整句/整段，玩家直接看到）。**不纳入**关键词表 / 文本变换表 /
//! 名字生成器（如 phobia 触发词、heckacious 替换表、pirates/exodrone/arcade 名字片段、口音表、
//! names/、词频表）——它们要么是功能性匹配会被翻译破坏，要么是会因语序错乱的生成器片段。
//! 运行时**不需要白名单**：load 处对所有 strings 文件跑反查，但只有这里抽进目录的串才会命中改写，
//! 其余天然 no-op（再加多词门槛防单词误伤）。逐字保留（含前导 @/% 与 @pick(...) 宏、HTML），
//! 与运行时 file2list/json_load 拿到的串一致，反查才命中；译者须保留这些 token。

use std::path::Path;

use crate::catalog::Catalog;
use crate::extract::emit;

const FLAVOR_FILES: &[&str] = &[
    "tips.txt",
    "sillytips.txt",
    "chemistrytips.txt",
    "fishing_tips.txt",
    "junkmail.txt",
    // 算命饼干式格言（智慧牛/基础 mob 闲聊池 speak、裁纸机纸条默认文本）——整句展示文本。
    "wisdoms.txt",
    "abductee_objectives.txt",
    "bane.json",
    "boomer.json",
    "eigenstasium.json",
    "mother.json",
    "ninja.json",
    "flavor_reports.json",
    "memories.json",
    // 巫师随机 loadout 展示名（"O1: Spell Cards" 等完整字面标签，Spellbook TGUI 直显）。
    "wizoff.json",
    // 街机敌人名池（形容词+敌名，中文语序同序可拼；组装点 make_boss_name 有 locale 门控 NOVA EDIT）。
    "arcade.json",
    // 离子法则碎片池（ALLCAPS 名词/动词短语）。模板句由 extract 的 generate_ion_law 专项抽；
    // 碎片在 strings 加载处反查成中文、显示端模板逆匹配引擎整句收口。
    "ion_laws.json",
    // 情人节：搭讪语（valentines，卡片纸整段文本）+ 糖果心（candyhearts，条目本身就是完整句
    // "A heart-shaped candy that reads: X"，vday.dm 直接整串赋 desc → 加载处反查整串命中）。
    "valentines.json",
];

/// 只收**部分 section** 的 strings JSON：同文件其余 section 是 `@pick(...)` 生成器子池 /
/// 字母变换表（如 traumas.json 的 y_replacements=["y","i","e"]、semicolon=[";"]），整文件收会
/// 往目录塞单字符噪音、翻译还会破坏生成逻辑。句子 section 里的 `@pick(x)` 宏逐字保留（译者同）。
const FLAVOR_JSON_SECTIONS: &[(&str, &[&str])] = &[
    (
        // 探索无人机（exodrone）的事件文本与星球描述——整段经 TGUI 显示给玩家。
        // **不收 `probe_names`**（Cassini/Galileo 是探测器专名）与 `trading_station_names`
        // （"Big Bill Hells's used mechs" 这类商号专名，而且被 `name = "\"[x]\" trading station"`
        // 拼进一个英文框架里 —— 只译商号会得到「"中文" trading station」这种半截货）。
        // `planet_types` 是 `{name, description, habitable…}` 的对象数组，collect_json_strings 只
        // 收字符串叶子，布尔字段与 assoc 键天然不进目录。
        // `alien_fauna` 被 replacetext 填进 description 的 BEAST 占位（description 本身在目录里）。
        "exodrone.json",
        &[
            "planet_types",
            "alien_fauna",
            "fluff_generic",
            "fluff_space",
            "fluff_trading",
            "fluff_ruins",
        ],
    ),
    (
        // 幻觉假聊天/心灵感应台词（玩家在幻觉里"听到"的整句）。**只收整句 section**：
        //   · `weird` 是乱码（`#@§*&£` / `EEEeeeeEEEE`），翻不得；
        //   · `add_name` 只有 `%TARGETNAME% ` 这类占位前缀，没有可译文本；
        //   · `people`/`accusations`/`contraband`/`threat`/`location`/`sublocation`/`chemicals`
        //     是**碎片**，被 fake_chat.dm 里的裸字面量框架按英文语序拼成整句
        //     （`"[people] is [accusations]!"`）。只译碎片会产出「舰长 is 叛徒!」——比全英文更糟，
        //     要收就得连那些框架一起接 LANG。
        // `@pick(add_name)` 宏与 `%TARGETNAME%` 逐字保留（译者同）。
        "hallucination.json",
        &[
            "advice",
            "aggressive",
            "conversation",
            "didyouhearthat",
            "doubt",
            "escape",
            "getout",
            "greetings",
            "help",
            "infection_advice",
            "suspicion",
            // 碎片池：被 fake_chat.dm 的句式框架拼成整句。**框架已接 LANG 并在译文侧调好语序**
            // （威胁那条是 `{1}有{0}`），所以这些碎片现在译了是对的 —— 在框架还是裸字面量的时候
            // 译它们只会产出「舰长 is 叛徒!」，两者必须同时做。
            "people",
            "accusations",
            "contraband",
            "threat",
            "location",
            "sublocation",
            // 化学合成器随机吐出的药品名（synthesizer.dm 直接当显示名用）。
            "chemicals",
        ],
    ),
    (
        // 脑创伤呓语（brain_damage：胡话整句）+ 神明幻觉 ALLCAPS 台词（god_*）。
        "traumas.json",
        &[
            "brain_damage",
            "god_foe",
            "god_aggressive",
            "god_neutral",
            "god_unstun",
            "god_heal",
            // brain_damage 的句子里用 `@pick(x)` 拼进来的**子池**。框架早就译好了（`@pick(george)
            // @pick(mellens) 在搞我，救命！！！`），子池没译就是中文句子里嵌着英文碎片。
            // 收这四个：都是「拼错的真词」（`abdoocters`=abductors、`eppilapse`=epilepsy、
            // `deth squads`、`sheadow lings`），在句中当名词/动词用。
            "create_nouns",
            "create_verbs",
            "mutations",
            "bug",
            // **不收** `servers`（basil/sybil/terry/colonel hall 是 /tg/ 服务器专名）、`george`/`mellens`
            // （人名），以及 `random_gibberish`/`y_replacements`/`semicolon` —— 后三者是**字母级**
            // 变换表（`y`→`i`/`e`、`;`），翻了当场把拼错效果弄坏。
        ],
    ),
];

/// 递归纳入其下所有 .json 的 flavor 子目录。
const FLAVOR_DIRS: &[&str] = &["antagonist_flavor", "wounds"];

pub(crate) fn extract_flavor(strings_root: &Path, catalog: &mut Catalog) {
    for name in FLAVOR_FILES {
        extract_flavor_file(&strings_root.join(name), catalog);
    }
    for (name, sections) in FLAVOR_JSON_SECTIONS {
        let Ok(text) = std::fs::read_to_string(strings_root.join(name)) else {
            continue;
        };
        let Ok(serde_json::Value::Object(map)) = serde_json::from_str::<serde_json::Value>(&text)
        else {
            continue;
        };
        for section in *sections {
            if let Some(value) = map.get(*section) {
                collect_json_strings(value, catalog);
            }
        }
    }
    for dir in FLAVOR_DIRS {
        if let Ok(entries) = std::fs::read_dir(strings_root.join(dir)) {
            for entry in entries.flatten() {
                extract_flavor_file(&entry.path(), catalog);
            }
        }
    }
}

/// 复印机/打印机表单（paper blanks）：`config/blanks.json`（TG）+ `config/nova/blanks.json`（Nova
/// 覆盖）。源码外 config 数据（运行期 json_decode 读入 GLOB.paper_blanks），抽取器原本够不着 →
/// 表单标题/字段标签/正文整段全英文。每个 blank = {code, category, name, info:[HTML 行]}。把
/// `name`/`category` 与**含可翻散文的 `info` 行**逐条抽进 `blanks` 命名空间；运行时在 init_paper_blanks
/// 落地点对 GLOB.paper_blanks 整串反查（display-only：act 用 code，反查名/分类/正文不破标识符）。
/// info 行是 HTML，**逐行整串**入目录（译者保留 HTML 标签与 `[___]` 占位、只译可见文本，反查整串命中）。
/// 纯占位行（`<p>[___]</p>`）/ 分隔线（`<hr />`）剥标签后无文本 → 跳过（不译）。
pub(crate) fn extract_blanks(repo_root: &Path, catalog: &mut Catalog) {
    for rel in ["config/blanks.json", "config/nova/blanks.json"] {
        let Ok(text) = std::fs::read_to_string(repo_root.join(rel)) else {
            continue;
        };
        let Ok(serde_json::Value::Array(blanks)) = serde_json::from_str::<serde_json::Value>(&text)
        else {
            continue;
        };
        for blank in &blanks {
            let serde_json::Value::Object(map) = blank else {
                continue;
            };
            for field in ["name", "category"] {
                if let Some(serde_json::Value::String(s)) = map.get(field) {
                    let s = s.trim();
                    if !s.is_empty() {
                        emit(catalog, "blanks", s);
                    }
                }
            }
            if let Some(serde_json::Value::Array(info)) = map.get("info") {
                for line in info {
                    if let serde_json::Value::String(line) = line {
                        let line = line.trim();
                        if !line.is_empty() && html_has_translatable_text(line) {
                            emit(catalog, "blanks", line);
                        }
                    }
                }
            }
        }
    }
}

/// 交互菜单（interaction_menu）的**聊天消息模板**：`config/nova/interactions/*.json` 里每个交互的
/// `message`/`user_messages`/`target_messages` 数组（玩家执行交互时经 manual_emote/to_chat 发出的句子，
/// 如 `"%USER% beckons %TARGET% over to them."`）。源码外 config 数据 → 抽取器够不着 → 聊天里整句英文。
/// 抽进 `interactions` 命名空间，运行时在 `act()` 落地点（替换 %TOKEN% **之前**）对原始模板整串反查。
/// 含 `%USER%`/`%TARGET%`/`%..._PRONOUN_..%` 标记，逐字入目录（译者保留两侧 %，反查整串命中、再 replacetext）。
/// 注：交互 name/desc 走 TGUI 目录（tgui-catalog.mjs 的 extractInteractionLabels），与此**聊天消息**分属两路。
pub(crate) fn extract_interactions(repo_root: &Path, catalog: &mut Catalog) {
    let dir = repo_root.join("config/nova/interactions");
    let Ok(entries) = std::fs::read_dir(&dir) else {
        return;
    };
    for entry in entries.flatten() {
        let Ok(text) = std::fs::read_to_string(entry.path()) else {
            continue;
        };
        let Ok(value) = serde_json::from_str::<serde_json::Value>(&text) else {
            continue;
        };
        collect_interaction_messages(&value, catalog);
    }
}

/// 新闻播报机 lorecaster 的 flavor 新闻：`config/nova/news_stories.json`（字典：story_id -> {title,text,...}）。
/// 源码外 config 数据 → 抽取器够不着 → 新闻整篇英文。抽 title + text 进 `news` 命名空间，运行时在
/// lorecaster fire() 落地点整串反查（display-only）。
pub(crate) fn extract_news_stories(repo_root: &Path, catalog: &mut Catalog) {
    let Ok(text) = std::fs::read_to_string(repo_root.join("config/nova/news_stories.json")) else {
        return;
    };
    let Ok(serde_json::Value::Object(stories)) = serde_json::from_str::<serde_json::Value>(&text)
    else {
        return;
    };
    for story in stories.values() {
        if let serde_json::Value::Object(map) = story {
            for field in ["title", "text"] {
                if let Some(serde_json::Value::String(s)) = map.get(field) {
                    let s = s.trim();
                    if !s.is_empty() {
                        emit(catalog, "news", s);
                    }
                }
            }
        }
    }
}

/// 递归找含 message/user_messages/target_messages 的交互对象（兼容单文件与 .master.json 字典形态）。
fn collect_interaction_messages(value: &serde_json::Value, catalog: &mut Catalog) {
    let serde_json::Value::Object(map) = value else {
        return;
    };
    // 占位/示例交互（category=="hide"，如 example_interaction.json 的 "message"/"message2"）不入目录。
    let is_hide = matches!(map.get("category"), Some(serde_json::Value::String(c)) if c == "hide");
    if !is_hide {
        for field in ["message", "user_messages", "target_messages"] {
            if let Some(serde_json::Value::Array(msgs)) = map.get(field) {
                for m in msgs {
                    if let serde_json::Value::String(m) = m {
                        let m = m.trim();
                        // "json error" 占位与空串跳过；其余整句模板入目录。
                        if !m.is_empty() && m != "json error" {
                            emit(catalog, "interactions", m);
                        }
                    }
                }
            }
        }
    }
    // master json：值为交互对象，递归。
    for v in map.values() {
        if v.is_object() {
            collect_interaction_messages(v, catalog);
        }
    }
}

/// 剥去 `<...>` 标签与 `[_ ]`（下划线/空格/方括号）占位后是否还剩字母 → 该 HTML 行是否含可翻文本。
fn html_has_translatable_text(line: &str) -> bool {
    let mut in_tag = false;
    for ch in line.chars() {
        match ch {
            '<' => in_tag = true,
            '>' => in_tag = false,
            c if !in_tag && c.is_alphabetic() => return true,
            _ => {}
        }
    }
    false
}

fn extract_flavor_file(path: &Path, catalog: &mut Catalog) {
    let Ok(text) = std::fs::read_to_string(path) else {
        return;
    };
    match path.extension().and_then(|s| s.to_str()) {
        Some("txt") => {
            // 逐非空行（trim，与 file2list 默认 trim=TRUE 一致）。
            for line in text.lines() {
                let line = line.trim();
                if !line.is_empty() {
                    emit(catalog, "strings", line);
                }
            }
        }
        Some("json") => {
            if let Ok(value) = serde_json::from_str::<serde_json::Value>(&text) {
                collect_json_strings(&value, catalog);
            }
        }
        _ => {}
    }
}

/// 递归取 JSON 的字符串叶子（数组元素 / 关联值）；key 不取（程序标识）。
/// flavor 碎片池里**同时被当 DM 标识符**用的那批（`nova-i18n lint` 的碰撞规则实测报出来的）。
///
/// 幻觉的地点/威胁/化学品池全是短名词（`cargo`/`Air`/`hulk`），进目录就等于往**全局反查表**里
/// 塞这些词对：运行期任何恰好等于该串的显示值都会被反查成中文，而它们同时是 `switch`/下标键。
/// 这几个词在幻觉里显英文只是少译一处，弄坏查表则是功能故障 —— 取舍很清楚。
///
/// **维护方式是可证伪的**：改这张表之后跑 `nova-i18n lint`，碰撞告警数不许比基线多。
const FLAVOR_IDENT_BLOCKLIST: &[&str] = &[
    // 幻觉地点/威胁/化学品池
    "Air", "cargo", "cult", "Energy", "hulk", "Infinity",
    // 脑损伤 create_verbs（`gib` 是 proc 名，`spawn` 是 DM 关键字兼 act 键）
    "gib", "spawn",
];

fn collect_json_strings(value: &serde_json::Value, catalog: &mut Catalog) {
    match value {
        serde_json::Value::String(s) => {
            let s = s.trim();
            if !s.is_empty() && !FLAVOR_IDENT_BLOCKLIST.contains(&s) {
                emit(catalog, "strings", s);
            }
        }
        serde_json::Value::Array(arr) => {
            for v in arr {
                collect_json_strings(v, catalog);
            }
        }
        serde_json::Value::Object(map) => {
            for v in map.values() {
                collect_json_strings(v, catalog);
            }
        }
        _ => {}
    }
}
