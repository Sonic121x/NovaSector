/datum/world_topic/equip
	keyword = "equip"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/equip/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/slot = ivanov_slot_from_text(input["slot"])
	if(!slot)
		return list("ok" = FALSE, "error" = "bad slot")

	var/obj/item/item = locate(input["item"] || input["ref"])
	if(!item)
		item = user.get_active_held_item()
	if(!istype(item))
		return list("ok" = FALSE, "error" = "bad item")

	return list("ok" = !!user.equip_to_slot_if_possible(item, slot), "slot" = ivanov_slot_name(slot))

/datum/world_topic/say
	keyword = "say"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/say/Run(list/input)
	var/mob/user = ivanov_topic_mob(input)
	if(!user)
		return list("ok" = FALSE, "error" = "bad auth or client not found")

	var/message = copytext_char("[input["text"] || input["message"]]", 1, MAX_MESSAGE_LEN)
	if(!length(message))
		return list("ok" = FALSE, "error" = "empty text")

	user.say(message, forced = "agent topic")
	return list("ok" = TRUE)

/datum/world_topic/point
	keyword = "point"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/point/Run(list/input)
	var/mob/living/user = ivanov_topic_mob(input)
	var/atom/target = locate(input["target"] || input["ref"])
	if(!istype(user) || !istype(target))
		return list("ok" = FALSE, "error" = "bad auth or target")

	return list("ok" = !!user.pointed(target), "target" = ivanov_atom_data(target))
