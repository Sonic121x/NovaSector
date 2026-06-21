/**
 * skill associated with the fishing feature. It modifies the fishing minigame difficulty
 * and is gained each time one is completed.
 */
/datum/skill/fishing
	name = "钓鱼"
	title = "Angler"
	desc = "在这荒芜的地球上，你是多么空虚和孤独。"
	modifiers = list(SKILL_VALUE_MODIFIER = list(1, 0, -1, -3, -5, -7, -10))
	skill_item_path = /obj/item/clothing/head/soft/fishing_hat

/datum/skill/fishing/New()
	. = ..()
	levelUpMessages[SKILL_LEVEL_NOVICE] = span_nicegreen("我开始明白[name]到底是什么了！我能一眼估出鱼的大小和重量。")
	levelUpMessages[SKILL_LEVEL_APPRENTICE] = span_nicegreen("我对[name]有点上手了！我能分辨出鱼是否饥饿、濒死或其他状态。")
	levelUpMessages[SKILL_LEVEL_JOURNEYMAN] = span_nicegreen("我感觉自己在[name]方面已经相当熟练了！我能看出在任何给定的钓鱼点能钓到什么鱼。")
	levelUpMessages[SKILL_LEVEL_MASTER] = span_nicegreen("I've begun to truly understand the surprising depth behind [name]. As a master [title], I can guess what I'm going to catch now!")

/datum/skill/fishing/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_NOVICE && old_level < SKILL_LEVEL_NOVICE)
		ADD_TRAIT(mind, TRAIT_EXAMINE_FISH, SKILL_TRAIT)
	if(new_level >= SKILL_LEVEL_APPRENTICE && old_level < SKILL_LEVEL_APPRENTICE)
		ADD_TRAIT(mind, TRAIT_EXAMINE_DEEPER_FISH, SKILL_TRAIT)
	if(new_level >= SKILL_LEVEL_JOURNEYMAN && old_level < SKILL_LEVEL_JOURNEYMAN)
		ADD_TRAIT(mind, TRAIT_EXAMINE_FISHING_SPOT, SKILL_TRAIT)
	if(new_level >= SKILL_LEVEL_MASTER && old_level < SKILL_LEVEL_MASTER)
		ADD_TRAIT(mind, TRAIT_REVEAL_FISH, SKILL_TRAIT)

/datum/skill/fishing/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_MASTER && new_level < SKILL_LEVEL_MASTER)
		REMOVE_TRAIT(mind, TRAIT_REVEAL_FISH, SKILL_TRAIT)
	if(old_level >= SKILL_LEVEL_JOURNEYMAN && new_level < SKILL_LEVEL_JOURNEYMAN)
		REMOVE_TRAIT(mind, TRAIT_EXAMINE_FISHING_SPOT, SKILL_TRAIT)
	if(old_level >= SKILL_LEVEL_APPRENTICE && new_level < SKILL_LEVEL_APPRENTICE)
		REMOVE_TRAIT(mind, TRAIT_EXAMINE_DEEPER_FISH, SKILL_TRAIT)
	if(old_level >= SKILL_LEVEL_NOVICE && new_level < SKILL_LEVEL_NOVICE)
		REMOVE_TRAIT(mind, TRAIT_EXAMINE_FISH, SKILL_TRAIT)
