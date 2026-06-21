/area/awaymission/caves/maintsroom
	name = "维护室"
	icon_state = "away2"
	requires_power = FALSE
	static_lighting = TRUE
	area_flags = NOTELEPORT
	area_flags_mapping = NONE

/area/awaymission/caves/maintsroom/deeper
	name = "深层"
	icon_state = "away3"

/obj/machinery/door/puzzle/keycard/crowlie_keycard
	name = "ID锁定气闸门"
	desc = "看起来需要一张门禁卡。"
	puzzle_id = "crowlie"

/obj/item/keycard/crowlie
	name = "门禁卡"
	desc = "一张门禁卡。真不错。看起来属于某个ID锁定的气闸门。"
	color = "#455357"
	puzzle_id = "crowlie"

/obj/machinery/door/puzzle/keycard/chamenos_keycard
	name = "门禁卡锁定气闸门"
	desc = "看起来它需要一张门禁卡。"
	puzzle_id = "chamenos"

/obj/item/keycard/chamenos
	name = "门禁卡"
	desc = "一张门禁卡。真棒。看起来它属于一个ID锁定的气闸门。"
	color = "#09bbec"
	puzzle_id = "chamenos"
