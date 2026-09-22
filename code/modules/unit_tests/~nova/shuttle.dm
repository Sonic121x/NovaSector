/// Makes sure shuttle call times are correctly modified by security levels
/datum/unit_test/shuttle_call_times

/datum/unit_test/shuttle_call_times/Run()
	// Expected time: 15 minutes = 9000 deciseconds. Fucking thing doesnt like macros.
	var/expected_time = 9000

	for(var/datum/security_level/sec_level_path as anything in subtypesof(/datum/security_level))
		var/datum/security_level/sec_level = allocate(sec_level_path)

		// Request the shuttle with the coefficient from this sec level
		SSshuttle.emergency.request(null, set_coefficient = sec_level.shuttle_call_time_mod)

		// Grab the time left
		var/time_left = SSshuttle.emergency.timeLeft(1)

		// Check against expected
		TEST_ASSERT_EQUAL(time_left, expected_time, "[sec_level_path] shuttle call time didn't match expected [expected_time], got [time_left]")

		// Cancel for the next run
		SSshuttle.emergency.cancel()

		qdel(sec_level)

/// A destroyed transit dock must not leave its /area/shuttle/transit ("Hyperspace") behind in GLOB.areas.
/// Every shuttle trip creates one of these areas, so a leak piles hundreds of them into the teleport list over a round.
/datum/unit_test/transit_area_cleanup

/datum/unit_test/transit_area_cleanup/proc/count_transit_areas()
	. = 0
	for(var/area/shuttle/transit/transit_area in GLOB.areas)
		.++

/datum/unit_test/transit_area_cleanup/Run()
	var/obj/docking_port/mobile/victim
	for(var/obj/docking_port/mobile/candidate as anything in SSshuttle.mobile_docking_ports)
		if(!candidate.assigned_transit)
			victim = candidate
			break
	TEST_ASSERT_NOTNULL(victim, "No mobile docking port without an assigned transit to test with")

	var/areas_before = count_transit_areas()
	var/obj/docking_port/stationary/transit/dock = SSshuttle.generate_transit_dock(victim)
	TEST_ASSERT(dock, "generate_transit_dock() failed for [victim.shuttle_id]")
	var/area/shuttle/transit/transit_area = dock.assigned_area
	TEST_ASSERT_NOTNULL(transit_area, "Generated transit dock has no assigned area")
	TEST_ASSERT_EQUAL(count_transit_areas(), areas_before + 1, "Generating a transit dock should add exactly one transit area")

	qdel(dock, force = TRUE)

	// The reservation's turfs are handed back to SSmapping asynchronously, and the area can only go once they have.
	var/deadline = world.time + 1 MINUTES
	UNTIL(QDELETED(transit_area) || world.time > deadline)
	TEST_ASSERT(QDELETED(transit_area), "Transit area still exists a minute after its dock was destroyed (holding [length(transit_area?.contents)] turfs)")
	TEST_ASSERT_EQUAL(count_transit_areas(), areas_before, "Transit area count did not return to its starting value")
