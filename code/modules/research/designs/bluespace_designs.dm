
/////////////////////////////////////////
///////////////Bluespace/////////////////
/////////////////////////////////////////

/datum/design/beacon
	name = "追踪信标"
	desc = "蓝空追踪信标。"
	id = "beacon"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/beacon
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SECURITY

/datum/design/bag_holding
	name = "未激活的蓝空包"
	desc = "一块金属块，准备被改造成一个带有蓝空间 异常核心的储物袋。"
	id = "bag_holding"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/uranium = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/bluespace =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/bag_of_holding_inert
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bluespace_crystal
	name = "人造蓝空晶体"
	desc = "一颗具有神秘力量的蓝色小水晶。"
	id = "bluespace_crystal"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/stack/ore/bluespace_crystal/artificial
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MATERIALS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/telesci_gps
	name = "GPS设备"
	desc = "一个能够随时追踪自身位置的小装置"
	id = "telesci_gps"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/gps
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO
	//autolathe_exportable = FALSE //NOVA EDIT REMOVAL

/datum/design/desynchronizer
	name = "去同步器"
	desc = "一种能够使持有者脱离时空束缚的装置。"
	id = "desynchronizer"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/desynchronizer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/miningsatchel_holding
	name = "蓝空矿石袋"
	desc = "一个可以装下无限量矿石的采矿包。"
	id = "minerbag_holding"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/uranium =SMALL_MATERIAL_AMOUNT*5) //quite cheap, for more convenience
	build_path = /obj/item/storage/bag/ore/holding
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/swapper
	name = "量子自旋转换器"
	desc = "一种实验装置，能够通过切换两个实体的粒子自旋值来交换它们的位置，必须链接到其他设备才能运行。"
	id = "swapper"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/swapper
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
