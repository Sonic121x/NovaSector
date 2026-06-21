/datum/action/item_action/vortex_recall
	name = "涡流召回"
	desc = "随时将你自己及附近人员召回至已调谐的圣像信标处。<br>若信标仍处于附着状态，则会将其分离。"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "vortex_recall"

/datum/action/item_action/vortex_recall/IsAvailable(feedback = FALSE)
	if(!istype(target, /obj/item/hierophant_club))
		return
	var/obj/item/hierophant_club/teleport_stick = target
	if(teleport_stick.teleporting)
		return FALSE
	if(teleport_stick.beacon && !check_teleport_valid(owner, get_turf(teleport_stick.beacon), TELEPORT_CHANNEL_FREE))
		return FALSE
	return ..()
