/obj/structure/medieval/stone_arch
	name = "石拱门"
	desc = "一个大型装饰性拱门。"
	icon = 'modular_nova/master_files/icons/obj/medieval/stone_arch.dmi'
	icon_state = "stone_arch"
	density = FALSE
	max_integrity = 150
	pixel_x = 0
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE

/obj/structure/medieval/stone_arch/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_SHIPPING_CONTAINER)

/obj/structure/medieval/wine_barrel
	name = "酒桶"
	desc = "一个侧放的装饰性木桶，里面据说装着酒。"
	icon = 'modular_nova/master_files/icons/obj/medieval/structures.dmi'
	icon_state = "wine_barrel"
	density = TRUE
	max_integrity = 150
	pixel_x = 0

/obj/structure/medieval/bed_1x2
	name = "床"
	desc = "一张奢华的床，邀请您在上面休息，哦，旅人。"
	icon = 'modular_nova/master_files/icons/obj/medieval/structures_64x64.dmi'
	icon_state = "bed_1x2"
	layer = 2.2
	density = FALSE
	max_integrity = 150
	pixel_x = 0

/obj/structure/medieval/bed_2x2
	name = "床"
	desc = "一张奢华的床，邀请您在上面休息，哦，旅人。"
	icon = 'modular_nova/master_files/icons/obj/medieval/structures_64x64.dmi'
	icon_state = "bed_2x2"
	layer = 2.2
	density = FALSE
	max_integrity = 150
	pixel_x = 0

/obj/structure/sink/standalone
	name = "水槽"
	icon = 'modular_nova/master_files/icons/obj/medieval/structures.dmi'
	icon_state = "sink"
