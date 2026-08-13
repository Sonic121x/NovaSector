#!/usr/bin/env node
// NovaSector 全量汉化：把 **地图里定义的 desc 覆盖** 收进英文主目录。
//
// 为什么单独一步：`.dmm` 里的 `desc = "…"` 是**实例变量覆盖**，不在任何 .dm 源码里，
// dreammaker 解析器（nova-i18n extract）看不到它们 → 整类漏抽。玩家侧的表现很有迷惑性：
// 物体的 **name** 是中文（地图名早就手工收进了 `_map_names.json`），**desc 却是英文**，
// 看着像「这一条漏译」，实际是「这一整类从没进过目录」。
// 线上实例：heretic.dmm 的「充满恐惧的人」——名字译了，检查文本整段英文。
//
// 产物 `strings/i18n/en/_map_descs.json` 是 identity 表（key===value），与 `_map_names.json`
// 同一形态：运行时 build_i18n_cache 扫 locale 目录下全部 .json，译文进 zh-Hans 同名文件后，
// 经整串精确反查落地（examine → to_chat → lang_fallback_apply）。
//
// **只合并、不裁剪**（与目录的一贯约定一致）：上游删掉某张图不会让已有译文消失。
//
// 用法：node tools/i18n/map-descs.mjs      （幂等；resync 之后跑一次）

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(import.meta.dirname, '../..');
const MAP_DIR = path.join(ROOT, '_maps');
const OUT = path.join(ROOT, 'strings/i18n/en/_map_descs.json');

/// 准入门槛。desc 是纯显示字段，没有 name 那种「值兼标识符」的风险，所以只需挡掉
/// 非自然语言的碎片：
///   - 含 `[` 的是插值串，整串反查永远命中不了（要走模板引擎，不属于本表）；
///   - 太短 / 没有空格的多半是标记性短值，留给别的通道。
function isTranslatableDesc(text) {
  if (text.includes('[')) return false;
  if (text.length < 25) return false;
  if (!text.includes(' ')) return false;
  return /[A-Za-z]{2}/.test(text);
}

function* walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) yield* walk(full);
    else if (entry.name.endsWith('.dmm')) yield full;
  }
}

const found = new Set();
// `desc = "…"`，其中 `\"` 是 DM 的转义引号，不终结字符串。
const DESC_RE = /\bdesc = "((?:[^"\\]|\\.)*)"/g;

for (const file of walk(MAP_DIR)) {
  const source = fs.readFileSync(file, 'utf8');
  for (const match of source.matchAll(DESC_RE)) {
    // 目录存的是**运行时形态**：DM 运行时字符串里 `\"` 已经是裸引号。
    const text = match[1].replace(/\\"/g, '"');
    if (isTranslatableDesc(text)) found.add(text);
  }
}

const existing = fs.existsSync(OUT)
  ? JSON.parse(fs.readFileSync(OUT, 'utf8'))
  : {};
let added = 0;
for (const text of found) {
  if (!(text in existing)) {
    existing[text] = text;
    added++;
  }
}

const sorted = Object.fromEntries(
  Object.keys(existing)
    .sort()
    .map((k) => [k, existing[k]]),
);
fs.writeFileSync(OUT, `${JSON.stringify(sorted, null, '\t')}\n`);
console.log(
  `地图 desc：扫到 ${found.size} 条，新增 ${added} 条 → strings/i18n/en/_map_descs.json（合计 ${Object.keys(sorted).length}）`,
);
