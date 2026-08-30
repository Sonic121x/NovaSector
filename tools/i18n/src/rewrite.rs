//! DM 调用点改写（阶段2，v2：纯字符串 + 内插字符串，统一 LANG）。
//!
//! 把汇聚点调用里「恰好含一个可翻译文本节点」的消息参数原地改写为：
//!   - 无内插：`LANG("key", null)`
//!   - 有内插：`LANG("key", list(<内插表达式源码>...))`
//! key 与抽取阶段一致（同一文本节点 → 同一 namespace+模板内容哈希），故目录已含该 key。
//!
//! 定位与切片：用 AST 文本节点的 Location（指向源码里的开引号——宏展开后 token 位置仍保留）
//! 定位字符串字面量，再用 DM 源码扫描器切出整段字面量与各 `[...]` 内插表达式源码。
//!
//! 统一用全服 locale 的 `LANG`（单语言服与按人 locale 等价，免去切出接收者源码）；定向
//! 的 `LANGU(接收者, …)` 留作手工/后续。
//!
//! 安全约束（面向 CI 自动化，杜绝源码损坏）：
//!   - 仅当消息参数里「可翻译文本节点」恰好 1 个时改写（拼接多段文本一律跳过）；
//!   - 断言 Location 处确为 `"`，否则跳过；字符串扫描不平衡/未闭合则跳过；
//!   - 源码切出的内插数必须与 AST 模板占位符数一致，否则跳过；
//!   - 幂等：已是 LANG(...) 的参数不是字符串字面量，不会被再次改写。

use anyhow::{Context as _, Result};
use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};

use dm::ast::{AssignOp, BinaryOp, Expression, Follow, Spanned, Statement, Term};

use crate::dm_string::{
    find_first_quote, find_open_paren, in_preprocessor_directive, line_col_to_byte,
    logical_line_end, scan_dm_string, split_call_args,
};
use crate::keys::{make_key, namespace_for};
use crate::semantics::{
    block_is_pure, is_announce_sink, is_rewrite_sink, is_wordy_sink, native_dialog_no_usr,
    resolve_sink_arg, sink_message_args,
};
use crate::template::{build_sink_template, build_template, placeholder_count, strip_tags};

/// 核心文件（非 modular_nova）被 codemod 改写时插入的文件级 NOVA EDIT 标记。
const CORE_MARKER: &str =
    "// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md";

struct Edit {
    start: usize,
    end: usize,
    replacement: String,
}

pub fn run(dme: &Path, filter: Option<&str>, dry_run: bool) -> Result<()> {
    let mut context = dm::Context::default();
    context.set_print_severity(Some(dm::Severity::Error));
    let pp = dm::preprocessor::Preprocessor::new(&context, dme.to_path_buf())
        .with_context(|| format!("无法打开 .dme: {}", dme.display()))?;
    let indents = dm::indents::IndentProcessor::new(&context, pp);
    let mut parser = dm::parser::Parser::new(&context, indents);
    parser.enable_procs();
    let (fatal, tree) = parser.parse_object_tree_2();
    if fatal {
        anyhow::bail!("DM 解析出现致命错误");
    }

    let mut rw = Rewriter {
        context: &context,
        filter,
        edits: HashMap::new(),
        cache: HashMap::new(),
        ident_proc: false,
        examine_proc: false,
    };

    // pass 1：收集所有「纯函数」proc 名（SpacemanDMM_should_be_pure）。纯度沿继承传播，
    // 子类型覆盖实现不会重复声明，故按 proc 名跳过（examine_hints 等本就应处处为纯）。
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
    // pass 2：改写（跳过纯函数名的 proc）。
    for ty in tree.iter_types() {
        let ns = namespace_for(&ty.path);
        for (proc_name, type_proc) in ty.procs.iter() {
            if pure_procs.contains(proc_name) {
                continue;
            }
            for proc_value in type_proc.value.iter() {
                if let Some(block) = &proc_value.code {
                    rw.ident_proc = crate::extract::is_identifier_dot_proc(proc_name);
                    rw.examine_proc = crate::extract::is_examine_proc(proc_name);
                    rw.visit_block(block, &ns);
                    // 物种特征(perk) proc：额外把 list 里 SPECIES_PERK_NAME/DESC 的字符串值改写为 LANG，
                    // 让插值描述（[name] livers are…[pct]%）的模板可译（占位符运行时填值；与抽取同名门槛）。
                    if proc_name.contains("perk") {
                        rw.rewrite_perk_block(block, &ns);
                    }
                }
            }
        }
    }

    let mut total = 0usize;
    let mut files = 0usize;
    for (path, mut edits) in rw.edits {
        if edits.is_empty() {
            continue;
        }
        files += 1;
        total += edits.len();
        if dry_run {
            continue;
        }
        let Some(Some(mut src)) = rw.cache.remove(&path) else {
            continue;
        };
        // 按起点降序应用，避免前面的替换使后面的偏移失效。
        edits.sort_by(|a, b| b.start.cmp(&a.start));
        for e in &edits {
            src.replace_range(e.start..e.end, &e.replacement);
        }
        let is_core = !path
            .to_string_lossy()
            .replace('\\', "/")
            .contains("modular_nova/");
        if is_core && !src.starts_with(CORE_MARKER) {
            src.insert_str(0, &format!("{CORE_MARKER}\n"));
        }
        std::fs::write(&path, src).with_context(|| format!("写回失败: {}", path.display()))?;
    }

    eprintln!(
        "改写 {total} 处，{files} 个文件{}",
        if dry_run {
            "（dry-run，未落盘）"
        } else {
            ""
        }
    );
    Ok(())
}

/// verb 命令面板显示名的**编译期**译文注入：把核心安全 verb 的 `set name = "English"` 字面量原地换成
/// `"译文"`（含 ADMIN_VERB 宏的 verb_name 实参）。verb 名是 BYOND 编译期元数据、无法像其它文本那样
/// 运行时按 locale 切换，故此为唯一可行方案（不可 locale 门控）。**只换字面量、不加行内 `//` 注释**
/// （verb 名常是宏实参/行中 token，行内注释会注释掉其后实参/代码 → 致命）；NOVA 标记靠文件级 CORE_MARKER
/// （与 LANG codemod 一致），原文可由 git 历史 / en 目录恢复。
///
/// 仅注入：① is_safe_verb_name 放行的安全显示名（排除 .click/body-chest 等 keybind 按名调用标识符，
/// 改名会断快捷键/宏）；② 目录里已有译文且 zh != en 的项。译文取自 strings/i18n/<locale>/*.json
/// （抽取阶段建 key、MT 翻译）。内容守卫：定位到的源码原文须严格等于 en，防错位/宏展开误改。
pub fn run_verbs(dme: &Path, locale: &str, revert: bool, dry_run: bool) -> Result<()> {
    // 载入译文目录（key -> 译文）。
    let strings_root = dme
        .parent()
        .unwrap_or_else(|| Path::new("."))
        .join("strings/i18n");
    let load_dir = |dir: &Path| -> HashMap<String, String> {
        let mut out = HashMap::new();
        if let Ok(rd) = std::fs::read_dir(dir) {
            for ent in rd.flatten() {
                let p = ent.path();
                if p.extension().and_then(|e| e.to_str()) != Some("json") {
                    continue;
                }
                if let Ok(content) = std::fs::read_to_string(&p) {
                    if let Ok(map) = serde_json::from_str::<HashMap<String, String>>(&content) {
                        out.extend(map);
                    }
                }
            }
        }
        out
    };
    let translations = load_dir(&strings_root.join(locale));
    if translations.is_empty() {
        anyhow::bail!(
            "译文目录为空或不存在: {}（先 extract 抽出 verb 名再翻译）",
            strings_root.join(locale).display()
        );
    }
    // --revert：建「译文 -> 候选英文原文」映射（仅安全 verb 名）。同一译文对应多个英文时
    // （Ghost/Ghosts、T-ray Scan/T-ray scan…）在改写点按命名空间逐点消歧：候选的
    // make_key(ns, en) 必须存在于 en 目录且其译文 == 当前字面量；唯一命中才还原。
    let mut zh2en: HashMap<String, Vec<String>> = HashMap::new();
    let mut english: HashMap<String, String> = HashMap::new();
    if revert {
        english = load_dir(&strings_root.join("en"));
        for (key, en) in &english {
            if !crate::extract::is_safe_verb_name(en) {
                continue;
            }
            let Some(zh) = translations.get(key) else {
                continue;
            };
            if zh == en || zh.is_empty() {
                continue;
            }
            let slot = zh2en.entry(zh.clone()).or_default();
            if !slot.contains(en) {
                slot.push(en.clone());
            }
        }
    }

    let mut context = dm::Context::default();
    context.set_print_severity(Some(dm::Severity::Error));
    let pp = dm::preprocessor::Preprocessor::new(&context, dme.to_path_buf())
        .with_context(|| format!("无法打开 .dme: {}", dme.display()))?;
    let indents = dm::indents::IndentProcessor::new(&context, pp);
    let mut parser = dm::parser::Parser::new(&context, indents);
    parser.enable_procs();
    let (fatal, tree) = parser.parse_object_tree_2();
    if fatal {
        anyhow::bail!("DM 解析出现致命错误");
    }

    let mut edits: HashMap<PathBuf, Vec<Edit>> = HashMap::new();
    let mut sources: HashMap<PathBuf, Option<String>> = HashMap::new();

    for ty in tree.iter_types() {
        let ns = namespace_for(&ty.path);
        for (_proc_name, type_proc) in ty.procs.iter() {
            for proc_value in type_proc.value.iter() {
                let Some(block) = &proc_value.code else {
                    continue;
                };
                for stmt in block.iter() {
                    let Statement::Setting { name, value, .. } = &stmt.elem else {
                        continue;
                    };
                    if name.as_str() != "name" {
                        continue;
                    }
                    // plain_string 回退：`set name = "< Ping >"` 会被 build_template 的 strip_tags
                    // 当 HTML 标签剥光而返回 None（详见 extract::plain_string）。抽取端已放行，
                    // 注入端必须用同一判据，否则这 22 条硅基音效表情抽得到、注不进。
                    let Some(lit) =
                        build_template(value).or_else(|| crate::extract::plain_string(value))
                    else {
                        continue;
                    };
                    // lit = 源码当前字面量。正向：lit 是英文原文，查 key 取译文；
                    // 反向（--revert）：lit 是已注入的译文，查 zh→en 映射还原英文。
                    let target = if revert {
                        let Some(candidates) = zh2en.get(&lit) else {
                            continue;
                        };
                        // 逐点消歧：候选英文按本命名空间算 key，须在 en 目录存在且译文 == 当前字面量。
                        let resolved: Vec<&String> = candidates
                            .iter()
                            .filter(|en| {
                                let key = make_key(&ns, en);
                                english.get(&key).map(String::as_str) == Some(en.as_str())
                                    && translations.get(&key) == Some(&lit)
                            })
                            .collect();
                        match resolved.as_slice() {
                            [only] => (*only).clone(),
                            [] => continue,
                            many => {
                                eprintln!("歧义跳过（{}）: {:?} -> {:?}", ns, lit, many);
                                continue;
                            }
                        }
                    } else {
                        if !crate::extract::is_safe_verb_name(&lit) {
                            continue;
                        }
                        let key = make_key(&ns, &lit);
                        match translations.get(&key) {
                            Some(zh) if zh != &lit && !zh.is_empty() => zh.clone(),
                            _ => continue,
                        }
                    };
                    let loc = match value {
                        Expression::Base { term, follow } if follow.is_empty() => term.location,
                        _ => continue,
                    };
                    let path = context.file_path(loc.file).to_path_buf();
                    let src = sources
                        .entry(path.clone())
                        .or_insert_with(|| std::fs::read_to_string(&path).ok());
                    let Some(src) = src.as_deref() else {
                        continue;
                    };
                    let Some(start) = line_col_to_byte(src, loc.line, loc.column) else {
                        continue;
                    };
                    let line_end = logical_line_end(src, start);
                    let bytes = src.as_bytes();
                    let mut i = start;
                    while i < line_end && bytes[i] != b'"' {
                        i += 1;
                    }
                    if i >= line_end {
                        continue;
                    }
                    let Some((qpos, qend, interp)) = scan_dm_string(src, i) else {
                        continue;
                    };
                    if !interp.is_empty() || in_preprocessor_directive(src, qpos) {
                        continue;
                    }
                    // 内容守卫：源码原文须严格等于当前字面量，否则跳过（防错位/宏）。
                    if qend < qpos + 2 || src[qpos + 1..qend - 1] != *lit {
                        continue;
                    }
                    let target_esc = target.replace('\\', "\\\\").replace('"', "\\\"");
                    // 只替换字面量本身、不加行内 `//` 注释：verb 名可能是宏实参（ADMIN_VERB 的
                    // verb_name）或行中 token，行内 `//` 会注释掉其后的实参/代码（致命）。NOVA 标记
                    // 靠文件级 CORE_MARKER（与 LANG codemod 一致）；原文可由 git 历史 / en 目录恢复。
                    let replacement = format!("\"{target_esc}\"");
                    edits.entry(path).or_default().push(Edit {
                        start: qpos,
                        end: qend,
                        replacement,
                    });
                }
            }
        }
    }

    let mut total = 0usize;
    let mut files = 0usize;
    for (path, mut es) in edits {
        if es.is_empty() {
            continue;
        }
        es.sort_by(|a, b| b.start.cmp(&a.start));
        es.dedup_by(|a, b| a.start == b.start && a.end == b.end);
        files += 1;
        total += es.len();
        if dry_run {
            continue;
        }
        let Some(Some(mut src)) = sources.remove(&path) else {
            continue;
        };
        for e in &es {
            src.replace_range(e.start..e.end, &e.replacement);
        }
        let is_core = !path
            .to_string_lossy()
            .replace('\\', "/")
            .contains("modular_nova/");
        if is_core && !src.starts_with(CORE_MARKER) {
            src.insert_str(0, &format!("{CORE_MARKER}\n"));
        }
        std::fs::write(&path, src).with_context(|| format!("写回失败: {}", path.display()))?;
    }

    eprintln!(
        "verb 注入 {total} 处，{files} 个文件{}",
        if dry_run {
            "（dry-run，未落盘）"
        } else {
            ""
        }
    );
    Ok(())
}

struct Rewriter<'a> {
    context: &'a dm::Context,
    filter: Option<&'a str>,
    edits: HashMap<PathBuf, Vec<Edit>>,
    cache: HashMap<PathBuf, Option<String>>,
    /// 当前 proc 是否为「标识符构建 proc」（update_overlays 等，见 extract::is_identifier_dot_proc）：
    /// 其 bare-`.` 累加是 icon_state/日志串而非玩家文本，禁止改写为 LANG。
    ident_proc: bool,
    /// 当前 proc 是否为 examine 家族（见 extract::is_examine_proc）：体内**任何**具名累加器
    /// 收到的字面量都是 examine 输出，与白名单累加器同等改写为 LANG。
    examine_proc: bool,
}

impl<'a> Rewriter<'a> {
    fn source(&mut self, path: &Path) -> Option<&str> {
        // 单测文件永不改写：断言依赖英文字面量语义（如 say("*shrug") 的 emote 调用），
        // 改成 LANG 会在 locale≠en 下破坏测试甚至改变被测行为。extract 侧同有抑制。
        if path.to_string_lossy().contains("modules/unit_tests") {
            return None;
        }
        let entry = self
            .cache
            .entry(path.to_path_buf())
            .or_insert_with(|| std::fs::read_to_string(path).ok());
        entry.as_deref()
    }

    fn visit_block(&mut self, block: &[Spanned<Statement>], ns: &str) {
        for stmt in block.iter() {
            self.visit_stmt(&stmt.elem, ns);
        }
    }

    fn visit_stmt(&mut self, stmt: &Statement, ns: &str) {
        match stmt {
            Statement::Expr(e) => self.visit_expr(e, ns),
            Statement::Return(Some(e)) => self.visit_expr(e, ns),
            Statement::While { condition, block } => {
                self.visit_expr(condition, ns);
                self.visit_block(block, ns);
            }
            Statement::If { arms, else_arm } => {
                for (cond, blk) in arms.iter() {
                    self.visit_expr(&cond.elem, ns);
                    self.visit_block(blk, ns);
                }
                if let Some(blk) = else_arm {
                    self.visit_block(blk, ns);
                }
            }
            Statement::ForInfinite { block } => self.visit_block(block, ns),
            Statement::ForLoop {
                init,
                test,
                inc,
                block,
            } => {
                if let Some(s) = init {
                    self.visit_stmt(s, ns);
                }
                if let Some(e) = test {
                    self.visit_expr(e, ns);
                }
                if let Some(s) = inc {
                    self.visit_stmt(s, ns);
                }
                self.visit_block(block, ns);
            }
            Statement::Switch {
                input,
                cases,
                default,
            } => {
                self.visit_expr(input, ns);
                // 修复：之前 `..` 漏掉了 cases —— switch 各 case 分支体里的语句全部没被改写。
                for (_case_conditions, blk) in cases.iter() {
                    self.visit_block(blk, ns);
                }
                if let Some(blk) = default {
                    self.visit_block(blk, ns);
                }
            }
            Statement::Spawn { delay, block } => {
                if let Some(e) = delay {
                    self.visit_expr(e, ns);
                }
                self.visit_block(block, ns);
            }
            Statement::Var(v) => {
                if let Some(e) = &v.value {
                    self.visit_expr(e, ns);
                }
            }
            Statement::Vars(vs) => {
                for v in vs.iter() {
                    if let Some(e) = &v.value {
                        self.visit_expr(e, ns);
                    }
                }
            }
            Statement::Setting { value, .. } => self.visit_expr(value, ns),
            // 以下分支此前全落进 `_ => {}`：**for-in / for-in-range / do-while / try-catch / 带标签块
            // 的整个循环体一处都没被改写过**（extract.rs 早已补齐同样的分支，rewrite 漏修至今）。
            // `for(var/mob/M in viewers)` 里的 to_chat/visible_message 是最常见的形态之一。
            Statement::DoWhile { block, condition } => {
                self.visit_block(block, ns);
                self.visit_expr(&condition.elem, ns);
            }
            Statement::ForList(f) => {
                if let Some(e) = &f.in_list {
                    self.visit_expr(e, ns);
                }
                self.visit_block(&f.block, ns);
            }
            Statement::ForKeyValue(f) => {
                if let Some(e) = &f.in_list {
                    self.visit_expr(e, ns);
                }
                self.visit_block(&f.block, ns);
            }
            Statement::ForRange(f) => {
                self.visit_expr(&f.start, ns);
                self.visit_expr(&f.end, ns);
                if let Some(e) = &f.step {
                    self.visit_expr(e, ns);
                }
                self.visit_block(&f.block, ns);
            }
            Statement::TryCatch {
                try_block,
                catch_block,
                ..
            } => {
                self.visit_block(try_block, ns);
                self.visit_block(catch_block, ns);
            }
            Statement::Label { block, .. } => self.visit_block(block, ns),
            _ => {}
        }
    }

    fn visit_expr(&mut self, expr: &Expression, ns: &str) {
        if let Expression::Base { term, follow } = expr {
            if let Term::Call(name, args) = &term.elem {
                if is_rewrite_sink(name.as_str()) {
                    if let Some(indices) = sink_message_args(name.as_str()) {
                        self.try_rewrite_call(
                            term.location,
                            args,
                            indices,
                            ns,
                            is_announce_sink(name.as_str()),
                            is_wordy_sink(name.as_str()),
                            name.as_str(),
                        );
                    }
                }
            }
            // input() 是 dreammaker 的专用 Term::Input（因 `as type in list` 语法），不是 Call。
            // 复用同一套实参定位（term.location 指向 input 关键字，find_open_paren 找其 `(`）。
            if let Term::Input { args, .. } = &term.elem {
                if let Some(indices) = sink_message_args("input") {
                    self.try_rewrite_call(term.location, args, indices, ns, false, false, "input");
                }
            }
            self.recurse_term(&term.elem, ns);
            for f in follow.iter() {
                // 方法调用形式的汇聚点（`X.visible_message(...)` 等）：用 follow 自身的 Location 定位、
                // 改写消息参数。裸调用走上面的 Term::Call 分支；方法调用是 Follow::Call，此前完全漏改。
                if let Follow::Call(_, name, fargs) = &f.elem {
                    if is_rewrite_sink(name.as_str()) {
                        if let Some(indices) = sink_message_args(name.as_str()) {
                            self.try_rewrite_call(
                                f.location,
                                fargs,
                                indices,
                                ns,
                                is_announce_sink(name.as_str()),
                                is_wordy_sink(name.as_str()),
                                name.as_str(),
                            );
                        }
                    }
                }
                self.recurse_follow(&f.elem, ns);
            }
            return;
        }
        match expr {
            Expression::AssignOp { op, lhs, rhs } => {
                // examine 文本：裸 `.`，以及 examine 信号处理器的累加器（examine_list/text/strings +=，
                // COMSIG_ATOM_EXAMINE 的输出参数，必玩家可见）。
                if matches!(op, AssignOp::AddAssign) {
                    if let Expression::Base { term, follow } = lhs.as_ref() {
                        if follow.is_empty() {
                            if let Term::Ident(id) = &term.elem {
                                if (id == "." && !self.ident_proc)
                                    || crate::extract::is_examine_accumulator(id)
                                    || self.examine_proc
                                {
                                    // examine proc 的具名累加器：抽取侧只收整句（见
                                    // extract::is_examine_sentence），改写侧不必再判——
                                    // try_rewrite_examine 查不到目录 key 就不动。
                                    self.try_rewrite_examine(term.location, id, rhs, ns);
                                }
                            }
                        }
                    }
                }
                // proc 内运行期 `desc = "<字面量>"`：插值 desc 在 examine 显示点反查够不着（整串非目录键）→
                // 改 LANG（与 extract 同条件）。复用 examine 改写器：anchor="desc",找其后唯一字符串字面量。
                // 仅 desc（display-only）；不动 name（避免破坏 `if(name=="…")` 比较）。
                else if matches!(op, AssignOp::Assign) {
                    if let Expression::Base { term, follow } = lhs.as_ref() {
                        if follow.is_empty() {
                            if let Term::Ident(id) = &term.elem {
                                if id == "desc" {
                                    self.try_rewrite_examine(term.location, id, rhs, ns);
                                }
                            }
                        }
                    }
                }
                self.visit_expr(lhs, ns);
                self.visit_expr(rhs, ns);
            }
            Expression::BinaryOp { lhs, rhs, .. } => {
                self.visit_expr(lhs, ns);
                self.visit_expr(rhs, ns);
            }
            Expression::TernaryOp {
                cond, if_, else_, ..
            } => {
                self.visit_expr(cond, ns);
                self.visit_expr(if_, ns);
                self.visit_expr(else_, ns);
            }
            _ => {}
        }
    }

    /// 改写一个汇聚点调用的各消息参数。
    ///
    /// 关键：用「调用」的 Location（调用点，可靠）定位，再从源码切出实参、找到其中的字符串
    /// 字面量并替换。这样对 span_*() 这类「宏展开后内层串位置指向宏定义」的情形也能正确改写
    /// （宏展开后内层文本节点的 Location 不可用于回写）。
    fn try_rewrite_call(
        &mut self,
        call_loc: dm::Location,
        args: &[Expression],
        indices: &[usize],
        ns: &str,
        interp_only: bool,
        wordy_only: bool,
        sink: &str,
    ) {
        // 原生 alert/input 的 [2]：有 usr 时是标题（该译），无 usr 时是按钮/默认值（绝不能译）。
        let no_usr_form = native_dialog_no_usr(sink, args);
        // 1) 用 AST 判定每个消息参数是否「恰好一个可翻译文本节点」，并取其模板/占位符数/key。
        let mut targets: Vec<(usize, String, usize)> = Vec::new();
        for &i in indices {
            if no_usr_form && i == 2 {
                continue;
            }
            // Named arguments resolve through the same semantic helper as extraction. The returned
            // slot remains the physical source slot used by the string rewriter.
            let Some((slot, arg)) = resolve_sink_arg(sink, i, args) else {
                continue;
            };
            // 门槛：源码里恰好一个可翻译字符串字面量（保证后面切片定位无歧义）。
            let mut nodes: Vec<&Spanned<Term>> = Vec::new();
            collect_text_nodes(arg, &mut nodes);
            if nodes.len() != 1 {
                continue;
            }
            // key 用与抽取**同一**函数计算，保证目录命中。
            let Some(template) = build_sink_template(arg) else {
                continue;
            };
            // 对话框按钮（Yes/No/Cancel…）绝不改写——它们是 `if(alert(...)=="Yes")` 的比较值，
            // 改成 LANG 会破坏比较逻辑（且 alert 空标题时按钮易被错位套用，见下方空实参对齐）。
            if is_dialog_button(&template) {
                continue;
            }
            // `*` 开头是 emote 调用语法（say("*shrug") 触发表情而非说话）——改写成 LANG 后
            // locale≠en 返回译文，emote 解析必失败。此类串留给运行时反查翻显示。
            if template.starts_with('*') {
                continue;
            }
            // 多词闸门（is_wordy_sink）：去掉占位符后仍须含空格，挡掉 `speak("unstun")` 这类 switch 键。
            if wordy_only {
                let bare = template.replace(|c: char| c == '{' || c == '}', " ");
                if !bare.trim().contains(' ') {
                    continue;
                }
            }
            let ph = placeholder_count(&template);
            // 公告类：非插值（ph==0）留给运行时整串反查，不改写（零额外 churn）；只改插值公告（反查/AC 够不着）。
            if interp_only && ph == 0 {
                continue;
            }
            targets.push((slot, make_key(ns, &template), ph));
        }
        if targets.is_empty() {
            return;
        }

        // 2) 用调用点 Location 在源码里切出实参范围。
        let path = self.context.file_path(call_loc.file).to_path_buf();
        if let Some(filter) = self.filter {
            if !path.to_string_lossy().contains(filter) {
                return;
            }
        }
        let Some(src) = self.source(&path) else {
            return;
        };
        let Some(name_start) = line_col_to_byte(src, call_loc.line, call_loc.column) else {
            return;
        };
        let Some(lparen) = find_open_paren(src, name_start) else {
            return;
        };
        let Some(mut arg_ranges) = split_call_args(src, lparen) else {
            return;
        };
        // **尾逗号**（多行调用的 `f(\n\ta,\n\tb,\n)` 收尾风格，上游 tgstation 大量使用）：源码切分会在
        // 最后一个逗号与 `)` 之间多切出一个空范围，而 AST 里没有它。它在**末尾**，不会让前面任何实参的
        // 下标错位 —— 直接丢弃即可。不丢的话会被下面的空实参守卫当成 `f(a,,b)` 而整调用跳过，这正是
        // 2026-07-30 上游同步后 40 余处 visible_message/to_chat 再也改写不回来的原因（rewrite 全仓 0 处）。
        if arg_ranges
            .last()
            .is_some_and(|&(s, e)| src[s..e].trim().is_empty())
        {
            arg_ranges.pop();
        }
        // 空实参守卫：dreammaker 的 AST **丢弃** `f(a,,b)` 里的空实参，但按源码逗号切分会**保留**空范围
        // → AST 下标与源码范围下标错位，目标会套用到相邻的错误实参（典型：alert 空标题 `,,` 致按钮被当
        // 消息改写，重跑还层层套 LANG）。**中间**的空实参才会错位，仍整调用跳过——宁可不译也不改坏。
        if arg_ranges.iter().any(|&(s, e)| src[s..e].trim().is_empty()) {
            return;
        }

        // 3) 对每个目标实参，找到其中唯一的字符串字面量并替换。
        let mut new_edits: Vec<Edit> = Vec::new();
        for (i, key, placeholders) in targets {
            let Some(&(astart, aend)) = arg_ranges.get(i) else {
                continue;
            };
            let Some(qpos) = find_first_quote(src, astart, aend) else {
                continue;
            };
            let Some((lstart, qend, interp_args)) = scan_dm_string(src, qpos) else {
                continue;
            };
            if qend > aend || interp_args.len() != placeholders {
                continue; // 越界 / 内插数不符 → 跳过
            }
            if in_preprocessor_directive(src, lstart) {
                continue; // 字符串在 #define 等预处理指令里（宏体）→ 跳过，避免破坏宏
            }
            let replacement = if interp_args.is_empty() {
                format!("LANG(\"{key}\", null)")
            } else {
                format!("LANG(\"{key}\", list({}))", interp_args.join(", "))
            };
            new_edits.push(Edit {
                start: lstart,
                end: qend,
                replacement,
            });
        }
        if !new_edits.is_empty() {
            self.edits.entry(path).or_default().extend(new_edits);
        }
    }

    /// 改写 examine 的 `. += <text>`。以「裸 `.` 的 Location」为锚（调用点级、可靠），在 rhs
    /// 源码里查找字符串字面量。覆盖裸串与 span_*() 包裹两种（span 包裹后内层串自身 Location
    /// 指向宏定义、不可用，故必须从 `.` 锚 + 源码扫描）。
    ///
    /// 安全：要求 rhs 源码里**恰好一个**顶层字符串字面量（span_notice("x") 满足；
    /// 形如 `foo("x") + "y"` 的有两个 → 跳过，避免改错那一个）。
    fn try_rewrite_examine(
        &mut self,
        dot_loc: dm::Location,
        anchor: &str,
        rhs: &Expression,
        ns: &str,
    ) {
        let mut nodes: Vec<&Spanned<Term>> = Vec::new();
        collect_text_nodes(rhs, &mut nodes);
        if nodes.len() != 1 {
            return;
        }
        let Some(template) = build_template(rhs) else {
            return;
        };
        let key = make_key(ns, &template);
        let placeholders = placeholder_count(&template);

        let path = self.context.file_path(dot_loc.file).to_path_buf();
        if let Some(filter) = self.filter {
            if !path.to_string_lossy().contains(filter) {
                return;
            }
        }
        let Some(src) = self.source(&path) else {
            return;
        };
        let Some(dot_start) = line_col_to_byte(src, dot_loc.line, dot_loc.column) else {
            return;
        };
        if !src.as_bytes()[dot_start..].starts_with(anchor.as_bytes()) {
            return; // 锚与 LHS 标识符（`.` 或 examine_list 等）不符 → 定位有误，跳过
        }
        let line_end = logical_line_end(src, dot_start);

        // 在标识符之后、line_end 内找顶层字符串字面量；要求恰好一个。
        let bytes = src.as_bytes();
        let mut first: Option<(usize, usize, Vec<String>)> = None;
        let mut count = 0usize;
        let mut i = dot_start + anchor.len();
        while i < line_end {
            if bytes[i] == b'"' {
                let Some((lstart, end, args)) = scan_dm_string(src, i) else {
                    return; // 畸形字符串 → 跳过
                };
                count += 1;
                if first.is_none() {
                    first = Some((lstart, end, args));
                }
                i = end;
            } else {
                i += 1;
            }
        }
        if count != 1 {
            return; // 0 个或多个（有歧义）→ 跳过
        }
        let (qpos, qend, interp_args) = first.unwrap();
        if interp_args.len() != placeholders || in_preprocessor_directive(src, qpos) {
            return;
        }
        let replacement = if interp_args.is_empty() {
            format!("LANG(\"{key}\", null)")
        } else {
            format!("LANG(\"{key}\", list({}))", interp_args.join(", "))
        };
        self.edits.entry(path).or_default().push(Edit {
            start: qpos,
            end: qend,
            replacement,
        });
    }

    /// 物种特征(perk)：走 list 字面量，把 key 为 name/description（SPECIES_PERK_NAME/DESC 宏）的
    /// 字符串值改写为 LANG。穿过嵌套 list / `+=` / 赋值。仅改**单一字符串字面量**值
    /// （collect_text_nodes==1）；变量/拼接名（如 `perk_name` 变量、`"A " + b`）安全跳过。
    fn rewrite_perk_block(&mut self, block: &[Spanned<Statement>], ns: &str) {
        for stmt in block.iter() {
            match &stmt.elem {
                Statement::Expr(e) | Statement::Return(Some(e)) => self.rewrite_perk_expr(e, ns),
                Statement::Var(v) => {
                    if let Some(e) = &v.value {
                        self.rewrite_perk_expr(e, ns);
                    }
                }
                Statement::Vars(vs) => {
                    for v in vs.iter() {
                        if let Some(e) = &v.value {
                            self.rewrite_perk_expr(e, ns);
                        }
                    }
                }
                Statement::If { arms, else_arm } => {
                    for (_c, blk) in arms.iter() {
                        self.rewrite_perk_block(blk, ns);
                    }
                    if let Some(blk) = else_arm {
                        self.rewrite_perk_block(blk, ns);
                    }
                }
                Statement::Switch { cases, default, .. } => {
                    for (_c, blk) in cases.iter() {
                        self.rewrite_perk_block(blk, ns);
                    }
                    if let Some(blk) = default {
                        self.rewrite_perk_block(blk, ns);
                    }
                }
                Statement::While { block, .. }
                | Statement::ForInfinite { block }
                | Statement::ForLoop { block, .. }
                | Statement::Spawn { block, .. } => self.rewrite_perk_block(block, ns),
                _ => {}
            }
        }
    }

    fn rewrite_perk_expr(&mut self, expr: &Expression, ns: &str) {
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
                            self.try_rewrite_perk(rhs, ns);
                        }
                        self.rewrite_perk_expr(rhs, ns);
                    } else {
                        self.rewrite_perk_expr(arg, ns);
                    }
                }
            }
            Expression::AssignOp { rhs, .. } => self.rewrite_perk_expr(rhs, ns),
            Expression::BinaryOp { lhs, rhs, .. } => {
                self.rewrite_perk_expr(lhs, ns);
                self.rewrite_perk_expr(rhs, ns);
            }
            _ => {}
        }
    }

    /// 用 rhs 字符串字面量自身的 Location 定位、改写为 LANG（perk 值非 sink 调用、key 又是宏，
    /// 不能用 call/anchor 定位）。仅当 rhs 恰好一个文本节点（裸串/插值串）时改。
    fn try_rewrite_perk(&mut self, rhs: &Expression, ns: &str) {
        let mut nodes: Vec<&Spanned<Term>> = Vec::new();
        collect_text_nodes(rhs, &mut nodes);
        if nodes.len() != 1 {
            return;
        }
        let Some(template) = build_template(rhs) else {
            return;
        };
        let key = make_key(ns, &template);
        let placeholders = placeholder_count(&template);
        let loc = match rhs {
            Expression::Base { term, follow } if follow.is_empty() => term.location,
            _ => return,
        };
        let path = self.context.file_path(loc.file).to_path_buf();
        if let Some(filter) = self.filter {
            if !path.to_string_lossy().contains(filter) {
                return;
            }
        }
        let Some(src) = self.source(&path) else {
            return;
        };
        let Some(start) = line_col_to_byte(src, loc.line, loc.column) else {
            return;
        };
        // 从 rhs 起点起、本逻辑行内找第一个字符串字面量的开引号。
        let line_end = logical_line_end(src, start);
        let bytes = src.as_bytes();
        let mut i = start;
        while i < line_end && bytes[i] != b'"' {
            i += 1;
        }
        if i >= line_end {
            return;
        }
        let Some((qpos, qend, interp_args)) = scan_dm_string(src, i) else {
            return;
        };
        if interp_args.len() != placeholders || in_preprocessor_directive(src, qpos) {
            return;
        }
        let replacement = if interp_args.is_empty() {
            format!("LANG(\"{key}\", null)")
        } else {
            format!("LANG(\"{key}\", list({}))", interp_args.join(", "))
        };
        self.edits.entry(path).or_default().push(Edit {
            start: qpos,
            end: qend,
            replacement,
        });
    }

    fn recurse_term(&mut self, term: &Term, ns: &str) {
        match term {
            Term::Expr(e) => self.visit_expr(e, ns),
            // pick() 是独立 AST 节点（权重语法 `pick(50;"a", 50;"b")`），不是 Term::Call。
            // extract 早已下探这一支；rewrite 漏了就会出现「目录有译文、源码仍裸字面量」。
            // 只保证 visit 到权重/值表达式。能否改写仍由「恰好一个文本节点」等既有 sink 规则决定；
            // Pick 本身不是文本节点（见 collect_text_nodes）。
            Term::Pick(args) => {
                visit_pick_payload(args, |e| self.visit_expr(e, ns));
            }
            Term::InterpString(_, parts) => {
                for (opt, _) in parts.iter() {
                    if let Some(e) = opt {
                        self.visit_expr(e, ns);
                    }
                }
            }
            Term::Call(_, args)
            | Term::SelfCall(args)
            | Term::ParentCall(args)
            | Term::List(args)
            | Term::GlobalCall(_, args) => {
                for a in args.iter() {
                    self.visit_expr(a, ns);
                }
            }
            Term::DynamicCall(a, b) => {
                for e in a.iter() {
                    self.visit_expr(e, ns);
                }
                for e in b.iter() {
                    self.visit_expr(e, ns);
                }
            }
            Term::NewImplicit { args }
            | Term::NewPrefab { args, .. }
            | Term::NewMiniExpr { args, .. } => {
                if let Some(args) = args {
                    for e in args.iter() {
                        self.visit_expr(e, ns);
                    }
                }
            }
            Term::Input { args, in_list, .. } => {
                for e in args.iter() {
                    self.visit_expr(e, ns);
                }
                if let Some(e) = in_list {
                    self.visit_expr(e, ns);
                }
            }
            Term::Locate { args, in_list } => {
                for e in args.iter() {
                    self.visit_expr(e, ns);
                }
                if let Some(e) = in_list {
                    self.visit_expr(e, ns);
                }
            }
            Term::ExternalCall {
                library,
                function,
                args,
            } => {
                if let Some(e) = library {
                    self.visit_expr(e, ns);
                }
                self.visit_expr(function, ns);
                for e in args.iter() {
                    self.visit_expr(e, ns);
                }
            }
            _ => {}
        }
    }

    fn recurse_follow(&mut self, follow: &Follow, ns: &str) {
        match follow {
            Follow::Index(_, e) => self.visit_expr(e, ns),
            Follow::Call(_, _, args) => {
                for a in args.iter() {
                    self.visit_expr(a, ns);
                }
            }
            _ => {}
        }
    }
}

/// 遍历 `Term::Pick` 的每个权重表达式与值表达式。与 extract::recurse_term 的 Pick 支同构。
fn visit_pick_payload(
    args: &[(Option<Expression>, Expression)],
    mut visit: impl FnMut(&Expression),
) {
    for (weight, value) in args.iter() {
        if let Some(w) = weight {
            visit(w);
        }
        visit(value);
    }
}

/// 收集消息参数里的「可翻译文本节点」（String / InterpString，过滤纯标签），降序穿过 `+` 拼接。
/// 无歧义的对话框按钮/比较值字面量——绝不改写为 LANG（否则破坏 `if(alert(...)=="Yes")` 之类比较，
/// 且无 usr 的 alert `alert(msg,title,"Yes")` 的 [2] 按钮易被当标题改写）。仅取**几乎只做按钮**的词；
/// 像 Confirm/Apply/Save 等常作标题/表头，**不**列入（应可译）。仅匹配整串恰好等于这些词的实参。
fn is_dialog_button(template: &str) -> bool {
    matches!(
        template.trim(),
        "Yes" | "No" | "Cancel" | "Ok" | "OK" | "Okay" | "Yes!" | "Nope" | "No!"
    )
}

fn collect_text_nodes<'b>(expr: &'b Expression, out: &mut Vec<&'b Spanned<Term>>) {
    match expr {
        Expression::Base { term, follow } if follow.is_empty() => match &term.elem {
            Term::String(_) | Term::InterpString(_, _) => {
                if node_template(&term.elem).is_some() {
                    out.push(term.as_ref());
                }
            }
            // 括号包裹（如 span_* 宏展开为 ("<span>" + str + "</span>")）：穿透进去。
            Term::Expr(inner) => collect_text_nodes(inner, out),
            _ => {}
        },
        Expression::BinaryOp {
            op: BinaryOp::Add,
            lhs,
            rhs,
        } => {
            collect_text_nodes(lhs, out);
            collect_text_nodes(rhs, out);
        }
        _ => {}
    }
}

/// 单个文本节点的模板（{0}/{1}…）与占位符个数；纯标签/无字母返回 None。
/// 与 extract.rs 的 build_template 对单节点结果一致（保证 key 匹配）。
fn node_template(term: &Term) -> Option<(String, usize)> {
    match term {
        Term::String(s) => {
            if !strip_tags(s).chars().any(|c| c.is_alphabetic()) {
                return None;
            }
            Some((s.clone(), 0))
        }
        Term::InterpString(lead, parts) => {
            let mut out = String::new();
            let mut count = 0usize;
            out.push_str(lead.as_str());
            for (opt, lit) in parts.iter() {
                if opt.is_some() {
                    out.push_str(&format!("{{{}}}", count));
                    count += 1;
                }
                out.push_str(lit);
            }
            // 纯占位符框架（`"[施动者] [动词] [受动者]!"`）也要认，判据与
            // `template::build_sink_template` 一致（≥3 个槽）：框架本身没有可翻的字面文本，
            // 但只有把这条调用改成 LANG，实参才走得到 `lang_localize_arg`，中文也才有办法
            // 丢掉英文复数槽 / 调换语序。两处闸门必须同口径，否则 key 对不上。
            if count < 3 && !strip_tags(&out).chars().any(|c| c.is_alphabetic()) {
                return None;
            }
            Some((out, count))
        }
        _ => None,
    }
}

#[cfg(test)]
mod pick_walk {
    use super::*;

    fn text(value: &str) -> Expression {
        Expression::from(Term::String(value.to_string()))
    }

    #[test]
    fn pick_payload_visits_weights_and_values() {
        let args: Box<[(Option<Expression>, Expression)]> = vec![
            (
                Some(Expression::from(Term::Int(50))),
                text("You feel pumped!"),
            ),
            (None, text("You feel tired.")),
        ]
        .into_boxed_slice();
        let mut n = 0;
        visit_pick_payload(&args, |_| n += 1);
        assert_eq!(n, 3, "two values + one weight");

        let mut texts = Vec::new();
        visit_pick_payload(&args, |e| {
            if let Some(t) = build_template(e) {
                texts.push(t);
            }
        });
        assert_eq!(texts, vec!["You feel pumped!", "You feel tired."]);
    }

    /// Pick 本身不是「恰好一个文本节点」：sink 改写门槛不因这次下探而放宽。
    #[test]
    fn pick_is_not_a_single_text_node() {
        let pick = Expression::from(Term::Pick(
            vec![
                (None, text("You feel pumped!")),
                (None, text("You feel tired.")),
            ]
            .into_boxed_slice(),
        ));
        let mut nodes = Vec::new();
        collect_text_nodes(&pick, &mut nodes);
        assert!(
            nodes.is_empty(),
            "rewrite must still require a single String/InterpString node"
        );
    }
}
