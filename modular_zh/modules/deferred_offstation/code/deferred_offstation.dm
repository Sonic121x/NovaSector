// Loads lavaland, lava/space ruins and the roundstart away mission after Master init instead of
// during it, so the lobby opens with only the station (and CentCom) initialized. See readme.md.

#define OFFSTATION_LOAD_IDLE 0
#define OFFSTATION_LOAD_RUNNING 1
#define OFFSTATION_LOAD_DONE 2

/// Map loader source used while placing deferred content.
#define OFFSTATION_LOADER_SOURCE "deferred offstation content"
/// Turfs processed between yields in the post-init passes (lighting, atmos).
#define OFFSTATION_TURFS_PER_BATCH 2000
/// Longest the load waits for lazily generated assets before starting anyway.
#define OFFSTATION_ASSET_WAIT (60 SECONDS)

/// When enabled, off-station content loads in the lobby after Master init. See modules/deferred_offstation.
/datum/config_entry/flag/defer_offstation_load
	default = FALSE

/datum/controller/subsystem/mapping
	/// TRUE when this round's off-station content was skipped during init and loads afterwards.
	var/offstation_deferred = FALSE
	/// OFFSTATION_LOAD_* state of the deferred load.
	var/offstation_load_state = OFFSTATION_LOAD_IDLE
	/// Whether players have been told the round start is waiting on the deferred load.
	var/offstation_wait_announced = FALSE
	/// The MC's sleep_offline_after_initializations, held back until the deferred load is done.
	var/offstation_held_sleep_offline = FALSE
	/// Stationary docking ports initialized by the deferred load, whose roundstart shuttles wait for the
	/// whole batch. Non-null only while the batch initializes.
	var/list/obj/docking_port/stationary/offstation_queued_shuttles
	/// TRUE while the deferred roundstart shuttles are still loading (after the round may start).
	var/offstation_shuttles_loading = FALSE

/datum/controller/subsystem/mapping/proc/nova_should_defer_offstation()
	return CONFIG_GET(flag/defer_offstation_load)

/// TRUE once nothing is left to load, so the round may start.
/datum/controller/subsystem/mapping/proc/offstation_ready()
	return !offstation_deferred || offstation_load_state == OFFSTATION_LOAD_DONE

/// Called by the MC once every subsystem has initialized.
/datum/controller/subsystem/mapping/proc/start_deferred_offstation_load()
	if(!offstation_deferred || offstation_load_state != OFFSTATION_LOAD_IDLE)
		return
	offstation_load_state = OFFSTATION_LOAD_RUNNING
	// An empty server stops world.time after init (world.sleep_offline), which would freeze this
	// load until the first player connects and leave them to walk into a half-loaded lavaland.
	if(Master.sleep_offline_after_initializations)
		offstation_held_sleep_offline = TRUE
		Master.sleep_offline_after_initializations = FALSE
	INVOKE_ASYNC(src, PROC_REF(load_deferred_offstation))

/datum/controller/subsystem/mapping/proc/announce_offstation_wait()
	if(offstation_wait_announced)
		return
	offstation_wait_announced = TRUE
	to_chat(world, span_notice(LANG("datum.e1bc4a85331e093b", null)))

/datum/controller/subsystem/mapping/proc/load_deferred_offstation()
	// Let the lazily generated assets (spritesheets queued during init) finish first: they normally
	// generate in the seconds after init, and this load would otherwise hold the MC for half a minute
	// right then, pushing them into the window where the first players connect and request them.
	var/asset_deadline = world.time + OFFSTATION_ASSET_WAIT
	do
		sleep(1 SECONDS)
	while((length(SSasset_loading.generate_queue) || SSasset_loading.assets_generating) && world.time < asset_deadline)
	var/start_time = REALTIMEOFDAY
	var/first_new_z = world.maxz + 1
	var/list/areas_before = alist()
	for(var/area/existing_area as anything in GLOB.areas)
		areas_before[existing_area] = TRUE

	// No try/catch anywhere in here, on purpose: stack_trace() reports a warning by CRASHing a
	// throwaway proc, and a try block up the stack would turn every such warning into an abort of
	// the whole load. Without one, an error ends only the proc it happens in, exactly as during init.
	var/lavaland_loaded = place_deferred_offstation(areas_before)
	// Idempotent. Only matters if place_deferred_offstation() errored in its own body before resetting
	// these, which would otherwise leave every atom created for the rest of the round uninitialized.
	SSatoms.map_loader_stop(OFFSTATION_LOADER_SOURCE)
	log_offstation_step("Placed deferred planetary content", start_time)
#ifndef SKIP_SPACE_LEVELS
	// The space ruin levels were created and initialized during init, so their ruins load the normal
	// mid-round way (initialized on placement), not in map loader mode.
	var/space_start = REALTIMEOFDAY
	setup_ruins(include_station = FALSE, include_lava = FALSE)
	log_offstation_step("Placed deferred space ruins", space_start)
#endif
	var/init_start = REALTIMEOFDAY
	initialize_deferred_offstation(first_new_z, lavaland_loaded)
	log_offstation_step("Initialized deferred off-station content", init_start)

	offstation_load_state = OFFSTATION_LOAD_DONE
	if(!offstation_shuttles_loading)
		release_offstation_sleep_offline()
	log_offstation_step("Loaded deferred off-station content", start_time)

/// Hands back what start_deferred_offstation_load() held, with the MC's own semantics. Only once the
/// shuttles are loaded too: an empty server would otherwise stop world.time with them half loaded.
/datum/controller/subsystem/mapping/proc/release_offstation_sleep_offline()
	if(!offstation_held_sleep_offline)
		return
	offstation_held_sleep_offline = FALSE
	Master.sleep_offline_after_initializations = TRUE
	if(!CONFIG_GET(flag/resume_after_initializations))
		world.sleep_offline = TRUE

/datum/controller/subsystem/mapping/proc/load_offstation_shuttles(list/obj/docking_port/stationary/ports)
	var/start_time = REALTIMEOFDAY
	SSshuttle.setup_shuttles(ports)
	offstation_shuttles_loading = FALSE
	log_offstation_step("Loaded [length(ports)] deferred roundstart shuttles", start_time)
	if(offstation_load_state == OFFSTATION_LOAD_DONE)
		release_offstation_sleep_offline()

/// Called from stationary docking ports' LateInitialize. TRUE if the port's roundstart shuttle was queued.
/datum/controller/subsystem/mapping/proc/queue_offstation_shuttle(obj/docking_port/stationary/port)
	if(isnull(offstation_queued_shuttles))
		return FALSE
	offstation_queued_shuttles += port
	return TRUE

/datum/controller/subsystem/mapping/proc/log_offstation_step(message, start_time)
	message = "[message] in [(REALTIMEOFDAY - start_time) / 10]s"
	log_world(message)
	log_mapping(message)

/**
 * Places the content of the new z-levels (lavaland, the away mission) in the same order and the same
 * atom state as init does: every new atom stays uninitialized until
 * [/datum/controller/subsystem/mapping/proc/initialize_deferred_offstation].
 *
 * That state is required, not cosmetic: the cave generator replaces turfs with `new` instead of
 * ChangeTurf because "the old tile hasn't got the chance to init yet". The map loader state is
 * global, so this phase must not yield either, or atoms created elsewhere meanwhile (a player's
 * lobby HUD) would never initialize. It takes a few seconds; it runs once, in the lobby.
 *
 * Returns TRUE if lavaland was loaded.
 */
/datum/controller/subsystem/mapping/proc/place_deferred_offstation(list/areas_before)
	var/old_ticklimit = Master.current_ticklimit
	Master.current_ticklimit = INFINITY // disables CHECK_TICK yields until restored
	SSatoms.map_loader_begin(OFFSTATION_LOADER_SOURCE)
	. = FALSE
#ifndef SKIP_LAVALAND
	if(current_map.minetype == MINETYPE_LAVALAND)
		var/list/failed_maps = list()
		LoadGroup(failed_maps, "Lavaland", "map_files/Mining", "Lavaland.dmm", default_traits = ZTRAITS_LAVALAND)
		if(length(failed_maps))
			stack_trace("Deferred lavaland failed to load: [failed_maps.Join(", ")]")
		else
			. = TRUE
#endif
#ifndef SKIP_SPACE_LEVELS
	if(CONFIG_GET(flag/roundstart_away))
		createRandomZlevel(prob(CONFIG_GET(number/config_gateway_chance)))
	else if(current_map.load_all_away_missions)
		load_all_away_missions()
	setup_ruins(include_station = FALSE, include_space = FALSE)
#endif
	for(var/area/new_area as anything in deferred_new_areas(areas_before))
		new_area.RunTerrainGeneration()
	setup_rivers(include_station = FALSE)
	load_reserved_ruins()
	for(var/area/new_area as anything in deferred_new_areas(areas_before))
		new_area.RunTerrainPopulation()
	require_area_resort()
	SSatoms.map_loader_stop(OFFSTATION_LOADER_SOURCE)
	Master.current_ticklimit = old_ticklimit

/datum/controller/subsystem/mapping/proc/deferred_new_areas(list/areas_before)
	. = list()
	for(var/area/candidate as anything in GLOB.areas)
		if(!areas_before[candidate])
			. += candidate

/**
 * Does for the deferred content what SSatoms, SSlighting, SSair and SSmachines did for the rest
 * of the map during init, the way [/datum/map_template/proc/initTemplateBounds] does it for
 * templates loaded mid-round. Yields freely: nothing here runs in map loader mode.
 */
/datum/controller/subsystem/mapping/proc/initialize_deferred_offstation(first_new_z, lavaland_loaded)
	// New z-levels (lavaland, away mission) plus the space ruin levels, which exist since init
	// but only now received their ruins.
	var/list/z_levels = list()
	for(var/z_level in first_new_z to world.maxz)
		z_levels += z_level
	z_levels |= levels_by_trait(ZTRAIT_SPACE_RUINS)

	// With nobody connected (an empty server after a restart, unit tests) there is no lobby to keep
	// responsive: run at init speed instead of yielding every tick, which costs about half again.
	// A player connecting meanwhile simply waits, as they would during init.
	var/old_ticklimit = Master.current_ticklimit
	var/unattended = !length(GLOB.clients)
	if(unattended)
		Master.current_ticklimit = INFINITY

	var/list/area/areas = list()
	var/list/turf/turfs = list()
	var/list/mob/mobs = list()
	var/list/obj/objs = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	for(var/z_level in z_levels)
		for(var/turf/level_turf as anything in Z_TURFS(z_level))
			if(!(level_turf.flags_1 & INITIALIZED_1))
				turfs += level_turf
				areas |= level_turf.loc
			if(!length(level_turf.contents))
				continue
			// Nested contents too (books shelved in a mapped bookcase): init covers every atom in the world.
			for(var/atom/movable/movable_in_turf as anything in level_turf.get_all_contents() - level_turf)
				if(movable_in_turf.flags_1 & INITIALIZED_1)
					continue
				if(ismob(movable_in_turf))
					mobs += movable_in_turf
				else
					objs += movable_in_turf
				if(istype(movable_in_turf, /obj/structure/cable))
					cables += movable_in_turf
				else if(istype(movable_in_turf, /obj/machinery/atmospherics))
					atmos_machines += movable_in_turf
			CHECK_TICK

	reg_in_areas_in_z(areas)
	release_offstation_smoothing(areas + turfs + objs + mobs)
	// Same order as initTemplateBounds(): areas, turfs, then what stands on them. Turfs create their air
	// in Initialize and mapped or spawned mobs check that air when they initialize, so turfs go first;
	// lava skips occupants that are not initialized yet (see /turf/open/lava/initialize_occupant).
	//
	// During init SSshuttle loads roundstart shuttles only after every atom is initialized. Here a dock's
	// LateInitialize would load its shuttle mid-batch, and the shuttle template's own InitializeAtoms
	// would run (again) the LateInitialize of everything still pending in this batch.
	offstation_queued_shuttles = list()
	var/step_start = REALTIMEOFDAY
	SSatoms.InitializeAtoms(areas + turfs + objs + mobs)
	log_offstation_step("Initialized [length(objs) + length(areas) + length(turfs) + length(mobs)] deferred atoms[unattended ? " (unattended)" : ""]", step_start)
	var/list/obj/docking_port/stationary/queued_shuttles = offstation_queued_shuttles
	offstation_queued_shuttles = null
	// SSicon_smooth's own Initialize() skips queued atoms that sit in nullspace or inside another
	// atom (a table a food cart creates and packs during its Initialize); its fire() doesn't, and they
	// runtime there. Check the queues rather than our lists: such atoms are created mid-batch.
	for(var/atom/queued as anything in SSicon_smooth.smooth_queue + SSicon_smooth.deferred + (SSicon_smooth.held_pools || list()))
		if(!queued.z)
			queued.smoothing_flags &= ~SMOOTH_QUEUED

	step_start = REALTIMEOFDAY
	for(var/batch_start in 1 to length(turfs) step OFFSTATION_TURFS_PER_BATCH)
		SSlighting.setup_static_lighting_if_needed(turfs.Copy(batch_start, min(batch_start + OFFSTATION_TURFS_PER_BATCH, length(turfs) + 1)))
		CHECK_TICK
	SSmachines.setup_template_powernets(cables)
	SSair.setup_template_machinery(atmos_machines)
	for(var/turf/new_turf as anything in turfs)
		if(QDELETED(new_turf))
			continue
		new_turf.air_update_turf(TRUE, TRUE)
		new_turf.levelupdate()
		CHECK_TICK

	log_offstation_step("Set up lighting, power and atmos for deferred content", step_start)

	// Subsystems that only scanned the world during their own init.
	for(var/z_level in first_new_z to world.maxz)
		SSweather.update_z_level(get_level(z_level))
	if(lavaland_loaded)
		// Sizes the new ore vents and randomizes ore rocks; at init this ran with lavaland absent.
		// ore_spread_probabilities is raw input on the first run and gets replaced by its own summary
		// (calculate_ore_spread), so it has to start empty again. It only feeds debug statistics.
		SSore_generation.ore_spread_probabilities = list()
		SSore_generation.Initialize()
	var/list/mining_levels = levels_by_trait(ZTRAIT_MINING)
	for(var/obj/machinery/computer/camera_advanced/console as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/camera_advanced))
		if(console.lock_override & CAMERA_LOCK_MINING)
			console.z_lock |= mining_levels
	require_area_resort()

	if(unattended)
		Master.current_ticklimit = old_ticklimit

	// Roundstart shuttles load one after another through transit reservations, which takes a while.
	// They sit on lavaland and ruins, so the round does not wait for them.
	log_mapping("Deferred off-station content queued [length(queued_shuttles)] roundstart shuttles")
	if(length(queued_shuttles))
		offstation_shuttles_loading = TRUE
		INVOKE_ASYNC(src, PROC_REF(load_offstation_shuttles), queued_shuttles)

/**
 * Atoms queued for smoothing during placement went straight into SSicon_smooth's live queue: in
 * map loader mode there is no mapload source to defer them under. SSicon_smooth would then smooth
 * each one as soon as the bulk init reached it, while its neighbours were still uninitialized (their
 * smoothing groups not yet built: "bad index" in bitmask_smooth). Take them back out; their own
 * Initialize() queues them again under InitializeAtoms' source, released once everything is ready.
 */
/datum/controller/subsystem/mapping/proc/release_offstation_smoothing(list/atom/pending_atoms)
	var/list/pending = alist()
	for(var/atom/pending_atom as anything in pending_atoms)
		if(pending_atom.smoothing_flags & SMOOTH_QUEUED)
			pending_atom.smoothing_flags &= ~SMOOTH_QUEUED
			pending[pending_atom] = TRUE
	if(!length(pending))
		return
	SSicon_smooth.smooth_queue = offstation_without(SSicon_smooth.smooth_queue, pending)
	SSicon_smooth.deferred = offstation_without(SSicon_smooth.deferred, pending)

/datum/controller/subsystem/mapping/proc/offstation_without(list/queue, list/pending)
	. = list()
	for(var/atom/queued as anything in queue)
		if(!pending[queued])
			. += queued

#undef OFFSTATION_LOAD_IDLE
#undef OFFSTATION_LOAD_RUNNING
#undef OFFSTATION_LOAD_DONE
#undef OFFSTATION_LOADER_SOURCE
#undef OFFSTATION_TURFS_PER_BATCH
#undef OFFSTATION_ASSET_WAIT
