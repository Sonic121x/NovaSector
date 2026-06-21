/obj/item/clothing/head/cowboy
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/cowboy/nova
	name = "SR 牛仔帽 调试"
	desc = "发现此物品请上报"
	icon = 'modular_nova/master_files/icons/obj/clothing/head/cowboy.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/cowboy.dmi'
	icon_state = null //Keeps this from showing up under the chameleon hat
	worn_icon_state = null //TG defaults this to "hunter" and breaks our items
	flags_inv = SHOWSPRITEEARS
	armor_type = /datum/armor/none
	resistance_flags = NONE //TG defaults cowboy hats to fireproof/acidproof

/obj/item/clothing/head/cowboy/nova/wide
	name = "宽檐帽"
	desc = "一顶宽檐帽，让你有型地遮挡阳光。"
	greyscale_colors = "#4D4D4D#DE9754"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/cowboy/nova/wide"
	post_init_icon_state = "widebrim"
	greyscale_config = /datum/greyscale_config/cowboy_wide
	greyscale_config_worn = /datum/greyscale_config/cowboy_wide/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/cowboy/nova/wide/feathered
	name = "宽檐羽毛帽"
	desc = "一顶饰有羽毛的宽檐帽，为粗犷的装束增添完美的点缀。"
	greyscale_colors = "#4D4D4D#DE9754#D5D5B9"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/cowboy/nova/wide/feathered"
	post_init_icon_state = "widebrim_feathered"
	greyscale_config = /datum/greyscale_config/cowboy_wide_feathered
	greyscale_config_worn = /datum/greyscale_config/cowboy_wide_feathered/worn

/obj/item/clothing/head/cowboy/nova/flat
	name = "平檐帽"
	desc = "一顶做工精良、带有短平帽檐的帽子，非常适合老式的枪战。"
	greyscale_colors = "#BE925B#914C2F"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/cowboy/nova/flat"
	post_init_icon_state = "flatbrim"
	greyscale_config = /datum/greyscale_config/cowboy_flat
	greyscale_config_worn = /datum/greyscale_config/cowboy_flat/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/cowboy/nova/flat/cowl
	name = "带兜帽的平檐帽"
	desc = "一顶做工精良、带有短平帽檐的帽子，搭配舒适保暖的兜帽。今天是个赴死的寒冷日子..."
	greyscale_colors = "#c26934#8f89ae#774B2D"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/cowboy/nova/flat/cowl"
	post_init_icon_state = "flatbrim_cowl"
	greyscale_config = /datum/greyscale_config/cowboy_flat_cowl
	greyscale_config_worn = /datum/greyscale_config/cowboy_flat_cowl/worn
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR | SHOWSPRITEEARS

/obj/item/clothing/head/cowboy/nova/cattleman
	name = "牧人帽"
	desc = "一顶带有折痕帽檐和高顶的帽子，旨在恶劣天气中能更紧实地戴在头上。在太空中不那么相关，但仍然派得上用场。"
	greyscale_colors = "#725443#B2977C"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/cowboy/nova/cattleman"
	post_init_icon_state = "cattleman"
	greyscale_config = /datum/greyscale_config/cowboy_cattleman
	greyscale_config_worn = /datum/greyscale_config/cowboy_cattleman/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/cowboy/nova/cattleman/wide
	name = "宽檐牛仔帽"
	desc = "一顶帽檐宽大、略有褶皱的帽子。适合在阳光下工作，但不怎么适合穿过狭窄的缝隙。"
	greyscale_colors = "#4D4D4D#5F666E"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/cowboy/nova/cattleman/wide"
	post_init_icon_state = "cattleman_wide"
	greyscale_config = /datum/greyscale_config/cowboy_cattleman_wide
	greyscale_config_worn = /datum/greyscale_config/cowboy_cattleman_wide/worn
	flags_1 = IS_PLAYER_COLORABLE_1

//Presets
/obj/item/clothing/head/cowboy/nova/flat/sheriff
	name = "警长帽"
	desc = "一顶深棕色的帽子，带着威士忌的气味。内侧绣着一小对鹿角。"
	icon_state = "/obj/item/clothing/head/cowboy/nova/flat/sheriff"
	greyscale_colors = "#704640#8f89ae"
	flags_1 = NONE //No recoloring presets

/obj/item/clothing/head/cowboy/nova/flat/deputy
	name = "副警长帽"
	desc = "一顶浅棕色的帽子，带着铁的气味。内侧绣着一小对鹿角。"
	icon_state = "/obj/item/clothing/head/cowboy/nova/flat/deputy"
	greyscale_colors = "#c26934#8f89ae"
	flags_1 = NONE //No recoloring presets

/obj/item/clothing/head/cowboy/nova/flat/cowl/sheriff
	name = "冬季警长帽"
	desc = "一顶深色帽子，配有同色的深色兜帽，温暖又透气。内侧绣着一小对鹿角。"
	icon_state = "/obj/item/clothing/head/cowboy/nova/flat/cowl/sheriff"
	icon_state = "/obj/item/clothing/head/cowboy/nova/flat/cowl/sheriff"
	greyscale_colors = "#3F3F3F#716349#3F3F3F"
	flags_1 = NONE //No recoloring presets

/obj/item/clothing/head/cowboy/nova/cattleman/sec
	name = "安保牛仔帽"
	desc = "一顶安保牛仔帽，是任何真正执法者的完美选择。"
	icon_state = "/obj/item/clothing/head/cowboy/nova/cattleman/sec"
	greyscale_colors = "#39393F#3F6E9E"
	armor_type = /datum/armor/head_helmet
	flags_1 = NONE //No recoloring presets

/obj/item/clothing/head/cowboy/nova/cattleman/wide/sec
	name = "宽檐安保牛仔帽"
	desc = "一个强盗出身的警长，他的执法手段残酷但有效——究竟是出于恐惧还是尊重尚不清楚，不过高悬的尸体倒也不多。一片和平的土地，一群安静的人民。"
	icon_state = "/obj/item/clothing/head/cowboy/nova/cattleman/wide/sec"
	greyscale_colors = "#39393F#3F6E9E"
	armor_type = /datum/armor/head_helmet
	flags_1 = NONE //No recoloring presets
