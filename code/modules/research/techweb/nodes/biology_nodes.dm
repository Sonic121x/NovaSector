/datum/techweb_node/bio_scan
	id = TECHWEB_NODE_BIO_SCAN
	display_name = "Biological Scan"
	description = "用于分析患者健康状况与试剂成分的先进技术，确保医疗舱内的精准诊断与治疗。"
	prereq_ids = list(TECHWEB_NODE_MEDBAY_EQUIP)
	design_ids = list(
		"healthanalyzer",
		"autopsyscanner",
		"genescanner",
		"medical_kiosk",
		"chem_master",
		"ph_meter",
		"scigoggles",
		"mod_reagent_scanner",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cytology
	id = TECHWEB_NODE_CYTOLOGY
	display_name = "Cytology"
	description = "专注于从细胞培育肢体与多种生物体的细胞生物学研究。"
	prereq_ids = list(TECHWEB_NODE_BIO_SCAN)
	design_ids = list(
		"limbgrower",
		"pandemic",
		"vatgrower",
		"petri_dish",
		"swab",
		"biopsy_tool",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/xenobiology
	id = TECHWEB_NODE_XENOBIOLOGY
	display_name = "Xenobiology"
	description = "探索非人类生物学，揭示外星生命形式及其独特生物过程的奥秘。"
	prereq_ids = list(TECHWEB_NODE_CYTOLOGY)
	design_ids = list(
		"xenobioconsole",
		"slime_scanner",
		"limbdesign_ethereal",
		"limbdesign_felinid",
		"limbdesign_lizard",
		"limbdesign_plasmaman",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	discount_experiments = list(/datum/experiment/scanning/cytology/slime = TECHWEB_TIER_3_POINTS)

/datum/techweb_node/gene_engineering
	id = TECHWEB_NODE_GENE_ENGINEERING
	display_name = "Gene Engineering"
	description = "研究复杂的DNA操纵技术，能够修改人类遗传特征以解锁特定能力与增强。"
	prereq_ids = list(TECHWEB_NODE_SELECTION, TECHWEB_NODE_XENOBIOLOGY)
	design_ids = list(
		"dnascanner",
		"scan_console",
		"dna_disk",
		"dnainfuser",
		"mod_dna_lock",
		"fleshreshaper",
		"fleshreshapermed",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	discount_experiments = list(/datum/experiment/scanning/people/mutant = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

// Botany root node
/datum/techweb_node/botany_equip
	id = TECHWEB_NODE_BOTANY_EQUIP
	starting_node = TRUE
	display_name = "Botany Equipment"
	description = "维护舰载花园、支持植物在空间站独特环境中生长的必备工具。"
	design_ids = list(
		"seed_extractor",
		"plant_analyzer",
		"watering_can",
		"spade",
		"cultivator",
		"secateurs",
		"hatchet",
	)

/datum/techweb_node/hydroponics
	id = TECHWEB_NODE_HYDROPONICS
	display_name = "Hydroponics"
	description = "研究先进的水培系统，以实现高效且可持续的植物栽培。"
	prereq_ids = list(TECHWEB_NODE_BOTANY_EQUIP, TECHWEB_NODE_CHEM_SYNTHESIS)
	design_ids = list(
		"biogenerator",
		"hydro_tray",
		"portaseeder",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE)

/datum/techweb_node/selection
	id = TECHWEB_NODE_SELECTION
	display_name = "Artificial Selection"
	description = "通过人工选择推进植物栽培技术，实现对植物DNA的精确操控。"
	prereq_ids = list(TECHWEB_NODE_HYDROPONICS)
	design_ids = list(
		"flora_gun",
		"gene_shears",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/scanning/random/plants/wild)
	discount_experiments = list(/datum/experiment/scanning/random/plants/traits = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE)
