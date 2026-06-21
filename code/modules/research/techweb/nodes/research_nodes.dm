/datum/techweb_node/fundamental_sci
	id = TECHWEB_NODE_FUNDIMENTAL_SCI
	starting_node = TRUE
	display_name = "Fundamental Science"
	description = "奠定科学理解的基石，为更深入的探索和理论研究铺平道路。"
	design_ids = list(
		"rdserver",
		"rdservercontrol",
		"rdconsole",
		"tech_disk",
		"doppler_array",
		"experimentor",
		"destructive_analyzer",
		"destructive_scanner",
		"experi_scanner",
		"laptop",
		"portadrive_basic",
		"portadrive_advanced",
		"portadrive_super",
	)

/datum/techweb_node/bluespace_theory
	id = TECHWEB_NODE_BLUESPACE_THEORY
	display_name = "Bluespace Theory"
	description = "对被称为蓝空的神秘异次元维度进行基础研究。"
	prereq_ids = list(TECHWEB_NODE_FUNDIMENTAL_SCI)
	design_ids = list(
		"bluespace_crystal",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/applied_bluespace
	id = TECHWEB_NODE_APPLIED_BLUESPACE
	display_name = "Applied Bluespace Research"
	description = "随着对蓝空动力学理解的加深，可以利用蓝空晶体分析数据设计出复杂的应用和技术。"
	prereq_ids = list(TECHWEB_NODE_BLUESPACE_THEORY)
	design_ids = list(
		"ore_silo",
		"minerbag_holding",
		"plumbing_receiver",
		"bluespacebeaker",
		"adv_watering_can",
		"bluespace_coffeepot",
		"bluespacesyringe",
		"blutrash",
		"light_replacer_blue",
		"bluespacebodybag",
		"gigabeacon",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/bluespace_crystal = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/bluespace_travel
	id = TECHWEB_NODE_BLUESPACE_TRAVEL
	display_name = "Bluespace Travel"
	description = "基于蓝空原理促进传送方法，以革新物流效率。"
	prereq_ids = list(TECHWEB_NODE_APPLIED_BLUESPACE)
	design_ids = list(
		"teleconsole",
		"tele_station",
		"tele_hub",
		"launchpad_console",
		"quantumpad",
		"launchpad",
		"bluespace_pod",
		"quantum_keycard",
		"swapper",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/anomaly_research
	id = TECHWEB_NODE_ANOMALY_RESEARCH
	display_name = "Anomaly Research"
	description = "深入研究神秘异常现象，探索精炼并利用其不可预测能量的方法。"
	prereq_ids = list(TECHWEB_NODE_APPLIED_BLUESPACE)
	design_ids = list(
		"anomaly_refinery",
		"anomaly_neutralizer",
		"reactive_armour",
		"space_furnace",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/anomaly_shells
	id = TECHWEB_NODE_ANOMALY_SHELLS
	display_name = "Advanced Anomaly Shells"
	description = "旨在利用异常核心的新外壳设计，以创新的方式最大化其潜力。"
	prereq_ids = list(TECHWEB_NODE_ANOMALY_RESEARCH)
	design_ids = list(
		"bag_holding",
		"cybernetic_heart_anomalock",
		"mod_storage_holding",
		"wormholeprojector",
		"gravitygun",
		"polymorph_belt",
		"perceptomatrix",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/anomalies = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)
