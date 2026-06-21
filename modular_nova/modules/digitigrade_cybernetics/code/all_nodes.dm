//digitigrade research

/datum/techweb_node/digitigrade_cyber
	id = TECHWEB_NODE_CYBERNETICS_DIGITIGRADE
	display_name = "Digitigrade Cybernetics"
	description = "特化的赛博格肢体设计。股骨的缩短无疑是机械优化的结果。"
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"digitigrade_cyber_l_leg",
		"digitigrade_cyber_r_leg",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)


/datum/techweb_node/adv_digitigrade_cyber
	id = TECHWEB_NODE_CYBERNETICS_DIGITIGRADE_ADVANCED
	display_name = "Advanced Digitigrade Cybernetics"
	description = "比消费级趾行模型更胜一筹，它们拥有自磨锐的爪子，能更快地毁掉你的鞋履。"
	prereq_ids = list(TECHWEB_NODE_AUGMENTATION)
	design_ids = list(
		"digitigrade_advanced_l_leg",
		"digitigrade_advanced_r_leg",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)
