/obj/item/fireproof_spray
	name = "防火喷雾"
	desc = "一种神奇的（无铅！）喷雾混合物，可以使任何衣物防火。警告标签注明它不适用于长时间的极端温度。"
	icon = 'modular_nova/modules/fireproof_spray/icons/fireproof_spray.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	icon_state = "fireproof_spray"
	resistance_flags = FIRE_PROOF
	/// the number of uses left in the spray
	var/uses = 2

/obj/item/fireproof_spray/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(uses <= 0)
		to_chat(user, span_warning("喷罐空了！"))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/clothing/clothing = interacting_with // checks if what we're spraying is actually something that can be worn, no fireproof welding tanks
	if(!istype(clothing))
		to_chat(user, span_warning("喷雾只对衣物有效！"))
		return ITEM_INTERACT_BLOCKING
	if(clothing.resistance_flags & FIRE_PROOF) // checks if the item already has the flag so you can't waste the spray
		to_chat(user, span_warning("[clothing] 已经防火了，你不想浪费喷雾！"))
		return ITEM_INTERACT_BLOCKING
	if(clothing.get_armor_rating(BULLET) > 1 || clothing.get_armor_rating(ENERGY) > 1) //checks for armour so you can't fireproof armour and sidestep blue xenobio potions
		to_chat(user, span_warning("[clothing] 衬有装甲板，喷雾对此无效，装甲会阻止溶液正确附着！你明智地没有浪费喷雾。"))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("你在 [clothing] 上喷了个遍，确保它不会烧得太厉害。"))
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 5)
	clothing.AddComponent(/datum/component/spray_fireproofed, immunity_time = HAS_TRAIT_FROM(clothing, TRAIT_ITEM_OBJECTIVE_BLOCKED, "Loadout") ? -1 : 60 SECONDS) // loadout items get permanent immunity
	uses --
	return ITEM_INTERACT_SUCCESS

/obj/item/fireproof_spray/examine(mob/user) //shows uses back to the user when examined
	. = ..()
	if(uses > 0)
		. += span_notice("It has [(uses)] use\s left.")
	else
		. += span_warning("它是空的。")
