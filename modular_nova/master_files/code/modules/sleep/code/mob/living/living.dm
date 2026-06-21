///Replaces proc definition in [code\modules\mob\living\living.dm]
/mob/living/proc/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(IsSleeping())
		to_chat(src, span_warning("你已经睡着了！"))
		return
	var/duration = tgui_input_number(
		src,
		"你想睡多少分钟？输入0表示无限期睡眠。抵抗以醒来。",
		"睡眠：持续时间",
		max_value = 300,
		min_value = 0,
		default = 1
	)
	if(isnull(duration))
		return
	if(duration == 0)
		duration = STATUS_EFFECT_PERMANENT
	else
		duration = duration MINUTES
	Sleeping(duration, is_voluntary = TRUE)
