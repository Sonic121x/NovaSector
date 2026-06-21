/obj/item/kirbyplants
	///List of modular icon states, added to the end of the randomization list
	/// and used to change to our icon file
	var/list/modular_states = list(
		"modular-1",
		"modular-2",
		"modular-3",
		"modular-4",
		"modular-5",
		"modular-6",
		"modular-7",
		"modular-8",
	)

/obj/item/kirbyplants/monkey
	name = "猴子植物"
	desc = "这似乎是纳米传讯科研部门的造物，有人可能会称其为畸形产物。它的头部看起来...是活的。"
	icon_state = "monkeyplant"
	icon = 'modular_nova/modules/aesthetics/plants/icons/plants.dmi'
	trimmable = FALSE
