// NOVA EDIT ADDITION START - HYPERSPACE_AREA_LEAK
// generate_transit_dock() creates a fresh /area/shuttle/transit ("Hyperspace") for every trip, but
// /obj/docking_port/stationary/transit/Destroy() only frees reserved_area (the turf reservation) and never
// deletes assigned_area, so each trip leaves one more area in GLOB.areas and the teleport list fills with them.
// The area cannot be qdel'd inside Destroy(): SSmapping hands the turfs back asynchronously (reserve_turfs() only
// queues them), so at that point the area still owns turfs and deleting it would leave their loc pointing at a
// deleted area. Instead we wait until it is empty, with a retry cap that falls back to the old behaviour
// (leaving it in place) rather than ever orphaning turfs.
/// Delay between cleanup checks
#define TRANSIT_AREA_CLEANUP_INTERVAL (5 SECONDS)
/// Checks made before giving up
#define TRANSIT_AREA_CLEANUP_MAX_TRIES 12

/area/shuttle/transit
	/// Cleanup checks left before we give up and keep the area
	var/cleanup_tries_left = TRANSIT_AREA_CLEANUP_MAX_TRIES

/// Called by the owning transit dock when it is destroyed; deletes the area once its turfs have been handed back
/area/shuttle/transit/proc/queue_cleanup()
	if(QDELETED(src))
		return
	if(!length(contents))
		qdel(src)
		return
	cleanup_tries_left--
	if(cleanup_tries_left <= 0)
		stack_trace("transit area still holds [length(contents)] turf(s) after cleanup retries; leaving it in place")
		return
	addtimer(CALLBACK(src, PROC_REF(queue_cleanup)), TRANSIT_AREA_CLEANUP_INTERVAL)

/obj/docking_port/stationary/transit/Destroy(force = FALSE)
	// Only on force, matching upstream which does no cleanup at all on a non-forced Destroy()
	var/area/shuttle/transit/stale_area
	if(force)
		stale_area = assigned_area
		assigned_area = null
	. = ..()
	stale_area?.queue_cleanup()
// NOVA EDIT ADDITION END

/obj/docking_port/mobile
	/// Does this shuttle play sounds upon landing and takeoff?
	var/shuttle_sounds = TRUE
	/// The take off sound to be played
	var/takeoff_sound = sound('modular_nova/modules/advanced_shuttles/sound/engine_startup.ogg')
	/// The landing sound to be played
	var/landing_sound = sound('modular_nova/modules/advanced_shuttles/sound/engine_landing.ogg')
	/// The sound range coeff for the landing and take off sound effect
	var/sound_range = 11

/obj/docking_port/mobile/proc/bolt_all_doors() // Expensive procs :(
	var/list/turfs = return_ordered_turfs(x, y, z, dir)
	// List off non-external airlocks with id_tag and id_tags of external airlock
	// If its string - its used by non-external airlock to check if it has same id_tag and it needs to be bolted
	// If its entity - its entity of non-external airlock, that MAY be bolted later if external one with same id_tag found
	var/list/airlock_cache = list()
	for(var/i in 1 to turfs.len)
		var/turf/checked_turf = turfs[i]

		// Do not touch station airlocks
		if (!shuttle_areas[get_area(checked_turf)])
			continue

		for(var/obj/machinery/door/airlock/airlock_door in checked_turf)
			if(airlock_door.external)
				airlock_door.close(force_crush = TRUE)
				airlock_door.bolt()
				// If airlock is controlled - bolt all airlocks with same id, to avoid different bolt state on airlocks binded to same button
				if(airlock_door.id_tag)
					// Let non-external airlocks after us know, that they should bolt themself
					airlock_cache[airlock_door.id_tag] = TRUE
					// For every non-external airlock that we already iterated through
					for(var/obj/machinery/door/airlock/synced_door in airlock_cache)
						if (synced_door.id_tag == airlock_door.id_tag)
							synced_door.close(force_crush = TRUE)
							synced_door.bolt()
							airlock_cache -= synced_door

			// If we are non-external, but we having id - there is possibility of external airlock with same id, if so - we want be bolted too
			// That is needed to avoid different bolt state on airlocks binded to same button
			else if(airlock_door.id_tag)
				// It already was external airlock with same id
				if(airlock_cache[airlock_door.id_tag])
					airlock_door.close(force_crush = TRUE)
					airlock_door.bolt()
					continue
				// There was none, so let it handle our bolting, if there will be any external at all
				airlock_cache += airlock_door

/obj/docking_port/mobile/proc/unbolt_all_doors()
	var/list/turfs = return_ordered_turfs(x, y, z, dir)
	for(var/i in 1 to turfs.len)
		var/turf/checked_turf = turfs[i]

		// Do not touch station airlocks
		if (!shuttle_areas[get_area(checked_turf)])
			continue

		for(var/obj/machinery/door/airlock/airlock_door in checked_turf)
			if(airlock_door.external)
				airlock_door.unbolt()

/obj/docking_port/mobile/proc/play_engine_sound(atom/distant_source, takeoff)
	if(distant_source)
		for(var/mob/hearing_mob in range(sound_range, distant_source))
			if(!hearing_mob?.client)
				continue
			var/volume_pref_modifier = hearing_mob.client.prefs.read_preference(/datum/preference/numeric/volume/sound_ship_ambience_volume) / 100
			if(volume_pref_modifier == 0)
				continue
			var/dist = get_dist(hearing_mob.loc, distant_source.loc)
			var/vol = clamp(40 - ((dist - 3) * 5) * volume_pref_modifier, 0, 40) // Every tile decreases sound volume by 5
			hearing_mob.playsound_local(distant_source, takeoff ? takeoff_sound : landing_sound, vol)

// NOVA EDIT ADDITION START - HYPERSPACE_AREA_LEAK
#undef TRANSIT_AREA_CLEANUP_INTERVAL
#undef TRANSIT_AREA_CLEANUP_MAX_TRIES
// NOVA EDIT ADDITION END
