/obj/machinery/computer/shuttle/ferry
	name = "运输渡轮控制台"
	desc = "控制运输渡轮的操控台。"
	circuit = /obj/item/circuitboard/computer/ferry
	shuttleId = "ferry"
	possible_destinations = "ferry_home;ferry_away;ferry_ntf" //NOVA EDIT CHANGE
	req_access = list(ACCESS_CENT_GENERAL)
	var/allow_silicons = FALSE
	var/allow_emag = FALSE

/obj/machinery/computer/shuttle/ferry/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(!allow_emag)
		balloon_alert(user, "防火墙过于强大！")
		return FALSE
	return ..()

/obj/machinery/computer/shuttle/ferry/attack_ai()
	return allow_silicons ? ..() : FALSE

/obj/machinery/computer/shuttle/ferry/attack_robot()
	return allow_silicons ? ..() : FALSE

/obj/machinery/computer/shuttle/ferry/request
	name = "渡轮操控台"
	circuit = /obj/item/circuitboard/computer/ferry/request
	possible_destinations = "ferry_home;ferry_away;ferry_ntf" //NOVA EDIT CHANGE
	req_access = list(ACCESS_CENT_GENERAL)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
