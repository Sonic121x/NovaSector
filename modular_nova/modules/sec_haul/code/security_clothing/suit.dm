/datum/atom_skin/security_armor_vest_white
	abstract_type = /datum/atom_skin/security_armor_vest_white

/datum/atom_skin/security_armor_vest_white/black
	preview_name = "Black Variant"
	new_icon_state = "vest_black"

/datum/atom_skin/security_armor_vest_white/blue
	preview_name = "Blue Variant"
	new_icon_state = "vest_blue"

/datum/atom_skin/security_armor_vest_white/white
	preview_name = "White Variant"
	new_icon_state = "vest_white"

/obj/item/clothing/suit/armor/vest/alt/sec/white
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "vest_white"

/obj/item/clothing/suit/armor/vest/alt/sec/white/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/security_armor_vest_white)

/obj/item/clothing/suit/armor/vest/brit
	name = "高可见度装甲背心"
	desc = "喂老兄，你有那玩意的许可证吗？"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "hazardbg"
	worn_icon_state = "hazardbg"

/obj/item/clothing/suit/armor/vest/brit/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "zipper")

/datum/atom_skin/vested_jacket
	abstract_type = /datum/atom_skin/vested_jacket

/datum/atom_skin/vested_jacket/red
	preview_name = "Red Variant"
	new_icon_state = "vested_jacket"

/datum/atom_skin/vested_jacket/blue
	preview_name = "Blue Variant"
	new_icon_state = "vested_jacket_blue"

/datum/atom_skin/vested_jacket/white
	preview_name = "White Variant"
	new_icon_state = "vested_jacket_white"

/datum/atom_skin/vested_jacket/black
	preview_name = "Black Variant"
	new_icon_state = "vested_jacket_black"

/obj/item/clothing/suit/armor/vest/vested_jacket
	name = "带背心安保夹克"
	desc = "公司标准装甲，现在缝上了一件时尚的拉链夹克，适用于你觉得不会挨枪子的时候！"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "vested_jacket"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS

/obj/item/clothing/suit/armor/vest/vested_jacket/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/vested_jacket)
	AddComponent(/datum/component/toggle_icon, "zipper")

/obj/item/clothing/head/hooded/winterhood/security/blue
	desc = "一顶蓝色的、带有装甲衬垫的冬季兜帽。绝对不防弹，尤其是你脸要露出来的那部分。"
	icon = 'modular_nova/master_files/icons/obj/clothing/head/winterhood.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/winterhood.dmi'
	icon_state = "winterhood_security"

/obj/item/clothing/suit/hooded/wintercoat/security/blue
	name = "安保冬季大衣"
	desc = "一件蓝色的、带有装甲衬垫的冬季大衣。它闪烁着微弱的消融涂层光泽，散发着一种不容置疑的权威感。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/wintercoat.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/wintercoat.dmi'
	icon_state = "coatsecurity_winter"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/security/blue

/*
*	WARDEN
*/

/obj/item/clothing/suit/armor/vest/warden/blue
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "vest_warden"

/*
*	Head of Security
*/

/obj/item/clothing/suit/armor/hos/hos_formal/black
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "hosformal_black"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
