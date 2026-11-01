/**
 * Join links in deadchat go through the controller rather than straight to the lobby: a link to a
 * lobby that has since been deleted is dropped by BYOND without reaching any Topic, and joining a
 * lobby whose match already started is silently ignored, so either way the click did nothing.
 * The controller always exists and can tell the ghost why.
 */
/datum/deathmatch_controller/Topic(href, href_list)
	. = ..()
	if(!href_list["join"])
		return
	var/mob/dead/observer/ghost = usr
	if(!istype(ghost))
		return
	var/datum/deathmatch_lobby/lobby
	for(var/host in lobbies)
		if(REF(lobbies[host]) == href_list["lobby"])
			lobby = lobbies[host]
			break
	if(isnull(lobby))
		to_chat(ghost, span_warning(LANG("datum.649753b430652ef1", null)))
		return
	if(lobby.playing)
		to_chat(ghost, span_warning(LANG("datum.031046fbb9fb3c9c", null)))
		return
	lobby.join(ghost)
