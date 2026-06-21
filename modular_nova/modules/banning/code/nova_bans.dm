/mob/living/Login()
	. = ..()
	if(ckey)
		if(is_banned_from(ckey, BAN_PACIFICATION))
			ADD_TRAIT(src, TRAIT_PACIFISM, ROUNDSTART_TRAIT)

/mob/dead/observer/Login()
	. = ..()
	if(ckey)
		if(is_banned_from(ckey, BAN_DONOTREVIVE))
			to_chat(src, span_notice("由于你被禁止复活，你无法重新进入你的身体。"))
			can_reenter_corpse = FALSE

/proc/process_eorg_bans()
	for(var/mob/iterating_player in GLOB.mob_list)
		if(iterating_player.ckey && is_banned_from(iterating_player.ckey, BAN_EORG))
			new /obj/effect/particle_effect/sparks/quantum (get_turf(iterating_player))
			iterating_player.visible_message(span_notice("[iterating_player] 被传送回家了，希望回到一个充满爱的家庭！"), span_userdanger("由于你被禁止参与回合结束，你将被删除。"))
			qdel(iterating_player)

