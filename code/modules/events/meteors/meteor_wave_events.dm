// Normal strength

/datum/round_event_control/meteor_wave
	name = "流星雨：普通"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 15
	max_occurrences = 3
	earliest_start = 25 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "一次常规的陨石雨。"
	map_flags = EVENT_SPACE_ONLY

/datum/round_event/meteor_wave
	start_when = 6
	end_when = 66
	announce_when = 1
	var/list/wave_type
	var/wave_name = "normal"

/datum/round_event/meteor_wave/New()
	..()
	if(!wave_type)
		determine_wave_type()

/datum/round_event/meteor_wave/proc/determine_wave_type()
	if(!wave_name)
		wave_name = pick_weight(list(
			"normal" = 50,
			"threatening" = 40,
			"catastrophic" = 10))
	switch(wave_name)
		if("normal")
			wave_type = GLOB.meteors_normal
		if("threatening")
			wave_type = GLOB.meteors_threatening
		if("catastrophic")
			if(check_holidays(HALLOWEEN))
				wave_type = GLOB.meteorsSPOOKY
			else
				wave_type = GLOB.meteors_catastrophic
		if("meaty")
			wave_type = GLOB.meateors
		if("space dust")
			wave_type = GLOB.meteors_dust
		if("halloween")
			wave_type = GLOB.meteorsSPOOKY
		else
			WARNING("Wave name of [wave_name] not recognised.")
			kill()

/datum/round_event/meteor_wave/announce(fake)
	priority_announce("检测到流星正与空间站发生碰撞。", "流星警报", ANNOUNCER_METEORS)

/datum/round_event/meteor_wave/tick()
	if(ISMULTIPLE(activeFor, 3))
		spawn_meteors(5, wave_type) //meteor list types defined in gamemode/meteor/meteors.dm

/datum/round_event_control/meteor_wave/threatening
	name = "流星雨：威胁"
	typepath = /datum/round_event/meteor_wave/threatening
	weight = 5
	min_players = 20
	max_occurrences = 3
	earliest_start = 35 MINUTES
	description = "一次出现大型流星概率更高的流星雨。"

/datum/round_event/meteor_wave/threatening
	wave_name = "threatening"

/datum/round_event_control/meteor_wave/catastrophic
	name = "流星雨：灾难"
	typepath = /datum/round_event/meteor_wave/catastrophic
	weight = 7
	min_players = 25
	max_occurrences = 3
	earliest_start = 45 MINUTES
	description = "一次可能召唤通古斯级流星的流星雨。"

/datum/round_event/meteor_wave/catastrophic
	wave_name = "catastrophic"

/datum/round_event_control/meteor_wave/meaty
	name = "流星雨：肉块"
	typepath = /datum/round_event/meteor_wave/meaty
	weight = 2
	max_occurrences = 1
	description = "一次由肉构成的流星雨。"

/datum/round_event/meteor_wave/meaty
	wave_name = "meaty"

/datum/round_event/meteor_wave/meaty/announce(fake)
	priority_announce("检测到肉质矿石正与空间站发生碰撞。", "哦糟了，快拿拖把来。", ANNOUNCER_METEORS)

/datum/round_event_control/meteor_wave/dust_storm
	name = "重大太空尘埃"
	typepath = /datum/round_event/meteor_wave/dust_storm
	weight = 14
	description = "空间站正遭受沙尘冲击。"
	earliest_start = 15 MINUTES
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7

/datum/round_event/meteor_wave/dust_storm
	announce_chance = 85
	wave_name = "space dust"

/datum/round_event/meteor_wave/dust_storm/announce(fake)
	var/list/reasons = list()

	reasons += "[station_name()] is passing through a debris cloud, expect minor damage \
		to external fittings and fixtures."

	reasons += "Nanotrasen Superweapons Division is testing a new prototype \
		[pick("field","projection","nova","super-colliding","reactive")] \
		[pick("cannon","artillery","tank","cruiser","\[REDACTED\]")], \
		some mild debris is expected."

	reasons += "A neighbouring station is throwing rocks at you. (Perhaps they've \
		grown tired of your messages.)"

	reasons += "[station_name()]'s orbit is passing through a cloud of remnants from an asteroid \
		mining operation. Minor hull damage is to be expected."

	reasons += "A large meteoroid on intercept course with [station_name()] has been demolished. \
		Residual debris may impact the station exterior."

	reasons += "[station_name()] has hit a particularly rough patch of space. \
		Please mind any turbulence or damage from debris."

	priority_announce(pick(reasons), "碰撞警报")
