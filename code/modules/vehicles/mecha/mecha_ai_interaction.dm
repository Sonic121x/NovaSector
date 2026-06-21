/obj/vehicle/sealed/mecha/attack_ai(mob/living/silicon/ai/user)
	if(!isAI(user))
		return

	var/obj/item/mecha_parts/mecha_tracking/data_tracker = null
	var/obj/item/mecha_parts/mecha_tracking/ai_control/control_tracker = null
	var/list/output = list()

	for(var/obj/item/mecha_parts/mecha_tracking/A in trackers)
		data_tracker = A
		break

	for(var/obj/item/mecha_parts/mecha_tracking/ai_control/B in trackers)
		control_tracker = B
		break

	if(!data_tracker && !user.can_dominate_mechs)
		to_chat(user, span_warning("You cannot interface this exosuit without tracking beacons installed."))
		return

	if(data_tracker || user.can_dominate_mechs)
		output += span_notice("[icon2html(src, user)] [name] 动力装甲状态报告\n")
		output += data_tracker?.get_mecha_info()

	if(user.can_dominate_mechs)
		if(data_tracker)
			output += span_danger("\nWarning: Tracking detected. Enter at your own risk.")

	if(user.can_dominate_mechs)
		output += "\n<a href='byond://?src=[REF(user)];ai_take_control=[REF(src)]'>[span_warning("\[INITIALIZE CONTROL OVERRIDE\]")]</a>"
	else if(!control_tracker)
		output += span_warning("\n\[无法控制 - 未安装AI追踪信标\]")
	else if(length(return_occupants()) >= max_occupants)
		output += span_warning("\n\[无法控制 - 已被占用\]")
	else
		output += "\n<a href='byond://?src=[REF(user)];ai_take_control=[REF(src)]'>[span_boldnotice("\[TAKE DIRECT CONTROL\]")]</a>"

	to_chat(user, boxed_message(jointext(output, "\n")))

/obj/vehicle/sealed/mecha/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	. = ..()
	if(!.)
		return

	//Transfer from core or card to mech. Proc is called by mech.
	switch(interaction)
		if(AI_TRANS_TO_CARD) //Upload AI from mech to AI card.
			if(!(mecha_flags & PANEL_OPEN)) //Mech must be in maint mode to allow carding.
				to_chat(user, span_warning("[name] 必须启用维护协议才能允许转移。"))
				return
			var/list/ai_pilots = list()
			for(var/mob/living/silicon/ai/aipilot in occupants)
				ai_pilots += aipilot
			if(!length(ai_pilots)) //Mech does not have an AI for a pilot
				to_chat(user, span_warning("No AI detected in \the [src]'s onboard computer."))
				return
			if(length(ai_pilots) > 1) //Input box for multiple AIs, but if there's only one we'll default to them.
				AI = tgui_input_list(user, "您希望将哪个AI存入卡中？", "AI选择", sort_list(ai_pilots))
			else
				AI = ai_pilots[1]
			if(isnull(AI))
				return
			if(!(AI in occupants) || !user.Adjacent(src))
				return //User sat on the selection window and things changed.

			AI.ai_restore_power()//So the AI initially has power.
			AI.set_control_disabled(TRUE)
			AI.radio_enabled = FALSE
			AI.disconnect_shell()
			remove_occupant(AI)
			mecha_flags  &= ~SILICON_PILOT
			AI.forceMove(card)
			card.AI = AI
			AI.controlled_equipment = null
			AI.remote_control = null
			to_chat(AI, span_notice("您已被下载到移动存储设备中。无线连接已离线。"))
			to_chat(user, "[span_boldnotice("Transfer successful")]: [AI.name] ([rand(1000,9999)].exe) 已从[name]中移除并存储于本地内存。")
			return

		if(AI_MECH_HACK) //Called by AIs on the mech
			AI.create_core_link(new /obj/structure/ai_core(AI.loc, CORE_STATE_FINISHED, AI.make_mmi()))
			if(AI.can_dominate_mechs && LAZYLEN(occupants)) //Oh, I am sorry, were you using that?
				to_chat(AI, span_warning("检测到乘员！已启动强制弹出程序！"))
				to_chat(occupants, span_danger("你已被强制弹出！"))
				for(var/ejectee in occupants)
					mob_exit(ejectee, silent = TRUE, randomstep = TRUE, forced = TRUE) //IT IS MINE, NOW. SUCK IT, RD!

		if(AI_TRANS_FROM_CARD) //Using an AI card to upload to a mech.
			AI = card.AI
			if(!AI)
				to_chat(user, span_warning("该设备当前未安装任何AI。"))
				return
			if(!(mecha_flags & AI_COMPATIBLE)) //If the mech isn't compatible with an AI transfer, early return.
				to_chat(user, span_warning("AI无法被安装到[src]中。"))
				return
			if(AI.deployed_shell) //Recall AI if shelled so it can be checked for a client
				AI.disconnect_shell()
			if(AI.stat || !AI.client)
				to_chat(user, span_warning("[AI.name]当前无响应，无法上传。"))
				return
			if((LAZYLEN(occupants) >= max_occupants) || dna_lock) //Normal AIs cannot steal mechs!
				to_chat(user, span_warning("访问被拒绝。[name]当前[LAZYLEN(occupants) >= max_occupants ? "currently fully occupied" : "secured with a DNA lock"]。"))
				return
			AI.set_control_disabled(FALSE)
			AI.radio_enabled = TRUE
			to_chat(user, "[span_boldnotice("Transfer successful")]：[AI.name]（[rand(1000,9999)].exe）已成功安装并执行。本地副本已被移除。")
			card.AI = null
	ai_enter_mech(AI)

///Hack and From Card interactions share some code, so leave that here for both to use.
/obj/vehicle/sealed/mecha/proc/ai_enter_mech(mob/living/silicon/ai/AI)
	AI.ai_restore_power()
	mecha_flags |= SILICON_PILOT
	moved_inside(AI)
	AI.eyeobj?.forceMove(src)
	AI.eyeobj?.RegisterSignal(src, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/mob/eye/camera/ai, update_visibility))
	AI.controlled_equipment = src
	AI.remote_control = src
	add_occupant(AI)

	var/list/output = list()
	output += span_bold("你已被上传至外骨骼的机载计算机。\n")
	output += "• Press the middle mouse button or the action button on your HUD panel to toggle equipment safety."
	output += "• Clicks with safety enabled will pass AI commands as usual."

	if(AI.can_dominate_mechs)
		output += "• [span_warning("Do not attempt to leave the station sector.")]"

	to_chat(AI, boxed_message(jointext(output, "\n")))
