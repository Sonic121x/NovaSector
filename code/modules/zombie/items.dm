/obj/item/mutant_hand/zombie
	name = "僵尸爪"
	desc = "A zombie's claw is its primary tool, capable of infecting \
		humans, butchering all other living things to \
		sustain the zombie, smashing open airlock doors and opening \
		child-safe caps on bottles."

	hitsound = 'sound/effects/hallucinations/growl1.ogg'
	force = 21 // Just enough to break airlocks with melee attacks
	wound_bonus = -30
	exposed_wound_bonus = 15
	sharpness = SHARP_EDGED
	/// Chance of infection on hit
	var/infect_chance = 100

/obj/item/mutant_hand/zombie/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(QDELETED(target))
		return
	if(ishuman(target))
		try_to_zombie_infect(target, user, user.zone_selected, infect_chance)
	else if(isliving(target))
		check_feast(target, user)

/obj/item/mutant_hand/zombie/weak
	force = 16
	demolition_mod = 1.33
	exposed_wound_bonus = 10
	infect_chance = 50

/proc/try_to_zombie_infect(mob/living/carbon/human/target, mob/living/user, def_zone = BODY_ZONE_CHEST, base_chance = 100)
	CHECK_DNA_AND_SPECIES(target)
	if(!prob(base_chance))
		return

	// Can't zombify with no head
	if(!target.get_bodypart(BODY_ZONE_HEAD))
		return

	if(HAS_TRAIT(target, TRAIT_NO_ZOMBIFY))
		// cannot infect any TRAIT_NO_ZOMBIFY human
		return

	// spaceacillin has a 75% chance to block infection
	if(HAS_TRAIT(target, TRAIT_VIRUS_RESISTANCE) && !HAS_TRAIT(target, TRAIT_IMMUNODEFICIENCY) && prob(75))
		return

	var/obj/item/bodypart/actual_limb = target.get_bodypart(def_zone)

	// What you hitting bro?
	if(!actual_limb)
		return

	var/limb_damage = actual_limb.get_damage()
	var/limb_armor = max(0, target.getarmor(actual_limb, BIO) - 25)

	// This is a pretty jank way to do this, but in short:
	// if they have thick material on that bodypart it will always need at least 25 previous limb damage to trigger an infection.
	// and if their bio armor isn't thick it's a bit weaker.
	for(var/obj/item/clothing/iter_clothing in target.get_clothing_on_part(actual_limb))
		if(iter_clothing.clothing_flags & THICKMATERIAL)
			limb_armor += 25

	if(limb_armor > limb_damage)
		return

	var/obj/item/organ/zombie_infection/infection
	infection = target.get_organ_slot(ORGAN_SLOT_ZOMBIE)
	if(!infection)
		infection = new()
		infection.Insert(target)
		to_chat(user, span_alien("你看见 [target] 抽搐了一下，因为 [target.p_their()] 头被 \a [infection] 覆盖了 - [target.p_Theyve()] 已被感染。"))

/obj/item/mutant_hand/zombie/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正在把 [user.p_their()] 的脑子扯出来！看起来 [user.p_theyre()] 试图自杀！"))
	var/obj/item/bodypart/head = user.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		head.dismember()
	return BRUTELOSS

/obj/item/mutant_hand/zombie/proc/check_feast(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		var/hp_gained = target.maxHealth
		target.investigate_log("has been devoured by a zombie.", INVESTIGATE_DEATHS)
		target.gib(DROP_ALL_REMAINS)
		var/need_mob_update
		need_mob_update = user.adjust_brute_loss(-hp_gained, updating_health = FALSE)
		need_mob_update += user.adjust_tox_loss(-hp_gained, updating_health = FALSE)
		need_mob_update += user.adjust_fire_loss(-hp_gained, updating_health = FALSE)
		need_mob_update += user.adjust_organ_loss(ORGAN_SLOT_BRAIN, -hp_gained) // Zom Bee gibbers "BRAAAAISNSs!1!"
		user.set_nutrition(min(user.nutrition + hp_gained, NUTRITION_LEVEL_FULL))
		if(need_mob_update)
			user.updatehealth()
