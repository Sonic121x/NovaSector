/// Exercises the listener/source overlap without needing a real client.
/datum/threed_sound/runtime_stability_test
	abstract_type = /datum/threed_sound/runtime_stability_test

/datum/threed_sound/runtime_stability_test/register_listener(mob/new_listener)
	if(new_listener in listeners)
		return
	listeners[new_listener] = NONE
	RegisterSignal(new_listener, COMSIG_QDELETING, PROC_REF(listener_deleted))
	RegisterSignal(new_listener, COMSIG_MOVABLE_MOVED, PROC_REF(listener_moved))

/datum/unit_test/threed_sound_parent_listener_overlap/Run()
	var/mob/source_and_listener = allocate(/mob)
	var/datum/threed_sound/runtime_stability_test/sound_manager = allocate(
		/datum/threed_sound/runtime_stability_test,
		source_and_listener,
		sound(null),
		list(source_and_listener),
	)

	TEST_ASSERT_EQUAL(
		sound_manager._signal_procs[source_and_listener][COMSIG_MOVABLE_MOVED],
		TYPE_PROC_REF(/datum/threed_sound, on_moved),
		"A parent which is also a listener should retain the source movement callback.",
	)
	TEST_ASSERT_EQUAL(
		sound_manager._signal_procs[source_and_listener][COMSIG_QDELETING],
		TYPE_PROC_REF(/datum/threed_sound, parent_delete),
		"A parent which is also a listener should retain the source deletion callback.",
	)

/obj/effect/runtime_stability_light_test
	abstract_type = /obj/effect/runtime_stability_light_test
	light_system = OVERLAY_LIGHT
	light_range = 6
	light_power = 1
	light_on = TRUE

/datum/unit_test/dynamic_lighting_range_reduction/Run()
	var/turf/source_turf = locate(23, 23, run_loc_floor_bottom_left.z)
	TEST_ASSERT_NOTNULL(source_turf, "The unit test z-level should contain the selected spatial-grid boundary turf.")
	var/obj/effect/runtime_stability_light_test/test_light = allocate(/obj/effect/runtime_stability_light_test, source_turf)
	var/datum/component/overlay_lighting/light_component = test_light.GetComponent(/datum/component/overlay_lighting)
	TEST_ASSERT_NOTNULL(light_component, "The test light should initialize an overlay-lighting component.")

	var/list/old_cells = SSspatial_grid.get_cells_in_range(source_turf, 6)
	var/list/new_cells = SSspatial_grid.get_cells_in_range(source_turf, 1)
	var/found_outer_cell = FALSE
	for(var/datum/spatial_grid_cell/grid_cell as anything in old_cells)
		if(grid_cell in new_cells)
			continue
		found_outer_cell = TRUE
		TEST_ASSERT(light_component in grid_cell.dynamic_light_sources, "The initial range-six light should be registered in every outer grid cell.")

	TEST_ASSERT(found_outer_cell, "The chosen turf should span more spatial-grid cells at range six than at range one.")
	test_light.set_light_range(1)

	for(var/datum/spatial_grid_cell/grid_cell as anything in old_cells)
		if(grid_cell in new_cells)
			continue
		TEST_ASSERT(!(light_component in grid_cell.dynamic_light_sources), "Reducing a light's range must remove it from cells covered only by the old range.")
