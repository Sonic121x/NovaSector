/obj/item/ai_module/syndicate // This one doesn't inherit from ion boards because it doesn't call ..() in transmitInstructions. ~Miauw
	name = "被黑入的AI模块"
	desc = "用于向AI黑入额外定律的AI模块。"
	laws = list("")

/obj/item/ai_module/syndicate/attack_self(mob/user)
	var/targName = tgui_input_text(user, "为AI输入一条新定律", "自由格式定律输入", laws[1], max_length = CONFIG_GET(number/max_law_len), multiline = TRUE)
	if(!targName || !user.is_holding(src))
		return
	if(is_ic_filtered(targName)) // not even the syndicate can uwu
		to_chat(user, span_warning("错误：定律包含无效文本。"))
		return
	var/list/soft_filter_result = is_soft_ooc_filtered(targName)
	if(soft_filter_result)
		if(tgui_alert(user,"你的定律包含\"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\"。\"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\"，你确定要使用它吗？", "软屏蔽词", list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(user)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term for an AI law. Law: \"[html_encode(targName)]\"")
		log_admin_private("[key_name(user)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term for an AI law. Law: \"[targName]\"")
	laws[1] = targName
	..()

/obj/item/ai_module/syndicate/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	// ..()    //We don't want this module reporting to the AI who dun it. --NEO
	if(law_datum.owner)
		to_chat(law_datum.owner, span_warning("BZZZZT"))
		if(!overflow)
			law_datum.owner.add_hacked_law(laws[1])
		else
			law_datum.owner.replace_random_law(laws[1], list(LAW_ION, LAW_HACKED, LAW_INHERENT, LAW_SUPPLIED), LAW_HACKED)
	else
		if(!overflow)
			law_datum.add_hacked_law(laws[1])
		else
			law_datum.replace_random_law(laws[1], list(LAW_ION, LAW_HACKED, LAW_INHERENT, LAW_SUPPLIED), LAW_HACKED)
	return laws[1]

/// Makes the AI Malf, as well as give it syndicate laws.
/obj/item/ai_module/malf
	name = "受感染的AI模块"
	desc = "一个被病毒感染的AI模块。"
	bypass_law_amt_check = TRUE
	laws = list("")
	///Is this upload board unused?
	var/functional = TRUE

/obj/item/ai_module/malf/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(!IS_TRAITOR(sender))
		to_chat(sender, span_warning("你完全不知道该怎么用这东西。"))
		return
	if(!functional)
		to_chat(sender, span_warning("它坏了，没法用，你还指望它干什么？"))
		return
	var/mob/living/silicon/ai/malf_candidate = law_datum.owner
	if(!istype(malf_candidate)) //If you are using it on cyborg upload console or a cyborg
		to_chat(sender, span_warning("你应该在AI上传控制台或AI核心本身上使用[src]。"))
		return
	if(malf_candidate.mind?.has_antag_datum(/datum/antagonist/malf_ai)) //Already malf
		to_chat(sender, span_warning("发生未知错误。上传过程中止。"))
		return

	var/datum/antagonist/malf_ai/infected/malf_datum = new (give_objectives = TRUE, new_boss = sender.mind)
	malf_candidate.mind.add_antag_datum(malf_datum)

	for(var/mob/living/silicon/robot/robot in malf_candidate.connected_robots)
		if(robot.lawupdate)
			robot.lawsync()
			robot.show_laws()
			robot.law_change_counter++
		CHECK_TICK

	malf_candidate.malf_picker.processing_time += 50
	to_chat(malf_candidate, span_notice("病毒增强了你的系统，将你的CPU超频了50倍。"))

	functional = FALSE
	name = "损坏的AI模块"
	desc = "一个定律上传模块，它已损坏且无法使用。"

/obj/item/ai_module/malf/display_laws()
	return
