/datum/personality/brave
	savefile_key = "brave"
	name = "勇敢"
	desc = "一点点血可吓不到我。"
	pos_gameplay_desc = "Accumulate fear slower, and moodlets related to fear are weaker"
	groups = list(PERSONALITY_GROUP_GENERAL_FEAR, PERSONALITY_GROUP_PEOPLE_FEAR)

/datum/personality/cowardly
	savefile_key = "cowardly"
	name = "怯懦"
	desc = "这里的一切都很危险！连空气都是！"
	neg_gameplay_desc = "Accumulate fear faster, and moodlets related to fear are stronger"
	groups = list(PERSONALITY_GROUP_GENERAL_FEAR)
