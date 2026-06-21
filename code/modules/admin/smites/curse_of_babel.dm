/// Strikes the target with a lightning bolt
/datum/smite/curse_of_babel
	name = "巴别塔诅咒"
	/// How long should the effect last
	var/duration

/datum/smite/curse_of_babel/configure(client/user)
	duration = tgui_input_number(user, "你希望这个效果持续多少分钟？", "时间", 1, 60, -1, round_value = FALSE) MINUTES

/datum/smite/curse_of_babel/effect(client/user, mob/living/carbon/target)
	. = ..()
	if(!iscarbon(target))
		to_chat(user, span_warning("必须对碳基生物使用。"), confidential = TRUE)
		return

	target.apply_status_effect(/datum/status_effect/tower_of_babel, duration)
	to_chat(target, span_userdanger("诸神已因你的罪孽而惩罚了你！"), confidential = TRUE)
