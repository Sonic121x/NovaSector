https://github.com/Skyrat-SS13/Skyrat-tg/pulls

## Title: Admin

MODULE ID: ADMIN

### Description:

Adds multiple admin features, including loud ASAY, rich text controls, and a runtime TTS switch.

### TG Proc Changes:

- code\datums\chatmessage.dm > /datum/chatmessage/proc/generate_image
- code\game\say.dm > /atom/movable/proc/compose_message
- code\modules\admin\verbs\adminhelp.dm
- code\modules\admin\verbs\adminpm.dm
- code\modules\admin\admin_verbs.dm
- code\modules\mob\living\emote.dm > /datum/emote/living/custom/run_emote
- code\__HELPERS\tts.dm > /proc/tts_speech_filter
- code\modules\admin\verbs\debug.dm
- code\controllers\subsystem\tts.dm > /datum/controller/subsystem/tts/proc/queue_tts_message

### Defines:

- N/A

### Master file additions

- N/A

### Included files that are not contained in this module:

- code\modules\unit_tests\~nova\tts_controls.dm

### Credits:

Gandalf2k15 - Porting and Refactoring
Akrilla - OG code
Floofies - Preferences loadverb and admin stasis
