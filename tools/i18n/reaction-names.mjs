#!/usr/bin/env node
// NovaSector 全量汉化：化学反应「没有产物试剂」时的兜底显示名。
//
// 为什么单独一步、而且**不能进主目录**：
//   `/datum/chemical_reaction` 压根没有 `name` 变量。反应查询界面（ui_data.dm）对没有 results
//   的反应，显示名是运行期从**类型路径末段**现切出来的：
//       var/list/names = splittext("[reaction.type]", "/")
//       data["reagent_mode_recipe"] = list("name" = names[names.len], "id" = reaction.type, …)
//   源码里没有任何字面量，抽取器按定义够不着 —— 玩家看到的就是 `omegasoapification`。
//
//   把这批算出来塞进主目录**试过，不行**：全仓 117 条里混着 `heat` / `holy` / `life` / `soup` /
//   `spider` / `foam` 这类通用单词（类型路径末段按定义就是标识符形态），进全局反查表当场把
//   `nova-i18n lint` 的碰撞告警从 54 顶到 61。所以它只能是**域内表**：顶层放置 → 不被
//   build_i18n_cache 合并进反查表，只由那一个显示点显式查表。
//
// 产物 `strings/i18n/reaction_names.json` 与 slime_colours.json / wire_colours.json 同形态。
// **只合并、不裁剪**：上游删掉某个配方不会让已有译文消失。
//
// 用法：node tools/i18n/reaction-names.mjs   （幂等；上游同步后跑一次）

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(import.meta.dirname, '../..');
const RECIPE_DIR = path.join(ROOT, 'code/modules/reagents/chemistry/recipes');
const OUT = path.join(ROOT, 'strings/i18n/reaction_names.json');
const LOCALE = 'zh-Hans';

function* dmFiles(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) yield* dmFiles(full);
    else if (entry.name.endsWith('.dm')) yield full;
  }
}

/// 收集「自己声明了 required_reagents、但没有 results」的反应类型。
///
/// **required_reagents 这道闸不能省**：不加它，抽出来的一大半是抽象父类型
/// （`/datum/chemical_reaction/food`、`/slime`、`/drink`），玩家在查询界面根本见不到。
function collectTypes() {
  const derived = new Set();
  for (const file of dmFiles(RECIPE_DIR)) {
    let current = null;
    let hasResults = false;
    let hasReagents = false;
    const flush = () => {
      if (current && hasReagents && !hasResults) derived.add(current);
      current = null;
      hasResults = false;
      hasReagents = false;
    };
    for (const line of fs.readFileSync(file, 'utf8').split('\n')) {
      const header = /^\/datum\/chemical_reaction\/([\w/]+)\s*$/.exec(line.replace(/\r$/, ''));
      if (header) {
        flush();
        current = header[1].split('/').pop();
        continue;
      }
      if (/^\//.test(line)) {
        flush();
        continue;
      }
      if (!current) continue;
      if (/^\s+results\s*=/.test(line)) hasResults = true;
      if (/^\s+required_reagents\s*=/.test(line)) hasReagents = true;
    }
    flush();
  }
  // ui_data.dm 只切末段，不做 _ → 空格替换，照抄它的算法。
  return [...derived].sort();
}

const existing = fs.existsSync(OUT)
  ? JSON.parse(fs.readFileSync(OUT, 'utf8'))
  : {
      _comment:
        '化学反应在「没有产物试剂」时的兜底显示名（ui_data.dm 从类型路径末段现切）。' +
        '顶层放置=不被 build_i18n_cache 合并进全局反查表——这些值按定义是类型路径末段、' +
        '标识符形态（heat/holy/life/soup…），进反查表必然误伤。由 lang_reaction_name() 显式查表。' +
        '由 tools/i18n/reaction-names.mjs 生成骨架，译文人工填；未填的保持英文，不影响显示。',
    };

const table = existing[LOCALE] ?? {};
let added = 0;
for (const name of collectTypes()) {
  if (!(name in table)) {
    table[name] = name;
    added += 1;
  }
}
existing[LOCALE] = Object.fromEntries(Object.entries(table).sort(([a], [b]) => (a < b ? -1 : 1)));
fs.writeFileSync(OUT, `${JSON.stringify(existing, null, '\t')}\n`);
console.log(`reaction_names.json：新增 ${added} 条，共 ${Object.keys(existing[LOCALE]).length} 条`);
