## Title: Expressive TTS

MODULE ID: TTS_EXPRESSION

### Description:

Uses the expressive features of qwen-audio TTS models through the SS13 TTS adapter:

- Emotion and nonverbal tags picked from how a line is said: yelling, whispering, last words in crit, and keywords in custom say verbs (`sobs*...`, `低声*...`, `laughs*...`).
- A free-text voice description per character (age, timbre, accent or dialect), sent to the model as a natural-language instruction, plus a speaking rate preference.
- Broadcast-style delivery for station-wide announcements.
- Readable voice labels in the preferences menu, random voices limited to adult voices in the server's language, and migration of voice IDs retired by a model change.
- A mood picker in the chat box that inserts custom say verbs matching those keywords.
- Humanoids perform generic vocal emotes (laugh, sigh, cough, cry, scream...) in their own TTS voice. Species emotes keep their sounds, listeners without speech TTS hear the stock sound, and a character preference turns it off.
- Donor-only custom voices: voice design from a description, or voice cloning from an uploaded recording with a consent statement. Every voice needs admin approval (`审核定制音色`); recordings are deleted after review and cloned voices carry the provider's AIGC watermark. Players open the studio from Voice Settings or the `定制音色` OOC verb.

The extras need the [ss13-tts](https://github.com/sernseek/ss13-tts) server. Every extra is optional: its `/tts-voice-info` endpoint reports what the model supports, and a TTS server without it receives the same requests as before.

### TG Proc Changes:

- code\controllers\subsystem\tts.dm > /datum/controller/subsystem/tts/proc/establish_connection_to_tts, /datum/controller/subsystem/tts/proc/queue_tts_message, /datum/controller/subsystem/tts/proc/random_tts_voice, /datum/controller/subsystem/tts/fire, /datum/tts_request
- code\datums\emotes.dm > /datum/emote/proc/run_emote
- code\game\say.dm > /atom/movable/proc/do_tts_message
- code\modules\tgui_input\say_modal\modal.dm > /datum/tgui_say/proc/load
- code\modules\client\preferences\middleware\tts.dm > /datum/preference_middleware/tts/proc/play_voice, /datum/preference_middleware/tts/proc/play_voice_robot
- code\__HELPERS\tts.dm > /proc/tts_queue_global_announcement

### Defines:

- code\__DEFINES\~nova_defines\tts_expression.dm

### Master file additions

- modular_nova\master_files\code\modules\client\preferences\voice.dm > voice labels and retired voice migration
- modular_nova\master_files\code\modules\client\preferences\middleware\tts.dm > `open_voice_studio` action

### Included files that are not contained in this module:

- code\modules\unit_tests\~nova\tts_controls.dm > /datum/unit_test/tts_expression
- modular_nova\modules\voice_actor_quirk\code\voice_actor_preferences.dm > voice labels and retired voice migration
- tgui\packages\tgui\interfaces\PreferencesMenu\preferences\features\character_preferences\nova\character_voice.tsx
- tgui\packages\tgui\interfaces\PreferencesMenu\CharacterPreferences\vocals.tsx
- tgui\packages\tgui\interfaces\TtsVoiceStudio.tsx
- tgui\packages\tgui\interfaces\TtsVoiceReview.tsx
- tgui\packages\tgui-say\MoodPicker.tsx, tgui\packages\tgui-say\TguiSay.tsx, tgui\packages\tgui-say\styles\styles.scss

### Credits:

sernseek
