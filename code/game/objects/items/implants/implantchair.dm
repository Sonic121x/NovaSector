/obj/machinery/implantchair
	name = "思维盾牌植入器"
	desc = "用于为乘员植入思维盾牌植入体。"
	icon = 'icons/obj/machines/implant_chair.dmi'
	icon_state = "implantchair"
	density = TRUE
	opacity = FALSE
	interaction_flags_mouse_drop = NEED_DEXTERITY

	var/ready = TRUE
	var/replenishing = FALSE

	var/ready_implants = 5
	var/max_implants = 5
	var/injection_cooldown = 600
	var/replenish_cooldown = 6000
	var/implant_type = /obj/item/implant/mindshield
	var/auto_inject = FALSE
	var/auto_replenish = TRUE
	var/special = FALSE
	var/special_name = "special function"
	var/message_cooldown
	var/breakout_time = 600

/obj/machinery/implantchair/Initialize(mapload)
	. = ..()
	open_machine()
	update_appearance()

/obj/machinery/implantchair/ui_state(mob/user)
	return GLOB.notcontained_state

/obj/machinery/implantchair/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ImplantChair", name)
		ui.open()

/obj/machinery/implantchair/ui_data()
	var/list/data = list()
	var/mob/living/mob_occupant = occupant

	data["occupied"] = mob_occupant ? 1 : 0
	data["open"] = state_open

	data["occupant"] = list()
	if(mob_occupant)
		data["occupant"]["name"] = mob_occupant.name
		data["occupant"]["stat"] = mob_occupant.stat

	data["special_name"] = special ? special_name : null
	data["ready_implants"] = ready_implants
	data["ready"] = ready
	data["replenishing"] = replenishing

	return data

/obj/machinery/implantchair/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("implant")
			implant(occupant, usr)
			. = TRUE

/obj/machinery/implantchair/proc/implant(mob/living/M,mob/user)
	if (!istype(M))
		return
	if(!ready_implants || !ready)
		return
	if(implant_action(M,user))
		ready_implants--
		if(!replenishing && auto_replenish)
			replenishing = TRUE
			addtimer(CALLBACK(src, PROC_REF(replenish)),replenish_cooldown)
		if(injection_cooldown > 0)
			ready = FALSE
			addtimer(CALLBACK(src, PROC_REF(set_ready)),injection_cooldown)
	else
		playsound(get_turf(src), 'sound/machines/buzz/buzz-sigh.ogg', 25, TRUE)
	update_appearance()

/obj/machinery/implantchair/proc/implant_action(mob/living/M)
	var/obj/item/I = new implant_type
	if(istype(I, /obj/item/implant))
		var/obj/item/implant/P = I
		if(P.implant(M))
			visible_message(span_warning("[M]被[src]植入了植入物。"))
			return TRUE
	else if(isorgan(I))
		var/obj/item/organ/P = I
		P.Insert(M, FALSE, FALSE)
		visible_message(span_warning("[M]被[src]植入了植入物。"))
		return TRUE

/obj/machinery/implantchair/update_icon_state()
	icon_state = initial(icon_state)
	if(state_open)
		icon_state += "_open"
	if(occupant)
		icon_state += "_occupied"
	return ..()

/obj/machinery/implantchair/update_overlays()
	. = ..()
	if(ready)
		. += "ready"

/obj/machinery/implantchair/proc/replenish()
	if(ready_implants < max_implants)
		ready_implants++
	if(ready_implants < max_implants)
		addtimer(CALLBACK(src,"replenish"),replenish_cooldown)
	else
		replenishing = FALSE

/obj/machinery/implantchair/proc/set_ready()
	ready = TRUE
	update_appearance()

/obj/machinery/implantchair/container_resist_act(mob/living/user)
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_notice("你看见[user]正在踢[src]的门！"), \
		span_notice("你靠在[src]的椅背上，开始把门推开...（这大约需要[DisplayTimeText(breakout_time)]。）"), \
		span_hear("你听到[src]传来金属的嘎吱声。"))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src || state_open)
			return
		user.visible_message(span_warning("[user]成功从[src]里挣脱出来了！"), \
			span_notice("你成功从[src]里挣脱出来了！"))
		open_machine()

/obj/machinery/implantchair/relaymove(mob/living/user, direction)
	if(message_cooldown <= world.time)
		message_cooldown = world.time + 50
		to_chat(user, span_warning("[src]的门纹丝不动！"))

/obj/machinery/implantchair/mouse_drop_receive(mob/target, mob/user, params)
	if(!isliving(target))
		return
	close_machine(target)

/obj/machinery/implantchair/close_machine(mob/living/user, density_to_set = TRUE)
	if((isnull(user) || istype(user)) && state_open)
		..(user)
		if(auto_inject && ready && ready_implants > 0)
			implant(user,null)

/obj/machinery/implantchair/genepurge
	name = "基因净化器"
	desc = "用于净化人类基因组中的外来影响。"
	special = TRUE
	special_name = "Purge genome"
	injection_cooldown = 0
	replenish_cooldown = 300

/obj/machinery/implantchair/genepurge/implant_action(mob/living/carbon/human/human, mob/user)
	if(!istype(human))
		return FALSE
	human.dna.remove_all_mutations()//hulks out
	human.set_species(/datum/species/human, 1)//lizards go home
	purrbation_remove(human)//remove cats
	return TRUE


/obj/machinery/implantchair/brainwash
	name = "神经印记器"
	desc = "用于<s>灌输思想</s>改造顽固的累犯。"
	special_name = "Imprint"
	injection_cooldown = 3000
	auto_inject = FALSE
	auto_replenish = FALSE
	special = TRUE
	var/objective = "Obey the law. Praise Nanotrasen."
	var/custom = FALSE

/obj/machinery/implantchair/brainwash/implant_action(mob/living/C, mob/user)
	if(!istype(C) || !C.mind) // I don't know how this makes any sense for silicons but laws trump objectives anyway.
		return FALSE
	if(custom)
		if(!user || !user.Adjacent(src))
			return FALSE
		objective = tgui_input_text(user, "你想给[C]印刻什么指令？", "洗脑", max_length = 120)
		message_admins("[ADMIN_LOOKUPFLW(user)] set brainwash machine objective to '[objective]'.")
		user.log_message("set brainwash machine objective to '[objective]'.", LOG_GAME)
	if(HAS_MIND_TRAIT(C, TRAIT_UNCONVERTABLE))
		return FALSE
	brainwash(C, objective)
	message_admins("[ADMIN_LOOKUPFLW(user)] brainwashed [key_name_admin(C)] with objective '[objective]'.")
	user.log_message("has brainwashed [key_name(C)] with the objective '[objective]' using \the [src]", LOG_ATTACK)
	C.log_message("has been brainwashed with the objective '[objective]' by [key_name(user)] using \the [src]", LOG_VICTIM, log_globally = FALSE)
	log_game("[key_name(user)] brainwashed [key_name(C)] with objective '[objective]'.")
	return TRUE
