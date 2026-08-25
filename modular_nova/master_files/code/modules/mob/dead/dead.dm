/mob/dead/get_status_tab_items()
	. = ..()
	if(SSticker.HasRoundStarted())
		return
	var/time_remaining = SSticker.GetTimeLeft()
	if(time_remaining > 0)
		. += LANG("mob.089189a1a541d986", list(round(time_remaining/10)))
	else if(time_remaining == -10)
		. += LANG("mob.fb6871ae7f5c5364", null)
	else
		. += LANG("mob.3a00d81170010fe0", null)

	. += LANG("mob.8044ca8f5aec8106", list(LAZYLEN(GLOB.clients)))
	if(client.holder)
		. += LANG("mob.7fba5fa702c55178", list(SSticker.totalPlayersReady))
		. += LANG("mob.846d709a9710791e", list(SSticker.total_admins_ready, length(GLOB.admins)))
	if(length(SSstatpanels.player_ready_data) || length(SSstatpanels.assistant_player_ready_data) || length(SSstatpanels.command_player_ready_data))
		. += SSstatpanels.get_job_estimation(src)

