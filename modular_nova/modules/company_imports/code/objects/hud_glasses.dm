/obj/item/clothing/glasses/hud/gun_permit
	name = "许可证HUD"
	desc = "一种平视显示器，可扫描视野内的人形生物，并显示其当前ID是否持有枪支许可证。"
	icon = 'modular_nova/modules/company_imports/icons/hud_goggles.dmi'
	worn_icon = 'modular_nova/modules/company_imports/icons/hud_goggles_worn.dmi'
	icon_state = "permithud"
	clothing_traits = list(TRAIT_PERMIT_HUD)

/obj/item/clothing/glasses/hud/gun_permit/sunglasses
	name = "许可证HUD太阳镜"
	desc = "一副带有平视显示功能的太阳镜，可扫描视野内的人形生物，并显示其当前ID是否持有枪支许可证。"
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1

/datum/design/permit_hud
	name = "枪支许可证HUD眼镜"
	desc = "一种平视显示器，可扫描视野内的人形生物，并显示其当前ID是否持有枪支许可证。"
	id = "permit_glasses"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/clothing/glasses/hud/gun_permit
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO
