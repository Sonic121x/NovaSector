// Navigate to a destination on another floor keeps going after each floor change.
//
// Upstream only draws the line to the nearest stairs or ladder and erases it when the floor changes,
// so every floor needs another trip through the destination list. Here the destination is remembered
// and the next leg is drawn on arrival: the next stairs or ladder while still on the wrong floor, the
// destination itself once on its floor. Destinations more than one floor away work too (upstream
// only looks one floor up and down).

/mob/living
	/// The destination picked in the navigate list while the drawn line only leads to stairs or a ladder.
	var/datum/weakref/navigate_final_target

/mob/living/create_navigation_line(atom/navigate_target)
	navigate_final_target = null
	if(isatom(navigate_target) && navigate_target.z != z)
		var/vertical = navigation_vertical_dir(navigate_target)
		if(vertical)
			navigate_final_target = WEAKREF(navigate_target)
			navigate_target = vertical
	return ..(navigate_target)

/mob/living/finish_navigation(turf/navigate_target, finding_zchange, list/path)
	. = ..()
	if(finding_zchange && navigate_final_target && length(client?.navigation_images))
		RegisterSignal(src, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(continue_navigation), override = TRUE)

// Upstream reads client.navigation_images unguarded; the next leg can start after the player disconnected.
/mob/living/cut_navigation()
	if(!client)
		UnregisterSignal(src, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_Z_CHANGED))
		return
	return ..()

/// Draws the next leg once a floor change happened on the way to a destination on another floor.
/mob/living/proc/continue_navigation(datum/source, turf/old_turf, turf/new_turf, same_z_layer)
	SIGNAL_HANDLER
	UnregisterSignal(src, COMSIG_MOVABLE_Z_CHANGED)
	cut_navigation()
	var/atom/next_leg = navigation_next_leg()
	if(!next_leg)
		navigate_final_target = null
		return
	// Same delay as the verb: the move that changed the floor is still in progress.
	addtimer(CALLBACK(src, PROC_REF(create_navigation_line), next_leg), world.tick_lag)

/// The remembered destination if it can still be navigated to from the current floor, otherwise null.
/mob/living/proc/navigation_next_leg()
	var/atom/final_target = navigate_final_target?.resolve()
	if(QDELETED(final_target) || incapacitated)
		return null
	if(final_target.z == z || navigation_vertical_dir(final_target))
		return final_target
	return null

/// UP or DOWN if the target is that way through the levels stacked on ours (any number of floors), otherwise NONE.
/mob/living/proc/navigation_vertical_dir(atom/target)
	var/turf/here = get_turf(src)
	var/turf/there = get_turf(target)
	if(!here || !there || here.z == there.z)
		return NONE
	for(var/direction in list(UP, DOWN))
		var/turf/level_turf = here
		for(var/_ in 1 to world.maxz)
			level_turf = get_step_multiz(level_turf, direction)
			if(!level_turf)
				break
			if(level_turf.z == there.z)
				return direction
	return NONE
