/datum/martial_art/jungle_arts
	name = "丛林格斗术"
	id = MARTIALART_JUNGLEARTS
	pacifist_style = TRUE

/datum/martial_art/jungle_arts/disarm_act(mob/living/attacker, mob/living/defender)
	return jungle_attack(attacker, defender)

/datum/martial_art/jungle_arts/grab_act(mob/living/attacker, mob/living/defender)
	return jungle_attack(attacker, defender, TRUE)

/datum/martial_art/jungle_arts/harm_act(mob/living/attacker, mob/living/defender)
	return jungle_attack(attacker, defender)

/datum/martial_art/jungle_arts/proc/jungle_attack(mob/living/attacker, mob/living/defender, grab_attack)
	var/atk_verb
	switch(rand(1,6))
		if(1)
			atk_verb = "dragged"
			var/obj/item/organ/tail/tail = attacker.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
			if(isnull(tail) && defender.stat != CONSCIOUS || defender.IsParalyzed())
				return MARTIAL_ATTACK_INVALID

			attacker.do_attack_animation(defender, ATTACK_EFFECT_CLAW)
			attacker.emote("spin")
			defender.visible_message(
				span_danger("[attacker]的尾巴[atk_verb]将[defender]击倒在地！"),
				span_userdanger("你的身体扭曲着，被[attacker]的尾巴[atk_verb]到了地上！"),
				span_hear("你听到一声脆响，紧接着是重物落地的声音！"),
				null,
				attacker,
			)
			to_chat(attacker, span_danger("你用尾巴缠住[defender]，将他们[atk_verb]在地！"))
			defender.apply_damage(rand(5, 10), attacker.get_attack_type())
			playsound(attacker, 'sound/items/weapons/whip.ogg', 50, TRUE, -1)
			defender.Knockdown(2 SECONDS)
			if(HAS_TRAIT(attacker, TRAIT_PACIFISM))
				attacker.add_mood_event("bypassed_pacifism", /datum/mood_event/pacifism_bypassed)

		if(6)
			var/obj/item/organ/tail/tail = attacker.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
			if(isnull(tail))
				return MARTIAL_ATTACK_INVALID

			atk_verb = pick("whipped", "flogged", "lashed")
			attacker.do_attack_animation(defender, ATTACK_EFFECT_CLAW)
			defender.visible_message(
				span_danger("[attacker]的尾巴以迅雷之势[atk_verb]了[defender]！"),
				span_userdanger("你感到一阵刺痛，被[attacker][atk_verb]了！"),
				span_hear("你听到一声尖锐的抽打声！"),
				null,
				attacker,
			)
			to_chat(attacker, span_danger("你以迅捷的动作[atk_verb]了[defender]！"))
			defender.apply_damage(rand(10, 15), attacker.get_attack_type())
			playsound(attacker, 'sound/items/weapons/whip.ogg', 50, TRUE, -1)
			defender.drop_all_held_items()
			if(HAS_TRAIT(attacker, TRAIT_PACIFISM))
				attacker.add_mood_event("bypassed_pacifism", /datum/mood_event/pacifism_bypassed)

		else
			atk_verb = pick("chomp", "gnaw", "chew")
			if(defender.check_block(attacker, 0, "[attacker]'s [atk_verb]", UNARMED_ATTACK))
				return MARTIAL_ATTACK_FAIL

			attacker.do_attack_animation(defender, ATTACK_EFFECT_BITE)
			defender.visible_message(
				span_danger("[attacker]凶猛地[atk_verb]了[defender]！"),
				span_userdanger("你被[attacker]凶残地[atk_verb]了！"),
				span_hear("你听到一阵凶猛的撕咬声！"),
				null,
				attacker,
			)
			to_chat(attacker, span_danger("你以凶猛的力道[atk_verb]了[defender]！"))
			defender.apply_damage(rand(10, 20), damagetype = BRUTE, sharpness = SHARP_POINTY, wound_bonus = 50)
			playsound(attacker, 'sound/items/weapons/bite.ogg', 50, TRUE, -1)
			if(HAS_TRAIT(attacker, TRAIT_PACIFISM))
				attacker.add_mood_event("bypassed_pacifism", /datum/mood_event/pacifism_bypassed)

	if(atk_verb)
		log_combat(attacker, defender, "[atk_verb] (Jungle Arts)")
		return MARTIAL_ATTACK_SUCCESS

	return MARTIAL_ATTACK_FAIL
