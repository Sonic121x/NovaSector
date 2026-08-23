//! 译文迁移：上游改英文文案 → 内容哈希 key 变化 → 旧译文变孤儿。本 pass 在 extract
//! 写盘前，把各 locale 目录里可继承的译文接到新 key 上，避免「改一个单词丢一条校对」。
//!
//! 两种迁移（按可信度递减）：
//!   1. **精确继承**：新 key 的英文值与任一「已译条目」的英文值完全相同（跨命名空间移动、
//!      同值多处出现）→ 直接继承译文，无需复核。
//!   2. **近似迁移**：真正新增的 key（旧 en 目录没有），在「孤儿条目」（旧 en 有、本次抽取
//!      没有、且已译）里按词级 Dice 相似度找最佳候选；≥3 词、相似度 ≥0.8、`{N}` 占位符
//!      多重集一致才继承，并写入报告（tools/i18n/mt/.pending/migrate-report.<locale>.json）
//!      供人工复核。
//!
//! 写回 locale 目录时保留各文件的既有缩进（tab / 2 空格混存，见 mt 工具同款约定）。

use crate::catalog::{write_preserving_indent, Catalog};
use anyhow::Result;
use std::collections::{BTreeMap, HashMap, HashSet};
use std::path::Path;

const FUZZY_MIN_TOKENS: usize = 3;
// 实测 0.8~0.89 仍大量接错（"SOOC channel"←"dead chat channel"、主宾对调句、"improving"←"affecting"）：
// token 相似度对「换一个实体词/一处措辞」不敏感，而那恰是译文必须跟着变的地方。0.95 = 只放行
// 「标点/大小写/一两个虚词」级别的差异，其余留给 MT 重翻（接错比漏译贵——漏译还会被 MT 补上）。
const FUZZY_MIN_DICE: f64 = 0.95;

pub fn run(fresh: &Catalog, en_dir: &Path) -> Result<()> {
    let Some(locales_root) = en_dir.parent() else {
        return Ok(());
    };
    // 旧 en 目录（磁盘现状，extract 尚未覆写）：key -> 值，全命名空间合并。
    let old_en = load_locale(en_dir);

    for entry in std::fs::read_dir(locales_root)?.flatten() {
        let path = entry.path();
        if !path.is_dir() || path == en_dir {
            continue;
        }
        let locale = entry.file_name().to_string_lossy().to_string();
        if locale.starts_with("qps") {
            continue; // 伪 locale 是生成物
        }
        migrate_locale(fresh, &old_en, &path, &locale)?;
    }
    Ok(())
}

fn migrate_locale(
    fresh: &Catalog,
    old_en: &BTreeMap<String, BTreeMap<String, String>>,
    locale_dir: &Path,
    locale: &str,
) -> Result<()> {
    let old_zh = load_locale(locale_dir);

    // 英文值 -> 译文（仅「已译」条目：zh 存在且 != en 值）。同值多译时任取（BTreeMap 序稳定）。
    let mut translated: HashMap<&str, &str> = HashMap::new();
    // 孤儿：旧 en 有、本次抽取无、且已译 —— 近似迁移候选。
    let mut orphans: Vec<(&str, &str, &str)> = Vec::new(); // (old_key, en_value, zh_value)
    for (ns, old_map) in old_en {
        let fresh_ns = fresh.namespaces().get(ns);
        let zh_ns = old_zh.get(ns);
        for (key, en_value) in old_map {
            let Some(zh_value) = zh_ns.and_then(|m| m.get(key)) else {
                continue;
            };
            if zh_value == en_value {
                continue; // 未译/保英文占位
            }
            translated.entry(en_value).or_insert(zh_value);
            if fresh_ns.map_or(true, |m| !m.contains_key(key)) {
                orphans.push((key, en_value, zh_value));
            }
        }
    }

    // 孤儿倒排索引：token -> 孤儿下标（近似迁移只在共享罕见词的候选里比）。
    let orphan_tokens: Vec<HashSet<String>> =
        orphans.iter().map(|(_, en, _)| tokenize(en)).collect();
    let mut token_index: HashMap<&str, Vec<usize>> = HashMap::new();
    for (i, tokens) in orphan_tokens.iter().enumerate() {
        for t in tokens {
            token_index.entry(t.as_str()).or_default().push(i);
        }
    }

    let mut exact = 0usize;
    let mut fuzzy = 0usize;
    let mut additions: BTreeMap<String, BTreeMap<String, String>> = BTreeMap::new();
    let mut report: Vec<serde_json::Value> = Vec::new();

    for (ns, fresh_map) in fresh.namespaces() {
        let zh_ns = old_zh.get(ns);
        for (key, en_value) in fresh_map {
            if zh_ns.is_some_and(|m| m.contains_key(key)) {
                continue; // 该 locale 已有条目（含占位）
            }
            // 1) 精确继承：同英文值已有译文（跨命名空间/同值多处）。
            if let Some(zh_value) = translated.get(en_value.as_str()) {
                additions
                    .entry(ns.clone())
                    .or_default()
                    .insert(key.clone(), (*zh_value).to_string());
                exact += 1;
                continue;
            }
            // 2) 近似迁移：仅对「旧 en 没有的 key」（真正新出现的文案）。
            if old_en.get(ns).is_some_and(|m| m.contains_key(key)) {
                continue;
            }
            let tokens = tokenize(en_value);
            if tokens.len() < FUZZY_MIN_TOKENS {
                continue;
            }
            let Some((oi, score)) =
                best_orphan(&tokens, en_value, &orphans, &orphan_tokens, &token_index)
            else {
                continue;
            };
            let (old_key, old_value, zh_value) = orphans[oi];
            additions
                .entry(ns.clone())
                .or_default()
                .insert(key.clone(), zh_value.to_string());
            fuzzy += 1;
            report.push(serde_json::json!({
                "new_key": format!("{ns}.{}", key.rsplit('.').next().unwrap_or(key)),
                "new_en": en_value,
                "old_key": old_key,
                "old_en": old_value,
                "inherited": zh_value,
                "dice": (score * 100.0).round() / 100.0,
            }));
        }
    }

    if exact == 0 && fuzzy == 0 {
        return Ok(());
    }

    // 写回：逐命名空间合并新增条目，保留该文件既有缩进。
    for (ns, add) in &additions {
        let path = locale_dir.join(format!("{ns}.json"));
        let mut map = old_zh.get(ns).cloned().unwrap_or_default();
        map.extend(add.clone());
        write_preserving_indent(&path, &map)?;
    }

    if !report.is_empty() {
        let dir = Path::new("tools/i18n/mt/.pending");
        std::fs::create_dir_all(dir)?;
        let path = dir.join(format!("migrate-report.{locale}.json"));
        std::fs::write(&path, serde_json::to_string_pretty(&report)? + "\n")?;
        eprintln!("近似迁移报告（请人工复核）: {}", path.display());
    }
    eprintln!(
        "译文迁移 [{locale}]：精确继承 {exact} 条，近似迁移 {fuzzy} 条（孤儿池 {} 条）",
        orphans.len()
    );
    Ok(())
}

/// 在孤儿池里找与 `tokens` 最相似的候选：共享罕见词粗筛 → Dice 细算 → 占位符一致校验。
fn best_orphan(
    tokens: &HashSet<String>,
    en_value: &str,
    orphans: &[(&str, &str, &str)],
    orphan_tokens: &[HashSet<String>],
    token_index: &HashMap<&str, Vec<usize>>,
) -> Option<(usize, f64)> {
    // 罕见词优先：按 df 升序取最多 3 个 token 的候选并集。
    let mut by_df: Vec<&String> = tokens.iter().collect();
    by_df.sort_by_key(|t| token_index.get(t.as_str()).map_or(0, |v| v.len()));
    let mut candidates: HashSet<usize> = HashSet::new();
    for t in by_df.iter().take(3) {
        if let Some(ids) = token_index.get(t.as_str()) {
            candidates.extend(ids.iter().copied());
        }
    }
    let ph = placeholders(en_value);
    let content = content_tokens(tokens);
    let mut best: Option<(usize, f64)> = None;
    for i in candidates {
        let other = &orphan_tokens[i];
        let inter = tokens.intersection(other).count();
        let dice = 2.0 * inter as f64 / (tokens.len() + other.len()) as f64;
        if dice < FUZZY_MIN_DICE {
            continue;
        }
        // 实词交集 ≥2：停用词/占位符堆出来的高 Dice（"You are now {0}" 类短模板）不作数。
        let other_content = content_tokens(other);
        if content.intersection(&other_content).count() < 2 {
            continue;
        }
        // 极性词出现集不一致直接否决：否定/反转（"now"↔"no longer"）语义相反，
        // token 相似度看不出来（实测 Dice 0.84 仍接错）。
        let polarity_of = |set: &HashSet<String>| -> Vec<&'static str> {
            POLARITY
                .iter()
                .copied()
                .filter(|p| set.contains(*p))
                .collect()
        };
        if polarity_of(tokens) != polarity_of(other) {
            continue;
        }
        if placeholders(orphans[i].1) != ph {
            continue; // 占位符集不一致：迁移会产生孤立 {N} 或丢参
        }
        if best.is_none_or(|(_, s)| dice > s) {
            best = Some((i, dice));
        }
    }
    best
}

/// 高频停用词：短模板几乎全由它们构成（"You are now {0}"），只按全词 Dice 会把不相干的
/// 短句判成相似 → 近似迁移接错译文。实词交集另行要求（见 best_orphan）。
const STOPWORDS: [&str; 16] = [
    "the", "a", "an", "is", "are", "was", "you", "your", "now", "of", "to", "in", "and", "or",
    "on", "it",
];

/// 否定/反转极性词（tokenize 后形态）：两侧出现集不一致时禁止近似迁移（见 best_orphan）。
const POLARITY: [&str; 6] = ["no", "not", "never", "longer", "cannot", "already"];

fn tokenize(s: &str) -> HashSet<String> {
    s.split(|c: char| !c.is_alphanumeric())
        // 纯数字 token（多为 {0}/{1} 占位符编号）不算词：否则占位符多的短模板互相虚增相似度。
        .filter(|w| !w.is_empty() && !w.chars().all(|c| c.is_ascii_digit()))
        .map(|w| w.to_lowercase())
        .collect()
}

fn content_tokens(tokens: &HashSet<String>) -> HashSet<&str> {
    tokens
        .iter()
        .map(String::as_str)
        .filter(|t| !STOPWORDS.contains(t))
        .collect()
}

fn placeholders(s: &str) -> Vec<u32> {
    let mut out = Vec::new();
    let bytes = s.as_bytes();
    let mut i = 0;
    while let Some(pos) = s[i..].find('{') {
        let start = i + pos + 1;
        let end = s[start..].find('}').map(|e| start + e);
        if let Some(end) = end {
            if let Ok(n) = s[start..end].parse::<u32>() {
                out.push(n);
            }
            i = end + 1;
        } else {
            break;
        }
        if i >= bytes.len() {
            break;
        }
    }
    out.sort_unstable();
    out
}

fn load_locale(dir: &Path) -> BTreeMap<String, BTreeMap<String, String>> {
    let mut result = BTreeMap::new();
    let Ok(entries) = std::fs::read_dir(dir) else {
        return result;
    };
    for entry in entries.flatten() {
        let path = entry.path();
        if path.extension().and_then(|s| s.to_str()) != Some("json") {
            continue;
        }
        let Some(ns) = path.file_stem().and_then(|s| s.to_str()) else {
            continue;
        };
        let Ok(text) = std::fs::read_to_string(&path) else {
            continue;
        };
        if let Ok(map) = serde_json::from_str::<BTreeMap<String, String>>(&text) {
            result.insert(ns.to_string(), map);
        }
    }
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn tokenize_and_dice() {
        let a = tokenize("The engine is on fire!");
        let b = tokenize("The engine is on fire now!");
        let inter = a.intersection(&b).count();
        let dice = 2.0 * inter as f64 / (a.len() + b.len()) as f64;
        assert!(dice > 0.8, "小改动应超过阈值: {dice}");
    }

    #[test]
    fn placeholder_multiset() {
        assert_eq!(placeholders("{0} hits {1}!"), vec![0, 1]);
        assert_eq!(placeholders("{1} 被 {0} 命中"), vec![0, 1]);
        assert_ne!(placeholders("{0} hits!"), placeholders("{0} hits {1}!"));
        assert_eq!(placeholders("no braces"), Vec::<u32>::new());
    }

    #[test]
    fn indent_detection_default() {
        // 不存在的文件走缺省 2 空格；真实文件读盘逻辑由集成使用验证。
        let tmp = std::env::temp_dir().join("nova_i18n_migrate_test.json");
        let _ = std::fs::remove_file(&tmp);
        let mut map = BTreeMap::new();
        map.insert("a.b".to_string(), "值".to_string());
        write_preserving_indent(&tmp, &map).unwrap();
        let text = std::fs::read_to_string(&tmp).unwrap();
        assert!(
            text.contains("\n  \"a.b\""),
            "缺省应为 2 空格缩进: {text:?}"
        );
        let _ = std::fs::remove_file(&tmp);
    }
}
