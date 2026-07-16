/proc/ivanov_atom_data(atom/target, mob/user)
	if(!istype(target))
		return null
	var/list/data = list(
		"ref" = REF(target),
		"name" = target.name,
		"type" = "[target.type]",
		"x" = target.x,
		"y" = target.y,
		"z" = target.z,
	)
	if(user)
		data["distance"] = get_dist(user, target)
	return data

/proc/ivanov_item_data(obj/item/item, mob/user)
	return ivanov_atom_data(item, user)

/proc/ivanov_visible_range(value)
	var/scan_range = text2num(value)
	if(isnull(scan_range))
		scan_range = 1
	return clamp(scan_range, 0, 5)

/datum/world_topic/visible_items
	keyword = "visible_items"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/visible_items/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/scan_range = ivanov_visible_range(input["range"])
	var/list/items = list()
	for(var/obj/item/item in view(scan_range, user))
		items += list(ivanov_item_data(item, user))

	return list("ok" = TRUE, "range" = scan_range, "items" = items)

/datum/world_topic/visible_atoms
	keyword = "visible_atoms"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/visible_atoms/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/scan_range = ivanov_visible_range(input["range"])
	var/list/atoms = list()
	for(var/atom/target in view(scan_range, user))
		if(target == user)
			continue
		atoms += list(ivanov_atom_data(target, user))

	return list("ok" = TRUE, "range" = scan_range, "atoms" = atoms)

/datum/world_topic/examine
	keyword = "examine"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/examine/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/atom/target = locate(input["target"] || input["ref"])
	if(!istype(target) || !(target in view(7, user)))
		return list("ok" = FALSE, "error" = "target not visible")

	var/list/examine_lines = target.examine(user)
	return list(
		"ok" = TRUE,
		"target" = ivanov_atom_data(target),
		"examine" = islist(examine_lines) ? jointext(examine_lines, "\n") : "[examine_lines]",
	)

/datum/world_topic/list_actions
	keyword = "list_actions"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/list_actions/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/list/actions = list()
	for(var/datum/action/action as anything in user.actions)
		actions += list(list(
			"ref" = REF(action),
			"name" = action.name,
			"desc" = action.desc,
			"type" = "[action.type]",
			"available" = action.IsAvailable(FALSE),
		))

	return list("ok" = TRUE, "actions" = actions)

/proc/ivanov_find_action(mob/user, list/input)
	var/action_ref = input["action"] || input["ref"]
	var/action_name = input["name"]
	var/action_type_text = input["type"]
	var/action_type = action_type_text ? text2path("[action_type_text]") : null
	var/datum/action/ref_action = action_ref ? locate(action_ref) : null
	if(ref_action in user.actions)
		return ref_action

	for(var/datum/action/action as anything in user.actions)
		if(action_type && action.type == action_type)
			return action
		if(action_type_text && "[action.type]" == "[action_type_text]")
			return action
		if(action_name && lowertext(action.name) == lowertext("[action_name]"))
			return action
	return null

/datum/world_topic/use_action
	keyword = "use_action"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/use_action/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/datum/action/action = ivanov_find_action(user, input)
	if(!action)
		return list("ok" = FALSE, "error" = "action not found")

	var/trigger_flags = text2num(input["trigger_flags"]) || NONE
	return list("ok" = !!action.Trigger(user, trigger_flags = trigger_flags), "ref" = REF(action), "name" = action.name)

/proc/ivanov_slot_from_text(value)
	var/text = lowertext("[value]")
	switch(text)
		if("back", "backpack")
			return ITEM_SLOT_BACK
		if("belt")
			return ITEM_SLOT_BELT
		if("left_pocket", "lpocket", "l_pocket")
			return ITEM_SLOT_LPOCKET
		if("right_pocket", "rpocket", "r_pocket")
			return ITEM_SLOT_RPOCKET
		if("jumpsuit", "uniform", "iclothing")
			return ITEM_SLOT_ICLOTHING
		if("suit", "exosuit", "oclothing")
			return ITEM_SLOT_OCLOTHING
		if("suit_storage", "suitstore")
			return ITEM_SLOT_SUITSTORE
		if("id")
			return ITEM_SLOT_ID
		if("mask")
			return ITEM_SLOT_MASK
		if("head", "hat")
			return ITEM_SLOT_HEAD
		if("shoes", "feet")
			return ITEM_SLOT_FEET
		if("gloves")
			return ITEM_SLOT_GLOVES
		if("ears")
			return ITEM_SLOT_EARS
		if("eyes", "glasses")
			return ITEM_SLOT_EYES
		if("neck")
			return ITEM_SLOT_NECK
	return text2num(text)

/proc/ivanov_slot_name(slot)
	switch(slot)
		if(ITEM_SLOT_BACK)
			return "back"
		if(ITEM_SLOT_BELT)
			return "belt"
		if(ITEM_SLOT_LPOCKET)
			return "left_pocket"
		if(ITEM_SLOT_RPOCKET)
			return "right_pocket"
		if(ITEM_SLOT_ICLOTHING)
			return "jumpsuit"
		if(ITEM_SLOT_OCLOTHING)
			return "suit"
		if(ITEM_SLOT_SUITSTORE)
			return "suit_storage"
		if(ITEM_SLOT_ID)
			return "id"
		if(ITEM_SLOT_MASK)
			return "mask"
		if(ITEM_SLOT_HEAD)
			return "head"
		if(ITEM_SLOT_FEET)
			return "feet"
		if(ITEM_SLOT_GLOVES)
			return "gloves"
		if(ITEM_SLOT_EARS)
			return "ears"
		if(ITEM_SLOT_EYES)
			return "eyes"
		if(ITEM_SLOT_NECK)
			return "neck"
	return "[slot]"

/datum/world_topic/list_inventory
	keyword = "list_inventory"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/list_inventory/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/list/hands = list()
	for(var/i in 1 to length(user.held_items))
		var/obj/item/held = user.get_item_for_held_index(i)
		hands += list(list(
			"index" = i,
			"active" = i == user.active_hand_index,
			"item" = held ? ivanov_item_data(held, user) : null,
		))

	var/list/slots = list()
	for(var/slot in list(ITEM_SLOT_BACK, ITEM_SLOT_BELT, ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET, ITEM_SLOT_ICLOTHING, ITEM_SLOT_OCLOTHING, ITEM_SLOT_SUITSTORE, ITEM_SLOT_ID, ITEM_SLOT_MASK, ITEM_SLOT_HEAD, ITEM_SLOT_FEET, ITEM_SLOT_GLOVES, ITEM_SLOT_EARS, ITEM_SLOT_EYES, ITEM_SLOT_NECK))
		var/obj/item/item = user.get_item_by_slot(slot)
		slots += list(list(
			"slot" = ivanov_slot_name(slot),
			"slot_id" = slot,
			"item" = item ? ivanov_item_data(item, user) : null,
		))

	return list("ok" = TRUE, "hands" = hands, "slots" = slots)

/datum/world_topic/list_storage
	keyword = "list_storage"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/list_storage/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")
	if(!user.active_storage)
		return list("ok" = TRUE, "items" = list())

	var/list/items = list()
	for(var/obj/item/item as anything in user.active_storage.return_inv(FALSE))
		items += list(ivanov_item_data(item, user))

	return list("ok" = TRUE, "items" = items)
