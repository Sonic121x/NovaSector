

/mob/living/carbon/alien/larva/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return TRUE
	var/damage = rand(1, 9)
	if (prob(90))
		playsound(loc, SFX_PUNCH, 25, TRUE, -1)
		visible_message(span_danger("[user]踢了[src]！"), \
						span_userdanger("[user]踢了你！"), span_hear("你听到肉体撞击的恶心声响！"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("你踢了[src]！"))
		if ((stat != DEAD) && (damage > 4.9))
			Unconscious(rand(100,200))

		var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(user.zone_selected))
		apply_damage(damage, BRUTE, affecting)
		log_combat(user, src, "attacked")
	else
		playsound(loc, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
		visible_message(span_danger("[user]的踢击没有命中[src]！"), \
						span_danger("你躲开了[user]的踢击！"), span_hear("你听到一阵呼啸声！"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_warning("你的踢击没有命中[src]！"))
		log_combat(user, src, "attacked and missed")

/mob/living/carbon/alien/larva/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	user.AddComponent(/datum/component/force_move, get_step_away(user,src, 30))

/mob/living/carbon/alien/larva/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_BITE
	..()
