/obj/machinery/power/apc/proc/get_malf_status(mob/living/silicon/ai/malf)
	if(!istype(malf) || !malf.malf_picker)
		return APC_AI_NO_MALF
	if(malfai != malf)
		return APC_AI_NO_HACK
	if(occupier == malf)
		return APC_AI_HACK_SHUNT_HERE
	if(istype(malf.loc, /obj/machinery/power/apc))
		return APC_AI_HACK_SHUNT_ANOTHER
	return APC_AI_HACK_NO_SHUNT

/obj/machinery/power/apc/proc/malfhack(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(get_malf_status(malf) != APC_AI_NO_HACK)
		return
	if(malf.malfhacking)
		to_chat(malf, span_warning("你已经在入侵一个APC了！"))
		return
	to_chat(malf, span_notice("开始覆盖APC系统。这需要一些时间，在此过程中你无法执行其他操作。"))
	malf.malfhack = src
	malf.malfhacking = addtimer(CALLBACK(malf, TYPE_PROC_REF(/mob/living/silicon/ai/, malfhacked), src), 30 SECONDS + 10*malf.hacked_apcs.len SECONDS, TIMER_STOPPABLE)

	var/atom/movable/screen/alert/hackingapc/hacking_apc
	hacking_apc = malf.throw_alert(ALERT_HACKING_APC, /atom/movable/screen/alert/hackingapc)
	hacking_apc.target = src

/obj/machinery/power/apc/proc/malfoccupy(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(istype(malf.loc, /obj/machinery/power/apc)) // Already in an APC
		to_chat(malf, span_warning("你必须先撤离你当前的APC！"))
		return
	if(!malf.can_shunt)
		to_chat(malf, span_warning("你无法进行分移！"))
		return
	if(!is_station_level(z))
		return
	INVOKE_ASYNC(src, PROC_REF(malfshunt), malf)

/obj/machinery/power/apc/proc/malfshunt(mob/living/silicon/ai/malf)
	var/confirm = tgui_alert(malf, "你确定要转移吗？这会让你离开你的核心！", "转移到 [name]？", list("Yes", "No"))
	if(confirm != "Yes")
		return
	malf.ShutOffDoomsdayDevice()
	occupier = malf
	if (isturf(malf.loc)) // create a deactivated AI core if the AI isn't coming from an emergency mech shunt
		malf.create_core_link(new /obj/structure/ai_core(malf.loc, CORE_STATE_FINISHED, malf.make_mmi()))
	malf.forceMove(src) // move INTO the APC, not to its tile
	if(!findtext(occupier.name, "APC Copy"))
		occupier.name = "[malf.name] APC复制品"
	malf.shunted = TRUE
	occupier.eyeobj.name = "[occupier.name] (AI之眼)"
	occupier.eyeobj.forceMove(src.loc)
	for(var/obj/item/pinpointer/nuke/disk_pinpointers in GLOB.pinpointer_list)
		disk_pinpointers.switch_mode_to(TRACK_MALF_AI) //Pinpointer will track the shunted AI
	var/datum/action/innate/core_return/return_action = new
	return_action.Grant(occupier)
	occupier.cancel_camera()

/obj/machinery/power/apc/proc/malfvacate(forced)
	if(!occupier)
		return
	SEND_SIGNAL(occupier, COMSIG_SILICON_AI_VACATE_APC, occupier)
	SEND_SIGNAL(src, COMSIG_SILICON_AI_VACATE_APC, occupier)
	if(forced)
		occupier.forceMove(drop_location())
		INVOKE_ASYNC(occupier, TYPE_PROC_REF(/mob/living, death))
		occupier.gib(DROP_ALL_REMAINS)
		occupier = null
		return

	if(!occupier.nuking) //Pinpointers go back to tracking the nuke disk, as long as the AI (somehow) isn't mid-nuking.
		for(var/obj/item/pinpointer/nuke/disk_pinpointers in GLOB.pinpointer_list)
			disk_pinpointers.switch_mode_to(TRACK_NUKE_DISK)
			disk_pinpointers.alert = FALSE

	if(occupier.linked_core)
		occupier.shunted = FALSE
		occupier.resolve_core_link()
		occupier = null
	else
		stack_trace("An AI: [occupier] has vacated an APC with no linked core and without being gibbed.")


/obj/machinery/power/apc/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	. = ..()
	if(!.)
		return
	if(card.AI)
		to_chat(user, span_warning("[card] 已被占用！"))
		return FALSE
	if(!occupier)
		to_chat(user, span_warning("[src] 里没有任何东西可以转移！"))
		return FALSE
	if(!occupier.mind || !occupier.client)
		to_chat(user, span_warning("[occupier] 要么处于非活动状态，要么已被摧毁！"))
		return FALSE
	if(occupier.linked_core) //if they have an active linked_core, they can't be transferred from an APC
		to_chat(user, span_warning("[occupier] 拒绝所有转移尝试！") )
		return FALSE
	if(transfer_in_progress)
		to_chat(user, span_warning("已经有一个转移正在进行中！"))
		return FALSE
	if(interaction != AI_TRANS_TO_CARD || occupier.stat)
		return FALSE
	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return FALSE
	transfer_in_progress = TRUE
	user.visible_message(span_notice("[user] 将 [card] 插入 [src]..."), span_notice("转移进程已启动。正在发送AI批准请求..."))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	SEND_SOUND(occupier, sound('sound/announcer/notice/notice2.ogg')) //To alert the AI that someone's trying to card them if they're tabbed out
	if(tgui_alert(occupier, "[user] 正试图将你转移到 \a [card.name]。你同意吗？", "APC转移", list("Yes - Transfer Me", "No - Keep Me Here")) == "No - Keep Me Here")
		to_chat(user, span_danger("AI拒绝了转移请求。进程已终止。"))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, TRUE)
		transfer_in_progress = FALSE
		return FALSE
	if(user.loc != user_turf)
		to_chat(user, span_danger("位置已改变。进程已终止。"))
		to_chat(occupier, span_warning("[user] 离开了！转移已取消。"))
		transfer_in_progress = FALSE
		return FALSE
	to_chat(user, span_notice("AI接受了请求。正在将存储的智能转移到 [card]..."))
	to_chat(occupier, span_notice("转移开始。你很快将被移动到 [card]。"))
	if(!do_after(user, 5 SECONDS, target = src))
		to_chat(occupier, span_warning("[user] 被打断了！转移已取消。"))
		transfer_in_progress = FALSE
		return FALSE
	if(!occupier || !card)
		transfer_in_progress = FALSE
		return FALSE
	user.visible_message(span_notice("[user] 将 [occupier] 转移到了 [card]！"), span_notice("转移完成！[occupier] 现已存储在 [card] 中。"))
	to_chat(occupier, span_notice("转移完成！你已被存储在 [user] 的 [card.name] 中。"))
	occupier.forceMove(card)
	card.AI = occupier
	occupier.shunted = FALSE
	occupier.cancel_camera()
	occupier = null
	transfer_in_progress = FALSE
	return TRUE
