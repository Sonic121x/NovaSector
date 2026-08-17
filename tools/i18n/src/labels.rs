//! nova-i18n labels —— 「标识符耦合的 DM 显示名」AST 抽取（替代 tgui-catalog.mjs 的正则 DM_LABEL_SOURCES）。
//!
//! 这些 name/title/category_name/explanation/choiced 选项在 TGUI 里**既是显示又是 act() 标识符**
//! （职业/怪癖/精灵配件/偏好下拉…），不能让 DM 端 P1 改数据（会破坏 act）。改为抽进前端 tgui 目录，
//! 由 TS runtime **只翻显示**（act 用原英文值，安全）。
//!
//! 相比 mjs 的正则扫描，AST 抽取**按类型路径 / proc 语义**定位，系统性消除三类陷阱：
//!   - **#define 绕过**：`init_possible_values()` 返回值经预处理器**展开**成字面量 → 一条语义规则
//!     覆盖所有 choiced 下拉（含 #define 定义的选项），不再每个新 #define 加一条正则。
//!   - **空白容差**：AST 取字面量值，不受引号前后空格/逗号位置影响。
//!   - **钉死路径静默失效**：按**类型路径**（`/datum/quirk` 等）而非文件路径定位 → 上游移动文件
//!     仍能命中（类型不变）。
//!
//! 输出：flat JSON `["English label", …]`（mjs 读入后 addText 进 tgui 目录）。

use anyhow::{Context as _, Result};
use std::collections::BTreeSet;
use std::path::Path;

use dm::ast::{Expression, Follow, Spanned, Statement, Term};

use crate::template::build_template;

/// 类型路径前缀 → 取该 var 的字符串值。这些 var 是「显示名」（act 用原英文值，翻显示安全）。
/// 按类型路径定位：覆盖该基类型的**所有子类型**，不论定义在哪个文件（上游移动文件不失效）。
const TYPE_VAR_RULES: &[(&str, &str)] = &[
    ("/datum/quirk", "name"),
    ("/datum/personality", "name"),
    ("/datum/sprite_accessory", "name"),
    ("/datum/language", "name"),
    ("/datum/species", "name"),
    ("/datum/augment_item", "name"),
    ("/datum/laugh_type", "name"),
    ("/datum/scream_type", "name"),
    ("/datum/loadout_item", "name"),
    // 配装项的分组小标题（"Improvised Ballistics"/"Forge Weapons"…）。前端把它当**分组键**用
    // （`groups.find(g => g.title === item.group)`）之后才渲染成 `<h3>{group.title}</h3>`，
    // 分组在渲染前完成、译文只发生在 jsx 那一跳，所以走「进前端目录、TS 只翻显示」这条桥是安全的；
    // 多词名还会被 P1 按「本身是 tgui 目录键」保留英文，负载侧不受影响。
    ("/datum/loadout_item", "group"),
    ("/datum/loadout_category", "category_name"),
    ("/datum/preference/name", "explanation"),
    ("/datum/job", "title"),
    // 基因突变名：DNA 控制台把 `mutation.name` 原样下发成 `Name`，前端既显示又拿它当标识符
    // （`mutations.find(m => m.Name === name)` 取 ByondRef、`Name !== 'Monkified'` 分支判断），
    // 所以 P1 绝不能改数据；而 name 多为单词（"Monkified"/"Dwarfism"），连 P1 的多词门槛都过不了。
    // 译文早在 datum.json 里躺着，缺的只是让它进前端目录、由 TS 端只翻显示。
    ("/datum/mutation", "name"),
    // 战斗街机的商店装备名：`battle_arcade_gear_list[name]` 既是显示又是 act("buy_item") 的
    // 回传键。P1 译多词名（"Leather Armor"）→ 回传中文 → 查表 miss，玩家表现为「中文名的装备
    // 买不了、单词名的能买」。值保英文（进 payload_skip_keys），显示走这条桥。
    ("/datum/battle_arcade_gear", "name"),
    // 强化+ 页的体表标记名：`build_marking_choices()` 把 name 既当下拉显示又当 act("change_marking")
    // 的 `marking_name` 回传键（`GLOB.body_markings[marking_name]` 查表），所以 P1 绝不能改数据。
    // 这类 name 从没进过任何目录（SINK_VARS 够不着 /datum/body_marking），故整个下拉永远英文。
    // LimbsPage 已把它渲染成对象选项 `{value: 英文, displayText: 英文}`，只缺让 displayText
    // 能在前端目录里查到。预设下拉（`filteredMarkingPresets`）是裸字符串，由 localizeDropdownProps
    // 运行时升级成对象，同样只需要这条桥。
    ("/datum/body_marking", "name"),
    ("/datum/body_marking_set", "name"),
];

/// 同 TYPE_VAR_RULES，但**只收单词**（trim 后不含空白）的显示名。
///
/// 为什么要分成两张表：这些类型族的 name 在 TGUI 里既显示又当标识符/客户端比较键用
/// （`act('buy', {name})`、`voteName`、`reaction.name` 参与置顶列表、`recipe.name === selected_recipe`），
/// 所以 DM 端不能改数据。而落地路径按词数分叉：
///   - **多词** name 由 P1（`lang_reverse_phrase_tgui`）在负载里就地翻好 → 已经能显示中文。把它们也塞进
///     前端目录反而会让 P1 按「本身是 tgui 目录键」**跳过**，改由 TS 只翻显示；一旦某界面把它渲染在
///     非可翻位置（模板串、非 translatable prop），就从「能显示中文」退化成英文。所以多词一律不进这张表。
///   - **单词** name 连 P1 的多词门槛都过不了，本来就永远是英文 → 进前端目录是纯增益。
///
/// 另一条安全线在 seeding 侧：`tools/i18n/seed-tgui-labels.mjs` 只把**其它命名空间里已有的译文**搬进
/// tgui.json，不新造词对。`build_i18n_cache` 会把 tgui.json 一并扫进 DM 侧全局反查表，新造词对等于
/// 扩大误翻面（线缆颜色那次被 `i18n_real_catalog` 抓过）。
const SINGLE_WORD_TYPE_VAR_RULES: &[(&str, &str)] = &[
    // 投票名（"Restart"/"Map"/"Custom"）：`act('toggleVote', {voteName: option.name})` 的回传键。
    ("/datum/vote", "name"),
    // 恶意 AI 模块名：`act('buy', {name: item.name})` 的回传键。
    ("/datum/ai_module", "name"),
    // 化学反应名：前端置顶列表按 name 存取、并与 `chem.title` 比较。
    ("/datum/chemical_reaction", "name"),
    // 设计名：铺砖器按 `recipe.name === selected_recipe` 判选中态。
    ("/datum/design", "name"),
    // 材料名（iron/glass/…）：前端 MATERIAL_ICONS/MATERIAL_RARITY 按英文名查表。
    ("/datum/material", "name"),
    // 试剂名（Water/Epinephrine/…）：机甲/borg 那批把它拼进 gear_action，各处也常用作查表键。
    ("/datum/reagent", "name"),
];

/// 具名变量（任意类型上）→ 取其 assoc list 的**值**（key 是 act 标识符不抽，值是显示名）。
/// 如 skin_tone_names（key=肤色 id，value=显示）、height_scaling_strings（CHOICED_PREFERENCE_DISPLAY_NAMES）。
const ASSOC_VALUE_VARS: &[&str] = &["skin_tone_names", "height_scaling_strings"];

/// 文件后缀 → 抽该文件内 list 字面量的 assoc **键**（如 food.dm 的食物类别全局表，键即类别显示名）。
const FILE_ASSOC_KEY_SUFFIXES: &[&str] =
    &["__nova_defines/_globalvars/food.dm", "_globalvars/food.dm"];

/// 文件路径子串 → 抽该文件内 list 字面量的**扁平字符串元素**（如 alt_titles：备用职业名列表）。
const FILE_FLAT_DIRS: &[&str] = &["alternative_job_titles"];

/// GLOBAL_LIST_INIT(X, V) 经 GLOBAL_MANAGED 宏展开为 `/datum/controller/global_vars/proc/InitGlobalX()`，
/// 体内 `X = V`（**赋值语句、非变量初值**）。故全局 list（skin_tone_names 的 assoc 值、食物类别
/// food_ic_flag_to_bitflag 的 assoc 键）要从这些 InitGlobal* proc 的赋值 RHS 抽，而非 ty.vars。
/// 形态：(proc 名后缀去掉 "InitGlobal" = 全局名, 抽取模式)。
const GLOBAL_INIT_ASSOC_VALUES: &[&str] = &["skin_tone_names"];
const GLOBAL_INIT_ASSOC_KEYS: &[&str] = &["food_ic_flag_to_bitflag"];

/// GLOBAL_LIST_INIT(X, …) 里**所有**字符串字面量都是显示名的全局表。
/// 管道分发器的三张配方表就是这形态：assoc 键是分类名（"Pipes"/"Binary"/"Devices"），值是
/// `new /datum/pipe_info/pipe("Gas Filter", /obj/…, TRUE)` —— 名字是**构造实参**，既不是 var
/// 初值也不是 assoc 值，前面几条规则一条都够不着。表里除了名字与分类名没有别的字符串
/// （其余实参是类型路径与布尔），整表全收是安全的。
/// cat_name 在前端既显示又当标识符（`ICON_BY_CATEGORY_NAME[cat_name]`、act 的 category 实参），
/// 所以走「进前端目录、TS 只翻显示」这条路，绝不能让 P1 改负载。
const GLOBAL_INIT_ALL_STRINGS: &[&str] = &[
    "atmos_pipe_recipes",
    "disposal_pipe_recipes",
    "transit_tube_recipes",
];

/// 从一个「选项 list」表达式抽 choiced **显示**串：flat 元素 → 元素本身 + capitalizeFirst（前端
/// dropdowns.tsx 用 `capitalizeFirst(choice)` 作显示与查表键，故小写值 "male" 的查表键是 "Male"）；
/// assoc 项 → 取**值**（显示），不取键（act 标识符）。
fn collect_option_displays(expr: &Expression, out: &mut BTreeSet<String>) {
    let args = match expr {
        Expression::Base { term, follow } if follow.is_empty() => match &term.elem {
            Term::List(args) => args,
            Term::Call(name, args) if name == "list" => args,
            Term::Expr(inner) => {
                collect_option_displays(inner, out);
                return;
            }
            _ => return,
        },
        _ => return,
    };
    for arg in args.iter() {
        if let Expression::AssignOp { rhs, .. } = arg {
            // assoc：key 是 act 标识符不抽，value 是显示。
            if let Some(s) = as_string(rhs) {
                add_label(s, out);
            }
        } else if let Some(s) = as_string(arg) {
            // flat 元素：是 choice 值（act），显示为 capitalizeFirst → 两形态都收（superset）。
            add_label(s, out);
            add_label(&capitalize_first(s), out);
        }
    }
}

fn as_string(expr: &Expression) -> Option<&str> {
    if let Expression::Base { term, follow } = expr {
        if follow.is_empty() {
            if let Term::String(s) = &term.elem {
                return Some(s);
            }
        }
    }
    None
}

/// 抽 list 字面量的 assoc **键**（食物类别全局表：键即显示名）。
fn collect_assoc_keys(expr: &Expression, out: &mut BTreeSet<String>) {
    if let Expression::Base { term, follow } = expr {
        if follow.is_empty() {
            let args = match &term.elem {
                Term::List(args) => Some(args),
                Term::Call(name, args) if name == "list" => Some(args),
                _ => None,
            };
            if let Some(args) = args {
                for arg in args.iter() {
                    if let Expression::AssignOp { lhs, .. } = arg {
                        if let Some(s) = as_string(lhs) {
                            add_label(s, out);
                        }
                    }
                }
            }
        }
    }
}

/// 抽 list 字面量的**扁平字符串元素**（alt_titles 等）。
fn collect_flat_strings(expr: &Expression, out: &mut BTreeSet<String>) {
    if let Expression::Base { term, follow } = expr {
        if follow.is_empty() {
            let args = match &term.elem {
                Term::List(args) => Some(args),
                Term::Call(name, args) if name == "list" => Some(args),
                _ => None,
            };
            if let Some(args) = args {
                for arg in args.iter() {
                    if let Some(s) = as_string(arg) {
                        add_label(s, out);
                    }
                }
            }
        }
    }
}

/// 抽 assoc list 的**值**（skin_tone_names / height_scaling_strings）。
fn collect_assoc_values(expr: &Expression, out: &mut BTreeSet<String>) {
    if let Expression::Base { term, follow } = expr {
        if follow.is_empty() {
            let args = match &term.elem {
                Term::List(args) => Some(args),
                Term::Call(name, args) if name == "list" => Some(args),
                _ => None,
            };
            if let Some(args) = args {
                for arg in args.iter() {
                    if let Expression::AssignOp { rhs, .. } = arg {
                        if let Some(s) = as_string(rhs) {
                            add_label(s, out);
                        }
                    }
                }
            }
        }
    }
}

fn capitalize_first(s: &str) -> String {
    let mut chars = s.chars();
    match chars.next() {
        Some(c) => c.to_uppercase().collect::<String>() + chars.as_str(),
        None => String::new(),
    }
}

/// 收集 proc 体里所有 `return <expr>` 表达式。
fn collect_returns<'a>(block: &'a [Spanned<Statement>], out: &mut Vec<&'a Expression>) {
    for stmt in block.iter() {
        match &stmt.elem {
            Statement::Return(Some(e)) => out.push(e),
            Statement::If { arms, else_arm } => {
                for (_c, blk) in arms.iter() {
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
            Statement::ForList(f) => collect_returns(&f.block, out),
            Statement::ForKeyValue(f) => collect_returns(&f.block, out),
            Statement::ForRange(f) => collect_returns(&f.block, out),
            _ => {}
        }
    }
}

/// 剥 BYOND 文法宏 \improper/\proper（运行时形态字节），与 mjs 的 addText 一致 —— 使键与运行时对齐。
fn add_label(raw: &str, out: &mut BTreeSet<String>) {
    let s = raw
        .replace('\u{ff}', "") // \improper/\proper 起始字节（运行时形态）
        .replace("\\improper", "")
        .replace("\\proper", "");
    let s = s.trim();
    if s.is_empty() || !s.chars().any(|c| c.is_alphabetic()) {
        return;
    }
    out.insert(s.to_string());
}

pub fn run(dme: &Path, out: &Path) -> Result<()> {
    let mut context = dm::Context::default();
    context.set_print_severity(Some(dm::Severity::Error));

    let pp = dm::preprocessor::Preprocessor::new(&context, dme.to_path_buf())
        .with_context(|| format!("无法打开 .dme: {}", dme.display()))?;
    let indents = dm::indents::IndentProcessor::new(&context, pp);
    let mut parser = dm::parser::Parser::new(&context, indents);
    parser.enable_procs();
    let (fatal, tree) = parser.parse_object_tree_2();
    if fatal {
        anyhow::bail!("DM 解析出现致命错误，无法继续 labels 抽取");
    }

    let mut labels: BTreeSet<String> = BTreeSet::new();

    for ty in tree.iter_types() {
        // 1) 类型路径前缀 → 显示名 var。
        for (prefix, var_name) in TYPE_VAR_RULES {
            if ty.path == *prefix || ty.path.starts_with(&format!("{prefix}/")) {
                if let Some(tv) = ty.vars.get(*var_name) {
                    if let Some(expr) = &tv.value.expression {
                        if let Some(t) = build_template(expr) {
                            if !t.contains('{') {
                                add_label(&t, &mut labels);
                            }
                        }
                    }
                }
            }
        }

        // 1b) 同上，但只收单词值（多词交给 P1，见 SINGLE_WORD_TYPE_VAR_RULES 的说明）。
        for (prefix, var_name) in SINGLE_WORD_TYPE_VAR_RULES {
            if ty.path == *prefix || ty.path.starts_with(&format!("{prefix}/")) {
                if let Some(tv) = ty.vars.get(*var_name) {
                    if let Some(expr) = &tv.value.expression {
                        if let Some(t) = build_template(expr) {
                            if !t.contains('{') && !t.trim().contains(char::is_whitespace) {
                                add_label(&t, &mut labels);
                            }
                        }
                    }
                }
            }
        }

        // 2) 具名 assoc-value 变量（任意类型）。
        for var_name in ASSOC_VALUE_VARS {
            if let Some(tv) = ty.vars.get(*var_name) {
                if let Some(expr) = &tv.value.expression {
                    collect_assoc_values(expr, &mut labels);
                }
            }
        }

        // 3) 文件作用域规则（按 var 声明位置的文件路径）。
        for (var_name, tv) in ty.vars.iter() {
            let _ = var_name;
            let Some(expr) = &tv.value.expression else {
                continue;
            };
            let file = context.file_path(tv.value.location.file);
            let file_str = file.to_string_lossy();
            if FILE_ASSOC_KEY_SUFFIXES
                .iter()
                .any(|s| file_str.ends_with(s))
            {
                collect_assoc_keys(expr, &mut labels);
            }
            if FILE_FLAT_DIRS.iter().any(|d| file_str.contains(d)) {
                collect_flat_strings(expr, &mut labels);
            }
        }

        // 4) procs：init_possible_values 选项显示 + alt_titles 赋值（在 alternative_job_titles 文件里）。
        for (proc_name, type_proc) in ty.procs.iter() {
            for proc_value in type_proc.value.iter() {
                let Some(block) = &proc_value.code else {
                    continue;
                };
                if proc_name == "init_possible_values" {
                    let mut rets = Vec::new();
                    collect_returns(block, &mut rets);
                    for r in rets {
                        collect_option_displays(r, &mut labels);
                    }
                }
                // GLOBAL_LIST_INIT 展开的 InitGlobal<X> proc（在 /datum/controller/global_vars 上）：
                // 体内首个赋值 `X = list(...)` 即全局 list 值。skin_tone_names 取 assoc 值、食物类别取键。
                if ty.path == "/datum/controller/global_vars" {
                    if let Some(global) = proc_name.strip_prefix("InitGlobal") {
                        if GLOBAL_INIT_ASSOC_VALUES.contains(&global) {
                            collect_global_init(block, &mut labels, collect_assoc_values);
                        } else if GLOBAL_INIT_ASSOC_KEYS.contains(&global) {
                            collect_global_init(block, &mut labels, collect_assoc_keys);
                        } else if GLOBAL_INIT_ALL_STRINGS.contains(&global) {
                            collect_global_init(block, &mut labels, collect_all_strings);
                        }
                    }
                }
                // alt_titles = list("…",…) 在 proc 体里赋值：按文件路径抽扁平串。
                let file = context.file_path(proc_value.location.file);
                if FILE_FLAT_DIRS
                    .iter()
                    .any(|d| file.to_string_lossy().contains(d))
                {
                    collect_flat_assignments(block, &mut labels);
                }
            }
        }
    }

    let json = serde_json::to_string_pretty(&labels.iter().collect::<Vec<_>>())?;
    std::fs::write(out, json + "\n")
        .with_context(|| format!("写 labels JSON 失败：{}", out.display()))?;
    eprintln!("抽取 {} 条 DM 显示标签 → {}", labels.len(), out.display());
    Ok(())
}

/// 收表达式子树里**所有**字符串字面量（含 `new /path("显示名", …)` 的构造实参）。
/// 仅供 GLOBAL_INIT_ALL_STRINGS 登记过的表使用——对任意表放开会把类型路径旁的标识符一起吞进来。
fn collect_all_strings(expr: &Expression, out: &mut BTreeSet<String>) {
    match expr {
        Expression::Base { term, follow } => {
            match &term.elem {
                Term::String(s) => add_label(s, out),
                Term::Expr(inner) => collect_all_strings(inner, out),
                Term::List(args) => {
                    for a in args.iter() {
                        collect_all_strings(a, out);
                    }
                }
                Term::Call(_, args) => {
                    for a in args.iter() {
                        collect_all_strings(a, out);
                    }
                }
                // `new /datum/pipe_info/pipe("Gas Filter", …)`：显示名是构造实参。
                Term::NewPrefab { args, .. } | Term::NewImplicit { args, .. } => {
                    if let Some(args) = args {
                        for a in args.iter() {
                            collect_all_strings(a, out);
                        }
                    }
                }
                _ => {}
            }
            for f in follow.iter() {
                if let Follow::Call(_, _, args) = &f.elem {
                    for a in args.iter() {
                        collect_all_strings(a, out);
                    }
                }
            }
        }
        Expression::AssignOp { lhs, rhs, .. } => {
            collect_all_strings(lhs, out);
            collect_all_strings(rhs, out);
        }
        Expression::BinaryOp { lhs, rhs, .. } => {
            collect_all_strings(lhs, out);
            collect_all_strings(rhs, out);
        }
        Expression::TernaryOp { if_, else_, .. } => {
            collect_all_strings(if_, out);
            collect_all_strings(else_, out);
        }
    }
}

/// 从 InitGlobal<X> proc 体抽全局 list：对体内每个 `<var> = <list>` 赋值的 RHS 应用 extractor
/// （assoc 值 / assoc 键）。宏生成体首句即 `X = InitValue`。
fn collect_global_init(
    block: &[Spanned<Statement>],
    out: &mut BTreeSet<String>,
    extractor: fn(&Expression, &mut BTreeSet<String>),
) {
    for stmt in block.iter() {
        if let Statement::Expr(Expression::AssignOp { rhs, .. }) = &stmt.elem {
            extractor(rhs, out);
        }
    }
}

/// 扫 proc 体里的赋值语句，对 `x = list("a","b",…)` 抽扁平字符串（用于 alt_titles）。
fn collect_flat_assignments(block: &[Spanned<Statement>], out: &mut BTreeSet<String>) {
    for stmt in block.iter() {
        match &stmt.elem {
            Statement::Expr(Expression::AssignOp { rhs, .. }) => collect_flat_strings(rhs, out),
            Statement::If { arms, else_arm } => {
                for (_c, blk) in arms.iter() {
                    collect_flat_assignments(blk, out);
                }
                if let Some(blk) = else_arm {
                    collect_flat_assignments(blk, out);
                }
            }
            Statement::Switch { cases, default, .. } => {
                for (_c, blk) in cases.iter() {
                    collect_flat_assignments(blk, out);
                }
                if let Some(blk) = default {
                    collect_flat_assignments(blk, out);
                }
            }
            _ => {}
        }
    }
}
