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

use crate::{governance::CatalogDomains, keys};

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

/// 允许在运行期把译文写进 `name` 的调用点（上游本来就在运行期拼这些名字，且它们是**复合身份名**、
/// 不参与任何英文比较；显示边界的 `name == initial(name)` 判据本就把它们排除在类型标签之外）。
///   · edible.dm     —— `"slice of [x]"`
///   · mail.dm       —— `"[initial(name)] for [收件人] ([职位])"`
/// 新增前先问：这个 name 有没有可能被拿去比较/当查表键？有 → 不该固化译文。
const NAME_LANG_ASSIGN_ALLOWLIST: &[&str] = &[
    "code/datums/components/food/edible.dm",
    "code/game/objects/items/mail.dm",
    // 打印出来的法医报告：`"FR-[编号] 'Forensic Record'"` 是**新生成实例的合成身份名**
    // （与 mail.dm 的「给某某的信」同形），编号来自运行期计数器，不存在 canonical 英文原名
    // 可供显示边界反查。纸张名不参与任何比较。
    "code/modules/detectivework/scanner.dm",
    // MOD 组件的钉选动作名 `"Activate [模块名]"`：上游本来就在 `New()` 里按链接的模块拼出来，
    // 不存在 canonical 英文原名可供显示边界反查。唯一读它的比较是 `action.dm` 的 `SetId`，
    // 那里比的是**同一个 mob 上两个动作名之间**（给同名按钮分配不同 id），两边同时被译仍然
    // 相等，所以译名不破坏它。
    "code/modules/mod/mod_actions.dm",
];

/// 表达式的**值**是否就是 LANG 的产物（译文串）。
///
/// 语义刻意比「出现过 LANG」严：`name = tgui_input_text(user, LANG(提示), LANG(标题), …)` 里
/// LANG 只是别人的实参，赋进 name 的是管理员输入 —— 按「出现过」判会当场误报（admin_verbs.dm
/// 就是这形状）。只认值位置：LANG 本身、拼接/三元的分支、内插串里的内插项。
///
/// 注意匹配的是**宏展开后**的名字：`LANG`/`LANGU` 是 `#define`，SpacemanDMM 的预处理器在建 AST
/// 之前就把它们展开成 `lang_format`/`lang_format_for` 了，AST 里根本没有 "LANG"（与 extract.rs
/// 里那处注释同源）。
fn expr_yields_lang(expr: &Expression) -> bool {
    match expr {
        Expression::Base { term, follow } => follow.is_empty() && term_yields_lang(&term.elem),
        Expression::BinaryOp { op, lhs, rhs } => {
            matches!(op, BinaryOp::Add) && (expr_yields_lang(lhs) || expr_yields_lang(rhs))
        }
        Expression::AssignOp { rhs, .. } => expr_yields_lang(rhs),
        Expression::TernaryOp { if_, else_, .. } => {
            expr_yields_lang(if_) || expr_yields_lang(else_)
        }
    }
}

fn term_yields_lang(term: &Term) -> bool {
    match term {
        Term::Call(name, _) => matches!(name.as_str(), "lang_format" | "lang_format_for"),
        Term::Expr(inner) => expr_yields_lang(inner),
        Term::InterpString(_, parts) => parts
            .iter()
            .any(|(part, _)| part.as_ref().is_some_and(expr_yields_lang)),
        _ => false,
    }
}

/// 收集 `name = <含 LANG 的表达式>` / `X.name = <含 LANG 的表达式>` 的位置（含 if/for 等嵌套块）。
fn collect_name_lang_assigns(block: &[Spanned<Statement>], out: &mut Vec<dm::Location>) {
    for stmt in block.iter() {
        if let Statement::Expr(Expression::AssignOp { op, lhs, rhs }) = &stmt.elem {
            if matches!(op, dm::ast::AssignOp::Assign)
                && assign_target_is_name(lhs)
                && expr_yields_lang(rhs)
            {
                out.push(stmt.location);
            }
        }
        visit_nested_blocks(&stmt.elem, &mut |inner| {
            collect_name_lang_assigns(inner, out)
        });
    }
}

/// 遍历语句里嵌套的子块（if/else/for/while/switch/do…）。只关心「块」，条件表达式不下探——
/// 赋值不会出现在条件里。
fn visit_nested_blocks(stmt: &Statement, sink: &mut impl FnMut(&[Spanned<Statement>])) {
    match stmt {
        Statement::If { arms, else_arm } => {
            for (_, block) in arms.iter() {
                sink(block);
            }
            if let Some(block) = else_arm {
                sink(block);
            }
        }
        Statement::ForLoop { block, .. }
        | Statement::While { block, .. }
        | Statement::DoWhile { block, .. } => sink(block),
        Statement::ForList(for_list) => sink(&for_list.block),
        Statement::ForRange(for_range) => sink(&for_range.block),
        Statement::Switch { cases, default, .. } => {
            for (_, block) in cases.iter() {
                sink(block);
            }
            if let Some(block) = default {
                sink(block);
            }
        }
        Statement::TryCatch {
            try_block,
            catch_block,
            ..
        } => {
            sink(try_block);
            sink(catch_block);
        }
        Statement::Spawn { block, .. } => sink(block),
        _ => {}
    }
}

/// 赋值左侧是否是 `name` 或 `<something>.name`。
fn assign_target_is_name(lhs: &Expression) -> bool {
    let Expression::Base { term, follow } = lhs else {
        return false;
    };
    if let Some(last) = follow.last() {
        return matches!(&last.elem, Follow::Field(_, field) if field.as_str() == "name");
    }
    matches!(&term.elem, Term::Ident(ident) if ident.as_str() == "name")
}

/// 规则 D：**目录里有、源码里却还是裸字面量**。
///
/// 抽取与改写是两条独立通道。上游把一段文案搬进新写法时，extract 常常照样抽得到（于是目录里
/// 有键、还被翻译了），而 rewrite 认不出那个 sink（比如上游把板条箱隐私锁重构成组件后，消息经
/// 项目自定义的 `deny(source, user, msg)` 下发）→ 源码里留着裸英文，玩家看到的就是英文，而
/// 目录里那条译文永远查不到调用点。这类**现有 lint 一条都查不出**：`nova-i18n lint` 的悬空 key
/// 规则查的是反方向（有 key 没原文）。
///
/// 判据刻意收紧到「**这段文字已经在 en 目录里**」：那说明抽取器认得它、译文多半也在，唯一缺的
/// 就是改写。纯启发式的「proc 里出现英文句子」噪音太大，没法当门禁。
struct BareLiteralCollector<'ctx> {
    context: &'ctx dm::Context,
    hits: BTreeMap<String, String>,
}

impl<'ctx> BareLiteralCollector<'ctx> {
    fn record(&mut self, text: &str, loc: dm::Location) {
        if !self.hits.contains_key(text) {
            let path = self.context.file_path(loc.file);
            // 单元测试里的英文串是**夹具**：i18n 的落地层测试必须照抄真实渲染形态（见 AGENTS 里
            // 「照抄真实形态，别手写等价物」那条），于是每写一条回归断言就会被这条规则报成新增
            // 裸字面量。抽取侧早有同样的排除（extract.rs 的 in_unit_tests），这里漏了。
            // 注意 DM 的 file list 用反斜杠，Path::components() 认不出，按归一后的字符串判。
            let normalized = path.to_string_lossy().replace('\\', "/");
            if normalized.contains("/unit_tests/") || normalized.starts_with("unit_tests/") {
                return;
            }
            self.hits
                .insert(text.to_string(), format!("{}:{}", path.display(), loc.line));
        }
    }

    fn visit_block(&mut self, block: &[Spanned<Statement>]) {
        for stmt in block.iter() {
            self.visit_stmt(&stmt.elem, stmt.location);
            visit_nested_blocks(&stmt.elem, &mut |inner| self.visit_block(inner));
        }
    }

    fn visit_stmt(&mut self, stmt: &Statement, loc: dm::Location) {
        match stmt {
            Statement::Expr(e) => self.visit_expr(e, loc),
            Statement::Return(Some(e)) => self.visit_expr(e, loc),
            Statement::Var(v) => {
                if let Some(e) = &v.value {
                    self.visit_expr(e, loc);
                }
            }
            _ => {}
        }
    }

    fn visit_expr(&mut self, expr: &Expression, loc: dm::Location) {
        match expr {
            Expression::Base { term, follow } => {
                self.visit_term(&term.elem, term.location);
                for f in follow.iter() {
                    match &f.elem {
                        Follow::Index(_, idx) => self.visit_expr(idx, loc),
                        Follow::Call(_, _, args) => {
                            for a in args.iter() {
                                self.visit_expr(a, loc);
                            }
                        }
                        _ => {}
                    }
                }
            }
            Expression::BinaryOp { lhs, rhs, .. } | Expression::AssignOp { lhs, rhs, .. } => {
                self.visit_expr(lhs, loc);
                self.visit_expr(rhs, loc);
            }
            Expression::TernaryOp { cond, if_, else_ } => {
                self.visit_expr(cond, loc);
                self.visit_expr(if_, loc);
                self.visit_expr(else_, loc);
            }
        }
    }

    fn visit_term(&mut self, term: &Term, loc: dm::Location) {
        match term {
            // LANG 调用整棵子树跳过：key 是 `<ns>.<hash>`，实参里的字面量是**故意**留成裸串的
            // （运行期由 lang_localize_arg 逐实参反查），报它们只会淹掉真正的漏网之鱼。
            Term::Call(name, args) => {
                if matches!(name.as_str(), "lang_format" | "lang_format_for") {
                    return;
                }
                for a in args.iter() {
                    self.visit_expr(a, loc);
                }
            }
            Term::String(text) => {
                self.record(text, loc);
            }
            // 插值串同样要查：`speak("[mode] level [threat] scumbag [name] in [area].")` 的**模板形态**
            // （`{0} level {1} scumbag {2} in {3}.`）早就在目录里、也译好了，缺的只是 rewrite 不认那个
            // sink。只看纯字面量会整类漏掉——beepsky 的逮捕播报就是这么在目录里躺了很久的。
            Term::InterpString(_, parts) => {
                let expr = Expression::Base {
                    term: Box::new(Spanned::new(loc, term.clone())),
                    follow: Box::new([]),
                };
                if let Some(template) = crate::template::build_template(&expr) {
                    self.record(&template, loc);
                }
                // 内插表达式里还可能嵌着自己的字面量（`"… [x ? "bar baz." : ""] …"`）。
                // 从前这一支只记模板就 return 了，另有一条同名 arm 想做下探却因排在后面**永不可达**
                // （编译器的 unreachable_pattern 警告一直在报）——整类嵌套字面量因此不在规则 D 视野里。
                for (opt, _) in parts.iter() {
                    if let Some(e) = opt {
                        self.visit_expr(e, loc);
                    }
                }
            }
            Term::Expr(inner) => self.visit_expr(inner, loc),
            Term::SelfCall(args) | Term::ParentCall(args) | Term::List(args) => {
                for a in args.iter() {
                    self.visit_expr(a, loc);
                }
            }
            _ => {}
        }
    }
}

/// 「句子型」：含空格且以句末标点收尾。挡掉标识符、图标名、路径片段这些同样可能出现在目录里的短串。
fn is_sentence_shaped(text: &str) -> bool {
    let trimmed = text.trim();
    if !trimmed.contains(' ') || trimmed.len() < 12 {
        return false;
    }
    trimmed.ends_with(['.', '!', '?'])
}

/// 目录值里也要放行**插值模板**（含 `{N}`）：规则 D 现在同时比对插值串的模板形态。
fn is_catalog_candidate(value: &str) -> bool {
    is_sentence_shaped(value)
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
    let mut paths: Vec<PathBuf> = entries.flatten().map(|entry| entry.path()).collect();
    paths.sort();
    for path in paths {
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

#[derive(Clone, Debug, Eq, PartialEq)]
struct DomainCatalogEntry {
    domain: String,
    key: String,
    file: String,
    value: String,
}

#[derive(Clone, Debug, Eq, PartialEq)]
struct DuplicateConflict {
    domain: String,
    key: String,
    first_file: String,
    first_value: String,
    second_file: String,
    second_value: String,
}

fn duplicate_conflicts(
    entries: impl IntoIterator<Item = DomainCatalogEntry>,
) -> Vec<DuplicateConflict> {
    let mut seen: BTreeMap<(String, String), DomainCatalogEntry> = BTreeMap::new();
    let mut conflicts = Vec::new();
    for entry in entries {
        let identity = (entry.domain.clone(), entry.key.clone());
        if let Some(first) = seen.get(&identity) {
            if first.value != entry.value {
                conflicts.push(DuplicateConflict {
                    domain: entry.domain,
                    key: entry.key,
                    first_file: first.file.clone(),
                    first_value: first.value.clone(),
                    second_file: entry.file,
                    second_value: entry.value,
                });
            }
        } else {
            seen.insert(identity, entry);
        }
    }
    conflicts
}

/// Runtime merges files by the explicit domain manifest. A key repeated with
/// the same value is harmless, but different values make the effective
/// translation depend on file iteration order and are therefore a hard error.
fn lint_duplicate_catalog_keys(
    locale_dir: &Path,
    locale: &str,
    domains: &CatalogDomains,
    report: &mut Report,
) {
    let Ok(entries) = std::fs::read_dir(locale_dir) else {
        report.error(format!(
            "[catalog/domain] locale 目录不存在或不可读：{}",
            locale_dir.display()
        ));
        return;
    };
    let mut paths: Vec<PathBuf> = entries.flatten().map(|entry| entry.path()).collect();
    paths.sort();
    let mut domain_entries = Vec::new();
    for path in paths {
        if !path.is_file() || path.extension().and_then(|ext| ext.to_str()) != Some("json") {
            continue;
        }
        let Some(file_name) = path.file_name().and_then(|name| name.to_str()) else {
            report.error(format!(
                "[catalog/domain] locale={locale} 文件名不是 UTF-8：{}",
                path.display()
            ));
            continue;
        };
        let Some(policy) = domains.get(file_name) else {
            report.error(format!(
                "[catalog/domain] locale={locale} 文件未登记，runtime 会拒绝加载：{}",
                path.display()
            ));
            continue;
        };
        let text = match std::fs::read_to_string(&path) {
            Ok(text) => text,
            Err(err) => {
                report.error(format!(
                    "[catalog/domain] locale={locale} 无法读取 {}：{err}",
                    path.display()
                ));
                continue;
            }
        };
        let map = match serde_json::from_str::<BTreeMap<String, String>>(&text) {
            Ok(map) => map,
            Err(err) => {
                report.error(format!(
                    "[catalog/domain] locale={locale} JSON 解析失败 {}：{err}",
                    path.display()
                ));
                continue;
            }
        };
        for (key, value) in map {
            domain_entries.push(DomainCatalogEntry {
                domain: policy.domain.clone(),
                key,
                file: path.display().to_string(),
                value,
            });
        }
    }

    for conflict in duplicate_conflicts(domain_entries) {
        report.error(format!(
            "[catalog/domain] locale={locale} domain={} 的 key {:?} 有冲突译文：\n    {} = {:?}\n    {} = {:?}",
            conflict.domain,
            conflict.key,
            conflict.first_file,
            conflict.first_value,
            conflict.second_file,
            conflict.second_value
        ));
    }
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
    const FIELDS: [&str; 7] = [
        "payload_skip_keys",
        "payload_prose_keys",
        "translatable_props",
        "option_text_props",
        "no_auto_translate",
        "identifier_dot_procs",
        "identifier_dot_proc_suffixes",
    ];
    let path = catalog_root.join("policy.json");
    let source_bytes = match std::fs::read(&path) {
        Ok(bytes) => bytes,
        Err(err) => {
            report.error(format!(
                "[policy] 无法读取 {}（三端标识符策略单一来源）：{err}",
                path.display()
            ));
            return;
        }
    };
    let json: serde_json::Value = match serde_json::from_slice(&source_bytes) {
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

    let Some(project_root) = catalog_root.parent().and_then(Path::parent) else {
        report.error(format!(
            "[policy] 无法从目录根推导项目根：{}",
            catalog_root.display()
        ));
        return;
    };
    let copy_path = project_root.join("tgui/packages/tgui/i18n/policy.json");
    match std::fs::read(&copy_path) {
        Err(err) => report.error(format!(
            "[policy] 无法读取 committed TGUI copy {}：{err}",
            copy_path.display()
        )),
        Ok(copy_bytes) if copy_bytes != source_bytes => {
            let offset = source_bytes
                .iter()
                .zip(&copy_bytes)
                .position(|(source, copy)| source != copy)
                .unwrap_or(source_bytes.len().min(copy_bytes.len()));
            report.error(format!(
                "[policy] policy drift：{} 与 {} 不是 byte-identical（首个差异 byte {}，长度 {} vs {}）。运行 `node tools/i18n/tgui-catalog.mjs sync` 后提交副本。",
                path.display(),
                copy_path.display(),
                offset,
                source_bytes.len(),
                copy_bytes.len()
            ));
        }
        Ok(_) => {}
    }
}

fn lint_catalog(
    catalog_root: &Path,
    locale: &str,
    domains: &CatalogDomains,
    report: &mut Report,
) -> Result<()> {
    let en_dir = catalog_root.join("en");
    let loc_dir = catalog_root.join(locale);
    lint_duplicate_catalog_keys(&en_dir, "en", domains, report);
    if locale != "en" {
        lint_duplicate_catalog_keys(&loc_dir, locale, domains, report);
    }
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
    bare_baseline: Option<&Path>,
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
    let parser_errors: Vec<String> = {
        let diagnostics = context.errors();
        diagnostics
            .iter()
            .filter(|diagnostic| diagnostic.severity() == dm::Severity::Error)
            .map(|diagnostic| diagnostic.description().to_owned())
            .collect()
    };
    if fatal || !parser_errors.is_empty() {
        let examples = parser_errors
            .iter()
            .take(5)
            .map(|description| format!("{description:?}"))
            .collect::<Vec<_>>()
            .join(", ");
        anyhow::bail!(
            "DM parser coverage failed/unsupported：fatal={fatal}，Severity::Error={}，exclusions=0；不会把 best-effort AST 当作完整 lint。{}",
            parser_errors.len(),
            if examples.is_empty() {
                String::new()
            } else {
                format!("diagnostics: {examples}")
            }
        );
    }
    eprintln!("[coverage] DM parser: full（Severity::Error=0，exclusions=0）");

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

    // 规则 C：**数据不许被翻**。
    //
    // 整条显示边界方案（类型显示名表 / 运行期反查）都建立在一个不变量上：实例的 name/desc 始终是
    // canonical English，`if(X.name == "…")`、`GLOB.foo[X.name]`、act 回传比较才不会当场坏掉。
    // 今天这条不变量靠 rewrite 的结构（只遍历 ty.procs，够不到类型变量声明）保证，但那是「碰巧
    // 成立」——谁把类型变量也纳入改写，或谁手写一句 `name = LANG(...)`，破坏都是静默的。
    // 这里把它变成编译期门禁。
    let mut data_translation = Vec::new();
    for ty in tree.iter_types() {
        // C1：类型变量声明里不得出现 LANG —— 那等于把译文固化成实例数据。
        for (var_name, type_var) in ty.vars.iter() {
            if !matches!(var_name.as_str(), "name" | "desc") {
                continue;
            }
            let Some(expr) = &type_var.value.expression else {
                continue;
            };
            if expr_yields_lang(expr) {
                let loc = type_var.value.location;
                data_translation.push(format!(
                    "{}:{} 类型变量声明 `{}` 含 LANG()：实例数据会变成译文，name/desc 的比较与查表会静默失效",
                    context.file_path(loc.file).display(),
                    loc.line,
                    var_name
                ));
            }
        }
        // C2：proc 体内 `name = LANG(...)` 只允许白名单（上游本就在运行期拼的复合名）。
        for (_proc_name, type_proc) in ty.procs.iter() {
            for proc_value in type_proc.value.iter() {
                let Some(block) = &proc_value.code else {
                    continue;
                };
                let mut hits = Vec::new();
                collect_name_lang_assigns(block, &mut hits);
                for loc in hits {
                    let path = context.file_path(loc.file);
                    let path_str = path.display().to_string().replace('\\', "/");
                    if NAME_LANG_ASSIGN_ALLOWLIST
                        .iter()
                        .any(|allowed| path_str.ends_with(allowed))
                    {
                        continue;
                    }
                    data_translation.push(format!(
                        "{}:{} 运行期 `name = LANG(...)`：实例名会变成译文。纯显示请走显示边界（lang_localize_name_for_display），确需固化请加进 NAME_LANG_ASSIGN_ALLOWLIST 并说明理由",
                        path.display(),
                        loc.line
                    ));
                }
            }
        }
    }
    for msg in data_translation {
        report.error(msg);
    }

    // 规则 D：目录里有、源码里却还是裸字面量（extract 认得、rewrite 不认的 sink）。
    let mut bare = BareLiteralCollector {
        context: &context,
        hits: BTreeMap::new(),
    };
    for ty in tree.iter_types() {
        for (_proc_name, type_proc) in ty.procs.iter() {
            for proc_value in type_proc.value.iter() {
                if let Some(block) = &proc_value.code {
                    bare.visit_block(block);
                }
            }
        }
    }
    let en_full = load_catalog(&catalog_root.join("en"));
    let catalog_sentences: BTreeSet<&str> = en_full
        .values()
        .filter(|v| is_catalog_candidate(v))
        .map(|v| v.as_str())
        .collect();
    let mut bare_hits: Vec<(String, String)> = bare
        .hits
        .into_iter()
        .filter(|(text, _)| catalog_sentences.contains(text.as_str()))
        .collect();
    bare_hits.sort();
    // 基线：绝大多数命中是**有意**留给反查路径的（speak 词池、examine 累加器、desc 变量…），
    // 所以这条规则只对「基线里没有的新增」失败 —— 那才是「上游换了 sink、rewrite 跟不上」的信号。
    let bare_baseline_set = match bare_baseline {
        Some(p) if p.exists() => std::fs::read_to_string(p)
            .unwrap_or_default()
            .lines()
            // **不能 trim**：这条规则的键是句子原文，行首空格是内容的一部分（`" Administrators
            // have been informed."` 这种拼句片段），trim 掉就永远匹配不上、每次都报成新增。
            .map(|l| l.strip_suffix('\r').unwrap_or(l))
            .filter(|l| !l.trim().is_empty() && !l.trim_start().starts_with('#'))
            .map(|l| l.to_string())
            .collect::<BTreeSet<String>>(),
        _ => BTreeSet::new(),
    };
    if update_baseline {
        if let Some(p) = bare_baseline {
            let mut content = String::from(
                "# nova-i18n「目录里有、源码里仍是裸字面量」基线（`nova-i18n lint --update-baseline` 生成）。\n                 # 每行一条已进 en 目录、但调用点没被 rewrite 改成 LANG 的句子。多数是有意留给反查\n                 # 路径的（speak 词池 / examine 累加器 / desc 变量）；CI 只对**不在此表**的新增失败 ——\n                 # 那通常意味着上游把消息挪进了 rewrite 不认识的 sink，译文会永远查不到调用点。\n",
            );
            for (text, _) in bare_hits.iter() {
                content.push_str(&text.replace('\n', "\\n"));
                content.push('\n');
            }
            std::fs::write(p, content)
                .with_context(|| format!("写裸英文基线失败：{}", p.display()))?;
            eprintln!(
                "已写入裸英文基线：{}（{} 条）",
                p.display(),
                bare_hits.len()
            );
        }
    }
    let new_bare: Vec<&(String, String)> = bare_hits
        .iter()
        .filter(|(text, _)| !bare_baseline_set.contains(text.replace('\n', "\\n").as_str()))
        .collect();
    if !new_bare.is_empty() {
        for (text, loc) in new_bare.iter().take(20) {
            report.error(format!(
                "{loc} 已进 en 目录的句子在源码里仍是裸字面量：{text:?}\n                 　　→ 译文躺在目录里但这个调用点永远查不到它（上游换了 sink、rewrite 认不出即此）。\n                 　　修法：① 让 rewrite 认得该 sink（tools/i18n/src/rewrite.rs 的 SINK_CALLS）后重跑 `nova-i18n rewrite`；\n                 　　② 确认该处本就该走反查路径（词池/累加器）→ `nova-i18n lint --update-baseline` 收进基线。"
            ));
        }
        if new_bare.len() > 20 {
            report.error(format!("…… 另有 {} 条同类新增裸英文", new_bare.len() - 20));
        }
    }
    eprintln!(
        "[bare/裸英文] 命中 {} 条（基线 {} 条，新增 {} 条）",
        bare_hits.len(),
        bare_baseline_set.len(),
        new_bare.len()
    );

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
/// C. **悬空 LANG key**：源码里 `LANG("obj.0123456789abcdef")` 而目录里没有这个 key。
///
/// 抽取与改写是**两个独立通道**：改写把字面量换成 LANG(key)，抽取负责把模板写进目录。任何一条
/// 让抽取跳过、而改写不跳过的规则（典型：具名累加器的整句闸——`available_channels += "<li>…</li>"`
/// 过不了句末标点闸，改写却照改不误），都会产出悬空 key。此时 `lang_resolve` 兜底**返回 key 本身**，
/// 玩家在耳机 examine 里看到的就是 `obj.0123456789abcdef` 这串乱码——比不翻译严重得多。
///
/// 一次实测：全仓三万余处 LANG 调用里有 76 个悬空 key（耳机频率表、无人机分发器、血虫技能、
/// 音乐技能芯片、雇佣合同…）。故列为**错误**而非告警：这是坏显示，不是缺翻译。
fn lint_dangling_lang_keys(root: &Path, dme: &Path, catalog_root: &Path, report: &mut Report) {
    let en = load_catalog(&catalog_root.join("en"));
    if en.is_empty() {
        return; // lint_catalog 已就此告警
    }
    let mut dangling: BTreeMap<String, String> = BTreeMap::new();
    let mut scanned = 0usize;
    // 源码根**必须从 .dme 推导**，不能钉死 code/ 与 modular_nova/：`interface/interface.dm`
    // 同样参与编译、同样被 rewrite 改写过，钉死的清单看不见它 —— 实测那里躺着 8 个悬空 key
    // （wiki/rules/forum/github/config 几个 verb 的整句提示），而本规则一直报 0。
    for dir in included_source_roots(dme) {
        collect_dm_files(&root.join(&dir), &mut |path: &Path, text: &str| {
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
    eprintln!(
        "悬空 key 扫描：{scanned} 处 LANG 调用，{} 个悬空。",
        dangling.len()
    );
}

/// 一行里出现的所有 `LANG("<ns>.<16 位十六进制>"` / `LANGU(…, "<key>"` 的 key。
/// 手写扫描而非正则：形态固定，最终校验复用 keys 模块的 v2 合约。
fn code_before_line_comment(line: &str) -> &str {
    let bytes = line.as_bytes();
    let mut in_string = false;
    let mut escaped = false;
    let mut index = 0usize;
    while index < bytes.len() {
        let byte = bytes[index];
        if in_string {
            if escaped {
                escaped = false;
            } else if byte == b'\\' {
                escaped = true;
            } else if byte == b'"' {
                in_string = false;
            }
        } else if byte == b'"' {
            in_string = true;
        } else if byte == b'/' && bytes.get(index + 1) == Some(&b'/') {
            return &line[..index];
        }
        index += 1;
    }
    line
}

fn lang_keys_in_line(line: &str) -> Vec<String> {
    let line = code_before_line_comment(line);
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
    }
    out
}
/// Automatic v2 or stable manual `<namespace>.<identifier>` LANG key.
fn is_catalog_key(s: &str) -> bool {
    if keys::is_v2_key(s) {
        return true;
    }
    let Some((namespace, name)) = s.split_once('.') else {
        return false;
    };
    !namespace.is_empty()
        && !name.is_empty()
        && namespace
            .bytes()
            .all(|byte| byte.is_ascii_lowercase() || byte == b'_')
        && name
            .bytes()
            .all(|byte| byte.is_ascii_lowercase() || byte.is_ascii_digit() || byte == b'_')
}

/// .dme 里 `#include` 到的 .dm 文件所在的顶层目录集合。
///
/// 过近似（按目录而非按文件）是**刻意**的：间接 include 的文件不在 .dme 的扁平清单里，按文件
/// 收口会重新制造盲区，而多扫几个文件对本规则只有成本、没有假阳性。读不到 .dme 时退回历史清单。
fn included_source_roots(dme: &Path) -> BTreeSet<String> {
    let Ok(text) = std::fs::read_to_string(dme) else {
        return ["code".to_owned(), "modular_nova".to_owned()].into();
    };
    let mut roots = BTreeSet::new();
    for line in text.lines() {
        let Some(rest) = line.trim_start().strip_prefix("#include") else {
            continue;
        };
        let Some(open) = rest.find('"') else { continue };
        let Some(close) = rest[open + 1..].find('"') else {
            continue;
        };
        let include = &rest[open + 1..open + 1 + close];
        if !include.ends_with(".dm") {
            continue;
        }
        // DM 的 include 路径用反斜杠。
        let normalized = include.replace('\\', "/");
        let Some((root, _)) = normalized.split_once('/') else {
            continue; // 与 .dme 同级的文件由调用方的根目录遍历覆盖不到，也无需覆盖
        };
        if !root.is_empty() {
            roots.insert(root.to_owned());
        }
    }
    if roots.is_empty() {
        roots.insert("code".to_owned());
        roots.insert("modular_nova".to_owned());
    }
    roots
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
    bare_baseline: Option<PathBuf>,
    update_baseline: bool,
    skip_ast: bool,
) -> Result<()> {
    let mut report = Report::default();
    let domains = CatalogDomains::load(catalog_root)?;

    lint_catalog(catalog_root, locale, &domains, &mut report)?;
    lint_policy(catalog_root, &mut report);
    lint_dangling_lang_keys(Path::new("."), dme, catalog_root, &mut report);
    if !skip_ast {
        lint_identifier_collisions(
            dme,
            catalog_root,
            baseline.as_deref(),
            bare_baseline.as_deref(),
            update_baseline,
            &mut report,
        )?;
    } else {
        eprintln!(
            "[coverage] DM AST/identifier rules: explicitly excluded by --no-ast（exclusions=1；catalog-only lint）"
        );
    }
    if update_baseline && report.errors.is_empty() {
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

#[cfg(test)]
mod tests {
    #[test]
    fn source_roots_come_from_the_dme_not_a_hardcoded_list() {
        let dir = std::env::temp_dir().join(format!("nova-i18n-roots-{}", std::process::id()));
        std::fs::create_dir_all(&dir).unwrap();
        let dme = dir.join("tgstation.dme");
        std::fs::write(
            &dme,
            "#include \"code\\game\\world.dm\"\n\
             #include \"modular_nova\\modules\\i18n\\code\\runtime.dm\"\n\
             #include \"interface\\interface.dm\"\n\
             #include \"interface\\skin.dmf\"\n",
        )
        .unwrap();

        let roots = included_source_roots(&dme);
        // interface/ compiles too; its omission hid eight dangling keys.
        assert!(roots.contains("interface"));
        assert!(roots.contains("code"));
        assert!(roots.contains("modular_nova"));
        // .dmf is not a source file, and each root appears once.
        assert_eq!(roots.len(), 3);

        // An unreadable .dme must not silently scan nothing.
        let missing = included_source_roots(&dir.join("absent.dme"));
        assert!(missing.contains("code") && missing.contains("modular_nova"));
        std::fs::remove_dir_all(&dir).ok();
    }

    use super::*;

    fn entry(domain: &str, key: &str, file: &str, value: &str) -> DomainCatalogEntry {
        DomainCatalogEntry {
            domain: domain.to_owned(),
            key: key.to_owned(),
            file: file.to_owned(),
            value: value.to_owned(),
        }
    }

    #[test]
    fn conflicting_duplicate_reports_both_provenances() {
        let conflicts = duplicate_conflicts([
            entry("forward", "obj.0123456789abcdef", "en/obj.json", "First"),
            entry("forward", "obj.0123456789abcdef", "en/datum.json", "Second"),
        ]);

        assert_eq!(conflicts.len(), 1);
        assert_eq!(conflicts[0].first_file, "en/obj.json");
        assert_eq!(conflicts[0].first_value, "First");
        assert_eq!(conflicts[0].second_file, "en/datum.json");
        assert_eq!(conflicts[0].second_value, "Second");
    }

    #[test]
    fn equal_values_or_different_domains_do_not_conflict() {
        let conflicts = duplicate_conflicts([
            entry("global_reverse", "Shared text", "en/a.json", "Translation"),
            entry("global_reverse", "Shared text", "en/b.json", "Translation"),
            entry("scoped:state", "Shared text", "en/_state.json", "Other"),
        ]);

        assert!(conflicts.is_empty());
    }

    #[test]
    fn dangling_key_scan_ignores_comments_but_not_comment_markers_in_text() {
        let key = "datum.0123456789abcdef";
        assert!(lang_keys_in_line(&format!("// ORIGINAL: LANG(\"{key}\", null)")).is_empty());
        assert_eq!(
            lang_keys_in_line(&format!(
                "to_chat(user, \"https://example/\", LANG(\"{key}\", null))"
            )),
            [key],
        );
        assert_eq!(
            lang_keys_in_line("to_chat(user, LANG(\"datum.lua_disabled\", null))"),
            ["datum.lua_disabled"],
        );
    }
}
