///Replaces proc definition in [code\modules\mob\living\living.dm]
GAME_VERB_PROC(/mob/living, mob_sleep, "睡眠", "IC")

	if(IsSleeping())
		to_chat(src, span_warning(LANG("mob.bd5702d4e6b7d6d4", null)))
		return
	var/duration = tgui_input_number(
		src,
		LANG("mob.4a484e5073095084", null),
		LANG("mob.2d9c4faa3b4edfc7", null),
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
