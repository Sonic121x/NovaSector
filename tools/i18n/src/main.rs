//! NovaSector 全量汉化 (i18n) —— DM 字符串抽取/改写工具。
//!
//! 首版 `extract` 聚焦类型变量初始化里的玩家可见文本（name/desc 等，即「动态渲染」内容的
//! 主要来源），输出英文主目录 strings/i18n/en/<namespace>.json。
//! 后续增量将扩展到 proc 体内的 to_chat / visible_message / balloon_alert 等汇聚点，
//! 并把内插字符串转换为 {0}/{1} 占位符模板、改写调用点为 LANG/LANGU。

mod audit;
mod catalog;
mod dm_string;
mod extract;
mod flavor;
mod governance;
mod keys;
mod labels;
mod lint;
mod migrate;
mod pseudo;
mod rewrite;
mod semantics;
mod template;

use anyhow::Result;
use clap::{Parser, Subcommand};
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "nova-i18n", about = "NovaSector 全量汉化抽取/改写工具")]
struct Cli {
    #[command(subcommand)]
    cmd: Cmd,
}

#[derive(Subcommand)]
enum Cmd {
    /// 解析 .dme 并抽取玩家可见字符串到英文目录。
    Extract {
        /// 项目入口 .dme。
        #[arg(long, default_value = "tgstation.dme")]
        dme: PathBuf,
        /// 英文主目录输出位置。
        #[arg(long, default_value = "strings/i18n/en")]
        out: PathBuf,
        /// 只统计、不落盘。
        #[arg(long)]
        dry_run: bool,
    },
    /// 幂等改写：把汇聚点调用里的纯字符串消息替换为 LANG("key", null)（v2）。
    Rewrite {
        /// 项目入口 .dme。
        #[arg(long, default_value = "tgstation.dme")]
        dme: PathBuf,
        /// 仅改写路径包含该子串的文件（建议分域/分模块逐步推进）。
        #[arg(long)]
        filter: Option<String>,
        /// 只统计、不落盘。
        #[arg(long)]
        dry_run: bool,
    },
    /// verb 命令面板名编译期注入译文（verb 名无法运行时本地化）。需先 extract + 翻译 verb 名。
    Verbs {
        /// 项目入口 .dme。
        #[arg(long, default_value = "tgstation.dme")]
        dme: PathBuf,
        /// 译文 locale（读 strings/i18n/<locale>/*.json 取译文）。
        #[arg(long, default_value = "zh-Hans")]
        locale: String,
        /// 反向还原：把已注入的「译文」verb 名换回英文原文（按 zh→en 映射，歧义跳过）。
        #[arg(long)]
        revert: bool,
        /// 只统计、不落盘。
        #[arg(long)]
        dry_run: bool,
    },
    /// i18n 门禁：目录卫生（占位符/标识符形/控制字符）+ 标识符碰撞静态分析（基线增量）。
    Lint {
        /// 项目入口 .dme（标识符碰撞 AST 扫描用）。
        #[arg(long, default_value = "tgstation.dme")]
        dme: PathBuf,
        /// 目录根（含 en/ 与各 locale 子目录）。
        #[arg(long, default_value = "strings/i18n")]
        catalog: PathBuf,
        /// 与英文做占位符/卫生比对的 locale。
        #[arg(long, default_value = "zh-Hans")]
        locale: String,
        /// 标识符碰撞基线文件（只对不在基线里的新碰撞失败）。
        #[arg(long, default_value = "tools/i18n/identifier-baseline.txt")]
        baseline: PathBuf,
        /// 「目录里有、源码里仍是裸字面量」的基线（只对新增失败）。
        #[arg(long, default_value = "tools/i18n/bare-english-baseline.txt")]
        bare_baseline: PathBuf,
        /// 用当前全部碰撞重写基线（首次采纳 / 修复后刷新）。
        #[arg(long)]
        update_baseline: bool,
        /// 跳过 AST 标识符扫描（只跑目录卫生，纯目录 PR 更快）。
        #[arg(long)]
        no_ast: bool,
    },
    /// 生成伪 locale 目录（从 en/ 包裹每个值，保留占位符/标签）。用于运行时爬取未接通路径 +
    /// 在 CI 单元测试里捕获「标识符被反查表变异」的 gameplay 回归（无需任何真实译文）。
    Pseudo {
        /// 目录根（含 en/）。
        #[arg(long, default_value = "strings/i18n")]
        catalog: PathBuf,
        /// 伪 locale 名（写到 <catalog>/<locale>/）。
        #[arg(long, default_value = "qps-ploc")]
        locale: String,
    },
    /// 抽「标识符耦合的 DM 显示名」（name/title/category_name/explanation/choiced 选项）到 flat JSON，
    /// 供 tgui-catalog.mjs 读入前端 tgui 目录。按类型路径/proc 语义定位（AST），取代正则 DM_LABEL_SOURCES。
    Labels {
        /// 项目入口 .dme。
        #[arg(long, default_value = "tgstation.dme")]
        dme: PathBuf,
        /// 输出 flat JSON 路径（committed；tgui-catalog.mjs 读它合并进前端目录）。
        #[arg(long, default_value = "tools/i18n/dm_labels.json")]
        out: PathBuf,
    },
    /// 审计自动目录项的 ownership/liveness。默认只读并在发现 stale 项时失败。
    CatalogAudit {
        /// 项目入口 .dme（用与 extract 相同的语义重建 live key 集合）。
        #[arg(long, default_value = "tgstation.dme")]
        dme: PathBuf,
        /// 目录根（含 catalog-domains.json 与 locale 子目录）。
        #[arg(long, default_value = "strings/i18n")]
        catalog: PathBuf,
        /// 只删除已证明 stale 的 extract-owned 项；manual/domain 与 TGUI 文件永不修改。
        #[arg(long)]
        apply: bool,
    },
    /// 计算英文模板的稳定目录 key（`<ns>.<BLAKE3 前 64 位>`）。手工 LANG 化裸拼接行时用：
    /// 取 key → 模板手工写进 en 目录（zh 同 key 填译文）→ 源码写 LANG("<key>", args)。
    Key {
        /// 命名空间（obj/mob/datum/…，通常=类型路径首段）。
        namespace: String,
        /// 英文模板（含 {0}/{1} 占位符，与 en 目录值逐字一致）。
        template: String,
    },
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    match cli.cmd {
        Cmd::Extract { dme, out, dry_run } => extract::run(&dme, &out, dry_run).map(|_| ()),
        Cmd::Rewrite {
            dme,
            filter,
            dry_run,
        } => rewrite::run(&dme, filter.as_deref(), dry_run),
        Cmd::Verbs {
            dme,
            locale,
            revert,
            dry_run,
        } => rewrite::run_verbs(&dme, &locale, revert, dry_run),
        Cmd::Lint {
            dme,
            catalog,
            locale,
            baseline,
            bare_baseline,
            update_baseline,
            no_ast,
        } => lint::run(
            &dme,
            &catalog,
            &locale,
            Some(baseline),
            Some(bare_baseline),
            update_baseline,
            no_ast,
        ),
        Cmd::Pseudo { catalog, locale } => pseudo::run(&catalog, &locale),
        Cmd::Labels { dme, out } => labels::run(&dme, &out),
        Cmd::CatalogAudit {
            dme,
            catalog,
            apply,
        } => audit::run(&dme, &catalog, apply),
        Cmd::Key {
            namespace,
            template,
        } => {
            println!("{}", keys::make_key(&namespace, &template));
            Ok(())
        }
    }
}
