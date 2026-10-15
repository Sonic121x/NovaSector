## Input method friendly controls

Module ID: IME_KEYBOARD

### Description:

With a Chinese, Japanese or Korean input method switched on, keystrokes are consumed by the input method before DreamSeeker's key macros see them: pressing WASD opens a candidate window instead of moving, and every hotkey stops working.

The native map control's input method cannot be changed from the server, but the browser controls sent to the client can. This module places a 1x1 WebView2 control (`mapwindow.ime_capture`) in the map window and keeps keyboard focus on a non-editable element inside it. Chromium disables the input method for its window while a non-editable element has focus, so keys arrive unmodified.

- The page forwards each key exactly like the native `Any` macro does: `KeyDown "W" [[map.mouse-pos]] [[map.size]]`. The embedded wingets are expanded by the client, so keybindings get the same mouse position as with native macros. The page uses `KeyboardEvent.code` (physical key), falling back to `keyCode`.
- Native macros never fire while a browser control has focus, so the client-side part of the other macros (Escape menu, Tab to chat, Back to clear input, the admin asay key) is injected into the page and run before the forwarded `KeyDown`.
- When the map takes focus back (clicking the map, closing the say box or a popup), the page reclaims it locally with `winget`/`winset`, without a server round trip. Editable inputs (chat bar, say box, TGUI text fields) are never reclaimed, so typing with the input method works as usual.

The feature is a game preference (`ime_keyboard`, default on). Turning it off removes the control and returns focus to the map.

Verified on Windows 11 with Microsoft Pinyin and BYOND 516.1688: movement and hotkeys, Escape/Tab macros, typing Chinese in the chat bar and say box, focus reclaim 50ms after a map click, and no foreground stealing when another application is active.

### TG Proc/File Changes:

- N/A

### Modular Overrides:

- N/A

### Defines:

- N/A

### Included files that are not contained in this module:

- `tgui/packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/nova/ime_keyboard.tsx`

### Credits:

sernseek
