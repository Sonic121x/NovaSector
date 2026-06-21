/*
*	NCV TITAN
*/

/turf/closed/indestructible/titanium
	name = "墙壁"
	desc = "一种用于穿梭机的轻质钛合金墙壁。"
	icon = 'icons/turf/walls/shuttle_wall.dmi'
	icon_state = "shuttle_wall-0"
	base_icon_state = "shuttle_wall"
	flags_1 = CAN_BE_DIRTY_1
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_TITANIUM_WALLS

/turf/closed/indestructible/titanium/nodiagonal
	icon = MAP_SWITCH('icons/turf/walls/shuttle_wall.dmi', 'icons/turf/walls/misc_wall.dmi')
	icon_state = MAP_SWITCH("shuttle_wall-0", "shuttle_nd")
	base_icon_state = "shuttle_wall"
	smoothing_flags = SMOOTH_BITMASK
