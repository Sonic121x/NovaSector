// THIS IS A NOVA SECTOR UI FILE
import { afterEach, beforeAll, describe, expect, test } from 'bun:test';

import { configAtom, store } from '../events/store';
import type { Config } from '../events/types';
import {
  ensureCatalogOverlay,
  mergeCatalogOverlay,
  resetCatalogOverlay,
  translateCurrent,
} from './catalog';
import { createSearch, searchableText } from './search';
import zhHans from './zh-Hans.json';

// 静态目录用真条目，免得假目录掩盖「查表键与显示链不一致」。
const SAMPLE = 'Confirm';
const SAMPLE_ZH = (zhHans as Record<string, string>)[SAMPLE];
// 负载值用生造词，不可能命中真目录。
const RUNTIME = 'Zxqv Bottled Glorp';
const RUNTIME_ZH = '兹克夫瓶装格洛普';

beforeAll(() => {
  store.set(configAtom, { locale: 'zh-Hans' } as Config);
});

afterEach(() => {
  resetCatalogOverlay();
});

describe('searchableText', () => {
  test('英文原值照常能搜', () => {
    expect(searchableText(RUNTIME).includes('bottled')).toBe(true);
  });

  test('静态目录里的译文也能搜', () => {
    expect(SAMPLE_ZH).toBeTruthy();
    expect(searchableText(SAMPLE).includes(SAMPLE_ZH.toLowerCase())).toBe(true);
  });

  test('负载 overlay 的译文能搜，清空后不再命中', () => {
    mergeCatalogOverlay({ [RUNTIME]: RUNTIME_ZH });
    expect(searchableText(RUNTIME).includes('瓶装')).toBe(true);
    resetCatalogOverlay();
    expect(searchableText(RUNTIME).includes('瓶装')).toBe(false);
  });

  test('空值不抛错、也不命中', () => {
    expect(searchableText(undefined)).toBe('');
    expect(searchableText(null).includes('x')).toBe(false);
  });
});

describe('createSearch', () => {
  test('签名与 tgui-core 一致：空查询全放行，按 stringifier 匹配', () => {
    const items = [{ name: RUNTIME }, { name: 'Other Thing' }];
    mergeCatalogOverlay({ [RUNTIME]: RUNTIME_ZH });
    expect(items.filter(createSearch('', (i) => i.name))).toHaveLength(2);
    expect(items.filter(createSearch('格洛普', (i) => i.name))).toEqual([
      items[0],
    ]);
    expect(items.filter(createSearch('OTHER', (i) => i.name))).toEqual([
      items[1],
    ]);
  });

  test('无 stringifier 时对象里的字符串字段也按显示文本匹配', () => {
    mergeCatalogOverlay({ [RUNTIME]: RUNTIME_ZH });
    const search = createSearch<{ name: string; id: number }>('瓶装');
    expect(search({ name: RUNTIME, id: 1 })).toBe(true);
    expect(search({ name: 'Other Thing', id: 2 })).toBe(false);
  });
});

describe('ensureCatalogOverlay', () => {
  test('同一份译文在 overlay 被清空后会重新合并', () => {
    const entries = { [RUNTIME]: RUNTIME_ZH };
    ensureCatalogOverlay(entries);
    expect(translateCurrent(RUNTIME)).toBe(RUNTIME_ZH);
    resetCatalogOverlay();
    expect(translateCurrent(RUNTIME)).toBe(RUNTIME);
    ensureCatalogOverlay(entries);
    expect(translateCurrent(RUNTIME)).toBe(RUNTIME_ZH);
  });
});
