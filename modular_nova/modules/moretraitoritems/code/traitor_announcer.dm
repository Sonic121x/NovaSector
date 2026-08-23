#define INFINITE_CHARGES -1

/obj/item/device/traitor_announcer
	name = "odd device"
	desc = "Hmm... what is this for?"
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
		balloon_alert(user, LANG("obj.e8ff683378b87f0a", null))
		return

	//build our announcement
	var/origin = sanitize_text(reject_bad_text(tgui_input_text(user, LANG("obj.a18f70bf254e4106", null), LANG("obj.a13897ade2fbeac1", null), get_area_name(user), max_length = MAX_NAME_LEN), ascii_only = FALSE))
	if(!origin)
		balloon_alert(user, LANG("obj.7f313aa2d7137006", null))
		return

	var/audio_key = tgui_input_list(user, LANG("obj.e7e98abf04eb39c7", null), LANG("obj.adb840f2439d7466", null), GLOB.announcer_keys, ANNOUNCER_INTERCEPT)
	if(!audio_key)
		balloon_alert(user, LANG("obj.498862e2f8b97802", null))
		return

	var/color = tgui_input_list(user, LANG("obj.e55458310124f68d", null), LANG("obj.59ef58ac133b02af", null), ANNOUNCEMENT_COLORS, "default")
	if(!color)
		balloon_alert(user, LANG("obj.cba9924c57671034", null))
		return

	var/title = sanitize_text(reject_bad_text(tgui_input_text(user, LANG("obj.0d9126fb7f3f99ac", null), LANG("obj.fa4ed425405e3026", null), max_length = MAX_NAME_LEN*2), ascii_only = FALSE))
	if(!title)
		balloon_alert(user, LANG("obj.355e60205342e8bb", null))
		return

	var/input = sanitize_text(reject_bad_text(tgui_input_text(user, LANG("obj.f8e65aaf61ada8df", null), LANG("obj.d40536e84d989596", null), multiline = TRUE), max_length = MAX_MESSAGE_LEN, ascii_only = FALSE))
	if(!input)
		balloon_alert(user, LANG("obj.76fac4a8183a3d8f", null))
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

	deadchat_broadcast(" made a fake priority announcement from [span_name("[get_area_name(usr, TRUE)]")].", span_name("[user.real_name]"), user, message_type=DEADCHAT_ANNOUNCEMENT)
	user.log_talk("\[Message title\]: [title], \[Message\]: [input], \[Audio key\]: [audio_key]", LOG_TELECOMMS, tag = "priority announcement")
	message_admins("[ADMIN_LOOKUPFLW(user)] has used [src] to make a fake announcement of [input].")

// Adminbus
/obj/item/device/traitor_announcer/infinite
	uses = -1

#undef INFINITE_CHARGES
