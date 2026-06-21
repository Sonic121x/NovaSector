/area/station/maintenance
	name = "通用维护区"
	ambience_index = AMBIENCE_MAINT
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED | PERSISTENT_ENGRAVINGS
	airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	forced_ambience = TRUE
	ambient_buzz = 'sound/ambience/maintenance/source_corridor2.ogg'
	ambient_buzz_vol = 20
	tacmap_color = TACMAP_AREA_MAINTENANCE

/*
* Departmental Maintenance
*/

/area/station/maintenance/department/chapel
	name = "礼拜堂维护区"
	icon_state = "maint_chapel"

/area/station/maintenance/department/chapel/monastery
	name = "修道院维护区"
	icon_state = "maint_monastery"

/area/station/maintenance/department/crew_quarters/bar
	name = "酒吧维护区"
	icon_state = "maint_bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/maintenance/department/crew_quarters/dorms
	name = "宿舍维护区"
	icon_state = "maint_dorms"

/area/station/maintenance/department/eva
	name = "舱外活动维护区"
	icon_state = "maint_eva"

/area/station/maintenance/department/eva/abandoned
	name = "废弃舱外活动存储区"

/area/station/maintenance/department/electrical
	name = "电力维护区"
	icon_state = "maint_electrical"

/area/station/maintenance/department/engine/atmos
	name = "大气维护区"
	icon_state = "maint_atmos"

/area/station/maintenance/department/security
	name = "安保维护区"
	icon_state = "maint_sec"

/area/station/maintenance/department/security/upper
	name = "上层安保维护区"

/area/station/maintenance/department/security/brig
	name = "禁闭室维护区"
	icon_state = "maint_brig"

/area/station/maintenance/department/medical
	name = "医疗舱维护区"
	icon_state = "medbay_maint"

/area/station/maintenance/department/medical/central
	name = "中央医疗舱维护区"
	icon_state = "medbay_maint_central"

/area/station/maintenance/department/medical/morgue
	name = "停尸房维护区"
	icon_state = "morgue_maint"

/area/station/maintenance/department/science
	name = "科研维护区"
	icon_state = "maint_sci"

/area/station/maintenance/department/science/central
	name = "中央科研维护区"
	icon_state = "maint_sci_central"

/area/station/maintenance/department/cargo
	name = "货运维护区"
	icon_state = "maint_cargo"

/area/station/maintenance/department/bridge
	name = "舰桥维护区"
	icon_state = "maint_bridge"

/area/station/maintenance/department/engine
	name = "工程维护区"
	icon_state = "maint_engi"

/area/station/maintenance/department/prison
	name = "监狱维护区"
	icon_state = "sec_prison"

/area/station/maintenance/department/science/xenobiology
	name = "异种生物学维护区"
	icon_state = "xenomaint"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | XENOBIOLOGY_COMPATIBLE | CULT_PERMITTED

/*
* Generic Maintenance Tunnels
*/

/area/station/maintenance/aft
	name = "舰尾维护区"
	icon_state = "aftmaint"

/area/station/maintenance/aft/upper
	name = "上层舰尾维护区"
	icon_state = "upperaftmaint"

/* Use greater variants of area definitions for when the station has two different sections of maintenance on the same z-level.
* Can stand alone without "lesser".
* This one means that this goes more fore/north than the "lesser" maintenance area.
*/
/area/station/maintenance/aft/greater
	name = "大型舰尾维护区"
	icon_state = "greateraftmaint"

/* Use lesser variants of area definitions for when the station has two different sections of maintenance on the same z-level in conjunction with "greater".
* (just because it follows better).
* This one means that this goes more aft/south than the "greater" maintenance area.
*/

/area/station/maintenance/aft/lesser
	name = "小型舰尾维护区"
	icon_state = "lesseraftmaint"

/area/station/maintenance/central
	name = "中央维护区"
	icon_state = "centralmaint"

/area/station/maintenance/central/greater
	name = "大型中央维护区"
	icon_state = "greatercentralmaint"

/area/station/maintenance/central/lesser
	name = "小型中央维护区"
	icon_state = "lessercentralmaint"

/area/station/maintenance/fore
	name = "舰首维护区"
	icon_state = "foremaint"

/area/station/maintenance/fore/upper
	name = "上层舰首维护区"
	icon_state = "upperforemaint"

/area/station/maintenance/fore/greater
	name = "大型舰首维护区"
	icon_state = "greaterforemaint"

/area/station/maintenance/fore/lesser
	name = "小型舰首维护区"
	icon_state = "lesserforemaint"

/area/station/maintenance/starboard
	name = "右舷维护区"
	icon_state = "starboardmaint"

/area/station/maintenance/starboard/upper
	name = "上层右舷维护区"
	icon_state = "upperstarboardmaint"

/area/station/maintenance/starboard/central
	name = "中央右舷维护区"
	icon_state = "centralstarboardmaint"

/area/station/maintenance/starboard/central/upper
	name = "上层中央右舷维护区"

/area/station/maintenance/starboard/greater
	name = "大型右舷维护区"
	icon_state = "greaterstarboardmaint"

/area/station/maintenance/starboard/lesser
	name = "小型右舷维护区"
	icon_state = "lesserstarboardmaint"

/area/station/maintenance/starboard/aft
	name = "舰尾右舷维护区"
	icon_state = "asmaint"

/area/station/maintenance/starboard/aft/upper
	name = "上层舰尾右舷维护区"

/area/station/maintenance/starboard/fore
	name = "前部右舷维护区"
	icon_state = "fsmaint"

/area/station/maintenance/starboard/fore/upper
	name = "上层前部右舷维护区"

/area/station/maintenance/port
	name = "左舷维护区"
	icon_state = "portmaint"

/area/station/maintenance/port/central
	name = "中央左舷维护区"
	icon_state = "centralportmaint"

/area/station/maintenance/port/greater
	name = "大型左舷维护区"
	icon_state = "greaterportmaint"

/area/station/maintenance/port/lesser
	name = "小型左舷维护区"
	icon_state = "lesserportmaint"

/area/station/maintenance/port/aft
	name = "后部左舷维护区"
	icon_state = "apmaint"

/area/station/maintenance/port/fore
	name = "前部左舷维护区"
	icon_state = "fpmaint"

/area/station/maintenance/tram
	name = "主要电车维护区"

/area/station/maintenance/tram/left
	name = "\improper 左舷电车地下通道"
	icon_state = "mainttramL"

/area/station/maintenance/tram/mid
	name = "\improper 中央电车地下通道"
	icon_state = "mainttramM"

/area/station/maintenance/tram/right
	name = "\improper 右舷电车地下通道"
	icon_state = "mainttramR"

/*
* Discrete Maintenance Areas
*/

/area/station/maintenance/disposal
	name = "废物处理区"
	icon_state = "disposal"

/area/station/maintenance/hallway/abandoned_command
	name = "\improper 废弃指挥走廊"
	icon_state = "maint_bridge"

/area/station/maintenance/hallway/abandoned_recreation
	name = "\improper 废弃娱乐走廊"
	icon_state = "maint_dorms"

/area/station/maintenance/disposal/incinerator
	name = "\improper 焚化炉"
	icon_state = "incinerator"
	tacmap_color = TACMAP_AREA_ENGINEERING

/area/station/maintenance/space_hut
	name = "\improper 太空小屋"
	icon_state = "spacehut"

/area/station/maintenance/space_hut/cabin
	name = "废弃小屋"

/area/station/maintenance/space_hut/plasmaman
	name = "\improper 废弃等离子人友好初创区"

/area/station/maintenance/space_hut/observatory
	name = "\improper 太空观测台"

/*
* Radation Storm Shelters
*/

/area/station/maintenance/radshelter
	name = "\improper 辐射风暴避难所"
	icon_state = "radstorm_shelter"

/area/station/maintenance/radshelter/medical
	name = "\improper 医疗辐射风暴避难所"

/area/station/maintenance/radshelter/sec
	name = "\improper 安保辐射风暴避难所"

/area/station/maintenance/radshelter/service
	name = "\improper 服务辐射风暴避难所"

/area/station/maintenance/radshelter/civil
	name = "\improper 平民辐射风暴避难所"

/area/station/maintenance/radshelter/sci
	name = "\improper 科研辐射风暴避难所"

/area/station/maintenance/radshelter/cargo
	name = "\improper 货运辐射风暴避难所"

/*
* External Hull Access Areas
*/

/area/station/maintenance/external
	name = "\improper 外部船体通道"
	icon_state = "amaint"

/area/station/maintenance/external/aft
	name = "\improper 船尾外部船体通道"

/area/station/maintenance/external/port
	name = "\improper 左舷外部船体通道"

/area/station/maintenance/external/port/bow
	name = "\improper 左舷船首外部船体通道"

/*
* Station Specific Areas
* If another station gets added, and you make specific areas for it
* Please make its own section in this file
* The areas below belong to North Star's Maintenance
*/

//1
/area/station/maintenance/floor1
	name = "\improper 一层维护区"

/area/station/maintenance/floor1/port
	name = "\improper 一层中央左舷维护区"
	icon_state = "maintcentral"

/area/station/maintenance/floor1/port/fore
	name = "\improper 一层前部左舷维护区"
	icon_state = "maintfore"
/area/station/maintenance/floor1/port/aft
	name = "\improper 一层后部左舷维护区"
	icon_state = "maintaft"

/area/station/maintenance/floor1/starboard
	name = "\improper 一层中央右舷维护区"
	icon_state = "maintcentral"

/area/station/maintenance/floor1/starboard/fore
	name = "\improper 一层前部右舷维护区"
	icon_state = "maintfore"

/area/station/maintenance/floor1/starboard/aft
	name = "\improper 一层后部右舷维护区"
	icon_state = "maintaft"
//2
/area/station/maintenance/floor2
	name = "\improper 二层维护区"
/area/station/maintenance/floor2/port
	name = "\improper 二层中央左舷维护区"
	icon_state = "maintcentral"

/area/station/maintenance/floor2/port/fore
	name = "\improper 二层左舷前部维护区"
	icon_state = "maintfore"

/area/station/maintenance/floor2/port/aft
	name = "\improper 二层左舷后部维护区"
	icon_state = "maintaft"

/area/station/maintenance/floor2/starboard
	name = "\improper 二层右舷中部维护区"
	icon_state = "maintcentral"

/area/station/maintenance/floor2/starboard/fore
	name = "\improper 二层右舷前部维护区"
	icon_state = "maintfore"

/area/station/maintenance/floor2/starboard/aft
	name = "\improper 二层右舷后部维护区"
	icon_state = "maintaft"
//3
/area/station/maintenance/floor3
	name = "\improper 三层维护区"

/area/station/maintenance/floor3/port
	name = "\improper 三层左舷中部维护区"
	icon_state = "maintcentral"

/area/station/maintenance/floor3/port/fore
	name = "\improper 三层左舷前部维护区"
	icon_state = "maintfore"

/area/station/maintenance/floor3/port/aft
	name = "\improper 三层左舷后部维护区"
	icon_state = "maintaft"

/area/station/maintenance/floor3/starboard
	name = "\improper 三层右舷中部维护区"
	icon_state = "maintcentral"

/area/station/maintenance/floor3/starboard/fore
	name = "\improper 三层右舷前部维护区"
	icon_state = "maintfore"

/area/station/maintenance/floor3/starboard/aft
	name = "\improper 三层右舷后部维护区"
	icon_state = "maintaft"
//4
/area/station/maintenance/floor4
	name = "\improper 四层维护区"

/area/station/maintenance/floor4/port
	name = "\improper 四层左舷中部维护区"
	icon_state = "maintcentral"

/area/station/maintenance/floor4/port/fore
	name = "\improper 四层左舷前部维护区"
	icon_state = "maintfore"

/area/station/maintenance/floor4/port/aft
	name = "\improper 四层左舷后部维护区"
	icon_state = "maintaft"

/area/station/maintenance/floor4/starboard
	name = "\improper 四层右舷中部维护区"
	icon_state = "maintcentral"

/area/station/maintenance/floor4/starboard/fore
	name = "\improper 四层右舷前部维护区"
	icon_state = "maintfore"

/area/station/maintenance/floor4/starboard/aft
	name = "\improper 四层右舷后部维护区"
	icon_state = "maintaft"
