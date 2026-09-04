#!/usr/bin/env node
// 一次性目录卫生：从 en 主目录摘掉「源值含汉字」的旧键（verb 注入污染）。
//
// 目录只合并不裁剪，extract 的 contains_cjk 闸只能挡住新抽，挡不住已经写进去的旧键。
// 本脚本必须手工跑；不要接到 extract / resync。
//
// 用法：
//   node tools/i18n/prune-cjk-en.mjs              # 删 CJK-in-en 孤儿键（及 zh 同 key）
//   node tools/i18n/prune-cjk-en.mjs --keep-english  # 再清 keep-english 里「后来已有真译文」的过期项
//
// 不碰：tgui.json（除非真有 CJK）、_state_words.json、顶层 scoped 表、
// LANG() 仍引用的 key、type_vars.json 仍指向的 key（删了就是悬空 / 显示边界 miss）。
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const EN_DIR = path.join(ROOT, 'strings/i18n/en');
const ZH_DIR = path.join(ROOT, 'strings/i18n/zh-Hans');
const TYPE_VARS = path.join(ROOT, 'strings/i18n/type_vars.json');
const KEEP = path.join(ROOT, 'tools/i18n/mt/keep-english.zh-Hans.json');
const CJK_RE = /[\u3400-\u9FFF\uF900-\uFAFF]/;
const WANT_KEEP_ENGLISH = process.argv.includes('--keep-english');

const SKIP_FILES = new Set(['tgui.json', '_state_words.json']);

/** 只删点名的 key，保留该文件原有 indent / 换行 / key 顺序。禁止 JSON.stringify 整份重排。 */
export function removeKeysPreservingFormat(filePath, keysToRemove) {
  const remove = new Set(keysToRemove);
  if (!fs.existsSync(filePath) || remove.size === 0) {
    return { removed: 0, skipped: true };
  }
  const before = fs.readFileSync(filePath, 'utf8');
  let data;
  try {
    data = JSON.parse(before);
  } catch (err) {
    throw new Error(`${filePath}: JSON 解析失败：${err.message}`);
  }
  if (!data || typeof data !== 'object' || Array.isArray(data)) {
    throw new Error(`${filePath}: 不是扁平对象目录`);
  }
  const present = [...remove].filter((k) => Object.hasOwn(data, k));
  if (present.length === 0) {
    return { removed: 0, skipped: true };
  }
  const drop = new Set(present);

  const lines = before.split('\n');
  const kept = [];
  let removedLines = 0;
  for (const line of lines) {
    const m = line.match(/^[ \t]*("(?:\\.|[^"\\])*")\s*:/);
    if (m) {
      let key;
      try {
        key = JSON.parse(m[1]);
      } catch {
        kept.push(line);
        continue;
      }
      if (drop.has(key)) {
        removedLines++;
        continue;
      }
    }
    kept.push(line);
  }

  let lastProp = -1;
  for (let i = kept.length - 1; i >= 0; i--) {
    const t = kept[i].trim();
    if (t === '' || t === '}') continue;
    if (t === '{') break;
    lastProp = i;
    break;
  }
  if (lastProp >= 0) {
    kept[lastProp] = kept[lastProp].replace(/,(\s*)$/, '$1');
  }

  let after = kept.join('\n');
  if (before.endsWith('\n') && !after.endsWith('\n')) after += '\n';

  const beforeLines = before.split('\n').length;
  const afterLines = after.split('\n').length;
  const delta = beforeLines - afterLines;
  if (Math.abs(delta - present.length) > 1) {
    throw new Error(
      `${filePath}: 删了 ${present.length} 个 key，但行数变化 ${delta}（疑似整份重排，已中止写盘）`,
    );
  }

  fs.writeFileSync(filePath, after);
  return { removed: present.length, skipped: false, lineDelta: delta };
}

function walkDm(dir, visit) {
  if (!fs.existsSync(dir)) return;
  for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
    if (ent.name === '.git' || ent.name === 'node_modules') continue;
    const p = path.join(dir, ent.name);
    if (ent.isDirectory()) walkDm(p, visit);
    else if (ent.name.endsWith('.dm')) visit(p, fs.readFileSync(p, 'utf8'));
  }
}

function collectLangKeys() {
  const keys = new Set();
  const re = /LANG(?:U)?\(\s*"([A-Za-z_][A-Za-z0-9_]*\.[0-9a-f]{16})"/g;
  for (const root of ['code', 'modular_nova', 'interface']) {
    walkDm(path.join(ROOT, root), (_p, text) => {
      re.lastIndex = 0;
      let m;
      while ((m = re.exec(text))) keys.add(m[1]);
    });
  }
  return keys;
}

function collectTypeVarKeys() {
  const keys = new Set();
  if (!fs.existsSync(TYPE_VARS)) return keys;
  const tv = JSON.parse(fs.readFileSync(TYPE_VARS, 'utf8'));
  for (const table of Object.values(tv)) {
    if (!table || typeof table !== 'object') continue;
    for (const v of Object.values(table)) {
      if (typeof v === 'string') keys.add(v);
    }
  }
  return keys;
}

function pruneCjk() {
  const langKeys = collectLangKeys();
  const typeVarKeys = collectTypeVarKeys();
  const files = fs.readdirSync(EN_DIR).filter((f) => f.endsWith('.json'));
  const byFile = [];
  let keptLive = 0;
  let keptTypeVar = 0;
  let skippedTgui = 0;

  for (const f of files) {
    const enPath = path.join(EN_DIR, f);
    const en = JSON.parse(fs.readFileSync(enPath, 'utf8'));
    const cjkKeys = [];
    for (const [k, v] of Object.entries(en)) {
      if (typeof v !== 'string' || !CJK_RE.test(v)) continue;
      if (f === 'tgui.json') {
        skippedTgui++;
        continue;
      }
      if (SKIP_FILES.has(f)) continue;
      if (langKeys.has(k)) {
        keptLive++;
        continue;
      }
      if (typeVarKeys.has(k)) {
        keptTypeVar++;
        continue;
      }
      cjkKeys.push(k);
    }
    if (!cjkKeys.length) continue;
    byFile.push({ f, keys: cjkKeys });
  }

  if (skippedTgui) {
    console.log(`tgui.json 有 ${skippedTgui} 条 CJK，按约定不删`);
  }
  console.log(
    `保留 LANG 仍引用 ${keptLive} 条、type_vars 仍指向 ${keptTypeVar} 条（删了会悬空 / 显示边界 miss）`,
  );

  let total = 0;
  for (const { f, keys } of byFile) {
    const enRes = removeKeysPreservingFormat(path.join(EN_DIR, f), keys);
    const zhRes = removeKeysPreservingFormat(path.join(ZH_DIR, f), keys);
    total += enRes.removed;
    console.log(
      `${f}: en -${enRes.removed}（行 ${enRes.lineDelta ?? 0}）  zh -${zhRes.removed}（行 ${zhRes.lineDelta ?? 0}）`,
    );
  }
  console.log(`CJK-in-en 孤儿键共删 ${total} 条，涉及 ${byFile.length} 个命名空间`);
  return { total, byFile, keptLive, keptTypeVar };
}

function relatedCatalogHits(keepKey, keepVal, enByKey, keysByEnVal) {
  if (enByKey.has(keepKey)) return [keepKey];
  return keysByEnVal.get(keepKey) || keysByEnVal.get(keepVal) || [];
}

function pruneKeepEnglish() {
  const files = fs.readdirSync(EN_DIR).filter((f) => f.endsWith('.json'));
  const enByKey = new Map();
  const zhByKey = new Map();
  const keysByEnVal = new Map();
  for (const f of files) {
    let en;
    let zh = {};
    try {
      en = JSON.parse(fs.readFileSync(path.join(EN_DIR, f), 'utf8'));
    } catch {
      continue;
    }
    try {
      zh = JSON.parse(fs.readFileSync(path.join(ZH_DIR, f), 'utf8'));
    } catch {
      /* 整档缺失 */
    }
    for (const [k, ev] of Object.entries(en)) {
      if (typeof ev !== 'string') continue;
      enByKey.set(k, ev);
      zhByKey.set(k, zh[k]);
      if (!keysByEnVal.has(ev)) keysByEnVal.set(ev, []);
      keysByEnVal.get(ev).push(k);
    }
  }

  const keep = JSON.parse(fs.readFileSync(KEEP, 'utf8'));
  const stale = [];
  let valid = 0;
  let bilingual = 0;
  let dangling = 0;
  for (const [keepKey, keepVal] of Object.entries(keep)) {
    const related = relatedCatalogHits(keepKey, keepVal, enByKey, keysByEnVal);
    if (!related.length) {
      dangling++;
      continue;
    }
    const enHasCjk = related.some((k) => CJK_RE.test(enByKey.get(k)));
    if (enHasCjk) {
      bilingual++;
      continue;
    }
    const allTranslated = related.every((k) => {
      const ev = enByKey.get(k);
      const zv = zhByKey.get(k);
      return zv != null && zv !== ev;
    });
    if (allTranslated) stale.push(keepKey);
    else valid++;
  }

  console.log(
    `keep-english 共 ${Object.keys(keep).length} 条：过期（已有真译文）${stale.length}，仍有效 ${valid}，双语源保留 ${bilingual}，目录里已无对应 ${dangling}`,
  );
  const res = removeKeysPreservingFormat(KEEP, stale);
  console.log(`已从 keep-english 删除 ${res.removed} 条过期项`);
  return { stale: res.removed, valid, bilingual, dangling, remaining: valid + bilingual + dangling };
}

const cjk = pruneCjk();
if (WANT_KEEP_ENGLISH) {
  pruneKeepEnglish();
} else {
  console.log('（未清 keep-english。加 --keep-english 只删「后来已有真译文」的项。）');
}

if (cjk.total === 0 && !WANT_KEEP_ENGLISH) {
  console.log('没有可删的 CJK 孤儿键。');
}
