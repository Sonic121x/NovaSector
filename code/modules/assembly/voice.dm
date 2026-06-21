#define INCLUSIVE_MODE 1
#define EXCLUSIVE_MODE 2
#define RECOGNIZER_MODE 3
#define VOICE_SENSOR_MODE 4

/obj/item/assembly/voice
	name = "声音分析仪"
	desc = "一种小型电子设备，能够录制语音样本，并在该样本被重复时发送信号。"
	icon_state = "voice"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.5)
	assembly_behavior = ASSEMBLY_TOGGLEABLE_INPUT
	verb_say = "哔哔声"
	verb_ask = "哔哔声"
	verb_exclaim = "哔哔声"
	var/listening = FALSE
	/// The activation message is tracked using this var.
	var/recorded = ""
	var/mode = INCLUSIVE_MODE
	var/static/list/modes = list(
		"inclusive",
		"exclusive",
		"recognizer",
		"voice sensor",
	)
	drop_sound = 'sound/items/handling/component_drop.ogg'
	pickup_sound = 'sound/items/handling/component_pickup.ogg'

/obj/item/assembly/voice/Initialize(mapload)
	. = ..()
	become_hearing_sensitive(ROUNDSTART_TRAIT)

/obj/item/assembly/voice/examine(mob/user)
	. = ..()
	. += span_notice("使用多功能工具在“包含”、“排除”、“识别器”和“语音传感器”模式之间切换。")

/obj/item/assembly/voice/Hear(atom/movable/speaker, message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range)
	. = ..()
	if(message_mods[WHISPER_MODE] || message_mods[MODE_RELAY]) //Too quiet lad
		return FALSE
	if(speaker == src)
		return FALSE

	// raw_message can contain multiple spaces between words etc which are not seen in chat due to HTML rendering
	// this means if the teller records a message with e.g. double spaces or tabs, other people will not be able to trigger the sensor since they don't know how to perform the same combination
	raw_message = htmlrendertext(raw_message)

	if(listening && !radio_freq)
		record_speech(speaker, raw_message, message_language)
	else
		if(check_activation(speaker, raw_message))
			send_pulse()
	return HEAR_HEARD | HEAR_UNDERSTOOD

/obj/item/assembly/voice/proc/record_speech(atom/movable/speaker, raw_message, datum/language/message_language)
	switch(mode)
		if(INCLUSIVE_MODE)
			recorded = raw_message
			listening = FALSE
			say("Activation message is '[recorded]'.", sanitize = FALSE, language = message_language)
		if(EXCLUSIVE_MODE)
			recorded = raw_message
			listening = FALSE
			say("Activation message is '[recorded]'.", sanitize = FALSE, language = message_language)
		if(RECOGNIZER_MODE)
			recorded = speaker.get_voice()
			listening = FALSE
			say("Your voice pattern is saved.", language = message_language)
		if(VOICE_SENSOR_MODE)
			if(length(raw_message))
				send_pulse()

/obj/item/assembly/voice/proc/check_activation(atom/movable/speaker, raw_message)
	if (recorded == "")
		return FALSE

	switch(mode)
		if(INCLUSIVE_MODE)
			if(findtext(raw_message, recorded))
				return TRUE
		if(EXCLUSIVE_MODE)
			if(raw_message == recorded)
				return TRUE
		if(RECOGNIZER_MODE)
			if(speaker.get_voice() == recorded)
				return TRUE
		if(VOICE_SENSOR_MODE)
			if(length(raw_message))
				return TRUE

	return FALSE

/obj/item/assembly/voice/proc/send_pulse()
	visible_message("咔哒一声。", visible_message_flags = EMOTE_MESSAGE)
	playsound(src, 'sound/effects/whirthunk.ogg', 30)
	addtimer(CALLBACK(src, PROC_REF(pulse)), 2 SECONDS)

/obj/item/assembly/voice/multitool_act(mob/living/user, obj/item/I)
	..()
	mode %= modes.len
	mode++
	to_chat(user, span_notice("你将[src]设置为[modes[mode]]模式。"))
	listening = FALSE
	recorded = ""
	return TRUE

/obj/item/assembly/voice/activate()
	if(!secured || holder)
		return FALSE
	listening = !listening
	say("[listening ? "Now" : "No longer"] recording input.")
	return TRUE

/obj/item/assembly/voice/attack_self(mob/user)
	if(!user)
		return FALSE
	activate()
	return TRUE

/obj/item/assembly/voice/toggle_secure()
	. = ..()
	listening = FALSE

#undef INCLUSIVE_MODE
#undef EXCLUSIVE_MODE
#undef RECOGNIZER_MODE
#undef VOICE_SENSOR_MODE
