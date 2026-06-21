//////lavaland surface papers

/obj/item/paper/fluff/stations/lavaland/surface/henderson_report
	name = "重要通知——亨德森夫人"
	default_raw_text = "无重要情况报告。"

//ratvar

/obj/structure/dead_ratvar
	name = "拉特瓦残骸"
	desc = "吾长眠于此，静候使徒。"
	icon = 'icons/obj/mining_zones/dead_ratvar.dmi'
	icon_state = "dead_ratvar"
	flags_1 = ON_BORDER_1
	appearance_flags = LONG_GLIDE
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE
	anchored = TRUE
	density = TRUE
	bound_width = 416
	bound_height = 64
	pixel_y = -10
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/dead_ratvar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_RATVAR_WRECK)
