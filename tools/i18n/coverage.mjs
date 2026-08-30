#!/usr/bin/env node
// 翻译覆盖率报告：把「还没翻」和「看起来像没翻其实不是」拆开。
//
// 以前只报「缺失 + zh==en」，把三件不同的事加在一起：
//   · verb 注入后混进 en 目录的中文源（CJK-in-en）
//   · 标识符 / 单位 / 全大写缩写（启发式不该送 MT）
//   · 真漏译
// resync 看那个加法会高估待译、低估数据卫生。
//
// 退出码恒为 0（纯报告，不阻断 resync）。`--json` 打机器可读汇总。
import fs from 'node:fs';
import path from 'node:path';

const EN = 'strings/i18n/en';
const ZH = 'strings/i18n/zh-Hans';
const KEEP = 'tools/i18n/mt/keep-english.zh-Hans.json';
const WANT_JSON = process.argv.includes('--json');

const CJK_RE = /[\u3400-\u9FFF\uF900-\uFAFF]/;
const IDENT_RE = /^[a-z][a-z0-9_]*$/;
const KEBAB_RE = /^[a-z][a-z0-9]*(?:-[a-z0-9]+)+$/;
const ABBREV_RE = /^[A-Z]{2,8}$/;
const UNIT_TOKEN_RE =
  /^(?:k?Pa|kPa|u|m|K|pH|GQ|cr|HP|s|min|h|ms|cm|mm|kg|g|mol|%|x|:g)$/i;
const PUNCT_TOKEN_RE = /^[:.+\-#%[\]()'"]+$/;

let keep = new Set();
try {
  const k = JSON.parse(fs.readFileSync(KEEP, 'utf8'));
  keep = new Set(Array.isArray(k) ? k : Object.keys(k));
} catch {
  /* 白名单可选 */
}

function isKeep(key, ev) {
  return keep.has(ev) || keep.has(key);
}

function isCjkInEn(ev) {
  return CJK_RE.test(ev);
}

function stripDecor(s) {
  return s
    .replace(/\{(\d+)\}/g, ' ')
    .replace(/<[^>]+>/g, ' ')
    .replace(/\\[a-zA-Z]+/g, ' ')
    .replace(/%[A-Z][A-Z0-9_]*%/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

/** 形态上不该送 MT：标识符、单位骨架、纯缩写、剥装饰后没有拉丁词。 */
function isHeuristicSkip(ev) {
  const t = ev.trim();
  if (t.length <= 1) return true;
  if (IDENT_RE.test(t) || KEBAB_RE.test(t) || ABBREV_RE.test(t)) return true;
  const stripped = stripDecor(t);
  if (!stripped) return true;
  if (IDENT_RE.test(stripped) || KEBAB_RE.test(stripped) || ABBREV_RE.test(stripped)) {
    return true;
  }
  const tokens = stripped.split(/[\s,;()/]+/).filter(Boolean);
  if (
    tokens.length &&
    tokens.every(
      (tok) =>
        UNIT_TOKEN_RE.test(tok) ||
        PUNCT_TOKEN_RE.test(tok) ||
        /^\d/.test(tok) ||
        ABBREV_RE.test(tok),
    )
  ) {
    return true;
  }
  return false;
}

let files = [];
try {
  files = fs.readdirSync(EN).filter((f) => f.endsWith('.json'));
} catch {
  process.exit(0);
}

const totals = {
  keys: 0,
  translated: 0,
  missingEnglish: 0,
  cjkInEn: 0,
  keep: 0,
  heuristic: 0,
  untranslatedProse: 0,
};
const rows = [];

for (const f of files) {
  let en;
  try {
    en = JSON.parse(fs.readFileSync(path.join(EN, f), 'utf8'));
  } catch {
    continue;
  }
  if (!en || typeof en !== 'object' || Array.isArray(en)) continue;
  let zh = {};
  try {
    zh = JSON.parse(fs.readFileSync(path.join(ZH, f), 'utf8'));
  } catch {
    /* 整档缺失 */
  }
  const n = {
    keys: 0,
    translated: 0,
    missingEnglish: 0,
    cjkInEn: 0,
    keep: 0,
    heuristic: 0,
    untranslatedProse: 0,
  };
  for (const [k, ev] of Object.entries(en)) {
    if (typeof ev !== 'string') continue;
    n.keys++;
    const cjk = isCjkInEn(ev);
    if (cjk) n.cjkInEn++;
    if (!(k in zh)) {
      if (cjk) continue;
      n.missingEnglish++;
      continue;
    }
    const zv = zh[k];
    if (zv !== ev) {
      n.translated++;
      continue;
    }
    if (cjk) continue;
    if (isKeep(k, ev)) n.keep++;
    else if (isHeuristicSkip(ev)) n.heuristic++;
    else n.untranslatedProse++;
  }
  for (const key of Object.keys(n)) totals[key] += n[key];
  const actionable = n.missingEnglish + n.untranslatedProse;
  if (actionable > 0 || n.cjkInEn > 0) {
    rows.push({ f, ...n, actionable });
  }
}

rows.sort((a, b) => b.actionable - a.actionable);

if (WANT_JSON) {
  console.log(JSON.stringify({ totals, files: rows }, null, 2));
  process.exit(0);
}

console.log(`   翻译覆盖率（en 共 ${totals.keys} 条）：`);
console.log(`     已译                         ${totals.translated}`);
console.log(`     真缺失（英文源、zh 无 key）   ${totals.missingEnglish}`);
console.log(`     未译散文（zh==en，像该翻）    ${totals.untranslatedProse}`);
console.log(`     keep-english                 ${totals.keep}`);
console.log(`     启发式跳过（标识符/单位/缩写） ${totals.heuristic}`);
console.log(`     源已是中文（en 含汉字）       ${totals.cjkInEn}`);
console.log(
  '   待翻 = 真缺失 + 未译散文。CJK-in-en 是 verb 注入污染，不是漏译；启发式跳过不要送 MT。',
);
console.log('   补缺失：`bun tools/i18n/mt/i18n-mt.ts`（默认只补缺失 key）。');

const shown = rows.filter((r) => r.actionable > 0).slice(0, 15);
for (const r of shown) {
  console.log(
    `     ${r.f.padEnd(20)} 缺${String(r.missingEnglish).padStart(4)}  散文${String(r.untranslatedProse).padStart(4)}  汉字源${String(r.cjkInEn).padStart(4)}  keep${String(r.keep).padStart(4)}  跳过${String(r.heuristic).padStart(4)}`,
  );
}
const extra = rows.filter((r) => r.actionable > 0).length - shown.length;
if (extra > 0) console.log(`     …还有 ${extra} 个命名空间有待翻缺口。`);
