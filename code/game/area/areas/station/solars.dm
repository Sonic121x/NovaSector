/*
* External Solar Areas
*/

/area/station/solars
	icon_state = "panels"
	requires_power = FALSE
	area_flags = NO_GRAVITY
	flags_1 = NONE
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_SPACE
	default_gravity = ZERO_GRAVITY

/area/station/solars/fore
	name = "\improper 前部太阳能阵列"
	icon_state = "panelsF"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/solars/aft
	name = "\improper 后部太阳能阵列"
	icon_state = "panelsAF"

/area/station/solars/aux/port
	name = "\improper 左舷船首辅助太阳能阵列"
	icon_state = "panelsA"

/area/station/solars/aux/starboard
	name = "\improper 右舷船首辅助太阳能阵列"
	icon_state = "panelsA"

/area/station/solars/starboard
	name = "\improper 右舷太阳能阵列"
	icon_state = "panelsS"

/area/station/solars/starboard/aft
	name = "\improper 右舷船尾太阳能阵列"
	icon_state = "panelsAS"

/area/station/solars/starboard/fore
	name = "\improper 右舷船首太阳能阵列"
	icon_state = "panelsFS"

/area/station/solars/starboard/fore/asteriod
	name = "\improper 右舷船首小行星太阳能阵列"
	icon_state = "panelsFS"
	area_flags = NONE // solar areas directly on asteriod have gravity

/area/station/solars/port
	name = "\improper 左舷太阳能阵列"
	icon_state = "panelsP"

/area/station/solars/port/asteriod
	name = "\improper 左舷小行星太阳能阵列"
	icon_state = "panelsP"
	area_flags = NONE // solar areas directly on asteriod have gravity

/area/station/solars/port/aft
	name = "\improper 左舷船尾太阳能阵列"
	icon_state = "panelsAP"

/area/station/solars/port/fore
	name = "\improper 左舷船首太阳能阵列"
	icon_state = "panelsFP"

/area/station/solars/aisat
	name = "\improper AI卫星太阳能阵列"
	icon_state = "panelsAI"


/*
* Internal Solar Areas
* The rooms where the SMES and computer are
* Not in the maintenance file just so we can keep these organized with other the external solar areas
*/

/area/station/maintenance/solars
	name = "太阳能阵列维护区"
	icon_state = "yellow"
	tacmap_color = TACMAP_AREA_ENGINEERING

/area/station/maintenance/solars/port
	name = "左舷太阳能阵列维护区"
	icon_state = "SolarcontrolP"

/area/station/maintenance/solars/port/aft
	name = "左舷船尾太阳能阵列维护区"
	icon_state = "SolarcontrolAP"

/area/station/maintenance/solars/port/fore
	name = "左舷船首太阳能阵列维护区"
	icon_state = "SolarcontrolFP"

/area/station/maintenance/solars/starboard
	name = "右舷太阳能阵列维护区"
	icon_state = "SolarcontrolS"

/area/station/maintenance/solars/starboard/aft
	name = "右舷船尾太阳能阵列维护区"
	icon_state = "SolarcontrolAS"

/area/station/maintenance/solars/starboard/fore
	name = "右舷船首太阳能阵列维护区"
	icon_state = "SolarcontrolFS"
