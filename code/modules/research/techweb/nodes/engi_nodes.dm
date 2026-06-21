// Parts root node
/datum/techweb_node/parts
	id = TECHWEB_NODE_PARTS
	starting_node = TRUE
	display_name = "Essential Stock Parts"
	description = "构成空间站运作基础的核心组件，涵盖日常功能所需的一系列基本设备。"
	design_ids = list(
		"micro_servo",
		"basic_battery",
		"basic_capacitor",
		"basic_cell",
		"basic_matter_bin",
		"basic_micro_laser",
		"basic_scanning",
		"high_battery",
		"high_cell",
		"miniature_power_cell",
		"condenser",
		"igniter",
		"infrared_emitter",
		"prox_sensor",
		"signaler",
		"timer",
		"voice_analyzer",
		"health_sensor",
		"sflash",
	)

/datum/techweb_node/parts_upg
	id = TECHWEB_NODE_PARTS_UPG
	display_name = "Upgraded Parts"
	description = "提供超越其基础对应物的增强能力。"
	prereq_ids = list(TECHWEB_NODE_PARTS, TECHWEB_NODE_ENERGY_MANIPULATION)
	design_ids = list(
		"rped",
		"high_micro_laser",
		"adv_capacitor",
		"nano_servo",
		"adv_matter_bin",
		"adv_scanning",
		"super_battery",
		"super_cell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/parts_adv
	id = TECHWEB_NODE_PARTS_ADV
	display_name = "Advanced Parts"
	description = "最精细调校且精确的标准部件。"
	prereq_ids = list(TECHWEB_NODE_PARTS_UPG)
	design_ids = list(
		"ultra_micro_laser",
		"super_capacitor",
		"pico_servo",
		"super_matter_bin",
		"phasic_scanning",
		"hyper_battery",
		"hyper_cell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier2_any = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)


/datum/techweb_node/parts_bluespace
	id = TECHWEB_NODE_PARTS_BLUESPACE
	display_name = "Bluespace Parts"
	description = "整合了最新的蓝空技术，这些先进组件不仅增强了功能，还为空间站的技术能力开辟了新的可能性。"
	prereq_ids = list(TECHWEB_NODE_PARTS_ADV, TECHWEB_NODE_BLUESPACE_TRAVEL)
	design_ids = list(
		"bs_rped",
		"quadultra_micro_laser",
		"quadratic_capacitor",
		"femto_servo",
		"bluespace_matter_bin",
		"triphasic_scanning",
		"bluespace_battery",
		"bluespace_cell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_any = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/telecomms
	id = TECHWEB_NODE_TELECOMS
	display_name = "Telecommunications Technology"
	description = "一套用于全站通信设置的综合性设备，确保无缝连接和操作协调。"
	prereq_ids = list(TECHWEB_NODE_PARTS_BLUESPACE)
	design_ids = list(
		"comm_monitor",
		"comm_server",
		"message_monitor",
		"ntnet_relay",
		"s_hub",
		"s_messaging",
		"s_server",
		"s_processor",
		"s_relay",
		"s_bus",
		"s_broadcaster",
		"s_receiver",
		"s_amplifier",
		"s_analyzer",
		"s_ansible",
		"s_crystal",
		"s_filter",
		"s_transmitter",
		"s_treatment",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)

// Engineering root node
/datum/techweb_node/construction
	id = TECHWEB_NODE_CONSTRUCTION
	starting_node = TRUE
	display_name = "Construction"
	description = "用于空间站维护和扩展的工具与基本机械。"
	design_ids = list(
		"circuit_imprinter_offstation",
		"circuit_imprinter",
		"solarcontrol",
		"solar_panel",
		"solar_tracker",
		"power_control",
		"airalarm_electronics",
		"airlock_board",
		"firealarm_electronics",
		"firelock_board",
		"trapdoor_electronics",
		"blast",
		"ignition",
		"big_manipulator",
		"airlock_painter",
		"decal_painter",
		"rwd",
		"cable_coil",
		"welding_helmet",
		"welding_tool",
		"mini_welding_tool",
		"tscanner",
		"multitool",
		"wrench",
		"crowbar",
		"screwdriver",
		"wirecutters",
		"light_bulb",
		"light_tube",
		"crossing_signal",
		"guideway_sensor",
		"manuunloader",
		"manusmelter",
		"manucrusher",
		"manucrafter",
		"manulathe",
		"manusorter",
		"manurouter",
		"mailsorter",
	)

/datum/techweb_node/energy_manipulation
	id = TECHWEB_NODE_ENERGY_MANIPULATION
	display_name = "Energy Manipulation"
	description = "通过复杂的能量控制方法驾驭闪电弧的原始力量。"
	prereq_ids = list(TECHWEB_NODE_CONSTRUCTION)
	design_ids = list(
		"apc_control",
		"powermonitor",
		"smes",
		"portable_smes",
		"power_connector",
		"emitter",
		"grounding_rod",
		"tesla_coil",
		"cell_charger",
		"recharger",
		"inducer",
		"inducerengi",
		"welding_goggles",
		"tray_goggles",
		"geigercounter",
		"diode_disk_stamina"
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/shuttle_engineering
	id = TECHWEB_NODE_SHUTTLE_ENG
	display_name = "Shuttle Engineering"
	description = "用于建造穿梭机的材料和设备"
	prereq_ids = list(TECHWEB_NODE_ENERGY_MANIPULATION, TECHWEB_NODE_APPLIED_BLUESPACE)
	design_ids = list(
		"borg_upgrade_engineering_shuttle_blueprints",
		"propulsion_engine",
		"shuttle_blueprints",
		"shuttle_control",
		"shuttle_docker",
		"shuttlerods",
		"shuttle_remote",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/holographics
	id = TECHWEB_NODE_HOLOGRAPHICS
	display_name = "Holographics"
	description = "将全息技术用于标识和屏障。"
	prereq_ids = list(TECHWEB_NODE_ENERGY_MANIPULATION)
	design_ids = list(
		"atmosshieldgen",
		"forcefield_projector",
		"holosign",
		"holosignsec",
		"holosignengi",
		"holosignatmos",
		"holosignrestaurant",
		"holosignbar",
		"holobarrier_jani",
		"holobarrier_med",
		"holopad",
		"holodisk",
		"modular_shield_gate",
		"modular_shield_generator",
		"modular_shield_node",
		"modular_shield_cable",
		"modular_shield_relay",
		"modular_shield_charger",
		"modular_shield_well",
		"modular_shield_console",
		"diode_disk_magnetic",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/hud
	id = TECHWEB_NODE_HUD
	display_name = "Integrated HUDs"
	description = "最初为助手开发，旨在通过增强现实学习不同职业的细微差别。"
	prereq_ids = list(TECHWEB_NODE_HOLOGRAPHICS, TECHWEB_NODE_CYBER_IMPLANTS)
	design_ids = list(
		"health_hud",
		"diagnostic_hud",
		"security_hud",
		"mod_visor_medhud",
		"mod_visor_diaghud",
		"mod_visor_sechud",
		"ci-medhud",
		"ci-diaghud",
		"ci-sechud",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/night_vision
	id = TECHWEB_NODE_NIGHT_VISION
	display_name = "Night Vision Technology"
	description = "有传言称，纳米传讯推动这项技术是为了延长轮班时间，确保全天候的生产力。"
	prereq_ids = list(TECHWEB_NODE_HUD)
	design_ids = list(
		"diagnostic_hud_night",
		"health_hud_night",
		"night_visision_goggles",
		"nvgmesons",
		"nv_scigoggles",
		"security_hud_night",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)
