/datum/round_event_control/random_ship_event
	name = "随机飞船事件"
	typepath = /datum/round_event/random_ship_event
	weight = 10
	max_occurrences = 1
	min_players = 15
	category = EVENT_CATEGORY_SPACE
	description = "一艘随机飞船将尝试联系空间站，意图不明。"
	admin_setup = list(/datum/event_admin_setup/listed_options/random_ship)
	map_flags = EVENT_SPACE_ONLY

/datum/round_event_control/random_ship_event/preRunEvent()
	if (SSmapping.is_planetary())
		return EVENT_CANT_RUN
	return ..()
