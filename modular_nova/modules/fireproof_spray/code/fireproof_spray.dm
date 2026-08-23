/obj/item/fireproof_spray
	name = "fireproof spray"
	desc = "A miraculous (lead free!) spray mix that will fireproof any article of clothing. A warning label denotes it won't work for prolonged extreme temperatures."
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
		to_chat(user, span_warning(LANG("obj.18158974071363f8", null)))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/clothing/clothing = interacting_with // checks if what we're spraying is actually something that can be worn, no fireproof welding tanks
	if(!istype(clothing))
		to_chat(user, span_warning(LANG("obj.18e4757a0fcc6727", null)))
		return ITEM_INTERACT_BLOCKING
	if(clothing.resistance_flags & FIRE_PROOF) // checks if the item already has the flag so you can't waste the spray
		to_chat(user, span_warning(LANG("obj.921c4ed99a3d6b9a", list(clothing))))
		return ITEM_INTERACT_BLOCKING
	if(clothing.get_armor_rating(BULLET) > 1 || clothing.get_armor_rating(ENERGY) > 1) //checks for armour so you can't fireproof armour and sidestep blue xenobio potions
		to_chat(user, span_warning(LANG("obj.99b6632c2725b63a", list(clothing))))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.46e30746b3d37606", list(clothing))))
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 5)
	clothing.AddComponent(/datum/component/spray_fireproofed, immunity_time = HAS_TRAIT_FROM(clothing, TRAIT_ITEM_OBJECTIVE_BLOCKED, "Loadout") ? -1 : 60 SECONDS) // loadout items get permanent immunity
	uses --
	return ITEM_INTERACT_SUCCESS

/obj/item/fireproof_spray/examine(mob/user) //shows uses back to the user when examined
	. = ..()
	if(uses > 0)
		. += span_notice(LANG("obj.5bf37df5de0917f2", list((uses))))
	else
		. += span_warning(LANG("obj.53b0d090ad9fbc27", null))
