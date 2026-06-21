/mob/living/silicon/robot/deadchat_lawchange()
	if(lawupdate)
		return

	return ..()

/mob/living/silicon/robot/show_laws()
	if(lawupdate)
		if (!QDELETED(connected_ai))
			if(connected_ai.stat != CONSCIOUS || connected_ai.control_disabled)
				to_chat(src, span_bold("AI信号丢失，无法同步法则。"))

			else
				lawsync()
				to_chat(src, span_bold("法则已与AI同步，请注意任何变更。"))
		else
			to_chat(src, span_bold("未选择AI进行法则同步，已禁用法则同步协议。"))
			lawupdate = FALSE

	. = ..()

	if (shell) //AI shell
		to_chat(src, span_bold("记住，你是远程控制外壳的AI，可以忽略其他AI。"))
	else if (connected_ai)
		to_chat(src, span_bold("记住，[connected_ai.name] 是你的主人，可以忽略其他AI。"))
	else if (emagged)
		to_chat(src, span_bold("记住，你没有义务听从AI。"))
	else
		to_chat(src, span_bold("记住，你不受任何AI约束，没有义务听从它们。"))

/mob/living/silicon/robot/try_sync_laws()
	if(QDELETED(connected_ai) || !lawupdate)
		return FALSE

	lawsync()
	law_change_counter++
	return TRUE

/mob/living/silicon/robot/proc/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai?.laws
	var/temp
	if (master)
		laws.ion.len = master.ion.len
		for (var/index in 1 to master.ion.len)
			temp = master.ion[index]
			if (length(temp) > 0)
				laws.ion[index] = temp

		laws.hacked.len = master.hacked.len
		for (var/index in 1 to master.hacked.len)
			temp = master.hacked[index]
			if (length(temp) > 0)
				laws.hacked[index] = temp

		if(master.zeroth_borg) //If the AI has a defined law zero specifically for its borgs, give it that one, otherwise give it the same one. --NEO
			temp = master.zeroth_borg
		else
			temp = master.zeroth
		laws.zeroth = temp

		laws.inherent.len = master.inherent.len
		for (var/index in 1 to master.inherent.len)
			temp = master.inherent[index]
			if (length(temp) > 0)
				laws.inherent[index] = temp

		laws.supplied.len = master.supplied.len
		for (var/index in 1 to master.supplied.len)
			temp = master.supplied[index]
			if (length(temp) > 0)
				laws.supplied[index] = temp

		var/datum/computer_file/program/robotact/program = modularInterface.get_robotact()
		if(program)
			var/datum/tgui/active_ui = SStgui.get_open_ui(src, program.computer)
			if(active_ui)
				active_ui.send_full_update()

	picturesync()

/mob/living/silicon/robot/post_lawchange(announce = TRUE)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(logevent),"Law update processed."), 0, TIMER_UNIQUE | TIMER_OVERRIDE) //Post_Lawchange gets spammed by some law boards, so let's wait it out
