// Nova Sector space area defines - Mostly for ruins

///Generic Nova Sector Ruins

/area/ruin/space/has_grav/powered/nova/smugglies
	name = "可疑货运设施"

/area/ruin/space/has_grav/powered/nova/clothing_facility
	name = "废弃研究空间站"

/area/ruin/space/has_grav/nova/blackmarket
	name = "黑市"

/area/ruin/space/has_grav/powered/nova/alien_tool_lab
	name = "外星工具实验室"

/area/ruin/space/has_grav/powered/nova/scrapheap
	name = "废料堆"

/area/ruin/space/has_grav/shuttle8532engineering
	name = "8532号穿梭机引擎室"

/area/ruin/space/has_grav/shuttle8532researchbay
	name = "8532号穿梭机研究舱"

/area/ruin/space/has_grav/shuttle8532cargohall
	name = "8532号穿梭机货运大厅"

/area/ruin/space/has_grav/shuttle8532crewquarters
	name = "8532号穿梭机船员宿舍"

/area/ruin/space/has_grav/shuttle8532bridge
	name = "8532号穿梭机舰桥"

/area/ruin/space/has_grav/vaulttango
	name = "ARBORLINK 金库探戈"

/area/ruin/space/has_grav/waypoint
	name = "废弃空间站"

/area/ruin/space/has_grav/powered/toy_store
	name = "玩具商店"

/area/ruin/space/has_grav/powered/prison_shuttle
	name = "监狱穿梭机"

/area/ruin/space/has_grav/powered/posterpandamonium
	name = "奇异穿梭机"

/area/ruin/space/has_grav/powered/turretfactory //give it vague mechanical sounds
	name = "炮塔工厂"
	ambientsounds = list('sound/ambience/maintenance/ambimaint.ogg','sound/ambience/maintenance/ambimaint1.ogg','sound/ambience/maintenance/ambimaint3.ogg', 'sound/ambience/maintenance/ambimaint5.ogg', 'sound/ambience/maintenance/ambimaint6.ogg')

//// Port Tarkon
// outside
/area/ruin/space/has_grav/outdoors
	outdoors = TRUE

/area/solars/tarkon
	name = "P-T太阳能阵列"
	icon_state = "space_near"
	default_gravity = STANDARD_GRAVITY
	outdoors = TRUE

// crew/service areas

/area/ruin/space/has_grav/port_tarkon
	name = "P-T低温储存室"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "cryo"

/area/ruin/space/has_grav/port_tarkon/kitchen
	name = "P-T厨房"
	icon_state = "cafeteria"

/area/ruin/space/has_grav/port_tarkon/garden
	name = "P-T花园"
	icon_state = "garden"

/area/ruin/space/has_grav/port_tarkon/toolstorage
	name = "P-T工具储藏室"
	icon_state = "tool_storage"

/area/ruin/space/has_grav/port_tarkon/dorms
	name = "P-T宿舍"
	icon_state = "dorms"

/area/ruin/space/has_grav/port_tarkon/sauna
	name = "P-T桑拿房"
	icon_state = "dorms"

/area/ruin/space/has_grav/port_tarkon/lockerroom
	name = "P-T储物柜储藏室"
	icon_state = "locker"

/area/ruin/space/has_grav/port_tarkon/lounge
	name = "P-T酒吧休息室"
	icon_state = "bar"

/area/ruin/space/has_grav/port_tarkon/restroom
	name = "P-T盥洗室"
	icon_state = "laundry_room"

// Halls

/area/ruin/space/has_grav/port_tarkon/afthall
	name = "P-T船尾走廊"
	icon_state = "afthall"

/area/ruin/space/has_grav/port_tarkon/forehall
	name = "P-T船首走廊"
	icon_state = "forehall"

/area/ruin/space/has_grav/port_tarkon/starboardhall
	name = "P-T右舷走廊"
	icon_state = "starboardhall"

/area/ruin/space/has_grav/port_tarkon/porthall
	name = "P-T 港口走廊"
	icon_state = "porthall"

/area/ruin/space/has_grav/port_tarkon/centerhall
	name = "P-T 中央走廊"
	icon_state = "centralhall"

/area/ruin/space/has_grav/port_tarkon/sciencehall
	name = "P-T 研究大厅"
	icon_state = "science"

/area/ruin/space/has_grav/port_tarkon/medhall
	name = "P-T 医疗大厅"
	icon_state = "med_central"

// Engineering

/area/ruin/space/has_grav/port_tarkon/atmos
	name = "P-T 大气控制中心"
	icon_state = "atmos"

/area/ruin/space/has_grav/port_tarkon/power1
	name = "P-T 太阳能控制室"
	icon_state = "engine"

/area/ruin/space/has_grav/port_tarkon/backuppower
	name = "P-T 备用电力储存室"
	icon_state = "engie"

// Command

/area/ruin/space/has_grav/port_tarkon/comms
	name = "P-T 通讯中心"
	icon_state = "command"

/area/ruin/space/has_grav/port_tarkon/comlobby
	name = "P-T 通讯大厅"
	icon_state = "command"

/area/ruin/space/has_grav/port_tarkon/apartment
	name = "P-T 主管公寓"
	icon_state = "head_quarters"
// Cargo

/area/ruin/space/has_grav/port_tarkon/cargo
	name = "P-T 货运中心"
	icon_state = "cargo_office"

/area/ruin/space/has_grav/port_tarkon/mining
	name = "P-T 采矿办公室"
	icon_state = "mining_dock"

/area/ruin/space/has_grav/port_tarkon/storage
	name = "P-T 仓库"
	icon_state = "cargo_warehouse"

/area/ruin/space/has_grav/port_tarkon/cargoexpand
	name = "P-T 项目室"
	icon_state = "engie"

// Lesser Departments

/area/ruin/space/has_grav/port_tarkon/trauma
	name = "P-T 创伤中心"
	icon_state = "medbay"

/area/ruin/space/has_grav/port_tarkon/morgue
	name = "P-T 停尸房"
	icon_state = "morgue"

/area/ruin/space/has_grav/port_tarkon/developement
	name = "P-T 研发中心"
	icon_state = "science"
	area_flags = XENOBIOLOGY_COMPATIBLE

/area/ruin/space/has_grav/port_tarkon/xenology //A bit beyond just normal xenobiology in scope, But basically xenobiology
	name = "P-T 外星生物学实验室"
	icon_state = "science"
	area_flags = XENOBIOLOGY_COMPATIBLE

/area/ruin/space/has_grav/port_tarkon/secoff
	name = "P-T 安保办公室"
	icon_state = "security"

/area/ruin/space/has_grav/port_tarkon/park
	name = "P-T 公园"
	icon_state = "garden"

/**
 * DS2 Syndie Areas
 */
/area/ruin/space/has_grav/nova/des_two
	name = "DS-2" //If DS-1 is so great...
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "syndie-ship"

//Cargo
/area/ruin/space/has_grav/nova/des_two/cargo
	name = "DS-2 仓库"

/area/ruin/space/has_grav/nova/des_two/cargo/hangar
	name = "DS-2 机库"

/area/ruin/space/has_grav/nova/des_two/cargo/storage
	name = "DS-2 深层存储区"

//Bridge
/area/ruin/space/has_grav/nova/des_two/bridge
	name = "DS-2 舰桥"
	icon_state = "syndie-control"

/area/ruin/space/has_grav/nova/des_two/bridge/cl
	name = "DS-2 企业联络官办公室"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/ruin/space/has_grav/nova/des_two/bridge/admiral
	name = "DS-2 空间站上将办公室"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/ruin/space/has_grav/nova/des_two/bridge/vault
	name = "DS-2 金库"

/area/ruin/space/has_grav/nova/des_two/bridge/vault
	name = "DS-2 情报中心"

/area/ruin/space/has_grav/nova/des_two/bridge/eva
	name = "DS-2 E.V.A."

//Security
/area/ruin/space/has_grav/nova/des_two/security
	name = "DS-2 安保"
	ambience_index = AMBIENCE_DANGER

/area/ruin/space/has_grav/nova/des_two/security/intel
	name = "DS-2 情报办公室"

/area/ruin/space/has_grav/nova/des_two/security/armory
	name = "DS-2 军械库"

/area/ruin/space/has_grav/nova/des_two/security/maa
	name = "DS-2 军械长办公室"

/area/ruin/space/has_grav/nova/des_two/security/lawyer
	name = "DS-2 审讯办公室"

/area/ruin/space/has_grav/nova/des_two/security/prison
	name = "DS-2 长期禁闭室"

//Service
/area/ruin/space/has_grav/nova/des_two/service
	name = "DS-2 服务区"

/area/ruin/space/has_grav/nova/des_two/service/diner
	name = "DS-2 小餐馆"

/area/ruin/space/has_grav/nova/des_two/service/dorms
	name = "DS-2 宿舍区"

/area/ruin/space/has_grav/nova/des_two/service/dorms/fitness
	name = "DS-2 健身房"

/area/ruin/space/has_grav/nova/des_two/service/lounge
	name = "DS-2 休息室"

/area/ruin/space/has_grav/nova/des_two/service/changing_room
	name = "DS-2 更衣室"

/area/ruin/space/has_grav/nova/des_two/service/sauna
	name = "DS-2 桑拿房"

/area/ruin/space/has_grav/nova/des_two/service/restroom
	name = "DS-2 洗手间"

/area/ruin/space/has_grav/nova/des_two/service/library
	name = "DS-2 图书馆"

/area/ruin/space/has_grav/nova/des_two/service/hydroponics
	name = "DS-2 水培室"

//Hallways
/area/ruin/space/has_grav/nova/des_two/halls
	name = "DS-2 中央大厅"

//Engineering
/area/ruin/space/has_grav/nova/des_two/engineering
	name = "DS-2 工程部"

//Research
/area/ruin/space/has_grav/nova/des_two/research
	name = "DS-2 研究部"

/area/ruin/space/has_grav/nova/des_two/research/robotics
	name = "DS-2 机器人舱"

//Medbay
/area/ruin/space/has_grav/nova/des_two/medbay
	name = "DS-2 医疗舱"

/area/ruin/space/has_grav/nova/des_two/medbay/chem
	name = "DS-2 化学实验室"

/**
 * Cargodise Lost Freighter defines
 */

/area/ruin/space/has_grav/cargodise_freighter/primaryhall
	name = "货船主厅"

/area/ruin/space/has_grav/cargodise_freighter/trauma
	name = "货船创伤中心"

/area/ruin/space/has_grav/cargodise_freighter/utility
	name = "货船工具间"

/area/ruin/space/has_grav/cargodise_freighter/kitchen
	name = "货船厨房"

/area/ruin/space/has_grav/cargodise_freighter/bridge
	name = "货船舰桥"

/area/ruin/space/has_grav/cargodise_freighter/cargo
	name = "货船货运舱"

/area/ruin/space/has_grav/cargodise_freighter/mining
	name = "货船采矿办公室"

/area/ruin/space/has_grav/cargodise_freighter/quarters
	name = "货船船员宿舍"

/area/ruin/space/has_grav/cargodise_freighter/hydroponics
	name = "货船水培区"

/area/ruin/space/has_grav/cargodise_freighter/vault
	name = "货船金库"

/area/ruin/space/has_grav/cargodise_freighter/exterior
	name = "货船外部"

// Nova Sector's Space Hotel

/area/ruin/space/has_grav/hotel/sauna
	name = "酒店桑拿房"

/area/ruin/space/has_grav/hotel/workroom/quarters
	name = "酒店员工宿舍"

/area/ruin/solars/hotel/solars
	name = "\improper 酒店太阳能阵列"
	requires_power = FALSE
	area_flags = NONE
	sound_environment = SOUND_AREA_SPACE
	base_lighting_alpha = 255
