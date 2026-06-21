/obj/machinery/computer/atmos_alert
	name = "大气警报控制台"
	desc = "用于监测太空站的空气警报。"
	circuit = /obj/item/circuitboard/computer/atmos_alert
	icon_screen = "alert:0"
	icon_keyboard = "atmos_key"
	light_color = LIGHT_COLOR_CYAN

	var/list/priority_alarms = list()
	var/list/minor_alarms = list()

/obj/machinery/computer/atmos_alert/examine(mob/user)
	. = ..()
	var/obj/item/circuitboard/computer/atmos_alert/my_circuit = circuit
	. += span_info("该控制台设置为[my_circuit.station_only ? "track all station and mining alarms" : "track alarms on the same z-level"]。")

/obj/machinery/computer/atmos_alert/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosAlertConsole", name)
		ui.open()

/obj/machinery/computer/atmos_alert/ui_data(mob/user)
	var/list/data = list()

	data["priority"] = list()
	for(var/zone in priority_alarms)
		data["priority"] += zone
	data["minor"] = list()
	for(var/zone in minor_alarms)
		data["minor"] += zone

	return data

/obj/machinery/computer/atmos_alert/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("clear")
			var/zone = params["zone"]
			if(zone in priority_alarms)
				to_chat(usr, span_notice("区域[zone]的优先警报已清除。"))
				priority_alarms -= zone
				. = TRUE
			if(zone in minor_alarms)
				to_chat(usr, span_notice("区域[zone]的次要警报已清除。"))
				minor_alarms -= zone
				. = TRUE
	update_appearance()

/obj/machinery/computer/atmos_alert/process()
	. = ..()
	if (!.)
		return FALSE

	var/alarm_count = priority_alarms.len + minor_alarms.len

	priority_alarms.Cut()
	minor_alarms.Cut()

	// An area list used for station_only circuits, so we only send an alarm if we're in one of the station or mining home areas
	var/list/station_alert_areas = GLOB.the_station_areas + typesof(/area/mine)
	// Setting up a variable for checking our circuit's station_only
	var/obj/item/circuitboard/computer/atmos_alert/my_circuit = circuit
	for (var/obj/machinery/airalarm/air_alarm as anything in GLOB.air_alarms)
		// If the circuit has station_only, check if alarm areas are in the station list
		if(my_circuit.station_only)
			if (!(air_alarm.my_area.type in station_alert_areas))
				continue
		// Otherwise just check if alarms match the console's z-level
		else if (air_alarm.z != z)
			continue

		switch (air_alarm.danger_level)
			if (AIR_ALARM_ALERT_NONE)
				continue
			if (AIR_ALARM_ALERT_WARNING)
				minor_alarms += get_area_name(air_alarm, format_text = TRUE)
			if (AIR_ALARM_ALERT_HAZARD)
				priority_alarms += get_area_name(air_alarm, format_text = TRUE)

	// Either we got new alarms, or we have no alarms anymore
	if ((alarm_count == 0) != (minor_alarms.len + priority_alarms.len == 0))
		update_appearance(UPDATE_ICON)

	return TRUE

/obj/machinery/computer/atmos_alert/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(priority_alarms.len)
		. += "alert:2"
		return
	if(minor_alarms.len)
		. += "alert:1"

// Subtype with the board pre-set to check only station areas and the mining station
/obj/machinery/computer/atmos_alert/station_only
	circuit = /obj/item/circuitboard/computer/atmos_alert/station_only
