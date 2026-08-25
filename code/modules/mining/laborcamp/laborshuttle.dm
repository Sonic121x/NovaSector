// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/computer/shuttle/labor
	name = "labor shuttle console"
	desc = "Used to call and send the labor camp shuttle."
	circuit = /obj/item/circuitboard/computer/labor_shuttle
	shuttleId = "laborcamp"
	possible_destinations = "laborcamp_home;laborcamp_away"
	req_access = list(ACCESS_BRIG)

/obj/machinery/computer/shuttle/labor/one_way
	name = "prisoner shuttle console"
	desc = "A one-way shuttle console, used to summon the shuttle to the labor camp."
	possible_destinations = "laborcamp_away"
	circuit = /obj/item/circuitboard/computer/labor_shuttle/one_way
	req_access = list( )

/obj/machinery/computer/shuttle/labor/one_way/launch_check(mob/user)
	. = ..()
	if(!.)
		return FALSE
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle("laborcamp")
	if(!M)
		to_chat(user, span_warning(LANG("obj.0578f885e7c60042", null)))
		return FALSE
	var/obj/docking_port/stationary/S = M.get_docked()
	if(S?.name == "laborcamp_away")
		to_chat(user, span_warning(LANG("obj.93f0437ca9475889", null)))
		return FALSE
	return TRUE

/obj/docking_port/stationary/laborcamp_home
	name = "SS13: Labor Shuttle Dock"
	shuttle_id = "laborcamp_home"
	roundstart_template = /datum/map_template/shuttle/labour/delta
	width = 9
	dwidth = 2
	height = 5

/obj/docking_port/stationary/laborcamp_home/kilo
	roundstart_template = /datum/map_template/shuttle/labour/kilo

/obj/docking_port/stationary/laborcamp_home/nebula
	roundstart_template = /datum/map_template/shuttle/labour/nebula
