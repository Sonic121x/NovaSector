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

export function mergeCatalogOverlay(entries: Catalog): void {
  overlay = { ...overlay, ...entries };
  for (const key of Object.keys(entries)) {
    overlayNormalized[normalizeOverlayKey(key)] = entries[key];
  }
}

export function resetCatalogOverlay(): void {
  overlay = {};
  overlayNormalized = {};
}

export function translate(
  locale: string,
  key: string,
  args?: Array<string | number>,
): string {
  const catalog = CATALOGS[locale] ?? CATALOGS[DEFAULT_LOCALE];
  // overlay 优先：它是本次负载的运行期真值，静态目录里不可能有。locale==en 时 DM 不下发 overlay。
  // 归一化索引排在静态目录之后：静态目录的精确命中永远优先于 overlay 的模糊命中。
  let template =
    overlay[key] ??
    catalog?.[key] ??
    CATALOGS[DEFAULT_LOCALE]?.[key] ??
    overlayNormalized[normalizeOverlayKey(key)] ??
    key;
  if (args) {
    for (let i = 0; i < args.length; i++) {
      template = template.split(`{${i}}`).join(String(args[i]));
    }
  }
  return template;
}

export function translateCurrent(
  key: string,
  args?: Array<string | number>,
): string {
  const locale = store.get(configAtom)?.locale ?? DEFAULT_LOCALE;
  return translate(locale, key, args);
}
