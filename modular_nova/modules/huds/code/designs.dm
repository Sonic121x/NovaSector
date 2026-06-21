/datum/design/health_hud_prescription
	name = "处方健康扫描仪HUD"
	desc = "一种平视显示器，可以扫描视野中的人类并提供其健康状况的准确数据。这款带有处方镜片。"
	id = "health_hud_prescription"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/health/prescription
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/security_hud_prescription
	name = "处方安保HUD"
	desc = "一种平视显示器，可扫描视野内的人类并提供其身份状态的准确数据。这款配有处方镜片。"
	id = "security_hud_prescription"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/security/prescription
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/diagnostic_hud_prescription
	name = "处方诊断HUD"
	desc = "一种用于分析和确定机器人机械故障的HUD。这款配有处方镜片。"
	id = "diagnostic_hud_prescription"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/hud/diagnostic/prescription
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/science_hud_prescription
	name = "处方科研HUD"
	desc = "这些眼镜可扫描容器内容物，并以易于阅读的格式将其内容投影给用户。这款配有处方镜片。"
	id = "science_hud_prescription"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/science/prescription
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/mesons_prescription
	name = "处方光学介子扫描仪"
	desc = "供工程和采矿人员使用，用于透过墙壁观察基本结构和地形布局，不受光照条件影响。此设计已加入处方镜片。"
	id = "mesons_prescription"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/meson/prescription
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/engine_goggles_prescription
	name = "处方工程扫描护目镜"
	desc = "工程师使用的护目镜。介子扫描模式可让您透过墙壁观察基本结构和地形布局，不受光照条件影响。T射线扫描模式可让您看到地板下的物体，如电缆和管道。此设计已加入处方镜片。"
	id = "engine_goggles_prescription"
	build_type = PROTOLATHE | AWAY_LATHE | COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/glasses/meson/engine/prescription
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/tray_goggles_prescription
	name = "处方光学T射线扫描仪"
	desc = "供工程人员使用，用于查看地板下的物体，如电缆和管道。此设计已加入处方镜片。"
	id = "tray_goggles_prescription"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/clothing/glasses/meson/engine/tray/prescription
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING
