#define RND_SUBCATEGORY_WEAPONS_MEDICALAMMO "/Medical Ammunition"
#define RND_MEDICALAMMO_UTILITY " (Utility)"

//Upgrade Kit//
/datum/design/medigun_speedkit
	name = "维-医疗 CWM-479 升级套件"
	desc = "用于维-医疗 CWM-479 的升级套件，提供更高容量的内部电池，并提升充电器吞吐量。"
	id = "medigun_speed"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	materials = list(
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	build_path = /obj/item/device/custom_kit/medigun_fastcharge

/datum/design/medicell
	name = "基础医疗电池设计"
	desc = "嘿，你不应该看到这个。真的... 完全不应该。"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_MEDICALAMMO,
	)

//Tier 2 Medicells//

/datum/design/medicell/brute2
	name = "钝伤 II 医疗电池"
	desc = "为使用电池的医疗枪提供改进的钝伤治疗功能。"
	id = "brute2medicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/brute/tier_2

/datum/design/medicell/burn2
	name = "烧伤 II 医疗电池"
	desc = "为使用电池的医疗枪提供改进的烧伤治疗功能。"
	id = "burn2medicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/burn/tier_2

/datum/design/medicell/toxin2
	name = "毒素 II 医疗电池"
	desc = "为使用电池的医疗枪提供改进的毒素伤害治疗功能。"
	id = "toxin2medicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/toxin/tier_2

/datum/design/medicell/oxy2
	name = "缺氧 II 医疗电池"
	desc = "为使用电池的医疗枪提供改进的缺氧治疗功能。"
	id = "oxy2medicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/oxygen/tier_2

//Tier 3 Medicells//

/datum/design/medicell/brute3
	name = "钝伤 III 医疗电池"
	desc = "为使用电池的医疗枪提供高级钝伤治疗功能。"
	id = "brute3medicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/brute/tier_3

/datum/design/medicell/burn3
	name = "烧伤 III 医疗电池"
	desc = "为使用电池的医疗枪提供高级烧伤治疗功能。"
	id = "burn3medicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/burn/tier_3

/datum/design/medicell/toxin3
	name = "毒素 III 医疗电池"
	desc = "为使用电池的医疗枪提供高级毒素伤害治疗功能。"
	id = "toxin3medicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/toxin/tier_3

/datum/design/medicell/oxy3
	name = "缺氧 III 医疗电池"
	desc = "为使用电池的医疗枪提供高级缺氧治疗功能。"
	id = "oxy3medicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/oxygen/tier_3

//Utility Medicells

/datum/design/medicell/utility
	name = "通用医疗单元"
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_MEDICALAMMO + RND_MEDICALAMMO_UTILITY,
	)

/datum/design/medicell/utility/clot
	name = "凝血医疗单元"
	desc = "赋予装载医疗单元的医疗枪基于射弹的凝血功能。"
	id = "clotmedicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/weaponcell/medical/utility/clotting

/datum/design/medicell/utility/temp
	name = "温度调节医疗单元"
	desc = "赋予装载医疗单元的医疗枪基于射弹的体温调节功能。"
	id = "tempmedicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/weaponcell/medical/utility/temperature

/datum/design/medicell/utility/gown
	name = "硬光长袍医疗单元"
	desc = "赋予装载医疗单元的医疗枪基于射弹的硬光长袍部署功能。"
	id = "gownmedicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/weaponcell/medical/utility/hardlight_gown

/datum/design/medicell/utility/bed
	name = "硬光担架床医疗单元"
	desc = "赋予装载医疗单元的医疗枪基于射弹的硬光担架床部署功能。最适合用于已处于平躺状态的病人。"
	id = "bedmedicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/weaponcell/medical/utility/bed

/datum/design/medicell/utility/salve
	name = "空药膏医疗单元"
	desc = "一种不完整的医疗单元，需要一片芦荟叶才能完全发挥其潜力，提供基于射弹嵌入的持续治疗效果。"
	id = "salvemedicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/device/custom_kit/empty_cell

/datum/design/medicell/utility/body
	name = "空躯体传送医疗单元"
	desc = "一种不完整的医疗单元，需要一个蓝空史莱姆提取物才能提供基于射弹的遗体回收功能。"
	id = "bodymedicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/device/custom_kit/empty_cell/body_teleporter

/datum/design/medicell/utility/relocation
	name = "压迫性力量转移医疗单元"
	desc = "赋予装载医疗单元的医疗枪基于射弹的围观者转移功能，通过本征态操纵将他们倾倒入医疗部大厅。仅在医疗部内由授权用户发射时有效。"
	id = "relocatemedicell"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/device/custom_kit/empty_cell/relocator

#undef RND_SUBCATEGORY_WEAPONS_MEDICALAMMO
#undef RND_MEDICALAMMO_UTILITY
