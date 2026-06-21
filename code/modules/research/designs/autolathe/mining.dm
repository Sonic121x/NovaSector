// Autolathe-able circuitboards for starting with boulder processing machines.
/datum/design/board/smelter
	name = "巨石熔炼器电路板"
	desc = "一块用于巨石熔炼器的电路板。技术含量足够低，可以从自动制造机打印。"
	id = "b_smelter"
	build_type = AUTOLATHE
	materials = list(
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/circuitboard/machine/smelter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/refinery
	name = "巨石精炼器电路板"
	desc = "一块用于巨石精炼器的电路板。技术含量足够低，可以从自动制造机打印。"
	id = "b_refinery"
	build_type = AUTOLATHE
	materials = list(
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/circuitboard/machine/refinery
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO
