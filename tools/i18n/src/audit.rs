//! Catalog ownership and liveness checks.
//!
//! DM extraction owns ordinary locale catalog files, TGUI owns `tgui.json`, and
//! underscore-prefixed files are manually maintained runtime domains.  The audit
//! only garbage-collects entries in the first category.

use anyhow::{Context as _, Result};
use std::collections::{BTreeMap, BTreeSet};
use std::path::{Path, PathBuf};

use crate::governance::{CatalogDomains, CatalogOwner};

#[derive(Debug)]
struct CatalogEntry {
    file_name: String,
    key: String,
    value: String,
    ownership: CatalogOwner,
}

fn read_catalog(path: &Path) -> Result<BTreeMap<String, String>> {
    let text = std::fs::read_to_string(path)
        .with_context(|| format!("无法读取目录文件：{}", path.display()))?;
    serde_json::from_str(&text).with_context(|| format!("目录 JSON 解析失败：{}", path.display()))
}

fn catalog_files(dir: &Path) -> Result<Vec<PathBuf>> {
    let mut files = Vec::new();
    for entry in std::fs::read_dir(dir)
        .with_context(|| format!("无法读取 locale 目录：{}", dir.display()))?
    {
        let path = entry?.path();
        if path.is_file() && path.extension().and_then(|ext| ext.to_str()) == Some("json") {
            files.push(path);
        }
    }
    files.sort();
    Ok(files)
}

fn collect_entries(en_dir: &Path, domains: &CatalogDomains) -> Result<Vec<CatalogEntry>> {
    let mut entries = Vec::new();
    for path in catalog_files(en_dir)? {
        let file_name = path
            .file_name()
            .and_then(|name| name.to_str())
            .context("目录文件名不是 UTF-8")?
            .to_owned();
        let ownership = domains
            .get(&file_name)
            .with_context(|| format!("{} 未登记在 catalog-domains.json", path.display()))?
            .owner;
        for (key, value) in read_catalog(&path)? {
            entries.push(CatalogEntry {
                file_name: file_name.clone(),
                key,
                value,
                ownership,
            });
        }
    }
    Ok(entries)
}

fn is_stale(entry: &CatalogEntry, live_keys: &BTreeSet<String>) -> bool {
    entry.ownership == CatalogOwner::Extract && !live_keys.contains(&entry.key)
}

fn locale_dirs(catalog_root: &Path) -> Result<Vec<PathBuf>> {
    let mut dirs = Vec::new();
    for entry in std::fs::read_dir(catalog_root)
        .with_context(|| format!("无法读取目录根：{}", catalog_root.display()))?
    {
        let path = entry?.path();
        if path.is_dir() {
            dirs.push(path);
        }
    }
    dirs.sort();
    Ok(dirs)
}

/// Remove only entries proved stale in DM-extractor-owned files.  Every edit is
/// parsed and staged before the first write, so malformed locale data cannot
/// leave a partially-applied collection.
fn apply_stale(
    catalog_root: &Path,
    domains: &CatalogDomains,
    stale: &[&CatalogEntry],
) -> Result<usize> {
    let mut stale_by_file: BTreeMap<&str, BTreeSet<&str>> = BTreeMap::new();
    for entry in stale {
        debug_assert_eq!(entry.ownership, CatalogOwner::Extract);
        stale_by_file
            .entry(&entry.file_name)
            .or_default()
            .insert(&entry.key);
    }

    let mut staged = Vec::new();
    let mut removed = 0usize;
    for locale_dir in locale_dirs(catalog_root)? {
        for (&file_name, keys) in &stale_by_file {
            let path = locale_dir.join(file_name);
            if !path.exists() {
                continue;
            }
            let ownership = domains
                .get(file_name)
                .with_context(|| format!("{file_name} 未登记在 catalog-domains.json"))?
                .owner;
            if ownership != CatalogOwner::Extract {
                anyhow::bail!(
                    "拒绝修改非自动目录文件：{}（manual/TGUI ownership is immutable）",
                    path.display()
                );
            }
            let mut catalog = read_catalog(&path)?;
            let before = catalog.len();
            catalog.retain(|key, _| !keys.contains(key.as_str()));
            removed += before - catalog.len();
            if catalog.len() != before {
                staged.push((path, catalog));
            }
        }
    }

    for (path, catalog) in staged {
        crate::catalog::write_preserving_indent(&path, &catalog)?;
    }
    Ok(removed)
}

/// Audit automatic catalog liveness against the exact extractor plus current
/// `LANG` references.  The default is a read-only CI check; `apply` performs the
/// same analysis and removes only proven-stale automatic entries from matching
/// locale files.
pub fn run(dme: &Path, catalog_root: &Path, apply: bool) -> Result<()> {
    let en_dir = catalog_root.join("en");
    let domains = CatalogDomains::load(catalog_root)?;
    let live_keys = crate::extract::live_keys(dme, &en_dir)?;
    let entries = collect_entries(&en_dir, &domains)?;

    let automatic = entries
        .iter()
        .filter(|entry| entry.ownership == CatalogOwner::Extract)
        .count();
    let manual = entries
        .iter()
        .filter(|entry| entry.ownership == CatalogOwner::Manual)
        .count();
    let tgui = entries
        .iter()
        .filter(|entry| entry.ownership == CatalogOwner::Tgui)
        .count();
    let stale: Vec<&CatalogEntry> = entries
        .iter()
        .filter(|entry| is_stale(entry, &live_keys))
        .collect();

    eprintln!(
        "catalog ownership: DM 自动 {} 条（live {} / stale {}），manual/domain {} 条（保留），TGUI {} 条（交由 TGUI extractor）",
        automatic,
        automatic - stale.len(),
        stale.len(),
        manual,
        tgui
    );
    for entry in &stale {
        eprintln!(
            "stale: strings/i18n/en/{} {} = {:?}",
            entry.file_name, entry.key, entry.value
        );
    }

    if stale.is_empty() {
        return Ok(());
    }
    if !apply {
        anyhow::bail!(
            "发现 {} 条失去 extracted literal / LANG reference 的自动目录项；只读检查未修改文件（确认后使用 `nova-i18n catalog-audit --apply`）",
            stale.len()
        );
    }

    let removed = apply_stale(catalog_root, &domains, &stale)?;
    eprintln!(
        "已从各 locale 的自动目录文件移除 {} 个条目；manual/domain 与 TGUI 文件未修改。",
        removed
    );
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn only_dead_automatic_entries_are_stale() {
        let live = BTreeSet::from(["obj.live".to_owned()]);
        let entry = |ownership, key: &str| CatalogEntry {
            file_name: "fixture.json".to_owned(),
            key: key.to_owned(),
            value: "value".to_owned(),
            ownership,
        };

        assert!(!is_stale(&entry(CatalogOwner::Extract, "obj.live"), &live));
        assert!(is_stale(&entry(CatalogOwner::Extract, "obj.dead"), &live));
        assert!(!is_stale(&entry(CatalogOwner::Manual, "obj.dead"), &live));
        assert!(!is_stale(&entry(CatalogOwner::Tgui, "obj.dead"), &live));
    }
}
