#!/usr/bin/env bun
// 上游更新日志（html/changelogs/archive/YYYY-MM.yml）的机翻，在同步上游时跑。
//
// 产物是每月一张「英文原文 → 译文」对照表：html/changelogs/localization/upstream/<locale>/YYYY-MM.json。
// 上游的归档文件一个字都不动（同步上游永不冲突），游戏内「更新日志」页签由前端按原文查表替换，
// 查不到的条目照常显示英文。按原文而不是按位置对齐，所以上游在月中追加、改写条目都不会错位。
//
// 这些译文**不进** strings/i18n 目录：tgui.json 会打进前端 bundle、DM 侧会把目录并进全局反查表，
// 几十万字的开发日志放进去既撑大 bundle、又凭空扩大误翻面。
//
// 只处理 START_MONTH 及以后的月份：历史日志不回填，从开始翻译的那个月起随同步逐月补齐。
// 每次运行只翻表里还没有的条目，已翻的原样保留；上游删掉的条目随之从表里摘掉。
//
// 用法：bun tools/i18n/changelog-mt.ts [YYYY-MM ...]（不带参数 = START_MONTH 起的全部月份）
// 复用 tools/i18n/mt/.env 的 OpenAI 兼容后端配置。
import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(import.meta.dir, '../..');
(() => {
  const envPath = path.join(ROOT, 'tools/i18n/mt/.env');
  if (!fs.existsSync(envPath)) return;
  for (const raw of fs.readFileSync(envPath, 'utf8').split('\n')) {
    const line = raw.trim();
    if (!line || line.startsWith('#')) continue;
    const eq = line.indexOf('=');
    if (eq < 0) continue;
    const key = line.slice(0, eq).trim();
    let val = line.slice(eq + 1).trim();
    if ((val.startsWith('"') && val.endsWith('"')) || (val.startsWith("'") && val.endsWith("'")))
      val = val.slice(1, -1);
    if (key && !(key in process.env)) process.env[key] = val;
  }
})();

/** 从这个月起翻译；更早的月份保持英文。 */
const START_MONTH = '2026-09';

const LOCALE = process.env.I18N_LOCALE ?? 'zh-Hans';
const API_KEY = process.env.OPENAI_API_KEY ?? process.env.I18N_OPENAI_API_KEY;
const MODEL = process.env.I18N_OPENAI_MODEL ?? 'gpt-4o-mini';
const BASE_URL = process.env.I18N_OPENAI_BASE_URL ?? 'https://api.openai.com/v1';
const CHUNK = Number(process.env.I18N_CHUNK ?? 40);
const CONCURRENCY = Number(process.env.I18N_CONCURRENCY ?? 4);

const ARCHIVE_DIR = path.join(ROOT, 'html/changelogs/archive');
const OUT_DIR = path.join(ROOT, 'html/changelogs/localization/upstream', LOCALE);
const GLOSSARY_PATH = path.join(ROOT, `tools/i18n/mt/glossary.${LOCALE}.json`);

const SYSTEM = `你在为太空站模拟游戏 Space Station 13（NovaSector 服务器）翻译更新日志，读者是简体中文玩家。
输入是一个 JSON 对象，每个值是一条更新日志条目（英文）。
规则：
1. 输出一个 JSON 对象，键与输入完全相同，值是对应条目的简体中文译文；不增不减任何键。
2. 译成简洁自然的更新说明，保留原意，不要添加解释。
3. 地图名、站点名、人名、型号、缩写、代码/类型路径（如 /obj/item/...）、PR/issue 编号、链接保持原样。
4. HTML 标签、markdown 标记和反引号里的内容原样保留。
5. 附带的术语表给出了游戏内既有译名，出现时请沿用。`;

type GlossaryValue = string | { zh: string; scope?: unknown } | { zh: string; scope?: unknown }[];

/** 术语表里的首选译名：优先取不带语境限定的义项（更新日志没有语境可判）。 */
function glossaryZh(value: GlossaryValue): string {
  if (typeof value === 'string') return value;
  const senses = Array.isArray(value) ? value : [value];
  return (senses.find((s) => s.scope == null) ?? senses[0])?.zh ?? '';
}

const glossary: [string, string][] = fs.existsSync(GLOSSARY_PATH)
  ? Object.entries(JSON.parse(fs.readFileSync(GLOSSARY_PATH, 'utf8')) as Record<string, GlossaryValue>)
      .map(([en, v]): [string, string] => [en, glossaryZh(v)])
      .filter(([en, zh]) => en.length >= 3 && zh.length > 0 && zh !== en)
  : [];

/** 只把本批条目里真正出现过的术语交给模型，整张表两千多条塞进去只会稀释注意力。 */
function glossaryHint(texts: string[]): string {
  const joined = texts.join('\n');
  const hits = glossary.filter(([en]) => {
    const at = joined.indexOf(en);
    if (at < 0) return false;
    // 词边界：挡住 "Ash" 咬进 "Ashwalker" 这种词内命中
    const before = joined[at - 1];
    const after = joined[at + en.length];
    return !/[A-Za-z0-9]/.test(before ?? '') && !/[A-Za-z0-9]/.test(after ?? '');
  });
  if (!hits.length) return '';
  return `\n\n术语表：\n${hits.map(([en, zh]) => `${en} → ${zh}`).join('\n')}`;
}

/// 超时/网络抖动重试：这类失败是暂时的，与「模型给的结果对不上」是两回事（后者靠二分收敛）。
async function postWithRetry(payload: unknown, attempt = 0): Promise<any> {
  try {
    const res = await fetch(`${BASE_URL}/chat/completions`, {
      method: 'POST',
      signal: AbortSignal.timeout(300_000),
      headers: { 'content-type': 'application/json', authorization: `Bearer ${API_KEY}` },
      body: JSON.stringify(payload),
    });
    if (!res.ok) throw new Error(`${res.status} ${await res.text()}`);
    return await res.json();
  } catch (err) {
    if (attempt >= 3) throw err;
    await new Promise((r) => setTimeout(r, 2000 * (attempt + 1)));
    return postWithRetry(payload, attempt + 1);
  }
}

/** 翻一批；结果缺键或值不是非空字符串就整批作废，交给调用方二分。 */
async function translateBatch(texts: string[]): Promise<string[] | null> {
  const input: Record<string, string> = {};
  texts.forEach((t, i) => {
    input[String(i + 1)] = t;
  });
  const json = await postWithRetry({
    model: MODEL,
    temperature: 0,
    response_format: { type: 'json_object' },
    messages: [
      { role: 'system', content: SYSTEM },
      { role: 'user', content: JSON.stringify(input, null, 1) + glossaryHint(texts) },
    ],
  });
  let parsed: Record<string, unknown>;
  try {
    parsed = JSON.parse(String(json.choices?.[0]?.message?.content ?? ''));
  } catch {
    return null;
  }
  const out = texts.map((_, i) => parsed[String(i + 1)]);
  if (out.some((v) => typeof v !== 'string' || !v.trim())) return null;
  return out as string[];
}

/** 对不齐就二分重试；单条仍失败则放弃这条（前端照常显示英文），而不是让整月作废。 */
async function translateAll(texts: string[]): Promise<Map<string, string>> {
  const result = new Map<string, string>();
  const failed: string[] = [];
  const run = async (batch: string[]): Promise<void> => {
    const out = await translateBatch(batch);
    if (out) {
      batch.forEach((t, i) => result.set(t, out[i]));
      return;
    }
    if (batch.length === 1) {
      failed.push(batch[0]);
      return;
    }
    const mid = Math.ceil(batch.length / 2);
    await run(batch.slice(0, mid));
    await run(batch.slice(mid));
  };
  const batches: string[][] = [];
  for (let i = 0; i < texts.length; i += CHUNK) batches.push(texts.slice(i, i + CHUNK));
  let next = 0;
  const workers = Array.from({ length: Math.min(CONCURRENCY, batches.length) }, async () => {
    while (next < batches.length) await run(batches[next++]);
  });
  await Promise.all(workers);
  for (const t of failed) console.warn(`  ⚠ 未能翻译，保留英文：${t.slice(0, 80)}`);
  return result;
}

/** 按归档里出现的顺序取全部条目原文（去重）。 */
function monthEntries(month: string): string[] {
  const data = Bun.YAML.parse(fs.readFileSync(path.join(ARCHIVE_DIR, `${month}.yml`), 'utf8')) as Record<
    string,
    Record<string, Record<string, unknown>[]>
  > | null;
  const seen = new Set<string>();
  for (const authors of Object.values(data ?? {})) {
    for (const changes of Object.values(authors ?? {})) {
      for (const change of changes ?? []) {
        for (const text of Object.values(change ?? {})) {
          if (text != null && String(text).trim()) seen.add(String(text));
        }
      }
    }
  }
  return [...seen];
}

async function main() {
  const requested = process.argv.slice(2);
  const months = (
    requested.length
      ? requested
      : fs
          .readdirSync(ARCHIVE_DIR)
          .filter((f) => /^\d{4}-\d{2}\.yml$/.test(f))
          .map((f) => f.slice(0, -4))
          .filter((m) => m >= START_MONTH)
  ).sort();

  fs.mkdirSync(OUT_DIR, { recursive: true });
  for (const month of months) {
    if (!/^\d{4}-\d{2}$/.test(month) || !fs.existsSync(path.join(ARCHIVE_DIR, `${month}.yml`))) {
      console.error(`没有上游归档：${month}`);
      process.exit(1);
    }
    const entries = monthEntries(month);
    const outPath = path.join(OUT_DIR, `${month}.json`);
    const existing: Record<string, string> = fs.existsSync(outPath)
      ? JSON.parse(fs.readFileSync(outPath, 'utf8'))
      : {};
    const missing = entries.filter((t) => !(t in existing));
    if (missing.length && !API_KEY) {
      console.error('需要 OPENAI_API_KEY（或 I18N_OPENAI_API_KEY）');
      process.exit(1);
    }
    const translated = missing.length ? await translateAll(missing) : new Map<string, string>();

    // 按归档顺序重写：已翻的保留、新翻的并入、上游已删的条目摘掉。
    const table: Record<string, string> = {};
    for (const t of entries) {
      const zh = existing[t] ?? translated.get(t);
      if (zh !== undefined) table[t] = zh;
    }
    fs.writeFileSync(outPath, `${JSON.stringify(table, null, '\t')}\n`);
    const dropped = Object.keys(existing).filter((t) => !(t in table)).length;
    console.log(
      `${month}: ${entries.length} 条，新翻 ${translated.size}，沿用 ${entries.length - missing.length}` +
        (dropped ? `，移除 ${dropped}` : ''),
    );
  }
}

await main();
