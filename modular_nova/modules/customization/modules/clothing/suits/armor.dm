// MODULAR ARMOUR

// WARDEN
/obj/item/clothing/suit/armor/vest/warden/syndicate
	name = "军械长背心"
	desc = "令人惊叹。充满威胁。非常适合那个因为离开禁闭室而被欺负的家伙。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "warden_syndie"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

// HEAD OF PERSONNEL
/obj/item/clothing/suit/armor/vest/hop/hop_formal
	name = "人事主管的阅兵夹克"
	desc = "一件为人事主管准备的奢华深蓝色夹克，饰有红色镶边。散发着官僚主义的气息。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "hopformal"

/obj/item/clothing/suit/armor/vest/hop/hop_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

// CAPTAIN
/obj/item/clothing/suit/armor/vest/capcarapace/jacket
	name = "舰长夹克"
	desc = "一件采用舰长配色的轻便装甲夹克。适合当你想要更时尚的款式时。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "capjacket_casual"
	body_parts_covered = CHEST|ARMS
