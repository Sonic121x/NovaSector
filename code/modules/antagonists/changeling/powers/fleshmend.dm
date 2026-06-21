/datum/action/changeling/fleshmend
	name = "血肉愈合"
	desc = "使我们的肉体迅速再生，治愈我们的烧伤、创伤与窒息伤的同时隐藏我们所有的伤疤. 使用消耗20化学点"
	helptext = "If we are on fire, the healing effect will not function. Does not regrow limbs or restore lost blood. Functions while unconscious."
	button_icon_state = "fleshmend"
	category = "combat"
	chemical_cost = 20
	dna_cost = 2
	req_stat = HARD_CRIT

//Starts healing you every second for 10 seconds.
//Can be used whilst unconscious.
/datum/action/changeling/fleshmend/sting_action(mob/living/user)
	if(user.has_status_effect(/datum/status_effect/fleshmend))
		user.balloon_alert(user, "已在血肉愈合中！")
		return
	..()
	to_chat(user, span_notice("我们开始快速愈合。"))
	user.apply_status_effect(/datum/status_effect/fleshmend)
	return TRUE

//Check buffs.dm for the fleshmend status effect code
