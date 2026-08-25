// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
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
		to_chat(malf, span_warning(LANG("obj.232dbf0625ea4459", null)))
		return
	to_chat(malf, span_notice(LANG("obj.c369e869adbeabdd", null)))
	malf.malfhack = src
	malf.malfhacking = addtimer(CALLBACK(malf, TYPE_PROC_REF(/mob/living/silicon/ai/, malfhacked), src), 30 SECONDS + 10*malf.hacked_apcs.len SECONDS, TIMER_STOPPABLE)

	var/atom/movable/screen/alert/hackingapc/hacking_apc
	hacking_apc = malf.throw_alert(ALERT_HACKING_APC, /atom/movable/screen/alert/hackingapc)
	hacking_apc.target = src

/obj/machinery/power/apc/proc/malfoccupy(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(istype(malf.loc, /obj/machinery/power/apc)) // Already in an APC
		to_chat(malf, span_warning(LANG("obj.968d31e472636901", null)))
		return
	if(!malf.can_shunt)
		to_chat(malf, span_warning(LANG("obj.2200459dbfb67264", null)))
		return
	if(!is_station_level(z))
		return
	INVOKE_ASYNC(src, PROC_REF(malfshunt), malf)

/obj/machinery/power/apc/proc/malfshunt(mob/living/silicon/ai/malf)
	var/confirm = tgui_alert(malf, LANG("obj.04af11f3507cae56", null), LANG("obj.5a3041d808d7043e", list(name)), list("Yes", "No"))
	if(confirm != "Yes")
		return
	malf.ShutOffDoomsdayDevice()
	occupier = malf
	if (isturf(malf.loc)) // create a deactivated AI core if the AI isn't coming from an emergency mech shunt
		malf.create_core_link(new /obj/structure/ai_core(malf.loc, CORE_STATE_FINISHED, malf.make_mmi()))
	malf.forceMove(src) // move INTO the APC, not to its tile
	if(!findtext(occupier.name, "APC Copy"))
		occupier.name = "[malf.name] APC Copy"
	malf.shunted = TRUE
	occupier.eyeobj.name = "[occupier.name] (AI Eye)"
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
		to_chat(user, span_warning(LANG("obj.e96f2bf3d2665244", list(card))))
		return FALSE
	if(!occupier)
		to_chat(user, span_warning(LANG("obj.ce3dc00600fbbd58", list(src))))
		return FALSE
	if(!occupier.mind || !occupier.client)
		to_chat(user, span_warning(LANG("obj.87a3b3da54daf26e", list(occupier))))
		return FALSE
	if(occupier.linked_core) //if they have an active linked_core, they can't be transferred from an APC
		to_chat(user, span_warning(LANG("obj.0196183bb1dbc1d7", list(occupier))) )
		return FALSE
	if(transfer_in_progress)
		to_chat(user, span_warning(LANG("obj.4d3b28cf04674c01", null)))
		return FALSE
	if(interaction != AI_TRANS_TO_CARD || IS_UNCONSCIOUS_OR_CRIT(occupier))
		return FALSE
	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		return FALSE
	transfer_in_progress = TRUE
	user.visible_message(span_notice(LANG("obj.936825ea7e37117b", list(user, card, src))), span_notice(LANG("obj.91fafceef4878638", null)))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	SEND_SOUND(occupier, sound('sound/announcer/notice/notice2.ogg')) //To alert the AI that someone's trying to card them if they're tabbed out
	if(tgui_alert(occupier, LANG("obj.cb27ec1cd985b642", list(user, card.name)), LANG("obj.401c435019fb0fe5", null), list("Yes - Transfer Me", "No - Keep Me Here")) == "No - Keep Me Here")
		to_chat(user, span_danger(LANG("obj.019aacdbbee70c93", null)))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, TRUE)
		transfer_in_progress = FALSE
		return FALSE
	if(user.loc != user_turf)
		to_chat(user, span_danger(LANG("obj.4c511b4e43b64ff8", null)))
		to_chat(occupier, span_warning(LANG("obj.80ed7eae653f755f", list(user))))
		transfer_in_progress = FALSE
		return FALSE
	to_chat(user, span_notice(LANG("obj.c78b1142b49b5785", list(card))))
	to_chat(occupier, span_notice(LANG("obj.a1b9ce6c8e0a94cb", list(card))))
	if(!do_after(user, 5 SECONDS, target = src))
		to_chat(occupier, span_warning(LANG("obj.3ec24835fa4864fb", list(user))))
		transfer_in_progress = FALSE
		return FALSE
	if(!occupier || !card)
		transfer_in_progress = FALSE
		return FALSE
	user.visible_message(span_notice(LANG("obj.e626614c94744c55", list(user, occupier, card))), span_notice(LANG("obj.7a313b006553adf9", list(occupier, card))))
	to_chat(occupier, span_notice(LANG("obj.7a3cd229872e8e0b", list(user, card.name))))
	occupier.forceMove(card)
	card.AI = occupier
	occupier.shunted = FALSE
	occupier.cancel_camera()
	occupier = null
	transfer_in_progress = FALSE
	return TRUE
