#!/usr/bin/env bun
// 词池（`world.file2list` 读的纯文本表）按 locale 翻译，产出 `<名>.<locale>.txt`。
//
// 这些表不在 i18n 目录里，也**不该**进目录：它们是极常见的英文单词（`hot`/`in`/`real`/`kind`…），
// 进全局反查表就是凭空扩大整个 DM 侧的误翻面。按 locale 换整张表既覆盖完全、又零全局风险。
// 运行期由 `lang_word_pool()` 选表（见 modular_nova/modules/i18n/code/runtime.dm）。
//
// 用法：bun tools/i18n/word-pool-mt.ts strings/names/adjectives.txt [更多...]
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

const LOCALE = process.env.I18N_LOCALE ?? 'zh-Hans';
const API_KEY = process.env.OPENAI_API_KEY ?? process.env.I18N_OPENAI_API_KEY;
const MODEL = process.env.I18N_OPENAI_MODEL ?? 'gpt-4o-mini';
const BASE_URL = process.env.I18N_OPENAI_BASE_URL ?? 'https://api.openai.com/v1';
const CHUNK = Number(process.env.I18N_CHUNK ?? 120);

if (!API_KEY) {
  console.error('需要 OPENAI_API_KEY（或 I18N_OPENAI_API_KEY）');
  process.exit(1);
}

// 词池里每一项都要**独立成词**地填进句子模板（`"{0} for {1} adventurers"` 的形容词槽、
// 梦境的 `%ADJECTIVE% admiral`），所以译文必须逐项对齐、不能合并或增删行。
const SYSTEM = `你在为一个太空站模拟游戏做简体中文本地化。
输入是一张词表，每行一个词或短语，用于填进句子模板的槽位（例如形容词槽「给{0}冒险家的传单」）。
规则：
1. 逐行翻译，输出行数必须与输入完全一致，顺序不变。
2. 形容词译成能直接修饰名词的形式（需要时带「的」），动词保持动词形态。
3. 专有名词、型号、缩写保持英文原样。
4. 只输出译文，每行一条，不要编号、不要解释、不要空行。`;

/// 超时/网络抖动重试。整张表要跑十几分钟，中间断一次就前功尽弃——而这类失败是暂时的，
/// 与「模型给的行数对不上」是两回事（后者靠二分收敛，见 translateChunk）。
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

async function translateChunk(lines: string[], attempt = 0): Promise<string[]> {
  const json = await postWithRetry({
    model: MODEL,
    temperature: 0,
    messages: [
      { role: 'system', content: SYSTEM },
      { role: 'user', content: lines.join('\n') },
    ],
  });
  const out = String(json.choices?.[0]?.message?.content ?? '')
    .split('\n')
    .map((l) => l.trim())
    .filter((l) => l.length > 0);
  // **行数对不上就整批重试**：错位一行，后面每一行都挂到错误的词上，而这类表没有 key 可以校验。
  if (out.length !== lines.length) {
    if (attempt < 2) return translateChunk(lines, attempt + 1);
    // 重试两次仍对不上：**对半拆开继续**，而不是让整张表失败。929 行的 ing_verbs 只要有一批
    // 反复错位就会把整个文件丢掉——而错位通常只出在某几行上，二分能把损失收敛到极小范围。
    if (lines.length > 1) {
      const mid = Math.floor(lines.length / 2);
      return [
        ...(await translateChunk(lines.slice(0, mid))),
        ...(await translateChunk(lines.slice(mid))),
      ];
    }
    // 单行还对不齐：保留英文。少译一个词远好过整表错位。
    console.warn(`\n  ⚠ 保留英文（模型未给出对齐译文）：${lines[0]}`);
    return [lines[0]];
  }
  return out;
}

for (const rel of process.argv.slice(2)) {
  const src = path.join(ROOT, rel);
  const lines = fs
    .readFileSync(src, 'utf8')
    .split('\n')
    .map((l) => l.replace(/\r$/, ''))
    .filter((l) => l.length > 0);
  const out: string[] = [];
  for (let i = 0; i < lines.length; i += CHUNK) {
    const slice = lines.slice(i, i + CHUNK);
    process.stdout.write(`${rel}: ${i + slice.length}/${lines.length}\r`);
    out.push(...(await translateChunk(slice)));
  }
  const dst = src.replace(/\.txt$/, `.${LOCALE}.txt`);
  fs.writeFileSync(dst, `${out.join('\n')}\n`);
  console.log(`\n${rel} -> ${path.relative(ROOT, dst)}（${out.length} 行）`);
}
