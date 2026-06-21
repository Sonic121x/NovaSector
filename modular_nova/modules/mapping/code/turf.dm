// Modular turf stuff

// Reskinned soil to make it look like it's turf, but it's not!
/obj/machinery/hydroponics/soil/fake_turf
	desc = "一块可以种植东西的肥沃土壤。"
	icon = 'icons/turf/floors.dmi' // This makes it look like the dirt floor
	icon_state = "dirt"
	layer = LOW_FLOOR_LAYER
	plane = FLOOR_PLANE
	self_sustaining = 1
	pixel_z = 0

/turf/open/floor/circuit/green/xenobio
	desc = "这片地板周围的空气似乎……有些不同？"
	initial_gas_mix = XENOBIO_BZ

/turf/open/floor/grass/fairy/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/misc/asteroid/snow/icemoon

/turf/open/floor/mineral/gold/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/misc/asteroid/snow/icemoon

/turf/closed/indestructible/normal_wall
	name = "墙壁"
	icon = 'modular_nova/modules/aesthetics/walls/icons/wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/fakedoor/blast_door
	name = /obj/machinery/door/poddoor::name
	desc = /obj/machinery/door/poddoor::desc
	icon = /obj/machinery/door/poddoor::icon
	icon_state = /obj/machinery/door/poddoor::icon_state

/turf/open/skyline
	name = "漫长的坠落"
	icon = 'modular_nova/master_files/icons/obj/skyscraper/background.dmi'
	base_icon_state = "0,34"

// Don't let things enter if they can't fly
/turf/open/skyline/Enter(atom/movable/movable, atom/oldloc)
	. = ..()
	if(.)
		if(HAS_TRAIT(src, TRAIT_CHASM_STOPPED)) // lets people walk on catwalks and such
			return
		return HAS_TRAIT(movable, TRAIT_MOVE_FLYING) || HAS_TRAIT(movable, TRAIT_MOVE_FLOATING)

