// THIS IS A NOVA SECTOR UI FILE
// 前端漏翻采集：把「查遍前端目录仍是英文」的显示串攒批回传给 DM，汇进同一份 i18n_misses.log。
//
// 为什么必须有这一条：**TGUI 是 DM 侧完全看不见的一面**。静态 JSX 文本、可翻 prop、children
// 模板都在浏览器里查表，查不到就原样渲染，服务端没有任何痕迹 —— 于是漏翻采集器一直只覆盖
// 聊天/浏览器/公告与 TGUI **负载值**（P1 在服务端能看到的那半边），而玩家看得最多的界面文案
// 那半边从来是盲区。
//
// 三条约束：
//   · **默认完全关闭**。开关由 DM 下发（`config.i18nLogMisses`，跟 I18N_LOG_MISSES 走），
//     关的时候连字符串都不入集合，正常游玩零开销。
//   · **去重**。同一个界面每帧都会重渲，不去重会瞬间刷爆消息通道。去重之后总量就等于
//     「界面上有多少条不同的英文」，天然有界，所以**不设条数上限** —— 截断的唯一后果是
//     「条数不再增长」，而那与「真的采干净了」表现完全一样。
//   · **攒批**。用 setTimeout 合并同一帧内的大量 miss，一次 sendMessage 发走。
//
// 闸门与 DM 侧 `lang_miss_value_candidate` 同源（标识符形态不收），但**不做多词过滤** ——
// 界面上的单词标签正是这一面最主要的缺口。

import { configAtom, store } from '../events/store';

/** 单条最大长度：更长的多是玩家书写内容（纸张/记录），本就不该翻。 */
const MAX_LENGTH = 240;
/** 攒批窗口（毫秒）。 */
const FLUSH_DELAY = 2000;

const seen = new Set<string>();
let pending: string[] = [];
let flushTimer: ReturnType<typeof setTimeout> | null = null;

function enabled(): boolean {
  return Boolean(store.get(configAtom)?.i18nLogMisses);
}

/** 形态判据：能不能是玩家可见的英文文案。与 DM 侧 lang_miss_value_candidate 同一套规则。 */
export function isMissCandidate(text: string): boolean {
  if (text.length < 2 || text.length > MAX_LENGTH) {
    return false;
  }
  // 非 ASCII（含 CJK）：要么已经译了，要么不是英文文案。
  // 标识符特征：下划线 / 斜杠（类型路径）/ `#`（ref）/ `=`（属性串）。
  if (/[^\x20-\x7e]/.test(text) || /[_/#=]/.test(text)) {
    return false;
  }
  if (!/[A-Za-z]/.test(text)) {
    return false;
  }
  // 全大写且无空格 = 常量/缩写（`SOUTH`/`APC`）。多词全大写标题仍然收。
  if (!/[a-z]/.test(text) && !text.includes(' ')) {
    return false;
  }
  return true;
}

/** 立即发走已攒的 miss。离线扫掠用它在**每个界面之后**收口 —— 靠攒批定时器的话，
 * 所有条目都会在扫掠末尾一次性发出，来源标签全变成最后那个界面。 */
export function flushMisses(): void {
  if (flushTimer !== null) {
    clearTimeout(flushTimer);
  }
  flush();
}

function flush(): void {
  flushTimer = null;
  if (!pending.length) {
    return;
  }
  const misses = pending;
  pending = [];
  Byond.sendMessage({ type: 'i18n/miss', misses });
}

/** 记录一条前端 miss。关闭时（默认）立即返回。 */
export function recordMiss(text: string): void {
  if (!enabled()) {
    return;
  }
  const trimmed = text.trim();
  if (seen.has(trimmed) || !isMissCandidate(trimmed)) {
    return;
  }
  seen.add(trimmed);
  pending.push(trimmed);
  if (flushTimer === null) {
    flushTimer = setTimeout(flush, FLUSH_DELAY);
  }
}
