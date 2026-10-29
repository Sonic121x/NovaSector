// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md


/mob/living/carbon/alien/adult/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	adjust_brute_loss(15)
	var/hitverb = "hit"
	if(mob_size < MOB_SIZE_LARGE)
		safe_throw_at(get_edge_target_turf(src, get_dir(user, src)), 2, 1, user)
		hitverb = "slam"
	playsound(loc, /datum/sound_effect/punch, 25, TRUE, -1)
	visible_message(span_danger("[user] [hitverb]s [src]!"), \
					span_userdanger("[user] [hitverb]s you!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You [hitverb] [src]!"))

/mob/living/carbon/alien/adult/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return TRUE
	var/damage = rand(1, 9)
	if (prob(90))
		playsound(loc, /datum/sound_effect/punch, 25, TRUE, -1)
		visible_message(span_danger("[user] punches [src]!"), \
						span_userdanger("[user] punches you!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("You punch [src]!"))
		if ((stat != DEAD) && (damage > 9 || prob(5)))//Regular humans have a very small chance of knocking an alien down.
			Unconscious(40)
			visible_message(span_danger(LANG("mob.b28257ff017a2b6e", list(user, src))), \
							span_userdanger(LANG("mob.f835f12eb2f64f6a", list(user))), span_hear(LANG("mob.6c7f8149b8c68cd4", null)), null, user)
			to_chat(user, span_danger(LANG("mob.f940e5d333cedcf7", list(src))))
		var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(user.zone_selected))
		apply_damage(damage, BRUTE, affecting)
		log_combat(user, src, "attacked")
	else
		playsound(loc, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
		visible_message(span_danger(LANG("mob.02d8b90bf7cab7c8", list(user, src))), \
						span_danger(LANG("mob.1c13df50e998dbb3", list(user))), span_hear(LANG("mob.b8189c1ed616b3a4", null)), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_warning(LANG("mob.67d5615ccb5f4c93", list(src))))

/mob/living/carbon/alien/adult/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_CLAW
	..()
