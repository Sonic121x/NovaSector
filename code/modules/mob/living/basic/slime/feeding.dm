
//Feeding

///Can the slime leech life energy from the target?
/mob/living/basic/slime/proc/can_feed_on(mob/living/meal, silent = FALSE, check_adjacent = FALSE, check_friendship = FALSE)

	if(!isliving(meal)) //sanity check
		return FALSE

	if(stat != CONSCIOUS)
		if(!silent)
			balloon_alert(src, "失去意识！")
		return FALSE

	if(hunger_disabled)
		if(!silent)
			balloon_alert(src, "不饿！")
		return FALSE

	if(check_friendship && has_faction(REF(meal)))
		return FALSE

	if(check_adjacent && (!Adjacent(meal) || !isturf(loc)))
		return FALSE

	if(!(mobility_flags & MOBILITY_MOVE))
		if(!silent)
			balloon_alert(src, "无法移动！")
		return FALSE

	if(meal.stat == DEAD)
		if(!silent)
			balloon_alert(src, "没有生命能量！")
		return FALSE

	if(locate(/mob/living/basic/slime) in meal.buckled_mobs)
		if(!silent)
			balloon_alert(src, "另一只史莱姆挡路了！")
		return FALSE

	if(issilicon(meal) || meal.mob_biotypes & MOB_ROBOTIC || meal.flags_1 & HOLOGRAM_1)
		balloon_alert(src, "没有生命能量！")
		return FALSE

	if(isslime(meal))
		if(!silent)
			balloon_alert(src, "不能吃史莱姆！")
		return FALSE

	if(isanimal(meal))
		var/mob/living/simple_animal/simple_meal = meal
		if(simple_meal.damage_coeff[TOX] <= 0 && simple_meal.damage_coeff[BRUTE] <= 0) //The creature wouldn't take any damage, it must be too weird even for us.
			if(!silent)
				balloon_alert(src, "不是食物！")
			return FALSE
	else if(isbasicmob(meal))
		var/mob/living/basic/basic_meal = meal
		if(basic_meal.damage_coeff[TOX] <= 0 && basic_meal.damage_coeff[BRUTE] <= 0)
			if (!silent)
				balloon_alert(src, "不是食物！")
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
			span_danger("[name] 缠住了 [target_mob]！"),
			span_userdanger("[name] 缠住了 [target_mob]！"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
		to_chat(src, span_notice("<i>我开始以 [target_mob] 为食...</i>"))
		balloon_alert(src, "开始进食")
	else
		balloon_alert(src, "附着失败！")

///The slime will stop feeding
/mob/living/basic/slime/proc/stop_feeding(silent = FALSE)
	if(!buckled)
		return

	if(!silent)
		visible_message(span_warning("[src] 放开了 [buckled]！"), span_notice("你放开了 [buckled]"))
		balloon_alert(src, "进食停止")
	remove_offsets(FEEDING_OFFSET)
	layer = initial(layer)
	buckled.unbuckle_mob(src,force=TRUE)

#undef FEEDING_OFFSET
