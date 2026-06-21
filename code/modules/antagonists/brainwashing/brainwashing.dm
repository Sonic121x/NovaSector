/proc/brainwash(mob/living/brainwash_victim, directives)
	if(!brainwash_victim.mind)
		return
	if(!islist(directives))
		directives = list(directives)
	var/datum/mind/brainwash_mind = brainwash_victim.mind
	var/datum/antagonist/brainwashed/brainwashed_datum = brainwash_mind.has_antag_datum(/datum/antagonist/brainwashed)
	if(brainwashed_datum)
		for(var/O in directives)
			var/datum/objective/brainwashing/objective = new(O)
			brainwashed_datum.objectives += objective
		brainwashed_datum.greet()
	else
		brainwashed_datum = new()
		for(var/O in directives)
			var/datum/objective/brainwashing/objective = new(O)
			brainwashed_datum.objectives += objective
		brainwash_mind.add_antag_datum(brainwashed_datum)

	var/begin_message = " has been brainwashed with the following objectives: "
	var/obj_message = english_list(directives)
	var/rendered = begin_message + obj_message
	if(!(rendered[length(rendered)] in list(",",":",";",".","?","!","\'","-")))
		rendered += "." //Good punctuation is important :)
	deadchat_broadcast(rendered, "<b>[brainwash_victim]</b>", follow_target = brainwash_victim, turf_target = get_turf(brainwash_victim), message_type=DEADCHAT_ANNOUNCEMENT)
	if(check_holidays(APRIL_FOOLS))
		// Note: most of the time you're getting brainwashed you're unconscious
		brainwash_victim.say("You son of a bitch! I'm in.", forced = "That son of a bitch! They're in. (April Fools)")

/datum/antagonist/brainwashed
	name = "\improper 洗脑受害者"
	pref_flag = ROLE_BRAINWASHED
	stinger_sound = 'sound/music/antag/brainwashed.ogg'
	roundend_category = "brainwashed victims"
	show_in_antagpanel = TRUE
	antag_hud_name = "brainwashed"
	antagpanel_category = ANTAG_GROUP_CREW
	show_name_in_check_antagonists = TRUE
	antag_flags = ANTAG_FAKE|ANTAG_SKIP_GLOBAL_LIST
	ui_name = "AntagInfoBrainwashed"
	suicide_cry = "FOR... SOMEONE!!"

/datum/antagonist/brainwashed/ui_static_data(mob/user)
	. = ..()
	var/list/data = list()
	data["objectives"] = get_objectives()
	return data

/datum/antagonist/brainwashed/farewell()
	to_chat(owner, span_warning("你的思绪突然清晰了..."))
	to_chat(owner, "<big>[span_warning("<b>You feel the weight of the Directives disappear! You no longer have to obey them.</b>")]</big>")
	if(owner.current)
		var/mob/living/owner_mob = owner.current
		owner_mob.log_message("is no longer brainwashed with the objectives: [english_list(objectives)].", LOG_ATTACK)
	owner.announce_objectives()
	return ..()

/datum/antagonist/brainwashed/admin_add(datum/mind/new_owner,mob/admin)
	var/mob/living/carbon/C = new_owner.current
	if(!istype(C))
		return
	var/list/objectives = list()
	do
		var/objective = tgui_input_text(admin, "添加一个目标", "洗脑", max_length = MAX_MESSAGE_LEN)
		if(objective)
			objectives += objective
	while(tgui_alert(admin, "添加另一个目标？", "更多洗脑", list("Yes","No")) == "Yes")

	if(tgui_alert(admin,"确认洗脑？","你确定吗？",list("Yes","No")) == "No")
		return

	if(!LAZYLEN(objectives))
		return

	if(QDELETED(C))
		to_chat(admin, "该生物已不存在")
		return

	brainwash(C, objectives)
	var/obj_list = english_list(objectives)
	message_admins("[key_name_admin(admin)] has brainwashed [key_name_admin(C)] with the following objectives: [obj_list].")
	C.log_message("has been force-brainwashed with the objective '[obj_list]' by admin [key_name(admin)]", LOG_VICTIM, log_globally = FALSE)
	log_admin("[key_name(admin)] has brainwashed [key_name(C)] with the following objectives: [obj_list].")

/datum/objective/brainwashing
	completed = TRUE
