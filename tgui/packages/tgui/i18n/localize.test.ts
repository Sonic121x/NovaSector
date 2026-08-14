// THIS IS A NOVA SECTOR UI FILE
import { beforeAll, describe, expect, test } from 'bun:test';
import { Dropdown } from 'tgui-core/components';

import { configAtom, store } from '../events/store';
import type { Config } from '../events/types';
import { localizeProps } from './localize';
import propTemplates from './prop-templates.json';
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

  // `{' '}`（prettier 换行时到处插）在 React 里是一个**字符串** child，会并进模板文本；
  // 抽取器若把它记成占位符，算出的 key 就比运行时多一个 `{N}` → 整条模板永远查不到 →
  // 整段回退英文，而其中的 `<b>`/`<span>` 因为自己是独立 jsx 节点照常被译，表现为
  // 「只有加粗的那个词是中文」。一次实测毒掉了 90 条模板 key（偏好菜单语言页、多个反派介绍页）。
  //
  // children 按 AntagInfoChangeling.tsx 的源码形状**独立构造**（不从目录 key 反推），
  // 断言运行时算出的模板确实是目录里的那一条 —— 抽取规则一旦回退，这里就红。
  test("{' '} 是文本不是占位符：模板 key 必须与运行时算出的一致", () => {
    const el = { type: 'span' }; // 站位：任何非字符串 child 都占一个 {N}
    const children = [
      'All abilities require using',
      ' ', // <- {' '}
      el, // <- <span>chemicals</span>
      ', you can see how much you have with the HUD on the left side of the screen. You may also hover your cursor over it to see the maximum amount of chemicals you can hold. This number can increase by',
      el, // <- <span>&ensp;absorbing</span>
      ' other Changelings.',
    ];
    const props = localizeProps({ children }) as Record<string, unknown>;
    expect(props.children).not.toBe(children);
    const text = (props.children as unknown[])
      .filter((c) => typeof c === 'string')
      .join('');
    expect(text).toContain('所有能力都需要');
  });

  // 运行期文案 + 图标/分隔线的混排：整条模板永远不在目录里（字符串是运行期数据），
  // 但字符串本身是独立目录条目。旧的「混排就整条保持英文」把整类焊死成英文：
  // 配装页分类页签 `<Box>{icon}{tab.name}</Box>`、反派介绍 tooltip 的非末段
  // `<div>{desc}<Divider/></div>`、中途加入菜单的部门标题 `<>{name}<span>…</span></>`。
  test('整条模板未命中时，完整独立目录条目仍逐段翻', () => {
    const el = { type: 'i' }; // <Icon />
    const props = localizeProps({ children: [el, 'Head'] }) as Record<
      string,
      unknown
    >;
    expect(props.children).toEqual([el, (zhHans as any).Head]);
  });

  // 反面一：整条模板未命中、且某段查不到 → 整条保持英文（那是拼句碎片的形态）。
  test('有段落查不到时整条保持英文', () => {
    const el = { type: 'i' };
    const children = ['Confirm', el, ' zzz-not-in-catalog-zzz'];
    const props = localizeProps({ children }) as Record<string, unknown>;
    expect(props.children).toBe(children);
  });

  // 反面二：目录里确实躺着大量拼句碎片（'and give it a'、'a mindshield.' …）——它们各自都能
  // 命中，逐段翻却会按英文语序拼回去。首字符是小写/标点的续接碎片一律不走逐段翻。
  test('小写开头的续接碎片不走逐段翻', () => {
    const el = { type: 'i' };
    const fragment = 'and give it a';
    expect((zhHans as Record<string, string>)[fragment]).toBeTruthy();
    const children = ['Confirm', el, fragment];
    const props = localizeProps({ children }) as Record<string, unknown>;
    expect(props.children).toBe(children);
  });

  // prop 里 JS 拼出来的整串（`` title={`Reading: ${x}`} ``）永远不是目录键 → 精确查表必 miss。
  // 抽取器按 `Reading: {0}` 收进目录 + sidecar，这里按字面段逆匹配还原、填回捕获值。
  test('prop 模板逆匹配：框架词翻译、捕获值原样保留', () => {
    const key = 'Reading: {0}';
    expect(propTemplates).toContain(key);
    const zh = (zhHans as Record<string, string>)[key];
    expect(zh).toBeTruthy();
    const props = localizeProps({ title: 'Reading: Zzyzx Manifesto' }) as Record<
      string,
      string
    >;
    expect(props.title).toBe(zh.replace('{0}', 'Zzyzx Manifesto'));
  });

  // 逆匹配是整串匹配，形状对不上就不该动（否则等于子串替换、会从句子中间开火）。
  test('形状不符的串不被 prop 模板改动', () => {
    const text = 'He was reading: Zzyzx Manifesto in the library.';
    const props = localizeProps({ title: text }) as Record<string, string>;
    expect(props.title).toBe(text);
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
