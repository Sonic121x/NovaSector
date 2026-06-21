//adding teshari silicon stuff to the mechfabricator

#define RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL "/Raptoral"
#define RND_SUBCATEGORY_CYBERNETICS_ADVANCED_RAPTORAL "/Advanced Raptoral"

/datum/design/teshari_cyber_chest
	name = "猛禽型赛博格躯干"
	id = "teshari_cyber_chest"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/chest/robot/teshari
	materials = list(/datum/material/iron= SHEET_MATERIAL_AMOUNT * 6)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_head
	name = "猛禽机械头部"
	id = "teshari_cyber_head"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/head/robot/teshari
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 0.75)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_l_arm
	name = "猛禽机械左前肢"
	id = "teshari_cyber_l_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/left/robot/teshari
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 1.5)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_r_arm
	name = "猛禽机械右前肢"
	id = "teshari_cyber_r_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/right/robot/teshari
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_l_leg
	name = "猛禽机械左后肢"
	id = "teshari_cyber_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/robot/teshari
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

/datum/design/teshari_cyber_r_leg
	name = "猛禽机械右后肢"
	id = "teshari_cyber_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/robot/teshari
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL,
	)

//advanced augmentations since those were added in the recent upstream

/datum/design/teshari_advanced_l_arm
	name = "高级猛禽机械左前肢"
	id = "teshari_advanced_l_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/left/robot/teshari_advanced
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 3,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_RAPTORAL,
	)

/datum/design/teshari_advanced_r_arm
	name = "高级猛禽机械右前肢"
	id = "teshari_advanced_r_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/right/robot/teshari_advanced
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 3,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_RAPTORAL,
	)

/datum/design/teshari_advanced_l_leg
	name = "高级猛禽机械左后肢"
	id = "teshari_advanced_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/robot/teshari_advanced
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 3,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_RAPTORAL,
	)

/datum/design/teshari_advanced_r_leg
	name = "高级猛禽机械右后肢"
	id = "teshari_advanced_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/robot/teshari_advanced
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 3,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_RAPTORAL,
	)

#undef RND_SUBCATEGORY_MECHFAB_CYBORG_RAPTORAL
#undef RND_SUBCATEGORY_CYBERNETICS_ADVANCED_RAPTORAL
