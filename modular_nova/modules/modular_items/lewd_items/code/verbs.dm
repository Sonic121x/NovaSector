GAME_VERB(/mob/living/carbon/human, climax_verb, "高潮", "IC")
	if(!has_status_effect(/datum/status_effect/climax_cooldown))
		if(tgui_alert(usr, LANG("mob.b5f29a08", null), LANG("mob.39f677eb", null), list("Yes", "No")) == "Yes")
			if(IS_UNCONSCIOUS_OR_CRIT(src))
				to_chat(usr, span_warning(LANG("mob.9143876c", null)))
				return
			else
				climax(TRUE)
	else
		to_chat(src, span_warning(LANG("mob.b4242208", null)))

GAME_VERB(/mob/living, reflexes_verb, "切换敏捷反应", "IC")
	if(!HAS_TRAIT_FROM(src, TRAIT_QUICKREFLEXES, REF(src)))
		ADD_TRAIT(src, TRAIT_QUICKREFLEXES, REF(src))
		to_chat(src, span_notice("[get_reflexes_gain_text()]"))
	else
		REMOVE_TRAIT(src, TRAIT_QUICKREFLEXES, REF(src))
		to_chat(src, span_notice("[get_reflexes_lose_text()]"))

/mob/living/proc/get_reflexes_gain_text()
	return "You don't feel like being touched right now."

/mob/living/proc/get_reflexes_lose_text()
	return "You'll allow yourself to be touched now."

/mob/living/silicon/get_reflexes_gain_text()
	return "Our systems will disallow platonic contact."

/mob/living/silicon/get_reflexes_lose_text()
	return "Our systems will allow platonic contact."

GAME_VERB_DESC(/mob/living/carbon/human, safeword, "移除不雅物品", "Removes any and all lewd items from you.", "OOC")
	log_message("[key_name(src)] used the Remove Lewd Items verb.", LOG_ATTACK)
	for(var/obj/item/equipped_item in get_equipped_items())
		if(!(equipped_item.type in GLOB.pref_checked_clothes))
			continue

		log_message("[equipped_item] was removed from [key_name(src)].", LOG_ATTACK)
		dropItemToGround(equipped_item, TRUE)

	// Leashes are treated a smidge different than the rest of the clothing; and need their own handling here.
	var/leash_check = src?.GetComponent(/datum/component/leash/erp)
	if(leash_check)
		qdel(leash_check)

	return TRUE
