GLOBAL_LIST_INIT(skill_types, subtypesof(/datum/skill))

/datum/skill
	var/name = "技能训练"
	var/title = "Skiller"
	var/desc = "做事的艺术"
	///Dictionary of modifier type - list of modifiers (indexed by level). 7 entries in each list for all 7 skill levels.
	var/modifiers = list(SKILL_SPEED_MODIFIER = list(1, 1, 1, 1, 1, 1, 1)) //Dictionary of modifier type - list of modifiers (indexed by level). 7 entries in each list for all 7 skill levels.
	///List Path pointing to the skill item reward that will appear when a user finishes leveling up a skill
	var/skill_item_path
	///List associating different messages that appear on level up with different levels
	var/list/levelUpMessages = list()
	///List associating different messages that appear on level up with different levels
	var/list/levelDownMessages = list()

/datum/skill/proc/get_skill_modifier(modifier, level)
	return modifiers[modifier][level] //Levels range from 1 (None) to 7 (Legendary)
/**
 * new: sets up some lists.
 *
 *Can't happen in the datum's definition because these lists are not constant expressions
 */
/datum/skill/New()
	. = ..()
	levelUpMessages = list(span_nicegreen("[name]到底是什么鬼？如果你看到这条消息，请告诉管理员。"), //This first index shouldn't ever really be used
	span_nicegreen("我开始明白[name]到底是什么了！"),
	span_nicegreen("我在[name]方面有了一点进步！"),
	span_nicegreen("我在[name]方面进步很大！"),
	span_nicegreen("我感觉自己在[name]方面已经相当熟练了！"),
	span_nicegreen("经过大量练习，我终于开始真正理解[name]背后的复杂细节和惊人深度。我现在认为自己是一名精通[title]的大师。"),
	span_nicegreen("Through incredible determination and effort, I've reached the peak of my [name] abiltities. I'm finally able to consider myself a legendary [title]!") )
	levelDownMessages = list(span_nicegreen("我不知为何完全丧失了对[name]的所有理解。如果你看到这条消息，请通知管理员。"),
	span_nicegreen("我开始忘记[name]到底是什么了。我需要更多练习……"),
	span_nicegreen("I'm getting a little worse at [name]. I'll need to keep practicing to get better at it..."),
	span_nicegreen("我在[name]方面有点退步了……"),
	span_nicegreen("我正在失去我的[name]专长……"),
	span_nicegreen("我感觉自己正在失去对[name]的掌握。"),
	span_nicegreen("我感觉自己传奇的[name]技能已经衰退。我需要更密集的训练来恢复失去的技能。") )

/**
 * level_gained: Gives skill levelup messages to the user
 *
 * Only fires if the xp gain isn't silent, so only really useful for messages.
 * Arguments:
 * * mind - The mind that you'll want to send messages
 * * new_level - The newly gained level. Can check the actual level to give different messages at different levels, see defines in skills.dm
 * * old_level - Similar to the above, but the level you had before levelling up.
 * * silent - Silences the announcement if TRUE
 */
/datum/skill/proc/level_gained(datum/mind/mind, new_level, old_level, silent)
	if(silent)
		return
	to_chat(mind.current, levelUpMessages[new_level]) //new_level will be a value from 1 to 6, so we get appropriate message from the 6-element levelUpMessages list
/**
 * level_lost: See level_gained, same idea but fires on skill level-down
 */
/datum/skill/proc/level_lost(datum/mind/mind, new_level, old_level, silent)
	if(silent)
		return
	to_chat(mind.current, levelDownMessages[old_level]) //old_level will be a value from 1 to 6, so we get appropriate message from the 6-element levelUpMessages list

/**
 * try_skill_reward: Checks to see if a user is eligable for a tangible reward for reaching a certain skill level
 *
 * Currently gives the user a special cloak when they reach a legendary level at any given skill
 * Arguments:
 * * mind - The mind that you'll want to send messages and rewards to
 * * new_level - The current level of the user. Used to check if it meets the requirements for a reward
 */
/datum/skill/proc/try_skill_reward(datum/mind/mind, new_level)
	if (new_level != SKILL_LEVEL_LEGENDARY)
		return
	if (!ispath(skill_item_path))
		to_chat(mind.current, span_nicegreen("我传奇的[name]技能相当令人印象深刻，不过似乎[title]专业协会没有任何身份象征来纪念我的能力。我应该让中央司令部知道这种不公，也许他们能做点什么。"))
		return
	if (LAZYFIND(mind.skills_rewarded, src.type))
		to_chat(mind.current, span_nicegreen("看来[title]专业协会不会再给我发送另一个身份象征了。"))
		return
	podspawn(list(
		"target" = get_turf(mind.current),
		"style" = /datum/pod_style/advanced,
		"spawn" = skill_item_path,
		"delays" = list(POD_TRANSIT = 150, POD_FALLING = 4, POD_OPENING = 30, POD_LEAVING = 30)
	))
	to_chat(mind.current, span_nicegreen("我传奇的技能引起了[title]专业协会的注意。看来他们正在给我发送一个身份象征来纪念我的能力。"))
	LAZYADD(mind.skills_rewarded, src.type)
