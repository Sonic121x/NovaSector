/datum/techweb_node/medbay_equip
	id = TECHWEB_NODE_MEDBAY_EQUIP
	starting_node = TRUE
	display_name = "Medbay Equipment"
	description = "在医疗部完好时为你提供急救的基本医疗工具。"
	design_ids = list(
		"beaker",
		"blood_filter",
		"blood_pack",
		"blood_scanner",
		"bonesetter",
		"cautery",
		"chem_pack",
		"circular_saw",
		"defibmountdefault",
		"dropper",
		"hemostat",
		"jerrycan",
		"large_beaker",
		"medicalbed",
		"operating",
		"organ_jar",
		"penlight",
		"penlight_paramedic",
		"pillbottle",
		"reflex_hammer",
		"retractor",
		"scalpel",
		"stethoscope",
		"suit_sensor",
		"surgical_drapes",
		"surgical_tape",
		"surgicaldrill",
		"syringe",
		"vitals_monitor",
		"xlarge_beaker",
	)
	experiments_to_unlock = list(
		/datum/experiment/autopsy/human,
		/datum/experiment/autopsy/nonhuman,
		/datum/experiment/autopsy/xenomorph,
		/datum/experiment/scanning/reagent/haloperidol,
		/datum/experiment/scanning/reagent/cryostylane,
	)

/datum/techweb_node/chem_synthesis
	id = TECHWEB_NODE_CHEM_SYNTHESIS
	display_name = "Chemical Synthesis"
	description = "从电力和稀薄空气中合成复杂的化学品……别问怎么做到的……"
	prereq_ids = list(TECHWEB_NODE_MEDBAY_EQUIP)
	design_ids = list(
		"med_spray_bottle",
		"inhaler",
		"inhaler_canister",
		"medigel",
		"medipen_refiller",
		"soda_dispenser",
		"beer_dispenser",
		"chem_dispenser",
		"portable_chem_mixer",
		"chem_heater",
		"w-recycler",
		"meta_beaker",
		"plumbing_rcd",
		"plumbing_rcd_service",
		"plunger",
		"fluid_ducts",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/medbay_equip_adv
	id = TECHWEB_NODE_MEDBAY_EQUIP_ADV
	display_name = "Advanced Medbay Equipment"
	description = "用于让船员保持完整——大部分情况下——的尖端医疗设备。"
	prereq_ids = list(TECHWEB_NODE_CHEM_SYNTHESIS)
	design_ids = list(
		"chem_mass_spec",
		"crewpinpointer",
		"defibmount",
		"diode_disk_healing",
		"diode_disk_sanity",
		"healthanalyzer_advanced",
		"medicalbed_emergency",
		"mod_health_analyzer",
		"piercesyringe",
		"smoke_machine",
		"vitals_monitor_advanced",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/scanning/reagent/haloperidol)
	announce_channels = list(RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/cryostasis
	id = TECHWEB_NODE_CRYOSTASIS
	display_name = "Cryostasis"
	description = "小丑意外喝下某种化学品的结果，现被重新用于将船员安全保存在休眠状态。"
	prereq_ids = list(TECHWEB_NODE_MEDBAY_EQUIP_ADV, TECHWEB_NODE_FUSION)
	design_ids = list(
		"cryo_grenade",
		"cryotube",
		"mech_sleeper",
		"splitbeaker",
		"stasis",
		"stasis_bodybag",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	discount_experiments = list(/datum/experiment/scanning/reagent/cryostylane = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_MEDICAL)
