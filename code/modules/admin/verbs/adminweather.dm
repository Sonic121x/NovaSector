// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(run_weather, R_ADMIN|R_FUN, "运行天气", "Triggers specific weather on the z-level you choose.", ADMIN_CATEGORY_EVENTS)

	var/list/weather_choices = list()
	if(!length(weather_choices))
		for(var/datum/weather/weather_type as anything in valid_subtypesof(/datum/weather))
			weather_choices[initial(weather_type.type)] = weather_type

	var/datum/weather/weather_choice = tgui_input_list(user, LANG("datum.ab4c79f4c08b2cd9", null), LANG("datum.858e003b961dc1c0", null), weather_choices)
	if(!weather_choice)
		return
	weather_choice = weather_choices[weather_choice]

	var/turf/current_turf = get_turf(user.mob)
	var/z_level = tgui_input_number(user, LANG("datum.07c3ce55c35540cd", null), LANG("datum.3321c9cb5a642e7f", null), min_value = 1, max_value = world.maxz, default = current_turf?.z)
	if(!isnum(z_level))
		return

	var/static/list/custom_options = list("Default", "Custom", "Cancel")
	var/custom_choice = tgui_alert(user, LANG("datum.cd6b61197e332b06", null), LANG("datum.f9bf3c1d0513dcb5", null), custom_options)
	switch(custom_choice)
		if("Default")
			SSweather.run_weather(weather_choice, z_level) // default settings
			message_admins("[key_name_admin(user)] started weather of type [weather_choice] on the z-level [z_level].")
			log_admin("[key_name(user)] started weather of type [weather_choice] on the z-level [z_level].")
			BLACKBOX_LOG_ADMIN_VERB("Run Weather")
			return
		if("Cancel")
			return

	var/list/area_choices = list()
	for(var/area/area_instance as anything in GLOB.areas)
		area_choices[area_instance.type] ||= list()
		area_choices[area_instance.type] |= area_instance

	var/area/area_choice = tgui_input_list(user, LANG("datum.f13674c6ef9e4f29", null), LANG("datum.f99c2e5cb3ef2d68", null), area_choices)
	if(!area_choice)
		return
	area_choice = area_choices[area_choice]

	var/weather_bitflags = input_bitfield(
		user,
		"Weather flags - Select the flags for your weather event",
		"weather_flags",
		weather_choice::weather_flags,
	)

	var/datum/reagent/reagent_choice
	if((weather_bitflags & (WEATHER_TURFS|WEATHER_MOBS)))
		var/static/list/reagent_options = list("Yes", "No", "Cancel")
		var/reagent_option = tgui_alert(user, LANG("datum.cb1417b55e590fcc", null), LANG("datum.39b4eb7d0b9139ec", null), reagent_options)
		switch(reagent_option)
			if("Cancel")
				return
			if("Yes")
				var/static/list/reagent_choices = list()
				if(!length(reagent_choices))
					for(var/datum/reagent/reagent_type as anything in subtypesof(/datum/reagent))
						reagent_choices[initial(reagent_type.type)] = reagent_type

				reagent_choice = tgui_input_list(user, LANG("datum.a7588a0580713ad0", null), LANG("datum.3214d219b620eac7", null), reagent_choices)
				if(!reagent_choice)
					return
				reagent_choice = reagent_choices[reagent_choice]

	var/thunder_value
	if(weather_bitflags & (WEATHER_THUNDER))
		var/static/list/thunder_choices = GLOB.thunder_chance_options

		var/thunder_choice = tgui_input_list(user, LANG("datum.220554c0261d2b31", null), LANG("datum.e05764b0c5658c20", null), thunder_choices)
		if(!thunder_choice)
			return
		thunder_value = GLOB.thunder_chance_options[thunder_choice]

	var/list/weather_data = list(
		WEATHER_FORCED_AREAS = area_choice,
		WEATHER_FORCED_FLAGS = weather_bitflags,
		WEATHER_FORCED_THUNDER = thunder_value,
		WEATHER_FORCED_REAGENT = reagent_choice,
	)

	SSweather.run_weather(weather_choice, z_level, weather_data)

	message_admins("[key_name_admin(user)] started weather of type [weather_choice] on the z-level [z_level].")
	log_admin("[key_name(user)] started weather of type [weather_choice] on the z-level [z_level].")
	BLACKBOX_LOG_ADMIN_VERB("Run Weather")

ADMIN_VERB(stop_weather, R_ADMIN|R_DEBUG, "停止所有进行中的天气", "Stop all currently active weather.", ADMIN_CATEGORY_EVENTS)
	log_admin("[key_name(user)] stopped all currently active weather.")
	message_admins("[key_name_admin(user)] stopped all currently active weather.")
	for(var/datum/weather/current_weather as anything in SSweather.processing)
		if(current_weather in SSweather.processing)
			current_weather.end()
	BLACKBOX_LOG_ADMIN_VERB("Stop All Active Weather")
