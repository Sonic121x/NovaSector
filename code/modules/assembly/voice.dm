// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define INCLUSIVE_MODE 1
#define EXCLUSIVE_MODE 2
#define RECOGNIZER_MODE 3
#define VOICE_SENSOR_MODE 4

/obj/item/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.5)
	assembly_behavior = ASSEMBLY_TOGGLEABLE_INPUT
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
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
	. += span_notice(LANG("obj.bf306f89df98e998", null))

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
			say(LANG("obj.3a309903fe3221ea", list(recorded)), sanitize = FALSE, language = message_language)
		if(EXCLUSIVE_MODE)
			recorded = raw_message
			listening = FALSE
			say(LANG("obj.3a309903fe3221ea", list(recorded)), sanitize = FALSE, language = message_language)
		if(RECOGNIZER_MODE)
			recorded = speaker.get_voice()
			listening = FALSE
			say(LANG("obj.d629613e2d2a9d6f", null), language = message_language)
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
	visible_message(LANG("obj.c72c06d52ce5d4a2", null), visible_message_flags = EMOTE_MESSAGE)
	playsound(src, 'sound/effects/whirthunk.ogg', 30)
	addtimer(CALLBACK(src, PROC_REF(pulse)), 2 SECONDS)

/obj/item/assembly/voice/multitool_act(mob/living/user, obj/item/I)
	..()
	mode %= modes.len
	mode++
	to_chat(user, span_notice(LANG("obj.f0df0b23d6add4da", list(src, modes[mode]))))
	listening = FALSE
	recorded = ""
	return TRUE

/obj/item/assembly/voice/activate()
	if(!secured || holder)
		return FALSE
	listening = !listening
	say(LANG("obj.ec82e5802b5f2277", list(listening ? "Now" : "No longer")))
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
