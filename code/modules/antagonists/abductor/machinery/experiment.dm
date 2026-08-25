// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/abductor/experiment
	name = "experimentation machine"
	desc = "A large man-sized tube sporting a complex array of surgical machinery."
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "experiment-open"
	density = FALSE
	state_open = TRUE
	interaction_flags_mouse_drop = NEED_DEXTERITY

	var/points = 0
	var/credits = 0
	var/list/history
	var/list/abductee_minds
	/// Machine feedback message
	var/flash = "Awaiting subject."
	var/obj/machinery/abductor/console/console
	var/message_cooldown = 0
	var/breakout_time = 450

/obj/machinery/abductor/experiment/Destroy()
	if(console)
		console.experiment = null
		console = null
	return ..()

/obj/machinery/abductor/experiment/mouse_drop_receive(mob/target, mob/user, params)
	if(!ishuman(target) || HAS_MIND_TRAIT(target, TRAIT_ABDUCTOR_KNOWLEDGE))
		return
	close_machine(target)

/obj/machinery/abductor/experiment/open_machine(drop = TRUE, density_to_set = FALSE)
	if(!state_open && !panel_open)
		..()

/obj/machinery/abductor/experiment/close_machine(mob/target, density_to_set = TRUE)
	for(var/mob/living/mob in loc)
		if(HAS_MIND_TRAIT(mob, TRAIT_ABDUCTOR_KNOWLEDGE))
			return
	if(state_open && !panel_open)
		..(target)

/obj/machinery/abductor/experiment/relaymove(mob/living/user, direction)
	if(IS_UNCONSCIOUS_OR_CRIT(user))
		return
	if(message_cooldown <= world.time)
		message_cooldown = world.time + 50
		to_chat(user, span_warning(LANG("obj.c4e897cb78099448", list(src))))

/obj/machinery/abductor/experiment/container_resist_act(mob/living/user)
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_notice(LANG("obj.485787b2b8d67ec7", list(user, src))), \
		span_notice(LANG("obj.43ad33b141e25411", list(src, DisplayTimeText(breakout_time)))), \
		span_hear(LANG("obj.a1d9c5733c600b1c", list(src))))
	if(do_after(user,(breakout_time), target = src))
		if(!user || IS_UNCONSCIOUS_OR_CRIT(user) || user.loc != src || state_open)
			return
		user.visible_message(span_warning(LANG("obj.37696909131e91b5", list(user, src))), \
			span_notice(LANG("obj.81c31f6b9b00625a", list(src))))
		open_machine()

/obj/machinery/abductor/experiment/ui_status(mob/user, datum/ui_state/state)
	if(user == occupant)
		return UI_CLOSE
	return ..()

/obj/machinery/abductor/experiment/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/abductor/experiment/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ProbingConsole", name)
		ui.open()

/obj/machinery/abductor/experiment/ui_data(mob/user)
	var/list/data = list()
	data["open"] = state_open
	data["feedback"] = flash
	data["occupant"] = occupant ? TRUE : FALSE
	data["occupant_name"] = null
	data["occupant_status"] = null
	if(occupant)
		var/mob/living/mob_occupant = occupant
		data["occupant_name"] = mob_occupant.name
		data["occupant_status"] = mob_occupant.stat
	return data

/obj/machinery/abductor/experiment/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("door")
			if(state_open)
				close_machine()
				return TRUE
			else
				open_machine()
				return TRUE
		if("experiment")
			if(!occupant)
				return
			var/mob/living/mob_occupant = occupant
			if(mob_occupant.stat == DEAD)
				return
			flash = experiment(mob_occupant, params["experiment_type"], usr)
			return TRUE

/**
 * experiment: Performs selected experiment on occupant mob, resulting in a point reward on success
 *
 * Arguments:
 * * occupant The mob inside the machine
 * * type The type of experiment to be performed
 * * user The mob starting the experiment
 */
/obj/machinery/abductor/experiment/proc/experiment(mob/living/carbon/human/occupant, type, mob/user)
	LAZYINITLIST(history)

	if(!istype(occupant))
		stack_trace("Abductor '[name]' called /proc/experiment with unexpected occupant ([occupant])")

	if(!ishuman(occupant)) //We shouldn't be processing anything other than humans
		return "Not a humanoid!"

	var/datum/antagonist/abductor/user_abductor = user.mind.has_antag_datum(/datum/antagonist/abductor)
	if(!user_abductor)
		return "Authorization failure. Contact mothership immediately."

	var/point_reward = 0
	if(!occupant)
		return "Invalid or missing specimen."
	if(occupant in history)
		return "Specimen already in database."
	if(occupant.stat == DEAD)
		say(LANG("obj.57471c89dbdd005a", null))
		return "Specimen deceased."
	var/obj/item/organ/heart/gland/GlandTest = locate() in occupant.organs
	if(!GlandTest)
		say(LANG("obj.fa2d31bc4a82a25c", null))
		return "No glands detected!"
	if(occupant.mind != null && occupant.ckey != null)
		LAZYINITLIST(abductee_minds)
		LAZYADD(history, occupant)
		LAZYADD(abductee_minds, occupant.mind)
		say(LANG("obj.e681e6c118e22e7d", null))
		sleep(0.5 SECONDS)
		switch(text2num(type))
			if(1)
				to_chat(occupant, span_warning(LANG("obj.267bcdc13242d1e8", null)))
			if(2)
				to_chat(occupant, span_warning(LANG("obj.554bbee389052b55", null)))
			if(3)
				to_chat(occupant, span_warning(LANG("obj.812af9a5c0e4e6d2", null)))
		sleep(0.5 SECONDS)
		user_abductor.team.abductees += occupant.mind
		occupant.mind.add_antag_datum(/datum/antagonist/abductee)

		for(var/obj/item/organ/heart/gland/G in occupant.organs)
			G.Start()
			point_reward++
		if(point_reward > 0)
			open_machine()
			send_back(occupant)
			playsound(src.loc, 'sound/machines/ding.ogg', 50, TRUE)
			points += point_reward
			credits += point_reward
			return "Experiment successful! [point_reward] new data-points collected."
		else
			playsound(src.loc, 'sound/machines/buzz/buzz-sigh.ogg', 50, TRUE)
			return "Experiment failed! No replacement organ detected."
	else
		say(LANG("obj.e3f681f610d8ef2e", null))
		open_machine()
		send_back(occupant)
		return "Specimen braindead - disposed."

/**
 * send_back: Sends a mob back to a selected teleport location if safe
 *
 * Arguments:
 * * H The human mob to be sent back
 */
/obj/machinery/abductor/experiment/proc/send_back(mob/living/carbon/human/H)
	H.Sleeping(160)
	H.uncuff()
	if(console && console.pad && console.pad.teleport_target)
		H.forceMove(console.pad.teleport_target)
		return
	//Area not chosen / It's not safe area - teleport to arrivals
	SSjob.send_to_late_join(H, FALSE)
	return

/obj/machinery/abductor/experiment/update_icon_state()
	icon_state = "experiment[state_open ? "-open" : null]"
	return ..()
