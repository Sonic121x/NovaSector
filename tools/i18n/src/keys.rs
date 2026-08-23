//! 稳定 key 与命名空间生成。

/// 由类型路径推导粗粒度命名空间（取首段），用于分文件组织目录。
/// 例如 `/obj/item/foo` -> `obj`，顶层（空路径）-> `_root`。
/// 相同英文模板在同一命名空间内复用同一 key（靠内容哈希去重）。
pub fn namespace_for(type_path: &str) -> String {
    // 语境 sidecar 把成员名编进路径尾巴（`/obj/item#name`、`/datum#proc()`）。命名空间只看类型
    // 路径本身——不剥的话**全局 proc**（类型路径为空）会得到 `#atmos_scan()` 这种命名空间，
    // 凭空造出 400 个 `#xxx().json` 目录文件，且 key 前缀跟着变 → 已有译文全部对不上。
    let trimmed = type_path.split('#').next().unwrap_or("").trim_matches('/');
    if trimmed.is_empty() {
        return "_root".to_string();
    }
    trimmed.split('/').next().unwrap_or("_root").to_string()
}

/// 稳定 key = `<namespace>.<BLAKE3 前 64 位（16 个小写十六进制字符）>`。
/// 仅依赖英文模板内容，保证幂等：同一模板恒得同一 key。
pub fn make_key(namespace: &str, template: &str) -> String {
    let hash = blake3::hash(template.as_bytes());
    let hex = hash.to_hex();
    format!("{namespace}.{}", &hex[..16])
}

/// Whether a key obeys the v2 `<namespace>.<16 lowercase hex>` contract.
pub fn is_v2_key(key: &str) -> bool {
    let Some((namespace, suffix)) = key.rsplit_once('.') else {
        return false;
    };
    !namespace.is_empty()
        && suffix.len() == 16
        && suffix
            .bytes()
            .all(|byte| byte.is_ascii_digit() || (b'a'..=b'f').contains(&byte))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn v2_key_is_stable_lowercase_64_bit_blake3() {
        let key = make_key("obj", "");
        assert_eq!(key, "obj.af1349b9f5f9a1a6");
        assert_eq!(key, make_key("obj", ""));
        assert!(is_v2_key(&key));
        let suffix = key.rsplit_once('.').unwrap().1;
        assert_eq!(suffix.len(), 16);
        assert!(suffix
            .bytes()
            .all(|byte| byte.is_ascii_digit() || (b'a'..=b'f').contains(&byte)));
    }

    #[test]
    fn v2_shape_rejects_legacy_or_noncanonical_keys() {
        assert!(!is_v2_key("obj.af1349b9"));
        assert!(!is_v2_key("obj.AF1349B9F5F9A1A6"));
        assert!(!is_v2_key("manual_name"));
    }
}
