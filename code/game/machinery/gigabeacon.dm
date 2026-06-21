/obj/machinery/bluespace_beacon

	icon = 'icons/obj/machines/floor.dmi'
	icon_state = "floor_beaconf"
	name = "千兆蓝空信标"
	desc = "一种从蓝空汲取能量并创建永久跟踪信标的设备"
	layer = LOW_OBJ_LAYER
	use_power = NO_POWER_USE
	idle_power_usage = 0
	var/obj/item/beacon/Beacon

/obj/machinery/bluespace_beacon/Initialize(mapload)
	. = ..()
	var/turf/T = loc
	Beacon = new(T)
	Beacon.SetInvisibility(INVISIBILITY_MAXIMUM)

	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

/obj/machinery/bluespace_beacon/Destroy()
	QDEL_NULL(Beacon)
	return ..()

/obj/machinery/bluespace_beacon/process()
	if(QDELETED(Beacon)) //Don't move it out of nullspace BACK INTO THE GAME for the love of god
		var/turf/T = loc
		Beacon = new(T)
		Beacon.SetInvisibility(INVISIBILITY_MAXIMUM)
	else if (Beacon.loc != loc)
		Beacon.forceMove(loc)
