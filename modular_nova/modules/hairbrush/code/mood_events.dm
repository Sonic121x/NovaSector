/datum/mood_event/brushed
	description = "最近有人给我梳头，感觉棒极了！"
	mood_change = 3
	timeout = 4 MINUTES

/datum/mood_event/brushed/add_effects(mob/brusher, brush_target)
	description = "[brusher == owner ? "I" : brusher.name]最近梳了我的[brush_target]，感觉棒极了！"

/datum/mood_event/brushed/expert // For those with hair expert trait
	description = "刚才有人大师级地给我梳了毛，我感觉棒极了！"
	mood_change = 4

/datum/mood_event/brushed/expert/add_effects(mob/brusher, brush_target)
	description = "[brusher == owner ? "I" : brusher.name] 给我的 [brush_target] 进行了一次完美的梳理，我感觉棒极了！"

/datum/mood_event/brushed/self
	description = "我最近给自己梳了毛！"
	mood_change = 2		// You can't hit all the right spots yourself, or something

/datum/mood_event/brushed/self/add_effects(brush_target)
	description = "我最近给我的 [brush_target] 梳了毛！"

/datum/mood_event/brushed/self/expert // For those with self-awareness or hair expert trait
	description = "我完美地给自己梳了毛，我感觉棒极了！"
	mood_change = 3		// Unless you know what you're doing

/datum/mood_event/brushed/self/expert/add_effects(brush_target)
	description = "完美地梳理我的 [brush_target] 正是我所需要的，我感觉棒极了！"

/datum/mood_event/brushed/pet/add_effects(mob/brushed_pet)
	description = "我最近给 [brushed_pet] 梳了毛，[brushed_pet.p_theyre()] 太可爱了！"

// Negative

/datum/mood_event/harshly_brushed
	description = "哎哟！刚才梳得太用力了！"
	mood_change = -3

/datum/mood_event/harsh_brushed/add_effects(brush_target)
	description = "哎哟！刚才给我的 [brush_target] 梳得太用力了！"
