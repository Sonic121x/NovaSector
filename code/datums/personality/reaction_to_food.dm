/datum/personality/ascetic
	savefile_key = "ascetic"
	name = "苦行者"
	desc = "我不太在意奢侈的食物——它们都只是身体的燃料。"
	pos_gameplay_desc = "Sorrow from eating disliked food is reduced"
	neg_gameplay_desc = "Enjoyment from eating liked food is limited"
	groups = list(PERSONALITY_GROUP_FOOD)

/datum/personality/gourmand
	savefile_key = "gourmand"
	name = "美食家"
	desc = "食物对我来说就是一切！"
	pos_gameplay_desc = "Enjoyment from eating liked food is strengthened"
	neg_gameplay_desc = "Sadness from eating food you dislike is increased, and mediocre food is less enjoyable"
	groups = list(PERSONALITY_GROUP_FOOD)

/datum/personality/teetotal
	savefile_key = "teetotal"
	name = "禁酒者"
	desc = "酒精不适合我。"
	neg_gameplay_desc = "Dislikes drinking alcohol"
	groups = list(PERSONALITY_GROUP_ALCOHOL)

/datum/personality/bibulous
	savefile_key = "bibulous"
	name = "嗜酒者"
	desc = "我总会再来一轮酒！"
	pos_gameplay_desc = "Fulfillment from drinking lasts longer, even after you are no longer drunk"
	groups = list(PERSONALITY_GROUP_ALCOHOL)
