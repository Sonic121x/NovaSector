GAME_VERB_DESC(/client, looc, "LOOC", "Local OOC, seen only by those in view.", "OOC", msg as text)
	looc_message(msg)

GAME_VERB_DESC(/client, looc_wallpierce, "LOOC(Wallpierce)", "Local OOC, seen by anyone within 7 tiles of you.", "OOC", msg as text)
	looc_message(msg, TRUE)

/client/proc/looc_message(msg, wall_pierce)
	if(GLOB.say_disabled)
		to_chat(usr, span_danger(LANG("client.b79ad8a3", null)))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!holder)
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger(LANG("client.0ac8d871", null)))
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, span_boldannounce(LANG("client.79757764", null)))
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(prefs.muted & MUTE_LOOC)
			to_chat(src, span_danger(LANG("client.ef695a82", null)))
			return
		if(is_banned_from(ckey, BAN_LOOC))
			to_chat(src, span_warning(LANG("client.a65462e3", null)))
			return
		if(mob.stat == DEAD)
			to_chat(src, span_danger(LANG("client.ccffee2a", null)))
			return
		if(istype(mob, /mob/dead))
			to_chat(src, span_danger(LANG("client.a156ab3b", null)))
			return

	msg = emoji_parse(msg)

	mob.log_talk(msg,LOG_OOC, tag="LOOC")
	var/list/heard
	//so the ai can post looc text
	if(istype(mob, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/ai = mob
		if(wall_pierce)
			heard = get_hearers_in_looc_range(ai.eyeobj)
		else
			heard = get_hearers_in_view(LOOC_RANGE, ai.eyeobj)
	else
		if(wall_pierce)
			heard = get_hearers_in_looc_range(mob.get_top_level_mob())
		else
			heard = get_hearers_in_view(LOOC_RANGE, mob.get_top_level_mob())

	heard = mob_only_listeners(heard)

	var/list/admin_seen = list()
	for(var/mob/hearing as anything in heard)
		var/client/hearing_client = hearing.client
		if(isnull(hearing_client))
			continue

		var/is_holder = hearing_client.holder
		if (is_holder)
			admin_seen[hearing_client] = TRUE
			// dont continue here, still need to show runechat

		if (isobserver(hearing) && !is_holder)
			continue //ghosts dont hear looc, apparantly

		// do the runetext here so admins can still get the runetext
		if(mob.runechat_prefs_check(hearing_client.mob) && hearing_client.prefs.read_preference(/datum/preference/toggle/enable_looc_runechat))
			// EMOTE is close enough. We don't want it to treat the raw message with languages.
			// I wish it didn't include the asterisk but it's modular this way.
			hearing_client.mob?.create_chat_message(mob, raw_message = "(LOOC: [msg])", runechat_flags = EMOTE_MESSAGE)

		if (is_holder)
			continue //admins are handled afterwards

		to_chat(hearing_client, span_looc(span_prefix(LANG("client.a8a84979", list(wall_pierce ? " (WALL PIERCE)" : "", src.mob.name, msg)))), avoid_highlighting = (hearing_client == src))

	for(var/client/cli_client as anything in GLOB.admins)
		if (admin_seen[cli_client])
			to_chat(cli_client, span_looc(LANG("client.ddee0ba1", list(ADMIN_FLW(usr), wall_pierce ? " (WALL PIERCE)" : "", src.key, src.mob.name, msg))), avoid_highlighting = (cli_client == src))
		else if (cli_client.prefs.read_preference(/datum/preference/toggle/admin/see_looc))
			to_chat(cli_client, span_rlooc(LANG("client.a21ff7fd", list(ADMIN_FLW(usr), wall_pierce ? " (WALL PIERCE)" : "", src.key, src.mob.name, msg))), avoid_highlighting = (cli_client == src))
