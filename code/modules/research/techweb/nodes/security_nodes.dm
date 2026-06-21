/datum/techweb_node/basic_arms
	id = TECHWEB_NODE_BASIC_ARMS
	starting_node = TRUE
	display_name = "Basic Arms"
	description = "弹道学在太空中可能难以预测。"
	design_ids = list(
		"toy_armblade",
		"toygun",
		"c38_rubber",
		"c38_rubber_mag",
		"c38_sec",
		"c38_mag",
		"capbox",
		"foam_dart",
		"sec_beanbag_slug",
		"sec_dart",
		"sec_Islug",
		"sec_rshot",
		"s12g_br",
	)

/datum/techweb_node/sec_equip
	id = TECHWEB_NODE_SEC_EQUIP
	display_name = "Security Equipment"
	description = "制服一个默剧演员所需的一切必需品。"
	prereq_ids = list(TECHWEB_NODE_BASIC_ARMS)
	design_ids = list(
		"secdata",
		"mining",
		"prisonmanage",
		"rdcamera",
		"seccamera",
		"security_photobooth",
		"photobooth",
		"scanner_gate",
		"pepperspray",
		"dragnet_beacon",
		"inspector",
		"evidencebag",
		"zipties",
		"seclite",
		"electropack",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)


/datum/techweb_node/riot_supression
	id = TECHWEB_NODE_RIOT_SUPRESSION
	display_name = "Riot Supression"
	description = "当你站在革命运动的对立面时。"
	prereq_ids = list(TECHWEB_NODE_SEC_EQUIP)
	design_ids = list(
		"clown_firing_pin",
		"pin_testing",
		"pin_loyalty",
		"tele_shield",
		"ballistic_shield",
		"handcuffs_s",
		"bola_energy",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/explosives
	id = TECHWEB_NODE_EXPLOSIVES
	display_name = "Explosives"
	description = "这一次，是蓄意爆炸。"
	prereq_ids = list(TECHWEB_NODE_RIOT_SUPRESSION)
	design_ids = list(
		"large_grenade",
		"adv_grenade",
		"pyro_grenade",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/ordnance/explosive/lowyieldbomb)
	announce_channels = list(RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/exotic_ammo
	id = TECHWEB_NODE_EXOTIC_AMMO
	display_name = "Exotic Ammunition"
	description = "专门设计的子弹，能够点燃、冻结并对目标造成各种其他效果，扩展了战斗能力。"
	prereq_ids = list(TECHWEB_NODE_EXPLOSIVES)
	design_ids = list(
		"c38_hotshot",
		"c38_hotshot_mag",
		"c38_iceblox",
		"c38_iceblox_mag",
		"c38_trac",
		"c38_trac_mag",
		"c38_true_strike",
		"c38_true_strike_mag",
		"techshotshell",
		"flechetteshell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	discount_experiments = list(/datum/experiment/ordnance/explosive/highyieldbomb = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/electric_weapons
	id = TECHWEB_NODE_ELECTRIC_WEAPONS
	display_name = "Electric Weaponry"
	description = "基于能量的武器，设计用于致命和非致命应用。"
	prereq_ids = list(TECHWEB_NODE_RIOT_SUPRESSION)
	design_ids = list(
		"stunrevolver",
		"ioncarbine",
		"temp_gun",
		"lasershell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/beam_weapons
	id = TECHWEB_NODE_BEAM_WEAPONS
	display_name = "Advanced Beam Weaponry"
	description = "如此先进，连工程师都对它的运作原理感到困惑。"
	prereq_ids = list(TECHWEB_NODE_ELECTRIC_WEAPONS)
	design_ids = list(
		"xray_laser",
		"nuclear_gun",
		"c38_flare",
		"c38_flare_mag",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)
