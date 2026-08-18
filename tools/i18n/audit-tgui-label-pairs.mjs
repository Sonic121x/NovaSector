#!/usr/bin/env bun
// 审计：`tgui-catalog.mjs extract` 之后，tgui 目录里**相对 git HEAD 新增的键**有没有引入
// 「凭空的 en -> zh 词对」。
//
// 为什么要审：strings/i18n/<locale>/tgui.json 会被 DM 侧 build_i18n_cache 一并扫进**全局反查表**
// （`lang_reverse_text` / 字面 AC 都吃它）。往里塞一个从未在别处出现过的词对，等于给整个 DM 侧新增
// 一片误翻面——线缆颜色（blue/purple/gold）那次就是这么被 i18n_real_catalog 当场抓住的。
// 合规的新键只有两种：① 值沿用其它命名空间已有的同英文译文；② 没有译文（值等于英文，sync() 会滤掉）。
//
// 用法：bun tools/i18n/audit-tgui-label-pairs.mjs [--base HEAD]
// 退出码 0 = 干净；1 = 有新造词对或与既有译文冲突（需人工确认后再提交）。
import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

const ROOT = execFileSync('git', ['rev-parse', '--show-toplevel'], {
  encoding: 'utf8',
}).trim();
const baseIdx = process.argv.indexOf('--base');
const BASE = baseIdx > 0 ? process.argv[baseIdx + 1] : 'HEAD';
const LOCALE = 'zh-Hans';

const readWorking = (rel) =>
  JSON.parse(fs.readFileSync(path.join(ROOT, rel), 'utf8'));
const readBase = (rel) => {
  try {
    return JSON.parse(
      execFileSync('git', ['show', `${BASE}:${rel}`], {
        encoding: 'utf8',
        cwd: ROOT,
        maxBuffer: 1 << 28,
      }),
    );
  } catch {
    return {};
  }
};

const enNew = readWorking('strings/i18n/en/tgui.json');
const zhNew = readWorking(`strings/i18n/${LOCALE}/tgui.json`);
const enBase = readBase('strings/i18n/en/tgui.json');
const zhBase = readBase(`strings/i18n/${LOCALE}/tgui.json`);

// 既有词对 = base 版本里所有命名空间（含 tgui 自己）的 en -> {zh…}
const pairs = new Map();
const addPairs = (en, zh) => {
  for (const [key, value] of Object.entries(en)) {
    if (typeof value !== 'string') continue;
    const translated = zh[key];
    if (typeof translated !== 'string' || translated === value) continue;
    if (!pairs.has(value)) pairs.set(value, new Set());
    pairs.get(value).add(translated);
  }
};
for (const file of fs.readdirSync(path.join(ROOT, 'strings/i18n/en'))) {
  if (!file.endsWith('.json')) continue;
  addPairs(
    readBase(`strings/i18n/en/${file}`),
    readBase(`strings/i18n/${LOCALE}/${file}`),
  );
}
addPairs(enBase, zhBase);

const invented = [];
const conflicting = [];
let reused = 0;
let untranslated = 0;
for (const key of Object.keys(enNew)) {
  if (key in enBase) continue;
  const english = enNew[key];
  const translated = zhNew[key];
  if (typeof translated !== 'string' || translated === english) {
    untranslated++;
    continue;
  }
  const known = pairs.get(english);
  if (!known) invented.push([english, translated]);
  else if (known.has(translated)) reused++;
  else conflicting.push([english, translated, [...known].slice(0, 2)]);
}

console.log(
  `新增键 ${Object.keys(enNew).filter((k) => !(k in enBase)).length}：沿用既有词对 ${reused}，未翻译 ${untranslated}，新造词对 ${invented.length}，与既有译文冲突 ${conflicting.length}`,
);
for (const [english, translated] of invented.slice(0, 20))
  console.log(`  新造  ${english} -> ${translated}`);
for (const [english, translated, known] of conflicting.slice(0, 20))
  console.log(
    `  冲突  ${english} -> ${translated}（既有 ${known.join(' / ')}）`,
  );
if (invented.length || conflicting.length) {
  console.error(
    '\n有新造/冲突词对：它们会进 DM 侧全局反查表。确认每一条都不是标识符形态后再提交，否则改抽取规则。',
  );
  process.exit(1);
}
