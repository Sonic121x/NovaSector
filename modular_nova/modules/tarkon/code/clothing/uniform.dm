/obj/item/clothing/under/tarkon
	name = "塔康货运制服"
	desc = "由塔康工业提供的、供货运部门船员穿着的制服。"
	worn_icon = 'modular_nova/modules/tarkon/icons/mob/clothing/uniform.dmi'
	worn_icon_digi = 'modular_nova/modules/tarkon/icons/mob/clothing/uniform_digi.dmi'
	body_parts_covered = CHEST|ARMS|GROIN|LEGS
	armor_type = /datum/armor/clothing_under/tarkon
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/tarkon"
	post_init_icon_state = "tarkon_recolor"
	greyscale_config = /datum/greyscale_config/tarkonuniform
	greyscale_config_worn = /datum/greyscale_config/tarkonuniform/worn
	greyscale_config_worn_digi = /datum/greyscale_config/tarkonuniform/worn/digi
	greyscale_colors = "#B7793D"

/obj/item/clothing/under/tarkon/sci
	name = "塔康研究制服"
	desc = "由塔康工业提供的、供研究部门船员穿着的制服。"
	icon_state = "/obj/item/clothing/under/tarkon/sci"
	post_init_icon_state = "tarkon_recolor"
	greyscale_colors = "#9E00EA"

/obj/item/clothing/under/tarkon/sec
	name = "塔康安保制服"
	desc = "由塔康工业提供的、供安保部门船员穿着的制服。"
	icon_state = "/obj/item/clothing/under/tarkon/sec"
	post_init_icon_state = "tarkon_recolor"
	armor_type = /datum/armor/clothing_under/tarkon
	greyscale_colors = "#B72B2F"

/obj/item/clothing/under/tarkon/med
	name = "塔康医疗制服"
	desc = "由塔康工业提供的、供医疗部门船员穿着的制服。"
	icon_state = "/obj/item/clothing/under/tarkon/med"
	post_init_icon_state = "tarkon_recolor"
	greyscale_colors = "#85C1E6"

/obj/item/clothing/under/tarkon/eng
	name = "塔康维护区制服"
	desc = "由塔康工业提供的、供维护区船员穿着的制服。"
	icon_state = "/obj/item/clothing/under/tarkon/eng"
	post_init_icon_state = "tarkon_recolor"
	greyscale_colors = "#ff9900"

/obj/item/clothing/under/tarkon/com
	name = "塔康指挥制服"
	desc = "由塔康工业提供的、供指挥部门船员穿着的制服。"
	icon_state = "/obj/item/clothing/under/tarkon/com"
	post_init_icon_state = "tarkon_recolor"
	armor_type = /datum/armor/clothing_under/tarkon
	greyscale_colors = "#3F6E9E"

/obj/item/clothing/under/tarkon/general
	name = "塔康通用制服"
	desc = "由塔康工业提供的、供文职船员穿着的制服。"
	icon = 'modular_nova/modules/tarkon/icons/obj/clothing/uniform.dmi'
	icon_state = "tarkon"
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	greyscale_colors = null

/datum/armor/clothing_under/tarkon
	melee = 10
	fire = 50
	acid = 50
	wound = 10
