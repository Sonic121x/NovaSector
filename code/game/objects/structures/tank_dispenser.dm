#define TANK_DISPENSER_CAPACITY 10

/obj/structure/tank_dispenser
	name = "气瓶分配器"
	desc = "一个简单但笨重的储气罐存储装置。"
	icon = 'icons/obj/structures.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	max_integrity = 300
	var/oxygentanks = TANK_DISPENSER_CAPACITY
	var/plasmatanks = TANK_DISPENSER_CAPACITY

/obj/structure/tank_dispenser/oxygen
	plasmatanks = 0

/obj/structure/tank_dispenser/plasma
	oxygentanks = 0

/obj/structure/tank_dispenser/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/contextual_screentip_bare_hands, lmb_text = "Take Plasma Tank", rmb_text = "Take Oxygen Tank")
	update_appearance()

/obj/structure/tank_dispenser/update_overlays()
	. = ..()
	switch(oxygentanks)
		if(1 to 3)
			. += "oxygen-[oxygentanks]"
		if(4 to TANK_DISPENSER_CAPACITY)
			. += "oxygen-4"
	switch(plasmatanks)
		if(1 to 4)
			. += "plasma-[plasmatanks]"
		if(5 to TANK_DISPENSER_CAPACITY)
			. += "plasma-5"

/obj/structure/tank_dispenser/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if (!plasmatanks)
		balloon_alert(user, "没有等离子罐！")
		return
	dispense(/obj/item/tank/internals/plasma, user)
	plasmatanks--
	update_appearance()

/obj/structure/tank_dispenser/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if (!oxygentanks)
		balloon_alert(user, "没有氧气罐！")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	dispense(/obj/item/tank/internals/oxygen, user)
	oxygentanks--
	update_appearance()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/tank_dispenser/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/tank_dispenser/attackby(obj/item/I, mob/living/user, list/modifiers, list/attack_modifiers)
	var/full
	if(istype(I, /obj/item/tank/internals/plasma))
		if(plasmatanks < TANK_DISPENSER_CAPACITY)
			plasmatanks++
		else
			full = TRUE
	else if(istype(I, /obj/item/tank/internals/oxygen))
		if(oxygentanks < TANK_DISPENSER_CAPACITY)
			oxygentanks++
		else
			full = TRUE
	else if(!user.combat_mode || (I.item_flags & NOBLUDGEON))
		balloon_alert(user, "无法插入！")
		return
	else
		return ..()
	if(full)
		balloon_alert(user, "它已经满了！")
		return

	if(!user.transferItemToLoc(I, src))
		return
	balloon_alert(user, "气罐已插入")
	update_appearance()

/obj/structure/tank_dispenser/atom_deconstruct(disassembled = TRUE)
	for(var/X in src)
		var/obj/item/I = X
		I.forceMove(loc)
	new /obj/item/stack/sheet/iron (loc, 2)

/obj/structure/tank_dispenser/examine(mob/user)
	. = ..()
	if(plasmatanks && oxygentanks)
		. += span_notice("它还剩下<b>[plasmatanks]</b>个等离子气罐tank\s 和<b>[oxygentanks]</b>个氧气罐tank\s 。")
	else if(plasmatanks || oxygentanks)
		. += span_notice("It has <b>[plasmatanks ? "[plasmatanks]</b> plasma" : "[oxygentanks]</b> oxygen"] tank\s left.")

/obj/structure/tank_dispenser/proc/dispense(tank_type, mob/receiver)
	var/existing_tank = locate(tank_type) in src
	if (isnull(existing_tank))
		existing_tank = new tank_type
	receiver.put_in_hands(existing_tank)
	balloon_alert(receiver, "tank received")

#undef TANK_DISPENSER_CAPACITY
