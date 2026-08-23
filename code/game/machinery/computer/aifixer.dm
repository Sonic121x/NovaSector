// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/computer/aifixer
	name = "\improper AI system integrity restorer"
	desc = "Used with intelliCards containing nonfunctional AIs to restore them to working order."
	req_access = list(ACCESS_CAPTAIN, ACCESS_ROBOTICS, ACCESS_COMMAND)
	circuit = /obj/item/circuitboard/computer/aifixer
	icon_state = MAP_SWITCH("computer", "/obj/machinery/computer/aifixer")
	icon_keyboard = "tech_key"
	icon_screen = "ai-fixer"
	light_color = LIGHT_COLOR_PINK

	/// Variable containing transferred AI
	var/mob/living/silicon/ai/occupier
	/// Variable dictating if we are in the process of restoring the occupier AI
	var/restoring = FALSE

/obj/machinery/computer/aifixer/screwdriver_act(mob/living/user, obj/item/I)
	if(occupier)
		if(machine_stat & (NOPOWER|BROKEN))
			to_chat(user, span_warning(LANG("obj.cf827b15d07e0130", list(name))))
		else
			to_chat(user, span_warning(LANG("obj.98b60a607f573771", list(name))))
	else
		return ..()

/obj/machinery/computer/aifixer/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiRestorer", name)
		ui.open()

/obj/machinery/computer/aifixer/ui_data(mob/user)
	var/list/data = list()

	data["ejectable"] = FALSE
	data["AI_present"] = FALSE
	data["error"] = null
	if(!occupier)
		data["error"] = "Please transfer an AI unit."
	else
		data["AI_present"] = TRUE
		data["name"] = occupier.name
		data["restoring"] = restoring
		data["health"] = (occupier.health + 100) / 2
		data["isDead"] = occupier.stat == DEAD
		data["laws"] = occupier.laws.get_law_list(include_zeroth = TRUE, render_html = FALSE)

	return data

/obj/machinery/computer/aifixer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!occupier)
		restoring = FALSE

	switch(action)
		if("PRG_beginReconstruction")
			if(occupier?.health < 100)
				to_chat(usr, span_notice(LANG("obj.66296f84aa8c3a76", null)))
				playsound(src, 'sound/machines/terminal/terminal_prompt_confirm.ogg', 25, FALSE)
				restoring = TRUE
				occupier.notify_revival("Your core files are being restored!", source = src)
				. = TRUE

/obj/machinery/computer/aifixer/proc/Fix()
	if(!use_energy(active_power_usage, force = TRUE))
		say(LANG("obj.bc331d214e62226e", null))
		return FALSE
	var/need_mob_update = FALSE
	need_mob_update += occupier.adjust_oxy_loss(-5, updating_health = FALSE)
	need_mob_update += occupier.adjust_fire_loss(-5, updating_health = FALSE)
	need_mob_update += occupier.adjust_brute_loss(-5, updating_health = FALSE)
	if(need_mob_update)
		occupier.updatehealth()
	if(occupier.health >= 0 && occupier.stat == DEAD)
		occupier.revive()
		if(!occupier.radio_enabled)
			occupier.radio_enabled = TRUE
			to_chat(occupier, span_warning(LANG("obj.b59f30dbbc571ee1", null)))
	return occupier.health < 100

/obj/machinery/computer/aifixer/process()
	if(..())
		if(restoring)
			var/oldstat = occupier.stat
			restoring = Fix()
			if(oldstat != occupier.stat)
				update_appearance()

/obj/machinery/computer/aifixer/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	if(restoring)
		. += "ai-fixer-on"

	if(!occupier)
		. += "ai-fixer-empty"
		return

	if(occupier.stat == HARD_CRIT || IS_UNCONSCIOUS(occupier))
		. += "ai-fixer-404"
	else if(!IS_UNCONSCIOUS_OR_CRIT(occupier))
		. += "ai-fixer-full"

/obj/machinery/computer/aifixer/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(!..())
		return
	//Downloading AI from card to terminal.
	if(interaction == AI_TRANS_FROM_CARD)
		if(machine_stat & (NOPOWER|BROKEN))
			to_chat(user, span_alert(LANG("obj.ef380c0a7ec960ab", list(src))))
			return
		AI.forceMove(src)
		occupier = AI
		AI.set_control_disabled(TRUE)
		AI.radio_enabled = FALSE
		to_chat(AI, span_alert(LANG("obj.798fb85fd6f2b3bd", null)))
		to_chat(user, LANG("obj.8779c42caea32b69", list(span_notice("Transfer successful"), AI.name, rand(1000,9999))))
		card.AI = null
		update_appearance()

	else //Uploading AI from terminal to card
		if(occupier && !restoring)
			to_chat(occupier, span_notice(LANG("obj.4521d3fb6d6295db", null)))
			to_chat(user, LANG("obj.473c445982b94f87", list(span_notice("Transfer successful"), occupier.name, rand(1000,9999))))
			occupier.forceMove(card)
			card.AI = occupier
			occupier = null
			update_appearance()
		else if (restoring)
			to_chat(user, span_alert(LANG("obj.c10d85373518ca43", null)))
		else if (!occupier)
			to_chat(user, span_alert(LANG("obj.6770381983d82948", null)))

/obj/machinery/computer/aifixer/Destroy()
	if(occupier)
		QDEL_NULL(occupier)
	return ..()

/obj/machinery/computer/aifixer/on_deconstruction(disassembled)
	if(occupier)
		QDEL_NULL(occupier)
