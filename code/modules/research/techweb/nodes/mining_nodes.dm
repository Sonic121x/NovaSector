/datum/techweb_node/material_processing
	id = TECHWEB_NODE_MATERIAL_PROC
	starting_node = TRUE
	display_name = "Material Processing"
	description = "合金和矿石的提炼与加工，以增强其实用性和价值。"
	design_ids = list(
		"pickaxe",
		"shovel",
		"conveyor_switch",
		"conveyor_belt",
		"mass_driver",
		"recycler",
		"stack_machine",
		"stack_console",
		"autolathe",
		"rglass",
		"plasmaglass",
		"plasmareinforcedglass",
		"plasteel",
		"titaniumglass",
		"plastitanium",
		"plastitaniumglass",
	)

/datum/techweb_node/mining
	id = TECHWEB_NODE_MINING
	display_name = "Mining Technology"
	description = "旨在优化采矿作业和资源开采的工具开发。"
	prereq_ids = list(TECHWEB_NODE_MATERIAL_PROC)
	design_ids = list(
		"cargoexpress",
		"brm",
		"b_smelter",
		"b_refinery",
		"ore_redemption",
		"mining_equipment_vendor",
		"mining_scanner",
		"mech_mscanner",
		"superresonator",
		"mech_drill",
		"mod_drill",
		"drill",
		"mod_orebag",
		"beacon",
		"telesci_gps",
		"mod_gps",
		"mod_visor_meson",
		"mesons",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/low_pressure_excavation
	id = TECHWEB_NODE_LOW_PRESSURE_EXCAVATION
	display_name = "Low-Pressure Excavation"
	description = "对原动加速器（PKAs）的研究，这种气动枪以其在低压环境下的卓越性能而闻名。"
	prereq_ids = list(TECHWEB_NODE_MINING, TECHWEB_NODE_GAS_COMPRESSION)
	design_ids = list(
		"damagemod",
		"rangemod",
		"cooldownmod",
		"triggermod",
		"hypermod",
		"borg_upgrade_damagemod",
		"borg_upgrade_rangemod",
		"borg_upgrade_cooldownmod",
		"borg_upgrade_hypermod",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/plasma_mining
	id = TECHWEB_NODE_PLASMA_MINING
	display_name = "Plasma Beam Mining"
	description = "工程师的等离子焊枪在采矿作业中被证明非常有效。这促成了机甲搭载型号和增强型手持切割器的开发，供矿工使用。"
	prereq_ids = list(TECHWEB_NODE_LOW_PRESSURE_EXCAVATION, TECHWEB_NODE_PLASMA_CONTROL)
	design_ids = list(
		"mech_plasma_cutter",
		"plasmacutter_adv",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/bitrunning
	id = TECHWEB_NODE_BITRUNNING
	display_name = "Bitrunning Technology"
	description = "蓝空技术催生了量子级计算的发展，从而解锁了在执行高级程序时物质化原子结构的手段。"
	prereq_ids = list(TECHWEB_NODE_GAMING, TECHWEB_NODE_APPLIED_BLUESPACE)
	design_ids = list(
		"byteforge",
		"quantum_console",
		"netpod",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/mining_adv
	id = TECHWEB_NODE_MINING_ADV
	display_name = "Advanced Mining Technology"
	description = "高级采矿设备，将资源开采的效率和效能推向极限。"
	prereq_ids = list(TECHWEB_NODE_PLASMA_MINING)
	design_ids = list(
		"jackhammer",
		"drill_diamond",
		"mech_diamond_drill",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SUPPLY)
