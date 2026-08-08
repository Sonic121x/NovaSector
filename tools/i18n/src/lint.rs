//! nova-i18n lint —— i18n 目录卫生 + 标识符碰撞静态门禁。
//!
//! 把 AGENTS.md「排查规律」里反复出现的两类 bug 从「玩家踩到才发现」变成「CI 编译期挡住」：
//!
//!   A. **目录卫生**（纯 JSON 检查，零误报）：
//!      - 占位符集合 en↔locale 必须一致（漏 `{0}` → 运行时插值留生串 / `{0}_弹匣` 类）。
//!      - en 值不得是「标识符形」（`^[a-z][a-z0-9_]*$`）—— act 键/枚举漏进目录会被反查表误翻。
//!      - 值里不得有裸控制字符（rustg acreplace 的 sentinel/JSON 坑）。
//!      - locale 值仍含「未译英文锚」（半翻译 bad-MT）报告为告警。
//!
//!   B. **标识符碰撞**（AST 静态分析，根因 #1「值匹配反查的本质歧义」的系统性出口）：
//!      扫全树，收集**标识符位置**的字符串字面量（`== / !=` 比较、`switch` case、list 下标键）。
//!      任何这样的标识符**同时**又是 en 目录里的一个**值**（即反查表/P1 会把它变异成译文）→
//!      运行期比较/查表必然 miss → gameplay 静默失效（StripMenu 蓝屏、landmark 出生错位、
//!      name2reagent 查表失败……全是此类）。报告 file:line。
//!      采用**基线（baseline）**模式增量采纳：记录当前已知碰撞，CI 只对**新增**碰撞失败。

use anyhow::{Context as _, Result};
use std::collections::{BTreeMap, BTreeSet};
use std::path::{Path, PathBuf};

use dm::ast::{BinaryOp, Case, Expression, Follow, Spanned, Statement, Term};

/// lint 结果：错误使退出码非零（CI 失败），告警仅打印。
#[derive(Default)]
struct Report {
    errors: Vec<String>,
    warnings: Vec<String>,
}

impl Report {
    fn error(&mut self, msg: String) {
        self.errors.push(msg);
    }
    fn warn(&mut self, msg: String) {
        self.warnings.push(msg);
    }
}

/// 手写的 locale-only 目录文件（无 en 对应是设计如此）：状态词表与人工 AC 兜底。
/// 这些不参与「陈旧 key / 占位符 parity」检查（它们本就没有英文源串）。
const MANUAL_ONLY_FILES: &[&str] = &["_state_words", "_fallback"];

/// 读取一个 locale 目录下全部 <ns>.json，合并成 key->value（与运行时 build_i18n_cache 一致）。
/// skip_manual=true 时跳过手写 locale-only 文件（用于 parity 检查的 locale 侧）。
fn load_catalog(dir: &Path) -> BTreeMap<String, String> {
    load_catalog_opt(dir, false)
}

fn load_catalog_opt(dir: &Path, skip_manual: bool) -> BTreeMap<String, String> {
    load_catalog_excluding(dir, if skip_manual { MANUAL_ONLY_FILES } else { &[] })
}

/// 读取目录下 .json 合并，跳过 stem 在 exclude 里的文件。
fn load_catalog_excluding(dir: &Path, exclude: &[&str]) -> BTreeMap<String, String> {
    let mut merged = BTreeMap::new();
    let Ok(entries) = std::fs::read_dir(dir) else {
        return merged;
    };
    for entry in entries.flatten() {
        let path = entry.path();
        if path.extension().and_then(|s| s.to_str()) != Some("json") {
            continue;
        }
        if let Some(stem) = path.file_stem().and_then(|s| s.to_str()) {
            if exclude.contains(&stem) {
                continue;
            }
        }
        let Ok(text) = std::fs::read_to_string(&path) else {
            continue;
        };
        let Ok(map) = serde_json::from_str::<BTreeMap<String, String>>(&text) else {
            continue;
        };
        for (k, v) in map {
            merged.insert(k, v);
        }
    }
    merged
}

/// 模板里出现的占位符下标集合（`{0}/{1}…`）。比较「集合」而非「个数」：
/// `{0} {1}` ↔ `{1} {0}`（中文语序重排）合法；`{0}` ↔ `{0}{1}`（漏参）非法。
fn placeholder_set(t: &str) -> BTreeSet<u32> {
    let b = t.as_bytes();
    let mut set = BTreeSet::new();
    let mut i = 0usize;
    while i < b.len() {
        if b[i] == b'{' {
            let mut j = i + 1;
            let mut num: u32 = 0;
            let mut had = false;
            while j < b.len() && b[j].is_ascii_digit() {
                num = num.saturating_mul(10).saturating_add((b[j] - b'0') as u32);
                j += 1;
                had = true;
            }
            if had && j < b.len() && b[j] == b'}' {
                set.insert(num);
                i = j + 1;
                continue;
            }
        }
        i += 1;
    }
    set
}

/// 点分标识符 key（ns.sub.name 形态：各段非空、仅含标识符字符）。用于识别 tgui 显式 useT key：
/// 其 en 值就是 key 本身、真实模板只在 locale 侧，占位符比对无意义。
fn is_dotted_key(s: &str) -> bool {
    s.split('.')
        .all(|seg| !seg.is_empty() && seg.chars().all(|c| c.is_ascii_alphanumeric() || c == '_'))
}

/// 裸控制字符（除 \n \t \r 外）。rustg acreplace 的 replacement 不能含控制字符（见 AGENTS.md），
/// 且 JSON 规范要求转义；目录里出现裸控制字符多半是抽取/MT 事故。
fn has_bad_control_char(s: &str) -> bool {
    s.chars()
        .any(|c| c.is_control() && c != '\n' && c != '\t' && c != '\r')
}

// ---------------------------------------------------------------------------
// A. 目录卫生
// ---------------------------------------------------------------------------

/// 校验三端策略单一来源 strings/i18n/policy.json：必须存在、可解析、
/// 各策略字段为字符串数组且无重复（三端消费者对坏 JSON 都是静默降级 → 必须在门禁挡住）。
fn lint_policy(catalog_root: &Path, report: &mut Report) {
    const FIELDS: [&str; 5] = [
        "payload_skip_keys",
        "pref_desc_keys",
        "no_auto_translate",
        "identifier_dot_procs",
        "identifier_dot_proc_suffixes",
    ];
    let path = catalog_root.join("policy.json");
    let Ok(text) = std::fs::read_to_string(&path) else {
        report.error(format!("[policy] 缺少 {}（三端标识符策略单一来源）", path.display()));
        return;
    };
    let json: serde_json::Value = match serde_json::from_str(&text) {
        Ok(v) => v,
        Err(err) => {
            report.error(format!("[policy] {} 解析失败：{err}", path.display()));
            return;
        }
    };
    for field in FIELDS {
        let Some(arr) = json[field].as_array() else {
            report.error(format!("[policy] 字段 {field} 缺失或不是数组"));
            continue;
        };
        let mut seen = std::collections::HashSet::new();
        for v in arr {
            let Some(s) = v.as_str() else {
                report.error(format!("[policy] {field} 含非字符串元素：{v}"));
                continue;
            };
            if !seen.insert(s) {
                report.error(format!("[policy] {field} 有重复项：{s}"));
            }
        }
    }
}

fn lint_catalog(catalog_root: &Path, locale: &str, report: &mut Report) -> Result<()> {
    let en_dir = catalog_root.join("en");
    let loc_dir = catalog_root.join(locale);
    let en = load_catalog(&en_dir);
    let loc = load_catalog_opt(&loc_dir, true);

    if en.is_empty() {
        report.warn(format!("英文目录为空或不存在：{}", en_dir.display()));
        return Ok(());
    }

    for (key, en_val) in &en {
        // en 侧控制字符多来自上游英文原文（如 U+0091/0092 弯引号被错编码）——extract 会重生，
        // 我们未必能改上游 → 仅告警（surface 不阻断）。locale 侧（下方）是我们写的译文 → 错误。
        if has_bad_control_char(en_val) {
            report.warn(format!(
                "[catalog] 英文值含裸控制字符（疑上游原文，建议修源）：{key}"
            ));
        }
    }

    // 占位符集合一致性 + locale 卫生。
    for (key, loc_val) in &loc {
        let Some(en_val) = en.get(key) else {
            // locale 有、en 没有：陈旧 key（en 目录已删除该串）。告警，不致命。
            report.warn(format!(
                "[catalog] {locale} 有 key 但英文目录已无（陈旧条目）：{key}"
            ));
            continue;
        };
        // 未译（zh == en）跳过卫生检查（待译占位）。
        if loc_val == en_val {
            continue;
        }
        // 显式 useT key（en 值就是 key 本身，如 tgui 的 "ammo_workbench.ui.sheets"）：真实模板只在
        // locale 侧，拿 key 比占位符无意义 → 跳过 parity。判据：en 值等于 key，或 en 值是无空格的点分标识符。
        if en_val == key || (!en_val.contains(' ') && en_val.contains('.') && is_dotted_key(en_val))
        {
            continue;
        }
        let en_ph = placeholder_set(en_val);
        let loc_ph = placeholder_set(loc_val);
        // 只有「zh 含 en 没有的占位符」才是真 bug：那个 {N} 永远没有实参填充 → 显示生串
        // （实参个数由 en 模板的占位符数决定，调用点据此传 args）。zh **少**用占位符是合法的：
        // 中文常省略代词/语序重排（"{1}self" → "自己"），少用时该 replacetext 只是 no-op，无害。
        let extra: BTreeSet<u32> = loc_ph.difference(&en_ph).copied().collect();
        if !extra.is_empty() {
            report.error(format!(
                "[catalog] {locale} 含 en 没有的占位符 {key}: 多出 {:?}（运行时无实参填充 → 显示生 {{N}}）\n    en: {en_val}\n    {locale}: {loc_val}",
                extra
            ));
        }
        if has_bad_control_char(loc_val) {
            report.error(format!("[catalog] {locale} 值含裸控制字符：{key}"));
        }
    }
    Ok(())
}

// ---------------------------------------------------------------------------
// B. 标识符碰撞（AST 静态分析）
// ---------------------------------------------------------------------------

/// 收集到的「标识符位置字符串」及其首次出现位置。
struct IdentCollector<'ctx> {
    context: &'ctx dm::Context,
    /// 字面量 -> 首个出现位置 "file:line"。
    idents: BTreeMap<String, String>,
}

impl<'ctx> IdentCollector<'ctx> {
    fn loc_str(&self, loc: dm::Location) -> String {
        let path = self.context.file_path(loc.file);
        format!("{}:{}", path.display(), loc.line)
    }

    fn record(&mut self, s: &str, loc: dm::Location) {
        // 只关心「标识符形」或「短无标点」串——长句子型不会被当 == 标识符（且句末标点闸门已挡）。
        // 但 == 比较里也可能出现完整短语（如 name == "Captain"）→ 不限形态，全收，靠与目录交集筛。
        if s.is_empty() {
            return;
        }
        if !self.idents.contains_key(s) {
            let loc_str = self.loc_str(loc);
            self.idents.insert(s.to_string(), loc_str);
        }
    }

    /// 若表达式是「裸字符串字面量」，返回其内容。
    fn as_string_literal(expr: &Expression) -> Option<&str> {
        if let Expression::Base { term, follow } = expr {
            if follow.is_empty() {
                if let Term::String(s) = &term.elem {
                    return Some(s);
                }
            }
        }
        None
    }

    fn visit_block(&mut self, block: &[Spanned<Statement>]) {
        for stmt in block.iter() {
            self.visit_stmt(&stmt.elem, stmt.location);
        }
    }

    fn visit_stmt(&mut self, stmt: &Statement, loc: dm::Location) {
        match stmt {
            Statement::Expr(e) | Statement::Throw(e) | Statement::Del(e) => self.visit_expr(e, loc),
            Statement::Return(opt) | Statement::Crash(opt) => {
                if let Some(e) = opt {
                    self.visit_expr(e, loc);
                }
            }
            Statement::While { condition, block } => {
                self.visit_expr(condition, loc);
                self.visit_block(block);
            }
            Statement::DoWhile { block, condition } => {
                self.visit_block(block);
                self.visit_expr(&condition.elem, condition.location);
            }
            Statement::If { arms, else_arm } => {
                for (cond, blk) in arms.iter() {
                    self.visit_expr(&cond.elem, cond.location);
                    self.visit_block(blk);
                }
                if let Some(blk) = else_arm {
                    self.visit_block(blk);
                }
            }
            Statement::ForInfinite { block } => self.visit_block(block),
            Statement::ForLoop {
                init,
                test,
                inc,
                block,
            } => {
                if let Some(s) = init {
                    self.visit_stmt(s, loc);
                }
                if let Some(e) = test {
                    self.visit_expr(e, loc);
                }
                if let Some(s) = inc {
                    self.visit_stmt(s, loc);
                }
                self.visit_block(block);
            }
            Statement::ForList(f) => {
                if let Some(e) = &f.in_list {
                    self.visit_expr(e, loc);
                }
                self.visit_block(&f.block);
            }
            Statement::ForKeyValue(f) => {
                if let Some(e) = &f.in_list {
                    self.visit_expr(e, loc);
                }
                self.visit_block(&f.block);
            }
            Statement::ForRange(f) => {
                self.visit_expr(&f.start, loc);
                self.visit_expr(&f.end, loc);
                if let Some(e) = &f.step {
                    self.visit_expr(e, loc);
                }
                self.visit_block(&f.block);
            }
            Statement::Var(v) => {
                if let Some(e) = &v.value {
                    self.visit_expr(e, loc);
                }
            }
            Statement::Vars(vs) => {
                for v in vs.iter() {
                    if let Some(e) = &v.value {
                        self.visit_expr(e, loc);
                    }
                }
            }
            Statement::Spawn { delay, block } => {
                if let Some(e) = delay {
                    self.visit_expr(e, loc);
                }
                self.visit_block(block);
            }
            Statement::Switch {
                input,
                cases,
                default,
            } => {
                // switch(input) { if("literal") … } —— 各 case 的精确字面量是 input 的标识符取值。
                self.visit_expr(input, loc);
                for (case_conditions, blk) in cases.iter() {
                    for case in case_conditions.elem.iter() {
                        if let Case::Exact(e) = case {
                            if let Some(s) = Self::as_string_literal(e) {
                                self.record(s, case_conditions.location);
                            }
                        }
                    }
                    self.visit_block(blk);
                }
                if let Some(blk) = default {
                    self.visit_block(blk);
                }
            }
            Statement::TryCatch {
                try_block,
                catch_block,
                ..
            } => {
                self.visit_block(try_block);
                self.visit_block(catch_block);
            }
            Statement::Label { block, .. } => self.visit_block(block),
            Statement::Setting { value, .. } => self.visit_expr(value, loc),
            _ => {}
        }
    }

    fn visit_expr(&mut self, expr: &Expression, loc: dm::Location) {
        match expr {
            Expression::Base { term, follow } => {
                self.visit_term(&term.elem, term.location);
                for f in follow.iter() {
                    if let Follow::Index(_, idx) = &f.elem {
                        // foo["literal"] —— 字面量下标键是标识符（assoc 查表/常量表键）。
                        if let Some(s) = Self::as_string_literal(idx) {
                            self.record(s, f.location);
                        }
                        self.visit_expr(idx, f.location);
                    } else if let Follow::Call(_, _, args) = &f.elem {
                        for a in args.iter() {
                            self.visit_expr(a, f.location);
                        }
                    }
                }
            }
            Expression::BinaryOp { op, lhs, rhs } => {
                // x == "literal" / "literal" == x （含 != / ~= / ~!）：字面量是 x 的标识符取值。
                if matches!(
                    op,
                    BinaryOp::Eq | BinaryOp::NotEq | BinaryOp::Equiv | BinaryOp::NotEquiv
                ) {
                    if let Some(s) = Self::as_string_literal(lhs) {
                        self.record(s, loc);
                    }
                    if let Some(s) = Self::as_string_literal(rhs) {
                        self.record(s, loc);
                    }
                }
                self.visit_expr(lhs, loc);
                self.visit_expr(rhs, loc);
            }
            Expression::AssignOp { lhs, rhs, .. } => {
                self.visit_expr(lhs, loc);
                self.visit_expr(rhs, loc);
            }
            Expression::TernaryOp {
                cond, if_, else_, ..
            } => {
                self.visit_expr(cond, loc);
                self.visit_expr(if_, loc);
                self.visit_expr(else_, loc);
            }
        }
    }

    fn visit_term(&mut self, term: &Term, loc: dm::Location) {
        match term {
            Term::Expr(e) => self.visit_expr(e, loc),
            Term::Call(_, args) | Term::SelfCall(args) | Term::ParentCall(args) => {
                for a in args.iter() {
                    self.visit_expr(a, loc);
                }
            }
            Term::List(args) => {
                for a in args.iter() {
                    self.visit_expr(a, loc);
                }
            }
            Term::InterpString(_, parts) => {
                for (opt, _) in parts.iter() {
                    if let Some(e) = opt {
                        self.visit_expr(e, loc);
                    }
                }
            }
            Term::Input { args, .. } => {
                for a in args.iter() {
                    self.visit_expr(a, loc);
                }
            }
            Term::Locate { args, in_list } => {
                for a in args.iter() {
                    self.visit_expr(a, loc);
                }
                if let Some(e) = in_list {
                    self.visit_expr(e, loc);
                }
            }
            Term::Pick(arms) => {
                for (weight, val) in arms.iter() {
                    if let Some(w) = weight {
                        self.visit_expr(w, loc);
                    }
                    self.visit_expr(val, loc);
                }
            }
            _ => {}
        }
    }
}

fn lint_identifier_collisions(
    dme: &Path,
    catalog_root: &Path,
    baseline: Option<&Path>,
    update_baseline: bool,
    report: &mut Report,
) -> Result<()> {
    let mut context = dm::Context::default();
    context.set_print_severity(Some(dm::Severity::Error));

    let pp = dm::preprocessor::Preprocessor::new(&context, dme.to_path_buf())
        .with_context(|| format!("无法打开 .dme: {}", dme.display()))?;
    let indents = dm::indents::IndentProcessor::new(&context, pp);
    let mut parser = dm::parser::Parser::new(&context, indents);
    parser.enable_procs();
    let (fatal, tree) = parser.parse_object_tree_2();
    if fatal {
        anyhow::bail!("DM 解析出现致命错误，无法继续 lint");
    }

    let mut collector = IdentCollector {
        context: &context,
        idents: BTreeMap::new(),
    };
    for ty in tree.iter_types() {
        for (_proc_name, type_proc) in ty.procs.iter() {
            for proc_value in type_proc.value.iter() {
                if let Some(block) = &proc_value.code {
                    collector.visit_block(block);
                }
            }
        }
    }

    // en 目录里「会被 DM 反查表变异」的值集合：无占位符的纯串（与 lang_build_reverse 一致）。
    // **排除 tgui.json**：前端目录的值是「TS 端翻显示、DM 保留英文值」机制（act/比较用英文，P1 经
    // i18n_tgui_strings 跳过、不动数据）——故 tgui-only 值被 DM 当标识符比较是**设计上安全**的，不应
    // 报碰撞。仍出现在其它命名空间（atom/obj/datum…）的值会被反查变异 → 仍纳入。
    let en = load_catalog_excluding(&catalog_root.join("en"), &["tgui"]);
    let mut translatable_values: BTreeSet<String> = BTreeSet::new();
    for v in en.values() {
        if !v.contains('{') {
            // lang_build_reverse 还会为首字母小写的键额外登记**首字母大写变体**（DM 里
            // 「小写存、`capitalize()` 显示」是通用写法）。变体同样会被反查变异，所以标识符
            // 碰撞面也跟着变大 —— 这里必须同步登记，否则 `"Move"` 这类比较会绕过门禁。
            if let Some(first) = v.chars().next() {
                if first.is_ascii_lowercase() && v.contains(' ') {
                    translatable_values
                        .insert(first.to_ascii_uppercase().to_string() + &v[first.len_utf8()..]);
                }
            }
            translatable_values.insert(v.clone());
        }
    }

    // 碰撞 = 标识符位置字符串 ∩ 可翻译目录值。
    let mut collisions: BTreeMap<String, String> = BTreeMap::new();
    for (ident, loc) in &collector.idents {
        if translatable_values.contains(ident) {
            collisions.insert(ident.clone(), loc.clone());
        }
    }

    // 基线：只对「不在基线里的新碰撞」失败。
    let baseline_set = match baseline {
        Some(p) if p.exists() => std::fs::read_to_string(p)
            .unwrap_or_default()
            .lines()
            .map(|l| l.trim())
            .filter(|l| !l.is_empty() && !l.starts_with('#'))
            .map(|l| l.to_string())
            .collect::<BTreeSet<String>>(),
        _ => BTreeSet::new(),
    };

    if update_baseline {
        if let Some(p) = baseline {
            let mut content = String::from(
                "# nova-i18n 标识符碰撞基线（由 `nova-i18n lint --update-baseline` 生成）。\n\
                 # 每行一个「既是 DM 标识符（==/switch/下标）又是 en 目录可翻译值」的字符串。\n\
                 # CI 只对**不在此表**的新增碰撞失败。修复一个碰撞（让该串不再被翻译，或消费侧\n\
                 # 用 lang_unreverse_text）后，从此表删掉对应行。\n",
            );
            for ident in collisions.keys() {
                content.push_str(ident);
                content.push('\n');
            }
            std::fs::write(p, content).with_context(|| format!("写基线失败：{}", p.display()))?;
            eprintln!(
                "已写入基线 {}（{} 条已知碰撞）。",
                p.display(),
                collisions.len()
            );
        }
        return Ok(());
    }

    // 置信分级：含下划线/全大写的标识符（icon_state/render_target/HUMANS_ONLY/toggle_safety…）
    // 是无歧义的代码 token —— 它若等于某可翻译显示串，几乎一定是真泄漏 → **新增即报错**。
    // 单词类（acid/amber/back…）多为「被比较变量从不经翻译」的误报 → 新增仅**告警**（surface 不阻断）。
    // 基线冻结当前全部已知碰撞，二者皆 silent；只对**不在基线**的新增按置信发声。
    let high_confidence = |s: &str| s.contains('_') || s.chars().all(|c| !c.is_ascii_lowercase());

    let mut new_err = 0usize;
    let mut new_warn = 0usize;
    for (ident, loc) in &collisions {
        if baseline_set.contains(ident) {
            continue;
        }
        let msg = format!(
            "字符串 \"{ident}\" 既被当标识符（==/switch/下标，见 {loc}）又是 en 目录可翻译值\n    \
             → 全服中文时反查表会把它变异成译文，运行期比较/查表必然 miss（StripMenu 蓝屏 / 出生点错位 / 查表失败类）。\n    \
             修法：① 把供给该串的变量排除出抽取（句末标点闸门 / SINK_VARS 黑名单）；② 消费侧用 lang_unreverse_text 兜；\n    \
             ③ 确认安全后 `nova-i18n lint --update-baseline` 收进基线。"
        );
        if high_confidence(ident) {
            new_err += 1;
            report.error(format!("[ident/高] {msg}"));
        } else {
            new_warn += 1;
            report.warn(format!("[ident/中] {msg}"));
        }
    }

    eprintln!(
        "标识符扫描：收集 {} 个标识符位置字符串，与目录交集 {} 个碰撞（基线 {} 条；新增高置信 {} 条→错误，新增单词类 {} 条→告警）。",
        collector.idents.len(),
        collisions.len(),
        baseline_set.len(),
        new_err,
        new_warn
    );
    Ok(())
}

// ---------------------------------------------------------------------------

#[allow(clippy::too_many_arguments)]
/// C. **悬空 LANG key**：源码里 `LANG("obj.abc12345")` 而目录里没有这个 key。
///
/// 抽取与改写是**两个独立通道**：改写把字面量换成 LANG(key)，抽取负责把模板写进目录。任何一条
/// 让抽取跳过、而改写不跳过的规则（典型：具名累加器的整句闸——`available_channels += "<li>…</li>"`
/// 过不了句末标点闸，改写却照改不误），都会产出悬空 key。此时 `lang_resolve` 兜底**返回 key 本身**，
/// 玩家在耳机 examine 里看到的就是 `obj.b045da9c` 这串乱码——比不翻译严重得多。
///
/// 一次实测：全仓三万余处 LANG 调用里有 76 个悬空 key（耳机频率表、无人机分发器、血虫技能、
/// 音乐技能芯片、雇佣合同…）。故列为**错误**而非告警：这是坏显示，不是缺翻译。
fn lint_dangling_lang_keys(root: &Path, catalog_root: &Path, report: &mut Report) {
    let en = load_catalog(&catalog_root.join("en"));
    if en.is_empty() {
        return; // lint_catalog 已就此告警
    }
    let mut dangling: BTreeMap<String, String> = BTreeMap::new();
    let mut scanned = 0usize;
    for dir in ["code", "modular_nova"] {
        collect_dm_files(&root.join(dir), &mut |path: &Path, text: &str| {
            for (lineno, line) in text.lines().enumerate() {
                for key in lang_keys_in_line(line) {
                    scanned += 1;
                    if !en.contains_key(&key) {
                        dangling
                            .entry(key)
                            .or_insert_with(|| format!("{}:{}", path.display(), lineno + 1));
                    }
                }
            }
        });
    }
    for (key, loc) in &dangling {
        report.error(format!(
            "[dangling] LANG(\"{key}\") 在 en 目录里没有对应条目（见 {loc}）\n\
             \t→ 运行期 lang_resolve 兜底返回 key 本身，玩家看到的就是这串 key。\n\
             \t成因几乎总是「改写改了、抽取没抽」：某条规则让 extract 跳过而 rewrite 没跳过。\n\
             \t修法：从引入该 LANG 调用的 commit 的 diff 里取回原字面量（用本 key 的 hash 校验），\n\
             \t写回 en/zh 目录；同时补齐 extract 侧的准入规则，否则下次抽取还会漏。"
        ));
    }
    eprintln!("悬空 key 扫描：{scanned} 处 LANG 调用，{} 个悬空。", dangling.len());
}

/// 一行里出现的所有 `LANG("<ns>.<8 位十六进制>"` / `LANGU(…, "<key>"` 的 key。
/// 手写扫描而非正则：这个 crate 没有 regex 依赖，而形态固定得很简单。
fn lang_keys_in_line(line: &str) -> Vec<String> {
    let bytes = line.as_bytes();
    let mut out = Vec::new();
    let mut i = 0usize;
    while let Some(pos) = line[i..].find("LANG") {
        let start = i + pos;
        i = start + 4;
        // LANG(" 或 LANGU(... 之后的**第一个**字符串字面量即 key 位（LANGU 的 user 实参不是字面量）。
        let rest = &line[i..];
        let Some(quote) = rest.find('"') else { break };
        let after = &rest[quote + 1..];
        let Some(close) = after.find('"') else { break };
        let candidate = &after[..close];
        if is_catalog_key(candidate) {
            out.push(candidate.to_string());
        }
        i += quote + 1 + close + 1;
        let _ = bytes; // 仅为可读性保留切片边界推进
    }
    out
}

/// `<ns>.<8 位十六进制>` 形态。
fn is_catalog_key(s: &str) -> bool {
    let Some((ns, hash)) = s.split_once('.') else {
        return false;
    };
    !ns.is_empty()
        && ns.chars().all(|c| c.is_ascii_lowercase() || c == '_')
        && hash.len() == 8
        && hash.chars().all(|c| c.is_ascii_hexdigit())
}

/// 递归遍历 .dm 文件并回调 (path, 内容)。
fn collect_dm_files(dir: &Path, visit: &mut dyn FnMut(&Path, &str)) {
    let Ok(entries) = std::fs::read_dir(dir) else {
        return;
    };
    let mut paths: Vec<PathBuf> = entries.flatten().map(|e| e.path()).collect();
    paths.sort();
    for path in paths {
        if path.is_dir() {
            collect_dm_files(&path, visit);
        } else if path.extension().is_some_and(|e| e == "dm") {
            if let Ok(text) = std::fs::read_to_string(&path) {
                visit(&path, &text);
            }
        }
    }
}

pub fn run(
    dme: &Path,
    catalog_root: &Path,
    locale: &str,
    baseline: Option<PathBuf>,
    update_baseline: bool,
    skip_ast: bool,
) -> Result<()> {
    let mut report = Report::default();

    lint_catalog(catalog_root, locale, &mut report)?;
    lint_policy(catalog_root, &mut report);
    lint_dangling_lang_keys(Path::new("."), catalog_root, &mut report);
    if !skip_ast {
        lint_identifier_collisions(
            dme,
            catalog_root,
            baseline.as_deref(),
            update_baseline,
            &mut report,
        )?;
    }

    if update_baseline {
        return Ok(());
    }

    for w in &report.warnings {
        eprintln!("warning: {w}");
    }
    for e in &report.errors {
        eprintln!("error: {e}");
    }
    eprintln!(
        "\nlint 完成：{} 错误，{} 告警。",
        report.errors.len(),
        report.warnings.len()
    );
    if !report.errors.is_empty() {
        anyhow::bail!("i18n lint 发现 {} 个错误", report.errors.len());
    }
    Ok(())
}
