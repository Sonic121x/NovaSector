/datum/round_event_control/wizard/lava //THE LEGEND NEVER DIES
	name = "地板是熔岩！"
	weight = 2
	typepath = /datum/round_event/wizard/lava
	max_occurrences = 3
	earliest_start = 0 MINUTES
	description = "将地板变成滚烫的熔岩。"
	min_wizard_trigger_potency = 5
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/lava
	end_when = 0
	var/started = FALSE

/datum/round_event/wizard/lava/start()
	if(!started)
		started = TRUE
		SSweather.run_weather(/datum/weather/floor_is_lava)
