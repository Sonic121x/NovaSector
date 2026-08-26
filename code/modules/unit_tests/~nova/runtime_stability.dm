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

/datum/unit_test/dynamic_lighting_stale_source
	var/datum/spatial_grid_cell/test_cell
	var/list/original_light_sources

/datum/unit_test/dynamic_lighting_stale_source/Run()
	test_cell = SSspatial_grid.get_cell_of(run_loc_floor_bottom_left)
	TEST_ASSERT_NOTNULL(test_cell, "The unit test turf should belong to a spatial grid cell.")

	original_light_sources = test_cell.dynamic_light_sources
	test_cell.dynamic_light_sources = original_light_sources.Copy()
	test_cell.dynamic_light_sources[null] = 0.5
	run_loc_floor_bottom_left.collect_dynamic_lightsources()

	TEST_ASSERT(!list_clear_nulls(test_cell.dynamic_light_sources), "collect_dynamic_lightsources() should remove stale null light keys.")

/datum/unit_test/dynamic_lighting_stale_source/Destroy()
	if(test_cell && original_light_sources)
		test_cell.dynamic_light_sources = original_light_sources
	return ..()
