/client/proc/mentor_follow(mob/living/M)
	if(!is_mentor())
		return
	var/orbiting = TRUE
	if(!isobserver(usr))
		mentor_datum.following = M
		usr.reset_perspective(M)
		ASSIGN_GAME_VERB(src, /client, mentor_unfollow)
		to_chat(usr, span_info(LANG("client.18ceac3806f6177d", list(MentorHrefToken(TRUE), key_name(M)))))
		orbiting = FALSE
	else
		var/mob/dead/observer/O = usr
		O.ManualFollow(M)
	to_chat(GLOB.admins, span_mentor(span_prefix(LANG("client.84aab3b1fd8924c3", list(key_name(usr), orbiting ? "orbiting" : "following", key_name(M), key_name(M), orbiting ? " as a ghost" : "")))))
	log_mentor("[key_name(usr)] [orbiting ? "is now orbiting" : "began following"][key_name(M)][orbiting ? " as a ghost" : ""].")

GAME_VERB_PROC_DESC(/client, mentor_unfollow, "停止跟随", "Stop following the followed.", "Mentor")
	if(!is_mentor())
		return
	usr.reset_perspective()
	UNASSIGN_GAME_VERB(src, /client, mentor_unfollow)
	to_chat(GLOB.admins, span_mentor(span_prefix(LANG("client.f57134772b7ff524", list(key_name(usr), key_name(mentor_datum.following))))))
	log_mentor("[key_name(usr)] stopped following [key_name(mentor_datum.following)].")
	mentor_datum.following = null
