// Nova Sector CC area defines

/*
 * Ghost Cafe
 */

/area/centcom/holding
	name = "拘留设施"
	area_flags = parent_type::area_flags | UNLIMITED_FISHING | NO_DEATH_MESSAGE
	mood_bonus = 25
	mood_message = "I am taking a well deserved rest!"

/area/centcom/holding/cafe
	name = "幽灵咖啡馆"

/area/centcom/holding/cafevox
	name = "咖啡馆语音盒"

/area/centcom/holding/cafedorms
	name = "幽灵咖啡馆宿舍"

/area/centcom/holding/cafepark
	name = "幽灵咖啡馆户外区"

/area/centcom/interlink
	name = "互联枢纽"

/area/centcom/interlink/dorm_rooms
	name = "互联枢纽宿舍房间"
	mood_bonus = /area/centcom/holding::mood_bonus
	mood_message = /area/centcom/holding::mood_message

/area/centcom/interlink/dorm_rooms/room1
	name = "互联枢纽舱室 1"

/area/centcom/interlink/dorm_rooms/room2
	name = "互联枢纽舱室 2"

/area/centcom/interlink/dorm_rooms/room3
	name = "互联枢纽舱室 3"

/area/centcom/interlink/dorm_rooms/room4
	name = "互联枢纽舱室 4"

/area/centcom/interlink/dorm_rooms/room5
	name = "互联枢纽舱室 5"

// UN-LIMITED WATERRRRRRR
/obj/machinery/shower/infinite/process(seconds_per_tick)
	. = ..()
	if(actually_on)
		reagents.add_reagent(reagent_id, reagents.maximum_volume - reagents.total_volume)

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/shower/infinite, (-16))
