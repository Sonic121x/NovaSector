// THIS IS A NOVA SECTOR UI FILE
// Typed, context-aware display messages. Canonical values never pass through translation.

import { fillArgs, translateStatic, translateStaticCurrent } from './catalog';

const CONTEXT_SEPARATOR = '\u0004';
const CONTEXT_PATTERN = /^[a-z][a-z0-9]*(?:[._/-][a-z0-9]+)*$/;
const LOCALIZED_OPTION_MARKER = Symbol('tgui.localized-option');

declare const localizedTextBrand: unique symbol;
declare const localizedMessageBrand: unique symbol;

export type MessageArgument = string | number;

/** Text that has crossed an explicit display-translation boundary. */
export type LocalizedText = string & {
  readonly [localizedTextBrand]: true;
};

/**
 * An extractable display message. `context` disambiguates identical English
 * sources; `source` remains the English fallback shown when a locale is absent.
 */
export type LocalizedMessage<
  Context extends string = string,
  Source extends string = string,
> = Readonly<{
  context: Context;
  source: Source;
  readonly [localizedMessageBrand]: true;
}>;

export type CanonicalOptionValue = string | number;

/** A canonical option value paired with display-only localized text. */
export type LocalizedOption<Value extends CanonicalOptionValue> = Readonly<{
  value: Value;
  label: LocalizedText;
}>;

/** Shape consumed by tgui-core Dropdown without changing its canonical value. */
export type LocalizedDropdownOption<Value extends CanonicalOptionValue> =
  Readonly<{
    value: Value;
    displayText: LocalizedText;
  }>;

type LiteralString<Value extends string> = string extends Value ? never : Value;
type MessageCatalog = Readonly<Record<string, string>>;

function markLocalizedOption<Option extends object>(option: Option): Option {
  Object.defineProperty(option, LOCALIZED_OPTION_MARKER, {
    value: true,
    enumerable: false,
  });
  return option;
}

/** Identifies options whose label already crossed the typed translation boundary. */
export function isLocalizedOption(option: unknown): boolean {
  return (
    !!option && typeof option === 'object' && LOCALIZED_OPTION_MARKER in option
  );
}

/**
 * Declares a message for `tgui-catalog.mjs`. Both arguments must be stable
 * string literals at the callsite so extraction can fail closed.
 */
export function defineMessage<
  const Context extends string,
  const Source extends string,
>(
  context: LiteralString<Context>,
  source: LiteralString<Source>,
): LocalizedMessage<Context, Source> {
  if (!CONTEXT_PATTERN.test(context)) {
    throw new Error(
      `Invalid translation context ${JSON.stringify(context)}; use stable lowercase segments`,
    );
  }
  if (!source.trim()) {
    throw new Error('Localized message source must not be empty');
  }
  if (source.includes(CONTEXT_SEPARATOR)) {
    throw new Error('Localized message source contains the context separator');
  }
  return Object.freeze({ context, source }) as unknown as LocalizedMessage<
    Context,
    Source
  >;
}

/** Deterministic catalog key shared by extraction and runtime lookup. */
export function messageKey(message: LocalizedMessage): string {
  return `${message.context}${CONTEXT_SEPARATOR}${message.source}`;
}

function fillMessage(
  template: string,
  args?: ReadonlyArray<MessageArgument>,
): LocalizedText {
  return fillArgs(template, args) as LocalizedText;
}

/** Pure resolver used when a caller owns a catalog (and by focused tests). */
export function translateMessageFromCatalog(
  catalog: MessageCatalog,
  message: LocalizedMessage,
  args?: ReadonlyArray<MessageArgument>,
): LocalizedText {
  return fillMessage(catalog[messageKey(message)] ?? message.source, args);
}

/** Explicit contextual translation. Payload overlays are deliberately excluded. */
export function translateMessage(
  locale: string,
  message: LocalizedMessage,
  args?: ReadonlyArray<MessageArgument>,
): LocalizedText {
  const key = messageKey(message);
  const translated = translateStatic(locale, key);
  return fillMessage(translated === key ? message.source : translated, args);
}

/** Explicit contextual translation using the active TGUI locale. */
export function translateMessageCurrent(
  message: LocalizedMessage,
  args?: ReadonlyArray<MessageArgument>,
): LocalizedText {
  const key = messageKey(message);
  const translated = translateStaticCurrent(key);
  return fillMessage(translated === key ? message.source : translated, args);
}

/** Pairs an untouched canonical value with an already-localized label. */
export function localizedOption<const Value extends CanonicalOptionValue>(
  value: Value,
  label: LocalizedText,
): LocalizedOption<Value> {
  return markLocalizedOption({ value, label });
}

/** Builds the object shape accepted by tgui-core Dropdown. */
export function localizedDropdownOption<
  const Value extends CanonicalOptionValue,
>(value: Value, label: LocalizedText): LocalizedDropdownOption<Value> {
  return markLocalizedOption({ value, displayText: label });
}

/** Translates only the label while preserving the value's exact type and bytes. */
export function translateOption<const Value extends CanonicalOptionValue>(
  locale: string,
  value: Value,
  message: LocalizedMessage,
  args?: ReadonlyArray<MessageArgument>,
): LocalizedOption<Value> {
  return localizedOption(value, translateMessage(locale, message, args));
}

/** Active-locale variant of `translateOption`. */
export function translateOptionCurrent<
  const Value extends CanonicalOptionValue,
>(
  value: Value,
  message: LocalizedMessage,
  args?: ReadonlyArray<MessageArgument>,
): LocalizedOption<Value> {
  return localizedOption(value, translateMessageCurrent(message, args));
}
