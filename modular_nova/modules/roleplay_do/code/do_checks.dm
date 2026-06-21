/mob/living/proc/doverb_checks(message)
	if(!length(message))
		return FALSE

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("发言当前已被管理员禁用。"))
		return FALSE

	//quickly calc our name stub again: duplicate this in say.dm override
	var/name_stub = " (<b>[usr]</b>)"
	if(length(message) > (MAX_MESSAGE_LEN - length(name_stub)))
		to_chat(usr, message)
		to_chat(usr, span_warning("^^^----- 上一条消息因超过最大长度 [MAX_MESSAGE_LEN] 已被丢弃。它并未发送！ -----^^^"))
		return FALSE

	if(usr.stat != CONSCIOUS)
		to_chat(usr, span_notice("你无法在当前状态下发送Do动作。"))
		return FALSE

	return TRUE
