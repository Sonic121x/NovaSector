//Look Sir, free crabs!
/mob/living/basic/crab
	name = "螃蟹"
	desc = "免费螃蟹！"
	icon_state = "crab"
	icon_living = "crab"
	icon_dead = "crab_dead"

	speak_emote = list("clicks")
	melee_damage_lower = 2
	melee_damage_upper = 2
	mob_biotypes = MOB_ORGANIC|MOB_CRUSTACEAN|MOB_AQUATIC
	butcher_results = list(/obj/item/food/meat/slab/rawcrab = 2)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "stomps"
	response_harm_simple = "stomp"
	friendly_verb_continuous = "pinches"
	friendly_verb_simple = "pinch"
	gold_core_spawnable = FRIENDLY_SPAWN
	mob_size = MOB_SIZE_SMALL
	///In the case 'melee_damage_upper' is somehow raised above 0
	attack_verb_continuous = "snips"
	attack_verb_simple = "snip"
	attack_sound = 'sound/items/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	ai_controller = /datum/ai_controller/basic_controller/crab

/mob/living/basic/crab/Initialize(mapload)
	. = ..()
	add_traits(list(TRAIT_NODROWN, TRAIT_SWIMMER, TRAIT_VENTCRAWLER_ALWAYS), INNATE_TRAIT)
	AddElement(/datum/element/sideway_movement)
	AddElement(/datum/element/tiny_mob_hunter, MOB_SIZE_TINY)
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/ai_flee_while_injured)
	AddComponent(/datum/component/speechmod, replacements = strings("crustacean_replacement.json", "crustacean"))

//COFFEE! SQUEEEEEEEEE!
/mob/living/basic/crab/coffee
	name = "咖啡"
	real_name = "Coffee"
	desc = "这是咖啡，另一只宠物！"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN

/mob/living/basic/crab/jon //holodeck crab
	name = "乔恩"
	real_name = "Jon"
	gold_core_spawnable = NO_SPAWN

/mob/living/basic/crab/evil
	name = "邪恶螃蟹"
	real_name = "Evil Crab"
	desc = "令人不安，不是吗？它肯定在策划什么邪恶的勾当..."
	icon_state = "evilcrab"
	icon_living = "evilcrab"
	icon_dead = "evilcrab_dead"
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/basic/crab/kreb
	name = "克雷布"
	desc = "这是一只真正的螃蟹。其他螃蟹都只是伪装起来的嘎巴克！"
	real_name = "Kreb"
	icon_state = "kreb"
	icon_living = "kreb"
	icon_dead = "kreb_dead"
	gold_core_spawnable = NO_SPAWN

/mob/living/basic/crab/evil/kreb
	name = "邪恶克雷布"
	real_name = "Evil Kreb"
	icon_state = "evilkreb"
	icon_living = "evilkreb"
	icon_dead = "evilkreb_dead"
	gold_core_spawnable = NO_SPAWN

///The basic ai controller for crabs
/datum/ai_controller/basic_controller/crab
	blackboard = list(
		BB_ALWAYS_IGNORE_FACTION = TRUE,
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/of_size/smaller,
		BB_FLEE_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_traits = DEFAULT_AI_FLAGS | STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee/from_flee_key,
		/datum/ai_planning_subtree/flee_target/from_flee_key,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/random_speech/crab,
		/datum/ai_planning_subtree/go_for_swim,
	)
