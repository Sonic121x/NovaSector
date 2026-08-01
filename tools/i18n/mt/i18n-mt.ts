#!/usr/bin/env bun
// NovaSector 全量汉化：增量、混译检测的翻译驱动。
//
// 思路：逐 key 判定状态（已译 / 缺失 / 未译 / 中英混杂），只把「待译」的那批喂给 Codex，
// 翻完合并回 zh-Hans。避免整文件重译，且能把 obj.json 这种里中英混杂的条目挑出来重做。
//
// 入口：`bun tools/i18n/mt/i18n-mt.ts ...`（已 chmod +x，亦可 `./tools/i18n/mt/i18n-mt.ts ...`）。
// 命令（第一个参数不是子命令时默认 translate，如 `... tgui.json`）：
//   pending [ns...]         # 只报告各文件待译数量与样例（不调用模型）
//   terms [ns...]           # 只报告译文与术语表不一致的条目
//   translate [ns...]       # 计算待译 -> 模型翻译 -> 合并回 zh-Hans
//   translate-terms [ns...] # 只让模型修正术语不一致的条目
//
// 后端（I18N_BACKEND，默认 codex）：
//   codex  —— Codex CLI（agent 写文件，禁用 MCP）。  claude —— Claude Code CLI（`claude -p`）。
//   openai —— OpenAI 兼容 API（HTTP；OPENAI_API_KEY + I18N_OPENAI_MODEL/BASE_URL，可走 DeepSeek/通义/vLLM）。
//
// 配置：tools/i18n/mt/.env 启动时自动加载（KEY=VALUE；shell 显式变量优先）。见 .env.example。
//   I18N_LOCALE(zh-Hans) / I18N_CHUNK(openai 400, agent 200) / I18N_CONCURRENCY(openai 4, agent 1)
//   I18N_NO_REUSE=1(关跨命名空间复用) / I18N_MAX_CODEX_CALLS / I18N_CONTINUE_ON_FAIL / I18N_FULL_GLOSSARY
//   I18N_MISSING_ONLY(默认开=补「缺失/空值」+「与英文逐字相同的占位译文」，但不动已有≠英文的真译文；
//                      =0 额外重判中英混杂/残留英文，首次翻新 locale 或想全量复查时用)
// agent 输出默认写入 tools/i18n/mt/.pending/*.codex.log，终端只显示批次进度。

import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

// 加载 tools/i18n/mt/.env（若存在）：KEY=VALUE 行；已在环境里的变量优先（shell 覆盖 .env）。
// 必须在下面读取 process.env 的 const 之前执行。
(() => {
  const envPath = path.join(import.meta.dir, '.env');
  if (!fs.existsSync(envPath)) return;
  for (const raw of fs.readFileSync(envPath, 'utf8').split('\n')) {
    const line = raw.trim();
    if (!line || line.startsWith('#')) continue;
    const eq = line.indexOf('=');
    if (eq < 0) continue;
    const key = line.slice(0, eq).trim();
    let val = line.slice(eq + 1).trim();
    if (
      (val.startsWith('"') && val.endsWith('"')) ||
      (val.startsWith("'") && val.endsWith("'"))
    ) {
      val = val.slice(1, -1);
    }
    if (key && !(key in process.env)) process.env[key] = val;
  }
})();

const ROOT = path.resolve(import.meta.dir, '../../..');
const LOCALE = process.env.I18N_LOCALE ?? 'zh-Hans';
const EN_DIR = path.join(ROOT, 'strings/i18n/en');
const DST_DIR = path.join(ROOT, `strings/i18n/${LOCALE}`);
const GLOSSARY_PATH = path.join(import.meta.dir, `glossary.${LOCALE}.json`);
const PENDING_DIR = path.join(import.meta.dir, '.pending');
// 「故意保持英文」白名单：模型/人工判定某 key 应保持英文（专名/cult 咒语/程序名/base64/字体名…）。
// 这类 key 的 zh==en，旧逻辑把 zh==en 一律当「失败占位」无限重送模型（浪费且每轮都报「待译」）。
// 登记后 zh==en 且命中白名单即跳过；英文原文一并记下，原文一旦改动则自动失效、重新进入翻译。
const KEEP_EN_PATH = path.join(import.meta.dir, `keep-english.${LOCALE}.json`);
const CODEX_REASONING = process.env.I18N_CODEX_REASONING ?? 'low';
const CODEX_MODEL = process.env.I18N_CODEX_MODEL;
const CODEX_STDIO = process.env.I18N_CODEX_STDIO ?? 'log';
// 翻译后端：codex（默认，agent 写文件）| claude（Claude Code CLI，agent 写文件）| openai（API，HTTP 返回 JSON）。
const BACKEND = (process.env.I18N_BACKEND ?? 'codex').toLowerCase();
const CLAUDE_MODEL = process.env.I18N_CLAUDE_MODEL; // 可选，覆盖 claude 默认模型
const OPENAI_API_KEY = process.env.OPENAI_API_KEY ?? process.env.I18N_OPENAI_API_KEY;
const OPENAI_MODEL = process.env.I18N_OPENAI_MODEL ?? 'gpt-4o-mini';
const OPENAI_BASE_URL = (
  process.env.I18N_OPENAI_BASE_URL ?? 'https://api.openai.com/v1'
).replace(/\/+$/, '');
const BACKEND_LABEL =
  BACKEND === 'openai' ? 'OpenAI' : BACKEND === 'claude' ? 'Claude Code' : 'Codex';
const PROGRESS_WIDTH = Number(process.env.I18N_PROGRESS_WIDTH ?? 28);

function envInt(name: string, fallback: number): number {
  const raw = process.env[name];
  if (raw == null || raw === '') {
    return fallback;
  }
  const parsed = Number(raw);
  return Number.isFinite(parsed) && parsed >= 0 ? Math.floor(parsed) : fallback;
}

function envFlag(name: string): boolean {
  return /^(1|true|yes|on)$/i.test(process.env[name] ?? '');
}

const MAX_CODEX_CALLS = envInt(
  'I18N_MAX_CODEX_CALLS',
  envInt('I18N_MAX_AGENTS', envInt('I18N_MAX_BATCHES', 0)),
);
const CODEX_DELAY_MS = envInt('I18N_CODEX_DELAY_MS', 0);
const CONTINUE_ON_FAIL = envFlag('I18N_CONTINUE_ON_FAIL');
const FULL_GLOSSARY = envFlag('I18N_FULL_GLOSSARY');
// 只补缺失（默认开）：只翻「目标 locale 里不存在/空值的 key」，对任何已有译文
// （含与英文相同、中英混杂）一律不动、不重判。整体翻译过一遍后增量补新抽取的 key 即此场景。
// 设 I18N_MISSING_ONLY=0 恢复「重判中英混杂/未译」的全量检测（首次翻译新 locale 时用）。
const MISSING_ONLY =
  process.env.I18N_MISSING_ONLY == null ? true : envFlag('I18N_MISSING_ONLY');
const CODEX_OUTPUT_POLL_MS = envInt('I18N_CODEX_OUTPUT_POLL_MS', 2000);
const CODEX_OUTPUT_KILL_MS = envInt('I18N_CODEX_OUTPUT_KILL_MS', 5000);

// 优先待译清单（I18N_ONLY_KEYS=<json>）：{"obj.json": ["obj.xxxx", ...], ...}。
// 由 `node tools/i18n/miss-scan.mjs --emit-pending` 从生产服漏翻日志生成——只翻
// 「玩家实际看到的」那批 key，把 MT 额度花在刀刃上。仍过 needsTranslation 判定
// （已译条目不会被强制重译；要重判混杂配合 I18N_MISSING_ONLY=0）。
const ONLY_KEYS: Record<string, Set<string>> | null = (() => {
  const file = process.env.I18N_ONLY_KEYS;
  if (!file) return null;
  const resolved = path.isAbsolute(file) ? file : path.join(ROOT, file);
  const raw = JSON.parse(fs.readFileSync(resolved, 'utf8'));
  const result: Record<string, Set<string>> = {};
  for (const [ns, keys] of Object.entries(raw)) {
    if (Array.isArray(keys)) result[ns] = new Set(keys as string[]);
  }
  return result;
})();

type Catalog = Record<string, string>;
type WorkMode = 'pending' | 'terms';
type TranslatedBatch = {
  catalog: Catalog;
  glossaryAdded: number;
  reused?: boolean;
  /** 术语强制修好的条数 / 强制后仍违规的条数（见 enforceGlossary）。 */
  termFixed?: number;
  termLeft?: number;
};
type TermMismatch = {
  term: string;
  expected: string;
  /**
   * 该术语是「保持英文」条目（expected === term）。
   *
   * 这类"违规"的含义是「译文里没保留英文原词」，**绝不能拿去 repair**：重翻会把英文
   * 塞回本来好好的中文里（实测 太空润滑剂 -> Space Lube、泡沫力量 SWAT 面具 ->
   * Foam Force SWAT 面罩）。术语表里 43% 是这类条目（多为 mark-english 种下的），
   * 与译文冲突时通常是**术语表该改**，不是译文该改。所以只报告、不修。
   */
  keepEnglish?: boolean;
};
/** 一个义项。scope 为空 = 兜底义项（没有任何限定义项命中时用它）。 */
type GlossarySense = {
  expected: string;
  /** 首选 + alts；命中任意一个都算一致。 */
  accepted: string[];
  note?: string;
  /** DM 类型路径前缀，如 "/datum/reagent"。命中即选中该义项。 */
  scope?: string[];
};
type GlossaryTerm = {
  term: string;
  sourcePattern: RegExp;
  /** 按 scope 由具体到兜底排好序。 */
  senses: GlossarySense[];
};
type TermReportEntry = {
  en: string;
  zh: string;
  missing: TermMismatch[];
};
type TermReport = Record<string, Record<string, TermReportEntry>>;

/**
 * 术语表条目。两种写法并存（旧的纯字符串仍然合法，不必一次性迁移）：
 *   "Nanotrasen": "纳米传讯"
 *   "multitool":  { "zh": "多功能工具", "alts": ["万用工具"], "note": "工程物品；泛指「多用途的工具」时不适用" }
 * - zh   = 首选译文（喂给模型的那个、自动一致性检查的目标）
 * - alts = 同样可接受的译法（一个英文对多个译文）。只用于**不判为不一致**，模型仍只被告知首选。
 * - note = 消歧注释，会随术语一起进提示词。专名 vs 普通名词用法的区分全靠它
 *          （multitool 那个物品 → 多功能工具；描述挎包「是个多用途的工具」→ 不该套术语）。
 */
type GlossarySenseSpec = {
  zh: string;
  alts?: string[];
  note?: string;
  /**
   * 限定该义项只在这些 DM 类型路径前缀下生效（可给字符串或数组）。
   * 语境来自 strings/i18n/scopes.json（nova-i18n extract 产出的 key -> 类型路径）。
   *
   *   "Base": [
   *     { "scope": "/datum/reagent", "zh": "碱" },
   *     { "scope": ["/area", "/turf"], "zh": "基地" },
   *     { "zh": "基础" }                              // 无 scope = 兜底
   *   ]
   *
   * 一词多义只能靠这个解决：从前同一个 `Base` 在化学和区域名下共用一条译文，
   * 检查器不是误报就是漏报，MT 也只能猜。
   */
  scope?: string | string[];
};
type GlossaryValue = string | GlossarySenseSpec | GlossarySenseSpec[];

const glossary: Record<string, GlossaryValue> = fs.existsSync(GLOSSARY_PATH)
  ? JSON.parse(fs.readFileSync(GLOSSARY_PATH, 'utf8'))
  : {};

/** 归一成义项数组：具体（有 scope）在前、兜底在后。 */
function glossarySenses(v: GlossaryValue): GlossarySense[] {
  const specs: GlossarySenseSpec[] =
    typeof v === 'string' ? [{ zh: v }] : Array.isArray(v) ? v : [v];
  return specs
    .map((s) => {
      const scope =
        s.scope == null
          ? undefined
          : (Array.isArray(s.scope) ? s.scope : [s.scope]).map((p) =>
              p.replace(/\/+$/, ''),
            );
      return {
        expected: s.zh,
        accepted: [s.zh, ...(s.alts ?? [])].filter((x) => x && x.length > 0),
        note: s.note,
        scope,
      };
    })
    .sort((a, b) => (b.scope ? 1 : 0) - (a.scope ? 1 : 0));
}

/** 首选译文（多义时取第一个义项——仅用于「保持英文」判定这类不看语境的场合）。 */
function glossaryZh(v: GlossaryValue): string {
  return glossarySenses(v)[0]?.expected ?? '';
}

// 术语表里「保持英文」的词（首选译文 === key，如 datum/Nanotrasen 缩写），允许留在译文里。
function keepEnglishTerms(): string[] {
  return Object.entries(glossary)
    .filter(([k, v]) => k === glossaryZh(v))
    .map(([k]) => k)
    .sort((a, b) => b.length - a.length);
}

let keepEnglish = keepEnglishTerms();

function escapeRegExp(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

/**
 * 术语表里**换个大小写就是另一个普通英文词**的条目，匹配时保持大小写敏感
 * （见 sourceTermPattern 的大小写不敏感说明）。
 *
 * 判据只有一条：把该词的小写形式放进普通句子里，它是不是一个意思完全不同的日常词。
 * 是 → 进这张表。举例（都是实测出来的误报）：
 *   Straight（异性恋）  命中 "walk straight ahead"
 *   Cream  （奶油）    命中 "ice cream"（冰淇淋是对的，不该改）
 *   Cook   （厨师）    命中 "cook meat" 这个动词
 *   Criminal（罪犯）   命中 "criminal mind"（犯罪心理是对的）
 *   robust （硬核）    命中 "Robust Industries, LLC" 这个公司名
 *   byond  （BYOND）   命中 "byond://" 协议头
 *
 * 反例（**不该**进这张表）：captain / chemist / curator / uplink / plushie —— 它们的
 * 小写形式就是同一个东西，正是靠大小写不敏感才能覆盖 obj 的小写 name/desc。
 */
/**
 * **拟声词/感叹词绝不能进术语表。**
 *
 * 它们的中文写法本来就随语法角色变，强行统一必错。`honk` 踩过：目录里有六种渲染，
 * 各自都对——
 *   纯 meme 大写 `<font size=8>HONK</font>` → 必须留 HONK
 *   拟声 `Honk.` / `a silly bike horn! Honk!` → 叭。/ 叭！
 *   拟声（另一派）`banana ice cream. Honk!`  → 呱呱！
 *   动词 `honking clown`                     → 鸣笛小丑
 *   专名 `El Honker's Mask` / `HONKITUDE`    → 鸣笛者 / 喇叭度
 * 当时按「目录里 Honk 出现 32 次 > 鸣叫 17 次」判它保持英文，结果把动词义项也变成
 * 「会让你满嘴 Honk」。**那个频次是整目录子串计数，把专名、meme、拟声全算作一类了**——
 * 对多语法角色的词是垃圾判据。这类词直接不收，让它随语境走。
 */

const CASE_SENSITIVE_TERMS = new Set([
  'alpha',
  'byond',
  'cook',
  'cream',
  'criminal',
  'fluff',
  'honk',
  'journey',
  'law',
  'meta',
  'noir',
  'robust',
  'shade',
  'sprout',
  'straight',
]);

function sourceTermPattern(term: string): RegExp {
  const prefix = /^[A-Za-z0-9]/.test(term) ? '(^|[^A-Za-z0-9])' : '';
  const suffix = /[A-Za-z0-9]$/.test(term) ? '(?=$|[^A-Za-z0-9])' : '';
  // **大小写不敏感**——DM 里同一个专名有两套写法：datum 显示名是首字母大写的
  // （"Multiver"、"Syriniver"），而 obj 的 name/desc 按 SS13 惯例全小写
  // （"multiver bottle"、"A small bottle of syriniver."）。术语表只收得到其中一种，
  // 大小写敏感匹配就让另一半**永远命中不了术语提示**，MT 每次现编译名 →
  // 多元维瓶 / 多效解毒剂 / 多功能解毒剂 三种叫法并存。这不是个别词的问题，是整类。
  //
  // 例外：**全大写缩写**（AI / ID / NT / ERT）保持大小写敏感。它们的小写形式往往是
  // 另一个普通词（id、it…），放开会把噪音灌进不一致报告。CASE_SENSITIVE_TERMS 同理。
  const flags =
    /[a-z]/.test(term) && !CASE_SENSITIVE_TERMS.has(term.toLowerCase())
      ? 'iu'
      : 'u';
  return new RegExp(`${prefix}${escapeRegExp(term)}${suffix}`, flags);
}

/**
 * key -> 该英文串出现过的 DM 类型路径（nova-i18n extract 产出）。
 * 缺文件不报错，只是退化成「所有义项都按兜底处理」——老仓库/未重跑 extract 时仍能工作。
 */
const SCOPES_PATH = path.join(ROOT, 'strings/i18n/scopes.json');
/**
 * TGUI 侧同名 sidecar（tgui-catalog.mjs 产出），来源写作 `tgui:ChemReactionChamber`。
 * 分两个文件是因为两个写者（Rust extract / node tgui-catalog）共用一个文件必然互相覆盖。
 * 两边 key 空间不重叠——DM 是 `obj.abc12345`，TGUI 直接拿英文原文当 key——所以合并安全。
 */
const TGUI_SCOPES_PATH = path.join(ROOT, 'strings/i18n/tgui-scopes.json');
function loadScopes(p: string): Record<string, string[]> {
  return fs.existsSync(p) ? JSON.parse(fs.readFileSync(p, 'utf8')) : {};
}
const scopesByKey: Record<string, string[]> = {
  ...loadScopes(SCOPES_PATH),
  ...loadScopes(TGUI_SCOPES_PATH),
};

/**
 * 给定条目 key，选出该术语适用的义项。
 * 规则：**最长前缀命中优先**（`/datum/reagent/medicine` 比 `/datum` 更具体），
 * 都不命中则用兜底义项；连兜底都没有就返回 null = 该语境下不检查这个词。
 */
function pickSense(term: GlossaryTerm, key: string): GlossarySense | null {
  const paths = scopesByKey[key];
  let best: GlossarySense | null = null;
  let bestLen = -1;
  for (const sense of term.senses) {
    if (!sense.scope) {
      if (best === null) best = sense; // 兜底：只在没有限定义项命中时生效
      continue;
    }
    if (!paths) continue;
    for (const prefix of sense.scope) {
      // `/datum/reagent` 命中 `/datum/reagent/medicine/multiver`；
      // `tgui:` 这种以冒号收尾的写法命中该来源下全部界面（`tgui:ChemHeater`）。
      const hit = paths.some(
        (p) =>
          p === prefix ||
          p.startsWith(`${prefix}/`) ||
          (prefix.endsWith(':') && p.startsWith(prefix)),
      );
      if (hit && prefix.length > bestLen) {
        best = sense;
        bestLen = prefix.length;
      }
    }
  }
  return best;
}

function glossaryTerms(): GlossaryTerm[] {
  return Object.entries(glossary)
    .filter(([term, v]) => term.length >= 2 && glossaryZh(v).length > 0)
    .sort((a, b) => b[0].length - a[0].length)
    .map(([term, v]) => ({
      term,
      senses: glossarySenses(v),
      sourcePattern: sourceTermPattern(term),
    }));
}

let termsByLength = glossaryTerms();

const LOWERCASE_TERM_ALLOWLIST = new Set([
  'ahelp',
  'airlock',
  'alifil',
  'antagonist',
  'arrivals',
  'bitrunner',
  'bluespace',
  'borg',
  'brussite',
  'buildmode',
  'ckey',
  'corpo',
  'deadchat',
  'departures',
  'digi',
  'disabler',
  'eigenstate',
  'embershrooms',
  'flechette',
  'freon',
  'gondola',
  'griff',
  'hardlight',
  'headcrab',
  'healium',
  'hemoparasite',
  'holonet',
  'honk',
  'lavaland',
  'lavaloop',
  'maintenance',
  'medicell',
  'medigun',
  'mercuryblast',
  'meteorslug',
  'minebot',
  'mothroach',
  'neuroware',
  'nitrium',
  'nizaya',
  'persocom',
  'piledriver',
  'plasma',
  'readmin',
  'robust',
  'rubbernecker',
  'seraka',
  'shakiri',
  'tacoyaki',
  'taser',
  'tegu',
  'tepache',
  'thoughtfeeder',
  'tinumium',
  'traitor',
  'tritium',
  'voltvine',
  'zaukerite',
]);

const SINGLE_WORD_TERM_ALLOWLIST = new Set([
  'Nanotrasen',
  'Sol',
  'SolFed',
  'Syndicate',
]);

const GENERIC_GLOSSARY_REJECTS = new Set([
  'abandoned',
  'advanced',
  'aft',
  'agent',
  'alien',
  'ash',
  'ashen',
  'auxiliary',
  'back',
  'backstage',
  'bad',
  'bar',
  'base',
  'basic',
  'bathrooms',
  'bay',
  'biolab',
  'big',
  'black',
  'block',
  'blue',
  'board',
  'bottom',
  'botany',
  'bow',
  'box',
  'bridge',
  'brig',
  'bright',
  'brown',
  'cafeteria',
  'cargo',
  'caves',
  'central',
  'chapel',
  'clean',
  'closed',
  'cold',
  'command',
  'common',
  'construction',
  'crate',
  'cubicles',
  'custodial',
  'customs',
  'dark',
  'deep',
  'derelict',
  'delta',
  'dirty',
  'disposals',
  'division',
  'dock',
  'dormitories',
  'dormitory',
  'dorms',
  'down',
  'east',
  'electrical',
  'empty',
  'engine',
  'engineering',
  'exosuit',
  'facility',
  'female',
  'first',
  'floor',
  'fore',
  'fourth',
  'fluffy',
  'full',
  'gateway',
  'genetical',
  'glass',
  'good',
  'gold',
  'gray',
  'graveyard',
  'greater',
  'green',
  'grey',
  'hall',
  'halls',
  'hallway',
  'heavy',
  'high',
  'hot',
  'hotel',
  'human',
  'hydroponics',
  'inside',
  'lab',
  'large',
  'lawful',
  'left',
  'lesser',
  'library',
  'light',
  'little',
  'lobby',
  'long',
  'lounge',
  'low',
  'lower',
  'magazine',
  'maint',
  'male',
  'medbay',
  'medical',
  'metal',
  'mining',
  'new',
  'normal',
  'north',
  'office',
  'old',
  'open',
  'operatives',
  'orange',
  'ordnance',
  'outpost',
  'pale',
  'pharmacy',
  'pink',
  'poke',
  'port',
  'power',
  'prison',
  'public',
  'purple',
  'red',
  'research',
  'restroom',
  'restrooms',
  'right',
  'ripper',
  'robotics',
  'round',
  'satellite',
  'science',
  'secure',
  'security',
  'service',
  'server',
  'shared',
  'ship',
  'short',
  'silver',
  'small',
  'softdrinks',
  'south',
  'spa',
  'special',
  'stairwell',
  'starboard',
  'storage',
  'supply',
  'room',
  'second',
  'target',
  'telecommunications',
  'tent',
  'third',
  'thermodynamic',
  'toolbox',
  'top',
  'tunnel',
  'up',
  'upper',
  'vendor',
  'virology',
  'wall',
  'walkway',
  'warm',
  'waystation',
  'welding',
  'west',
  'white',
  'window',
  'wood',
  'worn',
  'yellow',
]);

// 通用「中心词」（房间/设施/位置/泛物名）。多词短语若以这些词结尾，多是描述性名称（房间名、
// 设施名、泛指物品），翻译是组合式的、无需锁进术语表——别让它们污染/膨胀术语表。
// 注意：不含组织/品牌词（Company/Industries/Consortium/Systems…），那些是专名要保留。
const GENERIC_HEAD_NOUNS = new Set([
  'storage', 'office', 'room', 'rooms', 'hall', 'hallway', 'bay', 'lab',
  'laboratory', 'labs', 'dock', 'docks', 'chamber', 'chambers', 'wing',
  'outpost', 'restroom', 'restrooms', 'bathroom', 'bathrooms', 'dormitory',
  'dormitories', 'dorms', 'cell', 'cells', 'kitchen', 'vault', 'hold', 'deck',
  'corridor', 'junction', 'foyer', 'lobby', 'lounge', 'closet', 'locker',
  'lockers', 'pantry', 'freezer', 'vehicle', 'depot', 'terminal', 'platform',
  'atrium', 'courtyard', 'yard', 'range', 'armory', 'brig', 'morgue', 'chapel',
  'library', 'gym', 'arcade', 'cafeteria', 'canteen', 'quarters', 'barracks',
  'division', 'department', 'center', 'centre', 'facility', 'area', 'sector',
  'post', 'supply', 'supplies', 'tech',
  // 不收 'station'/'module'：地图/站点名（Beta Station…）与 "X Module" 多为专名/保留英文。
]);

/// 取短语最后一个英文词（小写）。
function headWord(term: string): string {
  const words = term.match(/[A-Za-z]+/g) ?? [];
  return (words[words.length - 1] ?? '').toLowerCase();
}

function isGenericPhrase(term: string): boolean {
  const words = term.match(/[A-Za-z]+/g) ?? [];
  return words.length >= 2 && GENERIC_HEAD_NOUNS.has(headWord(term));
}

function saveGlossary() {
  // 值原样保留（字符串或 {zh,alts,note} 对象），只重排 key。
  const sorted: Record<string, GlossaryValue> = {};
  for (const k of Object.keys(glossary).sort()) sorted[k] = glossary[k];
  fs.writeFileSync(GLOSSARY_PATH, `${JSON.stringify(sorted, null, 2)}\n`);
}

function isGlossaryAdditionCandidate(en: string): boolean {
  const term = en.trim();
  if (term.length < 3 || term !== en || /[{}<>]/.test(term)) {
    return false;
  }

  // 描述性短语（房间/设施/泛物名，以通用中心词结尾）不入术语表——翻译是组合式的、无需锁定。
  if (isGenericPhrase(term)) {
    return false;
  }

  const words = term.match(/[A-Za-z]+/g) ?? [];
  const lowerWords = words.map((word) => word.toLowerCase());
  if (lowerWords.some((word) => GENERIC_GLOSSARY_REJECTS.has(word))) {
    return false;
  }

  if (/^[a-z]+$/.test(term)) {
    return LOWERCASE_TERM_ALLOWLIST.has(term);
  }

  if (/^[A-Z0-9]{2,}$/.test(term)) {
    return true;
  }

  if (/[0-9.+_/()-]/.test(term)) {
    return true;
  }

  if (/^[A-Z][A-Za-z]+(?:[ '-][A-Z][A-Za-z]+)+$/.test(term)) {
    return true;
  }

  if (/^[A-Z][a-z]+$/.test(term)) {
    return SINGLE_WORD_TERM_ALLOWLIST.has(term);
  }

  if (/^[A-Z][A-Za-z]*[a-z][A-Z][A-Za-z]*$/.test(term)) {
    return true;
  }

  return false;
}

/** 把 Codex 这批新发现的固定词合并进术语表（仅新增，不覆盖已有人工译名），并落盘。 */
/** 术语表查重用的归一化形式：与 sourceTermPattern 的大小写不敏感、以及并条规则保持一致。 */
function glossaryNormKey(term: string): string {
  return term.toLowerCase().replace(/[-_\s]/g, '');
}

function mergeGlossaryAdditions(additions: Record<string, string>): number {
  // **按归一化形式查重**，不能用 `en in glossary` 的精确匹配。
  // 精确匹配下，模型返回的 "Nanotrasen" 在表里只有 "NANOTRASEN" 时会被当成新词加进去
  // （译名还不一样：纳诺特雷森 vs 纳米传讯），于是刚并好的变体组当场又裂开——实测一次
  // MT 运行就把上一轮合并的 40 组重新污染了。匹配已是大小写/连字符不敏感的，
  // 所以只要归一化后撞上就不算新词。
  const known = new Set(Object.keys(glossary).map(glossaryNormKey));
  let added = 0;
  for (const [en, zh] of Object.entries(additions)) {
    if (!en || !zh || known.has(glossaryNormKey(en))) continue;
    if (!isGlossaryAdditionCandidate(en)) continue;
    glossary[en] = zh;
    known.add(glossaryNormKey(en));
    added++;
  }
  if (added) {
    keepEnglish = keepEnglishTerms();
    termsByLength = glossaryTerms();
    saveGlossary();
  }
  return added;
}

const CJK = /[㐀-鿿]/;

/** 去掉占位符 / HTML 标签 / DM 文本宏 / 保持英文的术语，剩下的才用于判定「是否还有英文」。 */
function stripNoise(s: string): string {
  let t = s
    .replace(/\{\d+\}/g, ' ')
    .replace(/<[^>]*>/g, ' ')
    .replace(/&[a-zA-Z0-9#]+;/g, ' ')
    .replace(/\\[A-Za-z]+/g, ' ')
    .replace(/\b(?:boxed_message|purple_box|blue_box|red_box|green_box)/g, ' ')
    .replace(/\b[a-z][a-z0-9]*(?:_[a-z0-9]+)+(?=[A-Z])/g, ' ')
    .replace(/\b[a-z][a-z0-9]*(?:_[a-z0-9]+)+\b/g, ' ')
    .replace(/\b[a-z][a-z0-9]*(?:-[a-z0-9]+)+\b/g, ' ')
    .replace(/\/[A-Za-z0-9_./-]+/g, ' ')
    .replace(
      /\b[A-Za-z0-9_./-]+\.(?:png|jpg|jpeg|gif|webp|svg|dmi|ogg|wav|mp3|json|css|js|ts|tsx|html)\b/g,
      ' ',
    )
    .replace(
      /\.(?:png|jpg|jpeg|gif|webp|svg|dmi|ogg|wav|mp3|json|css|js|ts|tsx|html)\b/g,
      ' ',
    )
    .replace(/\b[a-z]+=[A-Za-z0-9_-]+\b/g, ' ');
  for (const term of keepEnglish) t = t.split(term).join(' ');
  return t;
}

/** 是否含「应被翻译的英文词」：连续小写字母 2+（短词如 New/Bug/Map 也算）。
 * 全大写缩写（APC/RCD）零小写、代码/路径经 stripNoise 抹掉 → 仍排除；故降到 2 只多收真短词、不收代码。 */
function hasEnglishWord(s: string): boolean {
  return /[a-z]{2,}/.test(stripNoise(s));
}

/**
 * 「该译的英文」判定（缺失/占位分支用）：hasEnglishWord 只认小写（把 HUD/EMP 类缩写当
 * 标识符排除），但**多词全大写句**（离子法则模板/池、横幅标题 "INSULT THE CLOWN"）没有小写
 * 字母 → 曾被整类跳过（实测 734 条从未进过待译队列）。多词 + 各词 ≥2 个大写字母 = 大写散文，
 * 该译；单个全大写词仍视为缩写不译。
 */
function hasTranslatableEnglish(s: string): boolean {
  if (hasEnglishWord(s)) return true;
  const words = stripNoise(s)
    .split(/\s+/)
    .filter((w) => /[A-Z]{2,}/.test(w));
  return words.length >= 2;
}

/**
 * 内部代码标识符（无空格的单 token 含下划线，如 spawn_menu_atom_data / plane_masters_colorblind /
 * {0}_light4）——是被抽取器误收的程序内部串，不是玩家可见文案。占位（zh==en）补译时排除它们，
 * 免得把代码 key 送去机翻（既浪费、又可能产出错译造成 bug）。真实 UI 文案用空格分词（"Left Hand"）
 * 或是无下划线的单词（"Chest"），不会被误伤。
 */
function looksLikeCodeIdentifier(s: string): boolean {
  return !/\s/.test(s) && /_/.test(s);
}

/**
 * 「已含中文的译文里是否还残留*该补译*的英文」——比 hasEnglishWord 多剥一层有意保留的专名/代码：
 * CamelCase 标识符（NIFSoft/MULEbot/Ckey）、首字母大写专名（Katsuobushi/Sidecar/Godfather）、
 * 斜杠代码串（obj/turf/mob）。这些在中文串里几乎都是刻意保留的术语，不该触发「中英混杂→重译」
 * 的死循环。注意：此剥离*只*用于已有中文的重做判定，不能用于判断「英文源是否该译」
 * （那里若剥大写，会把 "Reinforced Window" 这类 Title Case 标题误判成已译）。
 */
function hasStrayEnglishInTranslation(zh: string): boolean {
  const t = stripNoise(zh)
    .replace(/\b[A-Za-z]*[a-z][A-Z][A-Za-z]*\b/g, ' ') // 内部大写标识符（小写后接大写）：iPod, Ckey
    .replace(/\b[A-Z]{2,}[a-zà-ÿ][A-Za-z]*\b/g, ' ') // 缩写前缀标识符：NIFSoft, NIFsoft, MULEbot
    .replace(/\b[A-ZÀ-Þ][a-zà-ÿ]{2,}\b/g, ' ') // 首字母大写专名：Katsuobushi, Sidecar, Lanca
    .replace(/\b[a-z]+(?:\/[a-z]+)+\b/g, ' '); // 斜杠代码串：obj/turf/mob
  return /[a-z]{3,}/.test(t);
}

// ——「故意保持英文」白名单：惰性加载，登记时记下英文原文，flush 时排序落盘。——
let keepEnglishCache: Catalog | null = null;
let keepEnglishDirty = false;
function keepEnglishMap(): Catalog {
  if (keepEnglishCache == null) {
    keepEnglishCache = fs.existsSync(KEEP_EN_PATH)
      ? (JSON.parse(fs.readFileSync(KEEP_EN_PATH, 'utf8')) as Catalog)
      : {};
  }
  return keepEnglishCache;
}
/** 该 key 是否已登记「保持英文」且英文原文未变（原文变了则失效、重新翻译）。 */
function isKeepEnglish(key: string, enVal: string): boolean {
  return keepEnglishMap()[key] === enVal;
}
/** 登记某 key 为「保持英文」（英文原文一并记下）。 */
function markKeepEnglish(key: string, enVal: string): void {
  const m = keepEnglishMap();
  if (m[key] !== enVal) {
    m[key] = enVal;
    keepEnglishDirty = true;
  }
}
function flushKeepEnglish(): void {
  if (!keepEnglishDirty || keepEnglishCache == null) return;
  const sorted: Catalog = {};
  for (const k of Object.keys(keepEnglishCache).sort())
    sorted[k] = keepEnglishCache[k];
  fs.writeFileSync(KEEP_EN_PATH, `${JSON.stringify(sorted, null, 2)}\n`);
  keepEnglishDirty = false;
}

/** 该 key 是否需要（重新）翻译。 */
function needsTranslation(
  enVal: string,
  zhVal: string | undefined,
  key?: string,
): boolean {
  if (zhVal == null || zhVal === '') return hasTranslatableEnglish(enVal); // 缺失（key 不存在或空值）
  // 与英文逐字相同 = 没翻成功的「占位译文」，语义上等同未译 → 始终补译（即使 missing-only）。
  // 这是「整体翻译一遍后仍有 key 显示英文」（如 "Chest":"Chest"）的根因：旧逻辑里 missing-only
  // 把「有任何值」都当已译跳过，占位英文永远不会被重试。纯代码/符号（hasEnglishWord=false）不补。
  // 例外：已登记「保持英文」（专名/cult 咒语/程序名/base64…）的 key 不再重送模型。
  if (zhVal === enVal) {
    if (key != null && isKeepEnglish(key, enVal)) return false;
    return hasTranslatableEnglish(enVal) && !looksLikeCodeIdentifier(enVal);
  }
  if (MISSING_ONLY) return false; // 只补缺失/失败：已有「≠英文」的真译文都不动（不重判刻意保留的中英混杂）
  // 已登记保持英文的 key：混杂英文是有意的（拉丁彩蛋/@pick 模板/术语），深度复查也不重翻。
  // 登记途径：`accept-mixed`（批量接受现状）或手编 keep-english.<locale>.json。
  if (key != null && isKeepEnglish(key, enVal)) return false;
  const stray = hasEnglishWord(zhVal);
  if (!CJK.test(zhVal) && stray) return true; // 无中文却有英文词 → 未译
  if (CJK.test(zhVal) && stray && hasStrayEnglishInTranslation(zhVal))
    return true; // 中英混杂 → 重译（剥掉刻意保留的专名/代码后仍有英文才重做，避免对 NIFSoft/Katsuobushi 死循环）
  return false; // 看起来已完整翻译（或纯符号/缩写）
}

function readCatalog(file: string): Catalog {
  return fs.existsSync(file) ? JSON.parse(fs.readFileSync(file, 'utf8')) : {};
}

function jsonFileEquals(file: string, expected: unknown): boolean {
  if (!fs.existsSync(file)) {
    return false;
  }
  try {
    return (
      JSON.stringify(JSON.parse(fs.readFileSync(file, 'utf8'))) ===
      JSON.stringify(expected)
    );
  } catch {
    return false;
  }
}

function writableTarget(file: string): boolean {
  try {
    if (fs.existsSync(file)) {
      fs.accessSync(file, fs.constants.W_OK);
    } else {
      fs.accessSync(path.dirname(file), fs.constants.W_OK);
    }
    return true;
  } catch {
    return false;
  }
}

function ensureWritableTarget(file: string, label: string): boolean {
  if (writableTarget(file)) {
    return true;
  }
  const rel = path.relative(ROOT, file);
  console.error(
    `  ⚠ ${label} 不可写：${rel}。请先修权限，例如：chmod u+w ${rel}`,
  );
  return false;
}

function namespaceFiles(args: string[]): string[] {
  if (args.length)
    return args.map((a) => (a.endsWith('.json') ? a : `${a}.json`));
  return fs.readdirSync(EN_DIR).filter((f) => f.endsWith('.json'));
}

/** 计算某命名空间的待译集合（key -> 英文源）。 */
function computePending(file: string): Catalog {
  const allow = ONLY_KEYS ? (ONLY_KEYS[file] ?? new Set()) : null;
  const en = readCatalog(path.join(EN_DIR, file));
  const zh = readCatalog(path.join(DST_DIR, file));
  const pending: Catalog = {};
  for (const key of Object.keys(en)) {
    if (allow && !allow.has(key)) continue;
    // 显式清单（ONLY_KEYS）里的缺失/占位条目跳过可译性启发式（hasTranslatableEnglish 会把
    // 单个全大写词判成标识符——但人工点名的词池条目如 ion 暗号池 "PRETZELS" 就是要翻）。
    if (allow && (zh[key] == null || zh[key] === '' || zh[key] === en[key])) {
      if (key != null && isKeepEnglish(key, en[key])) continue;
      pending[key] = en[key];
      continue;
    }
    if (needsTranslation(en[key], zh[key], key)) pending[key] = en[key];
  }
  return pending;
}

// 探测目标目录文件已有的缩进（tab 或 N 空格），写回时沿用它——否则每次翻译都会把
// 整份目录按固定缩进重排，制造巨量无关 diff / 合并冲突（曾把 tab 的 datum/obj.json
// 整体翻成 2 空格，撞上上游同步合并）。找不到已有文件时取默认：tgui 目录用 tab（前端
// 约定），其余用 2 空格（与 Rust 抽取器 serde to_string_pretty 的输出一致）。
function detectIndent(file: string, isTguiCatalog: boolean): string | number {
  try {
    const match = fs.readFileSync(file, 'utf8').match(/\n([ \t]+)"/);
    if (match) return match[1][0] === '\t' ? '\t' : match[1].length;
  } catch {
    // 文件不存在，落到默认缩进
  }
  return isTguiCatalog ? '\t' : 2;
}

function writeSorted(file: string, catalog: Catalog): void {
  const isTguiCatalog = path.basename(file) === 'tgui.json';
  const sorted: Catalog = {};
  const keys = Object.keys(catalog);
  keys.sort(isTguiCatalog ? (a, b) => a.localeCompare(b) : undefined);
  for (const key of keys) {
    sorted[key] = catalog[key];
  }
  fs.writeFileSync(
    file,
    `${JSON.stringify(sorted, null, detectIndent(file, isTguiCatalog))}\n`,
  );
}

/// 跨命名空间「英文原文 -> 已有合格译文」全局表（仅取已译、非中英混杂的条目）。
/// 用于翻译前复用：同一英文别处已译过就直接套用，不再调模型。与运行时全局反查假设一致。
function buildGlobalReverse(): Map<string, string> {
  const reverse = new Map<string, string>();
  for (const file of namespaceFiles([])) {
    const en = readCatalog(path.join(EN_DIR, file));
    const zh = readCatalog(path.join(DST_DIR, file));
    for (const key of Object.keys(en)) {
      const e = en[key];
      const z = zh[key];
      if (z != null && z !== e && !needsTranslation(e, z) && !reverse.has(e)) {
        reverse.set(e, z);
      }
    }
  }
  return reverse;
}

function termMismatches(
  enVal: string,
  zhVal: string | undefined,
  key: string,
): TermMismatch[] {
  if (zhVal == null || zhVal === '' || zhVal === enVal) {
    return [];
  }

  const missing: TermMismatch[] = [];
  for (const entry of termsByLength) {
    if (!entry.sourcePattern.test(enVal)) continue;
    // 按条目所属的 DM 类型路径挑义项；该语境下没有适用义项就不检查这个词。
    const sense = pickSense(entry, key);
    if (!sense) continue;
    // alts 命中也算一致——一个英文允许多个译法（见 GlossaryValue 注释）。
    if (sense.accepted.some((a) => zhVal.includes(a))) continue;
    missing.push({
      term: entry.term,
      expected: sense.expected,
      ...(sense.expected === entry.term ? { keepEnglish: true } : {}),
    });
  }
  return missing;
}

/** 计算译文里术语表不一致的集合（key -> 英文源），并返回详细报告。 */
function computeTermReport(file: string): Record<string, TermReportEntry> {
  const allow = ONLY_KEYS ? (ONLY_KEYS[file] ?? new Set()) : null;
  const en = readCatalog(path.join(EN_DIR, file));
  const zh = readCatalog(path.join(DST_DIR, file));
  const report: Record<string, TermReportEntry> = {};
  for (const key of Object.keys(en)) {
    if (allow && !allow.has(key)) continue;
    const zhVal = zh[key];
    const missing = termMismatches(en[key], zhVal, key);
    if (missing.length) {
      report[key] = {
        en: en[key],
        zh: zhVal ?? '',
        missing,
      };
    }
  }
  return report;
}

/**
 * 送去重翻的条目。**只收「真·译名不一致」**：至少有一条违规不是「保持英文」类
 * （见 TermMismatch.keepEnglish）。纯保持英文的条目重翻只会把英文塞回中文，是净劣化。
 */
function computeTermPending(file: string): Catalog {
  const report = computeTermReport(file);
  const pending: Catalog = {};
  for (const [key, entry] of Object.entries(report)) {
    if (!entry.missing.some((m) => !m.keepEnglish)) continue;
    pending[key] = entry.en;
  }
  return pending;
}

function writeTermReport(report: TermReport) {
  fs.mkdirSync(PENDING_DIR, { recursive: true });
  const outPath = path.join(PENDING_DIR, `glossary-mismatches.${LOCALE}.json`);
  fs.writeFileSync(outPath, `${JSON.stringify(report, null, 2)}\n`);
  return outPath;
}

function cmdPending(args: string[]) {
  let total = 0;
  for (const file of namespaceFiles(args)) {
    const pending = computePending(file);
    const n = Object.keys(pending).length;
    total += n;
    const sample = Object.entries(pending)
      .slice(0, 2)
      .map(([k, v]) => `${k}=${JSON.stringify(v).slice(0, 40)}`);
    console.log(`${file}: 待译 ${n}${n ? `  e.g. ${sample.join(' | ')}` : ''}`);
  }
  console.log(`合计待译 ${total} 条（locale=${LOCALE}）`);
}

/**
 * 术语表**自相矛盾**检测：归一化（小写 + 去连字符/空格）后同一个词却有多条不同译文。
 *
 * 这类条目会凭空制造「不一致」——`maintenance`→维修通道 与 `Maintenance`→维护区 并存时，
 * 无论译文写哪个都必然违反另一条，实测一次贡献了 706 条假违规（占当时总量的 16%）。
 * 匹配已是大小写不敏感（见 sourceTermPattern），所以这种并存本身就是 bug，不是配置。
 * 修法：并成一条，最常用的译文作 zh，其余作 alts。
 */
function glossaryConflicts(): string[][] {
  const groups = new Map<string, Map<string, string>>();
  for (const [term, v] of Object.entries(glossary)) {
    const norm = term.toLowerCase().replace(/[-_\s]/g, '');
    if (!groups.has(norm)) groups.set(norm, new Map());
    groups.get(norm)?.set(term, glossaryZh(v));
  }
  const out: string[][] = [];
  for (const variants of groups.values()) {
    if (variants.size < 2) continue;
    const translated = [...variants].filter(([k, zh]) => k !== zh);
    if (new Set(translated.map(([, zh]) => zh)).size < 2) continue;
    out.push([...variants].map(([k, zh]) => `${k} -> ${zh}`));
  }
  return out;
}

function cmdTerms(args: string[]) {
  const conflicts = glossaryConflicts();
  if (conflicts.length) {
    console.log(
      `⚠ 术语表自相矛盾 ${conflicts.length} 组（归一化后同词、译文不同）——` +
        `这些会凭空制造「不一致」，先并成一条（最常用的作 zh，其余作 alts）：`,
    );
    for (const group of conflicts.slice(0, 10)) {
      console.log(`   ${group.join('  |  ')}`);
    }
  }
  let total = 0;
  const fullReport: TermReport = {};
  for (const file of namespaceFiles(args)) {
    const report = computeTermReport(file);
    const n = Object.keys(report).length;
    total += n;
    fullReport[file] = report;
    const sample = Object.entries(report)
      .slice(0, 2)
      .map(([key, entry]) => {
        const terms = entry.missing
          .slice(0, 3)
          .map(({ term, expected }) => `${term}->${expected}`)
          .join(', ');
        return `${key} [${terms}]`;
      });
    console.log(
      `${file}: 术语不一致 ${n}${n ? `  e.g. ${sample.join(' | ')}` : ''}`,
    );
  }
  const outPath = writeTermReport(fullReport);
  console.log(`合计术语不一致 ${total} 条（locale=${LOCALE}）`);
  console.log(`详情：${path.relative(ROOT, outPath)}`);
}

function batchGlossaryEntries(batch: Catalog): [string, string, string?][] {
  if (FULL_GLOSSARY) {
    return Object.entries(glossary).flatMap(([en, v]) =>
      glossarySenses(v).map(
        (s) =>
          [en, s.expected, senseNote(s)] as [string, string, string | undefined],
      ),
    );
  }

  // 按 (术语, 义项) 去重：同一批里 `Base` 可能既有 /datum/reagent 的「碱」又有兜底的
  // 「基础」，两条都得进提示词，否则模型只看到一个义项、另一半必然翻错。
  const selected = new Map<string, [string, string, string | undefined]>();
  for (const [key, value] of Object.entries(batch)) {
    for (const entry of termsByLength) {
      if (!entry.sourcePattern.test(value)) continue;
      const sense = pickSense(entry, key);
      if (!sense) continue;
      selected.set(`${entry.term} ${sense.expected}`, [
        entry.term,
        sense.expected,
        senseNote(sense),
      ]);
    }
  }
  return [...selected.values()];
}

/** 提示词里的注释：把 scope 一并说出来，模型才知道这条为什么只在某些语境成立。 */
function senseNote(sense: GlossarySense): string | undefined {
  if (!sense.scope) return sense.note;
  const scopeText = `仅 ${sense.scope.join(' / ')} 语境`;
  return sense.note ? `${scopeText}；${sense.note}` : scopeText;
}

function glossaryHint(batch: Catalog): string {
  const entries = batchGlossaryEntries(batch);
  if (entries.length === 0) {
    return '- （本批没有命中术语表；仍需保留 {0}/{1} 占位符、HTML/DM 宏和大写缩写）';
  }
  return entries
    .map(([en, zh, note]) => `- ${en} => ${zh}${note ? `（${note}）` : ''}`)
    .join('\n');
}

// 每批喂给模型的条数（大文件如 obj.json 必须分批，否则超上下文）。可用 I18N_CHUNK 覆盖。
//
// openai 从 400 降到 150：真正的天花板不是**输入**上下文而是**输出** token 上限——
// 400 条长 desc 的中文译文会把回复截断，JSON 半截结束，报
// `openai error: JSON Parse error: Unterminated string`，整批白跑（实测 obj.json 第 0 批）。
// 中文条目普遍比英文原文长，repair-terms 尤其（改的多是长描述），所以宁可小批多跑。
const CHUNK = Number(
  process.env.I18N_CHUNK ?? (BACKEND === 'openai' ? 150 : 200),
);
// 并发批数。agent（codex/claude）重、默认串行(1)；openai 是 API，可并行加速（受额度/限流约束）。
const CONCURRENCY = Math.max(
  1,
  envInt('I18N_CONCURRENCY', BACKEND === 'openai' ? 4 : 1),
);
// 跨命名空间复用：同一英文已在别处译过就直接复用、不再调模型（省调用 + 译名一致）。默认开，
// 与运行时「EN→译文」全局反查的假设一致。I18N_NO_REUSE=1 关闭。
const REUSE = !envFlag('I18N_NO_REUSE');

function progressLine(
  file: string,
  done: number,
  total: number,
  detail: string,
  frame = '',
): string {
  const ratio = total > 0 ? done / total : 1;
  const filled = Math.round(ratio * PROGRESS_WIDTH);
  const bar = `${'#'.repeat(filled)}${'-'.repeat(Math.max(PROGRESS_WIDTH - filled, 0))}`;
  const percent = Math.round(ratio * 100)
    .toString()
    .padStart(3, ' ');
  const spinner = frame ? ` ${frame}` : '';
  return `${file} [${bar}] ${done}/${total} ${percent}%${spinner} ${detail}`;
}

let lastProgressLength = 0;

function writeProgress(line: string, final = false) {
  if (!process.stdout.isTTY) {
    console.log(line);
    return;
  }

  const padded = line.padEnd(lastProgressLength);
  process.stdout.write(`\r${padded}`);
  lastProgressLength = line.length;
  if (final) {
    process.stdout.write('\n');
    lastProgressLength = 0;
  }
}

function startProgress(
  file: string,
  done: number,
  total: number,
  detail: string,
): ReturnType<typeof setInterval> | null {
  if (!process.stdout.isTTY) {
    writeProgress(progressLine(file, done, total, detail));
    return null;
  }

  const frames = ['-', '\\', '|', '/'];
  let frame = 0;
  writeProgress(progressLine(file, done, total, detail, frames[frame]));
  return setInterval(() => {
    frame = (frame + 1) % frames.length;
    writeProgress(progressLine(file, done, total, detail, frames[frame]));
  }, 250);
}

function finishProgress(
  timer: ReturnType<typeof setInterval> | null,
  file: string,
  done: number,
  total: number,
  detail: string,
) {
  if (timer) {
    clearInterval(timer);
  }
  writeProgress(progressLine(file, done, total, detail), true);
}

function tailFile(file: string, lines = 30): string {
  if (!fs.existsSync(file)) {
    return '';
  }
  return fs.readFileSync(file, 'utf8').split(/\r?\n/).slice(-lines).join('\n');
}

async function sleep(ms: number): Promise<void> {
  if (ms <= 0) {
    return;
  }
  await new Promise((resolve) => setTimeout(resolve, ms));
}

/// 构造 agent CLI 命令（codex / claude；两者都能读写工作区文件，复用「agent 写 outPath + 轮询」流程）。
function agentCommand(prompt: string): [string, string[]] {
  if (BACKEND === 'claude') {
    // prompt 必须紧跟 -p 作为其定位参数：新版 claude CLI 的 --allowedTools 是变参
    // （可吞掉后续 token），若把 prompt 放在 --allowedTools 之后会被当成额外的工具名吃掉。
    return [
      'claude',
      [
        '-p',
        prompt,
        '--permission-mode',
        'acceptEdits',
        '--allowedTools',
        'Read,Write,Edit',
        ...(CLAUDE_MODEL ? ['--model', CLAUDE_MODEL] : []),
      ],
    ];
  }
  // codex（默认）
  const codexArgs = [
    'exec',
    '-c',
    'mcp_servers={}',
    '-c',
    `model_reasoning_effort="${CODEX_REASONING}"`,
    '-s',
    'workspace-write',
    '--color',
    'never',
  ];
  if (CODEX_MODEL) {
    codexArgs.push('-m', CODEX_MODEL);
  }
  codexArgs.push(prompt);
  return ['codex', codexArgs];
}

async function runCodex(
  prompt: string,
  logPath: string,
  successProbe?: () => boolean,
): Promise<boolean> {
  const [cmd, args] = agentCommand(prompt);

  if (CODEX_STDIO === 'inherit') {
    return await new Promise((resolve) => {
      const child = spawn(cmd, args, {
        cwd: ROOT,
        env: { ...process.env, NO_COLOR: '1' },
        stdio: 'inherit',
      });
      let outputReady = false;
      let killTimer: ReturnType<typeof setTimeout> | null = null;
      const probeTimer = successProbe
        ? setInterval(() => {
            if (!outputReady && successProbe()) {
              outputReady = true;
              child.kill('SIGTERM');
              killTimer = setTimeout(
                () => child.kill('SIGKILL'),
                CODEX_OUTPUT_KILL_MS,
              );
            }
          }, CODEX_OUTPUT_POLL_MS)
        : null;
      child.on('close', (code) => {
        if (probeTimer) clearInterval(probeTimer);
        if (killTimer) clearTimeout(killTimer);
        resolve(outputReady || code === 0);
      });
      child.on('error', () => {
        if (probeTimer) clearInterval(probeTimer);
        if (killTimer) clearTimeout(killTimer);
        resolve(outputReady);
      });
    });
  }

  fs.mkdirSync(path.dirname(logPath), { recursive: true });
  const log = fs.createWriteStream(logPath, { flags: 'a' });
  log.write(
    [
      `\n=== ${new Date().toISOString()} ===`,
      `cwd: ${ROOT}`,
      `${cmd} ${args.slice(0, -1).join(' ')} <prompt>`,
      '',
    ].join('\n'),
  );

  return await new Promise((resolve) => {
    const child = spawn(cmd, args, {
      cwd: ROOT,
      env: { ...process.env, NO_COLOR: '1' },
      stdio: ['ignore', 'pipe', 'pipe'],
    });

    let outputReady = false;
    let killTimer: ReturnType<typeof setTimeout> | null = null;
    const probeTimer = successProbe
      ? setInterval(() => {
          if (!outputReady && successProbe()) {
            outputReady = true;
            log.write(
              `\n=== detected complete output; terminating Codex wrapper ===\n`,
            );
            child.kill('SIGTERM');
            killTimer = setTimeout(
              () => child.kill('SIGKILL'),
              CODEX_OUTPUT_KILL_MS,
            );
          }
        }, CODEX_OUTPUT_POLL_MS)
      : null;

    child.stdout.pipe(log, { end: false });
    child.stderr.pipe(log, { end: false });
    child.on('close', (code) => {
      if (probeTimer) clearInterval(probeTimer);
      if (killTimer) clearTimeout(killTimer);
      log.write(`\n=== exit ${code} ===\n`);
      log.end();
      resolve(outputReady || code === 0);
    });
    child.on('error', (err) => {
      if (probeTimer) clearInterval(probeTimer);
      if (killTimer) clearTimeout(killTimer);
      log.write(`\n=== spawn error: ${err.message} ===\n`);
      log.end();
      resolve(outputReady);
    });
  });
}

/// OpenAI API 后端：把本批 JSON 发给 chat completions，要求返回 {translations, glossary_additions}，
/// translations 写 outPath、glossary_additions 写 addPath（与 agent 后端一致，自动扩术语表；
/// mergeGlossaryAdditions 之后还会再过滤一遍）。用 OPENAI_API_KEY + OPENAI_MODEL（可配 base_url
/// 走兼容 OpenAI 协议的服务，如 DeepSeek/通义/本地 vLLM）。
async function runOpenAI(
  batch: Catalog,
  mode: WorkMode,
  outPath: string,
  addPath: string,
  logPath: string,
  idToScope: Record<string, string> = {},
): Promise<boolean> {
  if (!OPENAI_API_KEY) {
    console.error('  ⚠ 未设置 OPENAI_API_KEY（或 I18N_OPENAI_API_KEY）');
    return false;
  }
  const task =
    mode === 'terms'
      ? '这些条目的现有译文与术语表不一致；请重新给出自然中文译文，并严格套用术语表。'
      : '把每个值翻译为目标语言。';
  const system =
    `你是 Space Station 13 游戏文本的专业本地化译者，目标语言：${LOCALE}。${task}` +
    `输入是紧凑 JSON：键 -> 唯一英文源。规则：` +
    `(1) 键完全不变；(2) 逐字保留 {0}/{1}… 占位符、HTML 标签、DM 文本宏（如 \\improper、\\the）、` +
    `以及 %XXX% 形式的整段标记（如 %USER%/%TARGET%/%TARGET_PRONOUN_THEIR%，连同两侧 % 一字不改）；` +
    `(3) 严格遵循术语表（value===key 的词保持英文不翻，其余英文务必译为中文，不要中英混杂）；` +
    `(4) 大写缩写（APC/RCD/AI 等）保留英文。` +
    `只返回一个 JSON 对象：{"translations": {键 -> 译文，键与输入完全一致}, ` +
    `"glossary_additions": {英文固定专名 -> 中文}}，不要 Markdown、不要解释。` +
    `glossary_additions 只收术语表里没有的「固定专名」：品牌、阵营/组织、物种、舰船/站点/地图名、` +
    `唯一装备/武器/药剂/材料、型号、缩写、必须保留英文的命令或程序名；` +
    `不要收普通单词、多义词、颜色、大小、方向、形容词、泛称名词、可随语境翻译的词` +
    `（如 white/black/large/small/left/right/agent/vendor/crate）。不确定就不收。没有就写 {}。` +
    `术语表（仅本批命中）：\n${glossaryHint(batch)}` +
    scopeSection(idToScope);
  fs.mkdirSync(path.dirname(logPath), { recursive: true });
  try {
    const res = await fetch(`${OPENAI_BASE_URL}/chat/completions`, {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
        authorization: `Bearer ${OPENAI_API_KEY}`,
      },
      body: JSON.stringify({
        model: OPENAI_MODEL,
        temperature: 0,
        response_format: { type: 'json_object' },
        messages: [
          { role: 'system', content: system },
          { role: 'user', content: JSON.stringify(batch) },
        ],
      }),
    });
    if (!res.ok) {
      fs.appendFileSync(
        logPath,
        `\n=== openai HTTP ${res.status} ===\n${await res.text()}\n`,
      );
      return false;
    }
    const data = (await res.json()) as {
      choices?: { message?: { content?: string } }[];
    };
    const content = data?.choices?.[0]?.message?.content;
    if (typeof content !== 'string') {
      fs.appendFileSync(logPath, `\n=== openai 无 content ===\n`);
      return false;
    }
    const parsed = JSON.parse(content);
    // 兼容：模型若直接返回 id->译文（无 translations 包裹），则整体当 translations。
    const translations =
      parsed && typeof parsed === 'object' && parsed.translations &&
      typeof parsed.translations === 'object'
        ? parsed.translations
        : parsed;
    fs.writeFileSync(outPath, `${JSON.stringify(translations)}\n`);
    const additions = parsed?.glossary_additions;
    if (
      additions &&
      typeof additions === 'object' &&
      Object.keys(additions).length > 0
    ) {
      fs.writeFileSync(addPath, `${JSON.stringify(additions)}\n`);
    }
    return true;
  } catch (err) {
    fs.appendFileSync(
      logPath,
      `\n=== openai error: ${(err as Error)?.message} ===\n`,
    );
    return false;
  }
}

/**
 * 条目的语境提示 = 它所属 DM 类型路径的前 4 段（`/datum/reagent/medicine/c2/multiver`
 * -> `/datum/reagent/medicine`）。前缀比叶子有用：要判的是「这是试剂还是区域名」，
 * 不是具体哪个试剂。TGUI 条目直接给界面名（`tgui:ChemReactionChamber`）。
 */
function scopeHint(key: string): string | null {
  const paths = scopesByKey[key];
  if (!paths?.length) return null;
  const p = paths[0];
  if (!p.startsWith('/')) return p; // tgui:XXX
  return p.split('/').slice(0, 5).join('/');
}

function shortIdBatch(batch: Catalog): {
  codexBatch: Catalog;
  idToKeys: string[][];
  idToScope: Record<string, string>;
} {
  const codexBatch: Catalog = {};
  const idToKeys: string[][] = [];
  const idToScope: Record<string, string> = {};
  const valueToId = new Map<string, number>();
  for (const key of Object.keys(batch)) {
    const value = batch[key];
    const existingId = valueToId.get(value);
    if (existingId != null) {
      idToKeys[existingId].push(key);
      continue;
    }
    const numericId = idToKeys.length;
    const id = String(numericId);
    valueToId.set(value, numericId);
    idToKeys.push([key]);
    codexBatch[id] = value;
    const scope = scopeHint(key);
    if (scope) idToScope[id] = scope;
  }
  return { codexBatch, idToKeys, idToScope };
}

/** 语境段落。同一路径下的 id 合并成一行，避免逐条重复长路径。 */
function scopeSection(idToScope: Record<string, string>): string {
  const byScope = new Map<string, string[]>();
  for (const [id, scope] of Object.entries(idToScope)) {
    if (!byScope.has(scope)) byScope.set(scope, []);
    byScope.get(scope)?.push(id);
  }
  if (byScope.size === 0) return '';
  const lines = [...byScope.entries()].map(
    ([scope, ids]) => `- ${scope}: ${ids.join(',')}`,
  );
  return (
    '\n各条目在游戏源码里的所属类型（**只用来判断语境，绝不要翻译或写进译文**）。' +
    'DM 类型路径能直接消歧：/datum/reagent 下的 Base 是「碱」，/area 下的是「基地」；' +
    `/obj/item 下的短语多为物品名（名词短语，别翻成句子）：\n${lines.join('\n')}`
  );
}

function mapTranslatedBatch(
  raw: Catalog,
  idToKeys: string[][],
  batch: Catalog,
): Catalog {
  const translated: Catalog = {};
  for (const [id, value] of Object.entries(raw)) {
    const numericId = Number(id);
    const keys =
      Number.isInteger(numericId) && numericId >= 0
        ? idToKeys[numericId]
        : [id];
    for (const key of keys ?? []) {
      if (!(key in batch)) {
        continue;
      }
      translated[key] = value;
    }
  }
  return translated;
}

function reusableCatalog(
  inPath: string,
  keysPath: string,
  outPath: string,
  codexBatch: Catalog,
  idToKeys: string[][],
  batch: Catalog,
): Catalog | null {
  if (
    !jsonFileEquals(inPath, codexBatch) ||
    !jsonFileEquals(keysPath, idToKeys) ||
    !fs.existsSync(outPath)
  ) {
    return null;
  }

  let raw: Catalog;
  try {
    raw = readCatalog(outPath);
  } catch {
    return null;
  }

  const expectedIds = Object.keys(codexBatch).sort();
  const actualIds = Object.keys(raw).sort();
  if (JSON.stringify(expectedIds) !== JSON.stringify(actualIds)) {
    return null;
  }

  const catalog = mapTranslatedBatch(raw, idToKeys, batch);
  if (Object.keys(catalog).length !== Object.keys(batch).length) {
    return null;
  }

  return catalog;
}

function reusableTranslatedBatch(
  inPath: string,
  keysPath: string,
  outPath: string,
  addPath: string,
  codexBatch: Catalog,
  idToKeys: string[][],
  batch: Catalog,
): TranslatedBatch | null {
  const catalog = reusableCatalog(
    inPath,
    keysPath,
    outPath,
    codexBatch,
    idToKeys,
    batch,
  );
  if (!catalog) {
    return null;
  }

  const glossaryAdded = fs.existsSync(addPath)
    ? mergeGlossaryAdditions(readCatalog(addPath))
    : 0;
  return { catalog, glossaryAdded, reused: true };
}

/**
 * 术语强制回合数。术语表从前只是塞进提示词的**建议**，模型爱听不听 —— 于是同一个
 * 试剂能在目录里攒出七种叫法。这里把它变成**保证**：每批翻完立刻自查，违规条目
 * 单独重发（只发违规的那几条，便宜），最多 N 轮；仍不合规就留给 `terms` 报告和人工。
 * 0 = 关闭（回到纯建议模式）。
 */
const TERM_ENFORCE_ROUNDS = Math.max(0, envInt('I18N_TERM_ROUNDS', 2));

/** 本批里译文违反术语表的 key。 */
function batchTermViolations(batch: Catalog, catalog: Catalog): string[] {
  const bad: string[] = [];
  for (const key of Object.keys(catalog)) {
    const en = batch[key];
    if (en == null) continue;
    if (termMismatches(en, catalog[key], key).length > 0) bad.push(key);
  }
  return bad;
}

/**
 * 就地修正 catalog 里违反术语表的条目。
 *
 * 只在**确实变好**时才采纳重翻结果（违规数下降）：重翻是整条重来，可能修好术语却
 * 把句子别处翻坏。宁可留着旧的进 `terms` 报告等人工，也不要静默变差。
 */
async function enforceGlossary(
  file: string,
  idx: number | string,
  batch: Catalog,
  catalog: Catalog,
): Promise<{ fixed: number; left: number }> {
  let fixed = 0;
  let left = 0;
  for (let round = 1; round <= TERM_ENFORCE_ROUNDS; round++) {
    const bad = batchTermViolations(batch, catalog);
    left = bad.length;
    if (left === 0) break;
    const sub: Catalog = {};
    for (const key of bad) sub[key] = batch[key];
    // enforce=false：重试自身不再触发强制，避免无限递归。
    const retry = await translateBatch(file, `${idx}f${round}`, sub, 'terms', false);
    if (!retry) break;
    for (const [key, value] of Object.entries(retry.catalog)) {
      if (batch[key] == null) continue;
      const before = termMismatches(batch[key], catalog[key], key).length;
      const after = termMismatches(batch[key], value, key).length;
      if (after < before) {
        catalog[key] = value;
        if (after === 0) fixed++;
      }
    }
    left = batchTermViolations(batch, catalog).length;
  }
  return { fixed, left };
}

async function translateBatch(
  file: string,
  idx: number | string,
  batch: Catalog,
  mode: WorkMode,
  enforce = true,
): Promise<TranslatedBatch | null> {
  const inPath = path.join(
    PENDING_DIR,
    file.replace(/\.json$/, `.${idx}.json`),
  );
  const outPath = path.join(
    PENDING_DIR,
    file.replace(/\.json$/, `.${idx}.${LOCALE}.json`),
  );
  const addPath = path.join(
    PENDING_DIR,
    file.replace(/\.json$/, `.${idx}.glossary.json`),
  );
  const keysPath = path.join(
    PENDING_DIR,
    file.replace(/\.json$/, `.${idx}.keys.json`),
  );
  const logPath = path.join(
    PENDING_DIR,
    file.replace(/\.json$/, `.${idx}.codex.log`),
  );
  const { codexBatch, idToKeys, idToScope } = shortIdBatch(batch);

  const reusable = reusableTranslatedBatch(
    inPath,
    keysPath,
    outPath,
    addPath,
    codexBatch,
    idToKeys,
    batch,
  );
  if (reusable) {
    return reusable;
  }

  fs.rmSync(outPath, { force: true });
  fs.rmSync(addPath, { force: true });
  fs.rmSync(keysPath, { force: true });
  fs.rmSync(logPath, { force: true });
  fs.writeFileSync(inPath, `${JSON.stringify(codexBatch)}\n`);
  fs.writeFileSync(keysPath, `${JSON.stringify(idToKeys)}\n`);

  const task =
    mode === 'terms'
      ? '这些条目的现有译文与术语表不一致；请重新给出自然中文译文，并严格套用术语表。'
      : '把每个值翻译为目标语言。';
  const prompt =
    `你是 Space Station 13 游戏文本的专业本地化译者，目标语言：${LOCALE}。${task}` +
    `读取 ${path.relative(ROOT, inPath)}（紧凑 JSON：临时数字 ID -> 唯一英文源；数字 ID 不是目录 key，可能映射到多个真实 key），把每个值翻译为目标语言，写入 ` +
    `${path.relative(ROOT, outPath)}：` +
    `(1) 临时数字 ID 完全不变，不要输出真实目录 key；(2) 逐字保留 {0}/{1}… 占位符、HTML 标签、DM 文本宏（如 \\improper、\\the）、以及 %XXX% 形式整段标记（如 %USER%/%TARGET%，连同两侧 % 一字不改）；` +
    `(3) 严格遵循术语表（保持英文的词不要翻译，其余英文务必译为中文，不要中英混杂）；` +
    `(4) 大写缩写（APC/RCD/AI 等）保留英文；(5) 只输出/写入紧凑合法 JSON，键序与输入一致，不要 Markdown。` +
    `(6) 凡是术语表里没有的「固定专名/术语」才追加到 ${path.relative(ROOT, addPath)}：` +
    `只包括品牌、阵营/组织、物种、舰船/站点/地图名、唯一装备/武器/药剂/材料、型号、缩写、必须保留英文的命令或程序名。` +
    `不要追加普通单词、多义词、颜色、大小、方向、形容词、泛称名词、可随语境翻译的词（例如 white/black/large/small/left/right/agent/vendor/crate 等）。` +
    `不确定是否固定，就不要加入术语表。本批没有合格新增术语就写 {}。` +
    `以下术语表只列本批命中的术语；若需要完整术语表可用 I18N_FULL_GLOSSARY=1 运行。术语表：\n${glossaryHint(batch)}` +
    scopeSection(idToScope);

  const ok =
    BACKEND === 'openai'
      ? await runOpenAI(codexBatch, mode, outPath, addPath, logPath, idToScope)
      : await runCodex(prompt, logPath, () =>
          Boolean(
            reusableCatalog(
              inPath,
              keysPath,
              outPath,
              codexBatch,
              idToKeys,
              batch,
            ),
          ),
        );
  if (!ok) {
    const logHint =
      CODEX_STDIO === 'inherit'
        ? 'Codex 输出已直接打印到终端'
        : `日志：${path.relative(ROOT, logPath)}`;
    console.error(`\n  ⚠ ${BACKEND_LABEL} 执行失败，${logHint}`);
    const tail = tailFile(logPath);
    if (tail) {
      console.error(tail);
    }
    return null;
  }

  let glossaryAdded = 0;
  // 合并 Codex 这批新发现的固定词到术语表（仅新增，后续批次/文件即可复用，保持译名一致）。
  if (fs.existsSync(addPath)) {
    glossaryAdded = mergeGlossaryAdditions(readCatalog(addPath));
  }

  if (!fs.existsSync(outPath)) {
    console.error(`  ⚠ ${BACKEND_LABEL} 未产出 ${path.relative(ROOT, outPath)}`);
    return null;
  }
  const catalog = mapTranslatedBatch(readCatalog(outPath), idToKeys, batch);
  if (Object.keys(catalog).length === 0 && Object.keys(batch).length > 0) {
    console.error(
      `  ⚠ ${BACKEND_LABEL} 输出没有可映射的临时数字 ID：${path.relative(ROOT, outPath)}`,
    );
    return null;
  }
  // 术语强制：翻完立刻自查违规并定点重发（见 enforceGlossary）。
  let termFixed = 0;
  let termLeft = 0;
  if (enforce && TERM_ENFORCE_ROUNDS > 0) {
    const res = await enforceGlossary(file, idx, batch, catalog);
    termFixed = res.fixed;
    termLeft = res.left;
  }

  return {
    catalog,
    glossaryAdded,
    termFixed,
    termLeft,
  };
}

/// 按后端检查前置条件（agent 查 CLI 是否在 PATH，openai 查 key）。失败返回 false。
function checkBackendReady(): boolean {
  if (BACKEND === 'openai') {
    if (!OPENAI_API_KEY) {
      console.error('I18N_BACKEND=openai 需设置 OPENAI_API_KEY（或 I18N_OPENAI_API_KEY）。');
      return false;
    }
    return true;
  }
  if (BACKEND !== 'codex' && BACKEND !== 'claude') {
    console.error(`未知 I18N_BACKEND=${BACKEND}（可选 codex / claude / openai）。`);
    return false;
  }
  const cli = BACKEND === 'claude' ? 'claude' : 'codex';
  if (!Bun.which(cli)) {
    console.error(
      `未找到 ${cli} CLI。请先安装并登录 ${BACKEND_LABEL}（或改 I18N_BACKEND=openai 用 API）。`,
    );
    return false;
  }
  return true;
}

async function cmdTranslate(
  args: string[],
  mode: WorkMode = 'pending',
): Promise<boolean> {
  if (!checkBackendReady()) return false;
  fs.mkdirSync(PENDING_DIR, { recursive: true });
  fs.mkdirSync(DST_DIR, { recursive: true });
  // 优化①：跨命名空间复用表（仅 pending 模式；terms 模式要重译修术语，不复用）。
  const globalReverse =
    mode === 'pending' && REUSE ? buildGlobalReverse() : new Map<string, string>();
  let codexCallsStarted = 0;
  let stopped = false; // 达到上限或失败：停止开新调用
  let hardFail = false; // 失败且不续跑：返回 false
  for (const file of namespaceFiles(args)) {
    if (stopped) break;
    const pending =
      mode === 'terms' ? computeTermPending(file) : computePending(file);
    let keys = Object.keys(pending);
    if (keys.length === 0) {
      console.log(
        `${file}: 无${mode === 'terms' ? '术语不一致' : '待译'}，跳过`,
      );
      continue;
    }
    const dstFile = path.join(DST_DIR, file);
    if (
      !ensureWritableTarget(dstFile, '译文文件') ||
      !ensureWritableTarget(GLOSSARY_PATH, '术语表')
    ) {
      return false;
    }
    // 优化①：先用全局表把「别处已译过的英文」直接填上，不再调模型。
    if (mode === 'pending' && REUSE && globalReverse.size) {
      const merged = readCatalog(dstFile);
      let prefilled = 0;
      const remaining: string[] = [];
      for (const key of keys) {
        const reused = globalReverse.get(pending[key]);
        if (reused !== undefined) {
          merged[key] = reused;
          prefilled++;
        } else {
          remaining.push(key);
        }
      }
      if (prefilled) {
        writeSorted(dstFile, merged);
        console.log(`${file}: 复用已有译文 ${prefilled} 条（不调用模型）`);
      }
      keys = remaining;
    }
    if (keys.length === 0) {
      continue;
    }
    const batches = Math.ceil(keys.length / CHUNK);
    console.log(
      `${file}: ${mode === 'terms' ? '术语不一致' : '待译'} ${keys.length}，分 ${batches} 批（每批 ${CHUNK}，并发 ${CONCURRENCY}，后端 ${BACKEND_LABEL}）`,
    );
    // **按 DM 类型路径排序后再切批**：同一类型的条目落进同一批，模型能看到成组的
    // 上下文（"multiver bottle" 与 "A small bottle of multiver." 一起翻），
    // 语境段落也能按路径合并、少占 token。次键用 key 保证切批稳定可复现。
    keys.sort((a, b) => {
      const sa = scopeHint(a) ?? '~';
      const sb = scopeHint(b) ?? '~';
      return sa === sb ? a.localeCompare(b) : sa.localeCompare(sb);
    });
    // 预切批。
    const batchItems: { idx: number; batch: Catalog }[] = [];
    for (let start = 0, idx = 0; start < keys.length; start += CHUNK, idx++) {
      const batch: Catalog = {};
      for (const key of keys.slice(start, start + CHUNK))
        batch[key] = pending[key];
      batchItems.push({ idx, batch });
    }
    // 优化②：并发池（CONCURRENCY 个 worker 拉取批；合并落盘是同步块、worker 间不会交错，安全）。
    let nextItem = 0;
    const worker = async (): Promise<void> => {
      while (!stopped) {
        const item = batchItems[nextItem++];
        if (!item) return;
        if (MAX_CODEX_CALLS > 0 && codexCallsStarted >= MAX_CODEX_CALLS) {
          stopped = true;
          console.log(
            `达到本次调用上限 I18N_MAX_CODEX_CALLS=${MAX_CODEX_CALLS}。重跑同一命令会从剩余待译继续；需要不限量可设 I18N_MAX_CODEX_CALLS=0。`,
          );
          return;
        }
        const batchNo = item.idx + 1;
        const callNo = ++codexCallsStarted;
        const timer = startProgress(
          file,
          item.idx,
          batches,
          `call ${callNo}${MAX_CODEX_CALLS > 0 ? `/${MAX_CODEX_CALLS}` : ''} 批 ${batchNo}/${batches} ${BACKEND_LABEL} 翻译 ${Object.keys(item.batch).length} 条`,
        );
        const translatedBatch = await translateBatch(
          file,
          item.idx,
          item.batch,
          mode,
        );
        if (!translatedBatch) {
          finishProgress(timer, file, item.idx, batches, `批 ${batchNo}/${batches} 失败`);
          if (!CONTINUE_ON_FAIL) {
            stopped = true;
            hardFail = true;
          }
          continue;
        }
        // 同步合并落盘（read→apply→write 无 await，并发安全；断点续译：重跑会重算待译）。
        const merged = readCatalog(dstFile);
        let applied = 0;
        let refused = 0;
        for (const key of Object.keys(translatedBatch.catalog)) {
          if (key in item.batch) {
            // **绝不用更违规的译文覆盖更合规的**。
            // 强制回环最多重试 N 轮，仍不合规的条目照样会被写回去 —— 而它覆盖的
            // 旧译文可能本来是**对的**。实测：blanks.json 的「纳米传讯」被重翻成
            // 「纳米特兰森」，两轮重试没救回来，于是一条合规译文被违规译文顶掉了。
            // 术语违规数只许降不许升；持平才看新译文（那是正常的润色）。
            const before = termMismatches(
              item.batch[key],
              merged[key],
              key,
            ).length;
            const after = termMismatches(
              item.batch[key],
              translatedBatch.catalog[key],
              key,
            ).length;
            if (merged[key] != null && after > before) {
              refused++;
              continue;
            }
            merged[key] = translatedBatch.catalog[key];
            applied++;
            if (REUSE) globalReverse.set(item.batch[key], translatedBatch.catalog[key]);
            // 模型选择保持英文（返回值==英文原文）→ 登记白名单，下轮不再重送（专名/cult/程序名…）。
            if (translatedBatch.catalog[key] === item.batch[key])
              markKeepEnglish(key, item.batch[key]);
          }
        }
        writeSorted(dstFile, merged);
        flushKeepEnglish();
        finishProgress(
          timer,
          file,
          batchNo,
          batches,
          (translatedBatch.reused
            ? `批 ${batchNo}/${batches} 复用 .pending 输出，合并 ${applied}`
            : `批 ${batchNo}/${batches} 合并 ${applied}`) +
            (refused ? `，拒收更违规的 ${refused}` : '') +
            (translatedBatch.termFixed
              ? `，术语强制修正 ${translatedBatch.termFixed}`
              : '') +
            (translatedBatch.termLeft
              ? `，仍违规 ${translatedBatch.termLeft}（留待 terms 报告）`
              : ''),
        );
        if (translatedBatch.glossaryAdded) {
          console.log(
            `  术语表 +${translatedBatch.glossaryAdded}（已并入 ${path.relative(ROOT, GLOSSARY_PATH)}）`,
          );
        }
        if (CODEX_DELAY_MS) await sleep(CODEX_DELAY_MS);
      }
    };
    await Promise.all(
      Array.from({ length: Math.min(CONCURRENCY, batchItems.length) }, worker),
    );
    if (hardFail) {
      console.error(
        '已停止，避免继续启动新的调用。处理登录/额度/日志里的错误后，重跑同一命令会从剩余待译继续；若确实要跳过失败继续，设 I18N_CONTINUE_ON_FAIL=1。',
      );
      return false;
    }
  }
  console.log(`完成。请抽检后提交 strings/i18n/${LOCALE}。`);
  return true;
}

// 第一个参数不是已知子命令时（如直接传 `tgui.json`）默认走 translate（与旧 wrapper 行为一致）。
/// 清理术语表里的「描述性短语」（房间/设施/泛物名，以通用中心词结尾）——它们不该当固定术语。
/// 默认 dry-run 只预览；--apply 或 I18N_PRUNE_APPLY=1 才实际删除（删后请 git diff 复核）。
function cmdPruneGlossary(args: string[]): void {
  const apply = args.includes('--apply') || envFlag('I18N_PRUNE_APPLY');
  // 跳过「保持英文」条目（value===key，如 /vg/station、CDK Station）——那是有意保留的。
  const flagged = Object.keys(glossary).filter(
    (k) => isGenericPhrase(k) && glossary[k] !== k,
  );
  console.log(
    `术语表 ${Object.keys(glossary).length} 条；可清理（描述性短语，通用中心词结尾）${flagged.length} 条：`,
  );
  for (const k of flagged.slice(0, 40)) console.log(`  - ${k}  →  ${glossary[k]}`);
  if (flagged.length > 40) console.log(`  …（共 ${flagged.length} 条）`);
  if (!apply) {
    console.log(
      '\n以上为预览（dry-run）。确认无误后加 --apply（或 I18N_PRUNE_APPLY=1）实际删除。',
    );
    return;
  }
  for (const k of flagged) delete glossary[k];
  saveGlossary();
  console.log(
    `\n已删除 ${flagged.length} 条，术语表现 ${Object.keys(glossary).length} 条。请 git diff 复核。`,
  );
}

/// 把当前所有「zh==en 且会被判待译」的 key 登记进 keep-english 白名单（专名/cult 咒语/程序名/
/// base64/字体名等故意保持英文的条目）。一次性种子：跑过后这些 key 不再每轮被当待译重送模型。
/// 白名单文件可人工编辑——若某条其实想译，删掉它即恢复重译。
function cmdMarkEnglish(args: string[]): void {
  let total = 0;
  for (const file of namespaceFiles(args)) {
    const en = readCatalog(path.join(EN_DIR, file));
    const zh = readCatalog(path.join(DST_DIR, file));
    let n = 0;
    for (const key of Object.keys(en)) {
      if (
        zh[key] === en[key] &&
        hasEnglishWord(en[key]) &&
        !looksLikeCodeIdentifier(en[key]) &&
        !isKeepEnglish(key, en[key])
      ) {
        markKeepEnglish(key, en[key]);
        n++;
      }
    }
    if (n) console.log(`${file}: 登记保持英文 ${n}`);
    total += n;
  }
  flushKeepEnglish();
  console.log(
    `完成。共登记 ${total} 条到 ${path.relative(ROOT, KEEP_EN_PATH)}（可人工编辑；删除某条即恢复重译）。`,
  );
}

/**
 * 把「深度复查（I18N_MISSING_ONLY=0）会反复标记的中英混杂条目」批量登记为保持英文：
 * 这些条目往往已被模型翻过一轮、输出仍保留英文（拉丁彩蛋、@pick 模板语法、动态拼接 key、
 * 专名密集句）——模型自己的判断就是「英文该留」，反复重翻只烧额度不收敛。登记后
 * needsTranslation 的混杂分支直接放行；后续人工在在线平台改译文不受影响，删除
 * keep-english 里对应条目即恢复机器重译。
 */
function cmdAcceptMixed(args: string[]): void {
  let total = 0;
  for (const file of namespaceFiles(args)) {
    const en = readCatalog(path.join(EN_DIR, file));
    const zh = readCatalog(path.join(DST_DIR, file));
    let n = 0;
    for (const key of Object.keys(en)) {
      const zhVal = zh[key];
      if (zhVal == null || zhVal === '' || zhVal === en[key]) continue; // 未译/占位交给 mark-english
      if (isKeepEnglish(key, en[key])) continue;
      const stray = hasEnglishWord(zhVal);
      const flagged =
        (!CJK.test(zhVal) && stray) ||
        (CJK.test(zhVal) && stray && hasStrayEnglishInTranslation(zhVal));
      if (flagged) {
        markKeepEnglish(key, en[key]);
        n++;
      }
    }
    if (n) console.log(`${file}: 接受混杂现状 ${n}`);
    total += n;
  }
  flushKeepEnglish();
  console.log(
    `完成。共登记 ${total} 条到 ${path.relative(ROOT, KEEP_EN_PATH)}（删除某条即恢复重译）。`,
  );
}

const SUBCOMMANDS = new Set([
  'pending',
  'terms',
  'term-pending',
  'translate',
  'translate-terms',
  'repair-terms',
  'prune-glossary',
  'mark-english',
  'accept-mixed',
]);
const argv = process.argv.slice(2);
const isCmd = argv.length > 0 && SUBCOMMANDS.has(argv[0]);
const cmd = isCmd ? argv[0] : 'translate';
const rest = isCmd ? argv.slice(1) : argv;

if (cmd === 'pending') cmdPending(rest);
else if (cmd === 'mark-english') cmdMarkEnglish(rest);
else if (cmd === 'accept-mixed') cmdAcceptMixed(rest);
else if (cmd === 'terms' || cmd === 'term-pending') cmdTerms(rest);
else if (cmd === 'prune-glossary') cmdPruneGlossary(rest);
else if (cmd === 'translate-terms' || cmd === 'repair-terms') {
  if (!(await cmdTranslate(rest, 'terms'))) process.exit(1);
} else {
  if (!(await cmdTranslate(rest))) process.exit(1);
}
