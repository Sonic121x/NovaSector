
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
		visible_message(span_danger("[user]向[src]挥爪！"), \
						span_userdanger("[user]向你挥爪！"), null, null, user)
		to_chat(user, span_danger("你向[src]挥爪！"))
		if(prob(8))
			flash_act(affect_silicon = 1)
		adjust_brute_loss(damage)
		log_combat(user, src, "attacked")
	else
		playsound(loc, 'sound/items/weapons/slashmiss.ogg', 25, TRUE, -1)
		visible_message(span_danger("[user]的挥击未能命中[src]！"),
						span_danger("你躲开了[user]的挥击！"), null, null, user)
		to_chat(user, span_warning("你的挥击未能命中[src]！"))
		log_combat(user, src, "attacked and missed")

/mob/living/silicon/attack_animal(mob/living/simple_animal/user, list/modifiers)
	. = ..()
	var/damage_received = .
	if(prob(damage_received))
		for(var/mob/living/buckled in buckled_mobs)
			buckled.Paralyze(2 SECONDS)
			unbuckle_mob(buckled)
			buckled.visible_message(
				span_danger("[buckled]被[user]从[src]身上撞了下来！"),
				span_userdanger("你被[user]从[src]身上撞了下来！"),
				ignored_mobs = user,
			)
			to_chat(user, span_danger("你将[buckled]从[src]身上撞了下来！"))

/mob/living/silicon/attack_paw(mob/living/user, list/modifiers)
	return attack_hand(user, modifiers)

/mob/living/silicon/attack_larva(mob/living/carbon/alien/larva/L, list/modifiers)
	if(!L.combat_mode)
		visible_message(span_notice("[L.name]用头蹭了蹭[src]。"))

/mob/living/silicon/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	adjust_brute_loss(rand(10, 15))
	playsound(loc, SFX_PUNCH, 25, TRUE, -1)
	visible_message(span_danger("[user]猛击[src]！"), \
					span_userdanger("[user]猛击了你！"), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("你猛击了[src]！"))

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
		visible_message(span_danger("[user]猛击了[src]，但没留下任何凹痕！"), \
						span_warning("[user] 打了你一拳，但没留下凹痕！"), null, COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("你打了 [src] 一拳，但没留下凹痕！"))
		return TRUE
	else
		// NOVA EDIT ADDITION START
		if(HAS_TRAIT(src, TRAIT_QUICKREFLEXES) && (src.stat != UNCONSCIOUS) && !INCAPACITATED_IGNORING(src, INCAPABLE_RESTRAINTS))
			visible_message(span_warning("[user] 试图抚摸 [src]，但它躲开了。"))
			return TRUE
		// NOVA EDIT ADDITION END
		visible_message(span_notice("[user] 抚摸着 [src]。"), span_notice("[user] 抚摸着你。"), null, null, user)
		to_chat(user, span_notice("你抚摸着 [src]。"))
		SEND_SIGNAL(user, COMSIG_MOB_PAT_BORG)
		return TRUE

/mob/living/silicon/check_block(atom/hitby, damage, attack_text, attack_type, armour_penetration, damage_type, attack_flag)
	. = ..()
	if(. == SUCCESSFUL_BLOCK)
		return SUCCESSFUL_BLOCK
	if(damage_type == BRUTE && attack_type == UNARMED_ATTACK && attack_flag == MELEE && damage <= 10)
		playsound(src, 'sound/effects/bang.ogg', 10, TRUE)
		visible_message(span_danger("[attack_text] 在 [src] 上没留下凹痕！"), vision_distance = COMBAT_MESSAGE_RANGE)
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
	to_chat(src, span_danger("警告：检测到电磁脉冲。"))
	if(. & EMP_PROTECT_SELF || QDELETED(src))
		return
	switch(severity)
		if(1)
			src.take_bodypart_damage(burn = 20)
		if(2)
			src.take_bodypart_damage(burn = 10)
	to_chat(src, span_userdanger("*哔滋滋*"))
	for(var/mob/living/M in buckled_mobs)
		if(prob(severity*50))
			unbuckle_mob(M)
			M.Paralyze(40)
			M.visible_message(span_boldwarning("[M] 被从 [src] 上甩了下来！"))
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
			buckled.visible_message(span_boldwarning("[buckled] 被 [hitting_projectile] 从 [src] 上击落！"))
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
