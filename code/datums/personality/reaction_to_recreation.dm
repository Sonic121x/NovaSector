/datum/personality/gambler
	savefile_key = "gambler"
	name = "赌徒"
	desc = "掷骰子总是值得的！"
	pos_gameplay_desc = "Likes gambling and card games, and content with losing when gambling"

/datum/personality/slacking
	/// Areas which are considered "slacking off"
	var/list/slacker_areas = list(
		/area/station/commons/fitness,
		/area/station/commons/lounge,
		/area/station/service/bar,
		/area/station/service/cafeteria,
		/area/station/service/library,
		/area/station/service/minibar,
		/area/station/service/theater,
	)
	/// Mood event applied when in a slacking area
	var/mood_event_type

/datum/personality/slacking/apply_to_mob(mob/living/who)
	. = ..()
	who.apply_status_effect(/datum/status_effect/moodlet_in_area, mood_event_type, slacker_areas, CALLBACK(src, PROC_REF(is_slacking)))

/datum/personality/slacking/remove_from_mob(mob/living/who)
	. = ..()
	who.remove_status_effect(/datum/status_effect/moodlet_in_area, mood_event_type)

/// Callback for the moodlet_in_area status effect to determine if we're slacking off
/datum/personality/slacking/proc/is_slacking(mob/living/who, area/new_area)
	if(!istype(new_area, /area/station/service))
		return TRUE
	// Service workers don't slack in service
	if(who.mind?.assigned_role.departments_bitflags & DEPARTMENT_BITFLAG_SERVICE)
		return FALSE

	return TRUE

/datum/personality/slacking/lazy
	savefile_key = "lazy"
	name = "懒惰"
	desc = "我今天不太想工作。"
	pos_gameplay_desc = "Happy in the bar or recreation areas"
	mood_event_type = /datum/mood_event/slacking_off_lazy
	groups = list(PERSONALITY_GROUP_RECREATION, PERSONALITY_GROUP_WORK, PERSONALITY_GROUP_ATHLETICS)

/datum/personality/slacking/diligent
	savefile_key = "diligent"
	name = "勤勉"
	desc = "这里的事情需要有人去做！"
	pos_gameplay_desc = "Happy when in their department"
	neg_gameplay_desc = "Unhappy when slacking off in the bar or recreation areas"
	mood_event_type = /datum/mood_event/slacking_off_diligent
	groups = list(PERSONALITY_GROUP_RECREATION)

/datum/personality/slacking/diligent/apply_to_mob(mob/living/who)
	. = ..()
	RegisterSignals(who, list(COMSIG_MOB_MIND_TRANSFERRED_INTO, COMSIG_MOB_MIND_SET_ROLE), PROC_REF(update_effect))
	// Unfortunate side effect here in that IC job changes, IE HoP are missed
	who.apply_status_effect(/datum/status_effect/moodlet_in_area, /datum/mood_event/working_diligent, who.mind?.get_work_areas())

/datum/personality/slacking/diligent/remove_from_mob(mob/living/who)
	. = ..()
	UnregisterSignal(who, list(COMSIG_MOB_MIND_TRANSFERRED_INTO, COMSIG_MOB_MIND_SET_ROLE))
	who.remove_status_effect(/datum/status_effect/moodlet_in_area, /datum/mood_event/working_diligent)

/// Signal handler to update our status effect when our job changes
/datum/personality/slacking/diligent/proc/update_effect(mob/living/source, ...)
	SIGNAL_HANDLER

	source.remove_status_effect(/datum/status_effect/moodlet_in_area, /datum/mood_event/working_diligent)
	source.apply_status_effect(/datum/status_effect/moodlet_in_area, /datum/mood_event/working_diligent, source.mind.get_work_areas())

/datum/personality/industrious
	savefile_key = "industrious"
	name = "勤奋"
	desc = "每个人都需要工作——否则我们都在浪费时间。"
	neg_gameplay_desc = "Dislikes playing games"
	groups = list(PERSONALITY_GROUP_WORK)

/datum/personality/athletic
	savefile_key = "athletic"
	name = "运动型"
	desc = "不能整天坐着不动！必须保持活动。"
	pos_gameplay_desc = "Likes exercising"
	neg_gameplay_desc = "Dislikes being lazy"
	groups = list(PERSONALITY_GROUP_ATHLETICS)

/datum/personality/erudite
	savefile_key = "erudite"
	name = "博学者"
	desc = "知识就是力量。尤其是在这深空之中。"
	pos_gameplay_desc = "Likes reading books"
	groups = list(PERSONALITY_GROUP_READING)

/datum/personality/uneducated
	savefile_key = "uneducated"
	name = "未受教育者"
	desc = "我对书没什么兴趣——我已经知道我需要知道的一切了。"
	neg_gameplay_desc = "Dislikes reading books"
	groups = list(PERSONALITY_GROUP_READING)

/datum/personality/spiritual
	savefile_key = "spiritual"
	name = "灵性者"
	desc = "我相信存在更高的力量。"
	pos_gameplay_desc = "Likes the Chapel and the Chaplain, and has special prayers"
	neg_gameplay_desc = "Dislikes unholy things"
	personality_trait = TRAIT_SPIRITUAL
