/datum/lazy_template/virtual_domain/meta_central
	name = "元中心"
	cost = BITRUNNER_COST_LOW
	desc = "工人们时不时会向纳米特拉森要求权利。这是无利可图的。"
	difficulty = BITRUNNER_DIFFICULTY_LOW
	forced_outfit = /datum/outfit/job/security/mod
	help_text = "Respond to the worker's demands with sanctioned violence. Recover valuable materials that may be scattered around. Just remember your training: Always assume guilt, they can confess in medbay... Or something like that."
	is_modular = TRUE
	key = "meta_central"
	map_name = "meta_central"
	mob_modules = list(/datum/modular_mob_segment/revolutionary)
	reward_points = BITRUNNER_REWARD_LOW
	announce_to_ghosts = TRUE
