/obj/item/clothing/neck/collar/leather
	name = "皮革项圈"
	desc = "一个由皮革制成的坚固项圈；配有锁扣。前面有一个小金属环。"
	greyscale_colors = "#2d2d33#9b111e"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/leather"
	post_init_icon_state = "leather_collar"
	greyscale_config = /datum/greyscale_config/leather_collar
	greyscale_config_worn = /datum/greyscale_config/leather_collar/worn


/obj/item/clothing/neck/collar/leather/bell
	name = "皮革铃铛项圈"
	desc = /obj/item/clothing/neck/collar/bell::desc
	greyscale_colors = "#2d2d33#9b111e#dead39"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/leather/bell"
	post_init_icon_state = "leather_bell_collar"
	greyscale_config = /datum/greyscale_config/leather_collar/bell
	greyscale_config_worn = /datum/greyscale_config/leather_collar/bell/worn


/obj/item/clothing/neck/collar/leather/bell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/effects/jingle.ogg'=1), 25, 50, 16)


/obj/item/clothing/neck/collar/leather/cowbell // I'd give this jingling too but it's harder to source a good sample
	name = "皮革牛铃项圈"
	desc = /obj/item/clothing/neck/collar/thick/cowbell::desc
	icon_state = "/obj/item/clothing/neck/collar/leather/cowbell"
	post_init_icon_state = "leather_cowbell_collar"
	greyscale_colors = /obj/item/clothing/neck/collar/leather/bell::greyscale_colors
	greyscale_config = /datum/greyscale_config/leather_collar/cowbell
	greyscale_config_worn = /datum/greyscale_config/leather_collar/cowbell/worn


/obj/item/clothing/neck/collar/leather/cross
	name = "皮革十字项圈"
	desc = /obj/item/clothing/neck/collar/cross::desc
	greyscale_colors = /obj/item/clothing/neck/collar/leather/bell::greyscale_colors
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/leather/cross"
	post_init_icon_state = "leather_cross_collar"
	greyscale_config = /datum/greyscale_config/leather_collar/cross
	greyscale_config_worn = /datum/greyscale_config/leather_collar/cross/worn


/obj/item/clothing/neck/collar/leather/tagged
	name = "皮革标签项圈"
	desc = /obj/item/clothing/neck/collar/tagged::desc
	greyscale_colors = /obj/item/clothing/neck/collar/leather/bell::greyscale_colors
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/leather/tagged"
	post_init_icon_state = "leather_tagged_collar"
	greyscale_config = /datum/greyscale_config/leather_collar/tagged
	greyscale_config_worn = /datum/greyscale_config/leather_collar/tagged/worn


/obj/item/clothing/neck/collar/leather/holocollar
	name = "皮革全息项圈"
	desc = /obj/item/clothing/neck/collar/holocollar::desc
	greyscale_colors = /obj/item/clothing/neck/collar/leather/bell::greyscale_colors
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/leather/holocollar"
	post_init_icon_state = "leather_holocollar"
	greyscale_config = /datum/greyscale_config/leather_collar/holo
	greyscale_config_worn = /datum/greyscale_config/leather_collar/holo/worn
