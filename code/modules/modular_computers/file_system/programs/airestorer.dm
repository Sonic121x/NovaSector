// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/computer_file/program/ai_restorer
	filename = "ai_restore"
	filedesc = "AI Manager & Restorer"
	downloader_category = PROGRAM_CATEGORY_SCIENCE
	program_open_overlay = "generic"
	extended_desc = "Firmware Restoration Kit, capable of reconstructing damaged AI systems. Requires direct AI connection via intellicard slot."
	size = 12
	can_run_on_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	download_access = list(ACCESS_RD)
	tgui_id = "NtosAiRestorer"
	program_icon = "laptop-code"

	/// The AI stored in the program
	var/obj/item/aicard/stored_card
	/// Variable dictating if we are in the process of restoring the AI in the inserted intellicard
	var/restoring = FALSE

/datum/computer_file/program/ai_restorer/on_examine(obj/item/modular_computer/source, mob/user)
	var/list/examine_text = list()
	if(!stored_card)
		examine_text += LANG("datum.450206ee251595ca", null)
		return examine_text

	if(computer.Adjacent(user))
		examine_text += LANG("datum.89f54fb80be53f90", list(stored_card.name))
	else
		examine_text += LANG("datum.e7bc136101b81be1", null)
	examine_text += span_info(LANG("datum.329547e0acfd3cc5", null))
	return examine_text

/datum/computer_file/program/ai_restorer/kill_program(mob/user)
	try_eject(forced = TRUE)
	return ..()

/datum/computer_file/program/ai_restorer/process_tick(seconds_per_tick)
	. = ..()
	if(!restoring) //Put the check here so we don't check for an ai all the time
		return

	var/mob/living/silicon/ai/A = stored_card.AI
	if(stored_card.flush)
		restoring = FALSE
		return
	A.adjust_oxy_loss(-5, FALSE)
	A.adjust_fire_loss(-5, FALSE)
	A.adjust_brute_loss(-5, FALSE)

	// Please don't forget to update health, otherwise the below if statements will probably always fail.
	A.updatehealth()
	if(A.health >= 0 && A.stat == DEAD)
		A.revive()
		stored_card.update_appearance()

	// Finished restoring
	if(A.health >= 100)
		restoring = FALSE

	return TRUE

/datum/computer_file/program/ai_restorer/application_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/aicard))
		return aicard_act(user, tool)

/datum/computer_file/program/ai_restorer/proc/aicard_act(mob/living/user, obj/item/aicard/used_aicard)
	if(!computer)
		return NONE
	if(stored_card)
		to_chat(user, span_warning(LANG("datum.df431d9de4507e38", list(used_aicard, computer.name))))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(used_aicard, computer))
		return ITEM_INTERACT_BLOCKING

	stored_card = used_aicard
	to_chat(user, span_notice(LANG("datum.a9ab5056327dd722", list(used_aicard, computer.name))))
	return ITEM_INTERACT_SUCCESS

/datum/computer_file/program/ai_restorer/try_eject(mob/living/user, forced = FALSE)
	if(!stored_card)
		if(user)
			to_chat(user, span_warning(LANG("datum.46f68c0692e1d0ab", list(computer.name))))
		return FALSE

	if(restoring && !forced)
		if(user)
			to_chat(user, span_warning(LANG("datum.efa91847e63ae1e4", null)))
		return FALSE

	if(user && computer.Adjacent(user))
		to_chat(user, span_notice(LANG("datum.cbed32661d4c054a", list(stored_card, computer.name))))
		user.put_in_hands(stored_card)
	else
		stored_card.forceMove(computer.drop_location())

	stored_card = null
	restoring = FALSE
	return TRUE


/datum/computer_file/program/ai_restorer/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("PRG_beginReconstruction")
			if(!stored_card || !stored_card.AI)
				return FALSE
			var/mob/living/silicon/ai/A = stored_card.AI
			if(A && A.health < 100)
				restoring = TRUE
				A.notify_revival("Your core files are being restored!", source = computer)
			return TRUE
		if("PRG_eject")
			if(stored_card)
				try_eject(usr)
				return TRUE

/datum/computer_file/program/ai_restorer/ui_data(mob/user)
	var/list/data = list()

	data["ejectable"] = TRUE
	data["AI_present"] = !!stored_card?.AI
	data["error"] = null

	if(!stored_card)
		data["error"] = "Please insert an intelliCard."
	else if(!stored_card.AI)
		data["error"] = "No AI located..."
	else if(stored_card.flush)
		data["error"] = "Flush in progress!"
	else
		data["name"] = stored_card.AI.name
		data["restoring"] = restoring
		data["health"] = (stored_card.AI.health + 100) / 2
		data["isDead"] = stored_card.AI.stat == DEAD
		data["laws"] = stored_card.AI.laws.get_law_list(include_zeroth = TRUE, render_html = FALSE)

	return data
