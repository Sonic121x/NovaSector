/datum/design/survival_knife
	name = "生存刀"
	id = "survival_knife"
	build_type = COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6,
	)
	build_path = /obj/item/knife/combat/survival
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

