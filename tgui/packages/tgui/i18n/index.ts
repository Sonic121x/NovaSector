// THIS IS A NOVA SECTOR UI FILE
// Explicit contextual messages are the application-facing API. The custom JSX runtime below
// remains only as a legacy/upstream adapter for source that cannot carry typed display contracts.
// Catalogs are bundled because BYOND's embedded browser has no runtime network dependency.
// Placeholders use the DM-compatible positional form {0}, {1}, and may be reordered by locale.

import { createElement as reactCreateElement } from 'react';
import { useBackend } from '../backend';
import { translate } from './catalog';
import {
  localizedDropdownOption,
  localizedOption,
  translateMessage,
  type CanonicalOptionValue,
  type LocalizedDropdownOption,
  type LocalizedMessage,
  type LocalizedOption,
  type LocalizedText,
  type MessageArgument,
} from './messages';
import { localizeNode, localizeProps } from './localize';

export { translate, translateCurrent } from './catalog';
export {
  defineMessage,
  localizedDropdownOption,
  localizedOption,
  messageKey,
  translateMessage,
  translateMessageCurrent,
  translateOption,
  translateOptionCurrent,
} from './messages';
export type {
  CanonicalOptionValue,
  LocalizedDropdownOption,
  LocalizedMessage,
  LocalizedOption,
  LocalizedText,
  MessageArgument,
} from './messages';

/** Low-level hook for existing stable catalog keys; never pass payload identifiers here. */
export function useT(): (key: string, args?: Array<string | number>) => string {
  const { config } = useBackend();
  const locale = config?.locale ?? 'en';
  return (key, args) => translate(locale, key, args);
}

export type MessageTranslator = {
  text(
    message: LocalizedMessage,
    args?: ReadonlyArray<MessageArgument>,
  ): LocalizedText;
  option<const Value extends CanonicalOptionValue>(
    value: Value,
    message: LocalizedMessage,
    args?: ReadonlyArray<MessageArgument>,
  ): LocalizedOption<Value>;
  dropdownOption<const Value extends CanonicalOptionValue>(
    value: Value,
    message: LocalizedMessage,
    args?: ReadonlyArray<MessageArgument>,
  ): LocalizedDropdownOption<Value>;
};

/** Context-aware translator for application code. Canonical values only enter option.value. */
export function useTranslator(): MessageTranslator {
  const { config } = useBackend();
  const locale = config?.locale ?? 'en';
  return {
    text: (message, args) => translateMessage(locale, message, args),
    option: (value, message, args) =>
      localizedOption(value, translateMessage(locale, message, args)),
    dropdownOption: (value, message, args) =>
      localizedDropdownOption(
        value,
        translateMessage(locale, message, args),
      ),
  };
}

/** React classic-runtime entrypoint for the legacy/upstream automatic adapter. */
export function createElement(
  type: unknown,
  props: unknown,
  ...children: unknown[]
) {
  const localizedChildren = children.map((child) => localizeNode(child));
  return reactCreateElement(
    type as never,
    localizeProps(props, type) as never,
    ...(localizedChildren as never[]),
  );
}
