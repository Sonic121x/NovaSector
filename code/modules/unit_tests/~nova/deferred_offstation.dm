/// Off-station content loaded after init (modules/deferred_offstation) must end up the same as if
/// init had loaded it. Unit tests start only after the round has started, and the round start waits
/// for the deferred load, so everything below has to be finished by the time this runs.
/datum/unit_test/deferred_offstation

/datum/unit_test/deferred_offstation/Run()
	TEST_ASSERT(SSmapping.offstation_ready(), "the round started before deferred off-station content finished loading")
	TEST_ASSERT_EQUAL(SSatoms.initialized, INITIALIZATION_INNEW_REGULAR, "SSatoms was left in a map loading state")
	if(!SSmapping.offstation_deferred)
		return

	var/list/checked_levels = SSmapping.levels_by_trait(ZTRAIT_MINING) | SSmapping.levels_by_trait(ZTRAIT_SPACE_RUINS)
	for(var/z_level in checked_levels)
		for(var/turf/level_turf as anything in Z_TURFS(z_level))
			TEST_ASSERT(level_turf.flags_1 & INITIALIZED_1, "uninitialized turf [level_turf] ([level_turf.type]) at [AREACOORD(level_turf)]")
			for(var/atom/movable/inside as anything in level_turf.get_all_contents() - level_turf)
				TEST_ASSERT(inside.flags_1 & INITIALIZED_1, "uninitialized [inside.type] at [AREACOORD(level_turf)]")

	// Docks that come with a shuttle get it after the whole batch initialized, like during init. Those
	// load in the background and may still be loading when the round starts.
	var/shuttle_deadline = world.time + 2 MINUTES
	while(SSmapping.offstation_shuttles_loading && world.time < shuttle_deadline)
		sleep(1 SECONDS)
	TEST_ASSERT(!SSmapping.offstation_shuttles_loading, "deferred roundstart shuttles still loading after 2 minutes")
	for(var/obj/docking_port/stationary/port as anything in SSshuttle.stationary_docking_ports)
		if(!(port.z in checked_levels) || !port.roundstart_template)
			continue
		TEST_ASSERT(port.get_docked(), "[port] at [AREACOORD(port)] never loaded its roundstart shuttle")

	if(SSmapping.current_map.minetype != MINETYPE_LAVALAND)
		return
	var/list/lavaland_levels = SSmapping.levels_by_trait(ZTRAIT_MINING)
	TEST_ASSERT(length(lavaland_levels), "lavaland was deferred but never loaded")

	for(var/z_level in lavaland_levels)
		// A level leaves eligible_zlevels while a weather runs on it, so either counts as registered.
		var/has_weather = length(SSweather.eligible_zlevels["[z_level]"])
		for(var/datum/weather/running as anything in SSweather.processing)
			if(z_level in running.impacted_z_levels)
				has_weather = TRUE
		TEST_ASSERT(has_weather, "no weather was registered for lavaland z [z_level]")

	var/found_dock = FALSE
	for(var/obj/docking_port/stationary/port as anything in SSshuttle.stationary_docking_ports)
		if(port.z in lavaland_levels)
			found_dock = TRUE
			break
	TEST_ASSERT(found_dock, "no shuttle docking port registered on lavaland")

	for(var/obj/structure/ore_vent/vent as anything in SSore_generation.possible_vents)
		if(!(vent.z in lavaland_levels) || vent.unique_vent)
			continue
		TEST_ASSERT(length(vent.mineral_breakdown), "lavaland ore vent at [AREACOORD(vent)] was never given minerals")
