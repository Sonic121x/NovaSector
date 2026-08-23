#define SUBTLE_DEFAULT_DISTANCE world.view
#define SUBTLE_ONE_TILE 1
#define SUBTLE_SAME_TILE_DISTANCE 0

#define SUBTLE_ONE_TILE_TEXT "1-Tile Range"
#define SUBTLE_SAME_TILE_TEXT "Same Tile"

/datum/emote/living/subtle
	key = "subtle"
	key_third_person = "subtle"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)

/datum/config_entry/flag/play_subtler_sound
	default = TRUE

/datum/preference/toggle/subtler_sound
	savefile_key = "subtler_sound"
	savefile_identifier = PREFERENCE_PLAYER
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE

/datum/emote/living/subtle/run_emote(mob/user, params, type_override, intentional)
	if(!can_run_emote(user))
		to_chat(user, span_warning(LANG("datum.2fa88e98cb3fcf6a", null)))
		return FALSE
	var/subtle_message
	var/subtle_emote = params
	if(SSdbcore.IsConnected() && is_banned_from(user, "emote"))
		to_chat(user, LANG("datum.b71c017a5d2e9c38", null))
		return FALSE
	else if(user.client?.prefs.muted & MUTE_IC)
		to_chat(user, LANG("datum.edad7622f650b603", null))
		return FALSE
	else if(!params)
		subtle_emote = tgui_input_text(user, LANG("datum.b0c1d36db5b1dee5", null), LANG("datum.94ebb5ba30139b11", null), null, max_length = MAX_MESSAGE_LEN, multiline = TRUE)
		if(!subtle_emote)
			return FALSE
		subtle_message = subtle_emote
	else
		subtle_message = params

	var/running_emote_type = type_override || emote_type

	if(!can_run_emote(user))
		to_chat(user, span_warning(LANG("datum.2fa88e98cb3fcf6a", null)))
		return FALSE

	user.log_message(subtle_message, LOG_SUBTLE)

	var/space = should_have_space_before_emote(html_decode(subtle_emote)[1]) ? " " : ""

	subtle_message = span_subtle("<b>[user]</b>[space]<i>[user.apply_message_emphasis(subtle_message)]</i>")

	var/list/viewers = get_hearers_in_view(SUBTLE_ONE_TILE, user)

	var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
	if(hologram)
		viewers |= get_hearers_in_view(SUBTLE_ONE_TILE, hologram)
	for(var/obj/item/dullahan_relay/dullahan in viewers)
		viewers -= dullahan
		viewers += dullahan.owner

	for(var/obj/effect/overlay/holo_pad_hologram/iterating_hologram in viewers)
		if(iterating_hologram?.Impersonation?.client)
			viewers |= iterating_hologram.Impersonation

	for(var/mob/ghost as anything in GLOB.dead_mob_list)
		if((ghost.client?.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(ghost in viewers))
			to_chat(ghost, "[FOLLOW_LINK(ghost, user)] [subtle_message]")

	for(var/mob/receiver in viewers)
		if((running_emote_type & EMOTE_LEWD) && !pref_check_emote(receiver, preference = /datum/emote/living/lewd::pref_to_check))
			continue
		receiver.show_message(subtle_message, alt_msg = subtle_message)
		// Optional sound notification
		if(!isobserver(receiver))
			var/datum/preferences/prefs = receiver.client?.prefs
			if(prefs && prefs.read_preference(/datum/preference/toggle/subtler_sound))
				receiver.playsound_local(get_turf(receiver), 'sound/effects/achievement/beeps_jingle.ogg', 50)

	return TRUE

/*
*	SUBTLE 2: NO GHOST BOOGALOO
*/

/datum/emote/living/subtler
	key = "subtler"
	key_third_person = "subtler"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)

/datum/emote/living/subtler/run_emote(mob/user, params, type_override, intentional)
	if(!can_run_emote(user))
		to_chat(user, span_warning(LANG("datum.2fa88e98cb3fcf6a", null)))
		return FALSE
	var/subtler_message
	var/subtler_emote = params
	var/target
	var/subtler_range = SUBTLE_DEFAULT_DISTANCE

	if(SSdbcore.IsConnected() && is_banned_from(user, "emote"))
		to_chat(user, span_warning(LANG("datum.b71c017a5d2e9c38", null)))
		return FALSE
	else if(user.client?.prefs.muted & MUTE_IC)
		to_chat(user, span_warning(LANG("datum.edad7622f650b603", null)))
		return FALSE
	else if(!subtler_emote)
		subtler_emote = tgui_input_text(user, LANG("datum.b0c1d36db5b1dee5", null), LANG("datum.7d3c6a2d646a55ef", null) , max_length = MAX_MESSAGE_LEN, multiline = TRUE)
		if(!subtler_emote)
			return FALSE

		var/list/in_view = get_hearers_in_view(subtler_range, user)

		var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
		if(hologram)
			in_view |= get_hearers_in_view(subtler_range, hologram)

		in_view -= GLOB.dead_mob_list
		in_view.Remove(user)

		for(var/obj/item/dullahan_relay/dullahan in in_view)
			in_view -= dullahan
			if(user != dullahan.owner)
				in_view += dullahan.owner
		for(var/mob/mob in in_view) // Filters out the AI eye and clientless mobs.
			if(!istype(mob, /mob/eye/camera/ai))
				continue
			if(mob.client)
				continue
			in_view.Remove(mob)

		var/list/targets = list(SUBTLE_ONE_TILE_TEXT, SUBTLE_SAME_TILE_TEXT) + in_view
		target = tgui_input_list(user, LANG("datum.153e9cb537804b6c", null), LANG("datum.eb4c7c3f77033760", null), targets)
		if(!target)
			return FALSE

		switch(target)
			if(SUBTLE_ONE_TILE_TEXT)
				target = SUBTLE_ONE_TILE
			if(SUBTLE_SAME_TILE_TEXT)
				target = SUBTLE_SAME_TILE_DISTANCE
		subtler_message = subtler_emote
	else
		target = SUBTLE_ONE_TILE
		subtler_message = subtler_emote

	var/running_emote_type = type_override || emote_type

	if(!can_run_emote(user))
		to_chat(user, span_warning(LANG("datum.2fa88e98cb3fcf6a", null)))
		return FALSE

	user.log_message(subtler_message, LOG_SUBTLER)

	var/space = should_have_space_before_emote(html_decode(subtler_emote)[1]) ? " " : ""

	subtler_message = span_subtler("<b>[user]</b>[space]<i>[user.apply_message_emphasis(subtler_message)]</i>")

	if(istype(target, /mob))
		var/mob/target_mob = target
		user.show_message(subtler_message, alt_msg = subtler_message)
		if((running_emote_type & EMOTE_LEWD) && !pref_check_emote(target_mob, preference = /datum/emote/living/lewd::pref_to_check))
			return FALSE
		var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
		if((get_dist(user.loc, target_mob.loc) <= subtler_range) || (hologram && get_dist(hologram.loc, target_mob.loc) <= subtler_range))
			target_mob.show_message(subtler_message, alt_msg = subtler_message)
			var/datum/preferences/prefs = target_mob.client?.prefs
			if(prefs && prefs.read_preference(/datum/preference/toggle/subtler_sound))
				target_mob.playsound_local(get_turf(target_mob), 'sound/effects/achievement/glockenspiel_ping.ogg', 50)
		else
			to_chat(user, span_warning(LANG("datum.ae2efd701c09ea61", null)))
	else if(istype(target, /obj/effect/overlay/holo_pad_hologram))
		var/obj/effect/overlay/holo_pad_hologram/hologram = target
		if(hologram.Impersonation?.client)
			if((running_emote_type & EMOTE_LEWD) && !pref_check_emote(client = hologram.Impersonation.client, preference = /datum/emote/living/lewd::pref_to_check))
				return FALSE
			hologram.Impersonation.show_message(subtler_message, alt_msg = subtler_message)
			var/datum/preferences/prefs = hologram.Impersonation.client?.prefs
			if(prefs && prefs.read_preference(/datum/preference/toggle/subtler_sound))
				hologram.Impersonation.playsound_local(get_turf(hologram.Impersonation), 'sound/effects/achievement/glockenspiel_ping.ogg', 50)
	else
		var/ghostless = get_hearers_in_view(target, user) - GLOB.dead_mob_list

		var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
		if(hologram)
			ghostless |= get_hearers_in_view(target, hologram)

		for(var/obj/effect/overlay/holo_pad_hologram/holo in ghostless)
			if(holo?.Impersonation?.client)
				ghostless |= holo.Impersonation
		for(var/obj/item/dullahan_relay/dullahan in ghostless)
			ghostless -= dullahan
			ghostless += dullahan.owner

		for(var/mob/receiver in ghostless)
			if((running_emote_type & EMOTE_LEWD) && !pref_check_emote(receiver, preference = /datum/emote/living/lewd::pref_to_check))
				continue
			receiver.show_message(subtler_message, alt_msg = subtler_message)
			var/datum/preferences/prefs = receiver.client?.prefs
			if(prefs && prefs.read_preference(/datum/preference/toggle/subtler_sound))
				receiver.playsound_local(get_turf(receiver), 'sound/effects/achievement/glockenspiel_ping.ogg', 50)

	return TRUE

/*
*	VERB CODE
*/

/mob/living/proc/subtle_keybind()
	var/message = input(src, "", LANG("mob.0bc1d054b43c0453", null)) as text|null
	if(!length(message))
		return
	return subtle(message)

GAME_VERB(/mob/living, subtle, "轻微动作", "IC")
	if(GLOB.say_disabled)	// This is here to try to identify lag problems
		to_chat(usr, span_danger(LANG("mob.b79ad8a388d1b3a4", null)))
		return
	usr.emote("subtle")

/*
*	VERB CODE 2
*/

GAME_VERB(/mob/living, subtler, "轻微动作（幽灵不可见）", "IC")
	if(GLOB.say_disabled)	// This is here to try to identify lag problems
		to_chat(usr, span_danger(LANG("mob.b79ad8a388d1b3a4", null)))
		return
	usr.emote("subtler")

#undef SUBTLE_DEFAULT_DISTANCE
#undef SUBTLE_ONE_TILE
#undef SUBTLE_SAME_TILE_DISTANCE

#undef SUBTLE_ONE_TILE_TEXT
#undef SUBTLE_SAME_TILE_TEXT
