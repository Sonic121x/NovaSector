//! Shared catalog domain and ownership manifest handling.

use anyhow::{Context as _, Result};
use std::collections::BTreeMap;
use std::path::Path;

pub const MANIFEST_FILE: &str = "catalog-domains.json";

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum CatalogOwner {
    Extract,
    Manual,
    Tgui,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct CatalogFilePolicy {
    pub domain: String,
    pub owner: CatalogOwner,
    pub optional: bool,
    pub locale_only: bool,
}

#[derive(Clone, Debug)]
pub struct CatalogDomains {
    files: BTreeMap<String, CatalogFilePolicy>,
}

impl CatalogDomains {
    pub fn load(catalog_root: &Path) -> Result<Self> {
        let path = catalog_root.join(MANIFEST_FILE);
        let text = std::fs::read_to_string(&path)
            .with_context(|| format!("无法读取目录域清单：{}", path.display()))?;
        let root: serde_json::Value = serde_json::from_str(&text)
            .with_context(|| format!("目录域清单 JSON 解析失败：{}", path.display()))?;
        if root.get("version").and_then(serde_json::Value::as_u64) != Some(2) {
            anyhow::bail!("{} 必须声明 version: 2", path.display());
        }
        let object = root
            .get("files")
            .and_then(serde_json::Value::as_object)
            .with_context(|| format!("{} 缺少对象字段 files", path.display()))?;
        let mut files = BTreeMap::new();
        for (file_name, raw) in object {
            if !file_name.ends_with(".json") || file_name.contains('/') || file_name.contains('\\')
            {
                anyhow::bail!("目录域清单含非法文件名：{file_name:?}");
            }
            let domain = raw
                .get("domain")
                .and_then(serde_json::Value::as_str)
                .with_context(|| format!("目录域清单 {file_name} 缺少字符串 domain"))?;
            if !valid_domain(domain) {
                anyhow::bail!("目录域清单 {file_name} 的 domain 非法：{domain:?}");
            }
            let owner_name = raw
                .get("owner")
                .and_then(serde_json::Value::as_str)
                .with_context(|| format!("目录域清单 {file_name} 缺少字符串 owner"))?;
            let owner = owner_from_name(file_name, owner_name)?;
            // `_root.json` is the extractor's explicit namespace for root-level
            // DM types. Every other underscore-prefixed catalog is manual.
            if file_name.starts_with('_')
                && file_name != "_root.json"
                && owner != CatalogOwner::Manual
            {
                anyhow::bail!("{file_name} 以下划线开头，必须是 manual-owned");
            }
            if file_name == "tgui.json" && owner != CatalogOwner::Tgui {
                anyhow::bail!("tgui.json 必须归 TGUI extractor 所有");
            }
            if owner == CatalogOwner::Extract && domain != "forward" {
                anyhow::bail!("extract-owned {file_name} 必须属于 forward 域，而不是 {domain}");
            }
            if owner == CatalogOwner::Tgui && domain != "tgui" {
                anyhow::bail!("TGUI-owned {file_name} 必须属于 tgui 域，而不是 {domain}");
            }
            let optional = bool_field(raw, file_name, "optional")?;
            let locale_only = bool_field(raw, file_name, "locale_only")?;
            files.insert(
                file_name.clone(),
                CatalogFilePolicy {
                    domain: domain.to_owned(),
                    owner,
                    optional,
                    locale_only,
                },
            );
        }
        Ok(Self { files })
    }

    pub fn get(&self, file_name: &str) -> Option<&CatalogFilePolicy> {
        self.files.get(file_name)
    }
}

fn bool_field(raw: &serde_json::Value, file_name: &str, field: &str) -> Result<bool> {
    match raw.get(field) {
        None => Ok(false),
        Some(value) => value
            .as_bool()
            .with_context(|| format!("目录域清单 {file_name} 的 {field} 必须是 bool")),
    }
}

fn owner_from_name(file_name: &str, owner: &str) -> Result<CatalogOwner> {
    match owner {
        "extract" => Ok(CatalogOwner::Extract),
        "manual" => Ok(CatalogOwner::Manual),
        "tgui" => Ok(CatalogOwner::Tgui),
        _ => anyhow::bail!("目录域清单 {file_name} 的 owner 非法：{owner:?}"),
    }
}

fn valid_domain(domain: &str) -> bool {
    matches!(
        domain,
        "forward" | "manual_forward" | "global_reverse" | "tgui"
    ) || domain
        .strip_prefix("scoped:")
        .is_some_and(|scope| !scope.is_empty())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ownership_labels_are_explicit() {
        assert_eq!(
            owner_from_name("obj.json", "extract").unwrap(),
            CatalogOwner::Extract
        );
        assert_eq!(
            owner_from_name("_state_words.json", "manual").unwrap(),
            CatalogOwner::Manual
        );
        assert_eq!(
            owner_from_name("tgui.json", "tgui").unwrap(),
            CatalogOwner::Tgui
        );
        assert!(owner_from_name("obj.json", "legacy").is_err());
    }

    #[test]
    fn runtime_domain_names_are_narrow() {
        assert!(valid_domain("forward"));
        assert!(valid_domain("manual_forward"));
        assert!(valid_domain("global_reverse"));
        assert!(valid_domain("tgui"));
        assert!(valid_domain("scoped:state_words"));
        assert!(!valid_domain("scoped:"));
        assert!(!valid_domain("global"));
    }
}
