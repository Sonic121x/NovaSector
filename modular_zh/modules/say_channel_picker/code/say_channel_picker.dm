/**
 * Sends the say box the radio channels and languages its user can pick from, so a
 * channel or language can be chosen with the mouse instead of a typed prefix.
 * The say box still sends the usual prefixes (`:e`, `;`, `,x`), so speech parsing is unchanged.
 */
/datum/tgui_say/open(payload)
	. = ..()
	if(.)
		send_speech_options()

/datum/tgui_say/proc/send_speech_options()
	var/mob/user = client?.mob
	if(!user)
		return
	window.send_message("speechOptions", list(
		"channels" = user.say_picker_channels(),
		"languages" = user.say_picker_languages(),
	))

/// Display name of a radio channel or language. Channel names are identifiers compared in
/// English everywhere, so their labels live in a scoped table instead of the reverse catalog.
/proc/say_picker_label(name)
	var/list/table = lang_scoped_table("say_picker_labels.json")
	return table[name] || lang_reverse_text(name)

/// The radio `:x` and `;` prefixes talk into, if any.
/mob/proc/say_picker_radio()
	return null

/mob/living/carbon/human/say_picker_radio()
	return istype(ears, /obj/item/radio) ? ears : null

/mob/living/silicon/say_picker_radio()
	return radio

/// Radio channels as `list(list("prefix" = ":e", "name" = display name), ...)`, common first.
/mob/proc/say_picker_channels()
	var/list/channels = list()
	var/obj/item/radio/radio = say_picker_radio()
	if(!istype(radio))
		return channels
	channels += list(list("prefix" = RADIO_KEY_COMMON, "name" = say_picker_label(RADIO_CHANNEL_COMMON)))
	for(var/channel in radio.channels)
		var/token = GLOB.channel_tokens[channel]
		if(token && token != RADIO_KEY_COMMON)
			channels += list(list("prefix" = token, "name" = say_picker_label(channel)))
	if(issilicon(src) || (radio.special_channels & RADIO_SPECIAL_BINARY))
		channels += list(list("prefix" = MODE_TOKEN_BINARY, "name" = say_picker_label(MODE_BINARY)))
	return channels

/// Ghosts speak in deadchat, which ignores language prefixes (and they "know" every language).
/mob/dead/say_picker_languages()
	return list()

/// Spoken languages with a prefix key, as `list(list("prefix" = ",x", "name" = display name, "selected" = bool), ...)`.
/mob/proc/say_picker_languages()
	var/list/languages = list()
	var/datum/language/selected = get_selected_language()
	for(var/datum/language/language as anything in GLOB.all_languages)
		var/key = initial(language.key)
		if(!key || !can_speak_language(language))
			continue
		languages += list(list(
			"prefix" = ",[key]",
			"name" = say_picker_label(initial(language.name)),
			"selected" = language == selected,
		))
	return languages
