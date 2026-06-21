//Space Ruin Parents

/area/ruin/space
	default_gravity = ZERO_GRAVITY
	area_flags = NONE
	area_flags_mapping = UNIQUE_AREA

/area/ruin/space/unpowered
	always_unpowered = TRUE
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE

/area/ruin/space/has_grav
	default_gravity = STANDARD_GRAVITY

/area/ruin/space/has_grav/powered
	requires_power = FALSE

// Ruin solars define, /area/solars was moved to /area/station/solars, causing the solars specific areas to lose their properties
/area/ruin/space/solars
	requires_power = FALSE
	area_flags = NONE
	flags_1 = NONE
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_SPACE

/area/ruin/space/way_home
	name = "\improper 救赎之地"
	always_unpowered = FALSE

// Ruins of "onehalf" ship

/area/ruin/space/has_grav/onehalf/hallway
	name = "\improper 半空间站走廊"

/area/ruin/space/has_grav/onehalf/drone_bay
	name = "\improper 采矿无人机舱"

/area/ruin/space/has_grav/onehalf/dorms_med
	name = "\improper 船员生活区"

/area/ruin/space/has_grav/onehalf/bridge
	name = "\improper 半空间站舰桥"

/area/ruin/space/has_grav/powered/dinner_for_two
	name = "双人晚餐"

/area/ruin/space/has_grav/powered/cat_man
	name = "\improper 猫咪窝"

/area/ruin/space/has_grav/powered/authorship
	name = "\improper 作者室"

/area/ruin/space/has_grav/powered/aesthetic
	name = "美学空间"
	ambientsounds = list('sound/ambience/misc/ambivapor1.ogg')


//Ruin of Hotel

/area/ruin/space/has_grav/hotel
	name = "\improper 酒店"

/area/ruin/space/has_grav/hotel/guestroom
	name = "\improper 酒店客房"

/area/ruin/space/has_grav/hotel/guestroom/room_1
	name = "\improper 酒店客房 1"

/area/ruin/space/has_grav/hotel/guestroom/room_2
	name = "\improper 酒店客房 2"

/area/ruin/space/has_grav/hotel/guestroom/room_3
	name = "\improper 酒店客房 3"

/area/ruin/space/has_grav/hotel/guestroom/room_4
	name = "\improper 酒店客房 4"

/area/ruin/space/has_grav/hotel/guestroom/room_5
	name = "\improper 酒店客房 5"

/area/ruin/space/has_grav/hotel/guestroom/room_6
	name = "\improper 酒店客房 6"

/area/ruin/space/has_grav/hotel/security
	name = "\improper 酒店安保岗"

/area/ruin/space/has_grav/hotel/pool
	name = "\improper 酒店泳池室"
	icon_state = "fitness"

/area/ruin/space/has_grav/hotel/bar
	name = "\improper 酒店酒吧"

/area/ruin/space/has_grav/hotel/power
	name = "\improper 酒店电力室"

/area/ruin/space/has_grav/hotel/custodial
	name = "\improper 酒店保洁间"

/area/ruin/space/has_grav/hotel/shuttle
	name = "\improper 酒店穿梭机"
	requires_power = FALSE

/area/ruin/space/has_grav/hotel/dock
	name = "\improper 酒店穿梭机泊位"

/area/ruin/space/has_grav/hotel/workroom
	name = "\improper 酒店员工室"

/area/ruin/space/has_grav/hotel/storeroom
	name = "\improper 酒店员工储藏室"

//Ruin of Derelict Oupost

/area/ruin/space/has_grav/derelictoutpost
	name = "\improper 废弃前哨站"

/area/ruin/space/has_grav/derelictoutpost/cargostorage
	name = "\improper 废弃前哨站货物储藏室"

/area/ruin/space/has_grav/derelictoutpost/cargobay
	name = "\improper 废弃前哨站货物舱"

/area/ruin/space/has_grav/derelictoutpost/powerstorage
	name = "\improper 废弃前哨站能源储藏室"

/area/ruin/space/has_grav/derelictoutpost/dockedship
	name = "\improper 废弃前哨站停靠飞船"

//Ruin of turretedoutpost

/area/ruin/space/has_grav/turretedoutpost
	name = "\improper 炮塔前哨站"


//Ruin of old teleporter

/area/ruin/space/oldteleporter
	name = "\improper 旧传送器"


//Ruin of mech transport

/area/ruin/space/has_grav/powered/mechtransport
	name = "\improper 机甲运输区"


//Ruin of The Lizard's Gas (Station)

/area/ruin/space/has_grav/thelizardsgas
	name = "\improper 蜥蜴的加油站"


//Ruin of Deep Storage

/area/ruin/space/has_grav/deepstorage
	name = "深层储藏区"

/area/ruin/space/has_grav/deepstorage/airlock
	name = "\improper 深层储藏区气闸室"

/area/ruin/space/has_grav/deepstorage/power
	name = "\improper 深层储藏区能源与大气室"

/area/ruin/space/has_grav/deepstorage/hydroponics
	name = "深层储藏区水培室"

/area/ruin/space/has_grav/deepstorage/armory
	name = "\improper 深层储藏区安全储藏室"

/area/ruin/space/has_grav/deepstorage/storage
	name = "\improper 深层储藏区储藏室"

/area/ruin/space/has_grav/deepstorage/dorm
	name = "\improper 深层储藏区宿舍"

/area/ruin/space/has_grav/deepstorage/kitchen
	name = "\improper 深层储藏区厨房"

/area/ruin/space/has_grav/deepstorage/crusher
	name = "\improper 深层储藏区回收器"

/area/ruin/space/has_grav/deepstorage/pharmacy
	name = "\improper 深层储藏区药房"

//Ruin of Abandoned Zoo

/area/ruin/space/has_grav/abandonedzoo
	name = "\improper 废弃动物园"

//Ruin of Dangerous Research

/area/ruin/space/has_grav/dangerous_research
	name = "\improper ASRC 大厅"

/area/ruin/space/has_grav/dangerous_research/medical
	name = "\improper ASRC 医疗设施"

/area/ruin/space/has_grav/dangerous_research/dorms
	name = "\improper ASRC 宿舍区"

/area/ruin/space/has_grav/dangerous_research/lab
	name = "\improper ASRC 实验室"

/area/ruin/space/has_grav/dangerous_research/maint
	name = "\improper ASRC 维护区"

//Interdyne Ruin

/area/ruin/space/has_grav/interdyne
	name = "\improper Interdyne 研究基地"

//Ruin of Crashed Ship

/area/ruin/space/has_grav/crashedship/aft
	name = "\improper 坠毁飞船船尾"

/area/ruin/space/has_grav/crashedship/midship
	name = "\improper 坠毁飞船中段"

/area/ruin/space/has_grav/crashedship/fore
	name = "\improper 坠毁飞船船首"

/area/ruin/space/has_grav/crashedship/big_asteroid
	name = "\improper 小行星"

/area/ruin/space/has_grav/crashedship/small_asteroid
	name = "\improper 小行星"

//Ruin of ancient Space Station (OldStation)

/area/ruin/space/ancientstation
	icon_state = "oldstation"

/area/ruin/space/ancientstation/powered
	name = "通电地板"
	icon_state = "teleporter"
	requires_power = FALSE

/area/ruin/space/ancientstation/beta
	icon_state = "betastation"

/area/ruin/space/ancientstation/beta/atmos
	name = "贝塔站大气处理区"
	icon_state = "os_beta_atmos"
	ambience_index = AMBIENCE_ENGI

/area/ruin/space/ancientstation/beta/supermatter
	name = "贝塔站超物质反应室"
	icon_state = "os_beta_engine"

/area/ruin/space/ancientstation/beta/hall
	name = "贝塔站主走廊"
	icon_state = "os_beta_hall"

/area/ruin/space/ancientstation/beta/gravity
	name = "贝塔站重力发生器"
	icon_state = "os_beta_gravity"

/area/ruin/space/ancientstation/beta/mining
	name = "贝塔站采矿设备区"
	icon_state = "os_beta_mining"
	ambience_index = AMBIENCE_MINING

/area/ruin/space/ancientstation/beta/medbay
	name = "贝塔站医疗湾"
	icon_state = "os_beta_medbay"
	ambience_index = AMBIENCE_MEDICAL

/area/ruin/space/ancientstation/beta/storage
	name = "\improper 贝塔站仓储区"
	icon_state = "os_beta_storage"

/area/ruin/space/ancientstation/charlie
	icon_state = "charliestation"

/area/ruin/space/ancientstation/charlie/hall
	name = "查理站主走廊"
	icon_state = "os_charlie_hall"

/area/ruin/space/ancientstation/charlie/engie
	name = "查理站工程部"
	icon_state = "os_charlie_engine"
	ambience_index = AMBIENCE_ENGI

/area/ruin/space/ancientstation/charlie/bridge
	name = "查理站指挥区"
	icon_state = "os_charlie_bridge"

/area/ruin/space/ancientstation/charlie/hydro
	name = "查理站水培区"
	icon_state = "os_charlie_hydro"

/area/ruin/space/ancientstation/charlie/kitchen
	name = "\improper 查理站厨房"
	icon_state = "os_charlie_kitchen"

/area/ruin/space/ancientstation/charlie/sec
	name = "查理站安保部"
	icon_state = "os_charlie_sec"

/area/ruin/space/ancientstation/charlie/dorms
	name = "查理站宿舍区"
	icon_state = "os_charlie_dorms"

/area/ruin/space/solars/ancientstation/charlie/solars
	name = "\improper 查理站太阳能阵列"
	icon = 'icons/area/areas_ruins.dmi' // Solars inheriet areas_misc.dmi, not areas_ruin.dmi
	icon_state = "os_charlie_solars"
	requires_power = FALSE
	area_flags = NONE
	sound_environment = SOUND_AREA_SPACE

/area/ruin/space/ancientstation/charlie/storage
	name = "查理站储藏区"
	icon_state = "os_charlie_storage"

/area/ruin/space/ancientstation/delta
	icon_state = "deltastation"

/area/ruin/space/ancientstation/delta/hall
	name = "德尔塔站主走廊"
	icon_state = "os_delta_hall"

/area/ruin/space/ancientstation/delta/proto
	name = "\improper 德尔塔站原型实验室"
	icon_state = "os_delta_protolab"

/area/ruin/space/ancientstation/delta/rnd
	name = "德尔塔站研发部"
	icon_state = "os_delta_rnd"

/area/ruin/space/ancientstation/delta/ai
	name = "\improper 德尔塔站AI核心"
	icon_state = "os_delta_ai"
	ambientsounds = list('sound/ambience/misc/ambimalf.ogg', 'sound/ambience/engineering/ambitech.ogg', 'sound/ambience/engineering/ambitech2.ogg', 'sound/ambience/engineering/ambiatmos.ogg', 'sound/ambience/engineering/ambiatmos2.ogg')

/area/ruin/space/ancientstation/delta/storage
	name = "\improper 德尔塔站储藏区"
	icon_state = "os_delta_storage"

/area/ruin/space/ancientstation/delta/biolab
	name = "德尔塔站生物实验室"
	icon_state = "os_delta_biolab"

//KC13, aka TheDerelict.dmm

/area/ruin/space/ks13
	name = "\improper 废弃空间站13号"
	icon_state = "ks13"

// Area define for organization
/area/ruin/space/ks13/hallway

/area/ruin/space/ks13/hallway/central
	name = "\improper 废弃中央走廊"
	icon_state = "ks13_cent_hall"

/area/ruin/space/ks13/hallway/aft
	name = "\improper 废弃舰尾走廊"
	icon_state = "ks13_aft_hall"

/area/ruin/space/ks13/hallway/starboard_bow
	name = "\improper 废弃右舷船首走廊"
	icon_state = "ks13_sb_bow_hall"

// Area define for organization
/area/ruin/space/ks13/engineering

/area/ruin/space/ks13/engineering/supermatter
	name = "\improper 废弃超物质引擎室"
	icon_state = "ks13_supermatter"

/area/ruin/space/ks13/engineering/atmos
	name = "\improper 废弃大气处理室"
	icon_state = "ks13_atmos"

/area/ruin/space/ks13/engineering/secure_storage
	name = "\improper 废弃安全储物间"
	icon_state = "ks13_secure_storage"

/area/ruin/space/ks13/engineering/tech_storage
	name = "\improper 废弃技术储物间"
	icon_state = "ks13_tech_storage"

/area/ruin/space/ks13/engineering/aux_storage
	name = "\improper 废弃辅助储物间"
	icon_state = "ks13_aux_storage"

/area/ruin/space/ks13/engineering/grav_gen
	name = "\improper 废弃重力发生器"
	icon_state = "ks13_grav_gen"

/area/ruin/space/ks13/engineering/sb_bow_solars_control
	name = "\improper 废弃右舷船首太阳能控制室"
	icon_state = "ks13_sb_bow_solars_control"

/area/ruin/space/ks13/engineering/aft_solars_control
	name = "\improper 废弃船尾太阳能控制室"
	icon_state = "ks13_aft_solars_control"

// Area define for organization
/area/ruin/space/ks13/medical

/area/ruin/space/ks13/medical/morgue
	name = "\improper 废弃停尸房"
	icon_state = "ks13_morgue"

/area/ruin/space/ks13/medical/medbay
	name = "\improper 废弃医疗舱"
	icon_state = "ks13_med"

// Area define for organization
/area/ruin/space/ks13/service

/area/ruin/space/ks13/service/kitchen
	name = "\improper 废弃厨房"
	icon_state = "ks13_kitchen"

/area/ruin/space/ks13/service/bar
	name = "\improper 废弃酒吧"
	icon_state = "ks13_bar"

/area/ruin/space/ks13/service/chapel
	name = "\improper 废弃教堂"
	icon_state = "ks13_chapel"

/area/ruin/space/ks13/service/chapel_office
	name = "\improper 废弃教堂办公室"
	icon_state = "ks13_chapel_office"

/area/ruin/space/ks13/service/cafe
	name = "\improper 废弃咖啡馆"
	icon_state = "ks13_cafe"

/area/ruin/space/ks13/service/hydro
	name = "\improper 废弃水培室"
	icon_state = "ks13_hydro"

/area/ruin/space/ks13/service/jani
	name = "\improper 废弃清洁工储物间"
	icon_state = "ks13_jani"

// Area define for organization
/area/ruin/space/ks13/science

/area/ruin/space/ks13/science/rnd
	name = "\improper 废弃研发部"
	icon_state = "ks13_sci"

/area/ruin/space/ks13/science/genetics
	name = "\improper 废弃遗传学实验室"
	icon_state = "ks13_gen"

/area/ruin/space/ks13/science/ordnance
	name = "\improper 废弃军械部"
	icon_state = "ks13_ord"

/area/ruin/space/ks13/science/ordnance_hall
	name = "\improper 废弃军械部走廊"
	icon_state = "ks13_ord_hall"

// Area define for organization
/area/ruin/space/ks13/security

/area/ruin/space/ks13/security/sec
	name = "\improper 废弃安保区"
	icon_state = "ks13_sec"

/area/ruin/space/ks13/security/cell
	name = "\improper 废弃安保禁闭室"
	icon_state = "ks13_sec_cell"

/area/ruin/space/ks13/security/court
	name = "\improper 废弃法庭"
	icon_state = "ks13_court"

/area/ruin/space/ks13/security/court_hall
	name = "\improper 废弃法庭走廊"
	icon_state = "ks13_court_hall"

// Area define for organization
/area/ruin/space/ks13/command

/area/ruin/space/ks13/command/bridge
	name = "\improper 废弃舰桥"
	icon_state = "ks13_bridge"

/area/ruin/space/ks13/command/bridge_hall
	name = "\improper 废弃舰桥走廊"
	icon_state = "ks13_bridge_hall"

/area/ruin/space/ks13/command/eva
	name = "\improper 废弃舱外活动区"
	icon_state = "ks13_eva"

// Area define for organization
/area/ruin/space/ks13/ai

/area/ruin/space/ks13/ai/vault
	name = "\improper 废弃人工智能核心"
	icon_state = "ks13_ai_vault"

/area/ruin/space/ks13/ai/corridor
	name = "\improper 废弃人工智能走廊"
	icon_state = "ks13_ai_corridor"

// Misc areas that don't belong to a department, general purpose or what may have you
/area/ruin/space/ks13/tool_storage
	name = "\improper 废弃工具储藏室"
	icon_state = "ks13_tool_storage"

/area/ruin/space/ks13/dorms
	name = "\improper 废弃宿舍区"
	icon_state = "ks13_dorms"

/area/ruin/space/solars/ks13/sb_bow_solars
	name = "\improper 废弃右舷船首太阳能板"
	icon_state = "ks13_sb_bow_solars"

/area/ruin/space/solars/ks13/aft_solars
	name = "\improper 废弃船尾太阳能板"
	icon_state = "ks13_aft_solars"

//DJSTATION

/area/ruin/space/djstation
	name = "\improper 俄国佬DJ站"
	icon_state = "DJ"
	default_gravity = STANDARD_GRAVITY

/area/ruin/space/djstation/solars
	name = "\improper DJ站太阳能板"
	icon_state = "DJ"
	area_flags = NONE
	default_gravity = ZERO_GRAVITY

/area/ruin/space/djstation/service
	name = "\improper DJ站服务区"
	icon_state = "DJ"
	default_gravity = STANDARD_GRAVITY

//ABANDONED TELEPORTER

/area/ruin/space/abandoned_tele
	name = "\improper 废弃传送室"
	ambientsounds = list('sound/ambience/misc/ambimalf.ogg', 'sound/ambience/misc/signal.ogg')

//OLD AI SAT

/area/ruin/space/tcommsat_oldaisat // Since tcommsat was moved to /area/station/, this turf doesn't inhereit its properties anymore
	name = "\improper 废弃卫星"
	ambientsounds = list('sound/ambience/engineering/ambisin2.ogg', 'sound/ambience/misc/signal.ogg', 'sound/ambience/misc/signal.ogg', 'sound/ambience/general/ambigen9.ogg', 'sound/ambience/engineering/ambitech.ogg',\
											'sound/ambience/engineering/ambitech2.ogg', 'sound/ambience/engineering/ambitech3.ogg', 'sound/ambience/misc/ambimystery.ogg')
	airlock_wires = /datum/wires/airlock/engineering

// CRASHED PRISON SHUTTLE
/area/ruin/space/prison_shuttle
	name = "\improper 坠毁的囚犯穿梭机"


//ABANDONED BOX WHITESHIP

/area/ruin/space/has_grav/whiteship/box

	name = "\improper 废弃飞船"


//SYNDICATE LISTENING POST STATION

/area/ruin/space/has_grav/listeningstation
	name = "\improper 监听哨站"

/area/ruin/space/has_grav/powered/ancient_shuttle
	name = "\improper 古代穿梭机"

//HELL'S FACTORY OPERATING FACILITY
/area/ruin/space/has_grav/hellfactory
	name = "\improper 地狱工厂"

/area/ruin/space/has_grav/hellfactoryoffice
	name = "\improper 地狱工厂办公室"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | NOTELEPORT

//Ruin of Spinward Smoothies

/area/ruin/space/has_grav/spinwardsmoothies
	name = "斯宾沃德果汁店"

// The planet of the clowns
/area/ruin/space/has_grav/powered/clownplanet
	name = "\improper 小丑星球"
	ambientsounds = list('sound/music/lobby_music/clown.ogg')

//DERELICT SULACO
/area/ruin/space/has_grav/derelictsulaco
	name = "\improper 废弃苏拉科号"

/area/ruin/space/has_grav/powered/biooutpost
	name = "\improper 生物研究前哨站"
	area_flags = NOTELEPORT

/area/ruin/space/has_grav/powered/biooutpost/vault
	name = "\improper 生物研究前哨站安全测试区"

// Space Ghost Kitchen
/area/ruin/space/space_ghost_restaurant
	name = "\improper 太空幽灵餐厅"

//Mass-driver hub ruin
/area/ruin/space/massdriverhub
	name = "\improper 质量加速器路由器"
	always_unpowered = FALSE

// The abandoned capsule 'The Traveler's Rest'
/area/ruin/space/has_grav/travelers_rest
	name = "\improper 旅者休憩处"

// The Phonebooth
/area/ruin/space/has_grav/powered/space_phone_booth
	name = "\improper 电话亭"

// Botnanical Haven
/area/ruin/space/has_grav/powered/botanical_haven
	name = "\improper 植物学天堂"

// Ruin of Derelict Construction
/area/ruin/space/has_grav/derelictconstruction
	name = "\improper 废弃建筑工地"

/// The Atmos Asteroid Ruin, has a subtype for rapid identification since this has some unique atmospherics properties and we can easily detect it if something goes wonky.
/area/ruin/space/has_grav/atmosasteroid

// Ruin of Waystation
/area/ruin/space/has_grav/waystation
	name = "航站维护区"

/area/ruin/space/has_grav/waystation/qm
	name = "航站物资官办公室"

/area/ruin/space/has_grav/waystation/dorms
	name = "航站生活区"

/area/ruin/space/has_grav/waystation/kitchen
	name = "航站厨房"

/area/ruin/space/has_grav/waystation/cargobay
	name = "航站货运舱"

/area/ruin/space/has_grav/waystation/securestorage
	name = "空间站安全储物区"

/area/ruin/space/has_grav/waystation/cargooffice
	name = "空间站货运办公室"

/area/ruin/space/has_grav/powered/waystation/assaultpod
	name = "空间站突击舱"

/area/ruin/space/has_grav/waystation/power
	name = "空间站电力区"

// Ruin of The All-American Diner
/area/ruin/space/has_grav/allamericandiner
	name = "\improper 全美餐厅"

// Transit Booth
/area/ruin/space/has_grav/transit_booth
	name = "transit_booth"
	icon = 'icons/area/areas_ruins.dmi'
	icon_state = "ruins"
	requires_power = FALSE
	ambientsounds = list('sound/ambience/general/ambigen12.ogg','sound/ambience/general/ambigen13.ogg','sound/ambience/medical/ambinice.ogg')

// the outlet
/area/ruin/space/has_grav/the_outlet/storefront
	name = "\improper 折扣店店面"

/area/ruin/space/has_grav/the_outlet/employeesection
	name = "\improper 折扣店员工专区"

/area/ruin/space/has_grav/the_outlet/researchrooms
	name = "\improper 折扣店研究间"

/area/ruin/space/has_grav/the_outlet/cultinfluence
	name = "\improper 折扣店邪教侵蚀区"

//SYN-C Brutus, derelict frigate
/area/ruin/space/has_grav/infested_frigate
	name = "SYN-C 布鲁图斯号"

//garbage trucks
/area/ruin/space/has_grav/garbagetruck
	name = "已退役垃圾运输车"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience_index = AMBIENCE_MAINT

/area/ruin/space/has_grav/garbagetruck/foodwaste

/area/ruin/space/has_grav/garbagetruck/medicalwaste

/area/ruin/space/has_grav/garbagetruck/squat

/area/ruin/space/has_grav/garbagetruck/toystore

//Donk Co trading outpost
/area/ruin/space/has_grav/hauntedtradingpost
	name = "\improper 唐克公司贸易前哨站"
	icon_state = "donk_public"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/ruin/space/has_grav/hauntedtradingpost/public
	name = "\improper 唐克公司贸易前哨站公共会议区与食堂"

/area/ruin/space/has_grav/hauntedtradingpost/public/corridor
	name = "\improper 唐克公司贸易前哨站公共码头与走廊"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/ruin/space/has_grav/hauntedtradingpost/employees
	name = "\improper 唐克公司贸易前哨站员工休息室"
	icon_state = "donk_employees"
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/ruin/space/has_grav/hauntedtradingpost/employees/workstation
	name = "\improper 唐克公司贸易前哨站工程站"

/area/ruin/space/has_grav/hauntedtradingpost/employees/corridor
	name = "\improper 唐克公司贸易前哨站安全走廊"
	icon_state = "donk_command"

/area/ruin/space/has_grav/hauntedtradingpost/employees/breakroom
	name = "\improper 唐克公司贸易前哨站休息室"

/area/ruin/space/has_grav/hauntedtradingpost/maint
	name = "\improper 唐克公司贸易前哨站辅助储藏室"
	icon_state = "donk_maints"
	airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	ambience_index = AMBIENCE_MAINT

/area/ruin/space/has_grav/hauntedtradingpost/maint/toolstorage

/area/ruin/space/has_grav/hauntedtradingpost/maint/toystorage

/area/ruin/space/has_grav/hauntedtradingpost/maint/disposals
	name = "\improper 唐克公司贸易前哨废物处理站"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ruin/space/has_grav/hauntedtradingpost/office
	name = "\improper 唐克公司贸易前哨舰长办公室"
	icon_state = "donk_command"
	airlock_wires = /datum/wires/airlock/cargo
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/ruin/space/has_grav/hauntedtradingpost/office/meetingroom
	name = "\improper 唐克公司贸易前哨董事会会议室"

/area/ruin/space/has_grav/hauntedtradingpost/aicore
	name = "\improper 赛博太阳AI核心"
	icon_state = "donk_command"
	airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience_index = AMBIENCE_DANGER

//Film studio
/area/ruin/space/has_grav/film_studio
	name = "\improper 电影制片厂发电机房"

/area/ruin/space/has_grav/film_studio/dorms
	name = "\improper 电影制片厂生活区"

/area/ruin/space/has_grav/film_studio/stage
	name = "\improper 电影制片厂主拍摄区"

/area/ruin/space/has_grav/film_studio/backstage
	name = "\improper 电影制片厂后台"

/area/ruin/space/has_grav/film_studio/director
	name = "\improper 电影制片厂导演室"

/area/ruin/space/has_grav/film_studio/solars
	name = "\improper 电影制片厂维护太阳能板区"

/area/ruin/space/has_grav/film_studio/starboard
	name = "\improper 电影制片厂右舷翼"
