/datum/controller/subsystem/shuttle
	var/endvote_passed = FALSE

/datum/controller/subsystem/shuttle/proc/autoEnd()
	if(EMERGENCY_IDLE_OR_RECALLED)
		SSshuttle.emergency.request(silent = TRUE)
		priority_announce(LANG("datum.2378d71c37522eaf", list(SSsecurity_level.get_current_level_as_number() == SEC_LEVEL_RED ? "Red Alert state confirmed: Dispatching priority shuttle. " : "", emergency.timeLeft(600))), null, ANNOUNCER_SHUTTLECALLED, "Priority", color_override = "orange")
		log_game("Round end vote passed. Shuttle has been auto-called.")
		message_admins("Round end vote passed. Shuttle has been auto-called.")
	emergency_no_recall = TRUE
	endvote_passed = TRUE
	SSevents.can_fire = FALSE // we're going home
