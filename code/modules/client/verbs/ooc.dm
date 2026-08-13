// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
GLOBAL_VAR_INIT(OOC_COLOR, null)//If this is null, use the CSS for OOC. Otherwise, use a custom colour.
GLOBAL_VAR_INIT(normal_ooc_colour, "#002eb8")

///talking in OOC uses this
GAME_VERB(/client, ooc, VERB_OOC, null)
	VERB_ARG(msg, VERB_ARG_TYPE_TEXT, VERB_ARG_SOURCE_INPUT)
	if(GLOB.say_disabled) //This is here to try to identify lag problems
		to_chat(usr, span_danger(LANG("client.b79ad8a3", null)))
		return

	var/client_initalized = VALIDATE_CLIENT_INITIALIZATION(src)
	if(isnull(mob) || !client_initalized)
		if(!client_initalized)
			unvalidated_client_error() // we only want to throw this warning message when it's directly related to client failure.

		to_chat(usr, span_warning(LANG("client.384eafcb", list(span_big(msg)))))
		return

	if(isnull(holder))
		if(!GLOB.ooc_allowed)
			to_chat(src, span_danger(LANG("client.e44735a2", null)))
			return
		if(!GLOB.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, span_danger(LANG("client.ff2d29bb", null)))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger(LANG("client.058db9ff", null)))
			return
	if(is_banned_from(ckey, "OOC"))
		to_chat(src, span_danger(LANG("client.aaaae170", null)))
		return
	if(QDELETED(src))
		return

	msg = trim(copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN))
	var/raw_msg = msg

	var/list/filter_result = is_ooc_filtered(msg)
	if (!CAN_BYPASS_FILTER(usr) && filter_result)
		REPORT_CHAT_FILTER_TO_USER(usr, filter_result)
		log_filter("OOC", msg, filter_result)
		return

	// Protect filter bypassers from themselves.
	// Demote hard filter results to soft filter results if necessary due to the danger of accidentally speaking in OOC.
	var/list/soft_filter_result = filter_result || is_soft_ooc_filtered(msg)

	if (soft_filter_result)
		if(tgui_alert(usr,LANG("client.6308a68e", list(soft_filter_result[CHAT_FILTER_INDEX_WORD], soft_filter_result[CHAT_FILTER_INDEX_REASON])), LANG("client.b0fe106c", null), list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[html_encode(msg)]\"")
		log_admin_private("[key_name(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[msg]\"")

	if(!msg)
		return

	msg = emoji_parse(msg)

	if(SSticker.HasRoundStarted() && ((msg[1] in list(".",";",":","#")) || findtext_char(msg, "say", 1, 5)))
		if(tgui_alert(usr,LANG("client.296c835c", list(raw_msg)), LANG("client.11754bf0", null), list("Yes", "No")) != "Yes")
			return

	if(!holder)
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, span_boldannounce(LANG("client.6044b5d6", null)))
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	if(!(get_chat_toggles(src) & CHAT_OOC))
		to_chat(src, span_danger(LANG("client.a877c979", null)))
		return

	mob.log_talk(raw_msg, LOG_OOC)

	var/keyname = key
	var/list/key_tags
	var/key_prefix = ""
	var/visible_unlock = prefs.unlock_content && (prefs.toggles & MEMBER_PUBLIC)

	// heart first lol
	if(prefs.hearted)
		LAZYADD(key_tags, "emoji-heart")
	if(visible_unlock)
		LAZYADD(key_tags, "byond_member")
	// NOVA EDIT ADDITION START - Donator icons in OOC
	var/is_donator = SSplayer_ranks.is_donator(src)
	if(is_donator && prefs.read_preference(/datum/preference/toggle/display_donator_status))
		LAZYADD(key_tags, "nova_donator")
	// NOVA EDIT ADDITION END

	if(LAZYLEN(key_tags))
		var/datum/asset/spritesheet_batched/chat/sheet = get_asset_datum(/datum/asset/spritesheet_batched/chat)
		for(var/icon_name in key_tags)
			key_prefix = "[key_prefix][sheet.icon_tag(icon_name)]"
		key_prefix = "<span style='vertical-align: text-top; padding-right: 0.2em'>[key_prefix]</span>"

	keyname = "[key_prefix][keyname]"

	if(visible_unlock || is_donator) // NOVA EDIT CHANGE - ORIGINAL: if(visible_unlock)
		keyname = "<font color='[prefs.read_preference(/datum/preference/color/ooc_color) || GLOB.normal_ooc_colour]'>[keyname]</font>"

	//The linkify span classes and linkify=TRUE below make ooc text get clickable chat href links if you pass in something resembling a url
	for(var/client/receiver as anything in GLOB.clients)
		if(!receiver.prefs) // Client being created or deleted. Despite all, this can be null.
			continue
		if(!(get_chat_toggles(receiver) & CHAT_OOC))
			continue
		if(holder?.fakekey in receiver.prefs.ignoring)
			continue
		var/avoid_highlight = receiver == src
		if(holder)
			if(!holder.fakekey || receiver.holder)
				if(check_rights_for(src, R_ADMIN))
					var/ooc_color = ooc_colour ? ooc_colour : prefs.read_preference(/datum/preference/color/ooc_color)
					to_chat(receiver, span_adminooc("[CONFIG_GET(flag/allow_admin_ooccolor) && ooc_color ? "<font color=[ooc_color]>" :"" ][span_prefix("OOC:")] <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]</span>"), avoid_highlighting = avoid_highlight)
				else
					to_chat(receiver, span_adminobserverooc(span_prefix(LANG("client.e7be096b", list(keyname, holder.fakekey ? "/([holder.fakekey])" : "", msg)))), avoid_highlighting = avoid_highlight)
			else
				if(GLOB.OOC_COLOR)
					to_chat(receiver, "<span class='oocplain'><font color='[GLOB.OOC_COLOR]'><b>[span_prefix("OOC:")] <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message linkify'>[msg]</span></b></font></span>", avoid_highlighting = avoid_highlight)
				else
					to_chat(receiver, span_ooc(span_prefix(LANG("client.e41c9dd4", list(holder.fakekey ? holder.fakekey : key, msg)))), avoid_highlighting = avoid_highlight)

		else if(!(key in receiver.prefs.ignoring))
			if(ooc_colour)
				to_chat(receiver, "<span class='oocplain'><font color='[ooc_colour]'><b>[span_prefix("OOC:")] <EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></b></font></span>", avoid_highlighting = avoid_highlight)
			else if(GLOB.OOC_COLOR)
				to_chat(receiver, "<span class='oocplain'><font color='[GLOB.OOC_COLOR]'><b>[span_prefix("OOC:")] <EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></b></font></span>", avoid_highlighting = avoid_highlight)
			else
				to_chat(receiver, span_ooc(span_prefix(LANG("client.e41c9dd4", list(keyname, msg)))), avoid_highlighting = avoid_highlight)


/proc/toggle_ooc(toggle = null)
	if(toggle != null) //if we're specifically en/disabling ooc
		if(toggle != GLOB.ooc_allowed)
			GLOB.ooc_allowed = toggle
		else
			return
	else //otherwise just toggle it
		GLOB.ooc_allowed = !GLOB.ooc_allowed
	to_chat(world, LANG("_root.636a249b", list(GLOB.ooc_allowed ? "enabled" : "disabled")))

/proc/toggle_dooc(toggle = null)
	if(toggle != null)
		if(toggle != GLOB.dooc_allowed)
			GLOB.dooc_allowed = toggle
		else
			return
	else
		GLOB.dooc_allowed = !GLOB.dooc_allowed

ADMIN_VERB(set_ooc_color, R_FUN, "设置玩家 OOC 颜色", "Modifies the global OOC color.", ADMIN_CATEGORY_SERVER)
	var/newColor = tgui_color_picker(user, "Please select the new player OOC color.", "OOC color")
	if(isnull(newColor))
		return
	var/new_color = sanitize_color(newColor)
	message_admins("[key_name_admin(user)] has set the players' ooc color to [new_color].")
	log_admin("[key_name_admin(user)] has set the player ooc color to [new_color].")
	GLOB.OOC_COLOR = new_color

ADMIN_VERB(reset_ooc_color, R_FUN, "重置玩家 OOC 颜色", "Returns player OOC color to default.", ADMIN_CATEGORY_SERVER)
	if(tgui_alert(user, LANG("datum.26e132eb", null), LANG("datum.53dce6c2", null), list("Yes", "No")) != "Yes")
		return
	message_admins("[key_name_admin(user)] has reset the players' ooc color.")
	log_admin("[key_name_admin(user)] has reset player ooc color.")
	GLOB.OOC_COLOR = null

//Checks admin notice
GAME_VERB_DESC(/client, admin_notice, "管理员通知", "Check the admin notice if it has been set", "Admin")
	if(GLOB.admin_notice)
		to_chat(src, LANG("client.4311435f", list(span_boldnotice("Admin Notice:"), GLOB.admin_notice)))
	else
		to_chat(src, span_notice(LANG("client.9b2b211e", null)))

GAME_VERB_DESC(/client, motd, "MOTD", "Check the Message of the Day", "OOC")
	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<span class='infoplain'><div class=\"motd\">[motd]</div></span>", handle_whitespace=FALSE)
	else
		to_chat(src, span_notice(LANG("client.f74ead16", null)))

GAME_VERB_PROC_DESC(/client, self_notes, "查看管理员备注", "View the notes that admins have written about you", "OOC")

	if(!CONFIG_GET(flag/see_own_notes))
		to_chat(usr, span_notice(LANG("client.3f633650", null)))
		return

	browse_messages(null, usr.ckey, null, TRUE)

GAME_VERB_PROC_DESC(/client, self_playtime, "查看记录的游玩时间", "View the amount of playtime for roles the server has tracked.", "OOC")

	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, span_notice(LANG("client.8cad0082", null)))
		return

	new /datum/job_report_menu(src, usr)

// Ignore verb
GAME_VERB_DESC(/client, select_ignore, "忽略", "Ignore a player's messages on the OOC channel", "OOC")
	// Make a list to choose players from
	var/list/players = list()

	// Use keys and fakekeys for the same purpose
	var/displayed_key = ""

	// Try to add every player who's online to the list
	for(var/client/C in GLOB.clients)
		// Don't add ourself
		if(C == src)
			continue

		// Don't add players we've already ignored if they're not using a fakekey
		if((C.key in prefs.ignoring) && !C.holder?.fakekey)
			continue

		// Don't add players using a fakekey we've already ignored
		if(C.holder?.fakekey in prefs.ignoring)
			continue

		// Use the player's fakekey if they're using one
		if(C.holder?.fakekey)
			displayed_key = C.holder.fakekey

		// Use the player's key if they're not using a fakekey
		else
			displayed_key = C.key

		// Check if both we and the player are ghosts and they're not using a fakekey
		if(isobserver(mob) && isobserver(C.mob) && !C.holder?.fakekey)
			// Show us if the player is a ghost or not after their displayed key
			// Add the player's displayed key to the list
			players["[displayed_key](ghost)"] = displayed_key

		// Add the player's displayed key to the list if we or the player aren't a ghost or they're using a fakekey
		else
			players[displayed_key] = displayed_key

	// Check if the list is empty
	if(!length(players))
		// Express that there are no players we can ignore in chat
		to_chat(src, span_infoplain(LANG("client.7fef25cf", null)))

		// Stop running
		return

	// Sort the list
	players = sort_list(players)

	// Request the player to ignore
	var/selection = tgui_input_list(src, LANG("client.6123f9f9", null), LANG("client.284fb6b0", null), players)

	// Stop running if we didn't receieve a valid selection
	if(isnull(selection) || !(selection in players))
		return

	// Store the selected player
	selection = players[selection]

	// Check if the selected player is on our ignore list
	if(selection in prefs.ignoring)
		// Express that the selected player is already on our ignore list in chat
		to_chat(src, span_infoplain(LANG("client.6ac3c5f5", list(selection))))

		// Stop running
		return

	// Add the selected player to our ignore list
	prefs.ignoring.Add(selection)

	// Save our preferences
	prefs.save_preferences()

	// Express that we've ignored the selected player in chat
	to_chat(src, span_infoplain(LANG("client.4185e6d3", list(selection))))

// Unignore verb
GAME_VERB_DESC(/client, select_unignore, "取消忽略", "Stop ignoring a player's messages on the OOC channel", "OOC")
	// Check if we've ignored any players
	if(!length(prefs.ignoring))
		// Express that we haven't ignored any players in chat
		to_chat(src, span_infoplain(LANG("client.a078a38d", null)))

		// Stop running
		return

	// Request the player to unignore
	var/selection = tgui_input_list(src, LANG("client.6123f9f9", null), LANG("client.7b269124", null), prefs.ignoring)

	// Stop running if we didn't receive a selection
	if(isnull(selection))
		return

	// Check if the selected player is not on our ignore list
	if(!(selection in prefs.ignoring))
		// Express that the selected player is not on our ignore list in chat
		to_chat(src, span_infoplain(LANG("client.079cbe60", list(selection))))

		// Stop running
		return

	// Remove the selected player from our ignore list
	prefs.ignoring.Remove(selection)

	// Save our preferences
	prefs.save_preferences()

	// Express that we've unignored the selected player in chat
	to_chat(src, span_infoplain(LANG("client.abb0f938", list(selection))))

GAME_VERB_PROC_DESC(/client, show_previous_roundend_report, "你的上一回合", "View the last round end report you've seen", "OOC")

	SSticker.show_roundend_report(src, report_type = PERSONAL_LAST_ROUND)

GAME_VERB_PROC_DESC(/client, show_servers_last_roundend_report, "服务器上一回合", "View the last round end report from this server", "OOC")

	SSticker.show_roundend_report(src, report_type = SERVER_LAST_ROUND)

GAME_VERB_DESC(/client, fit_viewport, "适应视口", "Fit the width of the map window to match the viewport", "OOC")
	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/list/sizes = params2list(winget(src, "[SKIN_MAINWINDOW_SPLIT];[SKIN_MAPWINDOW]", "size"))

	// Client closed the window? Some other error? This is unexpected behaviour, let's
	// CRASH with some info.
	if(!sizes["[SKIN_MAPWINDOW].size"])
		CRASH("sizes does not contain mapwindow.size key. This means a winget failed to return what we wanted. --- sizes var: [sizes] --- sizes length: [length(sizes)]")

	var/list/map_size = splittext(sizes["[SKIN_MAPWINDOW].size"], "x")

	var/split_size = splittext(sizes["[SKIN_MAINWINDOW_SPLIT].size"], "x")
	var/split_width = text2num(split_size[1])

	// Window is minimized, we can't get proper data so return to avoid division by 0
	if (!split_width)
		return

	// Gets the type of zoom we're currently using from our view datum
	// If it's 0 we do our pixel calculations based off the size of the mapwindow
	// If it's not, we already know how big we want our window to be, since zoom is the exact pixel ratio of the map
	var/zoom_value = src.view_size?.zoom || 0

	var/desired_width = 0
	if(zoom_value)
		desired_width = round(view_size[1] * zoom_value * ICON_SIZE_X)
	else

		// Looks like we expect mapwindow.size to be "ixj" where i and j are numbers.
		// If we don't get our expected 2 outputs, let's give some useful error info.
		if(length(map_size) != 2)
			CRASH("map_size of incorrect length --- map_size var: [map_size] --- map_size length: [length(map_size)]")
		var/height = text2num(map_size[2])
		desired_width = round(height * aspect_ratio)

	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	// Avoid auto-resizing the statpanel and chat into nothing.
	desired_width = min(desired_width, split_width - 300)

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, SKIN_MAINWINDOW_SPLIT, "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, SKIN_MAPWINDOW, "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		winset(src, SKIN_MAINWINDOW_SPLIT, "splitter=[pct]")

/// Attempt to automatically fit the viewport, assuming the user wants it
/client/proc/attempt_auto_fit_viewport()
	if (!prefs?.read_preference(/datum/preference/toggle/auto_fit_viewport))
		return
	// No need to attempt to fit the viewport on non-initialized clients as they'll auto-fit viewport right before finishing init
	if(fully_created)
		INVOKE_ASYNC(src, VERB_REF(fit_viewport))

GAME_VERB_DESC(/client, policy, "显示政策", "Show special server rules related to your current character.", "OOC")
	//Collect keywords
	var/list/keywords = mob.get_policy_keywords()
	var/header = get_policy(POLICY_VERB_HEADER)
	var/list/policytext = list(header)
	var/anything = FALSE
	for(var/keyword in keywords)
		var/p = get_policy(keyword)
		if(p)
			policytext += p
			policytext += "<hr>"
			anything = TRUE
	if(!anything)
		policytext += "No related rules found."

	var/datum/browser/browser = new(usr, "policy", "Server Policy", 600, 500)
	browser.set_content(policytext.Join(""))
	browser.open()

GAME_VERB_HIDDEN(/client, fix_stat_panel, "修复状态面板")
	init_verbs()

GAME_VERB_PROC_DESC(/client, export_preferences, "导出偏好设置", "Export your current preferences to a file.", "OOC")

	ASSERT(prefs, "User attempted to export preferences while preferences were null!") // what the fuck

	prefs.savefile.export_json_to_client(usr, ckey)

GAME_VERB_DESC(/client, map_vote_tally_count, "显示地图投票统计", "View the current map vote tally counts.", "OOC")
	to_chat(mob, SSmap_vote.tally_printout)


GAME_VERB_DESC(/client, linkforumaccount, "关联论坛账号", "Validates your byond account to your forum account. Required to post on the forums.", "OOC")
	var/uri = CONFIG_GET(string/forum_link_uri)
	if(!uri)
		to_chat(src, span_warning(LANG("client.882f982c", null)))
		return

	if (!SSdbcore.Connect())
		to_chat(src, span_danger(LANG("client.a2fe5725", null)))
		return

	if  (is_guest_key(ckey))
		to_chat(src, span_danger(LANG("client.128e3843", null)))
		return

	var/token = generate_account_link_token()

	var/datum/db_query/query_set_token = SSdbcore.NewQuery("INSERT INTO phpbb.tg_byond_oauth_tokens (`token`, `key`) VALUES (:token, :key)", list("token" = token, "key" = key))
	if(!query_set_token.Execute())
		to_chat(src, span_danger(LANG("client.bec52bf6", null)))
		qdel(query_set_token)
		return

	qdel(query_set_token)

	to_chat(src, LANG("client.566925c9", list(uri, token, uri, token)))
	src << link("[uri]?token=[token]")

/client/proc/generate_account_link_token()
	var/static/entropychain
	if (!entropychain)
		if (fexists("data/entropychain.txt"))
			entropychain = file2text("entropychain.txt")
		else
			entropychain = "LOL THERE IS NO ENTROPY #HEATDEATH"
	else if (prob(rand(1,15)))
		text2file("data/entropychain.txt", entropychain)

	var/datum/db_query/query_get_token = SSdbcore.NewQuery("SELECT [random_string()], [random_string()]", list(random_string_args(entropychain), random_string_args(entropychain)))

	if(!query_get_token.Execute())
		to_chat(src, span_danger(LANG("client.6a89b42c", null)))
		qdel(query_get_token)
		return

	if(!query_get_token.NextRow())
		to_chat(src, span_danger(LANG("client.122a5fe9", null)))
		qdel(query_get_token)
		return

	entropychain = "[query_get_token.item[2]]"
	return query_get_token.item[1]


/client/proc/random_string()
	return "SHA2(CONCAT(RAND(),UUID(),?,RAND(),UUID()), 512)"

/client/proc/random_string_args(entropychain)
	return "[entropychain][GUID()][rand()*rand(999999)][world.time][GUID()][rand()*rand(999999)][world.timeofday][GUID()][rand()*rand(999999)][world.realtime][GUID()][rand()*rand(999999)][time2text(world.timeofday)][GUID()][rand()*rand(999999)][world.tick_usage][computer_id][address][ckey][key][GUID()][rand()*rand(999999)]"
