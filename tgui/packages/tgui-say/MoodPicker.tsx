// THIS IS A NOVA SECTOR UI FILE
import { classes } from 'tgui-core/react';

/** Columns of verbs in the picker. */
const COLUMNS = 3;
/** Height of one row of verbs, in pixels. */
const ROW_HEIGHT = 22;
/** Rows shown at once; the rest scroll. */
const VISIBLE_ROWS = 8;

/** Pixel height of the picker for the given number of verbs. */
export function moodPickerHeight(verbs: string[]): number {
  const rows = Math.min(Math.ceil(verbs.length / COLUMNS), VISIBLE_ROWS);
  return rows * ROW_HEIGHT + 6;
}

/** Returns the custom say verb the message starts with, if it is one of `verbs`. */
export function currentMood(value: string, verbs: string[]): string | null {
  const separator = value.indexOf('*');
  if (separator <= 0) {
    return null;
  }
  const verb = value.slice(0, separator);
  return verbs.includes(verb) ? verb : null;
}

/**
 * Puts `verb` in front of the message as a custom say verb (`verb*message`), replacing the
 * verb picked before. Picking the current verb again removes it.
 */
export function applyMood(value: string, verb: string, verbs: string[]): string {
  const previous = currentMood(value, verbs);
  const message = previous ? value.slice(previous.length + 1) : value;
  return previous === verb ? message : `${verb}*${message}`;
}

type Props = {
  verbs: string[];
  selected: string | null;
  theme: string;
  light: boolean;
  top: number;
  onPick: (verb: string) => void;
};

/** Grid of custom say verbs shown under the chat box. */
export function MoodPicker(props: Props) {
  const { verbs, selected, theme, light, top, onPick } = props;

  return (
    <div
      className={classes(['mood-picker', light && 'content-lightMode'])}
      style={{ top: `${top}px`, height: `${moodPickerHeight(verbs)}px` }}
    >
      {verbs.map((verb) => (
        <button
          className={classes([
            'button',
            `button-${theme}`,
            'mood-verb',
            verb === selected && 'mood-verb-selected',
          ])}
          key={verb}
          // Keep focus in the text box so typing continues after picking.
          onMouseDown={(event) => event.preventDefault()}
          onClick={() => onPick(verb)}
          type="button"
        >
          {verb}
        </button>
      ))}
    </div>
  );
}
