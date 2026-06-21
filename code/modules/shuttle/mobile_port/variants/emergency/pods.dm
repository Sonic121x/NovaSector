// THIS FILE CONTAINS: Pod mobile/stationary docking port, pod control console, pod storage and pod items

/obj/docking_port/mobile/pod
	name = "逃生舱"
	shuttle_id = "pod"
	launch_status = UNLAUNCHED

/obj/docking_port/mobile/pod/request(obj/docking_port/stationary/S)
	var/obj/machinery/computer/shuttle/connected_computer = get_control_console()
	if(!istype(connected_computer, /obj/machinery/computer/shuttle/pod))
		return FALSE
	if(!(SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED) && !(connected_computer.obj_flags & EMAGGED))
		to_chat(usr, span_warning("逃生舱仅在“红色代码”安保警报期间发射。"))
		return FALSE
	if(launch_status == UNLAUNCHED)
		launch_status = EARLY_LAUNCHED
		return ..()

/obj/docking_port/mobile/pod/cancel()
	return

/obj/machinery/computer/shuttle/pod
	name = "舱体控制电脑"
	locked = TRUE
	possible_destinations = "pod_asteroid"
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "pod_off"
	circuit = /obj/item/circuitboard/computer/emergency_pod
	light_color = LIGHT_COLOR_BLUE
	density = FALSE
	icon_keyboard = null
	icon_screen = "pod_on"

/obj/machinery/computer/shuttle/pod/Initialize(mapload)
	. = ..()
	RegisterSignal(SSsecurity_level, COMSIG_SECURITY_LEVEL_CHANGED, PROC_REF(check_lock))

/obj/machinery/computer/shuttle/pod/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	locked = FALSE
	balloon_alert(user, "警报等级检查已禁用")
	icon_screen = "emagged_general"
	update_appearance()
	return TRUE

/obj/machinery/computer/shuttle/pod/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	if(port)
		//Checks if the computer has already added the shuttle destination with the initial id
		//This has to be done because connect_to_shuttle is called again after its ID is updated
		//due to conflicting id names
		var/base_shuttle_destination = ";[initial(port.shuttle_id)]_lavaland"
		var/shuttle_destination = ";[port.shuttle_id]_lavaland"

		var/position = findtext(possible_destinations, base_shuttle_destination)
		if(position)
			if(base_shuttle_destination == shuttle_destination)
				return
			possible_destinations = splicetext(possible_destinations, position, position + length(base_shuttle_destination), shuttle_destination)
			return

		possible_destinations += shuttle_destination

/**
 * Signal handler for checking if we should lock or unlock escape pods accordingly to a newly set security level
 *
 * Arguments:
 * * source The datum source of the signal
 * * new_level The new security level that is in effect
 */
/obj/machinery/computer/shuttle/pod/proc/check_lock(datum/source, new_level)
	SIGNAL_HANDLER

	if(obj_flags & EMAGGED)
		return
	locked = (new_level < SEC_LEVEL_RED)

/obj/docking_port/stationary/random
	name = "逃生舱"
	shuttle_id = "pod"
	hidden = TRUE
	override_can_dock_checks = TRUE
	/// The area the pod tries to land at
	var/target_area = /area/lavaland/surface/outdoors
	/// Minimal distance from the map edge, setting this too low can result in shuttle landing on the edge and getting "sliced"
	var/edge_distance = 16

/obj/docking_port/stationary/random/Initialize(mapload)
	. = ..()
	if(!mapload)
		return

	var/list/turfs = get_area_turfs(target_area)
	var/original_len = turfs.len
	while(turfs.len)
		var/turf/picked_turf = pick(turfs)
		if(picked_turf.x<edge_distance || picked_turf.y<edge_distance || (world.maxx+1-picked_turf.x)<edge_distance || (world.maxy+1-picked_turf.y)<edge_distance)
			turfs -= picked_turf
		else
			forceMove(picked_turf)
			return

	// Fallback: couldn't find anything
	WARNING("docking port '[shuttle_id]' could not be randomly placed in [target_area]: of [original_len] turfs, none were suitable")
	return INITIALIZE_HINT_QDEL

/obj/docking_port/stationary/random/icemoon
	target_area = /area/icemoon/surface/outdoors/unexplored/rivers/no_monsters

//Pod suits/pickaxes


/obj/item/clothing/head/helmet/space/orange
	name = "紧急太空头盔"
	icon_state = "syndicate-helm-orange"
	inhand_icon_state = "syndicate-helm-orange"

/obj/item/clothing/suit/space/orange
	name = "紧急太空服"
	icon_state = "syndicate-orange"
	inhand_icon_state = "syndicate-orange"
	slowdown = 3

/obj/item/pickaxe/emergency
	name = "紧急离舱工具"
	desc = "用于在紧急着陆后脱困。"

/obj/item/storage/pod
	name = "紧急太空服"
	desc = "一个装有太空服的壁挂式保险箱。仅在紧急情况下打开。"
	anchored = TRUE
	density = FALSE
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "wall_safe_locked"
	storage_type = /datum/storage/pod

/obj/item/storage/pod/update_icon_state()
	. = ..()
	icon_state = "wall_safe[atom_storage?.locked ? "_locked" : ""]"

/obj/item/storage/pod/create_storage(max_slots, max_specific_storage, max_total_storage, list/canhold, list/canthold, storage_type)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)

MAPPING_DIRECTIONAL_HELPERS(/obj/item/storage/pod, 32)

/obj/item/storage/pod/PopulateContents()
	new /obj/item/clothing/head/helmet/space/orange(src)
	new /obj/item/clothing/head/helmet/space/orange(src)
	new /obj/item/clothing/suit/space/orange(src)
	new /obj/item/clothing/suit/space/orange(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/pickaxe/emergency(src)
	new /obj/item/pickaxe/emergency(src)
	new /obj/item/survivalcapsule(src)
	new /obj/item/storage/toolbox/emergency(src)
	new /obj/item/bodybag/environmental(src)
	new /obj/item/bodybag/environmental(src)
