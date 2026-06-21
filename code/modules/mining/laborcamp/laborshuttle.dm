/obj/machinery/computer/shuttle/labor
	name = "劳工穿梭机控制台"
	desc = "用来呼叫和发送劳工穿梭机。"
	circuit = /obj/item/circuitboard/computer/labor_shuttle
	shuttleId = "laborcamp"
	possible_destinations = "laborcamp_home;laborcamp_away"
	req_access = list(ACCESS_BRIG)

/obj/machinery/computer/shuttle/labor/one_way
	name = "囚犯穿梭机控制台"
	desc = "一个单向穿梭控制台，用于将穿梭机召唤至劳改营。"
	possible_destinations = "laborcamp_away"
	circuit = /obj/item/circuitboard/computer/labor_shuttle/one_way
	req_access = list( )

/obj/machinery/computer/shuttle/labor/one_way/launch_check(mob/user)
	. = ..()
	if(!.)
		return FALSE
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle("laborcamp")
	if(!M)
		to_chat(user, span_warning("无法定位穿梭机！"))
		return FALSE
	var/obj/docking_port/stationary/S = M.get_docked()
	if(S?.name == "laborcamp_away")
		to_chat(user, span_warning("穿梭机已在前哨站！"))
		return FALSE
	return TRUE

/obj/docking_port/stationary/laborcamp_home
	name = "SS13：劳工穿梭机对接站"
	shuttle_id = "laborcamp_home"
	roundstart_template = /datum/map_template/shuttle/labour/delta
	width = 9
	dwidth = 2
	height = 5

/obj/docking_port/stationary/laborcamp_home/kilo
	roundstart_template = /datum/map_template/shuttle/labour/kilo

/obj/docking_port/stationary/laborcamp_home/nebula
	roundstart_template = /datum/map_template/shuttle/labour/nebula
