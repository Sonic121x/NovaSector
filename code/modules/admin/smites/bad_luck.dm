/// Gives the target bad luck, optionally permanently
/datum/smite/bad_luck
	name = "厄运"

	/// Should the target know they've received bad luck?
	var/silent

	/// Is this permanent?
	var/incidents

/datum/smite/bad_luck/configure(client/user)
	silent = tgui_alert(user, "你希望应用此预兆时通知玩家吗？", "通知玩家？", list("Notify", "Silent")) == "Silent"
	incidents = tgui_input_number(user, "此预兆将持续多少次事件？0 表示永久。", "Duration?", default = 0, round_value = 1)
	if(incidents == 0)
		incidents = INFINITY

/datum/smite/bad_luck/effect(client/user, mob/living/target)
	. = ..()
	//if permanent, replace any existing omen
	if(incidents == INFINITY)
		var/existing_component = target.GetComponent(/datum/component/omen)
		qdel(existing_component)
	target.AddComponent(/datum/component/omen/smite, incidents_left = incidents)
	if(silent)
		return
	to_chat(target, span_warning("你有一种不祥的预感..."))
	if(incidents == INFINITY)
		to_chat(target, span_warning("一种<b>非常</b>糟糕的感觉……仿佛有恶意的力量正在注视着你……"))
