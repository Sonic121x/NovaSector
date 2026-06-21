/// Proteon - a very weak construct that only appears in NPC form in various ruins.
/mob/living/basic/construct/proteon
	name = "普洛提恩"
	real_name = "Proteon"
	desc = "A weaker construct meant to scour ruins for objects of Nar'Sie's affection. Those barbed claws are no joke."
	icon_state = "proteon"
	icon_living = "proteon"
	maxHealth = 35
	health = 35
	melee_damage_lower = 8
	melee_damage_upper = 10
	attack_verb_continuous = "pinches"
	attack_verb_simple = "pinch"
	smashes_walls = TRUE
	attack_sound = 'sound/items/weapons/punch2.ogg'
	playstyle_string = span_bold("你是普洛提恩。你的战斗能力不及大多数战斗构造体，但你依然迅捷灵活。负责运送金属和补给，并与你的邪教徒同伴合作。")

/// Hostile NPC version
/mob/living/basic/construct/proteon/hostile
	ai_controller = /datum/ai_controller/basic_controller/proteon
	smashes_walls = FALSE
	melee_attack_cooldown = 1.5 SECONDS

/mob/living/basic/construct/proteon/hostile/Initialize(mapload)
	. = ..()
	var/datum/callback/retaliate_callback = CALLBACK(src, PROC_REF(ai_retaliate_behaviour))
	AddComponent(/datum/component/ai_retaliate_advanced, retaliate_callback)

/// Set a timer to clear our retaliate list
/mob/living/basic/construct/proteon/hostile/proc/ai_retaliate_behaviour(mob/living/attacker)
	if (!istype(attacker))
		return
	var/random_timer = rand(2 SECONDS, 4 SECONDS) //for unpredictability
	addtimer(CALLBACK(src, PROC_REF(clear_retaliate_list)), random_timer)

/mob/living/basic/construct/proteon/hostile/proc/clear_retaliate_list()
	if(!ai_controller.blackboard_key_exists(BB_BASIC_MOB_RETALIATE_LIST))
		return
	ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
