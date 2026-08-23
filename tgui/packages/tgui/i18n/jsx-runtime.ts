// THIS IS A NOVA SECTOR UI FILE
// Legacy/upstream automatic-localization adapter. Application-owned code should use typed,
// contextual messages; Rspack/SWC keeps this importSource for unmigrated upstream JSX.

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
