/// One use AI card which downloads a ghost as a syndicate AI to put in your MODsuit
/obj/item/aicard/syndie
	name = "辛迪加AI卡"
	desc = "一种用于存储人工智能的设备。纳米传讯忘了申请专利，所以辛迪加制造了他们自己的版本！"
	icon = 'icons/obj/aicards.dmi'
	icon_state = "syndicard"
	base_icon_state = "syndicard"
	item_flags = null
	force = 7

/obj/item/aicard/syndie/update_icon_state()
	icon_state = base_icon_state
	return ..()

/obj/item/aicard/syndie/update_overlays()
	..()
	. = list()

	if(!AI)
		return

	var/face_state = "[base_icon_state][AI.stat == DEAD ? "-404" : "-full"]"
	. += mutable_appearance(icon, face_state)
	. += emissive_appearance(icon, face_state, src, alpha = src.alpha)

	var/indicator_state = "[base_icon_state][AI.control_disabled ? "-off" : "-on"]"
	. += mutable_appearance(icon, indicator_state)
	. += emissive_appearance(icon, indicator_state, src, alpha = src.alpha)


/obj/item/aicard/syndie/loaded
	/// Set to true while we're waiting for ghosts to sign up
	var/finding_candidate = FALSE

/obj/item/aicard/syndie/loaded/examine(mob/user)
	. = ..()
	. += span_notice("这张卡的背面有一个小小的S.E.L.F.标志，旁边贴着一个标签写着'激活即可获得一个免费的已校准AI！如果AI不可用或具有敌意，请尝试上行链路重新集成或向您的雇主申请补偿。")

/obj/item/aicard/syndie/loaded/attack_self(mob/user, modifiers)
	if(!isnull(AI))
		return ..()
	if(finding_candidate)
		balloon_alert(user, "加载中...")
		return TRUE
	finding_candidate = TRUE
	to_chat(user, span_notice("正在连接至S.E.L.F.调度系统..."))
	procure_ai(user)
	finding_candidate = FALSE
	return TRUE

/// Sets up the ghost poll
/obj/item/aicard/syndie/loaded/proc/procure_ai(mob/user)
	var/datum/antagonist/nukeop/op_datum = user.mind?.has_antag_datum(/datum/antagonist/nukeop,TRUE)
	if(isnull(op_datum))
		balloon_alert(user, "访问无效！")
		return
	var/mob/chosen_one = SSpolling.poll_ghosts_for_target(
		check_jobban = list(ROLE_OPERATIVE, JOB_AI),
		poll_time = 20 SECONDS,
		checked_target = src,
		ignore_category = POLL_IGNORE_SYNDICATE,
		alert_pic = src,
		role_name_text = "Nuclear Operative Modsuit AI",
		chat_text_border_icon = mutable_appearance(icon, "syndicard-full"),
	)
	on_poll_concluded(user, op_datum, chosen_one)

/// Poll has concluded with a ghost, create the AI
/obj/item/aicard/syndie/loaded/proc/on_poll_concluded(mob/user, datum/antagonist/nukeop/op_datum, mob/dead/observer/ghost)
	if(!ismob(ghost))
		to_chat(user, span_warning("无法连接到S.E.L.F.调度系统。请稍后重试，或使用你上行链路中的智能卡来退还你的点数。"))
		return

	// pick ghost, create AI and transfer
	var/mob/living/silicon/ai/weak_syndie/new_ai = new /mob/living/silicon/ai/weak_syndie(null, new /datum/ai_laws/syndicate_override, ghost)
	// create and apply syndie datum
	var/datum/antagonist/nukeop/nuke_datum = new()
	nuke_datum.send_to_spawnpoint = FALSE
	nuke_datum.give_bonus_tc = FALSE
	new_ai.mind.add_antag_datum(nuke_datum, op_datum.nuke_team)
	LAZYADD(new_ai.mind.special_roles, "Syndicate AI")
	new_ai.add_faction(ROLE_SYNDICATE)

	// Make it look evil!!!
	new_ai.hologram_appearance = mutable_appearance('icons/mob/silicon/ai.dmi',"xeno_queen") //good enough

	new_ai.set_core_display_icon("hades")

	// Hide PDA from messenger
	var/datum/computer_file/program/messenger/msg = locate() in new_ai.modularInterface.stored_files
	if(msg)
		msg.invisible = TRUE

	// Transfer the AI from the core we created into the card, then delete the core
	new_ai.transfer_ai(AI_TRANS_TO_CARD, user, null, src)
	update_appearance()

	var/obj/structure/ai_core/detritus = locate() in get_turf(src)
	qdel(detritus)

	if(AI)
		AI.set_control_disabled(FALSE)
		AI.radio_enabled = TRUE

	do_sparks(4, TRUE, src)
	playsound(src, 'sound/machines/chime.ogg', 25, TRUE)
	return

/obj/item/aicard/syndie/loaded/upload_ai(atom/to_what, mob/living/user)
	. = ..()
	if (!.)
		return
	visible_message(span_warning("用尽的卡片自燃了。"))
	do_sparks(3, cardinal_only = FALSE, source = src)
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)

/// Upgrade disk used to increase the range of a syndicate AI
/obj/item/disk/computer/syndie_ai_upgrade
	name = "AI交互范围升级"
	desc = "一张纳米传讯数据芯片，内含辛迪加智能卡AI可用于提升其无线接口能力的信息。只需将其拍在智能卡、MOD防护服或AI核心上，即可见证其工作！据传其中含有某种“相当糟糕”的东西。"
	max_capacity = 1000
	w_class = WEIGHT_CLASS_NORMAL
	sticker_icon_state = "o_syndicate"

/obj/item/disk/computer/syndie_ai_upgrade/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	var/mob/living/silicon/ai/AI
	if(isAI(target))
		AI = target
	else
		AI = locate() in target
	if(!AI || AI.interaction_range == INFINITY)
		playsound(src,'sound/machines/buzz/buzz-sigh.ogg',50,FALSE)
		to_chat(user, span_notice("错误！不兼容的对象！"))
		return ..()
	AI.interaction_range += 2
	if(AI.interaction_range > 7)
		AI.interaction_range = INFINITY
	playsound(src,'sound/machines/beep/twobeep.ogg',50,FALSE)
	to_chat(user, span_notice("你将[src]插入[AI]的插槽，它在处理数据时发出哔哔声。"))
	to_chat(AI, span_notice("你处理了[src]，发现自己现在能够操纵最远[AI.interaction_range]米内的电子设备了！"))
	qdel(src)
