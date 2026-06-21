/*
*	The hoodies and attached sprites [WERE ORIGINALLY FROM] https://github.com/Citadel-Station-13/Citadel-Station-13-RP before GAGSification
*	Respective datums can be found in modular_nova/modules/customization/datums/greyscale/hoodies
*	These are now a subtype of toggle/jacket too, so it properly toggles and isnt the unused 'storage' type
*/

/obj/item/clothing/suit/toggle/jacket/nova/hoodie
	name = "连帽衫"
	desc = "一件温暖的连帽衫。你总忍不住去摆弄它的拉链……"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie"
	post_init_icon_state = "hoodie"
	greyscale_config = /datum/greyscale_config/hoodie
	greyscale_config_worn = /datum/greyscale_config/hoodie/worn
	greyscale_colors = "#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE
	min_cold_protection_temperature = T0C - 20	//Not as good as the base jacket

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/trim
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/trim"
	post_init_icon_state = "hoodie_trim"
	greyscale_config = /datum/greyscale_config/hoodie_trim
	greyscale_config_worn = /datum/greyscale_config/hoodie_trim/worn
	greyscale_colors = "#ffffff#313131"

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/trim/alt
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/trim/alt"
	post_init_icon_state = "hoodie_trim_alt"

/*
*	PRESET GREYSCALES & BRANDED
*/

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/grey
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/grey"
	greyscale_colors = "#a8a8a8"
	flags_1 = NONE

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/black
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/black"
	greyscale_colors = "#313131"
	flags_1 = NONE

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/red
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/red"
	greyscale_colors = "#D13838"
	flags_1 = NONE

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/blue
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/blue"
	greyscale_colors = "#034A8D"
	flags_1 = NONE

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/green
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/green"
	greyscale_colors = "#1DA103"
	flags_1 = NONE

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/orange
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/orange"
	greyscale_colors = "#F79305"
	flags_1 = NONE

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/yellow
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/yellow"
	greyscale_colors = "#F0D655"
	flags_1 = NONE

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded
	name = "\improper 纳米传讯连帽衫"
	desc = "一件温暖的蓝色运动衫。背面骄傲地印有银色的纳米传讯标志字母。边缘饰有银色滚边。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded"
	post_init_icon_state = "hoodie_NT"
	greyscale_config = /datum/greyscale_config/hoodie_branded
	greyscale_config_worn = /datum/greyscale_config/hoodie_branded/worn
	greyscale_colors = "#02519A#ffffff"
	flags_1 = NONE

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/nrti
	name = "\improper NRTI连帽衫"
	desc = "一件温暖的灰色运动衫。背面印有字母“NRT”，指的是希芙星上首屈一指的新雷克雅未克技术学院。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/nrti"
	post_init_icon_state = "hoodie_NRTI"
	greyscale_colors = "#747474#a83232"

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/mu
	name = "\improper MU连帽衫"
	desc = "一件温暖的灰色运动衫。正面印有字母“MU”，指的是知名的公立大学——莫哈维大学。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/mu"
	post_init_icon_state = "hoodie_MU"
	greyscale_colors = "#747474#ffffff"

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/cti
	name = "\improper CTI连帽衫"
	desc = "一件温暖的黑色运动衫。背面印有字母‘CTI’，指的是天仓五星系中享有盛誉的大学——塞提技术学院。正面绣有一颗蓝色的超新星图案，那是CTI的徽章。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/cti"
	post_init_icon_state = "hoodie_CTI"
	greyscale_colors = "#313131#ffffff"

/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/smw
	name = "\improper 太空山风连帽衫"
	desc = "一件温暖的黑色运动衫。前后都印有流行软饮料“太空山风”的商标。"
	icon_state = "/obj/item/clothing/suit/toggle/jacket/nova/hoodie/branded/smw"
	post_init_icon_state = "hoodie_SMW"
	greyscale_colors = "#313131#ffffff"

/obj/item/clothing/suit/jacket/bomber
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/jacket/bomber"
	post_init_icon_state = "bomberjacket"
	greyscale_config = /datum/greyscale_config/tg_bomberjacket
	greyscale_config_worn = /datum/greyscale_config/tg_bomberjacket/worn
	greyscale_colors = "#806253#D6C8B4"
	flags_1 = IS_PLAYER_COLORABLE_1
