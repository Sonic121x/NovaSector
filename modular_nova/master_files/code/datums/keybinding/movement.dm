/datum/keybinding/movement/army_crawl
	hotkey_keys = list("K")
	name = "prone"
	full_name = "army crawl"
	description = "在短暂延迟后，尽可能地将自己贴近地面"
	keybind_signal = COMSIG_KB_MOVEMENT_ARMY_CRAWL_DOWN

/datum/keybinding/movement/army_crawl/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/crawler = user.mob
	if(istype(crawler, /mob/living/carbon))
		crawler.army_crawl()
