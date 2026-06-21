/datum/techweb_node/robotics
	id = TECHWEB_NODE_ROBOTICS
	starting_node = TRUE
	display_name = "Robotics"
	description = "可编程的机器，让我们的生活变得更懒散。"
	design_ids = list(
		"botnavbeacon",
		"mechfab",
		"paicard",
	)

/datum/techweb_node/exodrone
	id = TECHWEB_NODE_EXODRONE
	display_name = "Exploration Drones"
	description = "改造街机，暗中利用玩家的技能来控制真实无人机，用于实际目的。"
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"exodrone_console",
		"exodrone_launcher",
		"exoscanner",
		"exoscanner_console",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)

// AI root node
/datum/techweb_node/ai
	id = TECHWEB_NODE_AI
	display_name = "Artificial Intelligence"
	description = "探索人工智能系统，其智能程度超过全体船员的总和。"
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"aicore",
		"aifixer",
		"aiupload",
		"asimov_module",
		"borg_ai_control",
		"corporate_module",
		"default_module",
		"drone_module",
		"freeform_module",
		"intellicard",
		"mecha_tracking_ai_control",
		"nutimov_module",
		"oxygen_module",
		"paladin_module",
		"protectstation_module",
		"quarantine_module",
		"remove_module",
		"reset_module",
		"robocop_module",
		"safeguard_module",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai/New()
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_HUMAN_AI))
		design_ids -= list(
			"aicore",
			"aifixer",
			"aiupload",
			"borg_ai_control",
			"intellicard",
			"mecha_tracking_ai_control",
		)
	else if(HAS_TRAIT(SSstation, STATION_TRAIT_UNIQUE_AI))
		research_costs[TECHWEB_POINT_TYPE_GENERIC] *= 3

/datum/techweb_node/ai_laws
	id = TECHWEB_NODE_AI_LAWS
	display_name = "Advanced AI Upgrades"
	description = "深入研究复杂的人工智能指令，希望它们不会导致人类的灭绝。"
	prereq_ids = list(TECHWEB_NODE_AI)
	design_ids = list(
		"ai_uplink_brain", // NOVA EDIT ADDITION
		"ai_power_upgrade",
		"antimov_module",
		"asimovpp_module",
		"balance_module",
		"damaged_module",
		"dungeon_master_module",
		"freeformcore_module",
		"hippocratic_module",
		"hulkamania_module",
		"liveandletlive_module",
		"maintain_module",
		"onehuman_module",
		"overlord_module",
		"painter_module",
		"paladin_devotion_module",
		"peacekeeper_module",
		"purge_module",
		"reporter_module",
		"ten_commandments_module",
		"thermurderdynamic_module",
		"thinkermov_module",
		"tyrant_module",
		"yesman_module",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_COMMAND)
