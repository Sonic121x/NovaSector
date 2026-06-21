///this could cause serious trouble if this thing ever got station side, thankfully i dont think we have anybody psychotic or stupid enough to try something like that.
/mob/living/basic/mining/legion/houndoftindalos
	name = "廷达洛斯之猎犬"
	desc = "它看起来隐约像条狗——如果这条狗被送进碎木机，剩下的部分被做成细丝，然后以彩虹的颜色重新组装成狗的模糊形状。"
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "legion" ///these are just placeholder sprites until i can get a real sprite made or ported from CDDA
	icon_living = "legion"
	icon_dead = "legion"
	icon_gib = "syndicate_gib"
	basic_mob_flags = DEL_ON_DEATH
	speed = 6
	maxHealth = 5
	health = 5
	obj_damage = 50
	melee_damage_lower = 50
	melee_damage_upper = 50
	faction = list(FACTION_NETHER)
	attack_verb_continuous = "lashes out at"
	attack_verb_simple = "lash out at"
	death_message = "Contorts for a moment before folding in on itself- letting something else come out in the process."
	brood_type = /mob/living/basic/creature
	corpse_type = /mob/living/basic/migo
	ai_controller = /datum/ai_controller/basic_controller/legion/houndoftindalos

/datum/ai_controller/basic_controller/legion/houndoftindalos
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_TARGET_MINIMUM_STAT = HARD_CRIT,
		BB_AGGRO_RANGE = 5,
		BB_BASIC_MOB_FLEE_DISTANCE = 6,
	)
