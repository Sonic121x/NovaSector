/obj/effect/cosmic_diamond
	name = "宇宙钻石"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "cosmic_diamond"
	anchored = TRUE

/obj/effect/temp_visual/cosmic_cloud
	name = "宇宙云"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "cosmic_cloud"
	anchored = TRUE
	duration = 8

/obj/effect/temp_visual/cosmic_explosion
	name = "宇宙爆炸"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "cosmic_explosion"
	anchored = TRUE
	duration = 5
	pixel_x = -16
	pixel_y = -16

/obj/effect/temp_visual/space_explosion
	name = "太空爆炸"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "space_explosion"
	anchored = TRUE
	duration = 5
	pixel_x = -16
	pixel_y = -16

/obj/effect/temp_visual/cosmic_domain
	name = "宇宙领域"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "cosmic_domain"
	anchored = TRUE
	duration = 6
	pixel_x = -64
	pixel_y = -64

/obj/effect/temp_visual/cosmic_gem
	name = "宇宙宝石"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "cosmic_gem"
	duration = 12

/obj/effect/temp_visual/cosmic_gem/Initialize(mapload)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)
