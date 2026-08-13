GLOBAL_VAR_INIT(AOOC_COLOR, "#de3c8c")
GLOBAL_VAR_INIT(aooc_allowed, TRUE)	// used with admin verbs to disable aooc - not a config option
GLOBAL_LIST_EMPTY(ckey_to_aooc_name)

#define AOOC_LISTEN_PLAYER 1
#define AOOC_LISTEN_ADMIN 2

GAME_VERB(/client, aooc, "反派 OOC", "OOC")
	VERB_ARG(msg, VERB_ARG_TYPE_TEXT, VERB_ARG_SOURCE_INPUT)
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger(LANG("client.b79ad8a3", null)))
		return

	if(!mob)
		return

	if(!holder)
		if(!mob.mind || !length(mob.mind.antag_datums))
			to_chat(src, span_danger(LANG("client.64888d23", null)))
			return
		if(!GLOB.aooc_allowed)
			to_chat(src, span_danger(LANG("client.af6892f5", null)))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger(LANG("client.058db9ff", null)))
			return
	if(is_banned_from(ckey, "OOC"))
		to_chat(src, span_danger(LANG("client.aaaae170", null)))
		return
	if(QDELETED(src))
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	var/raw_msg = msg

	if(!msg)
		return

	msg = emoji_parse(msg)

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger(LANG("client.a877c979", null)))
		return

	mob.log_talk(raw_msg, LOG_OOC, tag = "AOOC")

	var/keyname = key
	var/anon = FALSE

	//Anonimity for players and deadminned admins
	if(!holder || holder.deadmined)
		if(!GLOB.ckey_to_aooc_name[key])
			GLOB.ckey_to_aooc_name[key] = "Operator [pick(GLOB.phonetic_alphabet)] [rand(1, 99)]"
		keyname = GLOB.ckey_to_aooc_name[key]
		anon = TRUE

	var/list/listeners = list()

	for(var/mind in get_antag_minds(/datum/antagonist))
		var/datum/mind/antag_mind = mind
		if(!antag_mind.current || !antag_mind.current.client || isnewplayer(antag_mind.current))
			continue
		listeners[antag_mind.current.client] = AOOC_LISTEN_PLAYER

	for(var/iterated_player in GLOB.player_list)
		var/mob/iterated_mob = iterated_player
		//Admins with muted OOC do not get to listen to AOOC, but normal players do, as it could be admins talking important stuff to them
		if(iterated_mob.client?.holder && !iterated_mob.client?.holder.deadmined && iterated_mob.client?.prefs?.chat_toggles & CHAT_OOC)
			listeners[iterated_mob.client] = AOOC_LISTEN_ADMIN

	for(var/client/iterated_client as anything in listeners)
		var/mode = listeners[iterated_client]
		var/color = (!anon && CONFIG_GET(flag/allow_admin_ooccolor) && iterated_client?.prefs?.read_preference(/datum/preference/color/ooc_color)) ? iterated_client?.prefs?.read_preference(/datum/preference/color/ooc_color) : GLOB.AOOC_COLOR
		var/name = (mode == AOOC_LISTEN_ADMIN && anon) ? "([key])[keyname]" : keyname
		to_chat(iterated_client, span_oocplain(LANG("client.0600bf7a", list(color, name, msg))), avoid_highlighting = (iterated_client == src))

#undef AOOC_LISTEN_PLAYER
#undef AOOC_LISTEN_ADMIN

/proc/toggle_aooc(toggle = null)
	if(toggle != null) //if we're specifically en/disabling aooc
		if(toggle == GLOB.aooc_allowed)
			return
		GLOB.aooc_allowed = toggle
	else //otherwise just toggle it
		GLOB.aooc_allowed = !GLOB.aooc_allowed
	var/list/listeners = list()
	for(var/mind in get_antag_minds(/datum/antagonist))
		var/datum/mind/antag_mind = mind
		if(!antag_mind.current || !antag_mind.current.client || isnewplayer(antag_mind.current))
			continue
		listeners[antag_mind.current.client] = TRUE

	for(var/iterated_player in GLOB.player_list)
		var/mob/iterated_mob = iterated_player
		if(!iterated_mob.client?.holder?.deadmined)
			listeners[iterated_mob.client] = TRUE
	for(var/iterated_listener in listeners)
		var/client/iterated_client = iterated_listener
		to_chat(iterated_client, span_oocplain(LANG("_root.9dcf1da5", list(GLOB.aooc_allowed ? "enabled" : "disabled"))))

ADMIN_VERB(toggleaooc, R_ADMIN, "切换反派 OOC", "Toggles Antag OOC.", ADMIN_CATEGORY_SERVER)
	toggle_aooc()
	log_admin("[key_name(usr)] toggled Antagonist OOC.")
	message_admins("[key_name_admin(usr)] toggled Antagonist OOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Antag OOC", "[GLOB.aooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
