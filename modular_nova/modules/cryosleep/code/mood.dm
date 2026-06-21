/datum/mood_event/tucked_in
	description = "把某人安顿好睡个好觉让我感觉好多了！"
	mood_change = 3
	timeout = 2 MINUTES

/datum/mood_event/tucked_in/add_effects(mob/tuckee)
	if(!tuckee)
		return
	description = "把[tuckee.name]安顿好睡个好觉让我感觉好多了！"
