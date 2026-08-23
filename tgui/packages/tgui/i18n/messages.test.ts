// THIS IS A NOVA SECTOR UI FILE
import { afterEach, describe, expect, test } from 'bun:test';

import { mergeCatalogOverlay, resetCatalogOverlay } from './catalog';
import { localizeProps } from './localize';
import {
  defineMessage,
  type LocalizedOption,
  localizedDropdownOption,
  localizedOption,
  messageKey,
  translateMessage,
  translateMessageFromCatalog,
  translateOption,
} from './messages';

const OPEN_MENU = defineMessage('inventory.menu', 'Open');

const OPEN_DOOR = defineMessage('airlock.action', 'Open');

function assertCompileTimeBoundaries() {
  const canonicalIdentifier: string = 'canonical-id';
  // @ts-expect-error Canonical strings are not contextual message descriptors.
  translateMessage('en', canonicalIdentifier);
  // @ts-expect-error Plain strings cannot be used as already-localized labels.
  localizedOption(canonicalIdentifier, canonicalIdentifier);
}
void assertCompileTimeBoundaries;

afterEach(() => {
  resetCatalogOverlay();
});

describe('contextual messages', () => {
  test('identical English sources resolve independently by stable context', () => {
    const catalog = {
      [messageKey(OPEN_MENU)]: '打开菜单',
      [messageKey(OPEN_DOOR)]: '开启气闸',
    };

    expect(String(translateMessageFromCatalog(catalog, OPEN_MENU))).toBe(
      '打开菜单',
    );
    expect(String(translateMessageFromCatalog(catalog, OPEN_DOOR))).toBe(
      '开启气闸',
    );
    expect(messageKey(OPEN_MENU)).not.toBe(messageKey(OPEN_DOOR));
  });

  test('missing locale entry returns the English source and fills dynamic values', () => {
    const status = defineMessage('machine.status', 'Slot {0}: {1}');
    expect(
      String(translateMessageFromCatalog({}, status, [3, 'Zxqv-id'])),
    ).toBe('Slot 3: Zxqv-id');
  });

  test('argument text cannot be consumed as a later placeholder', () => {
    const status = defineMessage('machine.interpolation', '{0} / {1} / {2}');
    expect(
      String(translateMessageFromCatalog({}, status, ['Zxqv{1}', 'Zxqv-tail'])),
    ).toBe('Zxqv{1} / Zxqv-tail / {2}');
  });

  test('payload overlay cannot shadow an explicit contextual message', () => {
    mergeCatalogOverlay({
      Open: 'overlay source',
      [messageKey(OPEN_MENU)]: 'overlay context',
    });

    expect(String(translateMessage('en', OPEN_MENU))).toBe('Open');
  });
});

describe('typed localized options', () => {
  test('canonical value stays byte-identical while only label is translated', () => {
    const canonical = 'toggle_reagent_sodium chloride' as const;
    const catalog = { [messageKey(OPEN_MENU)]: '打开菜单' };
    const label = translateMessageFromCatalog(catalog, OPEN_MENU);
    const option: LocalizedOption<typeof canonical> = localizedOption(
      canonical,
      label,
    );

    expect({ ...option, label: String(option.label) }).toEqual({
      value: canonical,
      label: '打开菜单',
    });
    expect(option.value).toBe(canonical);
    expect(new TextEncoder().encode(option.value)).toEqual(
      new TextEncoder().encode(canonical),
    );
  });

  test('translation helper never passes the canonical identifier through lookup', () => {
    const canonical = 'airlock/open' as const;
    const option = translateOption(
      'en',
      canonical,
      defineMessage('airlock.option', 'Open airlock'),
    );

    expect(option.value).toBe(canonical);
    expect(String(option.label)).toBe('Open airlock');
  });

  test('typed option labels are isolated from the automatic overlay adapter', () => {
    const label = translateMessageFromCatalog(
      { [messageKey(OPEN_MENU)]: 'Display label' },
      OPEN_MENU,
    );
    const option = localizedOption('canonical-id', label);
    mergeCatalogOverlay({ 'Display label': 'poisoned by overlay' });

    const props = localizeProps({ options: [option] }) as {
      options: Array<typeof option>;
    };
    expect(props.options[0]).toBe(option);
    expect(String(props.options[0].label)).toBe('Display label');
  });

  test('Dropdown helper uses displayText without altering the canonical value', () => {
    const label = translateMessageFromCatalog(
      { [messageKey(OPEN_DOOR)]: '开启气闸' },
      OPEN_DOOR,
    );
    const option = localizedDropdownOption('door/open', label);
    expect({ ...option, displayText: String(option.displayText) }).toEqual({
      value: 'door/open',
      displayText: '开启气闸',
    });
  });
});
