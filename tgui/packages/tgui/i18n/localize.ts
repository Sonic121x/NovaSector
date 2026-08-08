// THIS IS A NOVA SECTOR UI FILE
// Shared helpers for automatic TGUI JSX localization.

import { Dropdown } from 'tgui-core/components';

import { translateCurrent } from './catalog';
import policy from './policy.json';

// 可翻 prop 名来自三端策略单一来源 strings/i18n/policy.json（`tgui-catalog.mjs sync` 复制到本
// 目录）。抽取器读同一份 —— 两边各存一份清单时，新增 prop 只改一边会出现「目录里有键但界面不
// 翻」或「界面翻了但目录没键、MT 永远漏译」的静默半覆盖。
const TRANSLATABLE_PROPS = new Set<string>(policy.translatable_props);

const OPTION_TEXT_PROPS = new Set<string>(policy.option_text_props);

// 例外清单：这些英文串**绝不**自动翻译。
//
// 自动本地化按「英文原文」查表，无法在运行时区分「字面量 UI 文案」与「正好等于某常见词的
// 动态数据」。绝大多数命中都是期望的（On→开启、None→无…），但偶尔会把本该保持英文的专有
// 名词 / 代码标识符也翻了（典型：admin VV 里显示的变量名 "Type"、ckey 等）。
// 清单来自三端策略单一来源 strings/i18n/policy.json 的 `no_auto_translate`
// （`tgui-catalog.mjs sync` 复制到本目录供打包）。新增豁免改 policy.json 后跑 sync。
const NO_AUTO_TRANSLATE = new Set<string>(policy.no_auto_translate);

function translateText(text: string): string {
  const match = text.match(/^(\s*)([\s\S]*\S)(\s*)$/);
  if (!match) {
    return text;
  }
  const [, leading, body, trailing] = match;
  // 抽取期 (tgui-catalog.mjs normalizeText) 把内部空白折叠成单空格再算 key，
  // 所以运行时也要先折叠才能命中（否则换行/多空格的静态 JSX 文本永远查不到）。
  const lookup = body.replace(/\s+/g, ' ');
  if (NO_AUTO_TRANSLATE.has(lookup)) {
    return text;
  }
  const translated = translateCurrent(lookup);
  if (translated !== lookup) {
    return `${leading}${translated}${trailing}`;
  }
  // 未命中:精灵配件「备用版」名(生殖器/发型/尾巴/胸罩…)运行期由 `parent_type::name + " (Alt)"`
  // 编译期拼成("Human (Alt)"/"Pair (Alt)"/"Knotted (Alt)"…)，整串永不是字面量、无法抽取(抽出的是
  // 含占位符的模板 "{0} (Alt)"、反查跳过) → 译**基础名**、保留 " (Alt)" 后缀标记。
  const altMatch = lookup.match(/^(.+) \(Alt\)$/);
  if (altMatch) {
    const baseTranslated = translateCurrent(altMatch[1]);
    if (baseTranslated !== altMatch[1]) {
      return `${leading}${baseTranslated} (Alt)${trailing}`;
    }
  }
  // 未命中时保留原始 body（含原排版），不改动。
  return `${leading}${body}${trailing}`;
}

// 混合 children 的占位符模板。
//
// `<Box>Reduced by {n}% when infected with viruses.</Box>` 的 children 是
// ["Reduced by ", n, "% when infected with viruses."]。逐段查表会按**英文语序**把中文碎片
// 拼回去（「减少了 2 感染病毒时的%。」）——中文语序与英文不同，碎片翻译必错，比不翻更糟。
// 抽取期（tgui-catalog.mjs childrenTemplate）已把整条存成
// `Reduced by {0}% when infected with viruses.`，这里整条查、再把占位符换回原来的非字符串
// children，语序由译文决定。
//
// 查不到就**整条保持英文**，绝不回退到逐段翻译——那正是要根除的乱序来源。
function localizeChildrenTemplate(children: unknown[]): unknown[] | null {
  let slots = 0;
  let hasText = false;
  let template = '';
  for (const child of children) {
    if (typeof child === 'string') {
      hasText = true;
      template += child;
    } else {
      template += `{${slots++}}`;
    }
  }
  if (!hasText || slots === 0) {
    return null;
  }
  const lookup = template.replace(/\s+/g, ' ').trim();
  if (NO_AUTO_TRANSLATE.has(lookup)) {
    return null;
  }
  const translated = translateCurrent(lookup);
  if (translated === lookup) {
    return null;
  }
  // 占位符必须一一对上，否则说明目录条目与这处 children 形状不符（例如 `{cond && <X/>}`
  // 运行期塌成 false、少了一个位）——宁可整条不翻，也不能错位重组。
  const seen = new Set<number>();
  const pieces = translated.split(/\{(\d+)\}/);
  const rebuilt: unknown[] = [];
  for (let i = 0; i < pieces.length; i++) {
    if (i % 2 === 0) {
      if (pieces[i]) rebuilt.push(pieces[i]);
      continue;
    }
    const index = Number.parseInt(pieces[i], 10);
    const slotChildren = children.filter((c) => typeof c !== 'string');
    if (!Number.isInteger(index) || index < 0 || index >= slotChildren.length) {
      return null;
    }
    seen.add(index);
    rebuilt.push(slotChildren[index]);
  }
  if (seen.size !== slots) {
    return null;
  }
  return rebuilt;
}

export function localizeNode(value: unknown): unknown {
  if (typeof value === 'string') {
    return translateText(value);
  }
  if (Array.isArray(value)) {
    let changed = false;
    const localized = value.map((entry) => {
      const nextEntry = localizeNode(entry);
      changed ||= nextEntry !== entry;
      return nextEntry;
    });
    return changed ? localized : value;
  }
  return value;
}

function localizeOption(option: unknown): unknown {
  // 裸字符串选项**一律不翻**：在 tgui-core Dropdown 里「字符串选项的值===显示文本」(m(o)=o)，
  // onSelected 回传的就是这个字符串。若翻成中文，回传中文、而调用方几乎都按英文原文匹配
  // (`aug_options.find(a => displayName(a) === 回传)`、`value === style.name`、或把回传直接当
  // `style_name`/标识符发回服务端) → 匹配失败、选择静默失效（「强化+ 身体部位下拉点了没反应」即此）。
  // 字符串选项的「值」本身就是标识符,不可改。需要既翻显示又能正确回传的下拉,应改用**对象选项**
  // `{value, displayText}`：value 保持英文标识符(下面只翻 displayText)——见 LimbsPage 强化/植入下拉。
  if (typeof option === 'string') {
    return option;
  }
  if (!option || typeof option !== 'object' || Array.isArray(option)) {
    return localizeNode(option);
  }

  let nextOption = option as Record<string, unknown>;
  for (const propName of OPTION_TEXT_PROPS) {
    const propValue = nextOption[propName];
    if (typeof propValue !== 'string') {
      continue;
    }

    const localized = translateText(propValue);
    if (localized === propValue) {
      continue;
    }

    if (nextOption === option) {
      nextOption = { ...nextOption };
    }
    nextOption[propName] = localized;
  }
  return nextOption;
}

function localizeOptions(value: unknown): unknown {
  if (!Array.isArray(value)) {
    return value;
  }

  let changed = false;
  const localized = value.map((option) => {
    const nextOption = localizeOption(option);
    changed ||= nextOption !== option;
    return nextOption;
  });
  return changed ? localized : value;
}

// tgui-core Dropdown 专用：**裸字符串选项**既是显示又是回传值（`m(o) = o`），所以
// localizeOption 一律不翻它们——翻了 onSelected 就回传中文，调用方/服务端按英文匹配全部失效。
// 但整个界面里下拉往往是唯一还在显示英文的控件（ID 饰边压印机的饰边表、管道分配器的管件表…）。
//
// Dropdown 自己支持对象选项 `{value, displayText}`：菜单渲染 displayText、onSelected 回传 value。
// 所以这里在**运行时**把裸字符串升级成对象——value 保留原英文标识符，只有显示换成译文。调用方
// 代码一行不用改，整类「下拉不翻」一次解决。识别靠**组件标识**（`type === Dropdown`）而不是
// 「有 options prop」：界面里自定义组件也叫 options（AdminFax/LogViewer 的 `string[]`），
// 按 prop 名猜会把对象塞给只会渲染字符串的组件。
//
// 另一半是**收起时的按钮文字**：Dropdown 显示 `displayText || selected`，而 selected 由调用方
// 传的是 value（英文标识符）→ 菜单已是中文、按钮仍是英文。调用方没显式给 displayText 时，
// 这里按 selected 补一个译文；selected 本身不动，findIndex/高亮/回传全部照旧按英文匹配。
function localizeDropdownProps(
  props: Record<string, unknown>,
): Record<string, unknown> {
  let next = props;

  const options = props.options;
  if (Array.isArray(options)) {
    let changed = false;
    const localized = options.map((option) => {
      if (typeof option !== 'string') {
        return option;
      }
      const translated = translateText(option);
      if (translated === option) {
        return option;
      }
      changed = true;
      return { value: option, displayText: translated };
    });
    if (changed) {
      next = { ...next, options: localized };
    }
  }

  if (next.displayText === undefined || next.displayText === null) {
    const selected = props.selected;
    let selectedText: string | null = null;
    if (typeof selected === 'string') {
      const translated = translateText(selected);
      if (translated !== selected) {
        selectedText = translated;
      }
    } else if (selected && typeof selected === 'object') {
      // 对象选项的 selected：Dropdown 收起时显示的是 value 而非 displayText，同样要补。
      const display = (selected as Record<string, unknown>).displayText;
      if (typeof display === 'string') {
        selectedText = translateText(display);
      }
    }
    if (selectedText !== null) {
      next = next === props ? { ...next } : next;
      next.displayText = selectedText;
    }
  }

  return next;
}

export function localizeProps(props: unknown, type?: unknown): unknown {
  if (!props || typeof props !== 'object' || Array.isArray(props)) {
    return props;
  }

  let nextProps = props as Record<string, unknown>;
  for (const [propName, propValue] of Object.entries(nextProps)) {
    let localized: unknown = propValue;
    if (propName === 'children') {
      if (Array.isArray(propValue)) {
        // 文本与表达式混排：先试整条模板；成功即用，失败则整条保持英文（不逐段翻）。
        const templated = localizeChildrenTemplate(propValue);
        if (templated) {
          localized = templated;
        } else if (propValue.some((c) => typeof c !== 'string')) {
          localized = propValue;
        } else {
          localized = localizeNode(propValue);
        }
      } else {
        localized = localizeNode(propValue);
      }
    } else if (propName === 'options') {
      localized = localizeOptions(propValue);
    } else if (TRANSLATABLE_PROPS.has(propName)) {
      localized = localizeNode(propValue);
    }

    if (localized === propValue) {
      continue;
    }

    if (nextProps === props) {
      nextProps = { ...nextProps };
    }
    nextProps[propName] = localized;
  }

  if (type === Dropdown) {
    return localizeDropdownProps(nextProps);
  }

  return nextProps;
}
