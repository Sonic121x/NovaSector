/datum/round_event_control/radiation_storm
	name = "辐射风暴"
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 1
	category = EVENT_CATEGORY_SPACE
	description = "辐射风暴影响空间站，迫使船员逃往维护区。"
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event_control/radiation_storm/New()
	. = ..()
	if(max_occurrences > 0 && weight > 0 && check_holidays(CHERNOBYL_ANNIVERSARY))
		weight *= 2
		max_occurrences += 2

/datum/round_event/radiation_storm

/datum/round_event/radiation_storm/setup()
	start_when = 3
	end_when = start_when + 1
	announce_when = 1

/datum/round_event/radiation_storm/announce(fake)
	priority_announce("在空间站附近检测到高浓度辐射。维护区对辐射的屏蔽效果最佳。", "异常警报", ANNOUNCER_RADIATION)
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/radiation_storm/start()
	SSweather.run_weather(/datum/weather/rad_storm)
