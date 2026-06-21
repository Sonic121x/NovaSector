/datum/techweb_node/cyber/cyber_implants/New()
	design_ids += list(
		"ci-scanner",
		"ci-botany",
		"ci-janitor",
		"ci-lighter",
		"ci-razor",
		"ci-drill",
		"combat_implant_sandy",
		"combat_implant_razorwire",
		"combat_implant_shell_launcher",
	)
	// thrusters in combat_implants
	design_ids -= list(
		"ci-thrusters",
	)
	return ..()

/datum/techweb_node/cyber/combat_implants/New()
	design_ids += list(
		"ci-mantis",
		"ci-flash",
		"ci-thrusters",
		"ci-antisleep",
	)
	return ..()

/datum/techweb_node/cyber/night_vision_implants
	id = TECHWEB_NODE_NIGHT_VISION_IMPLANTS
	display_name = "Night Vision Implants"
	description = "现在你可以整夜工作，即使丢了眼镜也没关系！"
	prereq_ids = list(TECHWEB_NODE_NIGHT_VISION, TECHWEB_NODE_CYBER_IMPLANTS)
	design_ids = list(
		"ci-nv",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cyber/implants_nova
	id = TECHWEB_NODE_CYBERNETICS_ILLEGAL_NOVA
	display_name = "Illegal Cybernetics Implants"
	description = "那么，假设我们不在乎那些形式上的伦理规范……"
	prereq_ids = list(TECHWEB_NODE_COMBAT_IMPLANTS)
	design_ids = list(
		"combat_implant_hackerman",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/mining_adv/New() //Here for the integrated drill augments.
	design_ids += list(
		"ci-drill-diamond",
	)
	return ..()
