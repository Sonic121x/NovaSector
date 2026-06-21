/// A nasty little robotic bug that dusts people on attack. Jeepers. This should be a very, very, very rare spawn.
/mob/living/basic/supermatter_spider
	name = "超物质蜘蛛"
	desc= "一小片超物质被放置在机器人强化的基座上。"

	icon = 'icons/mob/simple/smspider.dmi'
	icon_state = "smspider"
	icon_living = "smspider"
	icon_dead = "smspider_dead"

	gender = NEUTER
	status_flags = CANPUSH
	mob_biotypes = MOB_BUG|MOB_ROBOTIC|MOB_MINERAL
	speak_emote = list("vibrates")


	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/effects/supermatter.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW

	maxHealth = 10
	health = 10
	minimum_survivable_temperature = TCMB
	maximum_survivable_temperature = T0C + 1250
	habitable_atmos = null
	death_message = "falls to the ground, its shard dulling to a miserable grey!"
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, STAMINA = 0, OXY = 1)

	faction = list(FACTION_HOSTILE)

	// Gold, supermatter tinted
	lighting_cutoff_red = 30
	lighting_cutoff_green = 30
	lighting_cutoff_blue = 10

	ai_controller = /datum/ai_controller/basic_controller/supermatter_spider

	/// If we successfully dust something, should we die?
	var/single_use = TRUE

/mob/living/basic/supermatter_spider/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/swarming)

	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_CLAW)

/// Proc that we call on attacking something to dust 'em.
/mob/living/basic/supermatter_spider/early_melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if(.)
		return

	if(isliving(target))
		var/mob/living/victim = target
		victim.investigate_log("has been dusted by [src].", INVESTIGATE_DEATHS)
		dust_feedback(target)
		victim.dust()
		if(single_use)
			death()
		return BASIC_MOB_END_ATTACK_CHAIN_COOLDOWN

	if(!isturf(target))
		dust_feedback(target)
		qdel(target)
		if(single_use)
			death()
		return BASIC_MOB_END_ATTACK_CHAIN_COOLDOWN

/// Simple proc that plays the supermatter dusting sound and sends a visible message.
/mob/living/basic/supermatter_spider/proc/dust_feedback(atom/target)
	playsound(get_turf(src), 'sound/effects/supermatter.ogg', 10, TRUE)
	visible_message(span_danger("[src] 撞上了 [target]，在一道炫目的闪光中将 [target.p_them()] 化为了尘埃！"))

/mob/living/basic/supermatter_spider/overcharged
	name = "过载超物质蜘蛛"
	desc = "一小片过载的超物质被放置在机器人强化的基座上。这一个看起来尤其危险。"
	icon_state = "smspideroc"
	icon_living = "smspideroc"
	maxHealth = 25
	health = 25
	single_use = FALSE

/datum/ai_controller/basic_controller/supermatter_spider
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/random_speech/supermatter_spider,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/ai_planning_subtree/random_speech/supermatter_spider
	speech_chance = 7
	emote_hear = list("clinks", "clanks")
	emote_see = list("vibrates")
