/datum/round_event_control/communications_blackout
	name = "通信中断"
	typepath = /datum/round_event/communications_blackout
	weight = 30
	category = EVENT_CATEGORY_ENGINEERING
	description = "对所有电信设备施加强电磁脉冲，暂时阻断所有通信。"
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 3

/datum/round_event/communications_blackout
	announce_when = 1

/datum/round_event/communications_blackout/announce(fake)
	var/alert = pick( "Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT",
		"Ionospheric anomalies detected. Temporary telecommunication failu*3mga;b4;'1v¬-BZZZT",
		"Ionospheric anomalies detected. Temporary telec#MCi46:5.;@63-BZZZZT",
		"Ionospheric anomalies dete'fZ\\kg5_0-BZZZZZT",
		"Ionospheri:%£ MCayj^j<.3-BZZZZZZT",
		"#4nd%;f4y6,>£%-BZZZZZZZT",
	)

	for(var/mob/living/silicon/ai/A in GLOB.ai_list) //AIs are always aware of communication blackouts.
		to_chat(A, "<br>[span_warning("<b>[alert]</b>")]<br>")
		to_chat(A, span_notice("记住，你可以通过右键点击全息板进行传输，并且可以使用\"\".[/datum/saymode/holopad::key]\"\"通过它们说话。"))

	if(prob(30) || fake) //most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		priority_announce(alert, "异常警报", sound = ANNOUNCER_COMMSBLACKOUT) //NOVA EDIT CHANGE - ORIGINAL: priority_announce(alert, "Anomaly Alert")


/datum/round_event/communications_blackout/start()
	for(var/obj/machinery/telecomms/shhh as anything in GLOB.telecomm_machines)
		shhh.emp_act(EMP_HEAVY)
	for(var/datum/transport_controller/linear/tram/transport as anything in SStransport.transports_by_type[TRANSPORT_TYPE_TRAM])
		if(!isnull(transport.home_controller))
			var/obj/machinery/transport/tram_controller/tcomms/controller = transport.home_controller
			controller.emp_act(EMP_HEAVY)
