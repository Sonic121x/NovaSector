///////SMELTABLE ALLOYS///////

/datum/design/plasteel_alloy
	name = "等离子铁"
	id = "plasteel"
	build_type = SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/plasma = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasteel
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/plastitanium_alloy
	name = "等离子钛钢"
	id = "plastitanium"
	build_type = SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT, /datum/material/plasma = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/plastitanium
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/plaglass_alloy
	name = "等离子玻璃"
	id = "plasmaglass"
	build_type = SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 0.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasmaglass
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/plasmarglass_alloy
	name = "强化等离子玻璃"
	id = "plasmareinforcedglass"
	build_type = SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 0.5, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.5,  /datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasmarglass
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/titaniumglass_alloy
	name = "钛钢玻璃"
	id = "titaniumglass"
	build_type = SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 0.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/titaniumglass
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/plastitaniumglass_alloy
	name = "等离子钛钢玻璃"
	id = "plastitaniumglass"
	build_type = SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 0.5, /datum/material/titanium = SHEET_MATERIAL_AMOUNT * 0.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plastitaniumglass
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/alienalloy
	name = "外星合金"
	desc = "一块逆向工程制成的外星合金薄板。"
	id = "alienalloy"
	build_type = SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/plasma = SHEET_MATERIAL_AMOUNT*2)
	build_path = /obj/item/stack/sheet/mineral/abductor
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
