GAME_VERB_PROC(/client, cmd_mentor_dementor, "摄魂怪", "Mentor")
	if(!is_mentor())
		return
	remove_mentor_verbs()
	if (/client/proc/mentor_unfollow in verbs)
		mentor_unfollow()
	GLOB.mentors -= src
	to_chat(src, span_interface(LANG("client.5d9efa79", null)))
	log_mentor("MENTOR: [src] dementored.")
	ASSIGN_GAME_VERB(src, /client, cmd_mentor_rementor)

GAME_VERB_PROC(/client, cmd_mentor_rementor, "复魂怪", "Mentor")
	if(!is_mentor())
		return
	add_mentor_verbs()
	GLOB.mentors[src] = TRUE
	to_chat(src, span_interface(LANG("client.e350cdc4", null)))
	log_mentor("MENTOR: [src] rementored.")
	UNASSIGN_GAME_VERB(src, /client, cmd_mentor_rementor)
