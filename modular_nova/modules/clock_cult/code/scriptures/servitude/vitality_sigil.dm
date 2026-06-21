/datum/scripture/create_structure/sigil_vitality
	name = "活力矩阵"
	desc = "召唤一个活力矩阵，可汲取非仆从的生命力。从简单实体中获得的活力要少得多。"
	tip = "Drain life from non-servants, increasing stored vitality."
	button_icon_state = "Sigil of Vitality"
	power_cost = 300
	invocation_time = 5 SECONDS
	invocation_text = list("My life in your hands.")
	summoned_structure = /obj/structure/destructible/clockwork/sigil/vitality
	cogs_required = 2
	invokers_required = 2
	category = SPELLTYPE_SERVITUDE
