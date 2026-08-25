// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/silicon/robot/try_speak(message, ignore_spam = FALSE, forced = null, filterproof = FALSE)
	// Cyborgs cannot speak if silent borg is on.
	// Unless forced is set, as that's probably stating laws or something.
	if(!forced && CONFIG_GET(flag/silent_borg))
		to_chat(src, span_danger(LANG("mob.0d94e9e8c3dacd95", null)))
		return FALSE

	return ..()
