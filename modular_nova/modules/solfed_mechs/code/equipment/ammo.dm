/obj/item/mecha_ammo/teargas
	name = "可发射催泪瓦斯榴弹"
	desc = "一箱密封的催泪瓦斯榴弹，用于大型外骨骼发射器。无法手动启动。"
	icon = 'modular_nova/modules/solfed_mechs/icons/mecha_ammo.dmi'
	icon_state = "teargas"
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2, /datum/material/silver=SMALL_MATERIAL_AMOUNT*5)
	rounds = 6
	ammo_type = MECHA_AMMO_TEARGAS

/obj/item/mecha_ammo/siege
	name = "40x250mm 尾翼稳定脱壳穿甲弹箱"
	desc = "A crate of hyperdense sabot slugs for siege-grade mech weapons. Designed for the T-99 'Hammerfall' mass driver."
	icon = 'modular_nova/modules/solfed_mechs/icons/mecha_ammo.dmi'
	icon_state = "sabot"
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT*10)
	rounds = 24
	ammo_type = MECHA_AMMO_SIEGE

/obj/item/mecha_ammo/emp
	name = "EMP 脉冲电池组"
	desc = "一包密封的 EMP 脉冲电池，专为赫尔墨斯级电子战步枪校准。发射聚焦脉冲，旨在瘫痪电子设备而不造成结构损坏。"
	icon = 'modular_nova/modules/solfed_mechs/icons/mecha_ammo.dmi'
	icon_state = "emp"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/uranium = SMALL_MATERIAL_AMOUNT*3)
	rounds = 12
	ammo_type = MECHA_AMMO_EMP

/obj/item/mecha_ammo/rubber
	name = "橡胶弹箱"
	desc = "一箱用于非致命性暴乱镇压的高密度橡胶弹。兼容外骨骼安装的防暴枪。"
	icon = 'modular_nova/modules/solfed_mechs/icons/mecha_ammo.dmi'
	icon_state = "rubber"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/plastic = SMALL_MATERIAL_AMOUNT*5)
	rounds = 24
	ammo_type = MECHA_AMMO_RUBBER
