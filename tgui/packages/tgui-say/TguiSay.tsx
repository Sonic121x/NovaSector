import './styles/main.scss';

import { useEffect, useRef, useState } from 'react';
import { dragStartHandler } from 'tgui/drag';
import { isEscape, KEY } from 'tgui-core/keys';
import { type BooleanLike, classes } from 'tgui-core/react';

import { type Channel, ChannelIterator } from './ChannelIterator';
// ZH EDIT ADDITION - SAY_CHANNEL_PICKER
import {
  ChannelPicker,
  channelPickerHeight,
  pickableChannels,
  pickableLanguages,
  type SpeechOption,
  type SpeechOptions,
} from './ChannelPicker';
import { ChatHistory } from './ChatHistory';
import { LineLength, RADIO_PREFIXES, WindowSize } from './constants';
import { getPrefix, windowClose, windowOpen, windowSet } from './helpers';
import { byondMessages } from './timers';
// ZH EDIT ADDITION START - TTS_EXPRESSION - Mood picker.
import {
  applyMood,
  currentMood,
  MoodPicker,
  moodPickerHeight,
} from './MoodPicker';

/** Channels whose messages accept a custom say verb. */
const MOOD_CHANNELS = ['Say', 'Radio', 'Whis'];
// ZH EDIT ADDITION END

type ByondOpen = {
  channel: Channel;
};

type ByondProps = {
  maxLength: number;
  lightMode: BooleanLike;
  scale: BooleanLike;
  moodVerbs?: string[]; // ZH EDIT ADDITION - TTS_EXPRESSION
};

export function TguiSay() {
  const innerRef = useRef<HTMLTextAreaElement>(null);
  const channelIterator = useRef(new ChannelIterator());
  const chatHistory = useRef(new ChatHistory());
  const messages = useRef(byondMessages);
  const scale = useRef(true);
  const currentPrefix = useRef<keyof typeof RADIO_PREFIXES | null>(null);

  // I initially wanted to make these an object or a reducer, but it's not really worth it.
  // You lose the granulatity and add a lot of boilerplate.
  const [buttonContent, setButtonContent] = useState('');
  const [lightMode, setLightMode] = useState(false);
  const [maxLength, setMaxLength] = useState(1024);
  const [size, setSize] = useState(WindowSize.Small);
  const [value, setValue] = useState('');
  // ZH EDIT ADDITION START - TTS_EXPRESSION
  const [moodVerbs, setMoodVerbs] = useState<string[]>([]);
  const [moodOpen, setMoodOpen] = useState(false);
  // ZH EDIT ADDITION END
  // ZH EDIT ADDITION START - SAY_CHANNEL_PICKER
  const [speechOptions, setSpeechOptions] = useState<SpeechOptions>({
    channels: [],
    languages: [],
  });
  const [channelOpen, setChannelOpen] = useState(false);
  const [language, setLanguageState] = useState<string | null>(null);
  // Read by handlers subscribed once on mount, which would see a stale state value.
  const languageRef = useRef<string | null>(null);
  const pickerOpen = moodOpen || channelOpen;
  const moodExtra =
    (moodOpen && moodPickerHeight(moodVerbs)) ||
    (channelOpen && channelPickerHeight(speechOptions)) ||
    0;
  // ZH EDIT ADDITION END

  const position = useRef([window.screenX, window.screenY]);
  const isDragging = useRef(false);

  function setCurrentPrefix(prefix: keyof typeof RADIO_PREFIXES | null): void {
    currentPrefix.current = prefix;
  }

  function handleArrowKeys(direction: KEY.Up | KEY.Down): void {
    const chat = chatHistory.current;
    const iterator = channelIterator.current;

    if (direction === KEY.Up) {
      if (chat.isAtLatest() && value) {
        // Save current message to temp history if at the most recent message
        chat.saveTemp(value);
      }
      // Try to get the previous message, fall back to the current value if none
      const prevMessage = chat.getOlderMessage();

      if (prevMessage) {
        setButtonContent(chat.getIndex().toString());
        setValue(prevMessage);
      }
    } else {
      const nextMessage = chat.getNewerMessage() || chat.getTemp() || '';

      const newContent = chat.isAtLatest()
        ? iterator.current()
        : chat.getIndex().toString();

      setButtonContent(newContent);
      setValue(nextMessage);
    }
  }

  function handleBackspaceDelete(): void {
    const chat = chatHistory.current;
    const iterator = channelIterator.current;

    // User is on a chat history message
    if (!chat.isAtLatest()) {
      chat.reset();
      setButtonContent(currentPrefix.current ?? iterator.current());

      // Empty input, resets the channel
    } else if (
      currentPrefix.current &&
      iterator.isSay() &&
      value?.length === 0
    ) {
      setCurrentPrefix(null);
      setButtonContent(iterator.current());
    }
  }

  function handleButtonClick(event: React.MouseEvent<HTMLButtonElement>): void {
    isDragging.current = true;

    setTimeout(() => {
      // So the button doesn't jump around accidentally
      if (isDragging.current) {
        dragStartHandler(event.nativeEvent);
      }
    }, 50);
  }

  // Prevents the button from changing channels if it's dragged
  function handleButtonRelease(): void {
    isDragging.current = false;
    const currentPosition = [window.screenX, window.screenY];

    if (JSON.stringify(position.current) !== JSON.stringify(currentPosition)) {
      position.current = currentPosition;
      return;
    }

    handleIncrementChannel();
  }

  function handleClose(): void {
    setMoodOpen(false); // ZH EDIT ADDITION - TTS_EXPRESSION
    setChannelOpen(false); // ZH EDIT ADDITION - SAY_CHANNEL_PICKER
    innerRef.current?.blur();
    windowClose(scale.current);

    setTimeout(() => {
      chatHistory.current.reset();
      channelIterator.current.reset();
      unloadChat();
    }, 25);
  }

  function handleEnter(): void {
    const iterator = channelIterator.current;
    const prefix = currentPrefix.current ?? '';

    if (value?.length && value.length < maxLength) {
      chatHistory.current.add(value);
      Byond.sendMessage('entry', {
        channel: iterator.current(),
        entry: withLanguage(iterator.isSay() ? prefix + value : value), // ZH EDIT CHANGE - SAY_CHANNEL_PICKER - ORIGINAL: entry: iterator.isSay() ? prefix + value : value,
      });
    }

    handleClose();
  }

  function handleForceSay(): void {
    const iterator = channelIterator.current;
    const currentValue = innerRef.current?.value;

    // Only force say if we're on a visible channel and have typed something
    if (!currentValue || !iterator.isVisible()) return;

    const prefix = currentPrefix.current ?? '';
    const grunt = withLanguage(
      iterator.isSay() ? prefix + currentValue : currentValue,
    ); // ZH EDIT CHANGE - SAY_CHANNEL_PICKER - ORIGINAL: const grunt = iterator.isSay() ? prefix + currentValue : currentValue;

    messages.current.forceSayMsg(grunt, iterator.current());
    handleClose();
  }

  function handleSaveText(): void {
    const iterator = channelIterator.current;
    const currentValue = innerRef.current?.value;

    if (!currentValue || !iterator.isVisible()) return;

    messages.current.saveText(currentValue, iterator.current());
  }

  function handleIncrementChannel(): void {
    const iterator = channelIterator.current;

    iterator.next();
    setButtonContent(iterator.current());
    setCurrentPrefix(null);
    // ZH EDIT ADDITION START - SAY_CHANNEL_PICKER - The pickers' buttons hide on channels
    // like Me; an open picker would keep the window tall with nothing in it.
    setMoodOpen(false);
    setChannelOpen(false);
    // ZH EDIT ADDITION END
    messages.current.channelIncrementMsg(iterator.isVisible());
  }

  function handleInput(event: React.FormEvent<HTMLTextAreaElement>): void {
    const iterator = channelIterator.current;
    let newValue = event.currentTarget.value;

    const newPrefix = getPrefix(newValue) || currentPrefix.current;
    // Handles switching prefixes
    if (newPrefix && newPrefix !== currentPrefix.current) {
      setButtonContent(RADIO_PREFIXES[newPrefix]);
      setCurrentPrefix(newPrefix);
      newValue = newValue.slice(3);
      iterator.set('Say');

      if (newPrefix === ':b ') {
        Byond.sendMessage('thinking', { visible: false });
      }
    }

    // Handles typing indicators
    if (channelIterator.current.isVisible() && newPrefix !== ':b ') {
      messages.current.typingMsg();
      messages.current.saveText(newValue, iterator.current());
    }

    setValue(newValue);
  }

  function handleKeyDown(
    event: React.KeyboardEvent<HTMLTextAreaElement>,
  ): void {
    if (event.getModifierState('AltGraph')) return;

    switch (event.key) {
      case KEY.Up:
      case KEY.Down:
        event.preventDefault();
        handleArrowKeys(event.key);
        break;

      case KEY.Delete:
      case KEY.Backspace:
        handleBackspaceDelete();
        break;

      case KEY.Enter:
        event.preventDefault();
        handleEnter();
        break;

      case KEY.Tab:
        event.preventDefault();
        handleIncrementChannel();
        break;

      default:
        if (isEscape(event.key)) {
          handleClose();
        }
    }
  }

  function handleOpen(data: ByondOpen): void {
    channelIterator.current.set(data.channel);

    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.current());

    windowOpen(channelIterator.current.current(), scale.current);

    innerRef.current?.focus();
  }

  function handleProps(data: ByondProps): void {
    setMaxLength(data.maxLength);
    setLightMode(!!data.lightMode);
    scale.current = !!data.scale;
    setMoodVerbs(data.moodVerbs || []); // ZH EDIT ADDITION - TTS_EXPRESSION
  }

  // ZH EDIT ADDITION START - SAY_CHANNEL_PICKER
  function setLanguage(prefix: string | null): void {
    languageRef.current = prefix;
    setLanguageState(prefix);
  }

  /** Puts the picked language's prefix in front of a message sent on a speech channel. */
  function withLanguage(entry: string): string {
    const prefix = languageRef.current;
    if (!prefix || !MOOD_CHANNELS.includes(channelIterator.current.current())) {
      return entry;
    }
    return `${prefix} ${entry}`;
  }

  /** Prefix of the radio channel in use (`;` for common), or null when not on the radio. */
  function currentRadio(): string | null {
    if (channelIterator.current.current() === 'Radio') {
      return ';';
    }
    return currentPrefix.current?.trim() || null;
  }

  function handleSpeechOptions(data: SpeechOptions): void {
    setSpeechOptions(data);
    const picked = languageRef.current;
    if (picked && !data.languages.some((lang) => lang.prefix === picked)) {
      setLanguage(null);
    }
  }

  function handlePickChannel(prefix: string): void {
    const iterator = channelIterator.current;
    const key = `${prefix} ` as keyof typeof RADIO_PREFIXES;

    if (prefix === currentRadio()) {
      iterator.set('Say');
      setCurrentPrefix(null);
      setButtonContent(iterator.current());
    } else if (prefix === ';') {
      iterator.set('Radio');
      setCurrentPrefix(null);
      setButtonContent(iterator.current());
    } else {
      iterator.set('Say');
      setCurrentPrefix(key);
      setButtonContent(RADIO_PREFIXES[key]);
      if (key === ':b ') {
        Byond.sendMessage('thinking', { visible: false });
      }
    }
    setChannelOpen(false);
    innerRef.current?.focus();
  }

  function handlePickLanguage(option: SpeechOption): void {
    const isCurrent = languageRef.current
      ? option.prefix === languageRef.current
      : !!option.selected;
    setLanguage(isCurrent || option.selected ? null : option.prefix);
    setChannelOpen(false);
    innerRef.current?.focus();
  }
  // ZH EDIT ADDITION END

  // ZH EDIT ADDITION START - TTS_EXPRESSION
  function handleMoodPick(verb: string): void {
    setValue(applyMood(value, verb, moodVerbs));
    setMoodOpen(false);
    innerRef.current?.focus();
  }
  // ZH EDIT ADDITION END

  function unloadChat(): void {
    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.current());
    setValue('');
  }

  /** Subscribe to Byond messages */
  useEffect(() => {
    Byond.subscribeTo('props', handleProps);
    Byond.subscribeTo('force', handleForceSay);
    Byond.subscribeTo('open', handleOpen);
    Byond.subscribeTo('save', handleSaveText);
    Byond.subscribeTo('close', handleClose);
    Byond.subscribeTo('speechOptions', handleSpeechOptions); // ZH EDIT ADDITION - SAY_CHANNEL_PICKER
  }, []);

  /** Value has changed, we need to check if the size of the window is ok */
  useEffect(() => {
    const len = value?.length || 0;

    let newSize: WindowSize;
    if (len > LineLength.Medium) {
      newSize = WindowSize.Large;
    } else if (len <= LineLength.Medium && len > LineLength.Small) {
      newSize = WindowSize.Medium;
    } else {
      newSize = WindowSize.Small;
    }

    if (size !== newSize) {
      windowSet(newSize + moodExtra, scale.current); // ZH EDIT CHANGE - TTS_EXPRESSION - ORIGINAL: windowSet(newSize, scale.current);
      setSize(newSize);
    }
  }, [value]);

  // ZH EDIT ADDITION START - TTS_EXPRESSION - Make room for the mood picker.
  useEffect(() => {
    windowSet(size + moodExtra, scale.current);
  }, [moodOpen, channelOpen]); // ZH EDIT CHANGE - SAY_CHANNEL_PICKER - ORIGINAL: }, [moodOpen]);
  // ZH EDIT ADDITION END

  const theme =
    (lightMode && 'lightMode') ||
    (currentPrefix.current && RADIO_PREFIXES[currentPrefix.current]) ||
    channelIterator.current.current();

  // ZH EDIT ADDITION START - TTS_EXPRESSION
  const showMood =
    moodVerbs.length > 0 &&
    MOOD_CHANNELS.includes(channelIterator.current.current());
  // ZH EDIT ADDITION END
  // ZH EDIT ADDITION START - SAY_CHANNEL_PICKER
  const showChannel =
    (pickableChannels(speechOptions).length > 0 ||
      pickableLanguages(speechOptions).length > 0) &&
    MOOD_CHANNELS.includes(channelIterator.current.current());
  const languageName = speechOptions.languages.find(
    (lang) => lang.prefix === language,
  )?.name;
  // ZH EDIT ADDITION END

  return (
    <>
      <div
        className={`window window-${theme} window-${size}`}
        onMouseDown={dragStartHandler}
        style={pickerOpen ? { height: `${size + moodExtra}px` } : undefined} // ZH EDIT ADDITION - TTS_EXPRESSION, SAY_CHANNEL_PICKER
      >
        {!lightMode && <div className={`shine shine-${theme}`} />}
      </div>
      <div
        className={classes([
          'content',
          lightMode && 'content-lightMode',
          showMood !== showChannel && 'content-mood', // ZH EDIT ADDITION - TTS_EXPRESSION, SAY_CHANNEL_PICKER
          showMood && showChannel && 'content-mood-2', // ZH EDIT ADDITION - SAY_CHANNEL_PICKER
        ])}
        style={{
          zoom: scale.current ? '' : `${100 / window.devicePixelRatio}%`,
          // ZH EDIT ADDITION START - TTS_EXPRESSION
          ...(pickerOpen && { bottom: 'auto', height: `${size - 4}px` }),
          // ZH EDIT ADDITION END
        }}
      >
        <button
          className={`button button-${theme}`}
          onMouseDown={handleButtonClick}
          onMouseUp={handleButtonRelease}
          type="button"
        >
          {buttonContent}
        </button>
        <textarea
          autoCorrect="off"
          className={classes([
            'textarea',
            `textarea-${theme}`,
            value.length > LineLength.Large && 'textarea-large',
          ])}
          maxLength={maxLength}
          onInput={handleInput}
          onKeyDown={handleKeyDown}
          ref={innerRef}
          spellCheck={false}
          value={value}
        />
        {/* ZH EDIT ADDITION START - TTS_EXPRESSION */}
        {showMood && (
          <button
            className={classes([
              'button',
              `button-${theme}`,
              currentMood(value, moodVerbs) && 'mood-verb-selected',
            ])}
            onMouseDown={(event) => event.preventDefault()}
            onClick={() => {
              setMoodOpen(!moodOpen);
              setChannelOpen(false); // ZH EDIT ADDITION - SAY_CHANNEL_PICKER
            }}
            title={currentMood(value, moodVerbs) || undefined}
            type="button"
          >
            情
          </button>
        )}
        {/* ZH EDIT ADDITION END */}
        {/* ZH EDIT ADDITION START - SAY_CHANNEL_PICKER */}
        {showChannel && (
          <button
            className={classes([
              'button',
              `button-${theme}`,
              !!language && 'mood-verb-selected',
            ])}
            onMouseDown={(event) => event.preventDefault()}
            onClick={() => {
              setChannelOpen(!channelOpen);
              setMoodOpen(false);
            }}
            title={languageName || '选择无线电频道或语言'}
            type="button"
          >
            频
          </button>
        )}
        {/* ZH EDIT ADDITION END */}
      </div>
      {/* ZH EDIT ADDITION START - TTS_EXPRESSION */}
      {moodOpen && showMood && (
        <MoodPicker
          verbs={moodVerbs}
          selected={currentMood(value, moodVerbs)}
          theme={theme}
          light={lightMode}
          top={size}
          onPick={handleMoodPick}
        />
      )}
      {/* ZH EDIT ADDITION END */}
      {/* ZH EDIT ADDITION START - SAY_CHANNEL_PICKER */}
      {channelOpen && showChannel && (
        <ChannelPicker
          options={speechOptions}
          channel={currentRadio()}
          language={language}
          theme={theme}
          light={lightMode}
          top={size}
          onPickChannel={handlePickChannel}
          onPickLanguage={handlePickLanguage}
        />
      )}
      {/* ZH EDIT ADDITION END */}
    </>
  );
}
