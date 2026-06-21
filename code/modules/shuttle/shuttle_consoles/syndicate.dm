#define SYNDICATE_CHALLENGE_TIMER (20 MINUTES)

/obj/machinery/computer/shuttle/syndicate
	name = "辛迪加穿梭机终端"
	desc = "用于控制辛迪加运输穿梭机的终端。"
	circuit = /obj/item/circuitboard/computer/syndicate_shuttle
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "syndicate"
	possible_destinations = "syndicate_away;syndicate_z5;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s;syndicate_custom"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/machinery/computer/shuttle/syndicate/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tool_blocker, TOOL_SCREWDRIVER, TOOL_ACT_PRIMARY)

/obj/machinery/computer/shuttle/syndicate/launch_check(mob/user)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/circuitboard/computer/syndicate_shuttle/board = circuit
	if(board?.challenge_start_time && world.time < board.challenge_start_time + SYNDICATE_CHALLENGE_TIMER)
		to_chat(user, span_warning("您已向空间站发出了战斗挑战！您必须至少再给他们[DisplayTimeText(board.challenge_start_time + SYNDICATE_CHALLENGE_TIMER - world.time)]的时间来准备。"))
		return FALSE
	board.moved = TRUE
	return TRUE

/obj/machinery/computer/shuttle/syndicate/recall
	name = "辛迪加穿梭机召回终端"
	desc = "如果你的朋友把你落下了，就用这个。"
	possible_destinations = "syndicate_away"

/obj/machinery/computer/shuttle/syndicate/drop_pod
	name = "辛迪加突击舱控制台"
	desc = "控制空投舱的发射系统。"
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "pod_off"
	icon_keyboard = null
	icon_screen = "pod_on"
	light_color = LIGHT_COLOR_BLUE
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "steel_rain"
	possible_destinations = null

/obj/machinery/computer/shuttle/syndicate/drop_pod/launch_check(mob/user)
	. = ..()
	if(!.)
		return FALSE
	if(!is_reserved_level(z))
		to_chat(user, span_warning("空投舱是单程的！"))
		return FALSE
	return TRUE

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate
	name = "辛迪加穿梭机导航计算机"
	desc = "用于为辛迪加穿梭机指定精确的传送位置。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	shuttleId = "syndicate"
	lock_override = CAMERA_LOCK_STATION
	shuttlePortId = "syndicate_custom"
	jump_to_ports = list("syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)
	view_range = 5.5
	x_offset = 7 //flip both offsets because the shuttle is mapped in facing SOUTH, not NORTH; the docking port is also rotated
	y_offset = 1
	whitelist_turfs = list(/turf/open/space, /turf/open/floor/plating, /turf/open/lava, /turf/closed/mineral, /turf/open/openspace, /turf/open/misc)
	see_hidden = TRUE
	circuit = /obj/item/circuitboard/computer/syndicate_shuttle_docker

#undef SYNDICATE_CHALLENGE_TIMER
