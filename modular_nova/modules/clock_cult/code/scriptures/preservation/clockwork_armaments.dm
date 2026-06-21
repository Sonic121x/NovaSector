/datum/scripture/clockwork_armaments
	name = "发条武装"
	desc = "召唤发条护甲与武器，为战斗做好准备。"
	tip = "Summon clockwork armor and weapons, to be ready for battle."
	button_icon_state = "clockwork_armor"
	power_cost = 450 // Likely only need to use it once
	invocation_time = 2 SECONDS
	invocation_text = list("Through courage and hope...", "we shall protect thee!")
	category = SPELLTYPE_PRESERVATION
	cogs_required = 1


/datum/scripture/clockwork_armaments/invoke_success()
	var/choice = tgui_input_list(invoker, "你想召唤什么武器？", "发条武装", list("Brass Spear", "Brass Battlehammer", "Brass Sword", "Brass Bow"))

	if(!choice)
		return FALSE

	var/static/datum/outfit/clockwork_armaments/base_outfit
	if(!base_outfit)
		base_outfit = new

	var/weapon_path = /obj/item/clockwork/weapon/brass_battlehammer

	switch(choice)
		if("Brass Spear")
			weapon_path = /obj/item/clockwork/weapon/brass_spear

		if("Brass Battlehammer")
			weapon_path = /obj/item/clockwork/weapon/brass_battlehammer

		if("Brass Sword")
			weapon_path = /obj/item/clockwork/weapon/brass_sword

		if("Brass Bow")
			weapon_path = /obj/item/gun/ballistic/bow/clockwork

	base_outfit.equip(invoker)

	invoker.put_in_hands(new weapon_path, FALSE)
