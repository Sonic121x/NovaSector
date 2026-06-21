

/mob/living/carbon/alien/adult/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	adjust_brute_loss(15)
	var/hitverb = "hit"
	if(mob_size < MOB_SIZE_LARGE)
		safe_throw_at(get_edge_target_turf(src, get_dir(user, src)), 2, 1, user)
		hitverb = "slam"
	playsound(loc, SFX_PUNCH, 25, TRUE, -1)
	visible_message(span_danger("[user][hitverb]了[src]！"), \
					span_userdanger("[user][hitverb]了你！"), span_hear("你听到一阵令人作呕的肉体撞击声！"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("你[hitverb]了[src]！"))

/mob/living/carbon/alien/adult/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return TRUE
	var/damage = rand(1, 9)
	if (prob(90))
		playsound(loc, SFX_PUNCH, 25, TRUE, -1)
		visible_message(span_danger("[user]殴打了[src]！"), \
						span_userdanger("[user] 揍了你一拳！"), span_hear("你听到一阵令人作呕的肉体撞击声！"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("你揍了 [src] 一拳！"))
		if ((stat != DEAD) && (damage > 9 || prob(5)))//Regular humans have a very small chance of knocking an alien down.
			Unconscious(40)
			visible_message(span_danger("[user] 把 [src] 打倒了！"), \
							span_userdanger("[user] 把你打倒了！"), span_hear("你听到一阵令人作呕的肉体撞击声！"), null, user)
			to_chat(user, span_danger("你把 [src] 打倒了！"))
		var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(user.zone_selected))
		apply_damage(damage, BRUTE, affecting)
		log_combat(user, src, "attacked")
	else
		playsound(loc, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
		visible_message(span_danger("[user] 的拳头打偏了，没击中 [src]！"), \
						span_danger("你躲开了 [user] 的拳头！"), span_hear("你听到一阵嗖嗖声！"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_warning("你的拳头打偏了，没击中 [src]！"))

/mob/living/carbon/alien/adult/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_CLAW
	..()
