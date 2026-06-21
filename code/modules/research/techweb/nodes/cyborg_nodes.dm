/datum/techweb_node/augmentation
	id = TECHWEB_NODE_AUGMENTATION
	starting_node = TRUE
	display_name = "Augmentation"
	description = "献给那些偏爱闪亮金属胜过柔软血肉的人。"
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"borg_chest",
		"borg_head",
		"borg_l_arm",
		"borg_l_leg",
		"borg_r_arm",
		"borg_r_leg",
		"borg_suit",
		"cybernetic_eyes",
		"cybernetic_eyes_moth",
		"cybernetic_ears",
		"cybernetic_ears_cat",
		"cybernetic_lungs",
		"cybernetic_stomach",
		"cybernetic_liver",
		"cybernetic_heart",
	)
	experiments_to_unlock = list(
		/datum/experiment/scanning/people/android,
	)

/datum/techweb_node/cybernetics
	id = TECHWEB_NODE_CYBERNETICS
	display_name = "Cybernetics"
	description = "具有预载工具模块和可编程定律的智慧机器人。"
	prereq_ids = list(TECHWEB_NODE_AUGMENTATION)
	design_ids = list(
		"robocontrol",
		"borgupload",
		"cyborgrecharger",
		"mmi_posi",
		"mmi",
		"mmi_m",
		"advanced_l_arm",
		"advanced_r_arm",
		"advanced_l_leg",
		"advanced_r_leg",
		"borg_upgrade_rename",
		"borg_upgrade_restart",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/borg_service
	id = TECHWEB_NODE_BORG_SERVICES
	display_name = "Service Cyborg Upgrades"
	description = "让他们按部就班地做饭。"
	prereq_ids = list(TECHWEB_NODE_CYBERNETICS)
	design_ids = list(
		"borg_upgrade_rolling_table",
		"borg_upgrade_condiment_synthesizer",
		"borg_upgrade_silicon_knife",
		"borg_upgrade_service_apparatus",
		"borg_upgrade_drink_apparatus",
		"borg_upgrade_service_cookbook",
		"borg_upgrade_botany",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/borg_mining
	id = TECHWEB_NODE_BORG_MINING
	display_name = "Mining Cyborg Upgrades"
	description = "用于开采对人类来说过于危险的地方。"
	prereq_ids = list(TECHWEB_NODE_CYBERNETICS)
	design_ids = list(
		"borg_upgrade_lavaproof",
		"borg_upgrade_holding",
		"borg_upgrade_diamonddrill",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/borg_medical
	id = TECHWEB_NODE_BORG_MEDICAL
	display_name = "Medical Cyborg Upgrades"
	description = "让他们遵循阿西莫夫第一定律。"
	prereq_ids = list(TECHWEB_NODE_BORG_SERVICES, TECHWEB_NODE_SURGERY_ADV)
	design_ids = list(
		"borg_upgrade_pinpointer",
		"borg_upgrade_beakerapp",
		"borg_upgrade_defibrillator",
		"borg_upgrade_expandedsynthesiser",
		"borg_upgrade_piercinghypospray",
		"borg_upgrade_surgicalprocessor",
		"borg_upgrade_surgicalomnitool",
		"borg_upgrade_syringe",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/borg_utility
	id = TECHWEB_NODE_BORG_UTILITY
	display_name = "Utility Cyborg Upgrades"
	description = "让他们替我们擦地板。"
	prereq_ids = list(TECHWEB_NODE_BORG_SERVICES, TECHWEB_NODE_SANITATION)
	design_ids = list(
		"borg_upgrade_advancedmop",
		"borg_upgrade_broomer",
		"borg_upgrade_expand",
		"borg_upgrade_prt",
		"borg_upgrade_plunger",
		"borg_upgrade_high_capacity_replacer",
		"borg_upgrade_selfrepair",
		"borg_upgrade_thrusters",
		"borg_upgrade_trashofholding",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/borg_utility/New()
	. = ..()
	if(!CONFIG_GET(flag/disable_secborg))
		design_ids += "borg_upgrade_disablercooler"

/datum/techweb_node/borg_engi
	id = TECHWEB_NODE_BORG_ENGI
	display_name = "Engineering Cyborg Upgrades"
	description = "为了更加偷懒。"
	prereq_ids = list(TECHWEB_NODE_BORG_MINING, TECHWEB_NODE_PARTS_UPG)
	design_ids = list(
		//"borg_upgrade_rped", // NOVA EDIT REMOVAL: Added to starting modules.
		"borg_upgrade_engineeringomnitool",
		"borg_upgrade_engineeringapp",
		"borg_upgrade_inducer",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

// Implants root node
/datum/techweb_node/passive_implants
	id = TECHWEB_NODE_PASSIVE_IMPLANTS
	display_name = "Passive Implants"
	description = "这些植入体设计为无需用户主动输入即可无缝运作，增强各种生理功能或提供持续益处。"
	prereq_ids = list(TECHWEB_NODE_AUGMENTATION)
	design_ids = list(
		"skill_station",
		"implant_trombone",
		"implant_chem",
		"implant_tracking",
		"implant_exile",
		"implant_beacon",
		"implant_bluespace",
		"implantcase",
		"implanter",
		"locator",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cyber/cyber_implants
	id = TECHWEB_NODE_CYBER_IMPLANTS
	display_name = "Cybernetic Implants"
	description = "集成到身体中的先进技术增强装置，提供改进的物理能力。"
	prereq_ids = list(TECHWEB_NODE_PASSIVE_IMPLANTS, TECHWEB_NODE_CYBERNETICS)
	design_ids = list(
		"ci-breather",
		"ci-nutriment",
		"ci-thrusters",
		"ci-herculean",
		"ci-connector",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cyber/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		research_costs[TECHWEB_POINT_TYPE_GENERIC] /= 2

/datum/techweb_node/cyber/combat_implants
	id = TECHWEB_NODE_COMBAT_IMPLANTS
	display_name = "Combat Implants"
	description = "确保你能他妈的醒过来，武士。"
	prereq_ids = list(TECHWEB_NODE_CYBER_IMPLANTS)
	design_ids = list(
		"ci-reviver",
		"ci-antidrop",
		"ci-antistun",
		"ci-tacvisor",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cyber/integrated_toolsets
	id = TECHWEB_NODE_INTERGRATED_TOOLSETS
	display_name = "Integrated Toolsets"
	description = "助手们数十年的违禁品走私，促成了能无缝融入你手臂的完整工具箱的开发。"
	prereq_ids = list(TECHWEB_NODE_COMBAT_IMPLANTS, TECHWEB_NODE_EXP_TOOLS)
	design_ids = list(
		"ci-nutrimentplus",
		"ci-surgery",
		"ci-surgery-brain",
		"ci-toolset",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cyber/cyber_organs
	id = TECHWEB_NODE_CYBER_ORGANS
	display_name = "Cybernetic Organs"
	description = "我们拥有重建他的技术。"
	prereq_ids = list(TECHWEB_NODE_CYBERNETICS)
	design_ids = list(
		"cybernetic_eyes_improved",
		"cybernetic_eyes_improved_moth",
		"cybernetic_ears_u",
		"cybernetic_ears_u_cat",
		"cybernetic_lungs_tier2",
		"cybernetic_stomach_tier2",
		"cybernetic_liver_tier2",
		"cybernetic_heart_tier2",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cyber/cyber_organs_upgraded
	id = TECHWEB_NODE_CYBER_ORGANS_UPGRADED
	display_name = "Upgraded Cybernetic Organs"
	description = "我们拥有升级他的技术。"
	prereq_ids = list(TECHWEB_NODE_CYBER_ORGANS)
	design_ids = list(
		"ci-gloweyes",
		"ci-welding",
		"ci-gloweyes-moth",
		"ci-welding-moth",
		"cybernetic_ears_whisper",
		"cybernetic_ears_whisper_cat",
		"cybernetic_ears_volume",
		"cybernetic_ears_volume_cat",
		"cybernetic_lungs_tier3",
		"cybernetic_stomach_tier3",
		"cybernetic_liver_tier3",
		"cybernetic_heart_tier3",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/scanning/people/augmented_organs)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cyber/cyber_organs_adv
	id = TECHWEB_NODE_CYBER_ORGANS_ADV
	display_name = "Advanced Cybernetic Organs"
	description = "提供增强感官能力的尖端赛博器官，让检测ERP比以往任何时候都更容易。"
	prereq_ids = list(TECHWEB_NODE_CYBER_ORGANS_UPGRADED, TECHWEB_NODE_NIGHT_VISION)
	design_ids = list(
		"cybernetic_ears_xray",
		"cybernetic_ears_xray_cat",
		"ci-thermals",
		"ci-xray",
		"ci-thermals-moth",
		"ci-xray-moth",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	discount_experiments = list(/datum/experiment/scanning/people/android = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)
