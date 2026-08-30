// THIS IS A NOVA SECTOR UI FILE
// Built-in TGUI catalogs. Runtime locale is supplied by BYOND in config.locale.

import { configAtom, store } from '../events/store';
import en from './en.json';
import zhHans from './zh-Hans.json';

type Catalog = Record<string, string>;

const CATALOGS: Record<string, Catalog> = {
  en: en as Catalog,
  'zh-Hans': zhHans as Catalog,
};

const DEFAULT_LOCALE = 'en';
let catalogRevision = 0;


/// 本次会话累积的**负载 overlay**：`英文 → 译文`，由 DM 侧随 ui_data/ui_static_data 下发
/// （见 tgui.dm 的 `json_data["i18n"]`）。
///
/// 存在的理由：运行期才成形的负载值（atom 名、datum 描述、拼接句）不可能出现在编译期抽取的静态
/// 目录里。从前 DM 直接把译文写进负载值，代价是**回传的标识符也被改成了中文** —— 服务端仍拿英文
/// 比较/查表，`ui_act` 静默失败。现在负载保持 canonical English，译文单独走这张表，只在渲染期用。
///
/// 合并而非替换：static_data 只在开窗时下发一次，之后每次 update 只带 data，覆盖会把静态那半丢掉。
let overlay: Catalog = {};

/// overlay 的**归一化索引**：小写键 → 译文。
///
/// 界面常在渲染前给运行期值套一层显示包装：`capitalize(x)` / `toTitleCase(x)` / `capitalizeAll(x)`
/// （全仓约 29 处）。包装后的串与负载里的原值只差大小写，精确查表必然 miss，整类回退英文。
/// 只对 overlay 建这个索引、不碰静态目录：overlay 的条目都是本次负载里**已确认是显示值**的串，
/// 大小写不敏感命中不会扩大误翻面；静态目录里则混着标识符形态的短键，放宽是危险的。
let overlayNormalized: Catalog = {};

function normalizeOverlayKey(key: string): string {
  return key.toLowerCase();
}

/// overlay 键的子串匹配器（按长度降序，最长优先）。界面里大量运行期值是被**拼进**一个更大的串
/// 再渲染的：`` {`${mode.name} - ${mode.desc}`} ``、`` title={`${x.name} (${n})`} `` 之类（全仓
/// 五十余处，还不含经解构/中间变量到达渲染点、静态扫描看不见的那些）。整串永远不是目录键，
/// 精确查表必 miss → 整条回退英文。
///
/// 子串替换在 DM 侧（字面 AC）是出过事的——无词边界概念，拼句碎片会从单词内部开火。这里靠三条守住：
///   · **只收多词键**（见 getOverlayMatcher 的过滤）。单词键仍在 overlay 里、照常做整串精确查表，
///     但绝不参与子串替换——单词从另一个词内部开火正是 DM 侧那些事故的形态。
///     （这条从前由 P1 的多词门槛顺带保证；门槛放开、单词值也进 overlay 之后，必须在这里显式挡。）
///   · 匹配面只有**本次负载**里那几十条已确认的显示值，不是整个目录；
///   · 词边界检查（前后不得是字母/数字），把 "Water Bottle" 咬进 "Water Bottled" 这类挡掉。
let overlayMatcher: RegExp | null = null;
let overlayMatcherStale = true;

function escapeRegExp(text: string): string {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function getOverlayMatcher(): RegExp | null {
  if (!overlayMatcherStale) {
    return overlayMatcher;
  }
  overlayMatcherStale = false;
  // 只收多词键；最长优先（交替分支按顺序试，短键排前面会把长键遮住——DM 侧 AC 的 LeftmostLongest 踩过两次）。
  const keys = Object.keys(overlay)
    .filter((key) => key.includes(' '))
    .sort((a, b) => b.length - a.length);
  overlayMatcher = keys.length
    ? new RegExp(keys.map(escapeRegExp).join('|'), 'g')
    : null;
  return overlayMatcher;
}

function isWordChar(char: string | undefined): boolean {
  return !!char && /[A-Za-z0-9]/.test(char);
}

/// 用 overlay 的键在串里做子串替换。没有任何键命中时返回 null（调用方保持原串）。
export function substituteOverlay(text: string): string | null {
  const matcher = getOverlayMatcher();
  if (!matcher) {
    return null;
  }
  let changed = false;
  matcher.lastIndex = 0;
  const result = text.replace(matcher, (match, offset: number) => {
    const before = text[offset - 1];
    const after = text[offset + match.length];
    // 词边界：命中处紧邻字母/数字说明咬进了另一个词的中间。
    if (isWordChar(before) || isWordChar(after)) {
      return match;
    }
    changed = true;
    return overlay[match];
  });
  return changed ? result : null;
}

export function mergeCatalogOverlay(entries: Catalog): void {
  overlay = { ...overlay, ...entries };
  overlayMatcherStale = true;
  catalogRevision++;
  for (const key of Object.keys(entries)) {
    overlayNormalized[normalizeOverlayKey(key)] = entries[key];
  }
}

export function resetCatalogOverlay(): void {
  overlay = {};
  overlayMatcherStale = true;
  overlayNormalized = {};
  catalogRevision++;
}

export function getCatalogRevision(): number {
  return catalogRevision;
}

export function getCurrentLocale(): string {
  return store.get(configAtom)?.locale ?? DEFAULT_LOCALE;
}

/**
 * 单趟填充 `{0}`/`{1}`/… 占位符。按序 `split('{i}').join(args[i])` 会把**已经写进串里的实参**
 * 当成下一轮模板再扫一遍：`"{0} then {1}"` + `["x{1}x", "END"]` 会变成 `xENDx then END`。
 * 对标 DM `lang_interpolate`；catalog 的 translate/translateStatic 与 messages 共用。
 */
export function fillArgs(
  template: string,
  args?: ReadonlyArray<string | number>,
): string {
  if (!args?.length) {
    return template;
  }
  return template.replace(/\{(\d+)\}/g, (placeholder, rawIndex) => {
    const index = Number(rawIndex);
    return index < args.length ? String(args[index]) : placeholder;
  });
}

function staticTemplate(locale: string, key: string): string {
  const catalog = CATALOGS[locale] ?? CATALOGS[DEFAULT_LOCALE];
  return (
    catalog?.[key] ??
    CATALOGS[DEFAULT_LOCALE]?.[key] ??
    key
  );
}

export function translate(
  locale: string,
  key: string,
  args?: ReadonlyArray<string | number>,
): string {
  const catalog = CATALOGS[locale] ?? CATALOGS[DEFAULT_LOCALE];
  // Overlay belongs to the automatic upstream adapter. Explicit contextual messages use
  // translateStatic(), so payload values can never shadow authored display messages.
  const template =
    overlay[key] ??
    catalog?.[key] ??
    CATALOGS[DEFAULT_LOCALE]?.[key] ??
    overlayNormalized[normalizeOverlayKey(key)] ??
    key;
  return fillArgs(template, args);
}

/** Low-level keyed lookup which excludes runtime payload overlays. */
export function translateStatic(
  locale: string,
  key: string,
  args?: ReadonlyArray<string | number>,
): string {
  return fillArgs(staticTemplate(locale, key), args);
}

export function translateCurrent(
  key: string,
  args?: ReadonlyArray<string | number>,
): string {
  return translate(getCurrentLocale(), key, args);
}

export function translateStaticCurrent(
  key: string,
  args?: ReadonlyArray<string | number>,
): string {
  return translateStatic(getCurrentLocale(), key, args);
}
