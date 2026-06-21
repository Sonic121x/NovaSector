/mob/living/carbon/verb/army_crawl()
	set name = "Army Crawl"
	set category = "IC"

	var/mob/living/carbon/crawler = src

	if(HAS_TRAIT(crawler, TRAIT_PRONE))
		visible_message("[crawler] 开始起身")
		if(!do_after(crawler, 3 SECONDS))
			return
		SEND_SIGNAL(crawler, COMSIG_MOVABLE_REMOVE_PRONE_STATE)
		return

	if(!crawler.can_army_crawl())
		balloon_alert(crawler, "必须躺下！")
		return

	visible_message("[crawler] 开始进一步压低身体")
	if(!do_after(crawler, 3 SECONDS, extra_checks = CALLBACK(crawler, PROC_REF(can_army_crawl))))
		if(!crawler.resting)
			balloon_alert(crawler, "必须躺下！")
		return
	crawler.AddComponent(/datum/component/prone_mob, block_hands = TRUE)

/// Checks if the user is lying down (resting)
/mob/living/carbon/proc/can_army_crawl()
	return resting
