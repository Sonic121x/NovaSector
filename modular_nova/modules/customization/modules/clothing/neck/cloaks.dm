/obj/item/clothing/neck/chaplain
	name = "主教斗篷"
	desc = "成为太空教皇。"
	icon = 'modular_nova/master_files/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/neck.dmi'
	icon_state = "bishopcloak"

/obj/item/clothing/neck/chaplain/black
	name = "黑色主教斗篷"
	icon_state = "blackbishopcloak"

/obj/item/clothing/neck/cloak/qm/nova/interdyne
	name = "甲板军官斗篷"
	desc = "一件象征着永恒货运王国的斗篷。织物上织有小小的莫辛-纳甘步枪纹章。"

/obj/item/clothing/neck/cowboylea
	name = "绿色牛仔披风"
	desc = "一件沾满沙尘的斗篷，内侧似乎绣着一个带鹿角的小鹿头。"
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	icon = 'modular_nova/master_files/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/neck.dmi'
	icon_state = "cowboy_poncho"
	heat_protection = CHEST

/obj/item/clothing/neck/cowboylea/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "over shoulder")

//This one is greyscale :)
/obj/item/clothing/neck/ranger_poncho
	name = "游骑兵披风"
	desc = "瞄准心脏，拉蒙。"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/ranger_poncho"
	post_init_icon_state = "ranger_poncho"
	greyscale_config = /datum/greyscale_config/ranger_poncho
	greyscale_config_worn = /datum/greyscale_config/ranger_poncho/worn
	greyscale_colors = "#917A57#858585"	//Roughly the same color as the original non-greyscale item was
	flags_1 = IS_PLAYER_COLORABLE_1
	heat_protection = CHEST

/obj/item/clothing/neck/ranger_poncho/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "over shoulder")

/obj/item/clothing/neck/long_cape
	name = "长斗篷"
	desc = "一件优雅的斗篷，精心地包裹着你的身体。"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/long_cape"
	post_init_icon_state = "long_cape"
	greyscale_config = /datum/greyscale_config/long_cape
	greyscale_config_worn = /datum/greyscale_config/long_cape/worn
	greyscale_colors = "#867361#4d433d#b2a69c#b2a69c"
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/long_cape/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "cover arm")

/obj/item/clothing/neck/wide_cape
	name = "宽斗篷"
	desc = "一件骄傲的、宽肩的斗篷，你可以用它来守护你后背的荣誉。"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/wide_cape"
	post_init_icon_state = "wide_cape"
	greyscale_config = /datum/greyscale_config/wide_cape
	greyscale_config_worn = /datum/greyscale_config/wide_cape/worn
	greyscale_colors = "#867361#4d433d#b2a69c"
	flags_1 = IS_PLAYER_COLORABLE_1
	body_parts_covered = CHEST|ARMS
