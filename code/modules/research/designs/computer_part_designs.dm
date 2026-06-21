////////////////////////////////////////
///////////Computer Parts///////////////
////////////////////////////////////////
// Data disks
/datum/design/portabledrive/basic
	name = "数据盘"
	id = "portadrive_basic"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/disk/computer
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MODULAR_COMPUTERS + RND_SUBCATEGORY_MODULAR_COMPUTERS_PARTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/portabledrive/advanced
	name = "高级数据盘"
	id = "portadrive_advanced"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/disk/computer/advanced
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MODULAR_COMPUTERS + RND_SUBCATEGORY_MODULAR_COMPUTERS_PARTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/portabledrive/super
	name = "超级数据盘"
	id = "portadrive_super"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 4)
	build_path = /obj/item/disk/computer/super
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MODULAR_COMPUTERS + RND_SUBCATEGORY_MODULAR_COMPUTERS_PARTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
