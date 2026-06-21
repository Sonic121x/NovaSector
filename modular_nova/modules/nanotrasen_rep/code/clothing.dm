
//Uniform items are in command.dm

/obj/item/clothing/suit/armor/vest/nanotrasen_consultant
	name = "纳米传讯军官大衣"
	desc = "一件颈部带有真毛皮的高级黑色外套，里面似乎还有一些装甲衬垫。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "bladerunner"
	inhand_icon_state = "armor"
	blood_overlay_type = "suit"
	dog_fashion = null
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|ARMS|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON


/obj/item/clothing/suit/armor/vest/nanotrasen_consultant/green
	name = "nanotrasen officer's green coat"
	desc = "A premium green coat with real fur round the neck, it seems to have some armor padding inside as well."
	icon = 'icons/obj/clothing/suits/jacket.dmi'
	worn_icon = 'icons/mob/clothing/suits/jacket.dmi'
	icon_state = "centcom_coat"

/obj/item/clothing/head/nanotrasen_consultant
	name = "纳米传讯顾问帽"
	desc = "一顶由杜拉纤维制成的帽子，正面有一个徽章，标志着\"纳米传讯顾问\"的等级。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon_state = "nt_consultant_cap"
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/head_nanotrasen_consultant
	strip_delay = 60
	dog_fashion = null
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/datum/armor/head_nanotrasen_consultant
	melee = 15
	bullet = 5
	laser = 15
	energy = 25
	bomb = 10
	fire = 30
	acid = 5
	wound = 4

/obj/item/clothing/head/nanotrasen_consultant/beret
	name = "纳米传讯顾问贝雷帽"
	desc = "一顶由耐拉线制成的贝雷帽，正面有一个徽章，标志着\"纳米传讯顾问\"的军衔。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/nanotrasen_consultant/beret"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#3F3C40#155326"

/obj/item/clothing/head/beret/centcom_formal/nt_consultant
	armor_type = /datum/armor/beret_centcom_formal_nt_consultant

/datum/armor/beret_centcom_formal_nt_consultant
	melee = 15
	bullet = 5
	laser = 15
	energy = 25
	bomb = 10
	fire = 30
	acid = 5
	wound = 4

/obj/item/clothing/suit/armor/centcom_formal/nt_consultant
	armor_type = /datum/armor/armor_centcom_formal_nt_consultant

/datum/armor/armor_centcom_formal_nt_consultant
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/suit/hooded/wintercoat/centcom/nt_consultant
	armor_type = /datum/armor/centcom_nt_consultant

/datum/armor/centcom_nt_consultant
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/gloves/combat/naval/nanotrasen_consultant
	name = "\improper 中央司令部手套"
	desc = "一双高品质的厚手套，饰有金色缝线。"

/obj/item/clothing/gloves/combat/naval/nanotrasen_consultant/black
	name = "\improper 中央司令部黑色手套"
	desc = "一双高品质的厚实黑色手套，带有光滑的塑钛鳞片。"
	icon_state = "combat"
	greyscale_colors = "#2f2e31"
