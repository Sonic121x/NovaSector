SUBSYSTEM_DEF(pai)
	name = "个人人工智能"
	ss_flags = SS_NO_INIT|SS_NO_FIRE

	/// List of pAI candidates, including those not submitted.
	var/list/candidates = list()
	/// All pAI cards on the map.
	var/list/pai_card_list = list()
	/// Prevents a pAI from submitting itself repeatedly and sounding an alert.
	var/submit_spam = FALSE

/datum/controller/subsystem/pai/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PaiSubmit")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/controller/subsystem/pai/Recover()
	. = ..()
	candidates = SSpai.candidates
	pai_card_list = SSpai.pai_card_list

/datum/controller/subsystem/pai/ui_state(mob/user)
	return GLOB.observer_state

/datum/controller/subsystem/pai/ui_static_data(mob/user)
	. = ..()
	var/list/data = list()
	var/datum/pai_candidate/candidate = candidates[user.ckey]
	if(isnull(candidate))
		return data
	data["comments"] = candidate.comments
	data["description"] = candidate.description
	data["name"] = candidate.name
	return data

/datum/controller/subsystem/pai/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return TRUE
	var/mob/user = ui.user
	var/datum/pai_candidate/candidate = candidates[user.ckey]
	if(is_banned_from(user.ckey, ROLE_PAI))
		to_chat(user, span_warning("你被禁止扮演个人人工智能！"))
		ui.close()
		return FALSE
	if(isnull(candidate))
		to_chat(user, span_warning("出现错误。请重新提交。"))
		ui.close()
		return FALSE
	switch(action)
		if("submit")
			candidate.comments = reject_bad_name(params["comments"], allow_numbers = TRUE, max_length = MAX_BROADCAST_LEN, strict = TRUE, cap_after_symbols = FALSE) || "Unknown"
			candidate.description = reject_bad_name(params["description"], allow_numbers = TRUE, max_length = MAX_BROADCAST_LEN, strict = TRUE, cap_after_symbols = FALSE) || "未知"
			candidate.name = reject_bad_name(params["name"], allow_numbers = TRUE, max_length = MAX_NAME_LEN, strict = TRUE, cap_after_symbols = FALSE) || "未知"
			candidate.ckey = user.ckey
			candidate.ready = TRUE
			ui.close()
			submit_alert(user)
			return TRUE
		if("save")
			candidate.comments = reject_bad_name(params["comments"], allow_numbers = TRUE, max_length = MAX_BROADCAST_LEN, strict = TRUE, cap_after_symbols = FALSE) || "Unknown"
			candidate.description = reject_bad_name(params["description"], allow_numbers = TRUE, max_length = MAX_BROADCAST_LEN, strict = TRUE, cap_after_symbols = FALSE) || "未知"
			candidate.name = reject_bad_name(params["name"], allow_numbers = TRUE, max_length = MAX_NAME_LEN, strict = TRUE, cap_after_symbols = FALSE) || "未知"
			candidate.savefile_save(user)
			return TRUE
		if("load")
			candidate.savefile_load(user)
			ui.send_full_update()
			return TRUE
		if("withdraw")
			if(!candidate.ready)
				to_chat(user, span_warning("你需要先提交申请才能撤回。"))
				return FALSE
			candidate.ready = FALSE
			to_chat(user, span_notice("你的个人人工智能候选资格已被撤回。"))
			return TRUE
	return FALSE

/**
 * This is the primary window proc when the pAI candidate
 * hud menu is pressed by observers.
 *
 * @params {mob} user The ghost doing the pressing.
 */
/datum/controller/subsystem/pai/proc/recruit_window(mob/user)
	/// Searches for a previous candidate upon opening the menu
	var/datum/pai_candidate/candidate = candidates[user.ckey]
	if(isnull(candidate))
		candidate = new(user.ckey)
		candidates[user.ckey] = candidate
	ui_interact(user)


/**
 * Pings all pAI cards on the station that new candidates are available.
 */
/datum/controller/subsystem/pai/proc/submit_alert(mob/user)
	if(submit_spam)
		to_chat(user, span_warning("你的候选资格已提交，但个人人工智能卡片的警报触发过于频繁。"))
		return FALSE
	submit_spam = TRUE
	for(var/obj/item/pai_card/pai_card as anything in pai_card_list)
		if(!pai_card.pai)
			pai_card.alert_update()
	to_chat(user, span_notice("你的个人人工智能候选资格已提交！"))
	addtimer(VARSET_CALLBACK(src, submit_spam, FALSE), PAI_SPAM_TIME, TIMER_UNIQUE|TIMER_DELETE_ME)
	return TRUE
