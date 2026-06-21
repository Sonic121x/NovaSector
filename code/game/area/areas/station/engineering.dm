/area/station/engineering
	icon_state = "engie"
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	tacmap_color = TACMAP_AREA_ENGINEERING

/area/station/engineering/circuit_workshop
	name = "\improper 电路工坊"
	icon_state = "cir_wor"

/area/station/engineering/engine_smes
	name = "\improper 工程部SMES"
	icon_state = "engine_smes"

/area/station/engineering/main
	name = "工程部"
	icon_state = "engine"

/area/station/engineering/main/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/block_area_power_fail)

/area/station/engineering/hallway
	name = "工程部走廊"
	icon_state = "engine_hallway"

/area/station/engineering/atmos
	name = "大气处理区"
	icon_state = "atmos"

/area/station/engineering/atmos/upper
	name = "上层大气处理区"

/*outside atmos*/
/area/station/engineering/atmos/space_catwalk
	name = "\improper 大气处理区太空步道"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED

	sound_environment = SOUND_AREA_SPACE
	ambience_index = AMBIENCE_SPACE
	ambient_buzz = null //Space is deafeningly quiet

/area/station/engineering/atmos/project
	name = "\improper 大气项目室"
	icon_state = "atmos_projectroom"

/area/station/engineering/atmos/pumproom
	name = "\improper 大气泵房"
	icon_state = "atmos_pump_room"

/area/station/engineering/atmos/mix
	name = "\improper 大气混合室"
	icon_state = "atmos_mix"

/area/station/engineering/atmos/storage
	name = "\improper 大气储藏室"
	icon_state = "atmos_storage"

/area/station/engineering/atmos/storage/gas
	name = "\improper 大气气体储存室"
	icon_state = "atmos_storage_gas"

/area/station/engineering/atmos/office
	name = "\improper 大气办公室"
	icon_state = "atmos_office"

/area/station/engineering/atmos/hfr_room
	name = "\improper 大气HFR室"
	icon_state = "atmos_HFR"

/area/station/engineering/atmospherics_engine
	name = "\improper 大气引擎"
	icon_state = "atmos_engine"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED

/area/station/engineering/atmospherics_engine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/block_area_power_fail)

/area/station/engineering/lobby
	name = "\improper 工程部大厅"
	icon_state = "engi_lobby"

/area/station/engineering/supermatter
	name = "\improper Place Somewhere Around the Supermatter" // don't use this type
	icon_state = "engine_sm"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED

/area/station/engineering/supermatter/engine
	name = "\improper 超物质引擎"
	icon_state = "engine_sm"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/supermatter/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/block_area_power_fail)

/area/station/engineering/supermatter/waste
	name = "\improper 超物质废料室"
	icon_state = "engine_sm_waste"

/area/station/engineering/supermatter/room
	name = "\improper 超物质引擎室"
	icon_state = "engine_sm_room"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/engineering/supermatter/room/upper
	name = "\improper 上层超物质引擎室"
	icon_state = "engine_sm_room_upper"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/engineering/break_room
	name = "\improper 工程部前厅"
	icon_state = "engine_break"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/gravity_generator
	name = "\improper 重力发生器室"
	icon_state = "grav_gen"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/storage
	name = "工程部储藏室"
	icon_state = "engine_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/storage_shared
	name = "共享工程储藏室"
	icon_state = "engine_storage_shared"

/area/station/engineering/transit_tube
	name = "\improper 运输管道"
	icon_state = "transit_tube"

/area/station/engineering/storage/tech
	name = "技术储藏室"
	icon_state = "tech_storage"

/area/station/engineering/storage/tcomms
	name = "电信储藏室"
	icon_state = "tcom_storage"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED

/*
* Construction Areas
*/

/area/station/construction
	name = "\improper 施工区域"
	icon_state = "construction"
	ambience_index = AMBIENCE_ENGI
	sound_environment = SOUND_AREA_STANDARD_STATION
	tacmap_color = TACMAP_AREA_ENGINEERING

/area/station/construction/mining/aux_base
	name = "辅助基地施工区"
	icon_state = "aux_base_construction"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/construction/storage_wing
	name = "\improper 仓储侧翼"
	icon_state = "storage_wing"
