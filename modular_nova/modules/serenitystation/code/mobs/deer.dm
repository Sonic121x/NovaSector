/mob/living/basic/deer/mining
	desc = "一只普通的鹿，经过数代在这颗行星上的生活，已经习惯了与怪物共存。"
	faction = list(FACTION_MINING)
	ai_controller = /datum/ai_controller/basic_controller/deer/mining

/datum/ai_controller/basic_controller/deer/mining/New()
	planning_subtrees -= list(
		/datum/ai_planning_subtree/play_with_friends,
		/datum/ai_planning_subtree/find_and_hunt_target/mark_territory,
		/datum/ai_planning_subtree/find_and_hunt_target/graze,
		/datum/ai_planning_subtree/find_and_hunt_target/drink_water,
	)
	return ..()
