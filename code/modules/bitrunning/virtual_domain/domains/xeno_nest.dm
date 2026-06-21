/datum/lazy_template/virtual_domain/xeno_nest
	name = "异形巢穴"
	cost = BITRUNNER_COST_LOW
	desc = "我们的飞船扫描仪探测到来源不明的生命形式。友好的接触尝试均已失败。"
	difficulty = BITRUNNER_DIFFICULTY_LOW
	completion_loot = list(/obj/item/toy/plush/rouny = 1)
	help_text = "You are on a barren planet filled with hostile creatures. There is a crate here, not hidden, \
	simply protected. Expect resistance."
	is_modular = TRUE
	key = "xeno_nest"
	map_name = "xeno_nest"
	mob_modules = list(/datum/modular_mob_segment/xenos)
	reward_points = BITRUNNER_REWARD_LOW
