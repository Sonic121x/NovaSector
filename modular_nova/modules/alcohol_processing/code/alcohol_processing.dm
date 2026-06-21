#define BAC_STAGE_1_ACTIVE 0.01
#define BAC_STAGE_2_WARN 0.05
#define BAC_STAGE_2_ACTIVE 0.07
#define BAC_STAGE_3_WARN 0.11
#define BAC_STAGE_3_ACTIVE 0.13
#define BAC_STAGE_4_WARN 0.17
#define BAC_STAGE_4_ACTIVE 0.19
#define BAC_STAGE_5_WARN 0.23

/datum/reagent/consumable/ethanol
	metabolization_rate = 0.3 * REAGENTS_METABOLISM

/atom/movable/screen/alert/status_effect/drunk
	desc = "All that alcohol you've been drinking is impairing your speech, \
		motor skills, and mental cognition. Make sure to act like it. \
		Check your current drunkenness level using your mood status."

/// Adds a moodlet entry based on if the mob currently has alcohol processing in their system.
/datum/mood/proc/get_alcohol_processing(mob/user)
	if(user.reagents.reagent_list.len)
		for(var/datum/reagent/consumable/ethanol/booze in user.reagents.reagent_list)
			return span_notice("我还在消化刚才喝下的酒精...\n")

/// Adds a moodlet entry based on the current blood alcohol content of the mob.
/datum/mood/proc/get_drunk_mood(mob/user)
	var/mob/living/target = user
	var/blood_alcohol_content = target.get_blood_alcohol_content()
	switch(blood_alcohol_content)
		if(BAC_STAGE_1_ACTIVE to BAC_STAGE_2_WARN)
			return span_notice("喝了一杯，该放松一下了！\n")
		if(BAC_STAGE_2_WARN to BAC_STAGE_2_ACTIVE)
			return span_nicegreen("现在我开始感觉到那杯酒了。\n")
		if(BAC_STAGE_2_ACTIVE to BAC_STAGE_3_WARN)
			return span_nicegreen("有点微醺，感觉不错！\n")
		if(BAC_STAGE_3_WARN to BAC_STAGE_3_ACTIVE)
			return span_nicegreen("那些酒真的开始上头了！\n")
		if(BAC_STAGE_3_ACTIVE to BAC_STAGE_4_WARN)
			return span_nicegreen("我不记得喝了多少，但感觉棒极了！\n")
		if(BAC_STAGE_4_WARN to BAC_STAGE_4_ACTIVE)
			return span_warning("我想我喝得太多了...我可能该停下来了...喝点水...\n")
		if(BAC_STAGE_4_ACTIVE to BAC_STAGE_5_WARN)
			return span_bolddanger("我感觉不太舒服...\n")
		if(BAC_STAGE_5_WARN to INFINITY)
			return span_bolddanger("附近有医生吗？我真的感觉很不舒服...\n")

#undef BAC_STAGE_1_ACTIVE
#undef BAC_STAGE_2_WARN
#undef BAC_STAGE_2_ACTIVE
#undef BAC_STAGE_3_WARN
#undef BAC_STAGE_3_ACTIVE
#undef BAC_STAGE_4_WARN
#undef BAC_STAGE_4_ACTIVE
#undef BAC_STAGE_5_WARN
