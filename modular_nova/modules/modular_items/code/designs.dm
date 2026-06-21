/*
* Designs
*/

/datum/design/health_hud_aviator
	name = "医疗HUD飞行员墨镜"
	desc = "一种平视显示器，可扫描视野内的人形生物并提供其健康状况的准确数据。该HUD已安装在一副太阳镜内。"
	id = "health_hud_aviator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/aviator/health
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/security_hud_aviator
	name = "安保HUD飞行员墨镜"
	desc = "一种平视显示器，可扫描视野内的人类并提供其身份状态的准确数据。该HUD已安装在一副太阳镜内。"
	id = "security_hud_aviator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/aviator/security
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/diagnostic_hud_aviator
	name = "诊断HUD飞行员墨镜"
	desc = "一种用于分析和确定机器人机械故障的平视显示器。该HUD已安装在一副太阳镜内。"
	id = "diagnostic_hud_aviator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/aviator/diagnostic
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/meson_hud_aviator
	name = "介子HUD飞行员墨镜"
	desc = "一种供工程和采矿人员使用的平视显示器，用于透过墙壁观察基本结构和地形布局，不受光照条件影响。该HUD已安装在一副太阳镜内。"
	id = "meson_hud_aviator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/aviator/meson
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/science_hud_aviator
	name = "科研飞行员墨镜"
	desc = "一副俗气的紫色飞行员太阳镜，佩戴者只需一瞥就能识别各种化合物。"
	id = "science_hud_aviator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/aviator/science
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/health_hud_projector
	name = "视网膜投影仪医疗HUD"
	desc = "一副配备扫描镜头和视网膜投影仪的头戴式耳机。它不提供任何眼部保护，但比护目镜更不显眼。"
	id = "health_hud_projector"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/projector/health
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/security_hud_projector
	name = "视网膜投影仪安保HUD"
	desc = "一副配备扫描镜头和视网膜投影仪的头戴式耳机。它不提供任何眼部保护，但比护目镜更不显眼。"
	id = "security_hud_projector"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/projector/security
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/diagnostic_hud_projector
	name = "视网膜投影器诊断平视显示器"
	desc = "配备扫描镜头和视网膜投影器的头戴式耳机。它不提供任何眼部保护，但比护目镜更不显眼。"
	id = "diagnostic_hud_projector"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/projector/diagnostic
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/meson_hud_projector
	name = "视网膜投影器介子平视显示器"
	desc = "配备扫描镜头和视网膜投影器的头戴式耳机。它不提供任何眼部保护，但比护目镜更不显眼。"
	id = "meson_hud_projector"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/projector/meson
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/science_hud_projector
	name = "科研视网膜投影器"
	desc = "配备扫描镜头和视网膜投影器的头戴式耳机。它不提供任何眼部保护，但比护目镜更不显眼。"
	id = "science_hud_projector"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/ar/projector/science
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL
