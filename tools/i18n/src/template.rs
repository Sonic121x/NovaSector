//! 占位符模板构建（抽取与改写共用的「唯一真相来源」）。
//!
//! 把一个表达式（字符串/内插串/字符串拼接）转为带 `{0}/{1}` 占位符的模板，
//! 以适配中文语序。抽取算 key 与改写算 key 都调用 [`build_template`]，二者必须
//! 用同一函数才能保证目录命中。

use dm::ast::{BinaryOp, Expression, Term};

/// 把一个表达式（字符串/内插串/字符串拼接）转为带 {0}/{1} 占位符的模板。
/// 非文本（纯变量/调用）返回 None。整体无字母（纯标签/标点）也返回 None。
///
/// 注意：本函数是「抽取 key」与「改写 key」的**唯一真相来源**（rewrite.rs 也调用它），
/// 二者必须用同一函数算 key 才能保证目录命中。
pub(crate) fn build_template(expr: &Expression) -> Option<String> {
    let mut out = String::new();
    let mut idx = 0usize;
    let is_text = render(expr, &mut out, &mut idx);
    // 整体去标签后需含字母，避免把纯标签/纯占位符当作可翻译文本。
    if is_text && strip_tags(&out).chars().any(|c| c.is_alphabetic()) {
        Some(out)
    } else {
        None
    }
}

/// 模板里的占位符个数（{0}/{1}… 顺序生成，这里数 `{` 紧跟数字的出现次数）。
pub(crate) fn placeholder_count(template: &str) -> usize {
    let b = template.as_bytes();
    let mut n = 0usize;
    let mut i = 0usize;
    while i + 1 < b.len() {
        if b[i] == b'{' && b[i + 1].is_ascii_digit() {
            n += 1;
        }
        i += 1;
    }
    n
}

/// 返回该表达式是否为「文本节点」（字符串/内插/字符串相加，含括号包裹）。
/// - 独立字符串字面量：纯标签/纯标点（去标签后无字母）丢弃（如 span 包裹），否则原样写入；
/// - 内插串：lead 与各段字面量**原样**写入（保留 "!" 等标点），内插表达式写成 {N}；
/// - 其余（变量、调用、带 follow 取值等）：在拼接语境里写成 {N} 占位符并返回 false。
fn render(expr: &Expression, out: &mut String, idx: &mut usize) -> bool {
    match expr {
        Expression::Base { term, follow } if follow.is_empty() => match &term.elem {
            Term::String(s) => {
                // 独立字符串：仅当去标签后含字母才保留（丢弃 span 包裹、纯标点独立串）。
                if strip_tags(s).chars().any(|c| c.is_alphabetic()) {
                    out.push_str(s);
                }
                true
            }
            Term::InterpString(lead, parts) => {
                out.push_str(lead.as_str());
                for (opt, lit) in parts.iter() {
                    if opt.is_some() {
                        out.push_str(&format!("{{{}}}", *idx));
                        *idx += 1;
                    }
                    out.push_str(lit);
                }
                true
            }
            // 括号包裹（如 span_* 宏展开为 ("<span>" + str + "</span>")）：穿透进去。
            Term::Expr(inner) => render(inner, out, idx),
            _ => {
                out.push_str(&format!("{{{}}}", *idx));
                *idx += 1;
                false
            }
        },
        Expression::BinaryOp {
            op: BinaryOp::Add,
            lhs,
            rhs,
        } => {
            let l = render(lhs, out, idx);
            let r = render(rhs, out, idx);
            l || r
        }
        _ => {
            out.push_str(&format!("{{{}}}", *idx));
            *idx += 1;
            false
        }
    }
}

/// 去掉 `<...>` 标签后的文本（用于判断片段是否只是标签）。
pub(crate) fn strip_tags(s: &str) -> String {
    let mut result = String::new();
    let mut in_tag = false;
    for c in s.chars() {
        match c {
            '<' => in_tag = true,
            '>' => in_tag = false,
            _ if !in_tag => result.push(c),
            _ => {}
        }
    }
    result
}

/// 一个 `span_*()` 宏展开后的形态：`("<span class='…'>" + 内容 + "</span>")`。
///
/// 判据只看**两端的字面量是不是纯标签**（去标签后无字母），中间是什么都行——内插串、
/// 变量、再套一层 span 都算。这与运行期切块器的判据同源：它也只认标签边界。
fn is_tag_wrapped(expr: &Expression) -> bool {
    let Expression::Base { term, follow } = expr else {
        return false;
    };
    if !follow.is_empty() {
        return false;
    }
    let Term::Expr(inner) = &term.elem else {
        return false;
    };
    let mut leaves = Vec::new();
    flatten_add(inner, &mut leaves);
    let (Some(first), Some(last)) = (leaves.first(), leaves.last()) else {
        return false;
    };
    is_pure_tag(first) && is_pure_tag(last)
}

/// 纯标签字面量：以 `<` 开头，且去掉标签后不含字母。
fn is_pure_tag(expr: &Expression) -> bool {
    let Expression::Base { term, follow } = expr else {
        return false;
    };
    if !follow.is_empty() {
        return false;
    }
    match &term.elem {
        Term::String(s) => {
            s.starts_with('<') && !strip_tags(s).chars().any(|c| c.is_alphabetic())
        }
        _ => false,
    }
}

/// 去掉 DM 的转义对（`\n`、`\t`、`\"`）后是否还含字母。
///
/// 分隔串判定**必须**先剥转义：AST 里的 `"\n"` 是反斜杠加字母 `n` 两个字符，直接看
/// `is_alphabetic` 会把它当成正文，于是「两个标签单元之间夹一个换行」的拼接链拆不开。
fn has_display_letters(s: &str) -> bool {
    let mut chars = s.chars();
    let mut plain = String::new();
    while let Some(c) = chars.next() {
        if c == '\\' {
            chars.next();
            continue;
        }
        plain.push(c);
    }
    strip_tags(&plain).chars().any(|c| c.is_alphabetic())
}

/// 把 `a + b + c` 摊平成操作数序列（只拆顶层 `+`）。
fn flatten_add<'a>(expr: &'a Expression, out: &mut Vec<&'a Expression>) {
    if let Expression::BinaryOp {
        op: BinaryOp::Add,
        lhs,
        rhs,
    } = expr
    {
        flatten_add(lhs, out);
        flatten_add(rhs, out);
    } else {
        out.push(expr);
    }
}

/// 把「若干个各自被标签包住的显示单元拼成一条」的表达式，按**单元**拆成多条模板。
///
/// `to_chat(span_notice("A") + span_boldnotice("B"))` 里 `build_template` 会把两端的
/// span 标签当作「去标签后无字母」丢掉，于是两句折成**一个** key `"AB"`；而运行期
/// `lang_fallback_apply_html` 按标签边界切块，切出来的 `A` 与 `B` 谁都不等于那个 key ——
/// 译文躺在目录里却永远查不到。按操作数拆开抽，两半各自成键，切块后即可精确命中。
///
/// 只在**每个**操作数要么是标签包裹的显示单元、要么是无字母的分隔串（`"\n"`、`" - "`）时
/// 才接管；只要有一个操作数是别的形状（变量、裸句），就交回 `build_template` 折成整条 ——
/// 那种形状运行期本来就不会被切开。
pub(crate) fn build_tag_chunk_templates(expr: &Expression) -> Option<Vec<String>> {
    let mut operands = Vec::new();
    flatten_add(expr, &mut operands);
    if operands.len() < 2 {
        return None;
    }
    let mut chunks = Vec::new();
    for operand in operands {
        if is_tag_wrapped(operand) {
            let template = build_template(operand)?;
            chunks.push(template);
            continue;
        }
        // 分隔串（换行/标点）在运行期不成块，跳过即可；其余形状一律交回整条处理。
        match operand {
            Expression::Base { term, follow } if follow.is_empty() => match &term.elem {
                Term::String(s) if !has_display_letters(s) => continue,
                _ => return None,
            },
            _ => return None,
        }
    }
    if chunks.len() < 2 {
        return None;
    }
    Some(chunks)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn parse(source: &str) -> Expression {
        let context = dm::Context::default();
        let lexer = dm::lexer::Lexer::new(&context, Default::default(), source.as_bytes());
        dm::parser::parse_expression(&context, Default::default(), lexer)
            .expect("expression parses")
    }

    #[test]
    fn tag_wrapped_operands_split_into_one_template_each() {
        // `span_*()` 已被预处理器展开成括号里的三段拼接。
        let expr = parse(
            "(\"<span class='notice'>\" + \"First half. \" + \"</span>\") +              (\"<span class='boldnotice'>\" + \"Second half.\" + \"</span>\")",
        );
        assert_eq!(
            build_tag_chunk_templates(&expr),
            Some(vec!["First half. ".to_owned(), "Second half.".to_owned()])
        );
        // 折成整条的旧形态正是运行期切块后永远查不到的那个 key。
        assert_eq!(
            build_template(&expr).as_deref(),
            Some("First half. Second half.")
        );
    }

    #[test]
    fn a_concatenation_that_is_not_split_at_runtime_stays_one_template() {
        // 裸句 + 变量：运行期不会在这里切块，拆开抽只会产生查不到的半句。
        let expr = parse("\"You have \" + count + \" items\"");
        assert_eq!(build_tag_chunk_templates(&expr), None);
        assert_eq!(build_template(&expr).as_deref(), Some("You have {0} items"));
    }

    #[test]
    fn separators_between_tagged_units_do_not_block_the_split() {
        let expr = parse(
            "(\"<span class='notice'>\" + \"Alpha.\" + \"</span>\") + \"\\n\" +              (\"<span class='notice'>\" + \"Beta.\" + \"</span>\")",
        );
        assert_eq!(
            build_tag_chunk_templates(&expr),
            Some(vec!["Alpha.".to_owned(), "Beta.".to_owned()])
        );
    }
}
