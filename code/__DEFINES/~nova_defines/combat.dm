
//Stamina threshold from which resisting a grab becomes hard
#define STAMINA_THRESHOLD_HARD_RESIST 80

//Resting thresholds
#define STAMINA_THRESHOLD_MEDIUM_GET_UP 50
#define STAMINA_THRESHOLD_SLOW_GET_UP 100

//Standing times in seconds
#define GET_UP_FAST 0.6
#define GET_UP_MEDIUM 1.5
#define GET_UP_SLOW 3

//Stamina threshold for attacking slower with items
#define STAMINA_THRESHOLD_TIRED_CLICK_CD 120
#define CLICK_CD_RANGE_TIRED 5 //#define CLICK_CD_RANGE 4, so 25% slower

//Grab breakout odds
#define OVERSIZED_GRAB_RESIST_BONUS 10 /// For those with the oversized trait, they get this.

//Grab breakout bonus for akulas when at 10+ wet_stacks
#define AKULA_GRAB_RESIST_BONUS 10

// Damage modifiers
#define OVERSIZED_HARM_DAMAGE_BONUS 5 /// Those with the oversized trait do 5 more damage.
#define OVERSIZED_KICK_EFFECTIVENESS_BONUS 5 /// Increased unarmed_effectiveness/stun threshold on oversized kicks.

//Force mob to rest, does NOT do stamina damage.
//It's really not recommended to use this proc to give feedback, hence why silent is defaulting to true.
/mob/living/carbon/proc/KnockToFloor(silent = TRUE, ignore_canknockdown = FALSE, knockdown_amt = 1)
	if(!silent && body_position != LYING_DOWN)
		to_chat(src, span_warning("你被击倒在地！"))
	Knockdown(knockdown_amt, ignore_canknockdown)

/mob/living/proc/StaminaKnockdown(stamina_damage, disarm, brief_stun, hardstun, ignore_canknockdown = FALSE, paralyze_amount, knockdown_amt = 1)
	if(!stamina_damage)
		return
	return Paralyze((paralyze_amount ? paralyze_amount : stamina_damage))

/mob/living/carbon/StaminaKnockdown(stamina_damage, disarm, brief_stun, hardstun, ignore_canknockdown = FALSE, paralyze_amount, knockdown_amt = 1)
	if(!stamina_damage)
		return
	if(!ignore_canknockdown && !(status_flags & CANKNOCKDOWN))
		return FALSE
	if(istype(buckled, /obj/vehicle/ridden))
		buckled.unbuckle_mob(src)
	KnockToFloor(TRUE, ignore_canknockdown, knockdown_amt)
	adjust_stamina_loss(stamina_damage)
	if(disarm)
		drop_all_held_items()
	if(brief_stun)
		//Stun doesnt send a proper signal to stand up, so paralyze for now
		Paralyze(0.25 SECONDS)
	if(hardstun)
		Paralyze((paralyze_amount ? paralyze_amount : stamina_damage))

#define HEADSMASH_BLOCK_ARMOR 20
#define SUPLEX_TIMER 3 SECONDS

/// alt-clicking a human as another human while grappling them tightly makes you try for grappling-based maneuvers.
/mob/living/carbon/human/click_alt(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/human_user = user
	if(human_user != src && human_user.combat_mode && !human_user.dna.species.try_grab_maneuver(user, src))
		return CLICK_ACTION_BLOCKING

/// State check for grab maneuver - because you can't logically suplex a man if you've stopped grappling them.
/datum/species/proc/grab_maneuver_state_check(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return (target.pulledby && target.pulledby == user && user.grab_state > GRAB_PASSIVE)

/// Tries a grab maneuver - suplex, limb dislocation, or headslam depending on targeted limb.
/datum/species/proc/try_grab_maneuver(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!grab_maneuver_state_check(user, target))
		return FALSE
	// psst, future coder - if you're adding more precise interactions, e.g. eye gouging/strangling, you're gonna need to make this less precise!
	// just remove the deprecise_zone() call. account for the specifics after!
	var/obj/item/bodypart/affecting = target.get_bodypart(deprecise_zone(user.zone_selected))
	if(!affecting)
		return FALSE
	. = FALSE
	if(HAS_TRAIT(user, TRAIT_PACIFISM)) //They're all violent acts. Even the suplex, which doesn't apply brute. (Yet. Maybe.)
		return
	switch(deprecise_zone(user.zone_selected))
		if(BODY_ZONE_HEAD)
			if(!(target.body_position == LYING_DOWN))
				target.balloon_alert(user, "未倒地！")
				return FALSE
			. = TRUE
			try_headslam(user, target, affecting)
		if(BODY_ZONE_CHEST)
			if(istype((user.martial_arts ? (isnum(1) ? (1 > 0 && 1 <= length(user.martial_arts) ? user.martial_arts[1] : null) : user.martial_arts[1]) : null), /datum/martial_art/cqc)) // This is terrible but LAZYACCESS is not defined at this point so we must invoke it without using the macro..
			// If you know CQC, You can't suplex and instead have the ability to use the chokehold, Sorry.
			// Sleeping people on demand is stronger anyway.
				return FALSE
			// Suplex!
			. = TRUE
			try_suplex(user, target)
		else // Assuming we're going for a limb...
			var/datum/wound/blunt/blute_wound = affecting.get_wound_type(/datum/wound/blunt)
			if(blute_wound && blute_wound.severity >= WOUND_SEVERITY_MODERATE)
				blute_wound.try_handling(user) // handle it like any other dislocation (if you're still in combat mode, you will attempt to make it worse)
				return TRUE
			// Dislocate!
			. = TRUE
			try_dislocate(user, target, affecting)

	if(.)
		user.changeNext_move(CLICK_CD_MELEE)
	return

/// Attempts to perform a suplex after SUPLEX_TIMER, causing both to be stunned. (Why spacemen are able to do such a thing on reflex, nobody knows.)
/datum/species/proc/try_suplex(mob/living/carbon/human/user, mob/living/carbon/human/target)
	target.visible_message(span_danger("[user.name]紧紧抱住[target.name]，开始将[target.p_them()]举起来！"), \
			span_userdanger("[user.name]紧紧抱住你，将你举了起来！"), ignored_mobs=user)
	to_chat(user, span_danger("你紧紧抱住[target.name]并将[target.p_them()]举起..."))
	user.changeNext_move(SUPLEX_TIMER)
	if(!do_after(user, SUPLEX_TIMER, target) || !grab_maneuver_state_check(user, target))
		return FALSE
	var/move_dir = get_dir(target, user)
	var/turf/moved_turf = get_turf(target)
	for(var/i in 1 to 2)
		var/turf/next_turf = get_step(moved_turf, move_dir)
		if(IS_OPAQUE_TURF(next_turf))
			break
		moved_turf = next_turf
	target.visible_message(span_danger("[user.name]将[target.name]摔倒在地！"), \
		span_userdanger("[user.name]摔了你！"), ignored_mobs=user)
	to_chat(user, span_danger("你对[target.name]使出了过肩摔！"))
	user.StaminaKnockdown(30, TRUE, TRUE)
	user.SpinAnimation(7,1)
	target.SpinAnimation(7,1)
	target.throw_at(moved_turf, 1, 1)
	target.StaminaKnockdown(80)
	target.Paralyze(2 SECONDS)
	// feels like there should be some funny brute here but iunno
	log_combat(user, target, "suplexes", "down on the ground (knocking down both)")

/// Attempts to perform a headslam, with the user slamming target's head into the floor. (Does not account for the potential nonexistence of aforementioned floor, e.g. space.)
/datum/species/proc/try_headslam(mob/living/carbon/human/user, mob/living/carbon/human/target, obj/item/bodypart/affecting)
	var/time_doing = 4 SECONDS
	if(target.stat != CONSCIOUS)
		time_doing = 2 SECONDS
		target.visible_message(span_danger("[user]紧紧抓住了[target]的头……"), ignored_mobs = user)
		to_chat(user, span_danger("你抓住[target]的头，准备将其猛砸下去……"))
	else
		target.visible_message(span_danger("[user]抓住[target]的头，试图压制[target.p_them()]！"), \
			span_userdanger("你挣扎着，因为[user]抓住了你的头并试图压制你！"), ignored_mobs = user)
		to_chat(user, span_danger("你抓住[target]的头，试图压制[target.p_them()]……"))
	user.changeNext_move(time_doing)
	if(!do_after(user, time_doing, target) || !grab_maneuver_state_check(user, target))
		return
	var/armor_block = target.run_armor_check(affecting, MELEE)
	var/head_knock = FALSE
	// Check to see if our head is protected by at least HEADSMASH_BLOCK_ARMOR (20 melee armor)
	if(armor_block < HEADSMASH_BLOCK_ARMOR)
		head_knock = TRUE

	target.visible_message(span_danger("[user.name]将[target.name]的头狠狠砸向地板！"), \
		span_userdanger("[user.name]将你的头砸向地板！"), ignored_mobs = user)
	to_chat(user, span_danger("你将[target.name]的头砸向地板！"))

	// wound bonus because if you're doing this you probably really don't like the other guy so you're looking forward to inconveniencing them (with a fracture)
	var/fun_times_at_the_headbash_factory = (head_knock ? 8 : 3)
	if(head_knock)
		target.adjust_organ_loss(ORGAN_SLOT_BRAIN, 15)
	target.apply_damage(15, BRUTE, affecting, armor_block, wound_bonus = fun_times_at_the_headbash_factory, exposed_wound_bonus = fun_times_at_the_headbash_factory)
	playsound(target, 'sound/effects/hit_kick.ogg', 70)
	log_combat(user, target, "headsmashes", "against the floor")

/// Attempts to perform a limb dislocation, with the user violently twisting one of target's limbs (as passed in). Only useful for extremities, because only extremities can eat dislocations.
/datum/species/proc/try_dislocate(mob/living/carbon/human/user, mob/living/carbon/human/target, obj/item/bodypart/affecting)
	var/datum/wound_pregen_data/pregen_data = GLOB.all_wound_pregen_data[/datum/wound/blunt/bone/moderate]
	if (!pregen_data)
		stack_trace("/datum/wound/blunt/bone/moderate has no pregen data!")
		return FALSE // shouldnt happen but sanity

	if (!pregen_data.can_be_applied_to(affecting, random_roll = FALSE))
		if (!(affecting.biological_state & BIO_JOINTED))
			to_chat(user, span_warning("[target]的[affecting.plaintext_zone]没有关节可以脱臼！"))
		return FALSE

	user.changeNext_move(4 SECONDS)
	target.visible_message(span_danger("[user.name]猛烈扭动[target.name]的[affecting.name]！"), \
			span_userdanger("[user.name]猛烈扭动你的[affecting.name]！"), ignored_mobs=user)
	to_chat(user, span_danger("你开始猛烈扭动[target.name]的[affecting.name]！"))
	if(!do_after(user, 4 SECONDS, target) || !grab_maneuver_state_check(user, target))
		return FALSE
	target.visible_message(span_danger("[user.name]使[target.name]的[affecting.name]脱臼了！"), \
		span_userdanger("[user.name]使你的[affecting.name]脱臼了！"), ignored_mobs=user)
	to_chat(user, span_danger("你使[target.name]的[affecting.name]脱臼了！"))
	affecting.force_wound_upwards(/datum/wound/blunt/bone/moderate)
	log_combat(user, target, "dislocates", "the [affecting.name]")
	return TRUE

#undef HEADSMASH_BLOCK_ARMOR
#undef SUPLEX_TIMER
