
// CENTCOM
// CentCom itself
/area/centcom
	name = "中央司令部"
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "centcom"
	static_lighting = TRUE
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	area_flags = NOTELEPORT
	flags_1 = NONE

// This is just to define the category
/area/centcom/central_command_areas
	name = "中央司令部区域"

/area/centcom/central_command_areas/control
	name = "中央司令部中央控制室"
	icon_state = "centcom_control"

/area/centcom/central_command_areas/evacuation
	name = "中央司令部恢复翼"
	icon_state = "centcom_evacuation"

/area/centcom/central_command_areas/evacuation/ship
	name = "中央司令部恢复船"
	icon_state = "centcom_evacuation_ship"

/area/centcom/central_command_areas/fore
	name = "前部中央司令部船坞"
	icon_state = "centcom_fore"

/area/centcom/central_command_areas/supply
	name = "中央司令部补给翼"
	icon_state = "centcom_supply"

/area/centcom/central_command_areas/ferry
	name = "中央司令部运输穿梭机船坞"
	icon_state = "centcom_ferry"

/area/centcom/central_command_areas/briefing
	name = "中央司令部简报室"
	icon_state = "centcom_briefing"

/area/centcom/central_command_areas/armory
	name = "中央司令部军械库"
	icon_state = "centcom_armory"

/area/centcom/central_command_areas/admin
	name = "中央司令部行政办公室"
	icon_state = "centcom_admin"

/area/centcom/central_command_areas/admin/storage
	name = "中央司令部行政办公室储藏室"
	icon_state = "centcom_admin_storage"

/area/centcom/central_command_areas/prison
	name = "管理监狱"
	icon_state = "centcom_prison"

/area/centcom/central_command_areas/prison/cells
	name = "管理监狱牢房"
	icon_state = "centcom_cells"

/area/centcom/central_command_areas/courtroom
	name = "纳米传讯大法庭"
	icon_state = "centcom_court"

/area/centcom/central_command_areas/holding
	name = "拘留设施"
	icon_state = "centcom_holding"

/area/centcom/central_command_areas/supplypod/supplypod_temp_holding
	name = "补给舱运输通道"
	icon_state = "supplypod_flight"

/area/centcom/central_command_areas/supplypod
	name = "补给舱设施"
	icon_state = "supplypod"

/area/centcom/central_command_areas/supplypod/pod_storage
	name = "补给舱储藏室"
	icon_state = "supplypod_holding"

/area/centcom/central_command_areas/supplypod/loading
	name = "补给舱装载设施"
	icon_state = "supplypod_loading"
	var/loading_id = ""
	// NOVA EDIT START - Dynamic lights on CentCom
	static_lighting = FALSE
	base_lighting_color = COLOR_WHITE
	base_lighting_alpha = 255
	// NOVA EDIT END

/area/centcom/central_command_areas/supplypod/loading/Initialize(mapload)
	. = ..()
	if(!loading_id)
		CRASH("[type] created without a loading_id")
	if(GLOB.supplypod_loading_bays[loading_id])
		CRASH("Duplicate loading bay area: [type] ([loading_id])")
	GLOB.supplypod_loading_bays[loading_id] = src

/area/centcom/central_command_areas/supplypod/loading/one
	name = "一号舱位"
	loading_id = "1"

/area/centcom/central_command_areas/supplypod/loading/two
	name = "二号舱位"
	loading_id = "2"

/area/centcom/central_command_areas/supplypod/loading/three
	name = "三号舱位"
	loading_id = "3"

/area/centcom/central_command_areas/supplypod/loading/four
	name = "4号泊位"
	loading_id = "4"

/area/centcom/central_command_areas/supplypod/loading/ert
	name = "ERT泊位"
	loading_id = "5"

//THUNDERDOME
/area/centcom/tdome
	name = "雷霆穹顶"
	icon_state = "thunder"

/area/centcom/tdome/arena
	name = "雷霆穹顶竞技场"
	icon_state = "thunder"
	area_flags = parent_type::area_flags | UNLIMITED_FISHING //for possible testing purposes

/area/centcom/tdome/tdome1
	name = "雷霆穹顶（队伍1）"
	icon_state = "thunder_team_one"

/area/centcom/tdome/tdome2
	name = "雷霆穹顶（队伍2）"
	icon_state = "thunder_team_two"

/area/centcom/tdome/administration
	name = "雷霆穹顶管理区"
	icon_state = "thunder_admin"

/area/centcom/tdome/observation
	name = "雷霆穹顶观察区"
	icon_state = "thunder_observe"

// ENEMY

// Wizard
/area/centcom/wizard_station
	name = "巫师巢穴"
	icon_state = "wizards_den"
	static_lighting = TRUE
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	area_flags = NOTELEPORT
	flags_1 = NONE

//Abductors
/area/centcom/abductor_ship
	name = "绑架者飞船"
	icon_state = "abductor_ship"
	requires_power = FALSE
	area_flags = NOTELEPORT
	static_lighting = FALSE
	base_lighting_alpha = 255
	default_gravity = STANDARD_GRAVITY
	flags_1 = NONE

//Syndicates
/area/centcom/syndicate_mothership
	name = "辛迪加母舰"
	icon_state = "syndie-ship"
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	area_flags = NOTELEPORT
	flags_1 = NONE
	ambience_index = AMBIENCE_DANGER

/area/centcom/syndicate_mothership/control
	name = "辛迪加控制室"
	icon_state = "syndie-control"
	static_lighting = TRUE

/area/centcom/syndicate_mothership/expansion_bombthreat
	name = "辛迪加军械实验室"
	icon_state = "syndie-elite"
	static_lighting = TRUE
	ambience_index = AMBIENCE_ENGI

/area/centcom/syndicate_mothership/expansion_bioterrorism
	name = "辛迪加生物武器实验室"
	icon_state = "syndie-elite"
	static_lighting = TRUE
	ambience_index = AMBIENCE_MEDICAL

/area/centcom/syndicate_mothership/expansion_chemicalwarfare
	name = "辛迪加化学武器制造厂"
	icon_state = "syndie-elite"
	static_lighting = TRUE
	ambience_index = AMBIENCE_REEBE

/area/centcom/syndicate_mothership/expansion_fridgerummage
	name = "辛迪加易腐品与食品储藏室"
	icon_state = "syndie-elite"
	static_lighting = TRUE

/area/centcom/syndicate_mothership/elite_squad
	name = "辛迪加精英小队"
	icon_state = "syndie-elite"

/area/centcom/syndicate_mothership/expansion_custodialcloset
	name = "辛迪加保洁间"
	icon_state = "syndie-elite"

//MAFIA
/area/centcom/mafia
	name = "黑手党小游戏"
	icon_state = "mafia"
	static_lighting = FALSE
	base_lighting_alpha = 255
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = BLOCK_SUICIDE

//CAPTURE THE FLAG
/area/centcom/ctf
	name = "夺旗模式"
	icon_state = "ctf"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_alpha = 255
	default_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = NOTELEPORT | NO_DEATH_MESSAGE | BLOCK_SUICIDE

/area/centcom/ctf/control_room
	name = "控制室 A"
	icon_state = "ctf_room_a"

/area/centcom/ctf/control_room2
	name = "控制室 B"
	icon_state = "ctf_room_b"

/area/centcom/ctf/central
	name = "中央区域"
	icon_state = "ctf_central"

/area/centcom/ctf/main_hall
	name = "主厅 A"
	icon_state = "ctf_hall_a"

/area/centcom/ctf/main_hall2
	name = "主厅 B"
	icon_state = "ctf_hall_b"

/area/centcom/ctf/corridor
	name = "走廊 A"
	icon_state = "ctf_corr_a"

/area/centcom/ctf/corridor2
	name = "走廊 B"
	icon_state = "ctf_corr_b"

/area/centcom/ctf/flag_room
	name = "旗帜室 A"
	icon_state = "ctf_flag_a"

/area/centcom/ctf/flag_room2
	name = "旗帜室 B"
	icon_state = "ctf_flag_b"

// Asteroid area stuff
/area/centcom/asteroid
	name = "\improper 小行星"
	icon_state = "asteroid"
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_MINING
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_ASTEROID

/area/centcom/asteroid/nearstation
	static_lighting = TRUE
	ambience_index = AMBIENCE_RUINS
	always_unpowered = FALSE
	requires_power = TRUE
	area_flags = BLOBS_ALLOWED

/area/centcom/asteroid/nearstation/bomb_site
	name = "\improper 炸弹测试小行星"
