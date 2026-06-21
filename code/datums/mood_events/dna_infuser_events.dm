/datum/mood_event/it_was_on_the_mouse
	description = "嘿嘿。\"它在鼠标上\"。真是玩了个文字游戏。"
	mood_change = 1
	timeout = 2 MINUTES
	event_flags = MOOD_EVENT_WHIMSY

/datum/mood_event/gondola_serenity
	description = "现在你脑子里可能有很多事。但这种满足感，一种只想坐下来观察的普遍呼唤，正席卷着你……"
	mood_change = 10
	special_screen_obj = "mood_gondola"

/datum/mood_event/fish_waterless
	mood_change = -3
	description = "干着真难受。我感觉像条离水的鱼。"

/datum/mood_event/fish_water
	mood_change = 1
	description = "咕噜咕噜！"
