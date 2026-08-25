https://github.com/Skyrat-SS13/Skyrat-tg/pulls

## Title: Admin

MODULE ID: ADMIN

### Description:

Adds multiple admin features, including loud ASAY, rich text controls, explicit runtime TTS controls, and localized station announcement speech.

### TG Proc Changes:

- code\datums\chatmessage.dm > /datum/chatmessage/proc/generate_image
- code\game\say.dm > /atom/movable/proc/compose_message
- code\modules\admin\verbs\adminhelp.dm
- code\modules\admin\verbs\adminpm.dm
- code\modules\admin\admin_verbs.dm
- code\modules\mob\living\emote.dm > /datum/emote/living/custom/run_emote
- code\__HELPERS\tts.dm > /proc/tts_speech_filter
- code\modules\admin\verbs\debug.dm
- code\controllers\subsystem\tts.dm > /datum/controller/subsystem/tts
- code\__HELPERS\priority_announce.dm > /proc/priority_announce, /proc/minor_announce, /proc/level_announce, /proc/dispatch_announcement_to_players
- code\controllers\subsystem\ticker.dm > /datum/controller/subsystem/ticker/proc/setup
- code\game\machinery\announcement_system.dm > /obj/machinery/announcement_system/Initialize
- code\datums\communications.dm > /datum/communciations_controller/proc/make_announcement

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
