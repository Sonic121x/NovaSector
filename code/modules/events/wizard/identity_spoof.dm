/datum/round_event_control/wizard/identity_spoof //now EVERYONE is the wizard!
	name = "群体身份冒充"
	weight = 5
	typepath = /datum/round_event/wizard/identity_spoof
	max_occurrences = 1
	description = "让所有人都打扮得像巫师一样。"

/datum/round_event_control/wizard/identity_spoof/can_spawn_event(players_amt, allow_magic = FALSE)
	. = ..()
	if(!.)
		return .

	if(GLOB.current_anonymous_theme) //already anonymous, ABORT ABORT
		return FALSE
	return TRUE

/datum/round_event/wizard/identity_spoof/start()
	if(GLOB.current_anonymous_theme)
		QDEL_NULL(GLOB.current_anonymous_theme)
	GLOB.current_anonymous_theme = new /datum/anonymous_theme/wizards(extras_enabled = TRUE, alert_players = TRUE)
