#define INFINITE_CHARGES -1

/obj/item/device/traitor_announcer
	name = "古怪装置"
	desc = "嗯...这是用来做什么的？"
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE
	special_desc = "A remote that can be used to transmit a fake announcement of your own design."
	icon = 'icons/obj/devices/scanner.dmi'
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	icon_state = "inspector"
	worn_icon_state = "salestagger"
	inhand_icon_state = "electronic"
	///How many uses does it have? -1 for infinite
	var/uses = 1

/obj/item/device/traitor_announcer/attack_self(mob/living/user, modifiers)
	. = ..()

	//can we use this?
	if(!isliving(user) || (uses == 0))
		balloon_alert(user, "使用次数已耗尽！")
		return

	//build our announcement
	var/origin = sanitize_text(reject_bad_text(tgui_input_text(user, "谁在播报，或者播报来自哪里？", "播报来源", get_area_name(user), max_length = MAX_NAME_LEN), ascii_only = FALSE))
	if(!origin)
		balloon_alert(user, "来源无效！")
		return

	var/audio_key = tgui_input_list(user, "Which announcement audio key should play? ('Intercept' is default)", "Announcement Audio", GLOB.announcer_keys, ANNOUNCER_INTERCEPT)
	if(!audio_key)
		balloon_alert(user, "音频无效！")
		return

	var/color = tgui_input_list(user, "公告应使用哪种颜色？", "公告色调", ANNOUNCEMENT_COLORS, "默认")
	if(!color)
		balloon_alert(user, "颜色无效！")
		return

	var/title = sanitize_text(reject_bad_text(tgui_input_text(user, "选择公告的标题。", "公告标题", max_length = MAX_NAME_LEN*2), ascii_only = FALSE))
	if(!title)
		balloon_alert(user, "标题无效！")
		return

	var/input = sanitize_text(reject_bad_text(tgui_input_text(user, "选择公告的正文内容。", "公告正文", multiline = TRUE), max_length = MAX_MESSAGE_LEN, ascii_only = FALSE))
	if(!input)
		balloon_alert(user, "正文无效！")
		return

	//treat voice
	var/list/message_data = user.treat_message(input)

	//send
	priority_announce(
		text = message_data["message"],
		title = title,
		sound = audio_key,
		sender_override = origin,
		color_override = color,
		has_important_message = TRUE,
		encode_title = FALSE,
		encode_text = FALSE,
	)

	if(uses != INFINITE_CHARGES)
		uses--

	deadchat_broadcast("从 [span_name("[get_area_name(usr, TRUE)]")] 发布了一条伪造的优先公告。", span_name("[user.real_name]"), user, message_type=DEADCHAT_ANNOUNCEMENT)
	user.log_talk("\[Message title\]: [title], \[Message\]: [input], \[Audio key\]: [audio_key]", LOG_TELECOMMS, tag = "priority announcement")
	message_admins("[ADMIN_LOOKUPFLW(user)] has used [src] to make a fake announcement of [input].")

// Adminbus
/obj/item/device/traitor_announcer/infinite
	uses = -1

#undef INFINITE_CHARGES
