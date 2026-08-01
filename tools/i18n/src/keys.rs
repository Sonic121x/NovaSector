//! 稳定 key 与命名空间生成。

/// 由类型路径推导粗粒度命名空间（取首段），用于分文件组织目录。
/// 例如 `/obj/item/foo` -> `obj`，顶层（空路径）-> `_root`。
/// 相同英文模板在同一命名空间内复用同一 key（靠内容哈希去重）。
pub fn namespace_for(type_path: &str) -> String {
    // 语境 sidecar 把成员名编进路径尾巴（`/obj/item#name`、`/datum#proc()`）。命名空间只看类型
    // 路径本身——不剥的话**全局 proc**（类型路径为空）会得到 `#atmos_scan()` 这种命名空间，
    // 凭空造出 400 个 `#xxx().json` 目录文件，且 key 前缀跟着变 → 已有译文全部对不上。
    let trimmed = type_path
        .split('#')
        .next()
        .unwrap_or("")
        .trim_matches('/');
    if trimmed.is_empty() {
        return "_root".to_string();
    }
    trimmed.split('/').next().unwrap_or("_root").to_string()
}

/// 稳定 key = `<namespace>.<内容哈希前 8 位>`。
/// 仅依赖英文模板内容，保证幂等：同一模板恒得同一 key。
pub fn make_key(namespace: &str, template: &str) -> String {
    let hash = blake3::hash(template.as_bytes());
    let short = &hash.to_hex()[..8];
    format!("{namespace}.{short}")
}
