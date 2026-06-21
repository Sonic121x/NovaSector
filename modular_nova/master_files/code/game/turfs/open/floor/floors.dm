/// Add atmos tiles here for planetside safety

/turf/open/misc/beach/sand/safe_planet
	/// Initial gas mix should always be the specific planet's atmos ID
	initial_gas_mix = SAFE_PLANET_ATMOS
	/// Planetary atmos specifically makes it so incorrect gasses are deleted overtime, such as plasma, carbon, etc. This prevents planets from suddenly having too much plasma from a turbine or SM waste.
	planetary_atmos = TRUE

/turf/open/misc/beach/coast/safe_planet
	initial_gas_mix = SAFE_PLANET_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/beach/coast/corner/safe_planet
	initial_gas_mix = SAFE_PLANET_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/grass/safe_planet
	initial_gas_mix = SAFE_PLANET_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/wood/large/safe_planet
	initial_gas_mix = SAFE_PLANET_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/wood/safe_planet
	initial_gas_mix = SAFE_PLANET_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/iron/safe_planet
	initial_gas_mix = SAFE_PLANET_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/stone/safe_planet
	initial_gas_mix = SAFE_PLANET_ATMOS
	planetary_atmos = TRUE

/turf/open/openspace/safe_planet
	initial_gas_mix = SAFE_PLANET_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/openspace/safe_planet

/turf/open/floor/iron/brick
	icon_state = "brick"
	base_icon_state = "brick"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick

/obj/item/stack/tile/iron/brick
	name = "砖块地板瓷砖"
	singular_name = "brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick"
	turf_type = /turf/open/floor/iron/brick
	merge_type = /obj/item/stack/tile/iron/brick
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/brick_half
	icon_state = "brick_half"
	base_icon_state = "brick_half"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_half

/obj/item/stack/tile/iron/brick_half
	name = "半砖块地板瓷砖"
	singular_name = "brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_half"
	turf_type = /turf/open/floor/iron/brick_half
	merge_type = /obj/item/stack/tile/iron/brick_half
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_half_vertical
	icon_state = "brick_half_vertical"
	base_icon_state = "brick_half_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_half_vertical

/obj/item/stack/tile/iron/brick_half_vertical
	name = "半砖块垂直地板瓷砖"
	singular_name = "brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_half_vertical"
	turf_type = /turf/open/floor/iron/brick_half_vertical
	merge_type = /obj/item/stack/tile/iron/brick_half_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_corner
	icon_state = "brick_corner"
	base_icon_state = "brick_corner"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_corner

/obj/item/stack/tile/iron/brick_corner
	name = "砖块地板角砖"
	singular_name = "brick floor corner tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_corner"
	turf_type = /turf/open/floor/iron/brick_corner
	merge_type = /obj/item/stack/tile/iron/brick_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_corner_inverse
	icon_state = "brick_corner_inverse"
	base_icon_state = "brick_corner_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_corner_inverse

/obj/item/stack/tile/iron/brick_corner_inverse
	name = "砖块地板反向角砖"
	singular_name = "brick floor inverse corner tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_corner_inverse"
	turf_type = /turf/open/floor/iron/brick_corner_inverse
	merge_type = /obj/item/stack/tile/iron/brick_corner_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_corner_vertical
	icon_state = "brick_corner_vertical"
	base_icon_state = "brick_corner_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_corner_vertical

/obj/item/stack/tile/iron/brick_corner_vertical
	name = "砖块地板垂直角砖"
	singular_name = "brick floor vertical corner tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_corner_vertical"
	turf_type = /turf/open/floor/iron/brick_corner_vertical
	merge_type = /obj/item/stack/tile/iron/brick_corner_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_corner_vertical_inverse
	icon_state = "brick_corner_vertical_inverse"
	base_icon_state = "brick_corner_vertical_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_corner_vertical_inverse

/obj/item/stack/tile/iron/brick_corner_vertical_inverse
	name = "砖块地板垂直反向角砖"
	singular_name = "brick floor vertical inverse corner tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_corner_vertical_inverse"
	turf_type = /turf/open/floor/iron/brick_corner_vertical_inverse
	merge_type = /obj/item/stack/tile/iron/brick_corner_vertical_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_aligned
	icon_state = "brick_aligned"
	base_icon_state = "brick_aligned"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_aligned

/obj/item/stack/tile/iron/brick_aligned
	name = "对齐砖块地板瓷砖"
	singular_name = "aligned brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_aligned"
	turf_type = /turf/open/floor/iron/brick_aligned
	merge_type = /obj/item/stack/tile/iron/brick_aligned
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_aligned_half
	icon_state = "brick_aligned_half"
	base_icon_state = "brick_aligned_half"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_aligned_half

/obj/item/stack/tile/iron/brick_aligned_half
	name = "半对齐砖块地板瓷砖"
	singular_name = "half aligned brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_aligned_half"
	turf_type = /turf/open/floor/iron/brick_aligned_half
	merge_type = /obj/item/stack/tile/iron/brick_aligned_half
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_aligned_half_vertical
	icon_state = "brick_aligned_half_vertical"
	base_icon_state = "brick_aligned_half_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_aligned_half_vertical

/obj/item/stack/tile/iron/brick_aligned_half_vertical
	name = "半对齐砖块地板垂直瓷砖"
	singular_name = "half aligned brick floor vertical tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_aligned_half_vertical"
	turf_type = /turf/open/floor/iron/brick_aligned_half_vertical
	merge_type = /obj/item/stack/tile/iron/brick_aligned_half_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_aligned_corner
	icon_state = "brick_aligned_corner"
	base_icon_state = "brick_aligned_corner"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_aligned_corner

/obj/item/stack/tile/iron/brick_aligned_corner
	name = "对齐砖块角砖"
	singular_name = "aligned brick corner"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_aligned_corner"
	turf_type = /turf/open/floor/iron/brick_aligned_corner
	merge_type = /obj/item/stack/tile/iron/brick_aligned_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_aligned_corner_inverse
	icon_state = "brick_aligned_corner_inverse"
	base_icon_state = "brick_aligned_corner_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_aligned_corner_inverse

/obj/item/stack/tile/iron/brick_aligned_corner_inverse
	name = "对齐砖块反向角砖"
	singular_name = "aligned brick inverse corner inverse"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_aligned_corner_inverse"
	turf_type = /turf/open/floor/iron/brick_aligned_corner_inverse
	merge_type = /obj/item/stack/tile/iron/brick_aligned_corner_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_aligned_corner_vertical
	icon_state = "brick_aligned_corner_vertical"
	base_icon_state = "brick_aligned_corner_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_aligned_corner_vertical

/obj/item/stack/tile/iron/brick_aligned_corner_vertical
	name = "对齐垂直砖块角砖"
	singular_name = "aligned vertical brick corner"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_aligned_corner_vertical"
	turf_type = /turf/open/floor/iron/brick_aligned_corner_vertical
	merge_type = /obj/item/stack/tile/iron/brick_aligned_corner_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/brick_aligned_corner_vertical_inverse
	icon_state = "brick_aligned_corner_vertical_inverse"
	base_icon_state = "brick_aligned_corner_vertical_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/brick_aligned_corner_vertical_inverse

/obj/item/stack/tile/iron/brick_aligned_corner_vertical_inverse
	name = "对齐垂直砖块反向角砖"
	singular_name = "aligned vertical brick inverse corner"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "brick_aligned_corner_vertical_inverse"
	turf_type = /turf/open/floor/iron/brick_aligned_corner_vertical_inverse
	merge_type = /obj/item/stack/tile/iron/brick_aligned_corner_vertical_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/pattern_1
	icon_state = "pattern_1"
	base_icon_state = "pattern_1"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_1

/obj/item/stack/tile/iron/pattern_1
	name = "对角线砖块瓷砖"
	singular_name = "diagonal brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_1"
	turf_type = /turf/open/floor/iron/pattern_1
	merge_type = /obj/item/stack/tile/iron/pattern_1
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/pattern_2
	icon_state = "pattern_2"
	base_icon_state = "pattern_2"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_2

/obj/item/stack/tile/iron/pattern_2
	name = "菱形螺旋砖块瓷砖"
	singular_name = "diamond spiral brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_2"
	turf_type = /turf/open/floor/iron/pattern_2
	merge_type = /obj/item/stack/tile/iron/pattern_2
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/pattern_3
	icon_state = "pattern_3"
	base_icon_state = "pattern_3"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_3

/obj/item/stack/tile/iron/pattern_3
	name = "砖块交叉网格地砖"
	singular_name = "brick crosshatch tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_3"
	turf_type = /turf/open/floor/iron/pattern_3
	merge_type = /obj/item/stack/tile/iron/pattern_3
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/pattern_4
	icon_state = "pattern_4"
	base_icon_state = "pattern_4"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_4

/obj/item/stack/tile/iron/pattern_4
	name = "砖块螺旋地砖"
	singular_name = "brick spiral tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_4"
	turf_type = /turf/open/floor/iron/pattern_4
	merge_type = /obj/item/stack/tile/iron/pattern_4
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/pattern_5
	icon_state = "pattern_5"
	base_icon_state = "pattern_5"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_5

/obj/item/stack/tile/iron/pattern_5
	name = "六边形图案地砖"
	singular_name = "hex tile pattern tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_5"
	turf_type = /turf/open/floor/iron/pattern_5
	merge_type = /obj/item/stack/tile/iron/pattern_5

/turf/open/floor/iron/pattern_6
	icon_state = "pattern_6"
	base_icon_state = "pattern_6"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_6

/obj/item/stack/tile/iron/pattern_6
	name = "六边形图案网格地砖"
	singular_name = "hex tile pattern grid tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_6"
	turf_type = /turf/open/floor/iron/pattern_6
	merge_type = /obj/item/stack/tile/iron/pattern_6

/turf/open/floor/iron/pattern_7
	icon_state = "pattern_7"
	base_icon_state = "pattern_7"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_7

/obj/item/stack/tile/iron/pattern_7
	name = "对角砖块地砖"
	singular_name = "diagonal brick"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_7"
	turf_type = /turf/open/floor/iron/pattern_7
	merge_type = /obj/item/stack/tile/iron/pattern_7

/turf/open/floor/iron/pattern_8
	icon_state = "pattern_8"
	base_icon_state = "pattern_8"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_8

/obj/item/stack/tile/iron/pattern_8
	name = "大型六边形地砖"
	singular_name = "large hex floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_8"
	turf_type = /turf/open/floor/iron/pattern_8
	merge_type = /obj/item/stack/tile/iron/pattern_8

/turf/open/floor/iron/pattern_9
	icon_state = "pattern_9"
	base_icon_state = "pattern_9"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_9

/obj/item/stack/tile/iron/pattern_9
	name = "偏移图案地砖"
	singular_name = "offset floor pattern tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_9"
	turf_type = /turf/open/floor/iron/pattern_9
	merge_type = /obj/item/stack/tile/iron/pattern_9

/turf/open/floor/iron/pattern_10
	icon_state = "pattern_10"
	base_icon_state = "pattern_10"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_10

/obj/item/stack/tile/iron/pattern_10
	name = "箭头图案砖块地砖"
	singular_name = "arrow pattern brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_10"
	turf_type = /turf/open/floor/iron/pattern_10
	merge_type = /obj/item/stack/tile/iron/pattern_10
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/pattern_11
	icon_state = "pattern_11"
	base_icon_state = "pattern_11"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/pattern_11

/obj/item/stack/tile/iron/pattern_11
	name = "大型六边形地砖"
	singular_name = "large hex floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "pattern_11"
	turf_type = /turf/open/floor/iron/pattern_11
	merge_type = /obj/item/stack/tile/iron/pattern_11

/*
* DARK TILES
*/

/turf/open/floor/iron/dark/brick
	icon_state = "dark_brick"
	base_icon_state = "dark_brick"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick

/obj/item/stack/tile/iron/dark/brick
	name = "深色砖块地砖"
	singular_name = "dark brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick"
	turf_type = /turf/open/floor/iron/dark/brick
	merge_type = /obj/item/stack/tile/iron/dark/brick
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/dark/brick_half
	icon_state = "dark_brick_half"
	base_icon_state = "dark_brick_half"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_half

/obj/item/stack/tile/iron/dark/brick_half
	name = "深色半砖地砖"
	singular_name = "dark half brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_half"
	turf_type = /turf/open/floor/iron/dark/brick_half
	merge_type = /obj/item/stack/tile/iron/dark/brick_half
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_half_vertical
	icon_state = "dark_brick_half_vertical"
	base_icon_state = "dark_brick_half_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_half_vertical

/obj/item/stack/tile/iron/dark/brick_half_vertical
	name = "深色垂直半砖地砖"
	singular_name = "dark brick vertical floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_half_vertical"
	turf_type = /turf/open/floor/iron/dark/brick_half_vertical
	merge_type = /obj/item/stack/tile/iron/dark/brick_half_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_corner
	icon_state = "dark_brick_corner"
	base_icon_state = "dark_brick_corner"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_corner

/obj/item/stack/tile/iron/dark/brick_corner
	name = "深色砖块转角地砖"
	singular_name = "dark brick corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_corner"
	turf_type = /turf/open/floor/iron/dark/brick_corner
	merge_type = /obj/item/stack/tile/iron/dark/brick_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_corner_inverse
	icon_state = "dark_brick_corner_inverse"
	base_icon_state = "dark_brick_corner_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_corner_inverse

/obj/item/stack/tile/iron/dark/brick_corner_inverse
	name = "深色砖块反向转角地砖"
	singular_name = "dark brick inverse corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_corner_inverse"
	turf_type = /turf/open/floor/iron/dark/brick_corner_inverse
	merge_type = /obj/item/stack/tile/iron/dark/brick_corner_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_corner_vertical
	icon_state = "dark_brick_corner_vertical"
	base_icon_state = "dark_brick_corner_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_corner_vertical

/obj/item/stack/tile/iron/dark/brick_corner_vertical
	name = "深色砖块垂直转角地砖"
	singular_name = "dark brick vertical corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_corner_vertical"
	turf_type = /turf/open/floor/iron/dark/brick_corner_vertical
	merge_type = /obj/item/stack/tile/iron/dark/brick_corner_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_corner_vertical_inverse
	icon_state = "dark_brick_corner_vertical_inverse"
	base_icon_state = "dark_brick_corner_vertical_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_corner_vertical_inverse

/obj/item/stack/tile/iron/dark/brick_corner_vertical_inverse
	name = "深色砖块垂直反向转角地砖"
	singular_name = "dark brick vertical corner invserse floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_corner_vertical_inverse"
	turf_type = /turf/open/floor/iron/dark/brick_corner_vertical_inverse
	merge_type = /obj/item/stack/tile/iron/dark/brick_corner_vertical_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_aligned
	icon_state = "dark_brick_aligned"
	base_icon_state = "dark_brick_aligned"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_aligned

/obj/item/stack/tile/iron/dark/brick_aligned
	name = "深色对齐砖块地砖"
	singular_name = "dark aligned floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_aligned"
	turf_type = /turf/open/floor/iron/dark/brick_aligned
	merge_type = /obj/item/stack/tile/iron/dark/brick_aligned
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/dark/brick_aligned_half
	icon_state = "dark_brick_aligned_half"
	base_icon_state = "dark_brick_aligned_half"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_aligned_half

/obj/item/stack/tile/iron/dark/brick_aligned_half
	name = "深色对齐半砖地砖"
	singular_name = "dark aligned half brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_aligned_half"
	turf_type = /turf/open/floor/iron/dark/brick_aligned_half
	merge_type = /obj/item/stack/tile/iron/dark/brick_aligned_half
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_aligned_half_vertical
	icon_state = "dark_brick_aligned_half_vertical"
	base_icon_state = "dark_brick_aligned_half_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_aligned_half_vertical

/obj/item/stack/tile/iron/dark/brick_aligned_half_vertical
	name = "深色对齐垂直半砖地砖"
	singular_name = "dark aligned half brick vertical floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_aligned_half_vertical"
	turf_type = /turf/open/floor/iron/dark/brick_aligned_half_vertical
	merge_type = /obj/item/stack/tile/iron/dark/brick_aligned_half_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_aligned_corner_vertical
	icon_state = "dark_brick_aligned_corner_vertical"
	base_icon_state = "dark_brick_aligned_corner_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_aligned_corner_vertical

/obj/item/stack/tile/iron/dark/brick_aligned_corner_vertical
	name = "深色对齐垂直转角地砖"
	singular_name = "dark aligned vertical corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_aligned_corner_vertical"
	turf_type = /turf/open/floor/iron/dark/brick_aligned_corner_vertical
	merge_type = /obj/item/stack/tile/iron/dark/brick_aligned_corner_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_aligned_corner_vertical_inverse
	icon_state = "dark_brick_aligned_corner_vertical_inverse"
	base_icon_state = "dark_brick_aligned_corner_vertical_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_aligned_corner_vertical_inverse

/obj/item/stack/tile/iron/dark/brick_aligned_corner_vertical_inverse
	name = "深色对齐垂直反向转角地砖"
	singular_name = "dark aligned vertical inverse corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_aligned_corner_vertical_inverse"
	turf_type = /turf/open/floor/iron/dark/brick_aligned_corner_vertical_inverse
	merge_type = /obj/item/stack/tile/iron/dark/brick_aligned_corner_vertical_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_aligned_corner
	icon_state = "dark_brick_aligned_corner"
	base_icon_state = "dark_brick_aligned_corner"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_aligned_corner

/obj/item/stack/tile/iron/dark/brick_aligned_corner
	name = "深色对齐转角地砖"
	singular_name = "dark aligned corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_aligned_corner"
	turf_type = /turf/open/floor/iron/dark/brick_aligned_corner
	merge_type = /obj/item/stack/tile/iron/dark/brick_aligned_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/brick_aligned_corner_inverse
	icon_state = "dark_brick_aligned_corner_inverse"
	base_icon_state = "dark_brick_aligned_corner_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/brick_aligned_corner_inverse

/obj/item/stack/tile/iron/dark/brick_aligned_corner_inverse
	name = "深色对齐反向转角地砖"
	singular_name = "dark aligned inverse corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_brick_aligned_corner_inverse"
	turf_type = /turf/open/floor/iron/dark/brick_aligned_corner_inverse
	merge_type = /obj/item/stack/tile/iron/dark/brick_aligned_corner_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/pattern_1
	icon_state = "dark_pattern_1"
	base_icon_state = "dark_pattern_1"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_1

/obj/item/stack/tile/iron/dark/pattern_1
	name = "深色对角砖纹地砖"
	singular_name = "dark diagonal brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_1"
	turf_type = /turf/open/floor/iron/dark/pattern_1
	merge_type = /obj/item/stack/tile/iron/dark/pattern_1
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/dark/pattern_2
	icon_state = "dark_pattern_2"
	base_icon_state = "dark_pattern_2"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_2

/obj/item/stack/tile/iron/dark/pattern_2
	name = "深色菱形螺旋砖纹地砖"
	singular_name = "dark diamond spiral brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_2"
	turf_type = /turf/open/floor/iron/dark/pattern_2
	merge_type = /obj/item/stack/tile/iron/dark/pattern_2
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/dark/pattern_3
	icon_state = "dark_pattern_3"
	base_icon_state = "dark_pattern_3"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_3

/obj/item/stack/tile/iron/dark/pattern_3
	name = "深色砖纹交叉网格地砖"
	singular_name = "dark brick crosshatch tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_3"
	turf_type = /turf/open/floor/iron/dark/pattern_3
	merge_type = /obj/item/stack/tile/iron/dark/pattern_3
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/dark/pattern_4
	icon_state = "dark_pattern_4"
	base_icon_state = "dark_pattern_4"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_4

/obj/item/stack/tile/iron/dark/pattern_4
	name = "深色砖纹螺旋地砖"
	singular_name = "dark brick spiral tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_4"
	turf_type = /turf/open/floor/iron/dark/pattern_4
	merge_type = /obj/item/stack/tile/iron/dark/pattern_4
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/dark/pattern_5
	icon_state = "dark_pattern_5"
	base_icon_state = "dark_pattern_5"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_5

/obj/item/stack/tile/iron/dark/pattern_5
	name = "深色六边形地砖"
	singular_name = "dark hex tile pattern tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_5"
	turf_type = /turf/open/floor/iron/dark/pattern_5
	merge_type = /obj/item/stack/tile/iron/dark/pattern_5

/turf/open/floor/iron/dark/pattern_6
	icon_state = "dark_pattern_6"
	base_icon_state = "dark_pattern_6"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_6

/obj/item/stack/tile/iron/dark/pattern_6
	name = "深色六边形网格地砖"
	singular_name = "dark hex tile pattern grid tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_6"
	turf_type = /turf/open/floor/iron/dark/pattern_6
	merge_type = /obj/item/stack/tile/iron/dark/pattern_6

/turf/open/floor/iron/dark/pattern_7
	icon_state = "dark_pattern_7"
	base_icon_state = "dark_pattern_7"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_7

/obj/item/stack/tile/iron/dark/pattern_7
	name = "深色对角砖纹"
	singular_name = "dark diagonal brick"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_7"
	turf_type = /turf/open/floor/iron/dark/pattern_7
	merge_type = /obj/item/stack/tile/iron/dark/pattern_7

/turf/open/floor/iron/dark/pattern_8
	icon_state = "dark_pattern_8"
	base_icon_state = "dark_pattern_8"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_8

/obj/item/stack/tile/iron/dark/pattern_8
	name = "大型深色六边形地砖"
	singular_name = "large dark hex floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_8"
	turf_type = /turf/open/floor/iron/dark/pattern_8
	merge_type = /obj/item/stack/tile/iron/dark/pattern_8

/turf/open/floor/iron/dark/pattern_9
	icon_state = "dark_pattern_9"
	base_icon_state = "dark_pattern_9"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_9

/obj/item/stack/tile/iron/dark/pattern_9
	name = "深色错位地砖"
	singular_name = "dark offset floor pattern tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_9"
	turf_type = /turf/open/floor/iron/dark/pattern_9
	merge_type = /obj/item/stack/tile/iron/dark/pattern_9

/turf/open/floor/iron/dark/pattern_10
	icon_state = "dark_pattern_10"
	base_icon_state = "dark_pattern_10"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_10

/obj/item/stack/tile/iron/dark/pattern_10
	name = "深色箭头砖纹地砖"
	singular_name = "dark arrow pattern brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_10"
	turf_type = /turf/open/floor/iron/dark/pattern_10
	merge_type = /obj/item/stack/tile/iron/dark/pattern_10
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/dark/pattern_11
	icon_state = "dark_pattern_11"
	base_icon_state = "dark_pattern_11"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/dark/pattern_11

/obj/item/stack/tile/iron/dark/pattern_11
	name = "深色大型六边形地砖"
	singular_name = "dark large hex floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "dark_pattern_11"
	turf_type = /turf/open/floor/iron/dark/pattern_11
	merge_type = /obj/item/stack/tile/iron/dark/pattern_11

/*
* WHITE TILES
*/
/turf/open/floor/iron/white/brick
	icon_state = "white_brick"
	base_icon_state = "white_brick"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick

/obj/item/stack/tile/iron/white/brick
	name = "白色砖纹地砖"
	singular_name = "white brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick"
	turf_type = /turf/open/floor/iron/white/brick
	merge_type = /obj/item/stack/tile/iron/white/brick
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/white/brick_half
	icon_state = "white_brick_half"
	base_icon_state = "white_brick_half"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_half

/obj/item/stack/tile/iron/white/brick_half
	name = "白色半砖地砖"
	singular_name = "white half brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_half"
	turf_type = /turf/open/floor/iron/white/brick_half
	merge_type = /obj/item/stack/tile/iron/white/brick_half
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_half_vertical
	icon_state = "white_brick_half_vertical"
	base_icon_state = "white_brick_half_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_half_vertical

/obj/item/stack/tile/iron/white/brick_half_vertical
	name = "白色垂直半砖地砖"
	singular_name = "white half brick vertical floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_half_vertical"
	turf_type = /turf/open/floor/iron/white/brick_half_vertical
	merge_type = /obj/item/stack/tile/iron/white/brick_half_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_corner
	icon_state = "white_brick_corner"
	base_icon_state = "white_brick_corner"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_corner

/obj/item/stack/tile/iron/white/brick_corner
	name = "白色砖纹转角地砖"
	singular_name = "white brick corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_corner"
	turf_type = /turf/open/floor/iron/white/brick_corner
	merge_type = /obj/item/stack/tile/iron/white/brick_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_corner_inverse
	icon_state = "white_brick_corner_inverse"
	base_icon_state = "white_brick_corner_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_corner_inverse

/obj/item/stack/tile/iron/white/brick_corner_inverse
	name = "白色砖纹反向转角地砖"
	singular_name = "white brick inverse corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_corner_inverse"
	turf_type = /turf/open/floor/iron/white/brick_corner_inverse
	merge_type = /obj/item/stack/tile/iron/white/brick_corner_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_corner_vertical
	icon_state = "white_brick_corner_vertical"
	base_icon_state = "white_brick_corner_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_corner_vertical

/obj/item/stack/tile/iron/white/brick_corner_vertical
	name = "白色垂直砖纹转角地砖"
	singular_name = "white vertical brick corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_corner_vertical"
	turf_type = /turf/open/floor/iron/white/brick_corner_vertical
	merge_type = /obj/item/stack/tile/iron/white/brick_corner_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_corner_vertical_inverse
	icon_state = "white_brick_corner_vertical_inverse"
	base_icon_state = "white_brick_corner_vertical_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_corner_vertical_inverse

/obj/item/stack/tile/iron/white/brick_corner_vertical_inverse
	name = "白色砖块反向转角地板砖"
	singular_name = "white brick corner inverse floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_corner_vertical_inverse"
	turf_type = /turf/open/floor/iron/white/brick_corner_vertical_inverse
	merge_type = /obj/item/stack/tile/iron/white/brick_corner_vertical_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_aligned
	icon_state = "white_brick_aligned"
	base_icon_state = "white_brick_aligned"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_aligned

/obj/item/stack/tile/iron/white/brick_aligned
	name = "白色对齐砖块地板砖"
	singular_name = "white aligned brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_aligned"
	turf_type = /turf/open/floor/iron/white/brick_aligned
	merge_type = /obj/item/stack/tile/iron/white/brick_aligned
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/white/brick_aligned_half
	icon_state = "white_brick_aligned_half"
	base_icon_state = "white_brick_aligned_half"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_aligned_half

/obj/item/stack/tile/iron/white/brick_aligned_half
	name = "白色对齐半砖地板砖"
	singular_name = "white aligned half brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_aligned_half"
	turf_type = /turf/open/floor/iron/white/brick_aligned_half
	merge_type = /obj/item/stack/tile/iron/white/brick_aligned_half
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_aligned_half_vertical
	icon_state = "white_brick_aligned_half_vertical"
	base_icon_state = "white_brick_aligned_half_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_aligned_half_vertical

/obj/item/stack/tile/iron/white/brick_aligned_half_vertical
	name = "白色对齐垂直半砖地板砖"
	singular_name = "white aligned half vertical brick floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_aligned_half_vertical"
	turf_type = /turf/open/floor/iron/white/brick_aligned_half_vertical
	merge_type = /obj/item/stack/tile/iron/white/brick_aligned_half_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_aligned_corner_vertical
	icon_state = "white_brick_aligned_corner_vertical"
	base_icon_state = "white_brick_aligned_corner_vertical"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_aligned_corner_vertical

/obj/item/stack/tile/iron/white/brick_aligned_corner_vertical
	name = "白色对齐垂直砖块转角地板砖"
	singular_name = "white aligned vertical brick corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_aligned_corner_vertical"
	turf_type = /turf/open/floor/iron/white/brick_aligned_corner_vertical
	merge_type = /obj/item/stack/tile/iron/white/brick_aligned_corner_vertical
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_aligned_corner_vertical_inverse
	icon_state = "white_brick_aligned_corner_vertical_inverse"
	base_icon_state = "white_brick_aligned_corner_vertical_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_aligned_corner_vertical_inverse

/obj/item/stack/tile/iron/white/brick_aligned_corner_vertical_inverse
	name = "白色对齐垂直砖块反向转角地板砖"
	singular_name = "white aligned vertical brick inverse corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_aligned_corner_vertical_inverse"
	turf_type = /turf/open/floor/iron/white/brick_aligned_corner_vertical_inverse
	merge_type = /obj/item/stack/tile/iron/white/brick_aligned_corner_vertical_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_aligned_corner
	icon_state = "white_brick_aligned_corner"
	base_icon_state = "white_brick_aligned_corner"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_aligned_corner

/obj/item/stack/tile/iron/white/brick_aligned_corner
	name = "白色对齐砖块转角地板砖"
	singular_name = "white aligned brick corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_aligned_corner"
	turf_type = /turf/open/floor/iron/white/brick_aligned_corner
	merge_type = /obj/item/stack/tile/iron/white/brick_aligned_corner
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/brick_aligned_corner_inverse
	icon_state = "white_brick_aligned_corner_inverse"
	base_icon_state = "white_brick_aligned_corner_inverse"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/brick_aligned_corner_inverse

/obj/item/stack/tile/iron/white/brick_aligned_corner_inverse
	name = "白色对齐砖块反向转角地板砖"
	singular_name = "white aligned brick inverse corner floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_brick_aligned_corner_inverse"
	turf_type = /turf/open/floor/iron/white/brick_aligned_corner_inverse
	merge_type = /obj/item/stack/tile/iron/white/brick_aligned_corner_inverse
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/pattern_1
	icon_state = "white_pattern_1"
	base_icon_state = "white_pattern_1"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_1

/obj/item/stack/tile/iron/white/pattern_1
	name = "白色对角砖块地板砖"
	singular_name = "white diagonal brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_1"
	turf_type = /turf/open/floor/iron/white/pattern_1
	merge_type = /obj/item/stack/tile/iron/white/pattern_1
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/white/pattern_2
	icon_state = "white_pattern_2"
	base_icon_state = "white_pattern_2"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_2

/obj/item/stack/tile/iron/white/pattern_2
	name = "白色菱形螺旋砖块地板砖"
	singular_name = "white diamond spiral brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_2"
	turf_type = /turf/open/floor/iron/white/pattern_2
	merge_type = /obj/item/stack/tile/iron/white/pattern_2
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/white/pattern_3
	icon_state = "white_pattern_3"
	base_icon_state = "white_pattern_3"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_3

/obj/item/stack/tile/iron/white/pattern_3
	name = "白色砖块交叉网格地板砖"
	singular_name = "white brick crosshatch tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_3"
	turf_type = /turf/open/floor/iron/white/pattern_3
	merge_type = /obj/item/stack/tile/iron/white/pattern_3
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/white/pattern_4
	icon_state = "white_pattern_4"
	base_icon_state = "white_pattern_4"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_4

/obj/item/stack/tile/iron/white/pattern_4
	name = "白色砖块螺旋地板砖"
	singular_name = "white brick spiral tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_4"
	turf_type = /turf/open/floor/iron/white/pattern_4
	merge_type = /obj/item/stack/tile/iron/white/pattern_4
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/iron/white/pattern_5
	icon_state = "white_pattern_5"
	base_icon_state = "white_pattern_5"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_5

/obj/item/stack/tile/iron/white/pattern_5
	name = "白色六边形图案地板砖"
	singular_name = "white hex tile pattern tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_5"
	turf_type = /turf/open/floor/iron/white/pattern_5
	merge_type = /obj/item/stack/tile/iron/white/pattern_5

/turf/open/floor/iron/white/pattern_6
	icon_state = "white_pattern_6"
	base_icon_state = "white_pattern_6"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_6

/obj/item/stack/tile/iron/white/pattern_6
	name = "白色六边形图案网格地板砖"
	singular_name = "white hex tile pattern grid tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_6"
	turf_type = /turf/open/floor/iron/white/pattern_6
	merge_type = /obj/item/stack/tile/iron/white/pattern_6

/turf/open/floor/iron/white/pattern_7
	icon_state = "white_pattern_7"
	base_icon_state = "white_pattern_7"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_7

/obj/item/stack/tile/iron/white/pattern_7
	name = "白色对角砖块"
	singular_name = "white diagonal brick"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_7"
	turf_type = /turf/open/floor/iron/white/pattern_7
	merge_type = /obj/item/stack/tile/iron/white/pattern_7

/turf/open/floor/iron/white/pattern_8
	icon_state = "white_pattern_8"
	base_icon_state = "white_pattern_8"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_8

/obj/item/stack/tile/iron/white/pattern_8
	name = "大型白色六边形地板砖"
	singular_name = "large white hex floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_8"
	turf_type = /turf/open/floor/iron/white/pattern_8
	merge_type = /obj/item/stack/tile/iron/white/pattern_8

/turf/open/floor/iron/white/pattern_9
	icon_state = "white_pattern_9"
	base_icon_state = "white_pattern_9"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_9

/obj/item/stack/tile/iron/white/pattern_9
	name = "白色偏移地板图案砖"
	singular_name = "white offset floor pattern tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_9"
	turf_type = /turf/open/floor/iron/white/pattern_9
	merge_type = /obj/item/stack/tile/iron/white/pattern_9

/turf/open/floor/iron/white/pattern_10
	icon_state = "white_pattern_10"
	base_icon_state = "white_pattern_10"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_10

/obj/item/stack/tile/iron/white/pattern_10
	name = "白色箭头图案砖块地板砖"
	singular_name = "white arrow pattern brick tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_10"
	turf_type = /turf/open/floor/iron/white/pattern_10
	merge_type = /obj/item/stack/tile/iron/white/pattern_10
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/iron/white/pattern_11
	icon_state = "white_pattern_11"
	base_icon_state = "white_pattern_11"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/iron/white/pattern_11

/obj/item/stack/tile/iron/white/pattern_11
	name = "白色大型六边形地板砖"
	singular_name = "white large hex floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "white_pattern_11"
	turf_type = /turf/open/floor/iron/white/pattern_11
	merge_type = /obj/item/stack/tile/iron/white/pattern_11

/*
	Wood
*/

/turf/open/floor/wood/wood_1
	icon_state = "wood_1"
	base_icon_state = "wood_1"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_1

/obj/item/stack/tile/wood/wood_1
	name = "对角砖块"
	singular_name = "diagonal brick"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_1"
	turf_type = /turf/open/floor/wood/wood_1
	merge_type = /obj/item/stack/tile/wood/wood_1
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/wood/wood_2
	icon_state = "wood_2"
	base_icon_state = "wood_2"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_2

/obj/item/stack/tile/wood/wood_2
	name = "木桶地板砖"
	singular_name = "wood barrel floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_2"
	turf_type = /turf/open/floor/wood/wood_2
	merge_type = /obj/item/stack/tile/wood/wood_2
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/wood/wood_3
	icon_state = "wood_3"
	base_icon_state = "wood_3"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_3

/obj/item/stack/tile/wood/wood_3
	name = "交替木角地板砖"
	singular_name = "alternating wood floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_3"
	turf_type = /turf/open/floor/wood/wood_3
	merge_type = /obj/item/stack/tile/wood/wood_3

/turf/open/floor/wood/wood_4
	icon_state = "wood_4"
	base_icon_state = "wood_4"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_4

/obj/item/stack/tile/wood/wood_4
	name = "交替木板"
	singular_name = "alternating wood boards"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_4"
	turf_type = /turf/open/floor/wood/wood_4
	merge_type = /obj/item/stack/tile/wood/wood_4
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/wood/wood_5
	icon_state = "wood_5"
	base_icon_state = "wood_5"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_5

/obj/item/stack/tile/wood/wood_5
	name = "对角木板"
	singular_name = "diagonal wooden boards"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_5"
	turf_type = /turf/open/floor/wood/wood_5
	merge_type = /obj/item/stack/tile/wood/wood_5
	tile_rotate_dirs = list(SOUTH, NORTH)

/turf/open/floor/wood/wood_6
	icon_state = "wood_6"
	base_icon_state = "wood_6"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_6

/obj/item/stack/tile/wood/wood_6
	name = "木板"
	singular_name = "wooden board"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_6"
	turf_type = /turf/open/floor/wood/wood_6
	merge_type = /obj/item/stack/tile/wood/wood_6

/turf/open/floor/wood/wood_7
	icon_state = "wood_7"
	base_icon_state = "wood_7"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_7

/obj/item/stack/tile/wood/wood_7
	name = "木格纹地板砖"
	singular_name = "wood crosshatch floor tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_7"
	turf_type = /turf/open/floor/wood/wood_7
	merge_type = /obj/item/stack/tile/wood/wood_7

/turf/open/floor/wood/wood_8
	icon_state = "wood_8"
	base_icon_state = "wood_8"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_8

/obj/item/stack/tile/wood/wood_8
	name = "方形木砖"
	singular_name = "square wood tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_8"
	turf_type = /turf/open/floor/wood/wood_8
	merge_type = /obj/item/stack/tile/wood/wood_8

/turf/open/floor/wood/wood_9
	icon_state = "wood_9"
	base_icon_state = "wood_9"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_9


/obj/item/stack/tile/wood/wood_9
	name = "木箭头图案砖"
	singular_name = "wood arrow pattern tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_9"
	turf_type = /turf/open/floor/wood/wood_9
	merge_type = /obj/item/stack/tile/wood/wood_9
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/turf/open/floor/wood/wood_10
	icon_state = "wood_10"
	base_icon_state = "wood_10"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_10

/obj/item/stack/tile/wood/wood_10
	name = "改良木拼花砖"
	singular_name = "modified wood parquet tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_10"
	turf_type = /turf/open/floor/wood/wood_10
	merge_type = /obj/item/stack/tile/wood/wood_10

/turf/open/floor/wood/wood_11
	icon_state = "wood_11"
	base_icon_state = "wood_11"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_11

/obj/item/stack/tile/wood/wood_11
	name = "木螺旋砖"
	singular_name = "wood spiral tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_11"
	turf_type = /turf/open/floor/wood/wood_11
	merge_type = /obj/item/stack/tile/wood/wood_11

/turf/open/floor/wood/wood_12
	icon_state = "wood_12"
	base_icon_state = "wood_12"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_12

/obj/item/stack/tile/wood/wood_12
	name = "中心木纹砖"
	singular_name = "centered wood tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_12"
	turf_type = /turf/open/floor/wood/wood_12
	merge_type = /obj/item/stack/tile/wood/wood_12

/turf/open/floor/wood/wood_13
	icon_state = "wood_13"
	base_icon_state = "wood_13"
	icon = 'modular_nova/master_files/icons/turf/floors/floor.dmi'
	floor_tile = /obj/item/stack/tile/wood/wood_13

/obj/item/stack/tile/wood/wood_13
	name = "六边形木砖"
	singular_name = "hexagon wood tile"
	icon = 'modular_nova/master_files/icons/obj/tiles.dmi'
	icon_state = "wood_13"
	turf_type = /turf/open/floor/wood/wood_13
	merge_type = /obj/item/stack/tile/wood/wood_13

