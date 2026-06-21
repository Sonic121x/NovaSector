/datum/personality/apathetic
	savefile_key = "apathetic"
	name = "冷漠"
	desc = "我对大多数事情都不在乎。无论是好的、坏的，当然也包括丑陋的。"
	neut_gameplay_desc = "All moodlets affect you less"
	groups = list(PERSONALITY_GROUP_MOOD_POWER)

/datum/personality/apathetic/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.mood_modifier -= 0.2

/datum/personality/apathetic/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.mood_modifier += 0.2

/datum/personality/sensitive
	savefile_key = "sensitive"
	name = "敏感"
	desc = "我很容易受到周围世界的影响。"
	neut_gameplay_desc = "All moodlets affect you more"
	groups = list(PERSONALITY_GROUP_MOOD_POWER)

/datum/personality/sensitive/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.mood_modifier += 0.2

/datum/personality/sensitive/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.mood_modifier -= 0.2

/datum/personality/resilient
	savefile_key = "resilient"
	name = "坚韧"
	desc = "没什么大不了的。我能承受！"
	pos_gameplay_desc = "Negative moodlets expire faster"
	groups = list(PERSONALITY_GROUP_MOOD_LENGTH)

/datum/personality/resilient/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.negative_moodlet_length_modifier -= 0.2

/datum/personality/resilient/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.negative_moodlet_length_modifier += 0.2

/datum/personality/brooding
	savefile_key = "brooding"
	name = "忧郁"
	desc = "每件事都困扰着我，我忍不住要去思考它们。"
	neg_gameplay_desc = "Negative moodlets last longer"
	groups = list(PERSONALITY_GROUP_MOOD_LENGTH)

/datum/personality/brooding/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.negative_moodlet_length_modifier += 0.2

/datum/personality/brooding/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.negative_moodlet_length_modifier -= 0.2

/datum/personality/hopeful
	savefile_key = "hopeful"
	name = "乐观"
	desc = "我相信事情总会变得更好。"
	pos_gameplay_desc = "Positive moodlets last longer"
	groups = list(PERSONALITY_GROUP_HOPE)

/datum/personality/hopeful/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.positive_moodlet_length_modifier += 0.2

/datum/personality/hopeful/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.positive_moodlet_length_modifier -= 0.2

/datum/personality/pessimistic
	savefile_key = "pessimistic"
	name = "悲观"
	desc = "我相信我们最好的日子已经过去了。"
	neg_gameplay_desc = "Positive moodlets last shorter"
	groups = list(PERSONALITY_GROUP_HOPE)

/datum/personality/pessimistic/apply_to_mob(mob/living/who)
	. = ..()
	who.mob_mood?.positive_moodlet_length_modifier -= 0.2

/datum/personality/pessimistic/remove_from_mob(mob/living/who)
	. = ..()
	who.mob_mood?.positive_moodlet_length_modifier += 0.2

/datum/personality/whimsical
	savefile_key = "whimsical"
	name = "异想天开"
	desc = "这个空间站有时太严肃了，放轻松点！"
	pos_gameplay_desc = "Likes ostensibly pointless but silly things, and does not mind clownish pranks"

/datum/personality/snob
	savefile_key = "snob"
	name = "势利"
	desc = "我对这个空间站只抱有最高的期望——任何低于此标准的事情都是不可接受的！"
	neut_gameplay_desc = "Room quality affects your mood"
	personality_trait = TRAIT_SNOB
