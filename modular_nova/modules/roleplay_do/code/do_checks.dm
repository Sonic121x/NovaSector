/mob/living/proc/doverb_checks(message)
	if(!length(message))
		return FALSE

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger(LANG("mob.b79ad8a388d1b3a4", null)))
		return FALSE

	//quickly calc our name stub again: duplicate this in say.dm override
	var/name_stub = " (<b>[usr]</b>)"
	if(length(message) > (MAX_MESSAGE_LEN - length(name_stub)))
		to_chat(usr, message)
		to_chat(usr, span_warning(LANG("mob.60a2534a2c429dc8", list(MAX_MESSAGE_LEN))))
		return FALSE

	if(IS_UNCONSCIOUS_OR_CRIT(usr))
		to_chat(usr, span_notice(LANG("mob.c44da1e5212346c5", null)))
		return FALSE

	return TRUE
