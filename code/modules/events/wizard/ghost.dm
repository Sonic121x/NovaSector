/datum/round_event_control/wizard/ghost //The spook is real
	name = "幽-幽-幽-幽灵！"
	weight = 3
	typepath = /datum/round_event/wizard/ghost
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "鬼魂变得可见。"
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/ghost/start()
	var/msg = span_warning("你突然感到自己变得极其显眼……")
	set_observer_default_invisibility(0, msg)


//--//

/datum/round_event_control/wizard/possession //Oh shit
	name = "支配幽-幽-幽-幽灵！"
	weight = 2
	typepath = /datum/round_event/wizard/possession
	max_occurrences = 5
	earliest_start = 0 MINUTES
	description = "鬼魂变得可见并获得附身能力。"

/datum/round_event/wizard/possession/start()
	for(var/mob/dead/observer/ghost_player in GLOB.player_list)
		ghost_player.fun_verbs = TRUE
		to_chat(ghost_player, span_hypnophrase("你突然感到一股新的诡异力量在体内涌动……"))
