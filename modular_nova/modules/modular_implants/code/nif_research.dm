/datum/design/nifsoft_remover
	name = "Nanotrasen 'Wrangler' NIF-Cutter"
	desc = "一种小型设备，允许使用者从 NIF 用户身上移除 NIFSoft。"
	id = "nifsoft_remover"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/nifsoft_remover
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/nifsoft_money_sense
	name = "自动估价 NIFSoft"
	desc = "一张包含自动估价 NIFsoft 的 NIFSoft 数据盘。"
	id = "nifsoft_money_sense"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/disk/nifsoft_uploader/job/money_sense
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/soulcatcher_device
	name = "召唤者型 RSD"
	desc = "一种 RSD 仪器，允许使用者从身体中提取意识并以虚拟形式存储。"
	id = "soulcatcher_device"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/handheld_soulcatcher
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mini_soulcatcher
	name = "骚灵型 RSD"
	desc = "灵魂捕捉器的微型版本，可以附加到各种物体上。"
	id = "mini_soulcatcher"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/attachable_soulcatcher
	materials = list(
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/nif_detective_tools
	name = "魔典·瓦科利埃 NIFSoft"
	desc = "一张包含魔典·瓦科利埃 NIFSoft 的 NIFSoft 数据盘。"
	id = "nif_detective_tools"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/disk/nifsoft_uploader/job/summoner/detective
	materials = list(
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/nif_surgery_tools
	name = "魔典·阿斯克勒庇俄斯 NIFSoft"
	desc = "一张包含魔典·阿斯克勒庇俄斯 NIFSoft 的 NIFSoft 数据盘。"
	id = "nif_surgery_tools"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/disk/nifsoft_uploader/job/summoner/surgery
	materials = list(
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/nif_service_tools
	name = "魔典·赫斯提亚 NIFSoft"
	desc = "一张包含魔典·赫斯提亚 NIFSoft 的 NIFSoft 数据盘。"
	id = "nif_service_tools"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/disk/nifsoft_uploader/job/summoner/service
	materials = list(
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/nif_general_tools
	name = "魔典·欧佩拉 NIFSoft"
	desc = "一张包含魔典·欧佩拉 NIFSoft 的 NIFSoft 数据盘。"
	id = "nif_general_tools"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/disk/nifsoft_uploader/summoner/tools
	materials = list(
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS,
	)
	departmental_flags = ALL

/datum/design/nifsoft_hud
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_EQUIPMENT,
	)

/datum/design/nifsoft_hud/medical
	name = "医疗 HUD NIFSoft"
	desc = "一张包含医疗 HUD NIFSoft 的 NIFSoft 数据盘。"
	id = "nifsoft_hud_medical"
	build_path = /obj/item/disk/nifsoft_uploader/job/med_hud
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/nifsoft_hud/security
	name = "安保 HUD NIFSoft"
	desc = "一张包含安保 HUD NIFSoft 的 NIFSoft 数据盘。"
	id = "nifsoft_hud_security"
	build_path = /obj/item/disk/nifsoft_uploader/job/sec_hud
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/nifsoft_hud/cargo
	name = "许可 HUD NIFSoft"
	desc = "一张包含许可 HUD NIFSoft 的 NIFSoft 数据盘。"
	id = "nifsoft_hud_cargo"
	build_path = /obj/item/disk/nifsoft_uploader/job/permit_hud
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/nifsoft_hud/diagnostic
	name = "诊断 HUD NIFSoft"
	desc = "一张包含诊断 HUD NIFSoft 的 NIFSoft 数据盘。"
	id = "nifsoft_hud_diagnostic"
	build_path = /obj/item/disk/nifsoft_uploader/job/diag_hud
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/nifsoft_hud/science
	name = "科研 HUD NIFSoft"
	desc = "一张包含科研 HUD NIFSoft 的 NIFSoft 数据盘。"
	id = "nifsoft_hud_science"
	build_path = /obj/item/disk/nifsoft_uploader/job/sci_hud
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/nifsoft_hud/meson
	name = "介子 HUD NIFSoft"
	desc = "一张包含介子 HUD NIFSoft 的 NIFSoft 数据盘。"
	id = "nifsoft_hud_meson"
	build_path = /obj/item/disk/nifsoft_uploader/job/meson_hud
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/nif_hud_kit
	name = "NIF HUD 改装套件"
	desc = "一个用于改装特定眼镜以显示NIF平视显示器的套件。"
	id = "nifsoft_hud_kit"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SECURITY
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_EQUIPMENT,
	)
	build_path = /obj/item/nif_hud_adapter

