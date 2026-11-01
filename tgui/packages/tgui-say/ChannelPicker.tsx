// THIS IS A NOVA SECTOR UI FILE
import { classes } from 'tgui-core/react';

import { RADIO_PREFIXES } from './constants';

/** A radio channel or language the server says the speaker can use. */
export type SpeechOption = {
  /** What the server parses: `;`, `:e`, `,x`. */
  prefix: string;
  /** Localized display name. */
  name: string;
  /** Languages only: the one spoken without a prefix. */
  selected?: boolean;
};

export type SpeechOptions = {
  channels: SpeechOption[];
  languages: SpeechOption[];
};

/** Columns of options in the picker. */
const COLUMNS = 3;
/** Height of one row, in pixels. */
const ROW_HEIGHT = 22;
/** Rows shown at once; the rest scroll. */
const VISIBLE_ROWS = 8;

/** Channels the say box has a theme for; others cannot be shown on the channel button. */
export function pickableChannels(options: SpeechOptions): SpeechOption[] {
  return options.channels.filter(
    (channel) =>
      channel.prefix === ';' || `${channel.prefix} ` in RADIO_PREFIXES,
  );
}

/** Languages worth offering: picking one only matters if there is more than one. */
export function pickableLanguages(options: SpeechOptions): SpeechOption[] {
  return options.languages.length > 1 ? options.languages : [];
}

/** Pixel height of the picker for the given options. */
export function channelPickerHeight(options: SpeechOptions): number {
  let rows = 0;
  for (const group of [pickableChannels(options), pickableLanguages(options)]) {
    if (group.length) {
      rows += 1 + Math.ceil(group.length / COLUMNS);
    }
  }
  return Math.min(rows, VISIBLE_ROWS) * ROW_HEIGHT + 6;
}

type Props = {
  options: SpeechOptions;
  /** Prefix of the radio channel in use, or null when not on the radio. */
  channel: string | null;
  /** Prefix of the language in use, or null for the default one. */
  language: string | null;
  theme: string;
  light: boolean;
  top: number;
  onPickChannel: (prefix: string) => void;
  onPickLanguage: (option: SpeechOption) => void;
};

/** Radio channels and languages shown under the chat box. */
export function ChannelPicker(props: Props) {
  const {
    options,
    channel,
    language,
    theme,
    light,
    top,
    onPickChannel,
    onPickLanguage,
  } = props;
  const channels = pickableChannels(options);
  const languages = pickableLanguages(options);

  function option(
    key: string,
    label: string,
    selected: boolean,
    onClick: () => void,
  ) {
    return (
      <button
        className={classes([
          'button',
          `button-${theme}`,
          'mood-verb',
          selected && 'mood-verb-selected',
        ])}
        key={key}
        // Keep focus in the text box so typing continues after picking.
        onMouseDown={(event) => event.preventDefault()}
        onClick={onClick}
        type="button"
      >
        {label}
      </button>
    );
  }

  return (
    <div
      className={classes(['mood-picker', light && 'content-lightMode'])}
      style={{ top: `${top}px`, height: `${channelPickerHeight(options)}px` }}
    >
      {channels.length > 0 && <div className="picker-heading">无线电</div>}
      {channels.map((radio) =>
        option(
          `radio${radio.prefix}`,
          radio.name,
          radio.prefix === channel,
          () => onPickChannel(radio.prefix),
        ),
      )}
      {languages.length > 0 && <div className="picker-heading">语言</div>}
      {languages.map((lang) =>
        option(
          `lang${lang.prefix}`,
          lang.name,
          language ? lang.prefix === language : !!lang.selected,
          () => onPickLanguage(lang),
        ),
      )}
    </div>
  );
}
