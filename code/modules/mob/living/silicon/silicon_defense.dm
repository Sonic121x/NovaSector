// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/mob/living/silicon/grippedby(mob/living/carbon/user, instant = FALSE)
	return //can't upgrade a simple pull into a more aggressive grab.

/mob/living/silicon/get_ear_protection(ignore_deafness = FALSE)
	return ..() + EAR_PROTECTION_HEAVY //no ears

/mob/living/silicon/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	. = ..()
	if(!.) //if harm or disarm intent
		return
	var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
	if (prob(90))
		playsound(loc, 'sound/items/weapons/slash.ogg', 25, TRUE, -1)
		visible_message(span_danger(LANG("mob.f626309960b4cb84", list(user, src))), \
						span_userdanger(LANG("mob.69901f7d4c5703dd", list(user))), null, null, user)
		to_chat(user, span_danger(LANG("mob.131938c9a2fead1f", list(src))))
		if(prob(8))
			flash_act(affect_silicon = 1)
		adjust_brute_loss(damage)
		log_combat(user, src, "attacked")
	else
		playsound(loc, 'sound/items/weapons/slashmiss.ogg', 25, TRUE, -1)
		visible_message(span_danger(LANG("mob.571c02c1d01d46b2", list(user, src))),
						span_danger(LANG("mob.9066c7ee435bf444", list(user))), null, null, user)
		to_chat(user, span_warning(LANG("mob.25dce99585de9397", list(src))))
		log_combat(user, src, "attacked and missed")

/mob/living/silicon/attack_animal(mob/living/simple_animal/user, list/modifiers)
	. = ..()
	var/damage_received = .
	if(prob(damage_received))
		for(var/mob/living/buckled in buckled_mobs)
			buckled.Paralyze(2 SECONDS)
			unbuckle_mob(buckled)
			buckled.visible_message(
				span_danger(LANG("mob.42ea79bcfe9652e1", list(buckled, src, user))),
				span_userdanger(LANG("mob.71391d0ef99af5d2", list(src, user))),
				ignored_mobs = user,
			)
			to_chat(user, span_danger(LANG("mob.46c6cf9d0341ee51", list(buckled, src))))

/mob/living/silicon/attack_paw(mob/living/user, list/modifiers)
	return attack_hand(user, modifiers)

/mob/living/silicon/attack_larva(mob/living/carbon/alien/larva/L, list/modifiers)
	if(!L.combat_mode)
		visible_message(span_notice(LANG("mob.4eac7c4100f1f859", list(L.name, src))))

/mob/living/silicon/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	adjust_brute_loss(rand(10, 15))
	playsound(loc, SFX_PUNCH, 25, TRUE, -1)
	visible_message(span_danger(LANG("mob.b9f421c8ba627172", list(user, src))), \
					span_userdanger(LANG("mob.f2fc802c498bf927", list(user))), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger(LANG("mob.51733a6598f1ca7d", list(src))))

/mob/living/silicon/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return TRUE

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		user.disarm(src)
		return TRUE

	if(has_buckled_mobs() && !user.combat_mode)
		user_unbuckle_mob(buckled_mobs[1], user)
		return TRUE
	if(user.combat_mode)
		user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
		playsound(src.loc, 'sound/effects/bang.ogg', 10, TRUE)
		visible_message(span_danger(LANG("mob.0f5e5e91405f6c88", list(user, src))), \
						span_warning(LANG("mob.9b3994740bc2716d", list(user))), null, COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger(LANG("mob.5a1dcecf01367d81", list(src))))
		return TRUE
	else
		// NOVA EDIT ADDITION START
		if(HAS_TRAIT(src, TRAIT_QUICKREFLEXES) && !IS_UNCONSCIOUS(src) && !INCAPACITATED_IGNORING(src, INCAPABLE_RESTRAINTS))
			visible_message(span_warning(LANG("mob.c8cbe6a3d0bb9ef2", list(user, src))))
			return TRUE
		// NOVA EDIT ADDITION END
		visible_message(span_notice(LANG("mob.d1411f1ba70fd4b4", list(user, src))), span_notice(LANG("mob.f7b31bed5fda43e4", list(user))), null, null, user)
		to_chat(user, span_notice(LANG("mob.1e046c198428d755", list(src))))
		SEND_SIGNAL(user, COMSIG_MOB_PAT_BORG)
		return TRUE

/mob/living/silicon/check_block(atom/hitby, damage, attack_text, attack_type, armour_penetration, damage_type, attack_flag)
	. = ..()
	if(. == SUCCESSFUL_BLOCK)
		return SUCCESSFUL_BLOCK
	if(damage_type == BRUTE && attack_type == UNARMED_ATTACK && attack_flag == MELEE && damage <= 10)
		playsound(src, 'sound/effects/bang.ogg', 10, TRUE)
		visible_message(span_danger(LANG("mob.f5f482d8d6e9e6e0", list(attack_text, src))), vision_distance = COMBAT_MESSAGE_RANGE)
		return SUCCESSFUL_BLOCK
	return FAILED_BLOCK

/mob/living/silicon/attack_drone(mob/living/basic/drone/user)
	if(user.combat_mode)
		return
	return ..()

/mob/living/silicon/attack_drone_secondary(mob/living/basic/drone/user)
	if(user.combat_mode)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()

/mob/living/silicon/emp_act(severity)
	. = ..()
	to_chat(src, span_danger(LANG("mob.4bc10898c947a6ec", null)))
	if(. & EMP_PROTECT_SELF || QDELETED(src))
		return
	switch(severity)
		if(1)
			src.take_bodypart_damage(burn = 20)
		if(2)
			src.take_bodypart_damage(burn = 10)
	to_chat(src, span_userdanger(LANG("mob.b75817ffdd1b041c", null)))
	for(var/mob/living/M in buckled_mobs)
		if(prob(severity*50))
			unbuckle_mob(M)
			M.Paralyze(40)
			M.visible_message(span_boldwarning(LANG("mob.809681a7982a5d45", list(M, src))))
	flash_act(affect_silicon = 1)

/mob/living/silicon/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE)
	if(hitting_projectile.damage_type == BURN)
		hitting_projectile.damage_type = BRUTE //Burn is for wire damage. Brute is the outer chassis.
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	var/prob_of_knocking_dudes_off = 0
	if(hitting_projectile.damage_type == BRUTE)
		prob_of_knocking_dudes_off = hitting_projectile.damage * 1.5
	if(hitting_projectile.stun || hitting_projectile.knockdown || hitting_projectile.paralyze)
		prob_of_knocking_dudes_off = 100

	if(prob(prob_of_knocking_dudes_off))
		for(var/mob/living/buckled in buckled_mobs)
			buckled.visible_message(span_boldwarning(LANG("mob.42ea79bcfe9652e1", list(buckled, src, hitting_projectile))))
			unbuckle_mob(buckled)
			buckled.Paralyze(4 SECONDS)

/mob/living/silicon/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash/static, length = 25)
	if(affect_silicon)
		return ..()

/// If an item does this or more throwing damage it will slow a borg down on hit
#define CYBORG_SLOWDOWN_THRESHOLD 10

/mob/living/silicon/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	. = ..()
	if(. || AM.throwforce < CYBORG_SLOWDOWN_THRESHOLD) // can cyborgs even catch things?
		return
	apply_status_effect(/datum/status_effect/borg_slow, AM.throwforce / 20)

/mob/living/silicon/attack_effects(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	. = ..()
	if(damage_done < CYBORG_SLOWDOWN_THRESHOLD)
		return
	apply_status_effect(/datum/status_effect/borg_slow, damage_done / 60)

#undef CYBORG_SLOWDOWN_THRESHOLD

/mob/living/silicon/hypnosis_vulnerable()
	return FALSE //It obeys its laws
