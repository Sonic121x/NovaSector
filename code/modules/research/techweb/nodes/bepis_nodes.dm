//Nodes that are found inside Bepis Disks.

/datum/techweb_node/light_apps
	id = TECHWEB_NODE_LIGHT_APPS
	display_name = "Illumination Applications"
	description = "照明与视觉技术的应用，最初被认为不具备商业可行性。"
	design_ids = list(
		"bright_helmet",
		"rld_mini",
		"photon_cannon",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_COMMON)

/datum/techweb_node/extreme_office
	id = TECHWEB_NODE_EXTREME_OFFICE
	display_name = "Advanced Office Applications"
	description = "我们最聪明的实验室人员在某个周五聚在一起，将办公效率提高了350%。方法如下。"
	design_ids = list(
		"mauna_mug",
		"rolling_table",
		"plasticducky",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_COMMON)

/datum/techweb_node/spec_eng
	id = TECHWEB_NODE_SPEC_ENG
	display_name = "Specialized Engineering"
	description = "Conventional wisdom has deemed these engineering products 'technically' safe, but far too dangerous to traditionally condone."
	design_ids = list(
		"eng_gloves",
		"lava_rods",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

/datum/techweb_node/aus_security
	id = TECHWEB_NODE_AUS_SECURITY
	display_name = "Australicus Security Protocols"
	description = "It is said that security in the Australicus sector is tight, so we took some pointers from their equipment. Thankfully, our sector lacks any signs of these, 'dropbears'."
	design_ids = list(
		"pin_explorer",
		"stun_boomerang",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/interrogation
	id = TECHWEB_NODE_INTERROGATION
	display_name = "Enhanced Interrogation Technology"
	description = "By cross-referencing several declassified documents from past dictatorial regimes, we were able to develop an incredibly effective interrogation device. \
	Ethical concerns about loss of free will do not apply to criminals, according to galactic law."
	design_ids = list(
		"hypnochair",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/sticky_advanced
	id = TECHWEB_NODE_STICKY_ADVANCED
	display_name = "Advanced Sticky Technology"
	description = "把一个好玩笑玩过头了？胡说！"
	design_ids = list(
		"pointy_tape",
		"super_sticky_tape",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_COMMON)

/datum/techweb_node/tackle_advanced
	id = TECHWEB_NODE_TACKLE_ADVANCED
	display_name = "Advanced Grapple Technology"
	description = "Nanotrasen would like to remind its researching staff that it is never acceptable to \"glomp\" your coworkers, and further \"scientific trials\" on the subject \
	will no longer be accepted in its academic journals."
	design_ids = list(
		"tackle_dolphin",
		"tackle_rocket",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY)

/datum/techweb_node/mod_experimental
	id = TECHWEB_NODE_MOD_EXPERIMENTAL
	display_name = "Experimental Modular Suits"
	description = "在创建MOD防护服时应用实验性理念，创造了这些..."
	design_ids = list(
		"mod_disposal",
		"mod_joint_torsion",
		"mod_recycler",
		"mod_shooting",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_COMMON)

/datum/techweb_node/posisphere
	id = TECHWEB_NODE_POSITRONIC_SPHERE
	display_name = "Experimental Spherical Positronic Brain"
	description = "近期在成本削减措施上的进展，使我们能够将正电子脑立方体切割成成本减半的球体。不幸的是，这也让它们能够通过滚动在实验室里移动。"
	design_ids = list(
		"posisphere",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/donk_shell
	id = TECHWEB_NODE_DONK_PRODUCTS
	display_name = "Donk Co. Failed Products Schematics"
	description = "We don't want to know why you're filling up your databanks with known failed products from an enemy corporation. That's your choice. I'm just saying, don't come crying to us \
		when it turns out you've downloaded some kind of horrible donk-pocket related malware that steals your Starscape password. Those bastards over at Donk Co. WILL delete your character."
	design_ids = list(
		"donkshell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY)
