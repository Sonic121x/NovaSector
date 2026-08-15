// THIS IS A NOVA SECTOR UI FILE
// Shared helpers for automatic TGUI JSX localization.

import { Dropdown } from 'tgui-core/components';

import { translateCurrent } from './catalog';
import policy from './policy.json';
import propTemplateKeys from './prop-templates.json';

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

// 运行期在 TS 里拼出来的 prop 值（`` title={`Reading: ${data.title}`} ``）的落地层。
//
// 整串是运行期产物、永远不是目录键，所以精确查表必然 miss，框架词（`Reading:` / `Mutant` /
// `Food Left:`）永远英文。抽取器已按 `Reading: {0}` 的模板把它们收进目录（见 tgui-catalog.mjs
// propTemplate），这里做**逆匹配**：按字面段还原出模板 → 查译文 → 把捕获值填回中文语序。
//
// 三条安全线，每一条 DM 侧都栽过：
//  ① 准入面只有 sidecar 里那批 prop 模板。目录里另有 590+ 条 children 模板，它们运行时按整条
//     精确查表；把 `- {0}, the {1}` / `{0} of 12 total` 这种泛化骨架放进逆匹配面，会把任意
//     同形状的整句劫持成「中文脚手架裹着英文」——比不翻更难看。
//  ② **整串精确查表永远排在逆匹配之前**（见 translateText 的调用顺序）：最具体的证据优先，
//     命中就直接返回，不给骨架模板抢先的机会。
//  ③ 逆匹配是**整串**匹配（`^…$`），不是子串替换；多条同时匹配时取字面段最长的那条（最具体）。
type PropTemplate = {
  key: string;
  pattern: RegExp;
  anchor: string; // 最长字面段，用作 includes() 预筛
  literalLength: number;
  slots: number[]; // 按出现顺序的占位符编号
  trailingLiteral: boolean[]; // 第 i 个占位符后面是否还有字面段
};

let propTemplateIndex: PropTemplate[] | null = null;
const propTemplateCache = new Map<string, string | null>();

function escapeRegExp(text: string): string {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function buildPropTemplateIndex(): PropTemplate[] {
  const out: PropTemplate[] = [];
  for (const key of propTemplateKeys as string[]) {
    const pieces = key.split(/\{(\d+)\}/);
    if (pieces.length < 3) continue;
    let pattern = '^';
    let anchor = '';
    let literalLength = 0;
    const slots: number[] = [];
    const trailingLiteral: boolean[] = [];
    for (let i = 0; i < pieces.length; i++) {
      if (i % 2 === 0) {
        pattern += escapeRegExp(pieces[i]);
        literalLength += pieces[i].length;
        if (pieces[i].length > anchor.length) anchor = pieces[i];
        if (pieces[i] && trailingLiteral.length) {
          trailingLiteral[trailingLiteral.length - 1] = true;
        }
      } else {
        slots.push(Number.parseInt(pieces[i], 10));
        trailingLiteral.push(false);
        pattern += '([\\s\\S]*?)';
      }
    }
    pattern += '$';
    if (!anchor) continue;
    out.push({
      key,
      pattern: new RegExp(pattern),
      anchor,
      literalLength,
      slots,
      trailingLiteral,
    });
  }
  // 最具体的先试。
  out.sort((a, b) => b.literalLength - a.literalLength);
  return out;
}

/**
 * 占位符代表的是一个**值**（名字、数量、状态词），不是一段散文。
 *
 * 这是逆匹配最关键的一道闸门，而且只能设在运行期：抽取期看不出 `Select {0}` 的 `{0}` 将来会
 * 被喂进什么。`Select {0}` 的锚 "Select " 是正经实词，却是极常见的句子开头 —— 目录里就有 17 条
 * 「Select a policy to view. These policies are…」这样的整句能匹配上，一旦放行就会被改写成
 * 「选择a policy to view.…」这种中文脚手架裹英文的东西，比不翻更难看。
 *
 * 判据按「值 vs 散文」分：值不长、不跨句、不以小写词开头（名字/数字/状态词都是大写或数字），
 * 也不会自带句末标点（除非模板本身在它后面还有字面段）。
 */
function capturesLookLikeValues(
  match: RegExpExecArray,
  tpl: PropTemplate,
): boolean {
  for (let i = 0; i < tpl.slots.length; i++) {
    const captured = (match[i + 1] ?? '').trim();
    if (!captured) {
      continue;
    }
    if (captured.length > 60) {
      return false;
    }
    if (/[.!?][\s ]/.test(captured)) {
      return false; // 跨句
    }
    const words = captured.split(/\s+/);
    if (words.length > 1 && /^\p{Ll}/u.test(captured)) {
      return false; // 小写开头的多词 = 半句散文
    }
    if (words.length > 8) {
      return false;
    }
    if (/[.!?]$/.test(captured) && !tpl.trailingLiteral[i]) {
      return false; // 模板末尾直接吞掉了一句带句号的话
    }
  }
  return true;
}

function matchPropTemplate(text: string): string | null {
  const cached = propTemplateCache.get(text);
  if (cached !== undefined) {
    return cached;
  }
  propTemplateIndex ??= buildPropTemplateIndex();
  let result: string | null = null;
  for (const tpl of propTemplateIndex) {
    if (!text.includes(tpl.anchor)) {
      continue;
    }
    const match = tpl.pattern.exec(text);
    if (!match) {
      continue;
    }
    const translated = translateCurrent(tpl.key);
    if (translated === tpl.key) {
      continue; // 未译：还原出模板也没有收益，继续找更长的（或放弃）。
    }
    // 译文丢了占位符就会丢内容（人名、数量…），宁可整条保持英文。
    if (tpl.slots.some((slot) => !translated.includes(`{${slot}}`))) {
      continue;
    }
    if (!capturesLookLikeValues(match, tpl)) {
      continue;
    }
    let filled = translated;
    for (let i = 0; i < tpl.slots.length; i++) {
      // 捕获值本身也可能是目录条目（物品名/语言名/部门名…）——只做**整串精确**查表，
      // 未命中就原样填回（玩家名、数字之类本就不该翻）。
      const captured = match[i + 1] ?? '';
      const localized = captured ? translateCurrent(captured) : captured;
      filled = filled.split(`{${tpl.slots[i]}}`).join(localized);
    }
    result = filled;
    break;
  }
  // 逆匹配跑在每次「精确查表 miss」上（多为逐帧重渲染的同一批串），缓存必要；但键是任意
  // 运行期串（含变动的数量/名字），不设上限会随界面刷新无限长。
  if (propTemplateCache.size > 2000) {
    propTemplateCache.clear();
  }
  propTemplateCache.set(text, result);
  return result;
}

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
  // 精确查表 miss 之后才轮到 prop 模板逆匹配（顺序见 matchPropTemplate 的安全线 ②）。
  const templated = matchPropTemplate(lookup);
  if (templated !== null) {
    return `${leading}${templated}${trailing}`;
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
// React 对 null/undefined/boolean 型 children **什么都不渲染**。它们几乎都来自
// `{cond && <X/>}` 在 cond 为假时的求值结果，在 children 数组里只是个空位。
//
// 把它们当成占位符建模板，是整类「目录里有译文、界面却永远英文」的根因：反派介绍 tooltip
// 的 `<div>{text}{index !== last && <Divider/>}</div>`，最后一段（多数反派只有一段）的
// children 是 `[介绍原文, false]` → 模板变成 `…station.{0}`，目录里当然没有 → 整条回退
// 英文；连带下面「混排就整条保持英文」的保守分支也一起把它焊死。渲染不出东西的空位必须
// 在建模板前就剔除，剩下的才是真正参与语序的片段。
function isIgnorableChild(child: unknown): boolean {
  return child === null || child === undefined || typeof child === 'boolean';
}

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

// 混排 children 里，「整条模板查不到就整条保持英文」这条保守分支挡住的是**拼句碎片**
// （"Reduced by " / "% when infected."）——它们各自只是半句，单独翻会按英文语序拼回去。
//
// 但同样形状里还有一类**完整独立文本**：它不是静态 JSX 拼句的一半，而是运行期塞进来的一整条
// 文案，兄弟节点只是图标/分隔线之类的非文本装饰：
//   `<Box>{icon && <Icon/>}{tab.name}</Box>`      配装页分类页签（"Head"）
//   `<div>{desc}{notLast && <Divider/>}</div>`    反派介绍 tooltip（非末段）
//   `<>{name}<span>{n} slots available</span></>` 中途加入菜单的部门标题
// 这些整条模板永远不会在目录里（字符串是运行期数据、不是抽取得到的字面量），于是全部被保守
// 分支焊死成英文——而它们各自的英文原文**本来就是独立目录键**、译文一直躺在目录里。
//
// 判据用「每个非空白字符串 child 都能整条精确命中目录」：碎片按定义不是独立键（抽取器只存整条
// 模板），命中不了 → 仍走保守分支。再加一道形态闸门挡掉「碰巧也是键」的续接碎片：以小写字母
// 或标点开头的片段一律视为半句。
function isSelfContainedText(text: string): boolean {
  const body = text.trim();
  if (!body) {
    return true; // 纯空白（prettier 换行插的 `{' '}` 等）不参与判定，原样保留。
  }
  // 续接碎片形态：", and "、"% when infected." —— 首字符是小写字母或标点。
  return !/^[\p{Ll}\p{P}\p{S}]/u.test(body);
}

function localizeChildrenSegments(children: unknown[]): unknown[] | null {
  let changed = false;
  const localized: unknown[] = [];
  for (const child of children) {
    if (typeof child !== 'string') {
      localized.push(child);
      continue;
    }
    if (!isSelfContainedText(child)) {
      return null;
    }
    const next = translateText(child);
    if (next === child) {
      // 空白 child 翻不动是正常的；有实义却查不到，说明它是碎片 → 整条保持英文。
      if (child.trim()) {
        return null;
      }
    } else {
      changed = true;
    }
    localized.push(next);
  }
  return changed ? localized : null;
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
        // 先剔除渲染不出东西的空位（`{cond && <X/>}` 为假时的 false 等），它们既不参与语序、
        // 也不该占占位符——否则整条模板必然查不到、整段回退英文。
        const rendered = propValue.filter((c) => !isIgnorableChild(c));
        // 文本与表达式混排：先试整条模板；成功即用，失败则整条保持英文（不逐段翻）。
        const templated = localizeChildrenTemplate(rendered);
        if (templated) {
          localized = templated;
        } else if (rendered.some((c) => typeof c !== 'string')) {
          // 整条模板未命中：只有在每个字符串 child 都是**完整独立目录条目**时才逐段翻
          // （运行期文案 + 图标/分隔线的形状），否则整条保持英文。
          const segments = localizeChildrenSegments(rendered);
          localized = segments ?? propValue;
        } else {
          const localizedText = localizeNode(rendered);
          localized = localizedText === rendered ? propValue : localizedText;
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
