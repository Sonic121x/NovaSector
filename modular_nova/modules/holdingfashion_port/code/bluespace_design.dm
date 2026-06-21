/datum/design/satchel_holding
	name = "惰性次元挎包"
	desc = "一块准备通过蓝空异常核心转化为次元挎包的金属块。"
	id = "satchel_holding"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/satchel_of_holding_inert
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/duffel_holding
	name = "惰性次元旅行袋"
	desc = "一块准备被转化为带有蓝空异常核心的次元旅行包的金属块。"
	id = "duffel_holding"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/duffel_of_holding_inert
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
