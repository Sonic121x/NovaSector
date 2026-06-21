/datum/personality/callous
	savefile_key = "callous"
	name = "冷漠型"
	desc = "我不太关心别人身上会发生什么。"
	pos_gameplay_desc = "Does not mind seeing death"
	neg_gameplay_desc = "Prefers not to help people"
	groups = list(PERSONALITY_GROUP_DEATH)

/datum/personality/compassionate
	savefile_key = "compassionate"
	name = "富有同情心"
	desc = "我喜欢向需要帮助的人伸出援手。"
	pos_gameplay_desc = "Likes helping people"
	neg_gameplay_desc = "Seeing death affects your mood more"
	groups = list(PERSONALITY_GROUP_DEATH, PERSONALITY_GROUP_MISANTHROPY)

/datum/personality/empathetic
	savefile_key = "empathetic"
	name = "善解人意" // according to google "empathic" means you understand other people, while "empathetic" means you feel what they feel
	desc = "他人的感受对我很重要。"
	pos_gameplay_desc = "Likes seeing other people happy"
	neg_gameplay_desc = "Dislikes seeing other people sad"
	groups = list(PERSONALITY_GROUP_OTHERS)

/datum/personality/misanthropic
	savefile_key = "misanthropic"
	name = "厌世"
	desc = "我们本就不该踏入星空。"
	pos_gameplay_desc = "Likes seeing other people sad"
	neg_gameplay_desc = "Dislikes seeing other people happy"
	groups = list(PERSONALITY_GROUP_OTHERS, PERSONALITY_GROUP_MISANTHROPY)

/datum/personality/aloof
	savefile_key = "aloof"
	name = "冷漠"
	desc = "为什么大家都这么敏感？我更想一个人待着。"
	neg_gameplay_desc = "Dislikes being grabbed, touched, or hugged"
	personality_trait = TRAIT_BADTOUCH

/datum/personality/aloof/apply_to_mob(mob/living/who)
	. = ..()
	RegisterSignals(who, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HELP_ACT), PROC_REF(uncomfortable_touch))

/datum/personality/aloof/remove_from_mob(mob/living/who)
	. = ..()
	UnregisterSignal(who, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HELP_ACT))

/// Causes a negative moodlet to our quirk holder on signal
/datum/personality/aloof/proc/uncomfortable_touch(mob/living/source)
	SIGNAL_HANDLER

	if(source.stat == DEAD)
		return

	new /obj/effect/temp_visual/annoyed(source.loc)
	if(source.mob_mood.sanity <= SANITY_NEUTRAL)
		source.add_mood_event("bad_touch", /datum/mood_event/very_bad_touch)
	else
		source.add_mood_event("bad_touch", /datum/mood_event/bad_touch)
