/obj/machinery/posialert
	name = "自动正电子警报控制台"
	desc = "当有正电子人格可供下载时会发出提示的控制台。"
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
		. += span_notice("静音剩余时间为[COOLDOWN_TIMELEFT(src, robotics_cooldown) * 0.1]秒。")
		. += span_notice("静音原因：[mute_reason]")
	. += span_notice("按下屏幕以静音或取消静音此控制台。")

/obj/machinery/posialert/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!COOLDOWN_FINISHED(src, robotics_cooldown))
		COOLDOWN_RESET(src, robotics_cooldown)
		to_chat(user, span_notice("你已移除[src]的静音。"))
		return
	mute_reason = null
	mute_reason = stripped_input(user, "静音的原因是什么？（最多20个字符）", "静音原因", "", 20)
	if(!mute_reason)
		to_chat(user, span_warning("[src]需要提供静音原因！"))
		return
	COOLDOWN_START(src, robotics_cooldown, 5 MINUTES)
	to_chat(user, span_notice("你已将[src]静音五分钟。"))

/obj/machinery/posialert/attack_ghost(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, robotics_cooldown))
		to_chat(user, span_warning("[src]已被静音！静音剩余时间为[COOLDOWN_TIMELEFT(src, robotics_cooldown) * 0.1]秒。"))
		to_chat(user, span_warning("[src]的静音原因：[mute_reason]"))
		return
	if(!COOLDOWN_FINISHED(src, ghost_cooldown))
		to_chat(user, span_warning("[src]目前仍在冷却中！冷却剩余时间为[COOLDOWN_TIMELEFT(src, ghost_cooldown) * 0.1]秒。"))
		return
	COOLDOWN_START(src, ghost_cooldown, 30 SECONDS)
	flick("posialertflash",src)
	say("There are positronic personalities available.")
	aas_config_announce(/datum/aas_config_entry/posibrain_alert, list(), src, list(announcement_channel))
	playsound(loc, 'sound/machines/ping.ogg', 50)

/datum/aas_config_entry/posibrain_alert
	name = "科研警报：新的正电子脑可用"
	announcement_lines_map = list(
		"Message" = "有正电子人格可供下载。",
	)
	general_tooltip = "当正电子脑中有新人格可供下载时广播。"

/datum/aas_config_entry/posibrain_alert/act_up()
	. = ..()
	if (.)
		return

	announcement_lines_map["消息"] = pick(
		"R/NT1M3 A= ANNOUN-*#nt_SY!?EM.dm, LI%£ 86: N=0DE NULL!",
		"新版SyndieOS已下载并准备安装。请前往机器人学部门。",
		"错误)#R - 发现B*@文本F*O(ND！")
