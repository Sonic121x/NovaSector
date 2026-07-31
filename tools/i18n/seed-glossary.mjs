#!/usr/bin/env node
/**
 * 从目录里**自动播种「规范名」进术语表**，让译名一致性由工具保证，而不是靠人一条条报、一条条改。
 *
 * 要解决的问题：一个专名（试剂/物品名）在目录里有一条**规范条目**（`Multiver` → 多功能解毒剂），
 * 但它还会出现在几十条别的英文串里（"A small bottle of Multiver."、"30 units of Multiver"、
 * "Multiver Pill"…）。那些串是各自独立翻译的，MT 每次现编一个译法 → 同一个东西在游戏里叫
 * 多元维 / 多效解毒剂 / 多功能解毒剂。玩家一条条报、我们一条条改，永远改不完。
 *
 * 通解：把规范名喂给术语表。之后
 *   ① `i18n-mt.ts terms`        —— 扫出所有「英文里有该词、但译文没用规范译名」的条目；
 *   ② `i18n-mt.ts repair-terms` —— 批量重译这些条目；
 *   ③ 以后新串在翻译时就带着术语提示，不会再跑偏。
 *
 * 播种判据（保守，宁可少播不可错播）：
 *   - 英文值是**短名词性短语**：1–4 个词、无句末标点、非全大写缩写、长度 ≥ 4；
 *   - 该英文值**整词出现在至少 N 条其它英文串里**（默认 3）—— 说明它确实会被反复提及，
 *     值得锁定；只出现一次的名字锁了也没意义；
 *   - 已有译文且译文 ≠ 英文（未译/保留英文的不播）；
 *   - 术语表里还没有（**绝不覆盖人工条目**）。
 *
 * 用法：
 *   node tools/i18n/seed-glossary.mjs            # 只报告，不写盘
 *   node tools/i18n/seed-glossary.mjs --write    # 写入 glossary.zh-Hans.json
 *   node tools/i18n/seed-glossary.mjs --min-refs 5 --limit 200
 */
import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.join(import.meta.dirname, '..', '..');
const LOCALE = process.env.I18N_LOCALE ?? 'zh-Hans';
const EN_DIR = path.join(ROOT, 'strings/i18n/en');
const ZH_DIR = path.join(ROOT, 'strings/i18n', LOCALE);
const GLOSSARY = path.join(ROOT, `tools/i18n/mt/glossary.${LOCALE}.json`);

const argv = process.argv.slice(2);
const WRITE = argv.includes('--write');
const MIN_REFS = Number(argv[argv.indexOf('--min-refs') + 1]) || 3;
const LIMIT = Number(argv[argv.indexOf('--limit') + 1]) || Infinity;

function loadDir(dir) {
  const out = {};
  if (!fs.existsSync(dir)) return out;
  for (const f of fs.readdirSync(dir)) {
    if (!f.endsWith('.json')) continue;
    try {
      Object.assign(out, JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8')));
    } catch {
      /* 手维护文件可能有非扁平结构，跳过 */
    }
  }
  return out;
}

const en = loadDir(EN_DIR);
const zh = loadDir(ZH_DIR);
const glossary = fs.existsSync(GLOSSARY)
  ? JSON.parse(fs.readFileSync(GLOSSARY, 'utf8'))
  : {};

const SENTENCE_END = /[.!?。！？:;,]$/;
const HAS_MARKUP = /[<>{}[\]\\]/;

/** 是否像一个「专名」——值得锁定译法的短名词短语。 */
function isCanonicalName(text) {
  if (typeof text !== 'string') return false;
  const t = text.trim();
  if (t !== text || t.length < 4 || t.length > 40) return false;
  if (SENTENCE_END.test(t) || HAS_MARKUP.test(t)) return false;
  // 必须以字母开头：排除 ".357 bullet" / ", the" / "*pop*" / "~ Blink" / "(Default)" 这类
  // 非名词性碎片（它们混进术语表只会把噪音固化下来）。
  if (!/^[A-Za-z]/.test(t)) return false;
  const words = t.split(/\s+/);
  if (words.length > 4) return false;
  // 全大写缩写（NT/AI/ERT）交给人工，自动播种容易误伤
  if (t === t.toUpperCase() && t.length <= 5) return false;
  // **专名形态**：至少一个词首字母大写（Multiver / Delta Station / Syriniver Bottle）。
  // 纯小写的通用短语（"a bug" / "crafting component"）不是专名，锁定它们会让 MT 在正常
  // 句子里被强行套用，弊大于利 —— 那类一致性交给上下文，不进术语表。
  if (!words.some((w) => /^[A-Z]/.test(w))) return false;
  // 冠词开头的多半是句子碎片而非名字
  if (/^(A|An|The)\s/i.test(t)) return false;
  return true;
}

function escapeRe(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// 候选：规范名 -> 译文
const candidates = new Map();
for (const [key, value] of Object.entries(en)) {
  if (!isCanonicalName(value)) continue;
  const translated = zh[key];
  if (typeof translated !== 'string' || !translated || translated === value) continue;
  if (value in glossary) continue;
  // 同一英文在不同命名空间可能有多条；译文不一致的先跳过交人工（本身就是要修的目标）
  const prev = candidates.get(value);
  if (prev && prev !== translated) {
    candidates.set(value, null); // 标记冲突
    continue;
  }
  if (!prev) candidates.set(value, translated);
}

// 统计每个候选被别的英文串提及的次数
const allEnValues = Object.values(en).filter((v) => typeof v === 'string');
const seeds = [];
const conflicts = [];
for (const [term, translated] of candidates) {
  if (translated === null) {
    conflicts.push(term);
    continue;
  }
  const re = new RegExp(`(^|[^A-Za-z0-9])${escapeRe(term)}($|[^A-Za-z0-9])`);
  let refs = 0;
  for (const v of allEnValues) {
    if (v !== term && re.test(v)) {
      refs++;
      if (refs >= MIN_REFS) break;
    }
  }
  if (refs >= MIN_REFS) seeds.push({ term, zh: translated, refs });
}

seeds.sort((a, b) => b.refs - a.refs || a.term.localeCompare(b.term));
const picked = seeds.slice(0, LIMIT);

console.log(`目录条目 en=${Object.keys(en).length} zh=${Object.keys(zh).length}`);
console.log(`术语表现有 ${Object.keys(glossary).length} 条`);
console.log(
  `候选规范名 ${candidates.size} 个；被 ≥${MIN_REFS} 条其它串提及、可播种：${seeds.length} 个`,
);
if (conflicts.length) {
  console.log(
    `\n跳过 ${conflicts.length} 个**同一英文已有多种译文**的（这些本身就是要修的，先人工定规范译名）：`,
  );
  for (const t of conflicts.slice(0, 15)) console.log(`   ${t}`);
}
console.log('\n播种样例（按被提及次数排序）：');
for (const s of picked.slice(0, 20)) {
  console.log(`   ${s.refs.toString().padStart(3)}×  ${s.term}  ->  ${s.zh}`);
}

if (!WRITE) {
  console.log('\n（未写盘。加 --write 落库，然后跑 `bun tools/i18n/mt/i18n-mt.ts terms` 看违规量）');
  process.exit(0);
}

for (const s of picked) {
  glossary[s.term] = {
    zh: s.zh,
    note: `自动播种：目录规范名，被 ${s.refs}+ 条其它串提及，须保持一致`,
  };
}
const sorted = {};
for (const k of Object.keys(glossary).sort()) sorted[k] = glossary[k];
fs.writeFileSync(GLOSSARY, `${JSON.stringify(sorted, null, 2)}\n`);
console.log(`\n已写入 ${picked.length} 条 → ${path.relative(ROOT, GLOSSARY)}`);
