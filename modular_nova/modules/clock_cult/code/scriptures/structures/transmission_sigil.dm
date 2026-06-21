/datum/scripture/create_structure/sigil_transmission
	name = "传输印记"
	desc = "召唤一个传输印记，为发条结构供能所必需。同时也会从带电物体中汲取能量。"
	tip = "Power structures using this."
	button_icon_state = "Sigil of Transmission"
	power_cost = 100
	invocation_time = 5 SECONDS
	invocation_text = list("Oh great holy one...", "your energy...", "the power of the holy light!")
	summoned_structure = /obj/structure/destructible/clockwork/sigil/transmission
	category = SPELLTYPE_STRUCTURES
