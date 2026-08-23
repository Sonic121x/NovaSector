/// A simple one-use beacon to activate a two-way portal to the anchored receiver it's linked to.
/obj/item/permanent_portal_creator
	name = "two-way bluespace entanglement device"
	desc = "A device with a very complex name, that is only used to confirm the second location that's tied to a stationary entanglement anchor."
	icon = 'icons/obj/devices/tracker.dmi'
	icon_state = "hand_tele"
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	armor_type = /datum/armor/item_permanent_portal_creator
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	/// The weakref to the linked entanglement anchor.
	var/datum/weakref/linked_anchor = null
	/// The name of the portal created at the position of the device.
	var/beacon_portal_name = "portal to somewhere"
	/// The name of the portal created at the position of the anchor.
	var/anchor_portal_name = "exit from somewhere"


/datum/armor/item_permanent_portal_creator
	bomb = 30
	fire = 100
	acid = 100

/obj/item/permanent_portal_creator/attack_self(mob/user, modifiers)
	if(!linked_anchor)
		balloon_alert(user, LANG("obj.59204d3b7513ec6b", null))
		return

	if(!isweakref(linked_anchor))
		balloon_alert(user, LANG("obj.68287953524ee291", null))
		return

	var/obj/item/permanent_portal_anchor/portal_anchor = linked_anchor.resolve()

	if(!istype(portal_anchor) || !get_turf(portal_anchor))
		balloon_alert(user, LANG("obj.68287953524ee291", null))
		return

	if(tgui_alert(user, LANG("obj.b1598ee9afdde8af", null), LANG("obj.773441628de640b4", null), list("Yes", "No")) != "Yes")
		return

	balloon_alert(user, LANG("obj.8b733ed3ee432e83", null))

	if(!do_after(user, 5 SECONDS))
		balloon_alert(user, LANG("obj.c7faa60a8a84796b", null))
		return

	var/list/obj/effect/portal/created_portals = create_portal_pair(get_turf(src), get_turf(portal_anchor), _lifespan = NONE)
	created_portals[1].name = beacon_portal_name
	created_portals[2].name = anchor_portal_name

	created_portals[1].balloon_alert(user, LANG("obj.74814878a528c6e6", null))

	qdel(portal_anchor)
	qdel(src)


/obj/item/permanent_portal_creator/space_hotel
	name = "\improper Twin Nexus two-way bluespace entanglement device"
	beacon_portal_name = "portal to the Twin Nexus"
	anchor_portal_name = "exit of the Twin Nexus"


/obj/item/permanent_portal_creator/space_hotel/examine(mob/user)
	. = ..()
	. += LANG("obj.d17d2f6269ec02f7", null)


/obj/item/permanent_portal_anchor
	name = "two-way bluespace entanglement anchor"
	desc = "A device with a very complex name, that serves as the stationary target of a linked two-way bluespace entanglement device."
	icon = 'icons/obj/devices/tracker.dmi'
	icon_state = "beacon"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	anchored = FALSE
	density = FALSE
	layer = BELOW_MOB_LAYER
	/// Does it automatically deploy when initialized?
	var/deploy_on_init = FALSE


/obj/item/permanent_portal_anchor/Initialize(mapload)
	. = ..()
	if(deploy_on_init)
		deploy()


/obj/item/permanent_portal_anchor/attack_self(mob/user, modifiers)
	if(!ishuman(user))
		return

	balloon_alert(user, LANG("obj.617d0336aeeefc63", null))

	if(!do_after(user, 5 SECONDS))
		balloon_alert(user, LANG("obj.38267bbe63733817", null))
		return

	deploy(user)

	playsound(src, 'modular_nova/modules/aesthetics/airlock/sound/bolts_down.ogg', 50, FALSE)

	balloon_alert(user, LANG("obj.867efa5cb751c4d5", null))


/// Simple helper proc to deploy the anchor, with mob/user as an optional argument to make them drop it if they're holding it.
/obj/item/permanent_portal_anchor/proc/deploy(mob/user = null)
	if(user)
		user.dropItemToGround(src, force = TRUE, silent = TRUE)

	set_anchored(TRUE)

	// Just to make it look a little nicer.
	pixel_x = 0
	pixel_y = -10


/obj/item/permanent_portal_anchor/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/permanent_portal_creator))
		return ..()

	if(!anchored)
		balloon_alert(user, LANG("obj.84ecf3259f57f237", null))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/permanent_portal_creator/portal_maker = tool
	portal_maker.linked_anchor = WEAKREF(src)

	balloon_alert(user, LANG("obj.0fdcdc618fb93c36", null))
	return ITEM_INTERACT_SUCCESS


/obj/item/permanent_portal_anchor/space_hotel
	name = "\improper Twin Nexus two-way bluespace entanglement anchor"
	desc = "A device with a very complex name, that serves as the stationary target of a linked two-way bluespace entanglement device.\n\nIn your case, it serves to let your guests out."


//Space Hotel Keycards and Room Doors
/obj/item/key_card/hotel_room
	name = "\improper Twin Nexus keycard"
	desc = "A keycard, to open a keycard-locked hotel room."
	access_id = "guest_room_"
	/// The number of the room, so that it gets automatically handled by the code everywhere
	/// it's relevant.
	var/room_number = null


/obj/item/key_card/hotel_room/Initialize(mapload)
	. = ..()

	if(!room_number)
		return

	access_id += "[room_number]"


/obj/item/key_card/hotel_room/examine(mob/user)
	. = ..()

	if(!room_number)
		return

	. += LANG("obj.3a0a249126f74c47", list(room_number))


/obj/item/key_card/hotel_room/master
	name = "\improper Twin Nexus master keycard"
	desc = "A master keycard, to open all the keycard-locked hotel rooms.\nIt has an engraving on it that reads: \"Master Access\""
	access_id = null
	master_access = TRUE

/obj/effect/mapping_helpers/airlock/access/all/twin_nexus_staff/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_TWIN_NEXUS_STAFF
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/twin_nexus_staff/manager/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_TWIN_NEXUS_MANAGER
	return access_list

/obj/machinery/door/airlock/keyed/hotel_room
	name = "Guest Room"
	access_id = "guest_room_"
	autoclose = TRUE
	greyscale_accent_color = null
	/// The number of the room, so that it gets automatically handled by the code everywhere
	/// it's relevant.
	var/room_number = null
	var/alternate = FALSE


/obj/machinery/door/airlock/keyed/hotel_room/Initialize(mapload)
	. = ..()

	if(!room_number)
		return

	name += " [room_number]"
	access_id += "[room_number]"
	fill_state_suffix = "_[room_number]"

	update_appearance()


/obj/item/key_card/hotel_room/one
	color = "#E0E000"
	room_number = 1

/obj/machinery/door/airlock/keyed/hotel_room/one
	greyscale_accent_color = "#E0E000"
	room_number = 1


/obj/item/key_card/hotel_room/two
	color = "#C4004E"
	room_number = 2

/obj/machinery/door/airlock/keyed/hotel_room/two
	greyscale_accent_color = "#C4004E"
	room_number = 2


/obj/item/key_card/hotel_room/three
	color = "#00C074"
	room_number = 3

/obj/machinery/door/airlock/keyed/hotel_room/three
	greyscale_accent_color = "#00C074"
	room_number = 3


/obj/item/key_card/hotel_room/four
	color = "#2CAF2C"
	room_number = 4

/obj/machinery/door/airlock/keyed/hotel_room/four
	greyscale_accent_color = "#2CAF2C"
	room_number = 4


/obj/item/key_card/hotel_room/five
	color = "#E55C01"
	room_number = 5

/obj/machinery/door/airlock/keyed/hotel_room/five
	greyscale_accent_color = "#E55C01"
	room_number = 5


/obj/item/key_card/hotel_room/six
	color = "#AC00AC"
	room_number = 6

/obj/machinery/door/airlock/keyed/hotel_room/six
	greyscale_accent_color = "#AC00AC"
	room_number = 6


/obj/item/key_card/hotel_room/seven
	color = "#0AA7E9"
	room_number = 7

/obj/machinery/door/airlock/keyed/hotel_room/seven
	greyscale_accent_color = "#0AA7E9"
	room_number = 7

/area/ruin/space/has_grav/hotel
	ambience_index = AMBIENCE_GENERIC
