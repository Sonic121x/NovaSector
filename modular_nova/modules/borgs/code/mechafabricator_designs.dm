/datum/design/borg_upgrade_shrink
	name = "缩小模块"
	id = "borg_upgrade_shrink"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/shrink
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 4,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL,
	)

/datum/design/borg_upgrade_surgicaltools
	name = "高级手术工具模块"
	id = "borg_upgrade_surgicaltools"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/surgerytools
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL,
	)

/datum/design/borg_upgrade_autopsyscanner
	name = "尸检扫描仪模块"
	id = "borg_upgrade_autopsyscanner"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/autopsy_scanner
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL,
	)

/datum/design/borg_upgrade_chemistrygripper
	name = "化学抓取器模块"
	id = "borg_upgrade_chemistrygripper"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/chemistrygripper
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL,
	)

/datum/design/affection_module
	name = "情感模块"
	id = "affection_module"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/affectionmodule
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL,
	)

/datum/design/advanced_materials
	name = "高级材料模块"
	id = "advanced_materials"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/advanced_materials
	materials = list(
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/iron=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/uranium=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT * 3,
	)
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING,
	)

/datum/design/borg_shapeshifter_module
	name = "变形模块"
	id = "borg_shapeshifter_module"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/borg_shapeshifter
	materials = list(
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL,
	)

/datum/design/borg_upgrade_welding
	name = "焊接模块"
	id = "borg_upgrade_welding"
	construction_time = 6 SECONDS
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/welder
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT * 1,
	)
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING,
	)

//Cyborg Nova overrides
/datum/design/borg_suit
	name = "机械人内骨骼"
	id = "borg_suit"
	build_type = MECHFAB
	build_path = /obj/item/robot_suit
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS,
	)

/datum/design/borg_chest
	name = "机械人躯干"
	id = "borg_chest"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/chest/robot
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 8,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS,
	)

/datum/design/borg_head
	name = "机械人头颅"
	id = "borg_head"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/head/robot
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS,
	)

/datum/design/borg_l_arm
	name = "机械人左臂"
	id = "borg_l_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/left/robot
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS,
	)

/datum/design/borg_r_arm
	name = "机械人右臂"
	id = "borg_r_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/right/robot
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS,
	)

/datum/design/borg_l_leg
	name = "机械人左腿"
	id = "borg_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/robot
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS,
	)

/datum/design/borg_r_leg
	name = "机械人右腿"
	id = "borg_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/robot
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS,
	)

/datum/design/borg_upgrade_cargo_apparatus
	name = "货运装置"
	id = "borg_upgrade_cargo_apparatus"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/cargo_papermanipulator
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2.5)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO
	)

/datum/design/rld
	name = "机械人快速照明装置"
	id = "rld_cyborg"
	build_type = MECHFAB
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/borg/upgrade/rld
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING
	)

/datum/design/borg_upgrade_brped
	name = "蓝空快速部件交换装置"
	id = "borg_upgrade_brped"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/brped
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING
	)

/datum/design/borgteleporter
	name = "机械人货运传送器"
	id = "borg_upgrade_cargo_teleporter"
	build_type = MECHFAB
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/borg/upgrade/cargo_teleporter
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO
	)
