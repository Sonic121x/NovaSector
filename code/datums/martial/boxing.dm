// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define LEFT_RIGHT_COMBO "DH"
#define RIGHT_LEFT_COMBO "HD"
#define LEFT_LEFT_COMBO "HH"
#define RIGHT_RIGHT_COMBO "DD"

#define STRAIGHT_PUNCH "straight_punch"
#define RIGHT_HOOK "right_hook"
#define LEFT_HOOK "left_hook"
#define UPPERCUT "uppercut"
#define LIGHT_JAB "light_jab"
#define DISCOMBOBULATE "discombobulate"
#define BLIND_JAB "blind_jab"
#define CRAVEN_BLOW "craven_blow"
#define NO_COMBO ""

/datum/martial_art/boxing
	name = "Boxing"
	id = MARTIALART_BOXING
	pacifist_style = TRUE
	help_verb = "Focus on your Form"
	/// Boolean on whether we are sportsmanlike in our tussling; TRUE means we have restrictions
	var/honorable_boxer = TRUE
	/// Can we perform grabs even if it would be dishonorable?
	var/ignore_grab_restriction = FALSE
	/// Default damage type for our boxing.
	var/default_damage_type = STAMINA
	/// List of traits applied to users of this martial art.
	var/list/boxing_traits = list(TRAIT_BOXING_READY)

/datum/martial_art/boxing/can_teach(mob/living/new_holder)
	return ishuman(new_holder)

/datum/martial_art/boxing/activate_style(mob/living/new_holder)
	. = ..()
	new_holder.add_traits(boxing_traits, BOXING_TRAIT)
	RegisterSignal(new_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))

/datum/martial_art/boxing/deactivate_style(mob/living/remove_from)
	remove_from.remove_traits(boxing_traits, BOXING_TRAIT)
	UnregisterSignal(remove_from, list(COMSIG_LIVING_CHECK_BLOCK))
	return ..()

///Unlike most instances of this proc, this is actually called in _proc/tussle()
///Returns a multiplier on our skill damage bonus.
/datum/martial_art/boxing/proc/check_streak(mob/living/attacker, mob/living/defender, obj/item/bodypart/arm/active_arm)
	if(check_behind(attacker, defender) && !honorable_boxer)
		reset_streak()
		return CRAVEN_BLOW

	if(HAS_TRAIT(attacker, TRAIT_DETECTIVES_TASTE) && defender.is_blind()) //In short: discombobulate
		reset_streak()
		return DISCOMBOBULATE

	if(findtext(streak, LEFT_LEFT_COMBO) && active_arm.body_zone == BODY_ZONE_R_ARM || findtext(streak, RIGHT_RIGHT_COMBO) && active_arm.body_zone == BODY_ZONE_L_ARM)
		reset_streak()
		if(attacker.is_blind())
			return BLIND_JAB
		else
			return LIGHT_JAB

	else if(findtext(streak, LEFT_LEFT_COMBO) && active_arm.body_zone == BODY_ZONE_L_ARM || findtext(streak, RIGHT_RIGHT_COMBO) && active_arm.body_zone == BODY_ZONE_R_ARM)
		reset_streak()
		return STRAIGHT_PUNCH

	if(findtext(streak, LEFT_RIGHT_COMBO) || findtext(streak, RIGHT_LEFT_COMBO))
		reset_streak()
		if(active_arm.body_zone == BODY_ZONE_L_ARM)
			if(findtext(streak, RIGHT_LEFT_COMBO))
				return LEFT_HOOK

		else if(active_arm.body_zone == BODY_ZONE_R_ARM)
			if(findtext(streak, LEFT_RIGHT_COMBO))
				return RIGHT_HOOK
		else
			return UPPERCUT

	return NO_COMBO

/// An extra effect on some moves and attacks.
/datum/martial_art/boxing/proc/perform_extra_effect(mob/living/attacker, mob/living/defender)
	return

/datum/martial_art/boxing/disarm_act(mob/living/attacker, mob/living/defender)
	if(honor_check(defender))
		add_to_streak("D", defender)
	tussle(attacker, defender)
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/boxing/grab_act(mob/living/attacker, mob/living/defender)
	if(honorable_boxer && !ignore_grab_restriction)
		attacker.balloon_alert(attacker, LANG("datum.4888073e", null))
		return MARTIAL_ATTACK_FAIL
	return MARTIAL_ATTACK_INVALID //UNLESS YOU'RE EVIL

/datum/martial_art/boxing/harm_act(mob/living/attacker, mob/living/defender)
	if(honor_check(defender))
		add_to_streak("H", defender)
	tussle(attacker, defender)
	return MARTIAL_ATTACK_SUCCESS

// Our only boxing move, which occurs on literally all attacks; the tussle. However, quite a lot morphs the results of this proc. Combos, unlike most martial arts attacks, are checked in this proc rather than our standard unarmed procs
/datum/martial_art/boxing/proc/tussle(mob/living/attacker, mob/living/defender)

	if(honorable_boxer) //Being a good sport, you never hit someone on the ground or already knocked down. It shows you're the better person.
		if((defender.body_position == LYING_DOWN && defender.get_stamina_loss() >= 100) || IS_UNCONSCIOUS(defender)) //If they're in stamcrit or unconscious, don't bloody punch them
			attacker.balloon_alert(attacker, LANG("datum.772a3842", null))
			return FALSE

	var/obj/item/bodypart/arm/active_arm = attacker.get_active_hand()

	//The values between which damage is rolled for punches
	var/lower_force = active_arm.unarmed_damage_low
	var/upper_force = active_arm.unarmed_damage_high

	//Determines knockout potential and armor penetration (if that matters)
	var/base_unarmed_effectiveness = active_arm.unarmed_effectiveness

	//Determines attack sound based on attacker arm
	var/attack_sound = active_arm.unarmed_attack_sound

	// Out athletics skill is added as a damage bonus
	var/athletics_skill =  attacker.mind?.get_skill_level(/datum/skill/athletics)

	// If true, grants experience for punching; we only gain experience if we punch another boxer.
	var/grant_experience = FALSE

	// What type of damage does our kind of boxing do? Defaults to STAMINA for normal boxing, unless you're performing EVIL BOXING. Subtypes use different damage types.
	var/damage_type = honorable_boxer ? default_damage_type : attacker.get_attack_type()

	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)

	// Our potential wound bonus on a punch. Only applies if we're dishonorable. Otherwise, we can't wound.
	var/possible_wound_bonus = honorable_boxer ? 0 : CANT_WOUND

	// Determines damage dealt on a punch. Against a boxing defender, we apply our skill bonus.
	var/damage = rand(lower_force, upper_force)

	// Attack verbs for our visible chat messages.
	var/current_atk_verb = "punches"
	var/current_atk_verbed = "punched"

	if(defender.check_block(attacker, damage, "[attacker]'s punch", UNARMED_ATTACK))
		return FALSE

	// Similar to a normal punch, should we have a value of 0 for our lower force, we simply miss outright.
	if(!lower_force)
		playsound(defender.loc, active_arm.unarmed_miss_sound, 25, TRUE, -1)
		defender.visible_message(span_warning(LANG("datum.02d8b90b", list(attacker, defender))), \
			span_danger(LANG("datum.1c13df50", list(attacker))), span_hear(LANG("datum.b8189c1e", null)), COMBAT_MESSAGE_RANGE, attacker)
		to_chat(attacker, span_warning(LANG("datum.67d5615c", list(defender))))
		log_combat(attacker, defender, "attempted to hit", "punch (boxing) ")
		return FALSE

	var/obj/item/bodypart/affecting = defender.get_bodypart(defender.get_random_valid_zone(attacker.zone_selected))

	if(honor_check(defender))
		var/strength_bonus = HAS_TRAIT(attacker, TRAIT_STRENGTH) ? 2 : 0 //Investing into genetic strength improvements makes you a better boxer

		var/obj/item/organ/cyberimp/chest/spine/potential_spine = attacker.get_organ_slot(ORGAN_SLOT_SPINE) //Getting a cyberspine also pushes you further than just mere meat
		if(istype(potential_spine))
			strength_bonus *= potential_spine.strength_bonus

		var/streak_augmentation = check_streak(attacker, defender, active_arm)

		var/combo_multiplier = 0

		switch(streak_augmentation)
			if(STRAIGHT_PUNCH)
				current_atk_verb = "straight punches"
				current_atk_verbed = "straight punched"
				combo_multiplier = 1

			if(LIGHT_JAB)
				current_atk_verb = "light jabs"
				current_atk_verbed = "light jabbed"
				combo_multiplier = 1

			if(LEFT_HOOK)
				current_atk_verb = "left hooks"
				current_atk_verbed = "left hooked"
				combo_multiplier = 1.5
				attacker.changeNext_move(CLICK_CD_MELEE * 1.5)

			if(RIGHT_HOOK)
				current_atk_verb = "right hooks"
				current_atk_verbed = "right hooked"
				combo_multiplier = 1.5
				attacker.changeNext_move(CLICK_CD_MELEE * 1.5)

			if(UPPERCUT)
				current_atk_verb = "uppercuts"
				current_atk_verbed = "uppercutted"
				base_unarmed_effectiveness *= 1.5
				combo_multiplier = 1
				attacker.changeNext_move(CLICK_CD_MELEE * 1.5)

			if(DISCOMBOBULATE)
				current_atk_verb = "discombobulates"
				current_atk_verbed = "discombobulated"
				affecting = defender.get_bodypart(defender.get_random_valid_zone(BODY_ZONE_HEAD))
				defender.adjust_confusion_up_to(20 SECONDS, 50 SECONDS)
				defender.adjust_dizzy_up_to(20 SECONDS, 50 SECONDS)
				combo_multiplier = 1

			if(BLIND_JAB)
				current_atk_verb = "blind jabs"
				current_atk_verbed = "blind jabbed"
				combo_multiplier = 0.5
				attacker.changeNext_move(CLICK_CD_MELEE * 1.5)

			if(CRAVEN_BLOW)
				current_atk_verb = "sucker punches"
				current_atk_verbed = "sucker punch"
				possible_wound_bonus = damage
				combo_multiplier = 2
				possible_wound_bonus *= 1.5
				affecting = defender.get_bodypart(defender.get_random_valid_zone(BODY_ZONE_HEAD))
				defender.adjust_staggered_up_to(STAGGERED_SLOWDOWN_LENGTH, 10 SECONDS) //why yes, this could result in them being knocked out in one.

		damage += round((athletics_skill + strength_bonus) * combo_multiplier, 1)

		if(combo_multiplier >= 1)
			perform_extra_effect(attacker, defender)

		if(defender.stat <= HARD_CRIT) // Do not grant experience against dead targets
			grant_experience = TRUE

	var/armor_block = defender.run_armor_check(affecting, MELEE, armour_penetration = base_unarmed_effectiveness)

	playsound(defender, attack_sound, 25, TRUE, -1)

	defender.visible_message(
		span_danger("[attacker] [current_atk_verb] [defender]!"),
		span_userdanger(LANG("datum.c61afe56", list(current_atk_verbed, attacker))),
		span_hear(LANG("datum.6c7f8149", null)),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)

	to_chat(attacker, span_danger(LANG("datum.22d557f3", list(current_atk_verbed, defender))))

	// Determines the total amount of experience earned per punch
	var/experience_earned = round(damage/4, 1)

	defender.apply_damage(damage, damage_type, affecting, armor_block, wound_bonus = possible_wound_bonus)

	log_combat(attacker, defender, "punched (boxing) ")

	if(defender.stat == DEAD || !honor_check(defender)) //early returning here so we don't worry about knockout probs or experience gain
		return TRUE

	if(grant_experience)
		skill_experience_adjustment(attacker, defender, (damage/lower_force))

	//Determine our attackers athletics level as a knockout probability bonus
	var/attacker_athletics_skill =  (attacker.mind?.get_skill_modifier(/datum/skill/athletics, SKILL_RANDS_MODIFIER) + base_unarmed_effectiveness)

	// Defender boxing skill and armor block are used as a defense here. This has already factored in base_unarmed_effectiveness from the attacker
	var/defender_athletics_skill =  clamp(defender.mind?.get_skill_modifier(/datum/skill/athletics, SKILL_RANDS_MODIFIER), 0, 100)

	//Determine our final probability, using a clamp to stop any prob() weirdness.
	var/final_knockout_probability = clamp(round(attacker_athletics_skill - defender_athletics_skill, 1), 0 , 100)

	if(!prob(final_knockout_probability))
		return TRUE

	crit_effect(attacker, defender, armor_block, damage_type, damage)

	experience_earned *= 2 //Double our experience gain on a crit hit

	playsound(defender, 'sound/effects/coin2.ogg', 40, TRUE)
	new /obj/effect/temp_visual/crit(get_turf(defender))
	skill_experience_adjustment(attacker, defender, experience_earned) //double experience for a successful crit

	return TRUE

/// Our crit effect. For normal boxing, this applies a stagger, then applies a knockout if they're staggered. Other types of boxing apply different kinds of effects.
/datum/martial_art/boxing/proc/crit_effect(mob/living/attacker, mob/living/defender, armor_block = 0, damage_type = STAMINA, damage = 0)
	if(defender.get_timed_status_effect_duration(/datum/status_effect/staggered))
		defender.visible_message(
			span_danger(LANG("datum.454b0e16", list(attacker, defender))),
			span_userdanger(LANG("datum.1ace6279", list(attacker))),
			span_hear(LANG("datum.6c7f8149", null)),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger(LANG("datum.00087ddb", list(defender))))
		defender.apply_effect(20 SECONDS, EFFECT_KNOCKDOWN, armor_block)
		defender.SetSleeping(10 SECONDS)
		log_combat(attacker, defender, "knocked out (boxing) ")
	else
		defender.visible_message(
			span_danger(LANG("datum.962ddadc", list(attacker, defender))),
			span_userdanger(LANG("datum.706ff840", list(attacker))),
			span_hear(LANG("datum.6c7f8149", null)),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		defender.adjust_staggered_up_to(STAGGERED_SLOWDOWN_LENGTH, 10 SECONDS)
		to_chat(attacker, span_danger(LANG("datum.fde652f7", list(defender))))
		log_combat(attacker, defender, "staggered (boxing) ")

	if(attacker.pulling == defender && attacker.grab_state >= GRAB_AGGRESSIVE) // dubious a normal boxer will be in a state where this happens, buuuut.
		var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
		defender.throw_at(throw_target, 2, 2, attacker)

/// Returns whether whoever is checked by this proc is complying with the rules of boxing. The boxer cannot block non-boxers, and cannot apply their scariest moves against non-boxers.
/datum/martial_art/boxing/proc/honor_check(mob/living/possible_boxer)
	if(!honorable_boxer)
		return TRUE //You scoundrel!!

	if(!HAS_TRAIT(possible_boxer, TRAIT_BOXING_READY))
		return FALSE

	return TRUE

/// Handles our instances of experience gain while boxing. It also applies the exercised status effect.
/datum/martial_art/boxing/proc/skill_experience_adjustment(mob/living/boxer, mob/living/defender, experience_value)
	//Boxing in heavier gravity gives you more experience
	var/gravity_modifier = boxer.has_gravity() > STANDARD_GRAVITY ? 1 : 2

	//You gotta sleep before you get any experience!
	boxer.mind?.adjust_experience(/datum/skill/athletics, round(experience_value / gravity_modifier, 1))
	boxer.apply_status_effect(/datum/status_effect/exercised)

/// Handles our blocking signals, similar to hit_reaction() on items. Only blocks while the boxer is in throw mode.
/datum/martial_art/boxing/proc/check_block(mob/living/boxer, atom/movable/hitby, damage, attack_text, attack_type, ...)
	SIGNAL_HANDLER

	if(!can_use(boxer) || !boxer.throw_mode || INCAPACITATED_IGNORING(boxer, INCAPABLE_GRAB))
		return NONE

	if(attack_type != UNARMED_ATTACK)
		return NONE

	//Determines unarmed defense against boxers using our current active arm.
	var/obj/item/bodypart/arm/active_arm = boxer.get_active_hand()
	var/base_unarmed_effectiveness = active_arm.unarmed_effectiveness

	// Out athletics skill is added to our block potential
	var/athletics_skill_rands =  boxer.mind?.get_skill_modifier(/datum/skill/athletics, SKILL_RANDS_MODIFIER)

	var/block_chance = base_unarmed_effectiveness + athletics_skill_rands

	var/block_text = pick("block", "evade")

	var/mob/living/attacker = GET_ASSAILANT(hitby)

	if(!honor_check(attacker))
		return NONE

	var/experience_earned = round(damage/4, 1)

	if(!damage)
		experience_earned = 2

	// WE reward experience for getting punched while boxing
	skill_experience_adjustment(boxer, attacker, experience_earned) //just getting hit a bunch doesn't net you much experience however

	if(!prob(block_chance))
		return NONE

	if(istype(attacker) && boxer.Adjacent(attacker))
		attacker.apply_damage(10, default_damage_type)
		boxer.apply_damage(5, STAMINA)
		perform_extra_effect(boxer, attacker)

	boxer.visible_message(
		span_danger(LANG("datum.73829518", list(boxer, block_text, attack_text))),
		span_userdanger(LANG("datum.22d557f3", list(block_text, attack_text))),
	)
	if(block_text == "evade")
		playsound(boxer.loc, active_arm.unarmed_miss_sound, 25, TRUE, -1)

	return SUCCESSFUL_BLOCK

/datum/martial_art/boxing/can_use(mob/living/martial_artist)
	if(!ishuman(martial_artist))
		return FALSE
	return ..()

/datum/martial_art/boxing/get_style_help()
	. = list()

	. += LANG("datum.a77f13cb", null)
	. += LANG("datum.992f91de", null)

	. += LANG("datum.3b73f12c", list(span_notice("Straight Punch")))
	. += LANG("datum.58758684", list(span_notice("Jab")))
	. += LANG("datum.57a429f3", list(span_notice("Left/Right Hook")))
	. += LANG("datum.4fdb50c5", list(span_notice("Uppercut")))

	. += LANG("datum.65ebfffc", null)
	. += LANG("datum.f7479c58", null)
	return .

// Boxing Variants!

/// Evil Boxing; for sick, evil scoundrels. Has no honor, making it more lethal (therefore unable to be used by pacifists).
/// Grants Strength and Stimmed to speed up any experience gain.

/datum/martial_art/boxing/evil
	name = "Evil Boxing"
	id = MARTIALART_EVIL_BOXING
	pacifist_style = FALSE
	help_verb = "Focus on Brawling"
	honorable_boxer = FALSE
	boxing_traits = list(TRAIT_BOXING_READY, TRAIT_STRENGTH, TRAIT_STIMMED)

/datum/martial_art/boxing/evil/get_style_help()
	. = list()

	. += LANG("datum.b667ba4c", null)
	. += LANG("datum.992f91de", null)

	. += LANG("datum.3b73f12c", list(span_notice("Straight Punch")))
	. += LANG("datum.58758684", list(span_notice("Jab")))
	. += LANG("datum.57a429f3", list(span_notice("Left/Right Hook")))
	. += LANG("datum.d413901e", list(span_notice("Uppercut")))
	. += LANG("datum.f479f0b5", list(span_notice("Sucker Punch")))

	. += LANG("datum.65ebfffc", null)
	return .

/// Hunter Boxing: for the uncaring, completely deranged one-spacer ecological disaster.
/// The honor check accepts boxing ready targets, OR various biotypes as valid targets. Uses a special crit effect rather than the standard one (against monsters).
/// I guess technically, this allows for lethal boxing. If you want.
/datum/martial_art/boxing/hunter
	name = "Hunter Boxing"
	id = MARTIALART_HUNTER_BOXING
	pacifist_style = FALSE
	help_verb = "Focus on the Hunt"
	default_damage_type = BRUTE
	boxing_traits = list(TRAIT_BOXING_READY)
	ignore_grab_restriction = TRUE
	/// The mobs we are looking for to pass the honor check
	var/honorable_mob_biotypes = MOB_BEAST | MOB_SPECIAL | MOB_PLANT | MOB_BUG | MOB_MINING | MOB_CRUSTACEAN | MOB_REPTILE
	/// Our crit shout words. First word is then paired with a second word to form an attack name.
	var/list/first_word_strike = list("Extinction", "Brutalization", "Explosion", "Adventure", "Thunder", "Lightning", "Sonic", "Atomizing", "Whirlwind", "Tornado", "Shark", "Falcon")
	var/list/second_word_strike = list(" Punch", " Pawnch", "-punch", " Jab", " Hook", " Fist", " Uppercut", " Straight", " Strike", " Lunge")

/datum/martial_art/boxing/hunter/get_style_help()
	. = list()

	. += LANG("datum.df134b0e", null)
	. += LANG("datum.992f91de", null)

	. += LANG("datum.3b73f12c", list(span_notice("Straight Punch")))
	. += LANG("datum.58758684", list(span_notice("Jab")))
	. += LANG("datum.57a429f3", list(span_notice("Left/Right Hook")))
	. += LANG("datum.0e20e366", list(span_notice("Uppercut")))

	. += LANG("datum.65ebfffc", null)
	. += LANG("datum.36623ed7", null)

	. += LANG("datum.cc667305", null)
	return .

/datum/martial_art/boxing/hunter/honor_check(mob/living/possible_boxer)
	if(HAS_TRAIT(possible_boxer, TRAIT_BOXING_READY))
		return TRUE

	if(possible_boxer.mob_biotypes & MOB_HUMANOID && !istype(possible_boxer, /mob/living/simple_animal/hostile/megafauna)) //We're after animals, not people. Unless they want to box. (Or a megafauna)
		return FALSE

	if(possible_boxer.mob_biotypes & honorable_mob_biotypes) //We're after animals, not people
		return TRUE

	return FALSE //rather than default assume TRUE, we default assume FALSE. After all, there could be mobs that are none of our biotypes and also not humanoid. By default, they would be valid for being boxed if TRUE.

// Our hunter boxer applies a rebuke and double damage against the target of their crit. If the target is humanoid, we just perform our regular crit effect instead.

/datum/martial_art/boxing/hunter/crit_effect(mob/living/attacker, mob/living/defender, armor_block = 0, damage_type = STAMINA, damage = 0)
	if(defender.mob_biotypes & MOB_HUMANOID && !istype(defender, /mob/living/simple_animal/hostile/megafauna))
		return ..() //Applies the regular crit effect if it is a normal human, and not a megafauna

	var/first_word_pick = pick(first_word_strike)
	var/second_word_pick = pick(second_word_strike)

	defender.visible_message(
		span_danger(LANG("datum.844bdfdc", list(attacker, defender, first_word_pick, second_word_pick))),
		span_userdanger(LANG("datum.f1bd5e9e", list(attacker))),
		span_hear(LANG("datum.6c7f8149", null)),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.abf44ab6", list(defender, first_word_pick, second_word_pick))))
	if(ishuman(attacker))
		var/mob/living/carbon/human/human_attacker = attacker
		human_attacker.force_say()
		human_attacker.say("[first_word_pick][second_word_pick]!!!", forced = "hunter boxing enthusiastic battlecry")
	defender.apply_status_effect(/datum/status_effect/rebuked)
	defender.apply_damage(damage * 2, default_damage_type, BODY_ZONE_CHEST, armor_block) //deals double our damage AGAIN

	var/healing_factor = round(damage/3, 1)
	attacker.heal_overall_damage(healing_factor, healing_factor, healing_factor)
	log_combat(attacker, defender, "hunter crit punched (boxing)")

// Our hunter boxer does a sizable amount of extra damage on a successful combo or block

/datum/martial_art/boxing/hunter/perform_extra_effect(mob/living/attacker, mob/living/defender)
	if(defender.mob_biotypes & MOB_HUMANOID && !istype(defender, /mob/living/simple_animal/hostile/megafauna))
		return // Does not apply to humans (who aren't megafauna)

	defender.apply_damage(rand(15,20), default_damage_type, BODY_ZONE_CHEST)

/datum/martial_art/boxing/hunter/skill_experience_adjustment(mob/living/boxer, mob/living/defender, experience_value)
	if(defender.mob_biotypes & MOB_HUMANOID && !istype(defender, /mob/living/simple_animal/hostile/megafauna))
		return ..() //IF they're a normal human, we give the normal amount of experience instead

	var/gravity_modifier = boxer.has_gravity() > STANDARD_GRAVITY ? 2 : 1
	var/big_game_bonus = (defender.maxHealth / 500)

	boxer.mind?.adjust_experience(/datum/skill/athletics, round(experience_value * (gravity_modifier + big_game_bonus), 1))

#undef LEFT_RIGHT_COMBO
#undef RIGHT_LEFT_COMBO
#undef LEFT_LEFT_COMBO
#undef RIGHT_RIGHT_COMBO

#undef STRAIGHT_PUNCH
#undef RIGHT_HOOK
#undef LEFT_HOOK
#undef UPPERCUT
#undef LIGHT_JAB
#undef DISCOMBOBULATE
#undef BLIND_JAB
#undef CRAVEN_BLOW
#undef NO_COMBO
