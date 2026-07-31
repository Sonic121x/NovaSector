//! 英文主目录的内存模型与落盘。
//!
//! 文件格式与运行时 (modular_nova/modules/i18n/code/runtime.dm) 读取的一致：
//! 每个命名空间一个 JSON，内容为扁平的 {"key": "模板"}。BTreeMap 保证 key 有序，
//! 便于 diff 与 Tolgee 同步。

use anyhow::Result;
use std::collections::{BTreeMap, BTreeSet};
use std::path::Path;

#[derive(Default)]
pub struct Catalog {
    namespaces: BTreeMap<String, BTreeMap<String, String>>,
    /// key -> 该英文串出现过的**完整 DM 类型路径**集合（一个 key 可来自多个类型：
    /// key 是内容哈希，同一句英文在 `/obj/item/storage/chest` 和 `/datum/wound/chest`
    /// 下会归到同一个 key）。落盘成 scopes.json，供术语表按语境消歧。
    scopes: BTreeMap<String, BTreeSet<String>>,
}

impl Catalog {
    pub fn new() -> Self {
        Self::default()
    }

    /// `type_path` 传**完整类型路径**（`/datum/reagent/medicine/multiver`）；命名空间由它推导。
    /// 对 flavor.rs 那种没有类型路径、直接给命名空间名（"news"/"strings"）的调用也成立——
    /// `namespace_for` 对裸命名空间名是幂等的，此时 scope 就退化成命名空间粒度。
    pub fn insert(&mut self, type_path: &str, key: &str, template: &str) {
        let namespace = crate::keys::namespace_for(type_path);
        self.namespaces
            .entry(namespace)
            .or_default()
            .insert(key.to_string(), template.to_string());
        let scope = type_path.trim_end_matches('/');
        if !scope.is_empty() {
            self.scopes
                .entry(key.to_string())
                .or_default()
                .insert(scope.to_string());
        }
    }

    /// 合并已存在目录里的条目（保留已被 rewrite 改写、源码中已不再是字面量的 key）。
    /// 重同步（合并上游后重跑）时必需：否则已改写字符串的 key 会从目录里消失。
    ///
    /// 只合并**本次抽取已产出的命名空间**：其它文件（tgui.json 归 tgui-catalog.mjs 管、
    /// 手维护 `_state_words.json` 等）不归 extract 所有，吸进来再写回会因排序/缩进
    /// 约定不同造成上万行伪 churn。
    pub fn load_dir(&mut self, dir: &Path) {
        let Ok(entries) = std::fs::read_dir(dir) else {
            return;
        };
        for entry in entries.flatten() {
            let path = entry.path();
            if path.extension().and_then(|s| s.to_str()) != Some("json") {
                continue;
            }
            let Some(namespace) = path.file_stem().and_then(|s| s.to_str()) else {
                continue;
            };
            let Some(existing) = self.namespaces.get_mut(namespace) else {
                continue; // 非 extract 自产命名空间：不接管
            };
            let Ok(text) = std::fs::read_to_string(&path) else {
                continue;
            };
            let Ok(map) = serde_json::from_str::<BTreeMap<String, String>>(&text) else {
                continue;
            };
            for (key, value) in map {
                existing.entry(key).or_insert(value);
            }
        }
    }

    pub fn namespaces(&self) -> &BTreeMap<String, BTreeMap<String, String>> {
        &self.namespaces
    }

    pub fn namespace_count(&self) -> usize {
        self.namespaces.len()
    }

    pub fn entry_count(&self) -> usize {
        self.namespaces.values().map(|m| m.len()).sum()
    }

    pub fn write(&self, out: &Path) -> Result<()> {
        std::fs::create_dir_all(out)?;
        for (namespace, map) in &self.namespaces {
            let path = out.join(format!("{namespace}.json"));
            write_preserving_indent(&path, map)?;
        }
        Ok(())
    }

    /// 写 key -> 类型路径 的 sidecar。
    ///
    /// **刻意放在 locale 目录之外**（`strings/i18n/scopes.json`，与 policy.json /
    /// voice_of_god.json 同级）：runtime.dm 的 build_i18n_cache 只下钻**目录**、且会把
    /// locale 目录里的每个 .json 全量并进反查表——放进去会让类型路径变成可反查的"译文"。
    ///
    /// 合并语义与 load_dir 一致：已被 rewrite 改写成 `LANG("key")` 的字符串，源码里已无
    /// 字面量、本次抽取产不出，其 scope 从旧文件保留，否则重跑一次就全丢。
    pub fn write_scopes(&self, path: &Path) -> Result<()> {
        let mut merged: BTreeMap<String, BTreeSet<String>> = std::fs::read_to_string(path)
            .ok()
            .and_then(|t| serde_json::from_str::<BTreeMap<String, BTreeSet<String>>>(&t).ok())
            .unwrap_or_default();
        // 本次抽取到的 key 以本次为准（类型可能被上游挪过窝）；没抽到的沿用旧值。
        for (key, scopes) in &self.scopes {
            merged.insert(key.clone(), scopes.clone());
        }
        if let Some(dir) = path.parent() {
            std::fs::create_dir_all(dir)?;
        }
        let mut buf = String::from("{\n");
        let last = merged.len().saturating_sub(1);
        for (i, (key, scopes)) in merged.iter().enumerate() {
            let list: Vec<&str> = scopes.iter().map(String::as_str).collect();
            buf.push_str("  ");
            buf.push_str(&serde_json::to_string(key)?);
            buf.push_str(": ");
            buf.push_str(&serde_json::to_string(&list)?);
            if i != last {
                buf.push(',');
            }
            buf.push('\n');
        }
        buf.push_str("}\n");
        std::fs::write(path, buf)?;
        Ok(())
    }

    /// 只记语境、不进目录。用于 `LANG("key")` 调用点：那里没有英文字面量可抽
    /// （已被 rewrite 换掉），但类型路径是有的。
    pub fn note_scope(&mut self, key: &str, type_path: &str) {
        let scope = type_path.trim_end_matches('/');
        if scope.is_empty() {
            return;
        }
        self.scopes
            .entry(key.to_string())
            .or_default()
            .insert(scope.to_string());
    }

    pub fn scope_count(&self) -> usize {
        self.scopes.len()
    }
}

/// 按文件既有缩进（第二行前导空白，缺省 2 空格）序列化扁平 map 写回。
/// tgui.json（tgui-catalog.mjs）等文件是 tab 缩进，统一 pretty 会造成上万行伪 churn，
/// 与 mt 工具的「preserve each catalog's existing indentation」同款约定。
pub fn write_preserving_indent(path: &Path, map: &BTreeMap<String, String>) -> Result<()> {
    let indent: Vec<u8> = std::fs::read_to_string(path)
        .ok()
        .and_then(|text| {
            text.lines().nth(1).map(|line| {
                line.bytes()
                    .take_while(|b| *b == b' ' || *b == b'\t')
                    .collect::<Vec<u8>>()
            })
        })
        .filter(|v| !v.is_empty())
        .unwrap_or_else(|| b"  ".to_vec());
    let indent = String::from_utf8_lossy(&indent).to_string();
    let mut buf = String::from("{\n");
    let last = map.len().saturating_sub(1);
    for (i, (key, value)) in map.iter().enumerate() {
        buf.push_str(&indent);
        buf.push_str(&serde_json::to_string(key)?);
        buf.push_str(": ");
        buf.push_str(&serde_json::to_string(value)?);
        if i != last {
            buf.push(',');
        }
        buf.push('\n');
    }
    buf.push_str("}\n");
    std::fs::write(path, buf)?;
    Ok(())
}
