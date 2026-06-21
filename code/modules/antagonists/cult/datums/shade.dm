/datum/antagonist/cult/shade
	name = "\improper 邪教幽影"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	antagpanel_category = ANTAG_GROUP_HORRORS
	///The time this player was most recently released from a soulstone.
	var/release_time
	///The time needed after release time to enable rune invocation.
	var/invoke_delay = (1 MINUTES)

/datum/antagonist/cult/shade/check_invoke_validity()
	if(isnull(release_time))
		to_chat(owner.current, span_alert("你无法从灵魂石内部激活符文！"))
		return FALSE

	if(release_time + invoke_delay > world.time)
		to_chat(owner.current, span_alert("你尚未积聚足够的力量来激活符文。你需要在灵魂石外再待一段时间！"))
		return FALSE
	return TRUE
