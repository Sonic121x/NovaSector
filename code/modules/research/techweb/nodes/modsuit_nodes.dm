/datum/techweb_node/mod_suit
	id = TECHWEB_NODE_MOD_SUIT
	starting_node = TRUE
	display_name = "Modular Suits"
	description = "配备各种不同模块的专用背装动力服。"
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"suit_storage_unit",
		"mod_shell",
		"mod_chestplate",
		"mod_helmet",
		"mod_gauntlets",
		"mod_boots",
		"mod_plating_standard",
		"mod_plating_civilian",
		"mod_paint_kit",
		"mod_storage",
		"mod_plasma",
		"mod_flashlight",
	)

/datum/techweb_node/mod_equip
	id = TECHWEB_NODE_MOD_EQUIP
	display_name = "Modular Suit Equipment"
	description = "更先进的模块，用于改进模块化套装。"
	prereq_ids = list(TECHWEB_NODE_MOD_SUIT)
	design_ids = list(
		"modlink_scryer",
		"mod_tether",
		"mod_welding",
		"mod_longfall",
		"mod_thermal_regulator",
		"mod_sign_radio",
		"mod_storage_expanded",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/mod_service
	id = TECHWEB_NODE_MOD_SERVICE
	display_name = "Civilian Modular Suits"
	description = "为体面生活设计的民用模块化套装。"
	prereq_ids = list(TECHWEB_NODE_MOD_SUIT)
	design_ids = list(
		"mod_clamp",
		"mod_safety",
		"mod_mouthhole",
		"mod_mister_janitor",
		"mod_plating_portable_suit"
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS / 2)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SERVICE)

/datum/techweb_node/mod_entertainment
	id = TECHWEB_NODE_MOD_ENTERTAINMENT
	display_name = "Entertainment Modular Suits"
	description = "为低幽默环境提供防护的动力服。"
	prereq_ids = list(TECHWEB_NODE_MOD_SUIT)
	design_ids = list(
		"mod_plating_cosmohonk",
		"mod_bikehorn",
		"mod_microwave_beam",
		"mod_waddle",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SERVICE)

/datum/techweb_node/mod_medical
	id = TECHWEB_NODE_MOD_MEDICAL
	display_name = "Medical Modular Suits"
	description = "用于快速救援的医疗模块化套装。"
	prereq_ids = list(TECHWEB_NODE_MOD_SUIT, TECHWEB_NODE_CHEM_SYNTHESIS)
	design_ids = list(
		"mod_plating_medical",
		"mod_quick_carry",
		"mod_injector",
		"mod_organizer",
		"mod_patienttransport",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/mod_engi
	id = TECHWEB_NODE_MOD_ENGI
	display_name = "Engineering Modular Suits"
	description = "工程套装，为动力工程师设计。"
	prereq_ids = list(TECHWEB_NODE_MOD_EQUIP)
	design_ids = list(
		"mod_plating_engineering",
		"mod_t_ray",
		"mod_magboot",
		"mod_constructor",
		"mod_mister_atmos",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/mod_security
	id = TECHWEB_NODE_MOD_SECURITY
	display_name = "Security Modular Suits"
	description = "用于处理太空犯罪的安保套装。"
	prereq_ids = list(TECHWEB_NODE_MOD_EQUIP)
	design_ids = list(
		"mod_mirage_grenade",
		"mod_stealth",
		"mod_mag_harness",
		"mod_pathfinder",
		"mod_holster",
		"mod_sonar",
		"mod_projectile_dampener",
		"mod_criminalcapture",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY)

/datum/techweb_node/mod_medical_adv
	id = TECHWEB_NODE_MOD_MEDICAL_ADV
	display_name = "Field Surgery Modules"
	description = "专为在野外条件下进行外科手术而设计的医疗模块化套装设备。"
	prereq_ids = list(TECHWEB_NODE_MOD_MEDICAL, TECHWEB_NODE_SURGERY_ADV)
	design_ids = list(
		"mod_defib",
		"mod_threadripper",
		"mod_surgicalprocessor",
		"mod_statusreadout",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/mod_engi_adv
	id = TECHWEB_NODE_MOD_ENGI_ADV
	display_name = "Advanced Engineering Modular Suits"
	description = "高级工程套装，为高级动力工程师设计。"
	prereq_ids = list(TECHWEB_NODE_MOD_ENGI)
	design_ids = list(
		"mod_plating_atmospheric",
		"mod_jetpack",
		"mod_rad_protection",
		"mod_emp_shield",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/mod_engi_adv/New()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_RADIOACTIVE_NEBULA)) //we'll really need the rad protection modsuit module
		starting_node = TRUE
	return ..()

/datum/techweb_node/mod_anomaly
	id = TECHWEB_NODE_MOD_ANOMALY
	display_name = "Anomalock Modular Suits"
	description = "需要异常核心才能运行的模块化套装模块。"
	prereq_ids = list(TECHWEB_NODE_MOD_ENGI_ADV, TECHWEB_NODE_ANOMALY_RESEARCH)
	design_ids = list(
		"mod_antigrav",
		"mod_teleporter",
		"mod_kinesis",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)
