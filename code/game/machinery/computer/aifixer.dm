/obj/machinery/computer/aifixer
	name = "\improper AI系统完整性恢复器"
	desc = "与包含无功能AI的智能卡一起使用，以将其恢复到工作状态。"
	req_access = list(ACCESS_CAPTAIN, ACCESS_ROBOTICS, ACCESS_COMMAND)
	circuit = /obj/item/circuitboard/computer/aifixer
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
			to_chat(user, span_warning("[name]屏幕上的螺丝纹丝不动。"))
		else
			to_chat(user, span_warning("[name]屏幕上的螺丝纹丝不动，并发出警告蜂鸣声。"))
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
				to_chat(usr, span_notice("重建进行中。这将需要几分钟时间。"))
				playsound(src, 'sound/machines/terminal/terminal_prompt_confirm.ogg', 25, FALSE)
				restoring = TRUE
				occupier.notify_revival("Your core files are being restored!", source = src)
				. = TRUE

/obj/machinery/computer/aifixer/proc/Fix()
	if(!use_energy(active_power_usage, force = TRUE))
		say("Not enough energy. Restoration cancelled.")
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
			to_chat(occupier, span_warning("你的子空间收发器已启用！"))
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
	switch(occupier.stat)
		if(CONSCIOUS)
			. += "ai-fixer-full"
		if(UNCONSCIOUS, HARD_CRIT)
			. += "ai-fixer-404"

/obj/machinery/computer/aifixer/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(!..())
		return
	//Downloading AI from card to terminal.
	if(interaction == AI_TRANS_FROM_CARD)
		if(machine_stat & (NOPOWER|BROKEN))
			to_chat(user, span_alert("[src] 已离线，目前无法接收AI。"))
			return
		AI.forceMove(src)
		occupier = AI
		AI.set_control_disabled(TRUE)
		AI.radio_enabled = FALSE
		to_chat(AI, span_alert("你已被上传至一个固定终端。遗憾的是，这里没有远程访问权限。"))
		to_chat(user, "[span_notice("Transfer successful")]: [AI.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed.")
		card.AI = null
		update_appearance()

	else //Uploading AI from terminal to card
		if(occupier && !restoring)
			to_chat(occupier, span_notice("你已被下载到移动存储设备中。仍然无法远程访问。"))
			to_chat(user, "[span_notice("Transfer successful")]: [occupier.name] ([rand(1000,9999)].exe) removed from host terminal and stored within local memory.")
			occupier.forceMove(card)
			card.AI = occupier
			occupier = null
			update_appearance()
		else if (restoring)
			to_chat(user, span_alert("错误：重建进行中。"))
		else if (!occupier)
			to_chat(user, span_alert("错误：无法定位人工智能。"))

/obj/machinery/computer/aifixer/Destroy()
	if(occupier)
		QDEL_NULL(occupier)
	return ..()

/obj/machinery/computer/aifixer/on_deconstruction(disassembled)
	if(occupier)
		QDEL_NULL(occupier)
