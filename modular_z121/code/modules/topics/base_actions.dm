/proc/ivanov_parse_dir(value)
	var/text = lowertext("[value]")
	switch(text)
		if("north", "n")
			return NORTH
		if("south", "s")
			return SOUTH
		if("east", "e")
			return EAST
		if("west", "w")
			return WEST
		if("northeast", "north_east", "ne")
			return NORTH|EAST
		if("northwest", "north_west", "nw")
			return NORTH|WEST
		if("southeast", "south_east", "se")
			return SOUTH|EAST
		if("southwest", "south_west", "sw")
			return SOUTH|WEST

	var/direct = text2num(text)
	return (direct in GLOB.alldirs) ? direct : NONE

/proc/ivanov_position(atom/movable/movable)
	return list(
		"x" = movable.x,
		"y" = movable.y,
		"z" = movable.z,
	)

/datum/world_topic/step
	keyword = "step"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/step/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user?.client)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/direct = ivanov_parse_dir(input["dir"] || input["direction"])
	if(!direct)
		return list("ok" = FALSE, "error" = "bad dir")

	var/turf/target = get_step(user, direct)
	if(!target)
		return list("ok" = FALSE, "error" = "bad target")

	var/moved = user.client.Move(target, direct)
	return list("ok" = !!moved, "moved" = !!moved, "position" = ivanov_position(user))

/datum/world_topic/step_to
	keyword = "step_to"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/step_to/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/turf/origin = get_turf(user)
	if(!origin)
		return list("ok" = FALSE, "error" = "no origin")

	var/dx = round(clamp(text2num(input["dx"]) || 0, -30, 30))
	var/dy = round(clamp(text2num(input["dy"]) || 0, -30, 30))
	var/turf/target = locate(origin.x + dx, origin.y + dy, origin.z)
	if(!target)
		return list("ok" = FALSE, "error" = "bad target")

	var/steps = max(abs(dx), abs(dy))
	var/delay = clamp(text2num(input["delay"]) || user.cached_multiplicative_slowdown || world.tick_lag, world.tick_lag, 10 SECONDS)
	var/timeout = clamp(text2num(input["timeout"]) || (steps * delay + 1 SECONDS), 1 SECONDS, 30 SECONDS)
	var/datum/move_loop/loop = GLOB.move_manager.move_to(user, target, 0, delay, timeout)
	return list("ok" = !!loop, "target" = ivanov_position(target), "position" = ivanov_position(user))

/datum/world_topic/swap_hand
	keyword = "swap_hand"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/swap_hand/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	return list("ok" = user.swap_hand(text2num(input["hand"])))

/datum/world_topic/use_hand
	keyword = "use_hand"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/use_hand/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	user.activate_hand(input["hand"])
	return list("ok" = TRUE)

/datum/world_topic/resist
	keyword = "resist"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/resist/Run(list/input)
	var/mob/living/user = ivanov_topic_mob(input)
	if(!istype(user))
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	user.resist()
	return list("ok" = TRUE)

/datum/world_topic/set_rest
	keyword = "set_rest"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/set_rest/Run(list/input)
	var/mob/living/user = ivanov_topic_mob(input)
	if(!istype(user))
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/value_text = lowertext("[input["value"] || input["rest"]]")
	if(value_text in list("toggle", ""))
		user.toggle_resting()
	else
		user.set_resting(value_text in list("1", "true", "yes", "on"), silent = FALSE)
	return list("ok" = TRUE, "resting" = user.resting)

/datum/world_topic/set_intent
	keyword = "set_intent"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/set_intent/Run(list/input)
	return list("ok" = FALSE, "error" = "four-intent mode is not implemented; use set_combat_mode")

/datum/world_topic/set_body_zone
	keyword = "set_body_zone"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/set_body_zone/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/zone = input["zone"]
	if(!(zone in (GLOB.all_body_zones + GLOB.all_precise_body_zones)))
		return list("ok" = FALSE, "error" = "bad zone")

	user.zone_selected = zone
	SEND_SIGNAL(user, COMSIG_MOB_SELECTED_ZONE_SET, zone)
	return list("ok" = TRUE, "zone" = user.zone_selected)

/datum/world_topic/set_throw
	keyword = "set_throw"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/set_throw/Run(list/input)
	var/mob/living/user = ivanov_topic_mob(input)
	if(!istype(user))
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/value_text = lowertext("[input["value"] || input["throw"]]")
	if(value_text in list("toggle", ""))
		user.toggle_throw_mode()
	else if(value_text in list("1", "true", "yes", "on"))
		user.throw_mode_on(THROW_MODE_TOGGLE)
	else
		user.throw_mode_off(THROW_MODE_TOGGLE)
	return list("ok" = TRUE, "throw_mode" = user.throw_mode)

/datum/world_topic/give_item
	keyword = "give_item"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/give_item/Run(list/input)
	var/mob/living/user = ivanov_topic_mob(input)
	if(!istype(user))
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/mob/living/target = locate(input["target"] || input["ref"])
	user.give(target)
	return list("ok" = TRUE)
