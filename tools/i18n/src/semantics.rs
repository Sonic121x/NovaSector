//! DM i18n extraction/rewrite shared semantic rules.
//!
//! Every sink signature and safety classification lives here so extraction cannot emit a key that
//! rewriting interprets differently (or vice versa).

use dm::ast::{AssignOp, Expression, Spanned, Statement, Term};

use crate::template::build_template;

/// Player-visible message argument indices for a sink.
///
/// `display_results` and `display_pain` are intentionally extraction-only: their rendered output is
/// translated by the runtime template matcher and must not be codemodded to `LANG` at the callsite.
pub fn sink_message_args(name: &str) -> Option<&'static [usize]> {
    match name {
        "to_chat" => Some(&[1]),
        "balloon_alert" => Some(&[1]),
        "balloon_alert_to_viewers" | "balloon_alert_to_hearers" => Some(&[0, 1]),
        "visible_message" => Some(&[0, 1, 2]),
        "audible_message" => Some(&[0, 1, 3]),
        "say" | "manual_emote" => Some(&[0]),
        "alert" | "input" => Some(&[0, 1, 2]),
        "tgui_alert" | "tgui_input_list" | "tgui_input_text" | "tgui_input_number" => Some(&[1, 2]),
        "priority_announce" | "minor_announce" | "print_command_report" => Some(&[0, 1]),
        "bank_card_talk" | "notify_ghosts" | "add_raw_text" | "speak" => Some(&[0]),
        "talk_into" => Some(&[1]),
        "display_results" => Some(&[2, 3, 4]),
        "display_pain" => Some(&[1]),
        _ => None,
    }
}

/// Whether a shared sink is safe for source rewriting rather than extraction only.
pub fn is_rewrite_sink(name: &str) -> bool {
    sink_message_args(name).is_some() && !matches!(name, "display_results" | "display_pain")
}

/// Parameter names corresponding to message indices, used to resolve named DM arguments.
pub fn sink_arg_name(sink: &str, idx: usize) -> Option<&'static str> {
    let names: &[(usize, &'static str)] = match sink {
        "priority_announce" => &[(0, "text"), (1, "title")],
        "minor_announce" => &[(0, "message"), (1, "title")],
        "print_command_report" => &[(0, "text"), (1, "title")],
        "to_chat" => &[(1, "message")],
        "balloon_alert" => &[(1, "text")],
        "visible_message" => &[(0, "message"), (1, "self_message"), (2, "blind_message")],
        "audible_message" => &[(0, "message"), (1, "self_message"), (3, "deaf_message")],
        "notify_ghosts" => &[(0, "title")],
        // 具名实参形态 `tgui_input_list(user, message = "Select an ability", title = "…", items = …)`：
        // 少了这张表，按位取参会落到 `items = …` 上、整条提示语一个字都抽不到，且 rewrite 同样
        // 跳过。比特跑者磁盘的「Select an ability」就是这么漏的。
        "tgui_alert" | "tgui_input_list" | "tgui_input_text" | "tgui_input_number" => {
            &[(1, "message"), (2, "title")]
        }
        _ => return None,
    };
    names.iter().find(|(i, _)| *i == idx).map(|(_, name)| *name)
}

/// Return the name of a DM named argument (`name = value`), if this expression is one.
pub fn keyword_arg_name(arg: &Expression) -> Option<&str> {
    let Expression::AssignOp {
        op: AssignOp::Assign,
        lhs,
        ..
    } = arg
    else {
        return None;
    };
    let Expression::Base { term, follow } = lhs.as_ref() else {
        return None;
    };
    if !follow.is_empty() {
        return None;
    }
    match &term.elem {
        Term::Ident(name) => Some(name.as_str()),
        _ => None,
    }
}

fn keyword_arg_value(arg: &Expression) -> Option<&Expression> {
    let Expression::AssignOp {
        op: AssignOp::Assign,
        rhs,
        ..
    } = arg
    else {
        return None;
    };
    keyword_arg_name(arg).map(|_| rhs.as_ref())
}

/// Resolve a sink's semantic argument index to its actual AST slot and value.
///
/// Named arguments win regardless of their physical order. If the positional fallback lands on a
/// differently named argument, alignment is ambiguous and the argument is rejected.
pub fn resolve_sink_arg<'a>(
    sink: &str,
    idx: usize,
    args: &'a [Expression],
) -> Option<(usize, &'a Expression)> {
    let keyword_slot = sink_arg_name(sink, idx).and_then(|wanted| {
        args.iter()
            .position(|arg| keyword_arg_name(arg) == Some(wanted))
    });
    let slot = match keyword_slot {
        Some(slot) => slot,
        None => {
            if args.get(idx).and_then(keyword_arg_name).is_some() {
                return None;
            }
            idx
        }
    };
    let raw = args.get(slot)?;
    Some((slot, keyword_arg_value(raw).unwrap_or(raw)))
}

/// Sinks whose single-token arguments are too likely to be gameplay identifiers to rewrite.
pub fn is_wordy_sink(name: &str) -> bool {
    matches!(name, "speak" | "talk_into")
}

/// Announcement sinks rewrite interpolated templates only; plain text uses runtime reverse lookup.
pub fn is_announce_sink(name: &str) -> bool {
    matches!(
        name,
        "priority_announce" | "minor_announce" | "print_command_report"
    )
}

/// Detect the native `alert(Message, Title, ...)` / `input(Message, Title, ...)` form where `usr`
/// is omitted. In that form semantic argument 2 is a button/default value, not a title.
pub fn native_dialog_no_usr(name: &str, args: &[Expression]) -> bool {
    if !matches!(name, "alert" | "input") {
        return false;
    }
    args.first()
        .and_then(|arg| keyword_arg_value(arg).or(Some(arg)))
        .and_then(build_template)
        .is_some()
}

/// Whether a proc block declares DreamChecker's pure-proc setting.
pub fn block_is_pure(block: &[Spanned<Statement>]) -> bool {
    block.iter().any(|statement| {
        matches!(
            &statement.elem,
            Statement::Setting { name, .. }
                if name.as_str() == "SpacemanDMM_should_be_pure"
        )
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use dm::ast::{Ident2, SettingMode};

    fn text(value: &str) -> Expression {
        Expression::from(Term::String(value.to_string()))
    }

    fn ident(value: &str) -> Expression {
        Expression::from(Term::Ident(value.to_string()))
    }

    fn keyword(name: &str, value: Expression) -> Expression {
        Expression::AssignOp {
            op: AssignOp::Assign,
            lhs: Box::new(ident(name)),
            rhs: Box::new(value),
        }
    }

    #[test]
    fn sink_signatures_and_modes_are_stable() {
        assert_eq!(sink_message_args("visible_message").unwrap(), &[0, 1, 2]);
        assert_eq!(sink_message_args("talk_into").unwrap(), &[1]);
        assert!(is_rewrite_sink("visible_message"));
        assert!(!is_rewrite_sink("display_results"));
        assert!(is_wordy_sink("speak"));
        assert!(is_wordy_sink("talk_into"));
        assert!(is_announce_sink("priority_announce"));
        assert!(!is_announce_sink("to_chat"));
    }

    #[test]
    fn named_sink_arguments_resolve_by_semantic_name() {
        let args = vec![
            keyword("title", text("Alert title")),
            keyword("text", text("Alert body")),
        ];
        let (body_slot, body) = resolve_sink_arg("priority_announce", 0, &args).unwrap();
        let (title_slot, title) = resolve_sink_arg("priority_announce", 1, &args).unwrap();
        assert_eq!(body_slot, 1);
        assert_eq!(title_slot, 0);
        assert_eq!(build_template(body).as_deref(), Some("Alert body"));
        assert_eq!(build_template(title).as_deref(), Some("Alert title"));
    }

    /// `tgui_input_list(user, message = "…", title = "…", items = …)`：具名实参形态。
    /// 少了 sink_arg_name 里那条，按位取参会落到 `items = …` 上（第 2 位是 title 的名字位，
    /// 但源码里第 2 个实参其实是 title、第 3 个是 items）—— 提示语一个字都抽不到，
    /// rewrite 同样跳过。比特跑者磁盘的「Select an ability」就是这么漏的。
    #[test]
    fn tgui_input_named_arguments_resolve_by_semantic_name() {
        let args = vec![
            ident("user"),
            keyword("items", ident("names")),
            keyword("message", text("Select an ability")),
            keyword("title", text("Bitrunning Program")),
        ];
        let (_, message) = resolve_sink_arg("tgui_input_list", 1, &args).unwrap();
        let (_, title) = resolve_sink_arg("tgui_input_list", 2, &args).unwrap();
        assert_eq!(build_template(message).as_deref(), Some("Select an ability"));
        assert_eq!(build_template(title).as_deref(), Some("Bitrunning Program"));
    }

    #[test]
    fn native_dialog_form_protects_button_or_default_slot() {
        assert!(native_dialog_no_usr(
            "alert",
            &[text("Question?"), text("Title"), text("Yes")]
        ));
        assert!(native_dialog_no_usr(
            "input",
            &[text("Question?"), text("Title"), text("Default")]
        ));
        assert!(!native_dialog_no_usr(
            "alert",
            &[ident("user"), text("Question?"), text("Title")]
        ));
        assert!(!native_dialog_no_usr("tgui_alert", &[text("Question?")]));
    }

    #[test]
    fn pure_proc_setting_is_shared() {
        let pure = Spanned::new(
            Default::default(),
            Statement::Setting {
                name: Ident2::from("SpacemanDMM_should_be_pure".to_string()),
                mode: SettingMode::Assign,
                value: Expression::from(Term::Int(1)),
            },
        );
        assert!(block_is_pure(&[pure]));
        assert!(!block_is_pure(&[]));
    }
}
