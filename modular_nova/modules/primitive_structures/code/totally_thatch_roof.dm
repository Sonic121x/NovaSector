/turf/open/misc/grass/roofing
	name = "茅草屋顶"
	desc = "一堆各种干枯的植物，已经不那么绿了，可以做成凑合的屋顶材料。"
	baseturfs = /turf/open/openspace/icemoon
	initial_gas_mix = "ICEMOON_ATMOS"
	icon_state = "grass-255"
	icon = 'modular_nova/modules/primitive_structures/icons/thatch.dmi'
	smooth_icon = 'modular_nova/modules/primitive_structures/icons/thatch.dmi'


/turf/open/floor/grass/thatch
	name = "茅草补丁"
	desc = "一堆各种干枯的植物，已经不那么绿了，可以做成凑合的地板材料"
	icon_state = "grass-255"
	base_icon_state = "grass"
	icon = 'modular_nova/modules/primitive_structures/icons/thatch.dmi'
	damaged_dmi = 'icons/turf/damaged.dmi'
	floor_tile = /obj/item/stack/tile/grass/thatch
	bullet_bounce_sound = null
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_FLOOR_GRASS
	canSmoothWith = SMOOTH_GROUP_FLOOR_GRASS + SMOOTH_GROUP_CLOSED_TURFS
	layer = HIGH_TURF_LAYER
	/// Icon used for smoothing
	var/smooth_icon = 'modular_nova/modules/primitive_structures/icons/thatch.dmi'


/turf/open/floor/grass/thatch/Initialize(mapload)
	. = ..()
	if(smoothing_flags)
		var/matrix/translation = new
		translation.Translate(-9, -9)
		transform = translation
		icon = smooth_icon


/turf/open/floor/grass/thatch/broken_states()
	return list("grass_damaged")


/turf/open/floor/grass/thatch/burnt_states()
	return list("grass_damaged")


/obj/item/stack/tile/grass/thatch
	name = "茅草瓦片"
	singular_name = "thatch floor tile"
	desc = "一块茅草，就像那些老式谷仓里用的那种。"
	icon_state = "tile_thatch"
	inhand_icon_state = "tile-thatch"
	icon = 'modular_nova/modules/primitive_structures/icons/thatch_obj.dmi'
	lefthand_file = 'modular_nova/modules/primitive_structures/icons/tile_lefthand.dmi'
	righthand_file = 'modular_nova/modules/primitive_structures/icons/tile_righthand.dmi'
	resistance_flags = FLAMMABLE
	turf_type = /turf/open/floor/grass/thatch
	merge_type = /obj/item/stack/tile/grass/thatch


/obj/item/food/grown/grass/thatch
	name = "茅草"
	desc = "又黄又干。"
	icon = 'modular_nova/modules/primitive_structures/icons/thatch_obj.dmi'
	icon_state = "thatch_clump"
	stacktype = /obj/item/stack/tile/grass/thatch


/obj/item/food/grown/grass/make_dryable()
	AddElement(/datum/element/dryable, /obj/item/food/grown/grass/thatch)
