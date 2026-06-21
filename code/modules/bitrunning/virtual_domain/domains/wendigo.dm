/datum/lazy_template/virtual_domain/wendigo
	name = "冰川吞噬者"
	cost = BITRUNNER_COST_HIGH
	desc = "传说讲述着冰月洞穴深处隐藏着贪婪的温迪戈。"
	difficulty = BITRUNNER_DIFFICULTY_HIGH
	forced_outfit = /datum/outfit/job/miner
	key = "wendigo"
	map_name = "wendigo"
	reward_points = BITRUNNER_REWARD_HIGH

/obj/effect/mob_spawn/corpse/human/bitrunner/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.apply_status_effect(/datum/status_effect/gutted)

/obj/effect/mob_spawn/corpse/human/cyber_police/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.apply_status_effect(/datum/status_effect/gutted)
