// THIS IS A NOVA SECTOR UI FILE
// JSX 自动本地化运行时。Rspack/SWC 只对 packages/tgui 使用这个 importSource；
// tgui-panel / tgui-say 继续使用 React 原生 jsx-runtime。

import {
  Fragment,
  jsx as reactJsx,
  jsxs as reactJsxs,
} from 'react/jsx-runtime';
import { localizeProps } from './localize';

export { Fragment };

export function jsx(type: unknown, props: unknown, key?: string) {
  return reactJsx(type as never, localizeProps(props, type) as never, key);
}

export function jsxs(type: unknown, props: unknown, key?: string) {
  return reactJsxs(type as never, localizeProps(props, type) as never, key);
}
