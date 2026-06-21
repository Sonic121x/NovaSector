/datum/action/changeling/regenerate
	name = "再生"
	desc = "允许我们再生与恢复缺失的肢体与重要器官，以及移除嵌入物、治疗严重伤口与恢复血容. 使用消耗10化学点"
	helptext = "Will alert nearby crew if any external limbs are regenerated. Can be used while unconscious."
	button_icon_state = "regenerate"
	chemical_cost = 10
	dna_cost = CHANGELING_POWER_INNATE
	req_stat = HARD_CRIT

/datum/action/changeling/regenerate/sting_action(mob/living/user)
	if(!iscarbon(user))
		user.balloon_alert(user, "没有缺失任何部位！")
		return FALSE

	..()
	to_chat(user, span_notice("你感到内外一阵瘙痒，仿佛你的组织在不断地编织与重组。"))
	var/mob/living/carbon/carbon_user = user
	var/got_limbs_back = length(carbon_user.get_missing_limbs()) >= 1
	carbon_user.fully_heal(HEAL_BODY)
	// Occurs after fully heal so the ling themselves can hear the sound effects (if deaf prior)
	if(got_limbs_back)
		playsound(user, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
		carbon_user.visible_message(
			span_warning("[user]缺失的肢体重新生长出来，发出响亮而怪诞的声音！"),
			span_userdanger("你的肢体重新生长，发出响亮、嘎吱作响的声音，并给你带来巨大的痛苦！"),
			span_hear("你听到有机物质撕裂的声音！"),
		)
		carbon_user.emote("scream")

	return TRUE
