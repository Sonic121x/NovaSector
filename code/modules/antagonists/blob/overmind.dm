// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
//Few global vars to track the blob
GLOBAL_LIST_EMPTY(blobs) //complete list of all blobs made.
GLOBAL_LIST_EMPTY(blob_cores)
GLOBAL_LIST_EMPTY(overminds)
GLOBAL_LIST_EMPTY(blob_nodes)

/// Clean up blob references after overmind is destroyed - called asynchronously to avoid blocking Destroy()
/proc/cleanup_overmind_blobs(mob/eye/blob/dead_overmind)
	// Clear overmind reference from global blobs
	for(var/obj/structure/blob/blob_structure as anything in GLOB.blobs)
		if(blob_structure && blob_structure.overmind == dead_overmind)
			blob_structure.overmind = null
			blob_structure.update_appearance() //reset anything that was ours


/mob/eye/blob
	name = "Blob Overmind"
	real_name = "Blob Overmind"
	desc = "The overmind. It controls the blob."
	icon = 'icons/mob/eyemob.dmi'
	icon_state = "marker"
	mouse_opacity = MOUSE_OPACITY_ICON
	move_on_shuttle = TRUE
	invisibility = INVISIBILITY_OBSERVER
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE
	see_invisible = SEE_INVISIBLE_LIVING
	pass_flags = PASSBLOB
	faction = list(ROLE_BLOB)
	// Vivid blue green, would be cool to make this change with strain
	lighting_cutoff_red = 0
	lighting_cutoff_green = 35
	lighting_cutoff_blue = 20
	hud_type = /datum/hud/blob_overmind
	var/obj/structure/blob/special/core/blob_core = null // The blob overmind's core
	var/blob_points = 0
	var/max_blob_points = OVERMIND_MAX_POINTS_DEFAULT
	var/last_attack = 0
	var/datum/blobstrain/reagent/blobstrain
	var/list/blob_mobs = list()
	/// A list of all blob structures
	var/list/all_blobs = list()
	var/list/resource_blobs = list()
	var/list/factory_blobs = list()
	var/list/node_blobs = list()
	var/free_strain_rerolls = OVERMIND_STARTING_REROLLS
	var/last_reroll_time = 0 //time since we last rerolled, used to give free rerolls
	var/nodes_required = TRUE //if the blob needs nodes to place resource and factory blobs
	var/placed = FALSE
	var/manualplace_min_time = OVERMIND_STARTING_MIN_PLACE_TIME // Some time to get your bearings
	var/autoplace_max_time = OVERMIND_STARTING_AUTO_PLACE_TIME // Automatically place the core in a random spot
	var/list/blobs_legit = list()
	var/max_count = 0 //The biggest it got before death
	var/blobwincount = OVERMIND_WIN_CONDITION_AMOUNT
	var/victory_in_progress = FALSE
	var/rerolling = FALSE
	var/announcement_size = OVERMIND_ANNOUNCEMENT_MIN_SIZE // Announce the biohazard when this size is reached
	var/announcement_time
	var/has_announced = FALSE

	/// The list of strains the blob can reroll for.
	var/list/strain_choices

	/// Adminbus potential - if this is set to FALSE, the blob won't end the round upon reaching critical mass.
	var/end_round_on_victory = TRUE

/mob/eye/blob/Initialize(mapload, starting_points = OVERMIND_STARTING_POINTS)
	ADD_TRAIT(src, TRAIT_BLOB_ALLY, INNATE_TRAIT)
	validate_location()
	blob_points = starting_points
	manualplace_min_time += world.time
	autoplace_max_time += world.time
	GLOB.overminds += src
	// NOVA EDIT CHANGE - i18n: initial(name) 是编译期英文原值，会覆盖掉 /atom/Initialize 反查好的中文名
	var/new_name = "[lang_reverse_text(initial(name))] ([rand(1, 999)])"
	name = new_name
	real_name = new_name
	last_attack = world.time
	var/datum/blobstrain/BS = pick(GLOB.valid_blobstrains)
	set_strain(BS)
	color = blobstrain.complementary_color
	if(blob_core)
		blob_core.update_appearance()
	SSshuttle.registerHostileEnvironment(src)
	. = ..()
	START_PROCESSING(SSobj, src)
	GLOB.blob_telepathy_mobs |= src

/mob/eye/blob/proc/validate_location()
	var/turf/T = get_turf(src)
	if(is_valid_turf(T))
		return

	if(LAZYLEN(GLOB.blobstart))
		var/list/blobstarts = shuffle(GLOB.blobstart)
		for(var/_T in blobstarts)
			if(is_valid_turf(_T))
				T = _T
				break
	else // no blob starts so look for an alternate
		for(var/i in 1 to 16)
			var/turf/picked_safe = get_safe_random_station_turf_equal_weight()
			if(is_valid_turf(picked_safe))
				T = picked_safe
				break

	if(!T)
		CRASH("No blobspawnpoints and blob spawned in nullspace.")
	forceMove(T)

/mob/eye/blob/proc/set_strain(datum/blobstrain/new_strain)
	if (!ispath(new_strain))
		return FALSE

	var/had_strain = FALSE
	if (istype(blobstrain))
		blobstrain.on_lose()
		qdel(blobstrain)
		had_strain = TRUE

	blobstrain = new new_strain(src)
	blobstrain.on_gain()

	if (had_strain)
		to_chat(src, span_notice(LANG("mob.3cac6a9a", list(blobstrain.color, blobstrain.name))))
		to_chat(src, span_notice(LANG("mob.085481ce", list(blobstrain.color, blobstrain.name, blobstrain.description))))
		if(blobstrain.effectdesc)
			to_chat(src, span_notice(LANG("mob.085481ce", list(blobstrain.color, blobstrain.name, blobstrain.effectdesc))))
	SEND_SIGNAL(src, COMSIG_BLOB_SELECTED_STRAIN, blobstrain)

/mob/eye/blob/can_z_move(direction, turf/start, turf/destination, z_move_flags = NONE, mob/living/rider)
	if(placed) // The blob can't expand vertically (yet)
		return FALSE
	. = ..()
	if(!.)
		return
	var/turf/target_turf = .
	if(!is_valid_turf(target_turf)) // Allows unplaced blobs to travel through station z-levels
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(src, span_warning(LANG("mob.8b7a5af9", null)))
		return null

/mob/eye/blob/proc/is_valid_turf(turf/tile)
	var/area/area = get_area(tile)
	if((area && !(area.area_flags & BLOBS_ALLOWED)) || !tile || !is_station_level(tile.z) || isgroundlessturf(tile))
		return FALSE
	return TRUE

/mob/eye/blob/process()
	if(!blob_core)
		if(!placed)
			if(manualplace_min_time && world.time >= manualplace_min_time)
				to_chat(src, span_boldnotice(LANG("mob.d25948b2", null)))
				to_chat(src, span_bolddanger(LANG("mob.ab478224", list(DisplayTimeText(autoplace_max_time - world.time)))))
				manualplace_min_time = 0
			if(autoplace_max_time && world.time >= autoplace_max_time)
				place_blob_core(BLOB_RANDOM_PLACEMENT)
		else
			// If we get here, it means yes: the blob is kill
			SSticker.news_report = BLOB_DESTROYED

			// Clear the biohazard emergency display when blob is defeated - async to avoid blocking
			INVOKE_ASYNC(src, PROC_REF(clear_biohazard_display))

			qdel(src)
	else if(!victory_in_progress && (blobs_legit.len >= blobwincount))
		begin_victory()

	else if(!free_strain_rerolls && (last_reroll_time + BLOB_POWER_REROLL_FREE_TIME<world.time))
		to_chat(src, span_boldnotice(LANG("mob.dbba95d5", null)))
		free_strain_rerolls = 1

	if(!victory_in_progress && max_count < blobs_legit.len)
		max_count = blobs_legit.len

	if(announcement_time && (world.time >= announcement_time || blobs_legit.len >= announcement_size) && !has_announced)
		priority_announce(LANG("mob.4bada0d0", list(station_name())), "Biohazard Alert", ANNOUNCER_OUTBREAK5)
		SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_TOMBSTONE] = TRUE

		// Set status displays to biohazard alert
		send_status_display_biohazard_alert()

		has_announced = TRUE

/// Create a blob spore and link it to us
/mob/eye/blob/proc/create_spore(turf/spore_turf, spore_type = /mob/living/basic/blob_minion/spore/minion)
	var/mob/living/basic/blob_minion/spore/spore = new spore_type(spore_turf, blob_borne = TRUE)
	spore.AddComponent(/datum/component/blob_minion, src)
	return spore

/// Add something to our list of mobs and wait for it to die
/mob/eye/blob/proc/register_new_minion(mob/living/minion)
	blob_mobs |= minion

/// Clear biohazard emergency display when blob is defeated
/mob/eye/blob/proc/clear_biohazard_display()
	clear_status_display_biohazard()

/// Announce the blob's victory! Tell everyone that they're about to explode and/or turn into biomass soup and give the overmind a victory lap.
/mob/eye/blob/proc/begin_victory()
	victory_in_progress = TRUE
	priority_announce("Biohazard has reached critical mass. Station loss is imminent.", "Biohazard Alert")
	SSsecurity_level.set_level(SEC_LEVEL_DELTA)

	// Set status displays to biohazard alert - critical level
	send_status_display_biohazard_alert()
	if(end_round_on_victory) // Assuming they actually *are* about to turn the station into soup...
		max_blob_points = INFINITY
		blob_points = INFINITY
	else
		to_chat(src, span_blob(LANG("mob.30fec253", null)))
	addtimer(CALLBACK(src, PROC_REF(victory)), 45 SECONDS)

/// Actually *do* the blob's victory: give them their greentext and, depending on the end_round_on_victory variable, decide if everyone dies or if it's just a jumpscare.
/mob/eye/blob/proc/victory()
	// Set victory flags immediately
	var/datum/antagonist/blob/B = mind.has_antag_datum(/datum/antagonist/blob)
	if(B)
		var/datum/objective/blob_takeover/main_objective = locate() in B.objectives
		if(main_objective)
			main_objective.completed = TRUE

	if(end_round_on_victory)
		to_chat(world, span_blobannounce(LANG("mob.82d7fc5f", list(real_name))))
		SSticker.news_report = BLOB_WIN
		SSticker.force_ending = FORCE_END_ROUND

		// Handle the heavy victory operations (where everyone dies) asynchronously
		INVOKE_ASYNC(src, PROC_REF(victory_sequence))
	else
		// Is the station going boom? No. But is the station still going to get yelled at? Yes.
		priority_announce("Experimental, classified, and very expensive emergency countermeasures have been activated to prevent total station loss, \
			but the initial failure to contain the viral biohazard will be noted on the station's performance report. Expect further penalties.", \
			"Emergency Biohazard Countermeasure Alert")

/// Kill everyone who's still on the station area and not already part of the blob's faction, and cover every station area with blob icons. Everyone's soup now.
/mob/eye/blob/proc/victory_sequence()
	sound_to_playing_players('sound/announcer/alarm/nuke_alarm.ogg', 70)
	sleep(10 SECONDS)
	for(var/mob/living/live_guy as anything in GLOB.mob_living_list)
		var/turf/guy_turf = get_turf(live_guy)
		if(isnull(guy_turf) || !is_station_level(guy_turf.z))
			continue

		if((live_guy in GLOB.overminds) || (live_guy.pass_flags & PASSBLOB))
			continue

		var/area/blob_area = get_area(guy_turf)
		if(!(blob_area.area_flags & BLOBS_ALLOWED))
			continue

		if(!live_guy.has_faction(ROLE_BLOB))
			playsound(live_guy, 'sound/effects/splat.ogg', 50, TRUE)
			if(live_guy.stat != DEAD)
				live_guy.investigate_log("has died from blob takeover.", INVESTIGATE_DEATHS)
			live_guy.death()
			create_spore(guy_turf, spore_type = /mob/living/basic/blob_minion/spore)
		else
			live_guy.fully_heal()

	for(var/area_type in GLOB.the_station_areas)
		var/area/check_area = GLOB.areas_by_type[area_type]
		if(!(check_area.area_flags & BLOBS_ALLOWED))
			continue
		check_area.color = blobstrain.color
		check_area.name = "blob"
		check_area.icon = 'icons/mob/nonhuman-player/blob.dmi'
		check_area.icon_state = "blob_shield"
		check_area.layer = BELOW_MOB_LAYER
		check_area.SetInvisibility(INVISIBILITY_NONE)
		check_area.blend_mode = 0

/mob/eye/blob/Destroy()
	QDEL_NULL(blobstrain)

	// Clear references immediately without iterating to avoid blocking
	all_blobs = null
	resource_blobs = null
	factory_blobs = null
	node_blobs = null
	blob_mobs = null
	GLOB.overminds -= src
	QDEL_LIST_ASSOC_VAL(strain_choices)

	SSshuttle.clearHostileEnvironment(src)
	STOP_PROCESSING(SSobj, src)
	GLOB.blob_telepathy_mobs -= src

	// Handle blob cleanup asynchronously to avoid blocking Destroy()
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(cleanup_overmind_blobs), src)

	return ..()

/mob/eye/blob/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, span_blobannounce(LANG("mob.cfcc522b", null)))
	if(!placed && autoplace_max_time <= world.time)
		to_chat(src, span_bolddanger(LANG("mob.ab478224", list(DisplayTimeText(autoplace_max_time - world.time)))))
		to_chat(src, span_bolddanger(LANG("mob.04a4ef71", list(manualplace_min_time ? "will be able to":"can"))))
	update_health_hud()
	add_points(0)

/mob/eye/blob/examine(mob/user)
	. = ..()
	if(blobstrain)
		. += LANG("mob.a1e2b6e4", list(blobstrain.color, blobstrain.name))

/mob/eye/blob/update_health_hud(healthpercent)
	if(!blob_core)
		return FALSE
	var/current_health = round((blob_core.get_integrity() / blob_core.max_integrity) * 100)
	var/new_maptext = MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#82ed00'>[current_health]%</font></div>")
	hud_used.screen_objects[HUD_MOB_HEALTH].maptext = new_maptext
	for(var/mob/living/basic/blob_minion/blobbernaut/blobbernaut in blob_mobs)
		var/atom/movable/screen/overmind_hud = blobbernaut.hud_used?.screen_objects[HUD_BLOBBERNAUT_OVERMIND]
		if (overmind_hud)
			overmind_hud.maptext = new_maptext

/mob/eye/blob/proc/add_points(points)
	blob_points = clamp(blob_points + points, 0, max_blob_points)
	hud_used.screen_objects[HUD_BLOB_POWER_DISPLAY].maptext = MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#e36600'>[round(blob_points)]</font></div>")

/mob/eye/blob/say(
	message,
	bubble_type,
	list/spans = list(),
	sanitize = TRUE,
	datum/language/language,
	ignore_spam = FALSE,
	forced,
	filterproof = FALSE,
	message_range = 7,
	datum/saymode/saymode,
	list/message_mods = list(),
)
	if (!message)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, span_boldwarning(LANG("mob.edad7622", null)))
			return
		if (!(ignore_spam || forced) && src.client.handle_spam_prevention(message, MUTE_IC))
			return

	if (stat)
		return

	blob_talk(message)

/mob/eye/blob/proc/blob_talk(message)

	message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))

	if (!message)
		return

	var/list/message_mods = list()
	var/adjusted_message = check_for_custom_say_emote(message, message_mods)
	log_sayverb_talk(message, message_mods, tag = "blob hivemind telepathy")
	var/messagepart = generate_messagepart(adjusted_message, message_mods = message_mods)
	var/rendered = span_big(span_blob("<b>\[Blob Telepathy\] [name](<font color=\"[blobstrain.color]\">[blobstrain.name]</font>)</b> [messagepart]"))
	relay_to_list_and_observers(rendered, GLOB.blob_telepathy_mobs, src, MESSAGE_TYPE_RADIO)

/mob/eye/blob/blob_act(obj/structure/blob/B)
	return

/mob/eye/blob/get_status_tab_items()
	. = ..()
	if(blob_core)
		. += LANG("mob.7786c79e", list(blob_core.get_integrity()))
		. += LANG("mob.98a48fb8", list(blob_points, max_blob_points))
		. += LANG("mob.41c202a1", list(blobs_legit.len, blobwincount))
	if(free_strain_rerolls)
		. += LANG("mob.637bd3ab", list(free_strain_rerolls))
	if(!placed)
		if(manualplace_min_time)
			. += LANG("mob.5760c2e1", list(max(round((manualplace_min_time - world.time)*0.1, 0.1), 0)))
		. += LANG("mob.4aae48eb", list(max(round((autoplace_max_time - world.time)*0.1, 0.1), 0)))

/mob/eye/blob/Move(NewLoc, Dir = 0)
	if(placed)
		var/obj/structure/blob/B = locate() in range(OVERMIND_MAX_CAMERA_STRAY, NewLoc)
		if(B)
			forceMove(NewLoc)
		else
			return FALSE
	else
		var/area/check_area = get_area(NewLoc)
		if(isgroundlessturf(NewLoc) || istype(check_area, /area/shuttle)) //if unplaced, can't go on shuttles or groundless tiles
			return FALSE
		forceMove(NewLoc)
		return TRUE

/mob/eye/blob/mind_initialize()
	. = ..()
	var/datum/antagonist/blob/blob = mind.has_antag_datum(/datum/antagonist/blob)
	if(!blob)
		mind.add_antag_datum(/datum/antagonist/blob)
