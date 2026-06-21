/datum/mood_event/drunk
	mood_change = 3
	description = "喝上一两杯后，一切都感觉更好了。"
	/// The blush overlay to display when the owner is drunk
	var/datum/bodypart_overlay/simple/emote/blush_overlay

/datum/mood_event/drunk/add_effects(drunkness)
	update_change(drunkness)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human_owner = owner
	blush_overlay = human_owner.give_emote_overlay(/datum/bodypart_overlay/simple/emote/blush)

/// Updates the description and value of the moodlet according to the passed drunkness value
/// (Does not add to or remove from the current level - it will sets it directly to the new value)
/datum/mood_event/drunk/proc/update_change(drunkness = 0)
	var/old_mood = mood_change
	switch(drunkness)
		if(0 to 30)
			mood_change = 3
			description = "喝上一两杯后，一切都感觉更好了。"
		if(30 to 45)
			mood_change = 4
			description = "是天气变热了，还是我的错觉？我得再来一杯降降温。"
		if(45 to 60)
			mood_change = 5
			description = "谁在动地板？我要去跟他们谈谈……喝完这杯就去。"
		if(60 to 90)
			mood_change = 6
			description = "我没醉，你才醉了！事实上……我还得来一杯！"
		if(90 to INFINITY)
			mood_change = 3 // crash out
			description = "You're my BESSST frien'... You and me agains' th' world, buddy. Le's get another drink."
	if(HAS_PERSONALITY(owner, /datum/personality/teetotal))
		mood_change *= -1.5
		description = "我不喜欢喝酒……它让我感觉糟透了。"
	if(HAS_PERSONALITY(owner, /datum/personality/bibulous))
		mood_change *= 1.5
	if(old_mood != mood_change)
		owner.mob_mood.update_mood()

/datum/mood_event/drunk/remove_effects()
	QDEL_NULL(blush_overlay)

/datum/mood_event/drunk_after
	mood_change = 2
	description = "醉意或许已消，但我依然感觉良好。"
	timeout = 5 MINUTES

/datum/mood_event/wrong_brandy
	description = "我讨厌那种酒。"
	mood_change = -2
	timeout = 6 MINUTES

/datum/mood_event/quality_revolting
	description = "那是我喝过的最难喝的东西。"
	mood_change = -8
	timeout = 7 MINUTES

/datum/mood_event/quality_nice
	description = "那杯酒一点也不差。"
	mood_change = 2
	timeout = 7 MINUTES

/datum/mood_event/quality_good
	description = "那杯酒相当不错。"
	mood_change = 4
	timeout = 7 MINUTES

/datum/mood_event/quality_verygood
	description = "那杯饮料真棒！"
	mood_change = 6
	timeout = 7 MINUTES

/datum/mood_event/quality_fantastic
	description = "那杯饮料太棒了！"
	mood_change = 8
	timeout = 7 MINUTES

/datum/mood_event/amazingtaste
	description = "味道好极了！"
	mood_change = 50
	timeout = 10 MINUTES

/datum/mood_event/wellcheers
	description = "这罐Wellcheers真美味！咸葡萄口味真是绝佳的提神剂。"
	mood_change = 3
	timeout = 7 MINUTES

/datum/mood_event/sweetcoffee
	description = "The bitter sweet taste of coffee was not too bad"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/sweettea
	description = "Let your worries dissolve like sugar in tea."
	mood_change = 4
	timeout = 2.5 MINUTES
