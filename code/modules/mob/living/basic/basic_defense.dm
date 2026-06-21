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
				span_notice("[user] [response_help_continuous] [src]。"),
				span_notice("[user] [response_help_continuous] 你。"),
				ignored_mobs = user,
			)
			to_chat(user, span_notice("你[response_help_simple]了[src]。"))
			playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)
		return TRUE

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("你不想伤害[src]！"))
		return TRUE
	var/obj/item/bodypart/arm/active_arm = user.get_active_hand()
	var/damage = (basic_mob_flags & IMMUNE_TO_FISTS) ? 0 : rand(active_arm.unarmed_damage_low, active_arm.unarmed_damage_high)
	if(check_block(user, damage, "[user]'s punch", UNARMED_ATTACK, 0, BRUTE))
		return
	user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
	visible_message(
		span_danger("[user]正在[response_harm_continuous][src]！"),
		span_userdanger("[user]正在[response_harm_continuous]你！"),
		vision_distance = COMBAT_MESSAGE_RANGE,
		ignored_mobs = user,
	)
	to_chat(user, span_danger("你[response_harm_simple]了[src]！"))
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
		span_danger("[shover.name] [response_disarm_continuous]了[src][moved ? ", pushing [p_them()]" : ""]！"),
		span_danger("你[response_disarm_simple]了[src][moved ? ", pushing [p_them()]" : ""]！"),
		span_hear("你听到一阵激烈的推搡声！"),
		COMBAT_MESSAGE_RANGE,
		list(src),
	)
	to_chat(src, span_userdanger("你被[moved ? "pushed" : "shoved"] [shover.name]了！"))

/mob/living/basic/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	playsound(loc, SFX_PUNCH, 25, TRUE, -1)
	visible_message(span_danger("[user]猛击了[src]！"), \
					span_userdanger("你被[user]猛击了！"), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("你猛击了[src]！"))
	apply_damage(15, damagetype = BRUTE)

/mob/living/basic/attack_paw(mob/living/carbon/human/user, list/modifiers)
	if(..()) //successful monkey bite.
		if(stat != DEAD)
			return apply_damage(rand(1, 3))

	if (!user.combat_mode)
		if (health > 0)
			visible_message(span_notice("[user.name]正在[response_help_continuous][src]。"), \
							span_notice("[user.name]正在[response_help_continuous]你。"), null, COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_notice("你[response_help_simple]了[src]。"))
			playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)


/mob/living/basic/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	. = ..()
	if(!.)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		playsound(loc, 'sound/items/weapons/pierce.ogg', 25, TRUE, -1)
		visible_message(span_danger("[user][response_disarm_continuous]了[name]！"), \
			span_userdanger("[user][response_disarm_continuous]了你！"), null, COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("你[response_disarm_simple]了[name]！"))
		log_combat(user, src, "disarmed")
		return
	var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
	visible_message(span_danger("[user]向[src]挥砍！"), \
		span_userdanger("[user]向你挥砍！"), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("你向[src]挥砍！"))
	playsound(loc, 'sound/items/weapons/slice.ogg', 25, TRUE, -1)
	apply_damage(damage)
	log_combat(user, src, "attacked")

/mob/living/basic/attack_larva(mob/living/carbon/alien/larva/attacking_larva, list/modifiers)
	. = ..()
	if(. && stat != DEAD) //successful larva bite
		var/damage_done = apply_damage(rand(attacking_larva.melee_damage_lower, attacking_larva.melee_damage_upper), BRUTE)
		if(damage_done > 0)
			attacking_larva.amount_grown = min(attacking_larva.amount_grown + damage_done, attacking_larva.max_grown)

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
			set_stat(CONSCIOUS)
	med_hud_set_status()

/mob/living/basic/emp_act(severity)
	. = ..()
	if(mob_biotypes & MOB_ROBOTIC)
		emp_reaction(severity)

/mob/living/basic/proc/emp_reaction(severity)
	switch(severity)
		if(EMP_LIGHT)
			visible_message(span_danger("[src]剧烈震动，零件开始松动！"))
			apply_damage(maxHealth * 0.6)
			Shake(duration = 1 SECONDS)
		if(EMP_HEAVY)
			visible_message(span_danger("[src]突然爆裂开来！"))
			apply_damage(maxHealth)
