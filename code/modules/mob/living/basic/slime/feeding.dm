// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

//Feeding

///Can the slime leech life energy from the target?
/mob/living/basic/slime/proc/can_feed_on(mob/living/meal, silent = FALSE, check_adjacent = FALSE, check_friendship = FALSE)

	if(!isliving(meal)) //sanity check
		return FALSE

	if(IS_UNCONSCIOUS_OR_CRIT(src))
		if(stat == DEAD)
			balloon_alert(src, LANG("mob.1bf49ad4", null))
		else if(IS_UNCONSCIOUS(src))
			balloon_alert(src, LANG("mob.dc8b5a42", null))
		else
			balloon_alert(src, LANG("mob.b49fe510", null))
		return FALSE

	if(hunger_disabled)
		if(!silent)
			balloon_alert(src, LANG("mob.c8aeaa3f", null))
		return FALSE

	if(check_friendship && has_faction(REF(meal)))
		return FALSE

	if(check_adjacent && (!Adjacent(meal) || !isturf(loc)))
		return FALSE

	if(!(mobility_flags & MOBILITY_MOVE))
		if(!silent)
			balloon_alert(src, LANG("mob.b5c8ce04", null))
		return FALSE

	if(meal.stat == DEAD)
		if(!silent)
			balloon_alert(src, LANG("mob.6d3b5261", null))
		return FALSE

	if(locate(/mob/living/basic/slime) in meal.buckled_mobs)
		if(!silent)
			balloon_alert(src, LANG("mob.a6fc8c92", null))
		return FALSE

	if(issilicon(meal) || meal.mob_biotypes & MOB_ROBOTIC || meal.flags_1 & HOLOGRAM_1)
		balloon_alert(src, LANG("mob.6d3b5261", null))
		return FALSE

	if(isslime(meal))
		if(!silent)
			balloon_alert(src, LANG("mob.c6a76143", null))
		return FALSE

	if(isanimal(meal))
		var/mob/living/simple_animal/simple_meal = meal
		if(simple_meal.damage_coeff[TOX] <= 0 && simple_meal.damage_coeff[BRUTE] <= 0) //The creature wouldn't take any damage, it must be too weird even for us.
			if(!silent)
				balloon_alert(src, LANG("mob.fb932b9b", null))
			return FALSE
	else if(isbasicmob(meal))
		var/mob/living/basic/basic_meal = meal
		if(basic_meal.damage_coeff[TOX] <= 0 && basic_meal.damage_coeff[BRUTE] <= 0)
			if (!silent)
				balloon_alert(src, LANG("mob.fb932b9b", null))
			return FALSE

	return TRUE

#define FEEDING_OFFSET "feeding"

///The slime will start feeding on the target
/mob/living/basic/slime/proc/start_feeding(mob/living/target_mob)
	target_mob.unbuckle_all_mobs(force = TRUE) //Slimes rip other mobs (eg: shoulder parrots) off (Slimes Vs Slimes is already handled in can_feed_on())
	if(target_mob.buckle_mob(src, force = TRUE))
		add_offsets(FEEDING_OFFSET, y_add = target_mob.mob_size <= MOB_SIZE_SMALL ? 0 : 3)
		layer = MOB_ABOVE_PIGGYBACK_LAYER //appear above the target mob
		target_mob.apply_status_effect(/datum/status_effect/slime_leech, src)
		target_mob.visible_message(
			span_danger(LANG("mob.cf705fa4", list(name, target_mob))),
			span_userdanger(LANG("mob.cf705fa4", list(name, target_mob))),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
		to_chat(src, span_notice(LANG("mob.d919efd5", list(target_mob))))
		balloon_alert(src, LANG("mob.a61e8e90", null))
	else
		balloon_alert(src, LANG("mob.5353f456", null))

///The slime will stop feeding
/mob/living/basic/slime/proc/stop_feeding(silent = FALSE)
	if(!buckled)
		return

	if(!silent)
		visible_message(span_warning(LANG("mob.4dbce1e1", list(src, buckled))), span_notice(LANG("mob.ebf2f27c", list(buckled))))
		balloon_alert(src, LANG("mob.b10966c3", null))
	remove_offsets(FEEDING_OFFSET)
	layer = initial(layer)
	INVOKE_ASYNC(buckled, TYPE_PROC_REF(/atom/movable, unbuckle_mob), src, force=TRUE)

#undef FEEDING_OFFSET
