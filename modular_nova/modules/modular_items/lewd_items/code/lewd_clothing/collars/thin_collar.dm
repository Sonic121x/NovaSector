/obj/item/clothing/neck/collar/bell
	name = "铃铛项圈"
	desc = "一个配有锁扣的项圈——正面固定着一个会叮当作响的小铃铛。"
	greyscale_colors = "#2d2d33#dead39"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/bell"
	post_init_icon_state = "bell_collar"
	greyscale_config = /datum/greyscale_config/thin_collar/bell
	greyscale_config_worn = /datum/greyscale_config/thin_collar/bell/worn


/obj/item/clothing/neck/collar/bell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/effects/jingle.ogg'=1), 25, 50, 16)


/obj/item/clothing/neck/collar/cowbell // I'd give this jingling too but it's harder to source a good sample
	name = "牛铃项圈"
	desc = "一个配有锁扣的项圈——和它前面挂着的牛铃比起来，简直像个侏儒！"
	icon_state = "/obj/item/clothing/neck/collar/cowbell"
	post_init_icon_state = "cowbell_collar"
	greyscale_colors = "#2d2d33#dead39"
	greyscale_config = /datum/greyscale_config/thin_collar/cowbell
	greyscale_config_worn = /datum/greyscale_config/thin_collar/cowbell/worn


/obj/item/clothing/neck/collar/cross
	name = "十字项圈"
	desc = "一个配有锁扣的项圈。这个项圈的吊牌是个小十字架。"
	greyscale_colors = "#2d2d33#dead39"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/cross"
	post_init_icon_state = "cross_collar"
	greyscale_config = /datum/greyscale_config/thin_collar/cross
	greyscale_config_worn = /datum/greyscale_config/thin_collar/cross/worn


/obj/item/clothing/neck/collar/tagged
	name = "挂牌项圈"
	desc = "一个配有锁扣的项圈。这个项圈前面有个空白的吊牌，可以随时刻字。"
	greyscale_colors = "#2d2d33#dead39"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/tagged"
	post_init_icon_state = "tagged_collar"
	greyscale_config = /datum/greyscale_config/thin_collar/tagged
	greyscale_config_worn = /datum/greyscale_config/thin_collar/tagged/worn


/obj/item/clothing/neck/collar/holocollar
	name = "全息项圈"
	desc = "一个配有锁扣的项圈。这个项圈前面有个花哨的全息吊牌。"
	greyscale_colors = "#2d2d33#dead39"
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/collar/holocollar"
	post_init_icon_state = "holocollar"
	greyscale_config = /datum/greyscale_config/thin_collar/holo
	greyscale_config_worn = /datum/greyscale_config/thin_collar/holo/worn
