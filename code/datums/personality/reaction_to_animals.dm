/datum/personality/animal_friend
	savefile_key = "animal_friend"
	name = "动物之友"
	desc = "我爱动物！它们永远不会离开我身边。"
	pos_gameplay_desc = "Likes being around pets"
	neg_gameplay_desc = "Seeing a pet's death affects your mood more"
	groups = list(PERSONALITY_GROUP_ANIMALS)

/datum/personality/cat_fan
	savefile_key = "cat_fan"
	name = "爱猫人士"
	desc = "猫咪太可爱了！"
	pos_gameplay_desc = "Likes being around cats"
	neg_gameplay_desc = "Dislikes being around dogs"
	groups = list(PERSONALITY_GROUP_ANIMALS)

/datum/personality/dog_fan
	savefile_key = "dog_fan"
	name = "爱狗人士"
	desc = "狗狗是最棒的！"
	pos_gameplay_desc = "Likes being around dogs"
	neg_gameplay_desc = "Dislikes being around cats"
	groups = list(PERSONALITY_GROUP_ANIMALS)

/datum/personality/animal_disliker
	savefile_key = "animal_disliker"
	name = "动物厌恶者"
	desc = "我们在这空间站都勉强求生，你还想养宠物？"
	neg_gameplay_desc = "Dislikes being around pets"
	groups = list(PERSONALITY_GROUP_ANIMALS)
