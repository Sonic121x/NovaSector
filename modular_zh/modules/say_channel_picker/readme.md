## Say box channel and language picker

Module ID: SAY_CHANNEL_PICKER

### Description:

Radio channels and languages are chosen in the say box with typed prefixes (`;`, `:e`, `.e`, `,x`). With a Chinese input method on, the punctuation turns full-width (`；` `：` `。` `，`) and the letter after it starts a pinyin composition, so every radio message means switching the input method off and on again.

The say box gets a 「频」 button next to the mood button. It opens a list of the radio channels the speaker's radio actually has (common first, binary for silicons and binary keys) and, when the speaker knows more than one, the languages they can speak. Picking a channel works like typing its prefix: the channel button changes and the message is sent with that prefix. Picking a language puts `,x` in front of every message sent on Say, Radio or Whisper until another language (or the default one) is picked; the button is highlighted while a non-default language is in use, and the language name shows on hover.

The say box still sends the ordinary prefixes, so speech parsing on the server is unchanged.

- When the say box opens, the server answers its `open` message with `speechOptions`: `channels` and `languages`, each a list of `{prefix, name}`, languages also carrying `selected` for the one spoken without a prefix.
- The radio is the one prefixes talk into: `ears` for humans, `radio` for silicons. Other mobs get no channels.
- Channels without a say box theme (`RADIO_PREFIXES`) are not offered, since the channel button could not show them.
- Channel names (`Common`, `Science`, ...) are identifiers compared in English everywhere, and several have two competing translations in the catalog, so their labels and the missing language names live in the scoped table `strings/i18n/say_picker_labels.json`. Anything not in it falls back to `lang_reverse_text`, then to the English name.

### TG Proc/File Changes:

- N/A

### Modular Overrides:

- `modular_zh/modules/say_channel_picker/code/say_channel_picker.dm`: `/datum/tgui_say/open()` (calls parent)

### Defines:

- N/A

### Included files that are not contained in this module:

- `tgui/packages/tgui-say/ChannelPicker.tsx`
- `tgui/packages/tgui-say/TguiSay.tsx` (`ZH EDIT` markers)
- `tgui/packages/tgui-say/styles/styles.scss` (`ZH EDIT` markers)
- `strings/i18n/say_picker_labels.json`, registered in `strings/i18n/catalog-domains.json`

### Credits:

sernseek
