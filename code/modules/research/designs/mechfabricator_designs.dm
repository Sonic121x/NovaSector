//Cyborg

/* //NOVA EDIT REMOVAL BEGIN - Costs lowered and time reduced -
/datum/design/borg_suit
	name = "Cyborg Endoskeleton"
	id = "borg_suit"
	build_type = MECHFAB
	build_path = /obj/item/robot_suit
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 50 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS
	)

/datum/design/borg_chest
	name = "Cyborg Torso"
	id = "borg_chest"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/chest/robot
	materials = list(/datum/material/iron= SHEET_MATERIAL_AMOUNT*20)
	construction_time = 35 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS
	)

/datum/design/borg_head
	name = "Cyborg Head"
	id = "borg_head"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/head/robot
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT * 2.5)
	construction_time = 35 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS
	)

/datum/design/borg_l_arm
	name = "Cyborg Left Arm"
	id = "borg_l_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/left/robot
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS
	)

/datum/design/borg_r_arm
	name = "Cyborg Right Arm"
	id = "borg_r_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/right/robot
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS
	)

/datum/design/borg_l_leg
	name = "Cyborg Left Leg"
	id = "borg_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/robot
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS
	)

/datum/design/borg_r_leg
	name = "Cyborg Right Leg"
	id = "borg_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/robot
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CHASSIS
	)
*///NOVA EDIT REMOVAL END

//Advanced Robotic Limbs

/datum/design/advanced_l_arm
	name = "高级左臂"
	id = "advanced_l_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/left/robot/advanced
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/gold=SHEET_MATERIAL_AMOUNT*3,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_LIMBS
	)

/datum/design/advanced_r_arm
	name = "高级右臂"
	id = "advanced_r_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/right/robot/advanced
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/gold=SHEET_MATERIAL_AMOUNT*3,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_LIMBS
	)

/datum/design/advanced_l_leg
	name = "高级左腿"
	id = "advanced_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/robot/advanced
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/gold=SHEET_MATERIAL_AMOUNT*3,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_LIMBS
	)

/datum/design/advanced_r_leg
	name = "高级右腿"
	id = "advanced_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/robot/advanced
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/gold=SHEET_MATERIAL_AMOUNT*3,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_LIMBS
	)

//Ripley
/datum/design/ripley_chassis
	name = "机甲骨架（APLU \"雷普利\"）"
	id = "ripley_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/ripley
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*10)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/ripley_torso
	name = "机甲躯干（APLU \"雷普利\"）"
	id = "ripley_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_torso
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*3.75,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/ripley_left_arm
	name = "机甲左臂（APLU \"雷普利\"）"
	id = "ripley_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_left_arm
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 15 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/ripley_right_arm
	name = "机甲右臂（APLU \"雷普利\"）"
	id = "ripley_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_right_arm
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 15 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/ripley_left_leg
	name = "机甲左腿（APLU \"雷普利\"）"
	id = "ripley_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_left_leg
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 15 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/ripley_right_leg
	name = "机甲右腿（APLU \"雷普利\"）"
	id = "ripley_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/ripley_right_leg
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 15 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

//Odysseus
/datum/design/odysseus_chassis
	name = "机甲骨架(\"Odysseus-奥德修斯\")"
	id = "odysseus_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/odysseus
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*10)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/odysseus_torso
	name = "机甲躯干(\"Odysseus-奥德修斯\")"
	id = "odysseus_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_torso
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*6)
	construction_time = 18 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/odysseus_head
	name = "机甲头部(\"Odysseus-奥德修斯\")"
	id = "odysseus_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_head
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*5
	)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/odysseus_left_arm
	name = "机甲左臂(\"Odysseus-奥德修斯\")"
	id = "odysseus_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_left_arm
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*3)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/odysseus_right_arm
	name = "机甲右臂(\"Odysseus-奥德修斯\")"
	id = "odysseus_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_right_arm
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*3)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/odysseus_left_leg
	name = "机甲左腿(\"Odysseus-奥德修斯\")"
	id = "odysseus_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_left_leg
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*3.5)
	construction_time = 13 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/odysseus_right_leg
	name = "机甲右腿(\"Odysseus-奥德修斯\")"
	id = "odysseus_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/odysseus_right_leg
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*3.5)
	construction_time = 13 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

//Gygax
/datum/design/gygax_chassis
	name = "机甲骨架 (\"Gygax-吉加斯\")"
	id = "gygax_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/gygax
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*10)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/gygax_torso
	name = "机甲躯干 (\"Gygax-吉加斯\")"
	id = "gygax_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_torso
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/gold=SHEET_MATERIAL_AMOUNT,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/gygax_head
	name = "机甲头部 (\"Gygax-吉加斯\")"
	id = "gygax_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_head
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/gold=SHEET_MATERIAL_AMOUNT,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/gygax_left_arm
	name = "机甲左臂 (\"Gygax-吉加斯\")"
	id = "gygax_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_left_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/gold=HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver=HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/gygax_right_arm
	name = "机甲右臂 (\"Gygax-吉加斯\")"
	id = "gygax_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_right_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/gold=HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver=HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/gygax_left_leg
	name = "机甲左腿 (\"Gygax-吉加斯\")"
	id = "gygax_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_left_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/gold=HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver=HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/gygax_right_leg
	name = "机甲右腿 (\"Gygax-吉加斯\")"
	id = "gygax_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_right_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/gold=HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver=HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/gygax_armor
	name = "机甲装甲 (\"Gygax-吉加斯\")"
	id = "gygax_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_armor
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/gold=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 60 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

//Durand
/datum/design/durand_chassis
	name = "机甲骨架 (\"Durand-杜兰德\")"
	id = "durand_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/durand
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*12.5)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/durand_torso
	name = "机甲躯干 (\"Durand-杜兰德\")"
	id = "durand_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_torso
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*12.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/durand_head
	name = "机甲头部 (\"Durand-杜兰德\")"
	id = "durand_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_head
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/durand_left_arm
	name = "机甲左臂 (\"Durand-杜兰德\")"
	id = "durand_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_left_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/durand_right_arm
	name = "机甲右臂 (\"Durand-杜兰德\")"
	id = "durand_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_right_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/durand_left_leg
	name = "机甲左腿 (\"Durand-杜兰德\")"
	id = "durand_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_left_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/durand_right_leg
	name = "机甲右腿 (\"Durand-杜兰德\")"
	id = "durand_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_right_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/durand_armor
	name = "机甲装甲 (\"Durand-杜兰德\")"
	id = "durand_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/durand_armor
	materials = list(
		/datum/material/iron=SMALL_MATERIAL_AMOUNT * 300,
		/datum/material/uranium=SHEET_MATERIAL_AMOUNT*12.5,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*10,
	)
	construction_time = 60 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

//H.O.N.K
/datum/design/honk_chassis
	name = "机甲骨架 (\"H.O.N.K\")"
	id = "honk_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/honker
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*10)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/honk_torso
	name = "机甲躯干 (\"H.O.N.K\")"
	id = "honk_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_torso
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/honk_head
	name = "机甲头部 (\"H.O.N.K\")"
	id = "honk_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_head
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/honk_left_arm
	name = "机甲左臂 (\"H.O.N.K\")"
	id = "honk_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_left_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/honk_right_arm
	name = "机甲右臂 (\"H.O.N.K\")"
	id = "honk_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_right_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/honk_left_leg
	name = "机甲左腿"
	id = "honk_left_leg"
	build_type = MECHFAB
	build_path =/obj/item/mecha_parts/part/honker_left_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/honk_right_leg
	name = "机甲右腿 (\"H.O.N.K\")"
	id = "honk_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/honker_right_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

//Phazon
/datum/design/phazon_chassis
	name = "机甲骨架 (\"Phazon-法宗\")"
	id = "phazon_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/phazon
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*10)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/phazon_torso
	name = "机甲躯干 (\"Phazon-法宗\")"
	id = "phazon_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_torso
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*17.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT*10,
	)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/phazon_head
	name = "机甲头部 (\"Phazon-法宗\")"
	id = "phazon_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_head
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/phazon_left_arm
	name = "机甲左臂 (\"Phazon-法宗\")"
	id = "phazon_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_left_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/phazon_right_arm
	name = "机甲右臂 (\"Phazon-法宗\")"
	id = "phazon_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_right_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/phazon_left_leg
	name = "机甲左腿 (\"Phazon-法宗\")"
	id = "phazon_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_left_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/phazon_right_leg
	name = "机甲右腿 (\"Phazon-法宗\")"
	id = "phazon_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_right_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/phazon_armor
	name = "机甲装甲 (\"Phazon-法宗\")"
	id = "phazon_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/phazon_armor
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*12.5,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*10,
	)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

//Savannah-Ivanov
/datum/design/savannah_ivanov_chassis
	name = "Exosuit Chassis (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/savannah_ivanov
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*10)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_torso
	name = "Exosuit Torso (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_torso
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*3.75,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_head
	name = "Exosuit Head (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_head
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_left_arm
	name = "Exosuit Left Arm (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_left_arm
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 15 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_right_arm
	name = "Exosuit Right Arm (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_right_arm
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 15 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_chassis
	name = "Exosuit Chassis (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/savannah_ivanov
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*12.5)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_torso
	name = "Exosuit Torso (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_torso
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*12.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_head
	name = "Exosuit Head (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_head
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_left_arm
	name = "Exosuit Left Arm (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_left_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_right_arm
	name = "Exosuit Right Arm (\"Savannah-Ivanov\")"
	id = "savannah_ivanov_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_right_arm
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_left_leg
	name = "机甲左腿 (\"Savannah-Ivanov-萨凡纳-伊万诺夫\")"
	id = "savannah_ivanov_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_left_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_right_leg
	name = "机甲右腿 (\"Savannah-Ivanov-萨凡纳-伊万诺夫\")"
	id = "savannah_ivanov_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_right_leg
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/savannah_ivanov_armor
	name = "机甲装甲 (\"Savannah-Ivanov-萨凡纳-伊万诺夫\")"
	id = "savannah_ivanov_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/savannah_ivanov_armor
	materials = list(
		/datum/material/iron=SMALL_MATERIAL_AMOUNT * 300,
		/datum/material/uranium=SHEET_MATERIAL_AMOUNT*12.5,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*10,
	)
	construction_time = 60 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

//Clarke
/datum/design/clarke_chassis
	name = "机甲骨架 (\"Clarke-克拉克\")"
	id = "clarke_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/clarke
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*10)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/clarke_torso
	name = "机甲躯干 (\"Clarke-克拉克\")"
	id = "clarke_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/clarke_torso
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*3.75,
		)
	construction_time = 20 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/clarke_head
	name = "机甲头部 (\"Clarke-克拉克\")"
	id = "clarke_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/clarke_head
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/clarke_left_arm
	name = "机甲左臂 (\"Clarke-克拉克\")"
	id = "clarke_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/clarke_left_arm
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 15 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

/datum/design/clarke_right_arm
	name = "机甲右臂 (\"Clarke-克拉克\")"
	id = "clarke_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/clarke_right_arm
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*7.5)
	construction_time = 15 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_CHASSIS
	)

//Exosuit Equipment
/datum/design/ripleyupgrade
	name = "Ripley MK-I>MK-II转换组件"
	id = "ripleyupgrade"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/ripleyupgrade
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
	)

/datum/design/paddyupgrade
	name = "里普利MK-I至帕迪转换套件"
	id = "paddyupgrade"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/ripleyupgrade/paddy
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT *5,
	)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES,
		RND_CATEGORY_MECHFAB_PADDY + RND_SUBCATEGORY_MECHFAB_CHASSIS,
	)

/datum/design/mech_hydraulic_clamp
	name = "液动压板"
	id = "mech_hydraulic_clamp"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/hydraulic_clamp
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
	)

/datum/design/mech_hydraulic_claw
	name = "液压爪"
	id = "mech_hydraulic_claw"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/paddy_claw
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC,
		RND_CATEGORY_MECHFAB_PADDY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
	)

/datum/design/mech_drill
	name = "采矿钻"
	id = "mech_drill"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/drill
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_mining_scanner
	name = "采矿扫描仪"
	id = "mech_mscanner"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/mining_scanner
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT *1.25,
	)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)

/datum/design/mech_extinguisher
	name = "灭火器"
	id = "mech_extinguisher"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/extinguisher
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)

/datum/design/mech_generator
	name = "等离子发电机"
	id = "mech_generator"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/generator
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_mousetrap_mortar
	name = "老鼠夹迫击炮"
	id = "mech_mousetrap_mortar"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/mousetrap_mortar
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_HONK,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_banana_mortar
	name = "香蕉迫击炮"
	id = "mech_banana_mortar"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 30 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_HONK,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_honker
	name = "HoNkER BlAsT 5000"
	id = "mech_honker"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/honker
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 50 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_HONK,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_punching_glove
	name = "艺术就是打你脸"
	id = "mech_punching_face"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*10,
		/datum/material/bananium=SHEET_MATERIAL_AMOUNT*3.75,
	)
	construction_time = 40 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_HONK,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_radio
	name = "机甲无线电"
	id = "mech_radio"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/radio
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2.5)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_air_tank
	name = "机甲空气罐"
	id = "mech_air_tank"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/air_tank
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/////////////////////////////////////////
//////////////Borg Upgrades//////////////
/////////////////////////////////////////

/datum/design/borg_upgrade_rename
	name = "重命名电路板"
	id = "borg_upgrade_rename"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/rename
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)

/datum/design/borg_upgrade_restart
	name = "格紧急重启模块"
	id = "borg_upgrade_restart"
	build_type = MECHFAB
	build_path = /obj/item/borg_restart_board
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*10,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)

/datum/design/borg_upgrade_thrusters
	name = "离子推进器"
	id = "borg_upgrade_thrusters"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/thrusters
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/plasma =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/uranium =SHEET_MATERIAL_AMOUNT*3,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)

/datum/design/borg_upgrade_disablercooler
	name = "快速镇暴光枪冷却模块"
	id = "borg_upgrade_disablercooler"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/disablercooler
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*10,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/gold =SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SECURITY
	)

/datum/design/borg_upgrade_diamonddrill
	name = "钻石钻"
	id = "borg_upgrade_diamonddrill"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/diamond_drill
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/diamond =SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)

/datum/design/borg_upgrade_holding
	name = "蓝空矿石袋"
	id = "borg_upgrade_holding"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/soh
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/gold =SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)

/datum/design/borg_upgrade_lavaproof
	name = "熔岩防护履带"
	id = "borg_upgrade_lavaproof"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/lavaproof
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/plasma =SHEET_MATERIAL_AMOUNT*2,
		/datum/material/titanium =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)

/datum/design/borg_syndicate_module
	name = "违法模块"
	id = "borg_syndicate_module"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/syndicate
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/diamond =SHEET_MATERIAL_AMOUNT*5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)

/datum/design/borg_transform_clown
	name = "小丑模块"
	id = "borg_transform_clown"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/transform/clown
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/bananium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)

/datum/design/borg_upgrade_selfrepair
	name = "自修复模块"
	id = "borg_upgrade_selfrepair"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/selfrepair
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*7.5,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)

/datum/design/borg_upgrade_expandedsynthesiser
	name = "拓展无针注射器合成器"
	id = "borg_upgrade_expandedsynthesiser"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/hypospray/expanded
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/plasma =SHEET_MATERIAL_AMOUNT*4,
		/datum/material/uranium =SHEET_MATERIAL_AMOUNT*4,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)

/datum/design/borg_upgrade_piercinghypospray
	name = "穿刺型无针注射器"
	id = "borg_upgrade_piercinghypospray"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/piercing_hypospray
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/titanium =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/diamond =SHEET_MATERIAL_AMOUNT * 1.5,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)

/datum/design/borg_upgrade_defibrillator
	name = "除颤器"
	id = "borg_upgrade_defibrillator"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/defib
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*4,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/silver =SHEET_MATERIAL_AMOUNT*2,
		/datum/material/gold =SHEET_MATERIAL_AMOUNT * 1.5,
	)
	construction_time = 8 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)

/datum/design/borg_upgrade_surgicalprocessor
	name = "外科处理器"
	id = "borg_upgrade_surgicalprocessor"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/processor
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*2,
		/datum/material/silver =SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)

/datum/design/borg_upgrade_surgicalomnitool
	name = "高级外科万能工具升级"
	id = "borg_upgrade_surgicalomnitool"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/surgery_omnitool
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/silver=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)

/datum/design/borg_upgrade_engineeringomnitool
	name = "高级工程万能工具升级"
	id = "borg_upgrade_engineeringomnitool"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/engineering_omnitool
	materials = list(
		/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT*3,
		/datum/material/gold=SHEET_MATERIAL_AMOUNT*2,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING,
	)

/datum/design/borg_upgrade_trashofholding
	name = "蓝空垃圾袋"
	id = "borg_upgrade_trashofholding"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/tboh
	materials = list(
		/datum/material/gold =SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_JANITOR
	)

/datum/design/borg_upgrade_advancedmop
	name = "先进拖把"
	id = "borg_upgrade_advancedmop"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/amop
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_JANITOR
	)

/datum/design/borg_upgrade_prt
	name = "电镀修复工具"
	id = "borg_upgrade_prt"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/prt
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.125,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*0.75,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_JANITOR
	)

/datum/design/borg_upgrade_plunger
	name = "集成式皮搋子"
	id = "borg_upgrade_plunger"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/plunger
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.125,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*0.75,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_JANITOR
	)

/datum/design/borg_upgrade_high_capacity_replacer
	name = "高容量灯泡更换器"
	id = "borg_upgrade_high_capacity_replacer"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/high_capacity_light_replacer
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.125,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*0.75,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_JANITOR
	)

/datum/design/borg_upgrade_rolling_table
	name = "滚轮手术台坞站"
	id = "borg_upgrade_rolling_table"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/rolling_table
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*10,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT*7.5,
	) //steeper price than a regular rolling table, with some added titanium to make up for the relative rarity of regular rolling tables
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SERVICE
	)

/datum/design/borg_upgrade_condiment_synthesizer
	name = "调味品合成器"
	id = "borg_upgrade_condiment_synthesizer"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/condiment_synthesizer
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*6,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT*3,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT*3,
	) //a bit cheaper than an expanded hypo for medical borg,
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SERVICE
	)

/datum/design/borg_upgrade_silicon_knife
	name = "厨房工具套装"
	id = "borg_upgrade_silicon_knife"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/silicon_knife
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SERVICE
	)

/datum/design/borg_upgrade_botany
	name = "植物学工具"
	id = "borg_upgrade_botany"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/botany_upgrade
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*13,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*2 // approx. all mats that u wasting on those tools on lathe
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SERVICE
	)


/datum/design/borg_upgrade_drink_apparatus
	name = "饮品装置"
	id = "borg_upgrade_drink_apparatus"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/drink_app
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SERVICE
	)

/datum/design/borg_upgrade_service_apparatus
	name = "服务装置"
	id = "borg_upgrade_service_apparatus"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/service_apparatus
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2.5)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SERVICE
	)

/datum/design/borg_upgrade_service_cookbook
	name = "服务食谱"
	id = "borg_upgrade_service_cookbook"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/service_cookbook
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SERVICE
	)

/datum/design/borg_upgrade_shuttle_blueprints
	name = "工程穿梭机蓝图"
	id = "borg_upgrade_engineering_shuttle_blueprints"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/shuttle_blueprints
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*2.5,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING
	)

/datum/design/borg_upgrade_expand
	name = "扩展模块"
	id = "borg_upgrade_expand"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/expand
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*100,
		/datum/material/titanium =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)

/datum/design/boris_ai_controller
	name = "B.O.R.I.S. AI-赛博遥控模块"
	id = "borg_ai_control"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/ai
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT*1.2,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT * 2,
	)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CONTROL_INTERFACES
	)
	search_metadata = "boris"

/* //NOVA EDIT REMOVAL START - Added to starting loadout. Linter got mad that the ID was not used anywhrere.
/datum/design/borg_upgrade_rped
	name = "Rapid Part Exchange Device Expanded"
	id = "borg_upgrade_rped"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/rped
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*2.5,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT*2.5
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING
	)
*/ // NOVA EDIT REMOVAL END
/datum/design/borg_upgrade_inducer
	name = "机械人感应器"
	id = "borg_upgrade_inducer"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/inducer
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 2)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING
	)

/datum/design/borg_upgrade_engineering_app
	name = "工程装置"
	id = "borg_upgrade_engineeringapp"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/engineering_app
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium =SMALL_MATERIAL_AMOUNT*5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ENGINEERING
	)

/datum/design/borg_upgrade_beaker_app
	name = "二级烧杯存储"
	id = "borg_upgrade_beakerapp"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/beaker_app
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT*1.125,
	) //Need glass for the new beaker too
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)

/datum/design/borg_upgrade_pinpointer
	name = "船员追踪器"
	id = "borg_upgrade_pinpointer"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/pinpointer
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)

/datum/design/borg_upgrade_syringe
	name = "高级注射器"
	id = "borg_upgrade_syringe"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/bs_syringe
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace =SMALL_MATERIAL_AMOUNT*5
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)

/datum/design/borg_upgrade_broomer
	name = "实验性长柄扫帚"
	id = "borg_upgrade_broomer"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/broomer
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*2,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_JANITOR
	)

/datum/design/mmi
	name = "人机界面"
	desc = "那毫无特色的缩写“人机接口”，掩盖了这怪物的真正恐怖之处，然而它却已在纳米传讯的各个站点成为了标配设备。"
	id = "mmi"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
	)
	construction_time = 7.5 SECONDS
	build_path = /obj/item/mmi
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mmi/medical
	build_type = PROTOLATHE | AWAY_LATHE
	id = "mmi_m"
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/posibrain
	name = "正电子脑"
	desc = "最新的人工智能技术。"
	id = "mmi_posi"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT*1.7,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*1.35,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5
	)
	construction_time = 7.5 SECONDS
	build_path = /obj/item/mmi/posibrain
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

//Misc
/datum/design/mecha_tracking
	name = "机甲追踪信标"
	id = "mecha_tracking"
	build_type = MECHFAB
	build_path =/obj/item/mecha_parts/mecha_tracking
	materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*5)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mecha_tracking_ai_control
	name = "AI控制信标"
	id = "mecha_tracking_ai_control"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_tracking/ai_control
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT * 2,
	)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mecha_camera
	name = "外骨骼外部摄像头套件"
	desc = "一款专为外骨骼操作设计的耐用闭路电视摄像头。"
	id = "mecha_camera"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/camera_kit
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/plasma =SMALL_MATERIAL_AMOUNT * 2,
		/datum/material/titanium =SMALL_MATERIAL_AMOUNT * 2,
	)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES,
		RND_CATEGORY_MECHFAB_SAVANNAH_IVANOV + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/synthetic_flash
	name = "闪光"
	desc = "当问题出现时，科学就是解决办法。"
	id = "sflash"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7.5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 7.5,
	)
	construction_time = 10 SECONDS
	build_path = /obj/item/assembly/flash/handheld
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG
	)
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_COMPONENTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

//MODsuit construction

/datum/design/mod_shell
	name = "模块服外壳"
	desc = "一款由Nakamura工程公司设计的模块化航天服外壳。"
	id = "mod_shell"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*5,
		/datum/material/plasma =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 25 SECONDS
	build_path = /obj/item/mod/construction/shell
	category = list(
		RND_CATEGORY_MODSUITS + RND_SUBCATEGORY_MODUITS_CHASSIS
	)

/datum/design/mod_helmet
	name = "模块服头盔"
	desc = "一款由Nakamura工程公司设计的模块化航天服头盔。"
	id = "mod_helmet"
	build_type = MECHFAB
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5)
	construction_time = 10 SECONDS
	build_path = /obj/item/mod/construction/helmet
	category = list(
		RND_CATEGORY_MODSUITS + RND_SUBCATEGORY_MODUITS_CHASSIS
	)

/datum/design/mod_chestplate
	name = "模块服胸板"
	desc = "一款由Nakamura工程公司设计的模块化航天服胸板。"
	id = "mod_chestplate"
	build_type = MECHFAB
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5)
	construction_time = 10 SECONDS
	build_path = /obj/item/mod/construction/chestplate
	category = list(
		RND_CATEGORY_MODSUITS + RND_SUBCATEGORY_MODUITS_CHASSIS
	)

/datum/design/mod_gauntlets
	name = "模块服手套"
	desc = "一款由Nakamura工程公司设计的模块化航天服手套。"
	id = "mod_gauntlets"
	build_type = MECHFAB
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5)
	construction_time = 10 SECONDS
	build_path = /obj/item/mod/construction/gauntlets
	category = list(
		RND_CATEGORY_MODSUITS + RND_SUBCATEGORY_MODUITS_CHASSIS
	)

/datum/design/mod_boots
	name = "模块服靴"
	desc = "一款由Nakamura工程公司设计的模块化航天服靴子。"
	id = "mod_boots"
	build_type = MECHFAB
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5)
	construction_time = 10 SECONDS
	build_path = /obj/item/mod/construction/boots
	category = list(
		RND_CATEGORY_MODSUITS + RND_SUBCATEGORY_MODUITS_CHASSIS
	)

/datum/design/mod_plating
	name = "模块服外层电镀"
	desc = "用于模块服的外部涂层。"
	id = "mod_plating_standard"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*1.5,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 15 SECONDS
	build_path = /obj/item/mod/construction/plating
	category = list(
		RND_CATEGORY_MODSUITS + RND_SUBCATEGORY_MODSUITS_PLATING
	)
	research_icon = 'icons/obj/clothing/modsuit/mod_construction.dmi'
	research_icon_state = "standard-plating"

/datum/design/mod_plating/New()
	. = ..()
	var/obj/item/mod/construction/plating/armor_type = build_path
	var/datum/mod_theme/theme = GLOB.mod_themes[initial(armor_type.theme)]
	desc = "用于模块服的外层电镀. [theme.desc]"

/datum/design/mod_plating/civilian
	name = "MOD民用护甲"
	id = "mod_plating_civilian"
	build_path = /obj/item/mod/construction/plating/civilian
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT*1.5,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
	)
	research_icon_state = "civilian-plating"

/datum/design/mod_plating/portable_suit
	name = "MOD便携式套装护甲"
	id = "mod_plating_portable_suit"
	build_path = /obj/item/mod/construction/plating/portable_suit
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
	)
	research_icon_state = "psuit-plating"

/datum/design/mod_plating/engineering
	name = "MOD工程电镀"
	id = "mod_plating_engineering"
	build_path = /obj/item/mod/construction/plating/engineering
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/gold =SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING
	research_icon_state = "engineering-plating"

/datum/design/mod_plating/atmospheric
	name = "MOD大气电镀"
	id = "mod_plating_atmospheric"
	build_path = /obj/item/mod/construction/plating/atmospheric
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/titanium =SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING
	research_icon_state = "atmospheric-plating"

/datum/design/mod_plating/medical
	name = "MOD医疗电镀"
	id = "mod_plating_medical"
	build_path = /obj/item/mod/construction/plating/medical
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/silver =SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	research_icon_state = "medical-plating"

/datum/design/mod_plating/cosmohonk
	name = "MOD宇宙喇叭电镀"
	id = "mod_plating_cosmohonk"
	build_path = /obj/item/mod/construction/plating/cosmohonk
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT*3,
		/datum/material/bananium =SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE
	research_icon_state = "cosmohonk-plating"

/datum/design/mod_paint_kit
	name = "模块服绘制套件"
	desc = "一套用于模块服的油漆套装。"
	id = "mod_paint_kit"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic =SMALL_MATERIAL_AMOUNT*5,
	)
	construction_time = 5 SECONDS
	build_path = /obj/item/mod/paint
	category = list(
		RND_CATEGORY_MODSUITS + RND_SUBCATEGORY_MODSUITS_MISC
	)

/datum/design/modlink_scryer
	name = "MODlink窥视器"
	desc = "一款佩戴于颈部的装备，可与另一台兼容MODlink的设备进行呼叫。"
	id = "modlink_scryer"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
	)
	construction_time = 5 SECONDS
	build_path = /obj/item/clothing/neck/link_scryer
	category = list(
		RND_CATEGORY_MODSUITS + RND_SUBCATEGORY_MODSUITS_MISC
	)

//MODsuit modules

/datum/design/module
	name = "MOD模块"
	build_type = MECHFAB
	construction_time = 1 SECONDS
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_GENERAL
	)

/datum/design/module/New()
	. = ..()
	var/obj/item/mod/module/module = build_path
	desc = "[initial(module.desc)] 它占用 [initial(module.complexity)]复杂度"

/datum/design/module/mod_storage
	name = "紧凑型存储模块"
	id = "mod_storage"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT *1.25,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/storage

/datum/design/module/mod_storage_expanded
	name = "存储模块"
	id = "mod_storage_expanded"
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/uranium =SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/storage/large_capacity

/datum/design/module/mod_storage_holding
	name = "次元存储模块"
	id = "mod_storage_holding"
	materials = list(
		/datum/material/gold =SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT*2.5,
		/datum/material/bluespace =SHEET_MATERIAL_AMOUNT
	)
	build_path = /obj/item/mod/module/storage/holding

/datum/design/module/mod_visor_medhud
	name = "医疗目镜模块"
	id = "mod_visor_medhud"
	materials = list(
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/visor/medhud
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/mod_visor_diaghud
	name = "诊断目镜模块"
	id = "mod_visor_diaghud"
	materials = list(
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/visor/diaghud
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SCIENCE
	)
/datum/design/module/mod_visor_sechud
	name = "安保目镜模块"
	id = "mod_visor_sechud"
	materials = list(
		/datum/material/titanium =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/visor/sechud
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
/datum/design/module/mod_visor_meson
	name = "介子目镜模块"
	id = "mod_visor_meson"
	materials = list(
		/datum/material/uranium =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/visor/meson
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)
/datum/design/module/mod_visor_welding
	name = "焊接保护模块"
	id = "mod_welding"
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/welding
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
/datum/design/module/mod_head_protection
	name = "安全第一头部防护模块"
	id = "mod_safety"
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/headprotector
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
/datum/design/module/mod_t_ray
	name = "T-ray扫描仪模块"
	id = "mod_t_ray"
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/t_ray
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
/datum/design/module/mod_health_analyzer
	name = "健康分析仪模块"
	id = "mod_health_analyzer"
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/health_analyzer
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/mod_stealth
	name = "隐身模块"
	id = "mod_stealth"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/stealth
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)
/datum/design/module/mod_jetpack
	name = "离子喷气背包模块"
	id = "mod_jetpack"
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/mod/module/jetpack

/datum/design/module/mod_magboot
	name = "磁稳定模块"
	id = "mod_magboot"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/magboot
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)

/datum/design/module/mod_mag_harness
	name = "磁力枪束模块"
	id = "mod_mag_harness"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/magnetic_harness
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

/datum/design/module/mod_tether
	name = "应急立体机动模块"
	id = "mod_tether"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/tether
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)

/datum/design/module/mod_mouthhole
	name = "进食模块"
	id = "mod_mouthhole"
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/mod/module/mouthhole

/datum/design/module/mod_rad_protection
	name = "防辐射保护模块"
	id = "mod_rad_protection"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/rad_protection
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
/datum/design/module/mod_emp_shield
	name = "抗电磁脉冲模块"
	id = "mod_emp_shield"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/emp_shield

/datum/design/module/mod_flashlight
	name = "闪光灯模组"
	id = "mod_flashlight"
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/flashlight

/datum/design/module/mod_reagent_scanner
	name = "成分扫描仪模块"
	id = "mod_reagent_scanner"
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/mod/module/reagent_scanner
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SCIENCE
	)

/datum/design/module/mod_gps
	name = "内置GPS模块"
	id = "mod_gps"
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/gps
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)

/datum/design/module/mod_constructor
	name = "构造器模块"
	id = "mod_constructor"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/constructor
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)
/datum/design/module/mod_quick_carry
	name = "速运模块"
	id = "mod_quick_carry"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/quick_carry
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/mod_longfall
	name = "长落模块"
	id = "mod_longfall"
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/mod/module/longfall

/datum/design/module/mod_thermal_regulator
	name = "恒温模块"
	id = "mod_thermal_regulator"
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/thermal_regulator

/datum/design/module/mod_injector
	name = "注射器模块"
	id = "mod_injector"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/injector
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/mod_bikehorn
	name = "喇叭模块"
	id = "mod_bikehorn"
	materials = list(
		/datum/material/plastic =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/bikehorn
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)

/datum/design/module/mod_microwave_beam
	name = "微波束模块"
	id = "mod_microwave_beam"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/microwave_beam
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)

/datum/design/module/mod_waddle
	name = "颠摆模块"
	id = "mod_waddle"
	materials = list(
		/datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/waddle
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)

/datum/design/module/mod_clamp
	name = "板条箱压板模块"
	id = "mod_clamp"
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/mod/module/clamp
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)

/datum/design/module/mod_drill
	name = "钻机模块"
	id = "mod_drill"
	materials = list(
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/iron =SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/drill
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)

/datum/design/module/mod_orebag
	name = "矿袋模块"
	id = "mod_orebag"
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/mod/module/orebag
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)

/datum/design/module/mod_organizer
	name = "整理模块"
	id = "mod_organizer"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/organizer
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/mod_pathfinder
	name = "探路者模块"
	id = "mod_pathfinder"
	materials = list(
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/pathfinder

/datum/design/module/mod_dna_lock
	name = "DNA锁模块"
	id = "mod_dna_lock"
	materials = list(
		/datum/material/diamond =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/dna_lock

/datum/design/module/mod_plasma_stabilizer
	name = "等离子稳定器模块"
	id = "mod_plasma"
	materials = list(
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/plasma_stabilizer

/datum/design/module/mod_glove_translator
	name = "手套传输模块"
	id = "mod_sign_radio"
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7.5,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/signlang_radio

/datum/design/module/mister_atmos
	name = "树脂喷雾器模块"
	id = "mod_mister_atmos"
	materials = list(
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	build_path = /obj/item/mod/module/mister/atmos
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)

/datum/design/module/mod_holster
	name = "枪套模块"
	id = "mod_holster"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/holster
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

/datum/design/module/mod_sonar
	name = "主动式声纳"
	id = "mod_sonar"
	materials = list(
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/mod/module/active_sonar
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

/datum/design/module/projectile_dampener
	name = "发射物阻尼模块"
	id = "mod_projectile_dampener"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/mod/module/projectile_dampener
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

/datum/design/module/surgicalprocessor
	name = "外科处理器模块"
	id = "mod_surgicalprocessor"
	materials = list(
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	build_path = /obj/item/mod/module/surgical_processor
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/threadripper
	name = "织物缝割模块"
	id = "mod_threadripper"
	materials = list(
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 2.5,
		/datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	build_path = /obj/item/mod/module/thread_ripper
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/defibrillator
	name = "除颤器模块"
	id = "mod_defib"
	materials = list(
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 2.5,
		/datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	build_path = /obj/item/mod/module/defibrillator
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/statusreadout
	name = "状态读数模块"
	id = "mod_statusreadout"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/mod/module/status_readout
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/patienttransport
	name = "伤员运输模块"
	id = "mod_patienttransport"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/criminalcapture/patienttransport
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_MEDICAL
	)

/datum/design/module/criminalcapture
	name = "犯人捕获模块"
	id = "mod_criminalcapture"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/criminalcapture
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

/datum/design/module/mirage
	name = "幻影手榴弹发射器模块"
	id = "mod_mirage_grenade"
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/dispenser/mirage
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

//MODsuit bepis modules
/datum/design/module/disposal
	name = "处理器选择模块"
	id = "mod_disposal"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT *1.25,
		/datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/disposal_connector
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SUPPLY
	)

/datum/design/module/joint_torsion
	name = "关节扭力棘轮模块"
	id = "mod_joint_torsion"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*2.5,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/joint_torsion
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUITS_MISC
	)

/datum/design/module/recycler
	name = "回收模块"
	id = "mod_recycler"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT*2,
	)
	build_path = /obj/item/mod/module/recycler
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)

/datum/design/module/shooting_assistant
	name = "射击助手模块"
	id = "mod_shooting"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*2,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/shooting_assistant
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SECURITY
	)

//MODsuit anomalock modules
/datum/design/module/mod_antigrav
	name = "反重力模块"
	id = "mod_antigrav"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT *1.25,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium =SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/anomaly_locked/antigrav
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SCIENCE
	)

/datum/design/module/mod_teleporter
	name = "传送器模块"
	id = "mod_teleporter"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT *1.25,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace =SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/anomaly_locked/teleporter
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SCIENCE
	)

/datum/design/module/mod_kinesis
	name = "念力模块"
	id = "mod_kinesis"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT *1.25,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/anomaly_locked/kinesis
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_ENGINEERING
	)

/datum/design/module/fishing_glove
	name = "MOD钓鱼手套模块"
	id = "mod_fishing"
	materials = list(
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/mod/module/fishing_glove

/datum/design/posisphere
	name = "正电子球体"
	desc = "人工烦扰技术的最新成果。"
	id = "posisphere"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 0.85,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 0.65,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT * 2.5
	)
	construction_time = 7.5 SECONDS
	build_path = /obj/item/mmi/posibrain/sphere
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/module/mister_janitor
	name = "清洁喷雾器模块"
	id = "mod_mister_janitor"
	materials = list(
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT * 1,
	)
	build_path = /obj/item/mod/module/mister/cleaner
	category = list(
		RND_CATEGORY_MODSUIT_MODULES + RND_SUBCATEGORY_MODSUIT_MODULES_SERVICE
	)
