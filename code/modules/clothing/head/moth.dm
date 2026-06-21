/obj/item/clothing/head/mothcap
	name = "飞蛾软帽"
	desc = "带护目镜的软皮帽，飞蛾舰队的标准装备。让你的头保持温暖，还能防止杂物进入你的大眼睛。"
	icon_state = "mothcap"
	icon = 'icons/obj/clothing/head/moth.dmi'
	worn_icon = 'icons/mob/clothing/head/moth.dmi'
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR

/obj/item/clothing/head/mothcap/original
	desc = "一顶配有放大镜护目镜的正宗加垫皮帽，飞蛾舰队标准配备。保暖头部，保护大眼睛免受碎屑侵扰。"

/obj/item/clothing/head/mothcap/original/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.2, zoom_method = ZOOM_METHOD_ITEM_ACTION, item_action_type = /datum/action/item_action/hands_free/moth_googles)
	AddElement(/datum/element/adjust_fishing_difficulty, -4)
