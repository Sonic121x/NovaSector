// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/basic/attack_hand(mob/living/carbon/human/user, list/modifiers)
	// so that martial arts don't double dip
	if (..())
		return TRUE

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		user.disarm(src)
		return TRUE

	if(!user.combat_mode)
		if (stat != DEAD)
			visible_message(
				span_notice(LANG("mob.6afbb5c3aa5fc504", list(user, response_help_continuous, src))),
				span_notice(LANG("mob.e83dca4be0100ca0", list(user, response_help_continuous))),
				ignored_mobs = user,
			)
			to_chat(user, span_notice(LANG("mob.d6171b714b8cf981", list(response_help_simple, src))))
			playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)
		return TRUE

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning(LANG("mob.450cd43a10233d57", list(src))))
		return TRUE
	var/obj/item/bodypart/arm/active_arm = user.get_active_hand()
	var/damage = rand(active_arm.unarmed_damage_low, active_arm.unarmed_damage_high)
	if(check_block(user, damage, "[user]'s punch", UNARMED_ATTACK, 0, BRUTE))
		return
	user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
	visible_message(
		span_danger(LANG("mob.dd02d8c90a5dee7a", list(user, response_harm_continuous, src))),
		span_userdanger(LANG("mob.9ab70b397edc0103", list(user, response_harm_continuous))),
		vision_distance = COMBAT_MESSAGE_RANGE,
		ignored_mobs = user,
	)
	to_chat(user, span_danger(LANG("mob.22d557f300d422c9", list(response_harm_simple, src))))
	playsound(loc, attacked_sound, 25, TRUE, -1)
	apply_damage(damage)
	log_combat(user, src, "attacked")
	updatehealth()
	return TRUE

/mob/living/basic/get_shoving_message(mob/living/shover, obj/item/weapon, shove_flags)
	if(weapon) // no "gently pushing aside" if you're pressing a shield at them.
		return ..()
	var/moved = !(shove_flags & SHOVE_BLOCKED)
	shover.visible_message(
		span_danger(LANG("mob.8c599991c83e459a", list(shover.name, response_disarm_continuous, src, moved ? ", pushing [p_them()]" : ""))),
		span_danger(LANG("mob.ddf7e598608c8312", list(response_disarm_simple, src, moved ? ", pushing [p_them()]" : ""))),
		span_hear(LANG("mob.7314bbd171d7d8b7", null)),
		COMBAT_MESSAGE_RANGE,
		list(src),
	)
	to_chat(src, span_userdanger(LANG("mob.c61afe56230b45a4", list(moved ? "pushed" : "shoved", shover.name))))

/mob/living/basic/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	playsound(loc, SFX_PUNCH, 25, TRUE, -1)
	visible_message(span_danger(LANG("mob.b9f421c8ba627172", list(user, src))), \
					span_userdanger(LANG("mob.863a5da21265b0c8", list(user))), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger(LANG("mob.51733a6598f1ca7d", list(src))))
	apply_damage(15, damagetype = BRUTE)

/mob/living/basic/attack_paw(mob/living/carbon/human/user, list/modifiers)
	if(..()) //successful monkey bite.
		if(stat != DEAD)
			return apply_damage(rand(1, 3))

	if (!user.combat_mode)
		if (health > 0)
			visible_message(span_notice(LANG("mob.6afbb5c3aa5fc504", list(user.name, response_help_continuous, src))), \
							span_notice(LANG("mob.e83dca4be0100ca0", list(user.name, response_help_continuous))), null, COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_notice(LANG("mob.d6171b714b8cf981", list(response_help_simple, src))))
			playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)


/mob/living/basic/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	. = ..()
	if(!.)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		playsound(loc, 'sound/items/weapons/pierce.ogg', 25, TRUE, -1)
		visible_message(span_danger(LANG("mob.dd02d8c90a5dee7a", list(user, response_disarm_continuous, name))), \
			span_userdanger(LANG("mob.9ab70b397edc0103", list(user, response_disarm_continuous))), null, COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger(LANG("mob.22d557f300d422c9", list(response_disarm_simple, name))))
		log_combat(user, src, "disarmed")
		return
	var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
	visible_message(span_danger(LANG("mob.f626309960b4cb84", list(user, src))), \
		span_userdanger(LANG("mob.c621411c1d460629", list(user))), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger(LANG("mob.131938c9a2fead1f", list(src))))
	playsound(loc, 'sound/items/weapons/slice.ogg', 25, TRUE, -1)
	apply_damage(damage)
	log_combat(user, src, "attacked")

/mob/living/basic/attack_larva(mob/living/carbon/alien/larva/attacking_larva, list/modifiers)
	. = ..()
	if(. && stat != DEAD) //successful larva bite
		var/damage_done = apply_damage(rand(attacking_larva.melee_damage_lower, attacking_larva.melee_damage_upper), BRUTE)
		if(damage_done > 0)
			attacking_larva.amount_grown = min(attacking_larva.amount_grown + damage_done, XENOMORPH_MAX_GROWTH)

/mob/living/basic/attack_drone(mob/living/basic/drone/attacking_drone)
	if(attacking_drone.combat_mode) //No kicking dogs even as a rogue drone. Use a weapon.
		return
	return ..()

/mob/living/basic/attack_drone_secondary(mob/living/basic/drone/attacking_drone)
	if(attacking_drone.combat_mode)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()

/mob/living/basic/check_projectile_armor(def_zone, obj/projectile/impacting_projectile, is_silent)
	return 0

/mob/living/basic/ex_act(severity, target, origin)
	. = ..()
	if(!. || QDELETED(src))
		return FALSE

	var/bomb_armor = getarmor(null, BOMB)
	switch(severity)
		if (EXPLODE_DEVASTATE)
			if(prob(bomb_armor))
				apply_damage(500, damagetype = BRUTE)
			else
				investigate_log("has been gibbed by an explosion.", INVESTIGATE_DEATHS)
				gib(DROP_ALL_REMAINS)

		if (EXPLODE_HEAVY)
			var/bloss = 60
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			apply_damage(bloss, damagetype = BRUTE)

		if (EXPLODE_LIGHT)
			var/bloss = 30
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			apply_damage(bloss, damagetype = BRUTE)

	return TRUE

/mob/living/basic/blob_act(obj/structure/blob/attacking_blob)
	. = ..()
	if (!.)
		return
	apply_damage(20, damagetype = BRUTE)

/mob/living/basic/do_attack_animation(atom/attacked_atom, visual_effect_icon, used_item, no_effect)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(attack_vis_effect && !iswallturf(attacked_atom)) // override the standard visual effect.
			visual_effect_icon = attack_vis_effect
		else if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()

/mob/living/basic/update_stat()
	if(HAS_TRAIT(src, TRAIT_GODMODE))
		return
	if(stat != DEAD)
		if(health <= 0)
			death()
		else
			set_stat(STABLE)
	med_hud_set_status()

/mob/living/basic/emp_act(severity)
	. = ..()
	if(mob_biotypes & MOB_ROBOTIC)
		emp_reaction(severity)

/mob/living/basic/proc/emp_reaction(severity)
	switch(severity)
		if(EMP_LIGHT)
			visible_message(span_danger(LANG("mob.859c07833ee549db", list(src))))
			apply_damage(maxHealth * 0.6)
			Shake(duration = 1 SECONDS)
		if(EMP_HEAVY)
			visible_message(span_danger(LANG("mob.f19b957cb3e2eb1d", list(src))))
			apply_damage(maxHealth)
