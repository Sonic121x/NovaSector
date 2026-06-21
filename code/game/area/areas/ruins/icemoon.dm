// Icemoon Ruins

/area/ruin/powered/lizard_gas
	name = "\improper 蜥蜴加油站"

/area/ruin/unpowered/buried_library
	name = "\improper 埋藏图书馆"

/area/ruin/powered/bathhouse
	name = "\improper 澡堂"
	mood_bonus = 10
	mood_message = "I wish I could stay here forever."

/turf/closed/wall/bathhouse
	desc = "触感凉爽，令人愉悦。"
	icon = 'icons/turf/shuttleold.dmi'
	icon_state = "block"
	base_icon_state = "block"
	smoothing_flags = NONE
	canSmoothWith = null
	rust_resistance = RUST_RESISTANCE_BASIC

/area/ruin/powered/mailroom
	name = "\improper 废弃邮局"

/area/ruin/comms_agent
	name = "\improper 监听站"
	sound_environment = SOUND_ENVIRONMENT_CITY

/area/ruin/comms_agent/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/block_area_power_fail)

/area/ruin/comms_agent/maint
	name = "\improper 监听站维护区"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/ruin/plasma_facility/commons
	name = "\improper 废弃等离子设施公共区"
	sound_environment = SOUND_AREA_STANDARD_STATION
	mood_bonus = -5
	mood_message = "I feel like I am being watched..."

/area/ruin/plasma_facility/operations
	name = "\improper 废弃等离子设施操作区"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	mood_bonus = -5
	mood_message = "I feel like I am being watched..."

/area/ruin/bughabitat
	name = "\improper 昆虫学推广中心"
	mood_bonus = 1
	mood_message = "This place seems strangely serene."

/area/ruin/pizzeria
	name = "\improper 莫夫奇披萨店"

/area/ruin/pizzeria/kitchen
	name = "\improper 莫夫奇厨房"

/area/ruin/syndibiodome
	name = "\improper 辛迪加生物穹顶"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience_index = AMBIENCE_DANGER
	area_flags = NOTELEPORT
	area_flags_mapping = NONE
	mood_bonus = -10
	mood_message = "What the fuck."

/area/ruin/planetengi
	name = "\improper 工程前哨站"

/area/ruin/huntinglodge
	name = "\improper 狩猎小屋"
	mood_bonus = -5
	mood_message = "Something feels off..."

/area/ruin/smoking_room/house
	name = "\improper 烟草屋"
	sound_environment = SOUND_ENVIRONMENT_CITY
	mood_bonus = -1
	mood_message = "Good lord, this place REEKS of cigarettes."

/area/ruin/smoking_room/room
	name = "\improper 吸烟室"
	sound_environment = SOUND_ENVIRONMENT_DIZZY
	mood_bonus = -8
	mood_message = "I can feel my lifespan shortening with every breath."

/area/ruin/powered/icemoon_phone_booth
	name = "\improper 电话亭"

/area/ruin/powered/hermit
	name = "\improper 隐士小屋"

/area/ruin/syndielab
	name = "\improper 辛迪加实验室"
	ambience_index = AMBIENCE_DANGER
	sound_environment = SOUND_ENVIRONMENT_CAVE

/area/ruin/outpost31
	name = "\improper 31号前哨站"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	mood_bonus = -10
	mood_message = "Something very bad happened here..."

/area/ruin/outpost31/medical
	name = "\improper 31号前哨站医疗室"

/area/ruin/outpost31/kitchendiningroom
	name = "\improper 31号前哨站厨房-餐厅"

/area/ruin/outpost31/kennel
	name = "\improper 31号前哨站犬舍"

/area/ruin/outpost31/radiomap
	name = "\improper 31号前哨站无线电地图室"

/area/ruin/outpost31/lab
	name = "\improper 31号前哨站实验室"
	area_flags = NOTELEPORT //megafauna arena
	area_flags_mapping = NONE
	requires_power = FALSE

/area/ruin/outpost31/lootroom
	name = "\improper 31号前哨站次级储藏室"
	area_flags = NOTELEPORT //megafauna loot room
	area_flags_mapping = NONE
	requires_power = FALSE

/area/ruin/outpost31/recroom
	name = "\improper 31号前哨站娱乐室"

/area/ruin/outpost31/crewquarters
	name = "\improper 31号前哨站睡眠区"

/area/ruin/outpost31/commander_room
	name = "\improper 31号前哨站站长办公室"
