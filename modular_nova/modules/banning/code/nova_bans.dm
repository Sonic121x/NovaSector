/mob/dead/observer/Login()
	. = ..()
	if(ckey)
		if(is_banned_from(ckey, BAN_DONOTREVIVE))
			to_chat(src, span_notice(LANG("mob.24feb8f4", null)))
			can_reenter_corpse = FALSE

/proc/process_eorg_bans()
	for(var/mob/iterating_player in GLOB.mob_list)
		if(iterating_player.ckey && is_banned_from(iterating_player.ckey, BAN_EORG))
			new /obj/effect/particle_effect/sparks/quantum (get_turf(iterating_player))
			iterating_player.visible_message(span_notice(LANG("_root.4606a28d", list(iterating_player))), span_userdanger(LANG("_root.ce6ef300", null)))
			qdel(iterating_player)

