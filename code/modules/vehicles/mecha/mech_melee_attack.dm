// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * ## Mech melee attack
 * Called when a mech melees a target with fists
 * Handles damaging the target & associated effects
 * return value is number of damage dealt. returning a value puts our mech onto attack cooldown.
 * Arguments:
 * * mecha_attacker: Mech attacking this target
 * * user: mob that initiated the attack from inside the mech as a controller
 */
/atom/proc/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/living/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_MECH, mecha_attacker, user)
	if(!isnull(user))
		log_combat(user, src, "attacked", mecha_attacker, "(COMBAT MODE: [uppertext(user?.combat_mode)] (DAMTYPE: [uppertext(mecha_attacker.damtype)])")
	return

/turf/closed/wall/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/living/user)
	if(!user.combat_mode)
		return

	mecha_attacker.do_attack_animation(src)
	switch(mecha_attacker.damtype)
		if(BRUTE)
			playsound(src, mecha_attacker.brute_attack_sound, 50, TRUE)
		if(BURN)
			playsound(src, mecha_attacker.burn_attack_sound, 50, TRUE)
		else
			return
	mecha_attacker.visible_message(span_danger(LANG("turf.930925c90cfa47ef", list(mecha_attacker, src))), span_danger(LANG("turf.b9c76307fa1ce6c0", list(src))), null, COMBAT_MESSAGE_RANGE)
	if(prob(hardness + mecha_attacker.force) && mecha_attacker.force > 20)
		dismantle_wall(1)
		playsound(src, mecha_attacker.destroy_wall_sound, 100, TRUE)
	else
		add_dent(WALL_DENT_HIT)
	..()
	return 100 //this is an arbitrary "damage" number since the actual damage is rng dismantle

/obj/structure/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/living/user)
	if(!user.combat_mode)
		return 0

	mecha_attacker.do_attack_animation(src)
	switch(mecha_attacker.damtype)
		if(BRUTE)
			playsound(src, 'sound/items/weapons/punch4.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/tools/welder.ogg', 50, TRUE)
		else
			return
	mecha_attacker.visible_message(span_danger(LANG("obj.930925c90cfa47ef", list(mecha_attacker, src))), span_danger(LANG("obj.b9c76307fa1ce6c0", list(src))), null, COMBAT_MESSAGE_RANGE)
	..()
	return take_damage(mecha_attacker.force * 3, mecha_attacker.damtype, "melee", FALSE, get_dir(src, mecha_attacker)) // multiplied by 3 so we can hit objs hard but not be overpowered against mobs.

/obj/machinery/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/living/user)
	if(!user.combat_mode)
		return

	mecha_attacker.do_attack_animation(src)
	switch(mecha_attacker.damtype)
		if(BRUTE)
			playsound(src, mecha_attacker.brute_attack_sound, 50, TRUE)
		if(BURN)
			playsound(src, mecha_attacker.burn_attack_sound, 50, TRUE)
		else
			return
	mecha_attacker.visible_message(span_danger(LANG("obj.930925c90cfa47ef", list(mecha_attacker, src))), span_danger(LANG("obj.b9c76307fa1ce6c0", list(src))), null, COMBAT_MESSAGE_RANGE)
	..()
	return take_damage(mecha_attacker.force * 3, mecha_attacker.damtype, "melee", FALSE, get_dir(src, mecha_attacker)) // multiplied by 3 so we can hit objs hard but not be overpowered against mobs.

/obj/structure/window/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/living/user)
	if(!user.combat_mode)
		return
	if(!can_be_reached())
		return

	mecha_attacker.do_attack_animation(src)
	switch(mecha_attacker.damtype)
		if(BRUTE)
			playsound(src, mecha_attacker.brute_attack_sound, 50, TRUE)
		if(BURN)
			playsound(src, mecha_attacker.burn_attack_sound, 50, TRUE)
		else
			return
	mecha_attacker.visible_message(span_danger(LANG("obj.7a1087988164048b", list(mecha_attacker, src))), span_danger(LANG("obj.0bb07f957486c351", list(src))), null, COMBAT_MESSAGE_RANGE)
	// Additionally destroy any grilles
	for(var/obj/structure/grille/grille in src.loc)
		if(istype(grille))
			grille.take_damage(mecha_attacker.force * 10, mecha_attacker.damtype, "melee", FALSE, get_dir(src, mecha_attacker))
	..()
	return take_damage(mecha_attacker.force * 100, mecha_attacker.damtype, "melee", FALSE, get_dir(src, mecha_attacker))

/obj/vehicle/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/living/user)
	if(!user.combat_mode)
		return FALSE

	mecha_attacker.do_attack_animation(src)
	switch(mecha_attacker.damtype)
		if(BRUTE)
			playsound(src, 'sound/items/weapons/punch4.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/tools/welder.ogg', 50, TRUE)
		else
			return
	mecha_attacker.visible_message(span_danger(LANG("obj.930925c90cfa47ef", list(mecha_attacker, src))), span_danger(LANG("obj.b9c76307fa1ce6c0", list(src))), null, COMBAT_MESSAGE_RANGE)
	..()
	return take_damage(mecha_attacker.force, mecha_attacker.damtype, "melee", FALSE, get_dir(src, mecha_attacker))

/mob/living/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/living/user)
	if(istype(user) && !user.combat_mode)
		step_away(src, mecha_attacker)
		log_combat(user, src, "pushed", mecha_attacker)
		visible_message(span_warning(LANG("mob.c106d8a61426eca0", list(mecha_attacker, src))), \
						span_warning(LANG("mob.9078dd7a201986a4", list(mecha_attacker))), span_hear(LANG("mob.7314bbd171d7d8b7", null)), 5, list(mecha_attacker))
		to_chat(mecha_attacker, span_danger(LANG("mob.3120248279b4b581", list(src))))
		return

	if(!isnull(user) && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning(LANG("mob.c2a13fcc69a895f5", null)))
		return

	mecha_attacker.do_attack_animation(src)
	if(mecha_attacker.damtype == BRUTE)
		step_away(src, mecha_attacker, 15)

	if(check_block(mecha_attacker, mecha_attacker.force * 3, "the [mecha_attacker.attack_verbs[1]]", attack_type = OVERWHELMING_ATTACK))
		return

	switch(mecha_attacker.damtype)
		if(BRUTE)
			if(mecha_attacker.force > 35) // durand and other heavy mechas
				mecha_attacker.melee_attack_effect(src, heavy = TRUE)
			else if(mecha_attacker.force > 20 && !IsKnockdown()) // lightweight mechas like gygax
				mecha_attacker.melee_attack_effect(src, heavy = FALSE)
			playsound(src, mecha_attacker.brute_attack_sound, 50, TRUE)
		if(BURN)
			playsound(src, mecha_attacker.burn_attack_sound, 50, TRUE)
		if(TOX)
			playsound(src, mecha_attacker.tox_attack_sound, 50, TRUE)
			var/bio_armor = (100 - run_armor_check(attack_flag = BIO, silent = TRUE)) / 100
			if((reagents.get_reagent_amount(/datum/reagent/cryptobiolin) + mecha_attacker.force) < mecha_attacker.force * 2)
				reagents.add_reagent(/datum/reagent/cryptobiolin, mecha_attacker.force / 2 * bio_armor)
			if((reagents.get_reagent_amount(/datum/reagent/toxin) + mecha_attacker.force) < mecha_attacker.force * 2)
				reagents.add_reagent(/datum/reagent/toxin, mecha_attacker.force / 2.5 * bio_armor)
		else
			return

	var/damage = rand(mecha_attacker.force * 0.5, mecha_attacker.force)
	if (mecha_attacker.damtype == BRUTE || mecha_attacker.damtype == BURN)
		var/def_zone = get_random_valid_zone(user?.zone_selected, even_weights = TRUE)
		var/zone_readable = parse_zone_with_bodypart(def_zone)
		apply_damage(damage, mecha_attacker.damtype, def_zone, run_armor_check(
			def_zone = def_zone,
			attack_flag = MELEE,
			absorb_text = span_notice("Your armor has protected your [zone_readable]!"),
			soften_text = span_warning("Your armor has softened a hit to your [zone_readable]!")
		))

	visible_message(span_danger(LANG("mob.dd02d8c90a5dee7a", list(mecha_attacker.name, mecha_attacker.attack_verbs[1], src))), \
		span_userdanger(LANG("mob.9ab70b397edc0103", list(mecha_attacker.name, mecha_attacker.attack_verbs[2]))), span_hear(LANG("mob.1b6c62e7dcbc3538", list(mecha_attacker.attack_verbs[3]))), COMBAT_MESSAGE_RANGE, list(mecha_attacker))
	to_chat(mecha_attacker, span_danger(LANG("mob.22d557f300d422c9", list(mecha_attacker.attack_verbs[1], src))))
	..()
	return damage
