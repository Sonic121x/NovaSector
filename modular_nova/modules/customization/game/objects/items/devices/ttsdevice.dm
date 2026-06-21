/obj/item/ttsdevice
	name = "TTS设备"
	desc = "A small device with a keyboard attached. Anything entered on the keyboard is played out the speaker. \n<span class='notice'>Ctrl-click the device to make it beep.</span> \n<span class='notice'>Ctrl-shift-click to name the device."
	icon = 'modular_nova/modules/modular_items/icons/remote.dmi'
	icon_state = "tts_device"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = UNIQUE_RENAME

/obj/item/ttsdevice/attack_self(mob/user)
	user.balloon_alert_to_viewers("typing...", "started typing...")
	playsound(src, 'modular_nova/master_files/sound/items/tts/started_type.ogg', 50, TRUE)
	var/str = tgui_input_text(user, "你希望设备说什么？", "说话文本", "", max_length = MAX_MESSAGE_LEN, encode = FALSE)
	if(QDELETED(src) || !user.can_perform_action(src))
		return
	if(!str)
		user.balloon_alert_to_viewers("stops typing", "stopped typing")
		playsound(src, 'modular_nova/master_files/sound/items/tts/stopped_type.ogg', 50, TRUE)
		return

	chat_color_name = name
	chat_color = user.client?.prefs?.read_preference(/datum/preference/color/chat_color)
	if(chat_color)
		chat_color_darkened = process_chat_color(chat_color, sat_shift = 0.85, lum_shift = 0.85)

	say(str)
	str = null

/obj/item/ttsdevice/item_ctrl_click(mob/user)
	var/noisechoice = tgui_input_list(user, "你想发出什么声音？", "机器人声音", list("Beep","Buzz","Ping"))
	if(noisechoice == "Beep")
		user.audible_message("makes their TTS beep!", audible_message_flags = EMOTE_MESSAGE)
		playsound(user, 'sound/machines/beep/twobeep.ogg', 50, 1, -1)
	if(noisechoice == "Buzz")
		user.audible_message("makes their TTS buzz!", audible_message_flags = EMOTE_MESSAGE)
		playsound(user, 'sound/machines/buzz/buzz-sigh.ogg', 50, 1, -1)
	if(noisechoice == "Ping")
		user.audible_message("makes their TTS ping!", audible_message_flags = EMOTE_MESSAGE)
		playsound(user, 'sound/machines/ping.ogg', 50, 1, -1)
	if(!noisechoice)
		return CLICK_ACTION_BLOCKING
	return CLICK_ACTION_SUCCESS

/obj/item/ttsdevice/click_ctrl_shift(mob/user)
	var/new_name = reject_bad_name(tgui_input_text(user, "为你的文本转语音设备命名。这会影响在聊天栏中的显示。", "设置TTS设备名称", "", max_length = MAX_NAME_LEN))
	if(new_name)
		name = "[new_name]的[initial(name)]"
	else
		name = initial(name)
