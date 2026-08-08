// THIS IS A NOVA SECTOR UI FILE
// Development JSX runtime wrapper paired with jsx-runtime.ts.

import { Fragment, jsxDEV as reactJsxDEV } from 'react/jsx-dev-runtime';
import { localizeProps } from './localize';

export { Fragment };

export function jsxDEV(
  type: unknown,
  props: unknown,
  key: string | undefined,
  isStaticChildren: boolean,
  source: unknown,
  self: unknown,
) {
  return reactJsxDEV(
    type as never,
    localizeProps(props, type) as never,
    key,
    isStaticChildren,
    source as never,
    self,
  );
}
