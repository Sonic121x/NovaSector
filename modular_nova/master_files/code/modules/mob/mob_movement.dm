GAME_VERB(/mob/living/carbon, army_crawl, "匍匐前进", "IC")
	var/mob/living/carbon/crawler = src

	if(HAS_TRAIT(crawler, TRAIT_PRONE))
		visible_message(LANG("mob.af3c556fa0a40fcc", list(crawler)))
		if(!do_after(crawler, 3 SECONDS))
			return
		SEND_SIGNAL(crawler, COMSIG_MOVABLE_REMOVE_PRONE_STATE)
		return

	if(!crawler.can_army_crawl())
		balloon_alert(crawler, LANG("mob.3d044f09f91d888b", null))
		return

	visible_message(LANG("mob.32a53d26cb174138", list(crawler)))
	if(!do_after(crawler, 3 SECONDS, extra_checks = CALLBACK(crawler, PROC_REF(can_army_crawl))))
		if(!crawler.resting)
			balloon_alert(crawler, LANG("mob.3d044f09f91d888b", null))
		return
	crawler.AddComponent(/datum/component/prone_mob, block_hands = TRUE)

/// Checks if the user is lying down (resting)
/mob/living/carbon/proc/can_army_crawl()
	return resting
