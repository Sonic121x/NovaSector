// Autopilot for real connected clients: plays the way a player would (ready up, latejoin, walk,
// click, talk, open windows) through the same entry points the client's own input uses, so local
// runs exercise connection, asset delivery, chat and TGUI with a real DreamSeeker on the other end.
// See readme.md and tools/zh/sim-players.sh.

/// World param that turns the autopilot on: "all", or a comma separated list of ckeys.
#define SIM_PLAYERS_PARAM "sim-players"
/// World param: "all" gives driven crew station-wide access, so the map tour can reach every room.
#define SIM_ACCESS_PARAM "sim-access"
/// Shortest and longest pause between two decisions.
#define SIM_THINK_MIN (1 SECONDS)
#define SIM_THINK_MAX (3 SECONDS)
/// How long a window the autopilot opened stays open.
#define SIM_UI_HOLD (12 SECONDS)
/// A decision still running after this long (an alert waiting for input, a long do_after) no longer
/// blocks the next one.
#define SIM_BUSY_TIMEOUT (30 SECONDS)
/// Dead this long, the autopilot ghosts.
#define SIM_GHOST_AFTER (30 SECONDS)
/// Disconnected this long, the autopilot gives up on the ckey.
#define SIM_GONE_TIMEOUT (5 MINUTES)
/// Steps taken per walking decision.
#define SIM_WALK_STEPS 6
/// Range the autopilot looks for something to walk to.
#define SIM_GOAL_RANGE 7
/// Longest path the map tour walks to reach its next target.
#define SIM_TOUR_RANGE 150
/// Candidates the map tour weighs when picking the next target.
#define SIM_TOUR_SAMPLES 25
/// Times a step is retried (a door opening) before the tour gives up on the path.
#define SIM_STEP_RETRIES 4

SUBSYSTEM_DEF(sim_players)
	name = "Simulated Players"
	ss_flags = SS_NO_FIRE
	/// Drive every client that connects.
	var/drive_all = FALSE
	/// ckeys to drive, when not driving everyone.
	var/list/wanted_ckeys = list()
	/// ckey -> /datum/sim_player
	var/list/drivers = list()
	/// Driven crew get station-wide access.
	var/all_access = FALSE
	/// type -> weakrefs to the station's interactable objects of that type; null until first needed.
	var/list/map_targets
	var/indexing_map = FALSE
	/// Types some driven player has walked up to and used.
	var/list/visited_types = list()

/// The autopilot takes over players' input, so it only exists on a server started for local testing:
/// the launch param must ask for it, and a TGS-managed (production) server never allows it.
/proc/sim_players_allowed()
	return !!world.params[SIM_PLAYERS_PARAM] && !world.TgsAvailable()

/datum/controller/subsystem/sim_players/Initialize()
	if(!sim_players_allowed())
		return SS_INIT_NO_NEED
	var/raw = world.params[SIM_PLAYERS_PARAM]
	if(LOWER_TEXT(raw) == "all")
		drive_all = TRUE
	else
		for(var/entry in splittext(raw, ","))
			var/key = ckey(entry)
			if(key)
				wanted_ckeys[key] = TRUE
	all_access = world.params[SIM_ACCESS_PARAM] == "all"
	RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_CONNECT, PROC_REF(on_client_connect))
	for(var/client/connected as anything in GLOB.clients)
		on_client_connect(SSdcs, connected)
	log_sim("autopilot on for [drive_all ? "every client" : jointext(wanted_ckeys, ", ")]")
	return SS_INIT_SUCCESS

/datum/controller/subsystem/sim_players/proc/on_client_connect(datum/source, client/connected)
	SIGNAL_HANDLER
	if(drive_all || wanted_ckeys[connected.ckey])
		drive(connected.ckey)

/datum/controller/subsystem/sim_players/proc/drive(ckey)
	if(!sim_players_allowed() || drivers[ckey])
		return
	drivers[ckey] = new /datum/sim_player(ckey)
	log_sim("[ckey] | autopilot engaged | |")

/datum/controller/subsystem/sim_players/proc/release(ckey)
	var/datum/sim_player/driver = drivers[ckey]
	if(!driver)
		return
	drivers -= ckey
	log_sim("[ckey] | autopilot released | [driver.summary()] |")
	qdel(driver)

/// Everything on the station a player could walk up to and use, by type. Built once, on first use.
/datum/controller/subsystem/sim_players/proc/get_map_targets()
	if(map_targets)
		return map_targets
	if(indexing_map)
		UNTIL(!indexing_map)
		return map_targets
	indexing_map = TRUE
	var/list/found = list()
	var/count = 0
	for(var/area/station/station_area in GLOB.areas)
		for(var/turf/area_turf as anything in station_area.get_turfs_from_all_zlevels())
			for(var/obj/thing in area_turf)
				if(is_tour_target(thing))
					LAZYADD(found[thing.type], WEAKREF(thing))
					count++
			CHECK_TICK
	map_targets = found
	indexing_map = FALSE
	log_sim("map index | [count] objects of [length(found)] types | |")
	return map_targets

/datum/controller/subsystem/sim_players/proc/is_tour_target(obj/thing)
	if(thing.invisibility > SEE_INVISIBLE_LIVING || thing.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
		return FALSE
	if(!ismachinery(thing) && !isstructure(thing) && !isitem(thing))
		return FALSE
	// Walked through or past anyway, or not something to put a hand on.
	if(istype(thing, /obj/machinery/door) || istype(thing, /obj/structure/window) || istype(thing, /obj/structure/grille) \
		|| istype(thing, /obj/structure/cable) || istype(thing, /obj/machinery/atmospherics/pipe) || istype(thing, /obj/structure/disposalpipe) \
		|| istype(thing, /obj/machinery/power/supermatter_crystal))
		return FALSE
	return TRUE

/datum/controller/subsystem/sim_players/proc/log_sim(text)
	if(GLOB.log_directory)
		WRITE_LOG("[GLOB.log_directory]/sim_players.log", text)

/// Lets an admin hand their own client to the autopilot, or take it back. Only on servers started
/// with the autopilot param.
ADMIN_VERB_CUSTOM_EXIST_CHECK(toggle_sim_player)
	return sim_players_allowed()

ADMIN_VERB(toggle_sim_player, R_DEBUG, "自动驾驶接管自己", "Let the autopilot play as you, or take control back (local testing).", ADMIN_CATEGORY_DEBUG)
	if(SSsim_players.drivers[user.ckey])
		SSsim_players.release(user.ckey)
		to_chat(user, span_notice(LANG("datum.974296de198da601", null)))
		return
	SSsim_players.drive(user.ckey)
	to_chat(user, span_notice(LANG("datum.f46d0b5413935f65", null)))

/// Drives one ckey. Holds the ckey rather than the client, so it follows the player through
/// reconnects and mob changes.
/datum/sim_player
	var/ckey
	var/active = TRUE
	var/last_seen = 0
	/// world.time the running decision started, 0 when idle.
	var/busy_since = 0
	/// world.time the autopilot last opened a window, 0 when none is open.
	var/ui_opened_at = 0
	var/dead_since = 0
	/// Where the autopilot is walking to.
	var/datum/weakref/goal_ref
	var/blocked_steps = 0
	/// action -> times taken
	var/list/counts = list()
	/// The body that last got station-wide access.
	var/datum/weakref/granted_ref
	/// Tour targets this player could not reach.
	var/list/unreachable = list()

/datum/sim_player/New(ckey)
	src.ckey = ckey
	last_seen = world.time
	INVOKE_ASYNC(src, PROC_REF(run_loop))

/datum/sim_player/Destroy(force)
	active = FALSE
	goal_ref = null
	return ..()

/datum/sim_player/proc/summary()
	var/list/parts = list()
	for(var/action in counts)
		parts += "[action] [counts[action]]"
	return jointext(parts, ", ")

/datum/sim_player/proc/run_loop()
	while(active)
		var/client/player = GLOB.directory[ckey]
		if(player?.mob)
			last_seen = world.time
			if(!busy_since || world.time - busy_since > SIM_BUSY_TIMEOUT)
				INVOKE_ASYNC(src, PROC_REF(think), player)
		else if(world.time - last_seen > SIM_GONE_TIMEOUT)
			SSsim_players.release(ckey)
			return
		sleep(rand(SIM_THINK_MIN, SIM_THINK_MAX))

/datum/sim_player/proc/think(client/player)
	busy_since = world.time
	// Everything below runs as the player's own input would, and much of it reads usr.
	usr = player.mob
	if(isnewplayer(player.mob))
		think_lobby(player, player.mob)
	else if(isobserver(player.mob))
		think_ghost(player, player.mob)
	else if(isliving(player.mob))
		think_living(player, player.mob)
	busy_since = 0

/datum/sim_player/proc/note(client/player, action, atom/target)
	counts[action]++
	var/mob/body = player.mob
	SSsim_players.log_sim("[ckey] | [action] | [target ? "[target] ([target.type])" : ""] | [body?.type] @ [AREACOORD(body)]")

// ------------------------------------------------------------------ input entry points

/// A link click: same path as an href the client sends.
/datum/sim_player/proc/click_href(client/player, datum/target, list/href_list)
	href_list = href_list.Copy()
	href_list["src"] = REF(target)
	player.Topic(list2params(href_list), href_list, target)

/// A button press in an open TGUI window: same message the TGUI frontend sends.
/datum/sim_player/proc/press(client/player, datum/src_object, action, list/params = list())
	var/datum/tgui/ui = SStgui.get_open_ui(player.mob, src_object)
	if(!ui?.window)
		return FALSE
	var/list/href_list = list(
		"tgui" = "1",
		"window_id" = ui.window.id,
		"type" = "act/[action]",
		"payload" = json_encode(params),
	)
	player.Topic(list2params(href_list), href_list)
	return TRUE

/// A left click on the map.
/datum/sim_player/proc/click_atom(client/player, atom/target)
	player.Click(target, target.loc, "mapwindow.map", "left=1;button=left;icon-x=16;icon-y=16")

/// A hotkey press, through the keybinding the key is bound to.
/datum/sim_player/proc/press_key(client/player, keybinding_name)
	var/datum/keybinding/binding = GLOB.keybindings_by_name[keybinding_name]
	if(!binding?.can_use(player))
		return
	binding.down(player, get_turf(player.mob))
	binding.up(player)

/// Typing into the say box.
/datum/sim_player/proc/speak(client/player, text)
	player.mob.say_verb(text)

/datum/sim_player/proc/note_window(client/player)
	if(length(player.mob.tgui_open_uis))
		ui_opened_at = world.time

/datum/sim_player/proc/close_windows(client/player)
	if(!ui_opened_at || world.time - ui_opened_at < SIM_UI_HOLD)
		return FALSE
	ui_opened_at = 0
	SStgui.close_user_uis(player.mob)
	note(player, "close windows")
	return TRUE

// ------------------------------------------------------------------ lobby

/datum/sim_player/proc/think_lobby(client/player, mob/dead/new_player/lobby_mob)
	if(close_windows(player))
		return
	switch(SSticker.current_state)
		if(GAME_STATE_STARTUP)
			return
		if(GAME_STATE_PREGAME)
			if(!lobby_mob.is_ready_to_play())
				click_href(player, lobby_mob, list("toggle_ready" = "1"))
				note(player, "ready up")
			else if(prob(15))
				var/button = pick("character_setup", "game_options", "view_manifest")
				click_href(player, lobby_mob, list("[button]" = "1"))
				note_window(player)
				note(player, "lobby [button]")
		if(GAME_STATE_PLAYING)
			if(!press(player, GLOB.latejoin_menu, "select_job", list("job" = JOB_ASSISTANT)))
				click_href(player, lobby_mob, list("late_join" = "1"))
				note(player, "open latejoin")
			else
				note(player, "latejoin")

// ------------------------------------------------------------------ ghost

/datum/sim_player/proc/think_ghost(client/player, mob/dead/observer/ghost)
	if(close_windows(player))
		return
	if(prob(20))
		var/list/candidates = list()
		for(var/mob/living/someone as anything in GLOB.alive_player_list)
			if(someone.z)
				candidates += someone
		if(length(candidates))
			var/mob/living/target = pick(candidates)
			ghost.ManualFollow(target)
			note(player, "orbit", target)
			return
	walk_randomly(player, ghost)

// ------------------------------------------------------------------ living

/datum/sim_player/proc/think_living(client/player, mob/living/body)
	if(body.stat == DEAD)
		if(!dead_since)
			dead_since = world.time
		else if(world.time - dead_since > SIM_GHOST_AFTER)
			body.ghostize(TRUE)
			note(player, "ghost")
		return
	dead_since = 0
	if(SSsim_players.all_access && granted_ref?.resolve() != body)
		grant_access(player, body)
	if(close_windows(player))
		return
	if(body.incapacitated)
		return
	switch(rand(1, 100))
		if(1 to 45)
			tour(player, body)
		if(46 to 55)
			speak(player, pick(GLOB.sim_player_lines))
			note(player, "say")
		if(56 to 60)
			speak(player, "*[pick("laugh", "nod", "wave", "shrug", "smile", "sigh", "clap")]")
			note(player, "emote")
		if(61 to 72)
			var/list/seen = list()
			for(var/atom/thing in oview(SIM_GOAL_RANGE, body))
				seen += thing
			if(length(seen))
				var/atom/target = pick(seen)
				body.examinate(target)
				note(player, "examine", target)
		if(73 to 78)
			use_held_item(player, body)
		if(79 to 82)
			var/obj/item/held = body.get_active_held_item()
			if(held)
				body.dropItemToGround(held)
				note(player, "drop", held)
			else
				press_key(player, "swap_hands_row")
				note(player, "swap hands")
		if(83 to 85)
			player.prefs.ui_interact(body)
			note_window(player)
			note(player, "open preferences")
		else
			click_nearby(player, body)

/datum/sim_player/proc/use_held_item(client/player, mob/living/body)
	var/obj/item/held = body.get_active_held_item()
	if(!held)
		return
	// Nothing that ends the run for everyone.
	if(istype(held, /obj/item/grenade) || istype(held, /obj/item/transfer_valve) || istype(held, /obj/item/bombcore))
		return
	held.attack_self(body)
	note_window(player)
	note(player, "use in hand", held)

/datum/sim_player/proc/click_nearby(client/player, mob/living/body)
	var/list/near = list()
	for(var/atom/movable/thing in orange(1, body))
		if(thing.invisibility > body.see_invisible || thing.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
			continue
		var/obj/item/item = thing
		if(istype(item) && (item.item_flags & ABSTRACT))
			continue
		near += thing
	if(!length(near))
		return
	var/atom/movable/target = pick(near)
	click_atom(player, target)
	note_window(player)
	note(player, "click", target)

/// Picks something interesting in view, walks next to it and clicks it.
/datum/sim_player/proc/walk_to_goal(client/player, mob/living/body)
	var/atom/movable/goal = goal_ref?.resolve()
	if(QDELETED(goal) || !goal.loc || get_dist(body, goal) > SIM_GOAL_RANGE || blocked_steps > 4)
		goal = pick_goal(body)
		goal_ref = goal ? WEAKREF(goal) : null
		blocked_steps = 0
		if(!goal)
			walk_randomly(player, body)
			return
		note(player, "head for", goal)
	for(var/i in 1 to SIM_WALK_STEPS)
		if(QDELETED(goal) || QDELETED(body) || player.mob != body)
			return
		if(body.Adjacent(goal))
			click_atom(player, goal)
			note_window(player)
			note(player, "click", goal)
			goal_ref = null
			return
		var/direction = get_dir(body, goal)
		if(!step_as_player(player, body, direction))
			blocked_steps++
			step_as_player(player, body, pick(GLOB.cardinals - direction))
		else
			counts["step"]++

/datum/sim_player/proc/grant_access(client/player, mob/living/body)
	var/obj/item/card/id/id = body.get_idcard(FALSE)
	if(!id)
		return
	granted_ref = WEAKREF(body)
	id.access |= SSid_access.get_region_access_list(list(REGION_ALL_STATION))
	note(player, "grant access", id)

/// Walks across the map to the next station object, preferring types nobody has used yet, and
/// uses it.
/datum/sim_player/proc/tour(client/player, mob/living/body)
	var/list/targets = SSsim_players.get_map_targets()
	if(!length(targets))
		walk_to_goal(player, body)
		return
	var/obj/goal = goal_ref?.resolve()
	if(QDELETED(goal) || !isturf(goal.loc) || goal.z != body.z || blocked_steps > 2)
		if(goal)
			unreachable[goal_ref] = TRUE
		goal = pick_tour_target(body, targets)
		goal_ref = goal ? WEAKREF(goal) : null
		blocked_steps = 0
		if(!goal)
			walk_randomly(player, body)
			return
		note(player, "head for", goal)
	if(body.Adjacent(goal))
		visit(player, body, goal)
		return
	var/obj/item/card/id/id = body.get_idcard(FALSE)
	var/list/path = get_path_to(body, goal, SIM_TOUR_RANGE, 1, id ? id.GetAccess() : list())
	if(!length(path))
		note(player, "no path", goal)
		blocked_steps = INFINITY
		return
	for(var/turf/next as anything in path)
		busy_since = world.time
		if(QDELETED(goal) || QDELETED(body) || player.mob != body || body.stat || body.incapacitated)
			return
		if(body.Adjacent(goal))
			break
		for(var/try_count in 1 to SIM_STEP_RETRIES)
			if(get_turf(body) == next || get_dist(body, next) > 1)
				break
			if(step_as_player(player, body, get_dir(body, next)))
				counts["step"]++
			else
				sleep(0.5 SECONDS)
		if(get_turf(body) != next)
			// Shoved, stuck behind something, or a door that will not open: path again next time.
			blocked_steps++
			note(player, "blocked", next)
			return
	if(!QDELETED(goal) && body.Adjacent(goal))
		visit(player, body, goal)

/datum/sim_player/proc/pick_tour_target(mob/living/body, list/targets)
	var/list/fresh = list()
	for(var/target_type in targets)
		if(!SSsim_players.visited_types[target_type])
			fresh += target_type
	var/list/pool = length(fresh) ? fresh : targets
	var/obj/best
	var/best_distance = INFINITY
	for(var/i in 1 to SIM_TOUR_SAMPLES)
		var/datum/weakref/ref = pick(targets[pick(pool)])
		if(unreachable[ref])
			continue
		var/obj/candidate = ref.resolve()
		if(QDELETED(candidate) || !isturf(candidate.loc) || candidate.z != body.z)
			continue
		var/distance = get_dist(body, candidate)
		if(distance < best_distance)
			best = candidate
			best_distance = distance
	return best

/// At a tour target: look at it, then use it with the free hand or the held item.
/datum/sim_player/proc/visit(client/player, mob/living/body, obj/goal)
	goal_ref = null
	SSsim_players.visited_types[goal.type] = TRUE
	note(player, "visit", goal)
	body.examinate(goal)
	sleep(1 SECONDS)
	if(QDELETED(goal) || player.mob != body)
		return
	if(body.get_active_held_item() && prob(50))
		press_key(player, "swap_hands_row")
	click_atom(player, goal)
	note_window(player)
	note(player, body.get_active_held_item() ? "use held on" : "use", goal)

/datum/sim_player/proc/pick_goal(mob/living/body)
	var/list/candidates = list()
	for(var/atom/movable/thing in oview(SIM_GOAL_RANGE, body))
		if(thing.invisibility > body.see_invisible || thing.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
			continue
		if(ismachinery(thing) || isstructure(thing) || isitem(thing) || isliving(thing))
			candidates += thing
	return length(candidates) ? pick(candidates) : null

/datum/sim_player/proc/walk_randomly(client/player, mob/body)
	var/direction = pick(GLOB.cardinals)
	for(var/i in 1 to SIM_WALK_STEPS)
		if(QDELETED(body) || player.mob != body)
			return
		if(step_as_player(player, body, direction))
			counts["step"]++
		else
			direction = pick(GLOB.cardinals)

/// One movement key press, through the client like the keyLoop does, waiting out the move delay.
/datum/sim_player/proc/step_as_player(client/player, mob/body, direction)
	var/wait = player.move_delay - world.time
	if(wait > 0)
		sleep(wait)
	if(QDELETED(player) || player.mob != body)
		return FALSE
	var/turf/start = get_turf(body)
	player.Move(get_step(body, direction), direction)
	return get_turf(body) != start

GLOBAL_LIST_INIT(sim_player_lines, list(
	"大家好！",
	"有人在吗？",
	"医疗部怎么走？",
	"我是新来的，有什么要帮忙的吗？",
	"这个机器怎么用？",
	"; 工程部，这里的门好像坏了。",
	"; 安保，有人在走廊里乱跑。",
	"Hello?",
))

#undef SIM_PLAYERS_PARAM
#undef SIM_THINK_MIN
#undef SIM_THINK_MAX
#undef SIM_UI_HOLD
#undef SIM_BUSY_TIMEOUT
#undef SIM_GHOST_AFTER
#undef SIM_GONE_TIMEOUT
#undef SIM_WALK_STEPS
#undef SIM_GOAL_RANGE
#undef SIM_TOUR_RANGE
#undef SIM_TOUR_SAMPLES
#undef SIM_STEP_RETRIES
#undef SIM_ACCESS_PARAM
