/proc/ivanov_target_atom(list/input)
	return locate(input["target"] || input["ref"])

/datum/world_topic/click
	keyword = "click"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/click/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/atom/target = ivanov_target_atom(input)
	if(!istype(target))
		return list("ok" = FALSE, "error" = "bad target")

	user.ClickOn(target, input["params"] || "")
	return list("ok" = TRUE, "target" = ivanov_atom_data(target))

/datum/world_topic/right_click
	keyword = "right_click"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/right_click/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	var/atom/target = ivanov_target_atom(input)
	if(!user || !istype(target))
		return list("ok" = FALSE, "error" = "bad auth or target")

	user.ClickOn(target, input["params"] || "right=1")
	return list("ok" = TRUE, "target" = ivanov_atom_data(target))

/datum/world_topic/alt_click
	keyword = "alt_click"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/alt_click/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	var/atom/target = ivanov_target_atom(input)
	if(!user || !istype(target))
		return list("ok" = FALSE, "error" = "bad auth or target")

	user.AltClickOn(target)
	return list("ok" = TRUE, "target" = ivanov_atom_data(target))

/datum/world_topic/ctrl_click
	keyword = "ctrl_click"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/ctrl_click/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	var/atom/target = ivanov_target_atom(input)
	if(!user || !istype(target))
		return list("ok" = FALSE, "error" = "bad auth or target")

	user.CtrlClickOn(target)
	return list("ok" = TRUE, "target" = ivanov_atom_data(target))

/datum/world_topic/shift_click
	keyword = "shift_click"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/shift_click/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	var/atom/target = ivanov_target_atom(input)
	if(!user || !istype(target))
		return list("ok" = FALSE, "error" = "bad auth or target")

	user.ShiftClickOn(target)
	return list("ok" = TRUE, "target" = ivanov_atom_data(target))

/datum/world_topic/middle_click
	keyword = "middle_click"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/middle_click/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	var/atom/target = ivanov_target_atom(input)
	if(!user || !istype(target))
		return list("ok" = FALSE, "error" = "bad auth or target")

	user.MiddleClickOn(target, input["params"] || "")
	return list("ok" = TRUE, "target" = ivanov_atom_data(target))

// Disabled for now: mouse_drop_dragged() and mouse_drop_receive() are protected procs.
