// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(change_shuttle_events, R_ADMIN|R_FUN, "更改穿梭机事件", "Change the events on a shuttle.", ADMIN_CATEGORY_SHUTTLE)
	//At least for now, just letting admins modify the emergency shuttle is fine
	var/obj/docking_port/mobile/port = SSshuttle.emergency

	if(!port)
		to_chat(user, span_admin(LANG("datum.64253f255812a2fe", null)))

	var/list/options = list("Clear"="Clear")

	//Grab the active events so we know which ones we can Add or Remove
	var/list/active = list()
	for(var/datum/shuttle_event/event in port.event_list)
		active[event.type] = event

	for(var/datum/shuttle_event/event as anything in subtypesof(/datum/shuttle_event))
		options[((event in active) ? "(Remove)" : "(Add)") + initial(event.name)] = event

	//Throw up an ugly menu with the shuttle events and the options to add or remove them, or clear them all
	var/result = input(user, LANG("datum.54487c0d5d807a82", null), LANG("datum.ab79d7fb18001a20", null)) as null|anything in sort_list(options)

	if(result == "Clear")
		port.event_list.Cut()
		message_admins("[key_name_admin(user)] has cleared the shuttle events on: [port]")
	else if(options[result])
		var/typepath = options[result]
		if(typepath in active)
			port.event_list.Remove(active[options[result]])
			message_admins("[key_name_admin(user)] has removed '[active[result]]' from [port].")
		else
			message_admins("[key_name_admin(user)] has added '[typepath]' to [port].")
			port.add_shuttle_event(typepath)

ADMIN_VERB(call_shuttle, R_ADMIN, "呼叫穿梭机", "Force a shuttle call with additional modifiers.", ADMIN_CATEGORY_SHUTTLE)
	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	var/confirm = tgui_alert(user, LANG("datum.be968efe0737cd01", null), LANG("datum.3c1da715a16e1d9e", null), list("Yes", "Yes (No Recall)", "No"))
	switch(confirm)
		if(null, "No")
			return
		if("Yes (No Recall)")
			SSshuttle.admin_emergency_no_recall = TRUE
			SSshuttle.emergency.mode = SHUTTLE_IDLE

	SSshuttle.emergency.request()
	BLACKBOX_LOG_ADMIN_VERB("Call Shuttle")
	log_admin("[key_name(user)] admin-called the emergency shuttle.")
	message_admins(span_adminnotice("[key_name_admin(user)] admin-called the emergency shuttle[confirm == "Yes (No Recall)" ? " (non-recallable)" : ""]."))

ADMIN_VERB(cancel_shuttle, R_ADMIN, "取消穿梭机", "Recall the shuttle, regardless of circumstances.", ADMIN_CATEGORY_SHUTTLE)
	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	if(tgui_alert(user, LANG("datum.be968efe0737cd01", null), LANG("datum.d70ebaee85a7985d", null), list("Yes", "No")) != "Yes")
		return

	if(!SSshuttle.cancel_evac(user.mob, hide_origin = TRUE)) // handles the case where the shuttle is set to unrecallable by another admin or the code
		return

	BLACKBOX_LOG_ADMIN_VERB("Cancel Shuttle")
	log_admin("[key_name(user)] admin-recalled the emergency shuttle.")
	message_admins(span_adminnotice("[key_name_admin(user)] admin-recalled the emergency shuttle."))

ADMIN_VERB(disable_shuttle, R_ADMIN, "禁用穿梭机", "Those fuckers aren't getting out.", ADMIN_CATEGORY_SHUTTLE)
	if(SSshuttle.emergency.mode == SHUTTLE_DISABLED)
		to_chat(user, span_warning(LANG("datum.b8472abad5f65a1b", null)))
		return

	if(tgui_alert(user, LANG("datum.be968efe0737cd01", null), LANG("datum.3c1da715a16e1d9e", null), list("Yes", "No")) != "Yes")
		return

	message_admins(span_adminnotice("[key_name_admin(user)] disabled the shuttle."))

	SSshuttle.last_mode = SSshuttle.emergency.mode
	SSshuttle.last_call_time = SSshuttle.emergency.timeLeft(1)
	SSshuttle.admin_emergency_no_recall = TRUE
	SSshuttle.emergency.setTimer(0)
	SSshuttle.emergency.mode = SHUTTLE_DISABLED
	priority_announce(
		text = "Emergency Shuttle uplink failure, shuttle disabled until further notice.",
		title = "Uplink Failure",
		sound = ANNOUNCER_SHUTTLE, // NOVA EDIT CHANGE - Announcer Sounds - ORIGINAL: sound = 'sound/announcer/announcement/announce_dig.ogg',
		sender_override = "Emergency Shuttle Uplink Alert",
		color_override = "grey",
	)

ADMIN_VERB(enable_shuttle, R_ADMIN, "启用穿梭机", "Those fuckers ARE getting out.", ADMIN_CATEGORY_SHUTTLE)
	if(SSshuttle.emergency.mode != SHUTTLE_DISABLED)
		to_chat(user, span_warning(LANG("datum.a398338cfff1af77", null)))
		return

	if(tgui_alert(user, LANG("datum.be968efe0737cd01", null), LANG("datum.3c1da715a16e1d9e", null), list("Yes", "No")) != "Yes")
		return

	message_admins(span_adminnotice("[key_name_admin(user)] enabled the emergency shuttle."))
	SSshuttle.admin_emergency_no_recall = FALSE
	SSshuttle.emergency_no_recall = FALSE
	if(SSshuttle.last_mode == SHUTTLE_DISABLED) //If everything goes to shit, fix it.
		SSshuttle.last_mode = SHUTTLE_IDLE

	SSshuttle.emergency.mode = SSshuttle.last_mode
	if(SSshuttle.last_call_time < 10 SECONDS && SSshuttle.last_mode != SHUTTLE_IDLE)
		SSshuttle.last_call_time = 10 SECONDS //Make sure no insta departures.
	SSshuttle.emergency.setTimer(SSshuttle.last_call_time)
	priority_announce(
		text = "Emergency Shuttle uplink reestablished, shuttle enabled.",
		title = "Uplink Restored",
		sound = ANNOUNCER_SHUTTLE, // NOVA EDIT CHANGE - Announcer Sounds - ORIGINAL: sound = 'sound/announcer/announcement/announce_dig.ogg',
		sender_override = "Emergency Shuttle Uplink Alert",
		color_override = "green",
	)

ADMIN_VERB(hostile_environment, R_ADMIN, "敌对环境", "Disable the shuttle, naturally.", ADMIN_CATEGORY_SHUTTLE)
	switch(tgui_alert(user, LANG("datum.2d66d006c98cbae1", null), LANG("datum.9b16bc89b83264f3", null), list("Enable", "Disable", "Clear All")))
		if("Enable")
			if (SSshuttle.hostile_environments["Admin"] == TRUE)
				to_chat(user, span_warning(LANG("datum.241ca48b31a3068b", null)))
			else
				message_admins(span_adminnotice("[key_name_admin(user)] Enabled an admin hostile environment"))
				SSshuttle.registerHostileEnvironment("Admin")
		if("Disable")
			if (!SSshuttle.hostile_environments["Admin"])
				to_chat(user, span_warning(LANG("datum.65421b0dc5b0dce6", null)))
			else
				message_admins(span_adminnotice("[key_name_admin(user)] Disabled the admin hostile environment"))
				SSshuttle.clearHostileEnvironment("Admin")
		if("Clear All")
			message_admins(span_adminnotice("[key_name_admin(user)] Disabled all current hostile environment sources"))
			SSshuttle.hostile_environments.Cut()
			SSshuttle.checkHostileEnvironment()

ADMIN_VERB(shuttle_panel, R_ADMIN, "穿梭机操纵器", "Opens the shuttle manipulator UI.", ADMIN_CATEGORY_SHUTTLE)
	SSshuttle.ui_interact(user.mob)

/obj/docking_port/mobile/proc/admin_fly_shuttle(mob/user)
	var/list/options = list()

	options += "-----COMPATABLE DOCKS:" //NOVA EDIT ADDITION
	for(var/port in SSshuttle.stationary_docking_ports)
		if (istype(port, /obj/docking_port/stationary/transit))
			continue  // please don't do this
		var/obj/docking_port/stationary/S = port
		if (canDock(S) == SHUTTLE_CAN_DOCK)
			options[S.name || S.shuttle_id] = S
	//NOVA EDIT ADDITION START
	options += "-----INCOMPATABLE DOCKS:" //I WILL CRASH THIS SHIP WITH NO SURVIVORS!
	for(var/port in SSshuttle.stationary_docking_ports)
		if (istype(port, /obj/docking_port/stationary/transit))
			continue  // please don't do this
		var/obj/docking_port/stationary/S = port
		if(!(canDock(S) == SHUTTLE_CAN_DOCK))
			options[S.name || S.shuttle_id] = S
	//NOVA EDIT END

	options += "--------"
	options += "Infinite Transit"
	options += "Delete Shuttle"
	options += "Into The Sunset (delete & greentext 'escape')"

	var/selection = tgui_input_list(user, LANG("obj.4135ead7ac532d0e", list(name || shuttle_id)), LANG("obj.e11247ef84d92375", null), options)
	if(isnull(selection))
		return

	switch(selection)
		if("Infinite Transit")
			destination = null
			mode = SHUTTLE_IGNITING
			setTimer(ignitionTime)

		if("Delete Shuttle")
			if(tgui_alert(user, LANG("obj.704b413eb94c4c3e", list(name || shuttle_id)), LANG("obj.fc0656cd18b266f8", null), list("Cancel", "Really!")) != "Really!")
				return
			jumpToNullSpace()

		if("Into The Sunset (delete & greentext 'escape')")
			if(tgui_alert(user, LANG("obj.87737fd2440ad070", list(name || shuttle_id)), LANG("obj.fc0656cd18b266f8", null), list("Cancel", "Really!")) != "Really!")
				return
			intoTheSunset()

		else
			if(options[selection])
				request(options[selection], TRUE) //NOVA EDIT CHANGE - ORIGINAL: request(options[selection])
				message_admins("[user.ckey] has admin FORCED [name || shuttle_id] to dock at [options[selection]], this is ignoring all safety measures.") //NOVA EDIT ADDITION

/obj/docking_port/mobile/emergency/admin_fly_shuttle(mob/user)
	return  // use the existing verbs for this

/obj/docking_port/mobile/arrivals/admin_fly_shuttle(mob/user)
	switch(tgui_alert(user, LANG("obj.6e0c6287b4309e27", null), LANG("obj.e11247ef84d92375", null), list("Fly", "Retarget", "Cancel")))
		if("Cancel")
			return
		if("Fly")
			return ..()

	var/list/options = list()

	for(var/port in SSshuttle.stationary_docking_ports)
		if (istype(port, /obj/docking_port/stationary/transit))
			continue  // please don't do this
		var/obj/docking_port/stationary/S = port
		if (canDock(S) == SHUTTLE_CAN_DOCK)
			options[S.name || S.shuttle_id] = S

	var/selection = tgui_input_list(user, LANG("obj.86eb0a768a63f8a1", null), LANG("obj.e11247ef84d92375", null), options)
	if(isnull(selection))
		return
	target_dock = options[selection]
	if(!QDELETED(target_dock))
		destination = target_dock
