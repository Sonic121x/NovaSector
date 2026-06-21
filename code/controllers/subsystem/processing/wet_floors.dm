PROCESSING_SUBSYSTEM_DEF(wet_floors)
	name = "湿滑地面"
	priority = FIRE_PRIORITY_WET_FLOORS
	wait = 10
	stat_tag = "WFP" //Used for logging
	var/temperature_coeff = 2
	var/time_ratio = 1.5 SECONDS
