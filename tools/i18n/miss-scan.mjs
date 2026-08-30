#!/usr/bin/env node
// i18n 漏翻日志聚合分类器。
//
// 输入：一份或多份运行期漏翻日志（miss_log.dm 产出的 data/logs/<round>/i18n_misses.log，
// 行格式 `[ts] n=N src=SRC | text`）。跨回合聚合出现次数（同一串取每份日志内最大 n 再求和），
// 按 AGENTS.md「目录已译却显英文」排查规律自动归类：
//   [已译未接通]  串在 en 目录且 zh 已译 → 显示路径绕过了翻译层，去落地点补反查/接 sink
//   [在目录未译]  串在 en 目录但 zh==en → 待译或 keep-english 白名单，跑 MT / 人工判断
//   [目录片段]    串是某条 en 目录值的子串 → AC 最短匹配拆碎/部分替换，落地点先整串反查
//   [没进目录]    en 目录里找不到 → 抽取器漏抽（config 数据/构造参数/插值句），补抽取源
//
// 用法：
//   node tools/i18n/miss-scan.mjs data/logs/<round>/i18n_misses.log [more.log ...]
//   cat *.log | node tools/i18n/miss-scan.mjs          # 也可从 stdin 读
//   node tools/i18n/miss-scan.mjs --min 3 <logs>       # 只看总次数 ≥3 的
//   node tools/i18n/miss-scan.mjs --json <logs>        # 机器可读输出
//   node tools/i18n/miss-scan.mjs --baseline tools/i18n/miss-baseline.txt <logs>
//       只对新增 (src, 归一化 text) 非零退出。行不 trim 行首空格（规则 D 同款）。
//       基线不存在或含 # UNINITIALIZED：首次对比会写入当前 miss，不会当成 0 条。
//   node tools/i18n/miss-scan.mjs --baseline tools/i18n/miss-baseline.txt --update-baseline <logs>
//       只重写 miss 基线，不碰 identifier-baseline.txt / bare-english-baseline.txt。
//   node tools/i18n/miss-scan.mjs --emit-pending <logs>
//       把「在目录未译」桶导出成 MT 优先清单（tools/i18n/mt/.pending/miss-priority.json，
//       {"obj.json": [key...]}），再用 I18N_ONLY_KEYS 只翻玩家实际看到的那批：
//       I18N_ONLY_KEYS=tools/i18n/mt/.pending/miss-priority.json bun tools/i18n/mt/i18n-mt.ts

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');

const DEFAULT_MISS_BASELINE = path.join(repoRoot, 'tools', 'i18n', 'miss-baseline.txt');

const args = process.argv.slice(2);
let minCount = 1;
let asJson = false;
let emitPending = false;
let baselinePath = null;
let updateBaseline = false;
const files = [];
for (let i = 0; i < args.length; i++) {
  const a = args[i];
  if (a === '--min') minCount = Number(args[++i]) || 1;
  else if (a === '--json') asJson = true;
  else if (a === '--emit-pending') emitPending = true;
  else if (a === '--update-baseline') updateBaseline = true;
  else if (a === '--baseline') {
    const v = args[++i];
    if (!v || v.startsWith('--')) {
      console.error('--baseline 需要路径（例如 tools/i18n/miss-baseline.txt）');
      process.exit(2);
    }
    baselinePath = v;
  } else if (a === '-h' || a === '--help') {
    console.log(`用法：node tools/i18n/miss-scan.mjs [选项] [i18n_misses.log ...]
  --min N              只看总次数 ≥N
  --json               机器可读
  --baseline PATH      只对新增 (src, text) 非零退出
  --update-baseline    只重写 miss 基线（默认同 --baseline 缺省路径）
  --emit-pending       导出「在目录未译」给 MT`);
    process.exit(0);
  } else files.push(a);
}
if (updateBaseline && !baselinePath) baselinePath = DEFAULT_MISS_BASELINE;

// ---- 读日志，跨文件聚合 ----
// src 允许连字符：`tgui-ui` 用 `\w+` 匹配不到，整类会被静默丢掉（不是报 0 条，是**一行都不解析**）。
const LINE_RE = /n=(\d+) src=([\w-]+) \| (.*)$/;
/** text -> { count, sources:Set } */
const misses = new Map();

function ingest(content) {
  /** 本份日志内每串的最大 n（阈值行 1/10/100/1000 取最大） */
  const perFile = new Map();
  for (const line of content.split('\n')) {
    const m = LINE_RE.exec(line);
    if (!m) continue;
    const [, n, src, rest] = m;
    // **首次记录那行带着 ` || 整行: …` / ` || 来源: …` 上下文**（miss_log.dm 写的）。切掉再当键：
    // 不切的话 n=1 那行的键带着上下文，与 en 目录永远对不上，整批首次记录会被误判成「没进目录」
    // —— 而绝大多数串只出现一次，等于整份报告的分类全错。
    const sep = rest.indexOf(' || ');
    const text = sep < 0 ? rest : rest.slice(0, sep);
    const hint = sep < 0 ? '' : rest.slice(sep + 4);
    const count = Number(n);
    const prev = perFile.get(text);
    if (!prev) {
      perFile.set(text, {
        count,
        sources: new Set([src]),
        hints: new Set(hint ? [hint] : []),
      });
    } else {
      if (count > prev.count) prev.count = count;
      prev.sources.add(src);
      if (hint) prev.hints.add(hint);
    }
  }
  for (const [text, { count, sources, hints }] of perFile) {
    const entry = misses.get(text) ?? { count: 0, sources: new Set(), hints: new Set() };
    entry.count += count;
    for (const s of sources) entry.sources.add(s);
    for (const h of hints) entry.hints.add(h);
    misses.set(text, entry);
  }
}

if (files.length) {
  for (const f of files) ingest(fs.readFileSync(f, 'utf8'));
} else {
  ingest(fs.readFileSync(0, 'utf8'));
}
if (!misses.size) {
  console.error('没有解析到任何 miss 行（确认输入是 i18n_misses.log）');
  process.exit(1);
}

function normalizeMissText(text) {
  return text.replaceAll('\n', '\\n');
}

function missKey(src, text) {
  return `${src}\t${normalizeMissText(text)}`;
}

function currentMissKeys() {
  const keys = [];
  for (const [text, { count, sources }] of misses) {
    if (count < minCount) continue;
    for (const src of sources) keys.push(missKey(src, text));
  }
  keys.sort();
  return keys;
}

function loadMissBaseline(filePath) {
  if (!fs.existsSync(filePath)) return { state: 'missing', keys: new Set() };
  const keys = new Set();
  let sawUninit = false;
  for (const line of fs.readFileSync(filePath, 'utf8').split('\n')) {
    const l = line.endsWith('\r') ? line.slice(0, -1) : line;
    if (!l.trim()) continue;
    if (l.trimStart().startsWith('#')) {
      if (l.trimStart().startsWith('# UNINITIALIZED')) sawUninit = true;
      continue;
    }
    keys.add(l);
  }
  if (keys.size === 0 && sawUninit) return { state: 'uninitialized', keys };
  return { state: 'ready', keys };
}

function writeMissBaseline(filePath, keys) {
  const header =
    '# nova-i18n 漏翻增量基线（`node tools/i18n/miss-scan.mjs --update-baseline` 生成）。\n' +
    '# 每行一条 `src<TAB>text`。text 已切掉 ` || 整行/来源` 上下文，**不 trim 行首空格**。\n' +
    '# 只对不在此表的新增 (src, text) 失败。本命令只写本文件，不改 identifier-baseline.txt / bare-english-baseline.txt。\n';
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, header + (keys.length ? `${keys.join('\n')}\n` : ''));
}

function applyBaselineGate() {
  if (!baselinePath) return 0;
  const dest = path.resolve(repoRoot, baselinePath);
  const loaded = loadMissBaseline(dest);
  const current = currentMissKeys();
  if (updateBaseline || loaded.state === 'missing' || loaded.state === 'uninitialized') {
    if (!updateBaseline) {
      const why = loaded.state === 'missing' ? '不存在' : '未初始化';
      console.error(
        `漏翻基线${why}：不会当成 0 条。正在写入 ${current.length} 条 → ${path.relative(repoRoot, dest)}`,
      );
      console.error(
        '此后只对新增 (src, text) 非零退出。刷新：--update-baseline（只改 miss-baseline.txt）',
      );
    }
    writeMissBaseline(dest, current);
    console.error(
      `已写入漏翻基线：${path.relative(repoRoot, dest)}（${current.length} 条）。未改 identifier-baseline.txt / bare-english-baseline.txt。`,
    );
    return 0;
  }
  const news = current.filter((k) => !loaded.keys.has(k));
  if (news.length) {
    console.error(`\n=== 新增漏翻（不在基线，${news.length} 条）===`);
    for (const k of news) {
      const tab = k.indexOf('\t');
      const src = tab < 0 ? '?' : k.slice(0, tab);
      const text = tab < 0 ? k : k.slice(tab + 1);
      console.error(`  (${src})  ${text}`);
    }
    console.error(
      '修法：新缺口则修抽取/落地层；已知噪音则\n' +
        '  node tools/i18n/miss-scan.mjs --baseline tools/i18n/miss-baseline.txt --update-baseline <logs>\n' +
        '（只更新 miss-baseline.txt）',
    );
    return 1;
  }
  console.error(`漏翻基线：${current.length} 条命中，新增 0 条`);
  return 0;
}

// ---- 加载目录 ----
const enDir = path.join(repoRoot, 'strings', 'i18n', 'en');
const zhDir = path.join(repoRoot, 'strings', 'i18n', 'zh-Hans');
/** en value -> { key, ns, translated } （同值多 key 时任取一，够定位） */
const enValues = new Map();
const fragmentsHaystack = [];
for (const file of fs.readdirSync(enDir).filter((f) => f.endsWith('.json'))) {
  const en = JSON.parse(fs.readFileSync(path.join(enDir, file), 'utf8'));
  const zhPath = path.join(zhDir, file);
  const zh = fs.existsSync(zhPath) ? JSON.parse(fs.readFileSync(zhPath, 'utf8')) : {};
  for (const [key, value] of Object.entries(en)) {
    if (typeof value !== 'string') continue;
    if (!enValues.has(value)) {
      enValues.set(value, { key, ns: file, translated: zh[key] !== undefined && zh[key] !== value });
    }
    if (value.length >= 12) fragmentsHaystack.push(value);
  }
}
// 片段检索用大 haystack（\x00 分隔防跨值误命中）
const haystack = fragmentsHaystack.join('\x00');

// ---- 前端目录（TGUI 渲染期查表）----
// 重构之后 tgui.json 不再进 DM 侧的目录桶（catalog-domains.json 把它标成 domain: tgui，
// 运行时加载器直接跳过），所以 P1 找不到译文、每个负载值都会刷一条 miss —— 而**前端**
// 的 bundle 里有译文，玩家看到的是中文。这类不是缺口，混进「已译未接通」会把真问题淹掉
// （实测一轮 419 行里占 81 行）。只对 DM 侧来源生效：tgui-ui 是前端自己报的 miss，
// 它在 bundle 里反而说明有别的问题，不能降噪。
const frontendCatalog = (() => {
  const p = path.join(repoRoot, 'tgui', 'packages', 'tgui', 'i18n', 'zh-Hans.json');
  if (!fs.existsSync(p)) return new Map();
  return new Map(
    Object.entries(JSON.parse(fs.readFileSync(p, 'utf8'))).filter(
      ([source, target]) => typeof target === 'string' && target !== source,
    ),
  );
})();
const isFrontendCovered = (text, sources) =>
  frontendCatalog.has(text) && !sources.includes('tgui-ui');

// ---- 口音替换词池（有意保英文，不进目录）----
// strings/*_replacement.json 是逐词/短语替换表（ork/鱼语/意式口音…），翻译会破坏替换机制，
// 按既定方针保持英文。它们每局都会刷 miss 日志 → 单独分桶降噪，别混进「没进目录」。
const poolWords = new Set();
const stringsDir = path.join(repoRoot, 'strings');
for (const file of fs.readdirSync(stringsDir).filter((f) => f.endsWith('_replacement.json'))) {
  const collect = (value) => {
    if (typeof value === 'string') {
      const s = value.trim().toLowerCase();
      if (s) poolWords.add(s);
    } else if (Array.isArray(value)) value.forEach(collect);
    else if (value && typeof value === 'object') Object.values(value).forEach(collect);
  };
  collect(JSON.parse(fs.readFileSync(path.join(stringsDir, file), 'utf8')));
}

// ---- 噪音识别（不值得处理的行，单独分桶降噪）----
// 1. CSS 声明：用户自定义 MOTD/公告 HTML 的内联样式经 fallback 层被逐行记录（"margin: 5px" 等）。
// 2. 管理员日志印记：JMP/FLW/VV 链接括号、build mode、deadmin、GC 硬删除告警、爆炸/EMP 尺寸行——
//    政策保英文（运行时已按 MESSAGE_TYPE_ADMINLOG/ATTACKLOG/DEBUG 跳过 fallback，旧日志仍会出现）。
const CSS_PROP_RE =
  /\b(px|rem|rgba?\(|linear-gradient|radial-gradient|font-(size|family|weight)|margin|padding|border|background|display|position|letter-spacing|text-align|box-shadow|align-items|justify-content|overflow|pointer-events|box-sizing|transition|text-shadow|background-(size|repeat|clip))\b/;
const ADMIN_LOG_RE =
  /\( ?(JMP|FLW|VV|SM|TP|LOGS|SMITE|PP) ?\)|has entered build mode|deadminned|deadmined|re-adminned|admin ghosted|took longer than .* seconds to delete|Explosion with size|EMP with size \(|- Playing as |is a (Game Admin|Host|Coder|Admin)\b|was selected\.$|reset the thunderdome/;
// 3. ckey / 贡献者名单：`pyritechimera, gabenyfox, draegonlore` —— 逗号分隔的全小写标识符串，
//    是人名不是文案。它们每局都会出现在偏好菜单/致谢页的负载里。
const CKEY_LIST_RE = /^[a-z0-9]+(?:, [a-z0-9]+)+$/;
// 4. 单测夹具的名字：套件驱动的漏翻采集里，被打的假人、被造的赛博格都叫这些名字。真实对局里
//    不存在，收进报告只会挤占位置（`John Doe` 还会顺带把 `You attack John` 这类整行拖进来）。
const TEST_FIXTURE_RE = /\b(Test Dummy|John Doe|Default Cyborg-\d+|consistent)\b/;
const isNoise = (text) =>
  (/[:;]/.test(text) && CSS_PROP_RE.test(text)) ||
  ADMIN_LOG_RE.test(text) ||
  CKEY_LIST_RE.test(text) ||
  TEST_FIXTURE_RE.test(text);

// ---- 归类 ----
const buckets = {
  前端已覆盖: [], // DM 侧查不到，但 TGUI bundle 有译文 → 渲染期由 TS 翻，不是缺口
  已译未接通: [], // 在目录且已译 → 路径绕过，落地点补反查
  在目录未译: [], // 在目录但 zh==en → MT/白名单判断
  目录片段: [], // 是某目录值的子串 → AC 拆碎，整串反查
  没进目录: [], // 抽取器漏抽 → 补抽取源/手维护文件
  词池保英文: [], // 口音替换词池 → 有意不译，纯降噪展示
  噪音: [], // CSS 声明/管理员日志印记 → 有意不译，纯降噪展示
};
for (const [text, { count, sources, hints }] of misses) {
  if (count < minCount) continue;
  const row = {
    text,
    count,
    sources: [...sources].join(','),
    hints: [...(hints ?? [])],
    catalog: null,
  };
  const hit = enValues.get(text);
  if (isFrontendCovered(text, row.sources)) {
    if (hit) row.catalog = `${hit.ns}#${hit.key}`;
    buckets['前端已覆盖'].push(row);
  } else if (hit) {
    row.catalog = `${hit.ns}#${hit.key}`;
    buckets[hit.translated ? '已译未接通' : '在目录未译'].push(row);
  } else if (poolWords.has(text.toLowerCase())) {
    buckets['词池保英文'].push(row);
  } else if (isNoise(text)) {
    buckets['噪音'].push(row);
  } else if (text.length >= 8 && haystack.includes(text)) {
    buckets['目录片段'].push(row);
  } else {
    buckets['没进目录'].push(row);
  }
}
for (const rows of Object.values(buckets)) rows.sort((a, b) => b.count - a.count);

// ---- 输出 ----
if (emitPending) {
  // 「在目录未译」桶 → MT 优先清单 {"<ns>.json": [key...]}，供 I18N_ONLY_KEYS 消费。
  const pending = {};
  for (const row of buckets['在目录未译']) {
    const [ns, key] = row.catalog.split('#');
    (pending[ns] ??= []).push(key);
  }
  const outDir = path.join(repoRoot, 'tools', 'i18n', 'mt', '.pending');
  fs.mkdirSync(outDir, { recursive: true });
  const outPath = path.join(outDir, 'miss-priority.json');
  fs.writeFileSync(outPath, JSON.stringify(pending, null, 2) + '\n');
  const total = Object.values(pending).reduce((sum, keys) => sum + keys.length, 0);
  console.log(`已导出 ${total} 条优先待译 key → ${path.relative(repoRoot, outPath)}`);
  console.log(
    '翻译：I18N_ONLY_KEYS=tools/i18n/mt/.pending/miss-priority.json bun tools/i18n/mt/i18n-mt.ts',
  );
  process.exit(0);
}
if (asJson) {
  console.log(JSON.stringify(buckets, null, 2));
  process.exit(applyBaselineGate());
}
const HINTS = {
  前端已覆盖: 'DM 侧查不到但前端 bundle 有译文 → 渲染期由 TS 本地化，不是缺口，无需处理',
  已译未接通: '译文就绪但显示路径绕过翻译层 → 找到落地点补 lang_reverse_text/lang_fallback_apply/接 sink',
  在目录未译: '在 en 目录但 zh 未译 → bun tools/i18n/mt/i18n-mt.ts 跑 MT，或确认属 keep-english 白名单',
  目录片段: '是某条目录值的子串（AC 最短匹配拆碎/部分替换）→ 该文本落地点先整串反查再进 fallback',
  没进目录: '抽取器没抽到（config 数据/new 构造参数/#define/运行期插值）→ 扩抽取源或手维护 _<feature>.json',
  词池保英文: '口音替换词池（strings/*_replacement.json），有意保英文 → 无需处理',
  噪音: 'CSS 声明（自定义 MOTD 样式）/管理员日志印记，有意保英文 → 无需处理',
};
for (const [name, rows] of Object.entries(buckets)) {
  if (!rows.length) continue;
  console.log(`\n=== ${name}（${rows.length} 条）===`);
  console.log(`    ${HINTS[name]}`);
  for (const row of rows) {
    const loc = row.catalog ? `  [${row.catalog}]` : '';
    console.log(`  ${String(row.count).padStart(5)}×  (${row.sources})${loc}  ${row.text}`);
    // 首次记录带的上下文（整行 / 调用点类型）是定位调用点最强的线索，别只打片段。
    for (const hint of row.hints) console.log(`           ↳ ${hint}`);
  }
}

// ---- 显示边界缺口按**类型**聚合 ----
// `display`/`desc` 两个来源带着 `src.type`（miss_log.dm 的 origin）。同一个类型下的漏翻是同一条
// 修法：往 labels.rs 的 TYPE_VAR_RULES 补一条，或确认该类型的 name/desc 根本没进过抽取。
// 按类型聚合之后，一条一条的名字变成「补哪几条规则」，这是这份报告里最直接可行动的一节。
{
  const byType = new Map();
  for (const rows of Object.values(buckets)) {
    for (const row of rows) {
      if (!/\b(display|desc)\b/.test(row.sources)) continue;
      for (const hint of row.hints) {
        const m = /^来源: (\/.+)$/.exec(hint);
        if (!m) continue;
        const list = byType.get(m[1]) ?? [];
        list.push(row);
        byType.set(m[1], list);
      }
    }
  }
  if (byType.size) {
    const ordered = [...byType].sort((a, b) => b[1].length - a[1].length);
    console.log(`\n=== 显示边界缺口按类型聚合（${byType.size} 个类型）===`);
    console.log(
      '    每个类型一条修法：labels.rs TYPE_VAR_RULES 补一条（按类型路径，覆盖全部子类型），' +
        '或确认该类型的 name/desc 压根没进抽取（拿英文名 grep strings/i18n/en/ 一条都没有 = 整类漏抽）',
    );
    for (const [type, rows] of ordered) {
      console.log(`  ${String(rows.length).padStart(4)} 条  ${type}`);
      for (const row of rows.slice(0, 5)) console.log(`           · ${row.text}`);
      if (rows.length > 5) console.log(`           … 另有 ${rows.length - 5} 条`);
    }
  }
}
// ---- LANG 实参缺口按**模板 key** 聚合 ----
// `arg` 来源现在带着它所属的 LANG key（runtime.dm 把 lang_resolve 的 key 一路传到
// lang_localize_arg）。没有它的时候每一条都要拿片段去全仓 grep —— 而片段往往来自 pick() 词池、
// 源码里根本搜不到那个字面量。有了 key 就能 `grep -rn '<key>' --include=*.dm` 一步定位调用点，
// 同一个 key 下的一堆实参也就是同一条修法（多半是某张词池表整张没进目录）。
{
  const byKey = new Map();
  for (const rows of Object.values(buckets)) {
    for (const row of rows) {
      if (!/\barg\b/.test(row.sources)) continue;
      for (const hint of row.hints) {
        const m = /^来源: ([a-z_]+\.[0-9a-f]{16})$/.exec(hint);
        if (!m) continue;
        const list = byKey.get(m[1]) ?? [];
        list.push(row);
        byKey.set(m[1], list);
      }
    }
  }
  if (byKey.size) {
    const ordered = [...byKey].sort((a, b) => b[1].length - a[1].length);
    console.log(`\n=== LANG 实参缺口按模板 key 聚合（${byKey.size} 个 key）===`);
    console.log(
      "    定位调用点：grep -rn '<key>' --include=*.dm code modular_nova —— " +
        '同一个 key 下的多条实参通常是同一张词池表整张没进目录',
    );
    for (const [key, rows] of ordered) {
      console.log(`  ${String(rows.length).padStart(4)} 条  ${key}`);
      for (const row of rows.slice(0, 5)) console.log(`           · ${row.text}`);
      if (rows.length > 5) console.log(`           … 另有 ${rows.length - 5} 条`);
    }
  }
}
const total = Object.values(buckets).reduce((sum, rows) => sum + rows.length, 0);
console.log(`\n共 ${total} 条唯一漏翻（阈值 ≥${minCount} 次）`);
process.exit(applyBaselineGate());
