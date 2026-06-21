/obj/item/circuitboard/machine/rna_recombinator
	name = "RNA Recombinator"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/rna_recombinator
	req_components = list(
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/servo = 2,
		/datum/stock_part/micro_laser = 2,
	)

/datum/techweb_node/mutanttech
	id = TECHWEB_NODE_MUTANT_TECH
	display_name = "Advanced Nanotrasen Viral Bioweapons Technology"
	description = "研究来自纳米传讯病毒生物武器部门的设备！有病毒问题？这个能救你的命。"
	prereq_ids = list(TECHWEB_NODE_SURGERY_TOOLS, TECHWEB_NODE_CYTOLOGY)
	design_ids = list("rna_vial", "rna_extractor", "rna_recombinator")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/design/rna_vial
	name = "空 RNA 样本瓶"
	desc = "一个用于储存遗传信息的空 RNA 样本瓶。"
	id = "rna_vial"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/rna_vial
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/rna_extractor
	name = "RNA 提取装置"
	desc = "一种 RNA 提取装置，可用于从任何目标提取 RNA 数据，需要 RNA 样本瓶才能工作。"
	id = "rna_extractor"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/rna_extractor
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/rna_recombinator
	name = "RNA Recombinator Board"
	desc = "MRNA 重组器是纳米传讯最先进的技术之一，能够精确重组病毒 RNA。"
	id = "rna_recombinator"
	build_path = /obj/item/circuitboard/machine/rna_recombinator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL
