// THIS IS A NOVA SECTOR UI FILE
// TGUI 前端漏翻的**离线扫掠**：不需要 BYOND、不需要真人，在测试环境里把每个界面渲染一遍，
// 把「查遍前端目录仍是英文」的显示串收成一份与 miss_log.dm 同格式的日志。
//
// 为什么需要它：TGUI 是 DM 侧完全看不见的一面（静态 JSX 文本、可翻 prop、children 模板都在
// 浏览器里查表，服务端毫无痕迹），而 `missLog.ts` 那条运行期回传只有真人开界面才产得出数据 ——
// 单测套件跑一整轮，`tgui-ui` 那一栏恒为 0。那是「没有浏览器」，不是「没有漏翻」。
//
// 做法：happy-dom + @testing-library/react（`Radio.test.tsx` 已在用的那套）把界面挂上去。
// 难点只有一个 —— **空数据下绝大多数界面会崩**（`previous_attempts.length` / `categories[0]`），
// 一崩整棵树都渲染不出来，静态文案也就一条都收不到。所以按界面**自己的 `Data` 类型**用 tsc API
// 合成一份结构完整的假数据：数组给一个元素（否则列表行整类渲染不到，而行里文案最多）、
// 字符串给一个**生造词**（真实英文词会命中目录、把「没翻」测成「翻了」）。
//
// 用法：cd tgui && bun test ./packages/tgui/i18n/render-sweep.sweep.tsx
// 文件名不含 `.test`，所以默认的 `bun test` 不会跑它（它比整个测试套件还慢）。

import fs from 'node:fs';
import path from 'node:path';
import { mock } from 'bun:test';
import type React from 'react';
import { act, cleanup, render } from '@testing-library/react';
import ts from 'typescript';

import { configAtom, gameDataAtom, store } from '../events/store';
import { localizeProps } from './localize';
import { flushMisses } from './missLog';

// **自动本地化只在 rspack 里接着**（`swcReactOptions('tgui/i18n')` 把 jsxImportSource 指向本目录
// 的 jsx-runtime）。`bun test` 用的是自己的 JSX 变换 + 原生 `react/jsx-runtime`，于是整条本地化链
// 在测试环境里根本不跑 —— 第一版扫掠「渲染成功 329 个、漏翻 0 条」就是这么来的，看着像干净、
// 其实一次查表都没发生。这里在测试环境里复现构建时做的同一件事。
for (const specifier of ['react/jsx-runtime', 'react/jsx-dev-runtime']) {
  const original = (await import(specifier)) as Record<string, unknown>;
  // **必须先把真函数取成局部常量**：`mock.module` 的工厂是**惰性求值**的，工厂里再去读
  // `original.jsx` 时那个命名空间对象已经指向 mock 自己 → 无限递归（实测每个界面都是
  // `Maximum call stack size exceeded`）。
  const realJsx = original.jsx as (...a: unknown[]) => unknown;
  const realJsxs = original.jsxs as (...a: unknown[]) => unknown;
  const realJsxDev = original.jsxDEV as ((...a: unknown[]) => unknown) | undefined;
  const patched: Record<string, unknown> = { ...original };
  patched.jsx = (type: unknown, props: unknown, key?: string) =>
    realJsx(type, localizeProps(props, type), key);
  patched.jsxs = (type: unknown, props: unknown, key?: string) =>
    realJsxs(type, localizeProps(props, type), key);
  if (realJsxDev) {
    patched.jsxDEV = (type: unknown, props: unknown, ...rest: unknown[]) =>
      realJsxDev(type, localizeProps(props, type), ...rest);
  }
  mock.module(specifier, () => patched);
}

const HERE = path.dirname(new URL(import.meta.url).pathname);
const INTERFACES = path.join(HERE, '..', 'interfaces');
const OUT = path.join(HERE, '..', '..', '..', '..', 'data', 'logs', 'tgui_misses.log');

/** 合成字符串用**生造词**：真实英文词会命中目录，把「这处没翻」测成「翻了」。 */
const SYNTH_TEXT = 'Zxqvblorp';

function interfaceFiles(): string[] {
  const out: string[] = [];
  const walk = (dir: string) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else if (entry.name.endsWith('.tsx') && !entry.name.includes('.test.'))
        out.push(full);
    }
  };
  walk(INTERFACES);
  return out.sort();
}

const files = interfaceFiles();

// 一个 Program 覆盖全部界面：每个文件各建一次 Program 在 329 个文件上要跑好几分钟。
const program = ts.createProgram(files, {
  allowJs: true,
  jsx: ts.JsxEmit.Preserve,
  strict: false,
  skipLibCheck: true,
  moduleResolution: ts.ModuleResolutionKind.Bundler,
  target: ts.ScriptTarget.ESNext,
});
const checker = program.getTypeChecker();

function synthesize(type: ts.Type, at: ts.Node, depth = 0): unknown {
  if (depth > 4) return null;
  const flags = type.getFlags();
  if (flags & ts.TypeFlags.StringLike) {
    // 字面量联合（`mode: 'a' | 'b'`）要给**真实的那个值**，否则 switch/比较全落空、整块不渲染。
    if (type.isStringLiteral()) return type.value;
    return SYNTH_TEXT;
  }
  if (flags & ts.TypeFlags.NumberLike) {
    return type.isNumberLiteral() ? type.value : 1;
  }
  if (flags & ts.TypeFlags.BooleanLike) return true;
  if (flags & (ts.TypeFlags.Null | ts.TypeFlags.Undefined | ts.TypeFlags.Void)) {
    return null;
  }
  if (type.isUnion()) {
    const concrete = type.types.filter(
      (t) => !(t.getFlags() & (ts.TypeFlags.Null | ts.TypeFlags.Undefined)),
    );
    return synthesize(concrete[0] ?? type.types[0], at, depth + 1);
  }
  if (checker.isArrayType(type)) {
    const element = checker.getTypeArguments(type as ts.TypeReference)[0];
    // **一个元素**，不是空数组：列表行里的文案是这一面的大头，空数组等于整类渲染不到。
    return element ? [synthesize(element, at, depth + 1)] : [];
  }
  if (flags & ts.TypeFlags.Object) {
    const out: Record<string, unknown> = {};
    for (const prop of checker.getPropertiesOfType(type)) {
      const declared = prop.valueDeclaration ?? at;
      out[prop.getName()] = synthesize(
        checker.getTypeOfSymbolAtLocation(prop, declared),
        declared,
        depth + 1,
      );
    }
    return out;
  }
  return null;
}

/** 合成该界面的假数据。判据是 **`useBackend<T>()` 的类型实参** —— 那就是负载的类型，
 * 比「名字以 Data 结尾的 type alias」准得多（`AntagInfoChangeling` 用的是 `type Info`，
 * 按名字找一条都对不上，于是整批反派介绍界面渲染不起来）。 */
function synthesizeData(file: string): Record<string, unknown> {
  const source = program.getSourceFile(file);
  if (!source) return {};
  let result: Record<string, unknown> = {};
  const visit = (node: ts.Node) => {
    if (
      ts.isCallExpression(node) &&
      ts.isIdentifier(node.expression) &&
      node.expression.text === 'useBackend' &&
      node.typeArguments?.length
    ) {
      const synthesized = synthesize(
        checker.getTypeFromTypeNode(node.typeArguments[0]),
        node,
      );
      if (synthesized && typeof synthesized === 'object') {
        result = { ...result, ...(synthesized as Record<string, unknown>) };
      }
    }
    ts.forEachChild(node, visit);
  };
  visit(source);
  return result;
}

// 前端 miss 走 `Byond.sendMessage({type:'i18n/miss'})`（见 missLog.ts）。把 mock 换成收集器。
type MissEntry = { text: string; where: string };
const collected: MissEntry[] = [];
let current = '';
// @ts-expect-error 覆盖 __mocks__/byond.ts 装的那个 noop
globalThis.Byond.sendMessage = (message: { type?: string; misses?: string[] }) => {
  if (message?.type !== 'i18n/miss' || !Array.isArray(message.misses)) return;
  for (const text of message.misses) collected.push({ text, where: current });
};

store.set(configAtom, {
  locale: 'zh-Hans',
  i18nLogMisses: true,
  title: 'Sweep',
  status: 2,
  window: { fancy: false, locked: false },
  user: { name: 'Sweep', observer: false },
} as never);

let rendered = 0;
const failed: string[] = [];

for (const file of files) {
  const name = path.basename(file, '.tsx');
  current = name;
  let module_: Record<string, unknown>;
  try {
    module_ = await import(file);
  } catch (error) {
    failed.push(`${name}: import ${(error as Error).message?.slice(0, 60)}`);
    continue;
  }
  const Component = (module_[name] ?? module_.default) as
    | React.ComponentType
    | undefined;
  if (typeof Component !== 'function') continue;
  store.set(gameDataAtom, synthesizeData(file));
  try {
    act(() => {
      render(<Component />);
    });
    rendered++;
  } catch (error) {
    failed.push(`${name}: ${(error as Error).message?.slice(0, 60)}`);
  }
  // **每个界面之后立刻收口**：靠 missLog 的攒批定时器的话，所有条目都会在扫掠末尾一次性发出，
  // 来源标签全变成最后那个界面 —— 而「哪个界面」正是这份报告唯一可行动的信息。
  flushMisses();
  cleanup();
}

// 扫掠自身的产物不是漏翻：合成串、mock 的窗口标题，以及**合成数据算出来的串**。
// 后一类最容易被当成真缺口：界面把负载值拼进显示文本（`${moles} Moles`、`${x} units of ${y}`），
// 喂进去的是合成值，拼出来的整串当然不在目录里 —— 但真实对局里那串也不会在目录里，
// 它本来就该走「模板 + 运行期值」那条路。`null` / `undefined` / `NaN` 是这类的指纹。
const ARTIFACTS = /^(Test UI|Sweep)$/;
const SYNTHETIC_VALUE = /\b(null|undefined|NaN)\b/;
const seen = new Set<string>();
const lines: string[] = [];
for (const { text, where } of collected) {
  if (seen.has(text)) continue;
  if (text.includes(SYNTH_TEXT) || ARTIFACTS.test(text)) continue;
  if (SYNTHETIC_VALUE.test(text)) continue;
  seen.add(text);
  // 与 miss_log.dm 同格式，好让 tools/i18n/miss-scan.mjs 直接吃。
  lines.push(`[sweep] n=1 src=tgui-ui | ${text} || 来源: ${where}`);
}
fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, `${lines.join('\n')}\n`);

console.log(`界面 ${files.length} 个，渲染成功 ${rendered}，未渲染 ${failed.length}`);
// 覆盖面要说清楚，否则「扫掠通过」会被当成「前端全译了」：
//   收得到 —— 静态 JSX 文本、可翻 prop、children 模板、**下拉框选项（收起状态也算，
//             localizeDropdownProps 在 prop 阶段就跑）**、挂载时就渲染的页签标签。
//   收不到 —— ① 上面这 ${failed.length} 个渲染不起来的界面；
//             ② **要交互才出现的内容**：模态框、未选中的页签正文、Collapsible 的展开体、
//                点击后才渲染的东西 —— 这一面只有真人开界面时的 missLog 回传才够得着。
console.log(
  '覆盖：静态文本 / 可翻 prop / children 模板 / 下拉选项（含收起）。' +
    '交互后才渲染的（模态框、未选中页签、Collapsible 展开体）不在其中。',
);
console.log(`漏翻 ${seen.size} 条唯一串 → ${OUT}`);
console.log('归类：node tools/i18n/miss-scan.mjs data/logs/tgui_misses.log');
if (failed.length) {
  console.log(`\n未渲染的前 15 个（合成数据仍不足以让它们跑起来）：`);
  for (const line of failed.slice(0, 15)) console.log(`  ${line}`);
}
