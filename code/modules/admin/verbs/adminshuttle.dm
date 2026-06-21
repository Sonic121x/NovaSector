ADMIN_VERB(change_shuttle_events, R_ADMIN|R_FUN, "Change Shuttle Events", "Change the events on a shuttle.", ADMIN_CATEGORY_SHUTTLE)
	//At least for now, just letting admins modify the emergency shuttle is fine
	var/obj/docking_port/mobile/port = SSshuttle.emergency

	if(!port)
		to_chat(user, span_admin("哎呀，找不到逃生穿梭机！"))

	var/list/options = list("Clear"="Clear")

	//Grab the active events so we know which ones we can Add or Remove
	var/list/active = list()
	for(var/datum/shuttle_event/event in port.event_list)
		active[event.type] = event

	for(var/datum/shuttle_event/event as anything in subtypesof(/datum/shuttle_event))
		options[((event in active) ? "(Remove)" : "(Add)") + initial(event.name)] = event

	//Throw up an ugly menu with the shuttle events and the options to add or remove them, or clear them all
	var/result = input(user, "选择要添加/移除的事件", "穿梭机事件") as null|anything in sort_list(options)

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

ADMIN_VERB(call_shuttle, R_ADMIN, "Call Shuttle", "Force a shuttle call with additional modifiers.", ADMIN_CATEGORY_SHUTTLE)
	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	var/confirm = tgui_alert(user, "你确定吗？", "确认", list("Yes", "Yes (No Recall)", "No"))
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

ADMIN_VERB(cancel_shuttle, R_ADMIN, "Cancel Shuttle", "Recall the shuttle, regardless of circumstances.", ADMIN_CATEGORY_SHUTTLE)
	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	if(tgui_alert(user, "你确定吗？", "确认穿梭机取消", list("Yes", "No")) != "Yes")
		return

	if(!SSshuttle.cancel_evac(user.mob, hide_origin = TRUE)) // handles the case where the shuttle is set to unrecallable by another admin or the code
		return

	BLACKBOX_LOG_ADMIN_VERB("Cancel Shuttle")
	log_admin("[key_name(user)] admin-recalled the emergency shuttle.")
	message_admins(span_adminnotice("[key_name_admin(user)] 管理员召回了紧急穿梭机。"))

ADMIN_VERB(disable_shuttle, R_ADMIN, "Disable Shuttle", "Those fuckers aren't getting out.", ADMIN_CATEGORY_SHUTTLE)
	if(SSshuttle.emergency.mode == SHUTTLE_DISABLED)
		to_chat(user, span_warning("错误，穿梭机已禁用。"))
		return

	if(tgui_alert(user, "你确定吗？", "确认", list("Yes", "No")) != "Yes")
		return

	message_admins(span_adminnotice("[key_name_admin(user)] 禁用了穿梭机。"))

	SSshuttle.last_mode = SSshuttle.emergency.mode
	SSshuttle.last_call_time = SSshuttle.emergency.timeLeft(1)
	SSshuttle.admin_emergency_no_recall = TRUE
	SSshuttle.emergency.setTimer(0)
	SSshuttle.emergency.mode = SHUTTLE_DISABLED
	priority_announce(
		text = "紧急穿梭机上行链路故障，穿梭机已停用，直至另行通知。",
		title = "上行链路故障",
		sound = ANNOUNCER_SHUTTLE, // NOVA EDIT CHANGE - Announcer Sounds - ORIGINAL: sound = 'sound/announcer/announcement/announce_dig.ogg',
		sender_override = "紧急穿梭机上行链路警报",
		color_override = "grey",
	)

ADMIN_VERB(enable_shuttle, R_ADMIN, "Enable Shuttle", "Those fuckers ARE getting out.", ADMIN_CATEGORY_SHUTTLE)
	if(SSshuttle.emergency.mode != SHUTTLE_DISABLED)
		to_chat(user, span_warning("错误，穿梭机未禁用。"))
		return

	if(tgui_alert(user, "你确定吗？", "确认", list("Yes", "No")) != "Yes")
		return

	message_admins(span_adminnotice("[key_name_admin(user)] 启用了紧急穿梭机。"))
	SSshuttle.admin_emergency_no_recall = FALSE
	SSshuttle.emergency_no_recall = FALSE
	if(SSshuttle.last_mode == SHUTTLE_DISABLED) //If everything goes to shit, fix it.
		SSshuttle.last_mode = SHUTTLE_IDLE

	SSshuttle.emergency.mode = SSshuttle.last_mode
	if(SSshuttle.last_call_time < 10 SECONDS && SSshuttle.last_mode != SHUTTLE_IDLE)
		SSshuttle.last_call_time = 10 SECONDS //Make sure no insta departures.
	SSshuttle.emergency.setTimer(SSshuttle.last_call_time)
	priority_announce(
		text = "紧急穿梭机上行链路已重新建立，穿梭机已启用。",
		title = "上行链路已恢复",
		sound = ANNOUNCER_SHUTTLE, // NOVA EDIT CHANGE - Announcer Sounds - ORIGINAL: sound = 'sound/announcer/announcement/announce_dig.ogg',
		sender_override = "紧急穿梭机上行链路警报",
		color_override = "green",
	)

ADMIN_VERB(hostile_environment, R_ADMIN, "Hostile Environment", "Disable the shuttle, naturally.", ADMIN_CATEGORY_SHUTTLE)
	switch(tgui_alert(user, "选择选项", "敌对环境管理器", list("Enable", "Disable", "Clear All")))
		if("Enable")
			if (SSshuttle.hostile_environments["Admin"] == TRUE)
				to_chat(user, span_warning("错误，管理员敌对环境已启用。"))
			else
				message_admins(span_adminnotice("[key_name_admin(user)] 启用了一个管理员敌对环境"))
				SSshuttle.registerHostileEnvironment("Admin")
		if("Disable")
			if (!SSshuttle.hostile_environments["Admin"])
				to_chat(user, span_warning("错误，未找到管理员敌对环境。"))
			else
				message_admins(span_adminnotice("[key_name_admin(user)] 禁用了管理员敌对环境"))
				SSshuttle.clearHostileEnvironment("Admin")
		if("Clear All")
			message_admins(span_adminnotice("[key_name_admin(user)] 禁用了所有当前敌对环境来源"))
			SSshuttle.hostile_environments.Cut()
			SSshuttle.checkHostileEnvironment()

ADMIN_VERB(shuttle_panel, R_ADMIN, "Shuttle Manipulator", "Opens the shuttle manipulator UI.", ADMIN_CATEGORY_SHUTTLE)
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

	var/selection = tgui_input_list(user, "选择要飞往 [name || shuttle_id] 的位置：", "飞行穿梭机", options)
	if(isnull(selection))
		return

	switch(selection)
		if("Infinite Transit")
			destination = null
			mode = SHUTTLE_IGNITING
			setTimer(ignitionTime)

		if("Delete Shuttle")
			if(tgui_alert(user, "确定要删除 [name || shuttle_id] 吗？", "删除穿梭机", list("Cancel", "Really!")) != "Really!")
				return
			jumpToNullSpace()

		if("Into The Sunset (delete & greentext 'escape')")
			if(tgui_alert(user, "确定要删除 [name || shuttle_id] 并完成逃脱目标吗？", "删除穿梭机", list("Cancel", "Really!")) != "Really!")
				return
			intoTheSunset()

		else
			if(options[selection])
				request(options[selection], TRUE) //NOVA EDIT CHANGE - ORIGINAL: request(options[selection])
				message_admins("[user.ckey] has admin FORCED [name || shuttle_id] to dock at [options[selection]], this is ignoring all safety measures.") //NOVA EDIT ADDITION

/obj/docking_port/mobile/emergency/admin_fly_shuttle(mob/user)
	return  // use the existing verbs for this

/obj/docking_port/mobile/arrivals/admin_fly_shuttle(mob/user)
	switch(tgui_alert(user, "您想让抵达穿梭机飞行一次，还是更改其目的地？", "飞行穿梭机", list("Fly", "Retarget", "Cancel")))
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

	var/selection = tgui_input_list(user, "新的抵达目的地", "飞行穿梭机", options)
	if(isnull(selection))
		return
	target_dock = options[selection]
	if(!QDELETED(target_dock))
		destination = target_dock
