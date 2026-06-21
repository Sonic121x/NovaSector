/datum/design/rods
	name = "铁棒"
	id = "rods"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/rods
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)

/datum/design/rglass
	name = "强化玻璃"
	id = "rglass"
	build_type = AUTOLATHE | SMELTER | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/rglass
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
