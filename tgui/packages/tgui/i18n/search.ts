// THIS IS A NOVA SECTOR UI FILE
// Search that also matches what the player actually sees.
//
// 负载与静态数据里的值保持 canonical English，译文只在渲染期查表显示（overlay / 静态目录）。
// 搜索框却拿英文原值做 `includes` —— 界面上看到的是「盐水葡萄糖溶液」，输入「盐水」什么也搜不到。
// 这里把「原文 + 当前显示文本」一起作为匹配对象：英文照常能搜，中文也能搜，被过滤的值本身不动。
//
// `createSearch` 由 rspack 在 tgui 包内替换掉 tgui-core 的同名函数（见 rspack.config.ts），
// 上游三十来个界面一行不改；手写 `toLowerCase().includes()` 的界面改用 `searchableText()`。

import { getCatalogRevision, getCurrentLocale } from './catalog';
import { displayTextOf } from './localize';

export * from 'tgui-core/string';

let cachedRevision = -1;
let cachedLocale = '';
let cache = new Map<string, string>();

/**
 * 搜索用的匹配文本：原文与当前显示文本，小写。显示文本与原文相同时只有原文。
 * 用法同 `x.toLowerCase()`：`searchableText(item.name).includes(query)`。
 */
export function searchableText(value: unknown): string {
  if (value === null || value === undefined) {
    return '';
  }
  const text = typeof value === 'string' ? value : String(value);
  // 目录 overlay 每次负载更新都会变，换代或换 locale 就整表作废（缓存只为同一次过滤里的重复值）。
  const revision = getCatalogRevision();
  const locale = getCurrentLocale();
  if (revision !== cachedRevision || locale !== cachedLocale) {
    cachedRevision = revision;
    cachedLocale = locale;
    cache = new Map();
  }
  let haystack = cache.get(text);
  if (haystack === undefined) {
    const shown = displayTextOf(text);
    haystack = (shown === text ? text : `${text}\n${shown}`).toLowerCase();
    cache.set(text, haystack);
  }
  return haystack;
}

/** 无 stringifier 时 tgui-core 拿整个对象的 JSON 匹配；这里把其中的字符串字段也换成可搜文本。 */
function defaultStringifier(obj: unknown): string {
  const json = JSON.stringify(obj) ?? '';
  if (!obj || typeof obj !== 'object') {
    return json;
  }
  const shown: string[] = [json];
  for (const value of Object.values(obj)) {
    if (typeof value === 'string') {
      const text = searchableText(value);
      if (text.includes('\n')) {
        shown.push(text);
      }
    }
  }
  return shown.join('\n');
}

/** 与 tgui-core 的 `createSearch` 签名一致，额外匹配当前显示文本。 */
export function createSearch<TObj>(
  searchText: string,
  stringifier?: (obj: TObj) => string,
): (obj: TObj) => boolean {
  const preparedSearch = searchText.toLowerCase().trim();
  return (obj: TObj) => {
    if (!preparedSearch) {
      return true;
    }
    const str = stringifier ? stringifier(obj) : defaultStringifier(obj);
    if (!str) {
      return false;
    }
    return searchableText(str).includes(preparedSearch);
  };
}
