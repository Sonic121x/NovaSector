// ZH EDIT ADDITION - I18N
// The escape menu is its own bundle, so the TGUI catalog and auto-localization don't reach it.
// The server sends the labels for the current locale with the init message
// (strings/i18n/escape_menu_labels.json); anything not in it stays English.

let translations: Record<string, string> = {};

/** An empty DM list arrives as `[]`; that and anything else that isn't a table means English. */
export function setTranslations(table: unknown) {
  translations =
    table && typeof table === 'object' && !Array.isArray(table)
      ? (table as Record<string, string>)
      : {};
}

export function t(text: string): string {
  return translations[text] ?? text;
}
