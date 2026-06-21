/datum/techweb_node/misc_cargo
	id = TECHWEB_NODE_MISC_CARGO
	display_name = "Misc. Cargo Technology"
	description = "别哭了！包含大量货运难题的修正概念。能正确运送货物，同时流通，紧凑缓存。"
	prereq_ids = list(TECHWEB_NODE_BLUESPACE_THEORY)
	design_ids = list(
		"conveysorter",
		"cargotele",
		"goodycase_holder",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SUPPLY)
