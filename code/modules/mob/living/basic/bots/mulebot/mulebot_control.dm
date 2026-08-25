// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/basic/bot/mulebot/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Mule", name)
		ui.open()

/mob/living/basic/bot/mulebot/ui_data(mob/user)
	var/list/data = list()
	data["powerStatus"] = bot_mode_flags & BOT_MODE_ON
	data["locked"] = bot_access_flags & BOT_COVER_LOCKED
	data["siliconUser"] = HAS_SILICON_ACCESS(user)
	data["mode"] = mode ? "[mode]" : "Ready"
	data["modeStatus"] = ""
	switch(mode)
		if(BOT_IDLE, BOT_DELIVER, BOT_GO_HOME)
			data["modeStatus"] = "good"
		if(BOT_BLOCKED, BOT_NAV, BOT_WAIT_FOR_NAV)
			data["modeStatus"] = "average"
		if(BOT_NO_ROUTE)
			data["modeStatus"] = "bad"
	data["load"] = !!load 
	data["loadName"] = get_load_name()
	data["destination"] =  ai_controller.blackboard[BB_MULEBOT_DESTINATION_BEACON]
	data["homeDestination"] = ai_controller.blackboard[BB_MULEBOT_HOME_BEACON]
	data["destinationsList"] = GLOB.deliverybeacontags
	// NOVA EDIT ADDITION START - I18N - 目的地是导航信标 tag（地图数据），下拉「显示兼 act 标识符」：
	// 用对象选项 {value=英文 tag（onSelected 回传、按 beacon.location 匹配），displayText=译名（仅显示）}，
	// 并本地化已选/主页的「显示」（display-only，act 用 tgui_input_list 另发英文 tag）。en 时全 no-op、保持原 string[]。
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		var/list/localized_dests = list()
		for(var/dest_tag in GLOB.deliverybeacontags)
			localized_dests += list(list("value" = dest_tag, "displayText" = lang_localize_display_name(dest_tag)))
		data["destinationsList"] = localized_dests
		data["destination"] = lang_localize_display_name(ai_controller.blackboard[BB_MULEBOT_DESTINATION_BEACON])
		data["homeDestination"] = lang_localize_display_name(ai_controller.blackboard[BB_MULEBOT_HOME_BEACON])
	// NOVA EDIT ADDITION END
	data["cellPercent"] = cell?.percent()
	data["autoReturn"] = mulebot_delivery_flags & MULEBOT_RETURN_MODE
	data["autoPickup"] = mulebot_delivery_flags & MULEBOT_AUTO_PICKUP_MODE
	data["reportDelivery"] = mulebot_delivery_flags & MULEBOT_REPORT_DELIVERY_MODE
	data["botId"] = id
	data["allowPossession"] = bot_mode_flags & BOT_MODE_CAN_BE_SAPIENT
	data["possessionEnabled"] = can_be_possessed
	data["paiInserted"] = !!paicard
	return data

/mob/living/basic/bot/mulebot/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = ui.user
	if(. || (bot_access_flags & BOT_COVER_LOCKED && !HAS_SILICON_ACCESS(user)))
		return

	bot_control(action, user, params)
	return TRUE

/mob/living/basic/bot/mulebot/bot_control(command, mob/user, list/params = list(), pda = FALSE)
	if(pda && wires.is_cut(WIRE_RX)) // MULE wireless is controlled by wires.
		return

	switch(command)
		if("stop")
			if(mode != BOT_IDLE)
				bot_reset()
		if("go")
			if(mode == BOT_IDLE)
				start()
		if("home")
			if(mode == BOT_IDLE || mode == BOT_DELIVER)
				start_home()
		if("destination")
			var/new_dest
			if(pda)
				new_dest = tgui_input_list(user, LANG("mob.c674440166ace839", null), LANG("mob.031a4a1dd8bf75a2", null), GLOB.deliverybeacontags, ai_controller.blackboard[BB_MULEBOT_DESTINATION_BEACON])
			else
				new_dest = params["value"]
			if(new_dest)
				set_destination(new_dest)
		if("setid")
			var/new_id = tgui_input_text(user, LANG("mob.a3c6bc8841fff540", null), LANG("mob.89704444d6b0bf7a", null), id, max_length = MAX_NAME_LEN)
			if(new_id)
				set_id(new_id)
				name = "\improper MULEbot [new_id]"
		if("sethome")
			var/new_home = tgui_input_list(user, LANG("mob.ae7a26e63bb9cc1d", null), LANG("mob.031a4a1dd8bf75a2", null), GLOB.deliverybeacontags, ai_controller.blackboard[BB_MULEBOT_HOME_BEACON])
			if(new_home)
				ai_controller.set_blackboard_key(BB_MULEBOT_HOME_BEACON, new_home)
		if("unload")
			if(load && mode != BOT_HUNT)
				unload()
		if("autoret")
			mulebot_delivery_flags ^= MULEBOT_RETURN_MODE
		if("autopick")
			mulebot_delivery_flags ^= MULEBOT_AUTO_PICKUP_MODE
		if("report")
			mulebot_delivery_flags ^= MULEBOT_REPORT_DELIVERY_MODE

/mob/living/basic/bot/mulebot/proc/start()
	if(!(bot_mode_flags & BOT_MODE_ON))
		return
	if(ai_controller.blackboard[BB_MULEBOT_DESTINATION_BEACON] == ai_controller.blackboard[BB_MULEBOT_HOME_BEACON])
		update_bot_mode(new_mode = BOT_GO_HOME)
	else
		update_bot_mode(new_mode = BOT_DELIVER)

/mob/living/basic/bot/mulebot/proc/start_home()
	set_destination(ai_controller.blackboard[BB_MULEBOT_HOME_BEACON])
	update_bot_mode(new_mode = BOT_GO_HOME)

/mob/living/basic/bot/mulebot/proc/set_destination(new_destination)
	ai_controller.set_blackboard_key(BB_MULEBOT_DESTINATION_BEACON, new_destination)

/mob/living/basic/bot/mulebot/proc/set_home(turf/home_loc)
	if(home_destination)
		ai_controller.set_blackboard_key(BB_MULEBOT_HOME_BEACON, home_destination)
		home_destination = null
	if(!istype(home_loc))
		CRASH("MULEbot [id] was requested to set a home location to [home_loc ? "an invalid home loc ([home_loc.type])" : "null"]")

	var/obj/machinery/navbeacon/home_beacon = locate() in home_loc
	if(isnull(home_beacon))
		ai_controller.set_blackboard_key(BB_MULEBOT_HOME_BEACON, "")
		return
	ai_controller.set_blackboard_key(BB_MULEBOT_HOME_BEACON, home_beacon.location)
	log_transport("[id]: MULEbot successfuly set home location to ID [home_beacon.location] at [home_beacon.x], [home_beacon.y], [home_beacon.z]")

///Sets the new ID of the mulebot
/mob/living/basic/bot/mulebot/proc/set_id(new_id)
	id = new_id
