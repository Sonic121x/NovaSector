// THIS IS A NOVA SECTOR UI FILE
import { beforeAll, describe, expect, test } from 'bun:test';
import { Dropdown } from 'tgui-core/components';

import { configAtom, store } from '../events/store';
import type { Config } from '../events/types';
import { localizeProps } from './localize';
import zhHans from './zh-Hans.json';

// 用真目录里已有的条目做断言，避免测试自带一套假目录、掩盖「目录键与运行时查表键不一致」。
const SAMPLE = 'Confirm';
const SAMPLE_ZH = (zhHans as Record<string, string>)[SAMPLE];

beforeAll(() => {
  store.set(configAtom, { locale: 'zh-Hans' } as Config);
});

describe('localizeProps', () => {
  test('目录里有译文的可翻 prop 被替换', () => {
    expect(SAMPLE_ZH).toBeTruthy();
    const props = localizeProps({ content: SAMPLE }) as Record<string, string>;
    expect(props.content).toBe(SAMPLE_ZH);
  });

  test('confirmContent 也算可翻 prop（policy.json 单一来源）', () => {
    const props = localizeProps({ confirmContent: SAMPLE }) as Record<
      string,
      string
    >;
    expect(props.confirmContent).toBe(SAMPLE_ZH);
  });

  test('非 Dropdown 组件的裸字符串 options 一律不动', () => {
    const options = [SAMPLE];
    const props = localizeProps({ options }, () => null) as Record<
      string,
      unknown
    >;
    expect(props.options).toEqual([SAMPLE]);
  });

  test('Dropdown 裸字符串选项升级为对象：value 保持英文、只翻显示', () => {
    const props = localizeProps(
      { options: [SAMPLE], selected: SAMPLE, onSelected: () => {} },
      Dropdown,
    ) as Record<string, any>;
    expect(props.options).toEqual([{ value: SAMPLE, displayText: SAMPLE_ZH }]);
    // selected 是回传/高亮用的标识符，必须原样保留。
    expect(props.selected).toBe(SAMPLE);
    // 收起时按钮显示译文（Dropdown 显示 displayText || selected）。
    expect(props.displayText).toBe(SAMPLE_ZH);
  });

  test('Dropdown 已有 displayText 时不覆盖', () => {
    const props = localizeProps(
      { options: [SAMPLE], selected: SAMPLE, displayText: 'custom' },
      Dropdown,
    ) as Record<string, unknown>;
    expect(props.displayText).toBe('custom');
  });

  // 反派介绍 tooltip 的真实形状：`<div>{text}{cond && <Divider/>}</div>`。
  // 最后一段（绝大多数反派只有一段）的 `cond &&` 求值成 false，React 不渲染它，
  // 但它仍占着 children 的一个位置。若按「非字符串 = 一个占位符」建模板，整条会变成
  // `…station.{0}`，目录里没有这条 → 整段回退英文（混排 children 的保守规则），
  // 于是**目录里明明有译文的整类文案在界面上永远是英文**。
  test('不渲染的 children（false/null/undefined）不占占位符', () => {
    const desc =
      'Team up with other crew members as blood brothers to combine the strengths of your departments, break each other out of prison, and overwhelm the station.';
    const descZh = (zhHans as Record<string, string>)[desc];
    expect(descZh).toBeTruthy();
    const props = localizeProps({ children: [desc, false] }) as Record<
      string,
      unknown
    >;
    expect(props.children).toEqual([descZh]);
  });

  test('目录里没有的选项保持裸字符串', () => {
    const unknownOption = 'zzz-not-in-catalog-zzz';
    const props = localizeProps(
      { options: [unknownOption], selected: unknownOption },
      Dropdown,
    ) as Record<string, unknown>;
    expect(props.options).toEqual([unknownOption]);
    expect(props.displayText).toBeUndefined();
  });
});
