// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md


/mob/living/carbon/alien/larva/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return TRUE
	var/damage = rand(1, 9)
	if (prob(90))
		playsound(loc, SFX_PUNCH, 25, TRUE, -1)
		visible_message(span_danger(LANG("mob.83af7d2cabf2a33c", list(user, src))), \
						span_userdanger(LANG("mob.cd11ce48e95a7874", list(user))), span_hear(LANG("mob.6c7f8149b8c68cd4", null)), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger(LANG("mob.23132e2f530d5b9f", list(src))))
		if ((stat != DEAD) && (damage > 4.9))
			Unconscious(rand(100,200))

		var/obj/item/bodypart/affecting = get_bodypart(get_random_valid_zone(user.zone_selected))
		apply_damage(damage, BRUTE, affecting)
		log_combat(user, src, "attacked")
	else
		playsound(loc, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
		visible_message(span_danger(LANG("mob.a20fe5ffb8a96e35", list(user, src))), \
						span_danger(LANG("mob.95e7861bb1536078", list(user))), span_hear(LANG("mob.b8189c1ed616b3a4", null)), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_warning(LANG("mob.1ee8eb9a639918a2", list(src))))
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
