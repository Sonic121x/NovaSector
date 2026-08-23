// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define TANK_DISPENSER_CAPACITY 10

/obj/structure/tank_dispenser
	name = "tank dispenser"
	desc = "A simple yet bulky storage device for gas tanks."
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
		balloon_alert(user, LANG("obj.e1144325ba3163c9", null))
		return
	dispense(/obj/item/tank/internals/plasma, user)
	plasmatanks--
	update_appearance()

/obj/structure/tank_dispenser/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if (!oxygentanks)
		balloon_alert(user, LANG("obj.f6a888f3a829cee7", null))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	dispense(/obj/item/tank/internals/oxygen, user)
	oxygentanks--
	update_appearance()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/tank_dispenser/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/tank_dispenser/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/tank/internals/plasma))
		if(plasmatanks == TANK_DISPENSER_CAPACITY)
			balloon_alert(user, LANG("obj.60dc2f712731644b", null))
			return ITEM_INTERACT_BLOCKING
		plasmatanks++
	else if(istype(tool, /obj/item/tank/internals/oxygen))
		if(oxygentanks == TANK_DISPENSER_CAPACITY)
			balloon_alert(user, LANG("obj.60dc2f712731644b", null))
			return ITEM_INTERACT_BLOCKING
		oxygentanks++
	else
		if(!user.combat_mode || (tool.item_flags & NOBLUDGEON))
			balloon_alert(user, LANG("obj.372d420f22216691", null))
			return ITEM_INTERACT_BLOCKING
		return NONE

	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, LANG("obj.67ce4c1b27931a76", null))
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/structure/tank_dispenser/atom_deconstruct(disassembled = TRUE)
	for(var/X in src)
		var/obj/item/I = X
		I.forceMove(loc)
	new /obj/item/stack/sheet/iron (loc, 2)

/obj/structure/tank_dispenser/examine(mob/user)
	. = ..()
	if(plasmatanks && oxygentanks)
		. += span_notice(LANG("obj.5df0ecb4a89057f9", list(plasmatanks, oxygentanks)))
	else if(plasmatanks || oxygentanks)
		. += span_notice(LANG("obj.bae54123492b8e78", list(plasmatanks ? "[plasmatanks]</b> plasma" : "[oxygentanks]</b> oxygen")))

/obj/structure/tank_dispenser/proc/dispense(tank_type, mob/receiver)
	var/existing_tank = locate(tank_type) in src
	if (isnull(existing_tank))
		existing_tank = new tank_type
	receiver.put_in_hands(existing_tank)
	balloon_alert(receiver, LANG("obj.54917a962c226fce", null))

#undef TANK_DISPENSER_CAPACITY
