/// Navigate keeps the destination across floor changes (modular_zh/master_files/code/modules/mob/living/navigation.dm).
/// The checks on one floor run on any map; the trip across floors needs three stacked station levels
/// (_maps/map_jsons/multiz_debug.json) and is skipped elsewhere.
/datum/unit_test/multiz_navigation

/datum/unit_test/multiz_navigation/Run()
	var/mob/living/carbon/human/consistent/walker = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/pen/same_floor = allocate(/obj/item/pen)

	TEST_ASSERT_EQUAL(walker.navigation_vertical_dir(same_floor), NONE, "a destination on our floor has no vertical direction")
	walker.navigate_final_target = WEAKREF(same_floor)
	TEST_ASSERT_EQUAL(walker.navigation_next_leg(), same_floor, "a remembered destination on our floor is the next leg")

	var/obj/item/pen/elsewhere = allocate(/obj/item/pen)
	var/centcom_z = SSmapping.levels_by_trait(ZTRAIT_CENTCOM)[1]
	elsewhere.forceMove(locate(world.maxx / 2, world.maxy / 2, centcom_z))
	TEST_ASSERT_EQUAL(walker.navigation_vertical_dir(elsewhere), NONE, "a level not stacked on ours is neither up nor down")
	walker.navigate_final_target = WEAKREF(elsewhere)
	TEST_ASSERT_NULL(walker.navigation_next_leg(), "a destination on an unconnected level is dropped")

	walker.navigate_final_target = WEAKREF(same_floor)
	qdel(same_floor)
	TEST_ASSERT_NULL(walker.navigation_next_leg(), "a deleted destination is dropped")

	var/list/floors = stacked_station_floors()
	if(length(floors) < 3)
		return
	var/turf/bottom = floors[1]
	var/turf/middle = floors[2]
	var/turf/top = floors[3]
	walker.forceMove(bottom)
	var/obj/item/pen/upstairs = allocate(/obj/item/pen, top)

	TEST_ASSERT_EQUAL(walker.navigation_vertical_dir(upstairs), UP, "a destination two floors up is up")
	walker.forceMove(top)
	TEST_ASSERT_EQUAL(walker.navigation_vertical_dir(locate(bottom.x, bottom.y, bottom.z)), DOWN, "a destination two floors down is down")

	// Bottom floor to the middle one: still on the wrong floor, so the destination is kept and the next
	// line leads to the stairs or ladder up.
	walker.forceMove(bottom)
	walker.navigate_final_target = WEAKREF(upstairs)
	walker.RegisterSignal(walker, COMSIG_MOVABLE_Z_CHANGED, TYPE_PROC_REF(/mob/living, continue_navigation))
	walker.forceMove(middle)
	TEST_ASSERT_NOTNULL(walker.find_nearest_stair_or_ladder(UP), "the debug map has a way up from the middle floor")
	sleep(1 SECONDS) // the next leg is drawn from a timer
	TEST_ASSERT_EQUAL(walker.navigate_final_target?.resolve(), upstairs, "the destination is kept after reaching an intermediate floor")
	TEST_ASSERT(!COOLDOWN_FINISHED(walker, navigate_cooldown), "the next leg was drawn on the intermediate floor")

	// Middle floor to the destination's floor: the line now goes to the destination itself.
	walker.RegisterSignal(walker, COMSIG_MOVABLE_Z_CHANGED, TYPE_PROC_REF(/mob/living, continue_navigation))
	walker.forceMove(top)
	sleep(1 SECONDS) // the next leg is drawn from a timer
	TEST_ASSERT_NULL(walker.navigate_final_target, "on the destination's floor the line leads to the destination, not to stairs")

/// One floor turf on each of three stacked station levels, bottom first; empty if the map has no such stack.
/datum/unit_test/multiz_navigation/proc/stacked_station_floors()
	var/list/floors = list()
	for(var/station_z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		var/turf/probe = locate(world.maxx / 2, world.maxy / 2, station_z)
		if(GET_TURF_BELOW(probe))
			continue
		for(var/level in 1 to 3)
			if(!probe)
				return list()
			var/turf/open/floor/level_floor = locate(/turf/open/floor) in Z_TURFS(probe.z)
			if(!level_floor)
				return list()
			floors += level_floor
			probe = GET_TURF_ABOVE(probe)
		return floors
	return list()
