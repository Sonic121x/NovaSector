#!/usr/bin/env node
// 译名一致性检测：同一句英文（去文法宏 / 折叠空白后）在目录里对应了**不同的中文**。
//
// 为什么需要它：`\improper Blob` 与 `Blob` 是**两条各自合法的源串**（`\improper` 是 DM 的
// 语法提示，不同类型用不用它本来就可以不同），所以它们是两把 key、分两批送去 MT —— 于是
// 同一个专名很容易得到两个译名（实测 `团块` / `泡泡`）。玩家按渲染路径看到不同名字，
// 而目录侧一切正常，任何现有门禁都不报。
//
// **不是所有分叉都是错的。** `bolt` 螺栓/插销、`Science` 科学/科学部 是同形异义，各自正确
// （AGENTS 与 audit.rs 的 AMBIGUITY_ALLOWLIST 记着这一类）。所以这是**报告**不是硬门禁：
// 用 --baseline 冻结现状、只对新增失败，才不会把 242 组既有条目连同真问题一起焊死。
//
// 用法：
//   node tools/i18n/consistency.mjs                     # 全量报告（按可疑度排序）
//   node tools/i18n/consistency.mjs --baseline <file>              # 只对不在基线里的组失败
//   node tools/i18n/consistency.mjs --baseline <file> --update-baseline
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const EN = path.join(ROOT, 'strings/i18n/en');
const ZH = path.join(ROOT, 'strings/i18n/zh-Hans');
// tgui.json 由 TGUI extractor 拥有、以英文原文为 key，域不同，不参与比对。
const SKIP = new Set(['tgui.json']);
const MACRO = /\\{1,2}(improper|proper)\s?/g;

const args = process.argv.slice(2);
const baselinePath = (() => {
  const i = args.indexOf('--baseline');
  return i === -1 ? null : args[i + 1];
})();
const updateBaseline = args.includes('--update-baseline');

const norm = (s) => s.replace(MACRO, '').replace(/\s+/g, ' ').trim();

function load(dir) {
  const out = new Map();
  if (!fs.existsSync(dir)) return out;
  for (const name of fs.readdirSync(dir)) {
    if (!name.endsWith('.json') || SKIP.has(name)) continue;
    let parsed;
    try {
      parsed = JSON.parse(fs.readFileSync(path.join(dir, name), 'utf8'));
    } catch {
      continue;
    }
    for (const [key, value] of Object.entries(parsed)) {
      if (typeof value === 'string') out.set(`${name}::${key}`, value);
    }
  }
  return out;
}

const en = load(EN);
const zh = load(ZH);
const groups = new Map();
for (const [id, source] of en) {
  const translated = zh.get(id);
  if (!translated) continue;
  const bucket = norm(source);
  if (!bucket) continue;
  if (!groups.has(bucket)) groups.set(bucket, []);
  groups.get(bucket).push({ id, source, translated });
}

const findings = [];
for (const [bucket, entries] of groups) {
  const distinct = new Set(entries.map((e) => norm(e.translated)));
  if (distinct.size < 2) continue;
  // 同一命名空间内分叉最可疑：同一个 .json 里两条只差文法宏的源串，几乎必然指同一个东西。
  const byFile = new Map();
  for (const e of entries) {
    const file = e.id.split('::')[0];
    if (!byFile.has(file)) byFile.set(file, new Set());
    byFile.get(file).add(norm(e.translated));
  }
  const sameFileSplit = [...byFile.values()].some((set) => set.size > 1);
  findings.push({ bucket, entries, sameFileSplit });
}
findings.sort((a, b) => Number(b.sameFileSplit) - Number(a.sameFileSplit) || a.bucket.localeCompare(b.bucket));

let baseline = new Set();
if (baselinePath && fs.existsSync(baselinePath)) {
  baseline = new Set(
    fs
      .readFileSync(baselinePath, 'utf8')
      .split('\n')
      .filter((line) => line && !line.startsWith('#')),
  );
}

if (updateBaseline) {
  if (!baselinePath) {
    console.error('--update-baseline 需要同时给 --baseline <file>');
    process.exit(2);
  }
  const header = [
    '# 译名一致性基线（node tools/i18n/consistency.mjs --update-baseline 生成）。',
    '# 每行一个「去文法宏后的英文」。只对不在此表的新增分叉失败。',
    '# 表里既有真问题也有同形异义（bolt 螺栓/插销），逐条清理时从这里删行。',
  ];
  fs.writeFileSync(baselinePath, [...header, ...findings.map((f) => f.bucket)].join('\n') + '\n');
  console.log(`已写入基线 ${baselinePath}：${findings.length} 组`);
  process.exit(0);
}

const fresh = findings.filter((f) => !baseline.has(f.bucket));
const show = baselinePath ? fresh : findings;
for (const f of show.slice(0, 40)) {
  console.log(`\n${f.sameFileSplit ? '[同命名空间] ' : ''}«${f.bucket.slice(0, 70)}»`);
  for (const e of f.entries) console.log(`   ${e.id}\n     en=${JSON.stringify(e.source)}\n     zh=${JSON.stringify(e.translated)}`);
}
const sameFile = findings.filter((f) => f.sameFileSplit).length;
console.log(`\n分叉组 ${findings.length}（其中同命名空间内 ${sameFile} 组，最可疑）`);
if (baselinePath) {
  console.log(`基线 ${baseline.size} 组，新增 ${fresh.length} 组`);
  if (fresh.length) process.exit(1);
}
