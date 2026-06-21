/area/station/hallway
	icon_state = "hall"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/hallway/primary
	name = "\improper 主走廊"
	icon_state = "primaryhall"

/area/station/hallway/primary/aft
	name = "\improper 后部主走廊"
	icon_state = "afthall"

/area/station/hallway/primary/fore
	name = "\improper 前部主走廊"
	icon_state = "forehall"

/area/station/hallway/primary/starboard
	name = "\improper 右舷主走廊"
	icon_state = "starboardhall"

/area/station/hallway/primary/port
	name = "\improper 左舷主走廊"
	icon_state = "porthall"

/area/station/hallway/primary/central
	name = "\improper 中央主走廊"
	icon_state = "centralhall"

/area/station/hallway/primary/central/fore
	name = "\improper 前部中央主走廊"
	icon_state = "hallCF"

/area/station/hallway/primary/central/aft
	name = "\improper 后部中央主走廊"
	icon_state = "hallCA"

/area/station/hallway/primary/upper
	name = "\improper 上层中央主走廊"
	icon_state = "centralhall"

/area/station/hallway/primary/tram
	name = "\improper 主电车轨道"

/area/station/hallway/primary/tram/left
	name = "\improper 左舷电车站台"
	icon_state = "halltramL"

/area/station/hallway/primary/tram/center
	name = "\improper 中央电车站台"
	icon_state = "halltramM"

/area/station/hallway/primary/tram/right
	name = "\improper 右舷电车站台"
	icon_state = "halltramR"

// This shouldn't be used, but it gives an icon for the enviornment tree in the map editor
/area/station/hallway/secondary
	icon_state = "secondaryhall"

/area/station/hallway/secondary/command
	name = "\improper 指挥走廊"
	icon_state = "bridge_hallway"

/area/station/hallway/secondary/construction
	name = "\improper 施工区域"
	icon_state = "construction"

/area/station/hallway/secondary/construction/engineering
	name = "\improper 工程走廊"

/area/station/hallway/secondary/exit
	name = "\improper 逃生舱走廊"
	icon_state = "escape"

/area/station/hallway/secondary/exit/escape_pod
	name = "\improper 逃生舱舱段"
	icon_state = "escape_pods"

/area/station/hallway/secondary/exit/departure_lounge
	name = "\improper 离站休息室"
	icon_state = "escape_lounge"

/area/station/hallway/secondary/entry
	name = "\improper 抵达穿梭机走廊"
	icon_state = "entry"
	area_flags = EVENT_PROTECTED

/area/station/hallway/secondary/dock
	name = "\improper 次级空间站对接走廊"
	icon_state = "hall"

/area/station/hallway/secondary/service
	name = "\improper 服务走廊"
	icon_state = "hall_service"
	tacmap_color = TACMAP_AREA_SERVICE

/area/station/hallway/secondary/spacebridge
	name = "\improper 太空桥"
	icon_state = "hall"

/area/station/hallway/secondary/recreation
	name = "\improper 娱乐走廊"
	icon_state = "hall"

/*
* Station Specific Areas
* If another station gets added, and you make specific areas for it
* Please make its own section in this file
* The areas below belong to North Star's Hallways
*/

//1
/area/station/hallway/floor1
	name = "\improper 一层走廊"

/area/station/hallway/floor1/aft
	name = "\improper 一层船尾走廊"
	icon_state = "1_aft"

/area/station/hallway/floor1/fore
	name = "\improper 一层船首走廊"
	icon_state = "1_fore"
//2
/area/station/hallway/floor2
	name = "\improper 二层走廊"

/area/station/hallway/floor2/aft
	name = "\improper 二层船尾走廊"
	icon_state = "2_aft"

/area/station/hallway/floor2/fore
	name = "\improper 二层船首走廊"
	icon_state = "2_fore"
//3
/area/station/hallway/floor3
	name = "\improper 三层走廊"

/area/station/hallway/floor3/aft
	name = "\improper 三层船尾走廊"
	icon_state = "3_aft"

/area/station/hallway/floor3/fore
	name = "\improper 三层船首走廊"
	icon_state = "3_fore"
//4
/area/station/hallway/floor4
	name = "\improper 四层走廊"

/area/station/hallway/floor4/aft
	name = "\improper 四层船尾走廊"
	icon_state = "4_aft"

/area/station/hallway/floor4/fore
	name = "\improper 四层船首走廊"
	icon_state = "4_fore"
