// THIS IS A NOVA SECTOR UI FILE
import { beforeAll, describe, expect, test } from 'bun:test';
import { Dropdown } from 'tgui-core/components';

import { configAtom, store } from '../events/store';
import type { Config } from '../events/types';
import { mergeCatalogOverlay, resetCatalogOverlay } from './catalog';
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

  test('legacy JSX adapter keeps unknown text as its English fallback', () => {
    const source = 'Zzqv unknown upstream message';
    const props = localizeProps({ content: source }) as Record<string, string>;
    expect(props.content).toBe(source);
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
    const props = localizeProps({
      title: 'Reading: Zzyzx Manifesto',
    }) as Record<string, string>;
    expect(props.title).toBe(zh.replace('{0}', 'Zzyzx Manifesto'));
  });

  test('prop 模板缓存随 locale 切换失效', () => {
    const source = 'Reading: Zzyzx Manifesto';
    store.set(configAtom, { locale: 'en' } as Config);
    expect(
      (localizeProps({ title: source }) as Record<string, string>).title,
    ).toBe(source);

    store.set(configAtom, { locale: 'zh-Hans' } as Config);
    const zh = (zhHans as Record<string, string>)['Reading: {0}'];
    expect(
      (localizeProps({ title: source }) as Record<string, string>).title,
    ).toBe(zh.replace('{0}', 'Zzyzx Manifesto'));
  });

  test('prop 模板缓存随 overlay 生命周期失效', () => {
    const source = 'Reading: Zzyzx Manifesto';
    mergeCatalogOverlay({ 'Reading: {0}': '负载模板：{0}' });
    expect(
      (localizeProps({ title: source }) as Record<string, string>).title,
    ).toBe('负载模板：Zzyzx Manifesto');

    resetCatalogOverlay();
    const zh = (zhHans as Record<string, string>)['Reading: {0}'];
    expect(
      (localizeProps({ title: source }) as Record<string, string>).title,
    ).toBe(zh.replace('{0}', 'Zzyzx Manifesto'));
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

// 负载 overlay：运行期才成形的值（atom 名、datum 描述、拼接句）不可能在编译期抽取的静态目录里。
// DM 侧把它们随负载下发（`json_data["i18n"]`），值本身保持 canonical English —— 于是 act() 回传
// 与服务端持有的字符串逐字节相同。这几条守「overlay 真的接进了查表链」以及它的生命周期。
describe('负载 overlay', () => {
  const RUNTIME = 'Zxqv Thranok Unit';
  const RUNTIME_ZH = '兹克夫单元';

  test('overlay 里的运行期值在可翻 prop 上被替换', () => {
    mergeCatalogOverlay({ [RUNTIME]: RUNTIME_ZH });
    const props = localizeProps({ content: RUNTIME }) as Record<string, string>;
    expect(props.content).toBe(RUNTIME_ZH);
    resetCatalogOverlay();
  });

  test('overlay 合并而非替换：static_data 只在开窗时下发一次', () => {
    mergeCatalogOverlay({ [RUNTIME]: RUNTIME_ZH });
    mergeCatalogOverlay({ Other: '其它' });
    const props = localizeProps({ content: RUNTIME }) as Record<string, string>;
    expect(props.content).toBe(RUNTIME_ZH);
    resetCatalogOverlay();
  });

  test('窗口挂起后清空：复用给别的界面时不留误翻面', () => {
    mergeCatalogOverlay({ [RUNTIME]: RUNTIME_ZH });
    resetCatalogOverlay();
    const props = localizeProps({ content: RUNTIME }) as Record<string, string>;
    expect(props.content).toBe(RUNTIME);
  });

  test('大小写包装（capitalize/toTitleCase）仍能命中', () => {
    mergeCatalogOverlay({ 'power chromosome': '力量染色体' });
    // 界面写的是 capitalize(x) / toTitleCase(x)，渲染到的串与负载原值只差大小写。
    for (const wrapped of ['Power chromosome', 'Power Chromosome']) {
      const props = localizeProps({ content: wrapped }) as Record<
        string,
        string
      >;
      expect(props.content).toBe('力量染色体');
    }
    resetCatalogOverlay();
  });

  test('拼进更大串里的运行期值靠子串替换落地', () => {
    mergeCatalogOverlay({
      'Zxqv Thranok Unit': '兹克夫单元',
      'quiet dark drift': '静暗漂流',
    });
    // `` {`${x.name} - ${x.desc}`} `` 这种整串永远不是目录键。
    const props = localizeProps({
      content: 'Zxqv Thranok Unit - quiet dark drift',
    }) as Record<string, string>;
    expect(props.content).toBe('兹克夫单元 - 静暗漂流');
    resetCatalogOverlay();
  });

  test('子串替换有词边界：不得咬进另一个词中间', () => {
    mergeCatalogOverlay({ 'Zxqv Thranok': '兹克夫' });
    const props = localizeProps({ content: 'Zxqv Thranoks' }) as Record<
      string,
      string
    >;
    expect(props.content).toBe('Zxqv Thranoks');
    resetCatalogOverlay();
  });

  test('子串替换最长优先：短键不得遮住长键', () => {
    mergeCatalogOverlay({
      'Zxqv Thranok': '兹克夫',
      'Zxqv Thranok Unit': '兹克夫单元',
    });
    const props = localizeProps({
      content: 'Zxqv Thranok Unit: 5u',
    }) as Record<string, string>;
    expect(props.content).toBe('兹克夫单元: 5u');
    resetCatalogOverlay();
  });

  test('混排 children 里的负载值不受碎片闸门连坐', () => {
    mergeCatalogOverlay({ 'Zxqv Thranok Unit': '兹克夫单元' });
    // ["Zxqv Thranok Unit", " costs ", 5, " credits"]：碎片 " costs " 永远不是目录键，
    // 从前靠 P1 就地改写、名字本来就是中文；整条闸门不能把它一起打回英文。
    const props = localizeProps({
      children: ['Zxqv Thranok Unit', ' costs ', 5, ' credits'],
    }) as Record<string, unknown>;
    expect((props.children as unknown[])[0]).toBe('兹克夫单元');
    expect((props.children as unknown[])[1]).toBe(' costs ');
    resetCatalogOverlay();
  });

  test('单词键只做整串精确查表，不参与子串替换', () => {
    // P1 的多词门槛放开后单词值也进 overlay（「TGUI 单词名恒为英文」那类才有解），
    // 但单词做子串替换会从另一个词内部开火 —— 这条界线必须在 TS 侧显式守住。
    mergeCatalogOverlay({ Zxqv: '兹克夫' });
    const exact = localizeProps({ content: 'Zxqv' }) as Record<string, string>;
    expect(exact.content).toBe('兹克夫');
    const inside = localizeProps({ content: 'Zxqv Thranok reactor' }) as Record<
      string,
      string
    >;
    expect(inside.content).toBe('Zxqv Thranok reactor');
    resetCatalogOverlay();
  });

  test('静态目录条目不受 overlay 影响', () => {
    mergeCatalogOverlay({ [RUNTIME]: RUNTIME_ZH });
    const props = localizeProps({ content: SAMPLE }) as Record<string, string>;
    expect(props.content).toBe(SAMPLE_ZH);
    resetCatalogOverlay();
  });
});
