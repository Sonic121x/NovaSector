/obj/machinery/posialert
	name = "automated positronic alert console"
	desc = "A console that will ping when a positronic personality is available for download."
	icon = 'modular_nova/modules/positronic_alert_console/icons/terminals.dmi'
	icon_state = "posialert"
	// to create a cooldown so if roboticists are tired of ghosts
	COOLDOWN_DECLARE(robotics_cooldown)
	/// the reason that the console is muted (player decided)
	var/mute_reason
	// to create a cooldown so ghosts cannot spam it
	COOLDOWN_DECLARE(ghost_cooldown)
	/// The radio channel used to send messages.
	var/announcement_channel = RADIO_CHANNEL_SCIENCE

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/posialert, 28)

/obj/machinery/posialert/examine(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, robotics_cooldown))
		. += span_notice(LANG("obj.59e2f47422905cfd", list(COOLDOWN_TIMELEFT(src, robotics_cooldown) * 0.1)))
		. += span_notice(LANG("obj.9bb8a3c71f70ffd3", list(mute_reason)))
	. += span_notice(LANG("obj.33f99fac9cebcbb0", null))

/obj/machinery/posialert/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!COOLDOWN_FINISHED(src, robotics_cooldown))
		COOLDOWN_RESET(src, robotics_cooldown)
		to_chat(user, span_notice(LANG("obj.3ba19649097fe817", list(src))))
		return
	mute_reason = null
	mute_reason = stripped_input(user, "What would the reason for the mute be? (max characters is 20)", "Mute Reason", "", 20)
	if(!mute_reason)
		to_chat(user, span_warning(LANG("obj.7aca210e3407bd96", list(src))))
		return
	COOLDOWN_START(src, robotics_cooldown, 5 MINUTES)
	to_chat(user, span_notice(LANG("obj.079df7a0c7237843", list(src))))

/obj/machinery/posialert/attack_ghost(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, robotics_cooldown))
		to_chat(user, span_warning(LANG("obj.aa401517679c6e02", list(src, COOLDOWN_TIMELEFT(src, robotics_cooldown) * 0.1))))
		to_chat(user, span_warning(LANG("obj.15266a2ae73b69de", list(src, mute_reason))))
		return
	if(!COOLDOWN_FINISHED(src, ghost_cooldown))
		to_chat(user, span_warning(LANG("obj.3b4f1cdc0ffd7a48", list(src, COOLDOWN_TIMELEFT(src, ghost_cooldown) * 0.1))))
		return
	COOLDOWN_START(src, ghost_cooldown, 30 SECONDS)
	flick("posialertflash",src)
	say(LANG("obj.fff6b55e7c9c2ac2", null))
	aas_config_announce(/datum/aas_config_entry/posibrain_alert, list(), src, list(announcement_channel))
	playsound(loc, 'sound/machines/ping.ogg', 50)

/datum/aas_config_entry/posibrain_alert
	name = "Science Alert: New Positronic Brain Available"
	announcement_lines_map = list(
		"Message" = "There are positronic personalities available.",
	)
	general_tooltip = "Broadcasted when a new personality is available for download in posibrain."

/datum/aas_config_entry/posibrain_alert/act_up()
	. = ..()
	if (.)
		return

	announcement_lines_map["Message"] = pick(
		"R/NT1M3 A= ANNOUN-*#nt_SY!?EM.dm, LI%£ 86: N=0DE NULL!",
		"New version of SyndieOS downloaded and ready for installation. Please proceed to robotics.",
		"ERR)#R - B*@ TEXT F*O(ND!")
