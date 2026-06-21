/datum/scripture/create_structure/tinkerers_cache
	name = "工匠储藏库"
	desc = "创造一个工匠储藏库，一个能够锻造精英装备的强大熔炉。"
	tip = "Use the cache to create more powerful equipment at the cost of power and time."
	button_icon_state = "Tinkerer's Cache"
	power_cost = 700
	invocation_time = 5 SECONDS
	invocation_text = list("Guide my hand and we shall create greatness.")
	summoned_structure = /obj/structure/destructible/clockwork/gear_base/powered/tinkerers_cache
	cogs_required = 4
	category = SPELLTYPE_STRUCTURES
