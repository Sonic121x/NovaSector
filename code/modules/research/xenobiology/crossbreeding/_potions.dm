// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*
Slimecrossing Potions
	Potions added by the slimecrossing system.
	Collected here for clarity.
*/

//Extract cloner - Charged Grey
/obj/item/slimepotion/extract_cloner
	name = "extract cloning potion"
	desc = "A more powerful version of the extract enhancer potion, capable of cloning regular slime extracts."
	icon_state = "potgold"

/obj/item/slimepotion/extract_cloner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(istype(interacting_with, /obj/item/slimecross))
		to_chat(user, span_warning(LANG("obj.478d3464", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING
	if(!istype(interacting_with, /obj/item/slime_extract))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/slime_extract/S = interacting_with
	if(S.recurring)
		to_chat(user, span_warning(LANG("obj.478d3464", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING
	var/path = S.type
	var/obj/item/slime_extract/C = new path(get_turf(interacting_with))
	C.extract_uses = S.extract_uses
	to_chat(user, span_notice(LANG("obj.3292d3af", list(interacting_with))))
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Peace potion - Charged Light Pink
/obj/item/slimepotion/peacepotion
	name = "pacification potion"
	desc = "A light pink solution of chemicals, smelling like liquid peace. And mercury salts."
	icon_state = "potlightpink"

/obj/item/slimepotion/peacepotion/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	var/mob/living/peace_target = interacting_with
	if(!isliving(peace_target) || peace_target.stat == DEAD)
		to_chat(user, span_warning(LANG("obj.4f4e6667", list(src))))
		return ITEM_INTERACT_BLOCKING
	if(ismegafauna(peace_target))
		to_chat(user, span_warning(LANG("obj.45e49c00", list(src))))
		return ITEM_INTERACT_BLOCKING
	if(peace_target != user)
		peace_target.visible_message(span_danger(LANG("obj.20a8029d", list(user, peace_target, src))),
			span_userdanger(LANG("obj.d34eedb4", list(user, src))))
	else
		peace_target.visible_message(span_danger(LANG("obj.5d249f52", list(user, src))),
			span_danger(LANG("obj.0be85a3b", list(src))))

	if(!do_after(user, 10 SECONDS, target = peace_target))
		return ITEM_INTERACT_BLOCKING
	if(peace_target != user)
		to_chat(user, span_notice(LANG("obj.bf92cde6", list(peace_target, src))))
	else
		to_chat(user, span_warning(LANG("obj.36fa520a", list(src))))
	if(isanimal_or_basicmob(peace_target))
		ADD_TRAIT(peace_target, TRAIT_PACIFISM, MAGIC_TRAIT)
	else if(iscarbon(peace_target))
		var/mob/living/carbon/peaceful_carbon = peace_target
		peaceful_carbon.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_SURGERY)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Love potion - Charged Pink
/obj/item/slimepotion/lovepotion
	name = "love potion"
	desc = "A pink chemical mix thought to inspire feelings of love."
	icon_state = "potpink"

/obj/item/slimepotion/lovepotion/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	var/mob/living/love_target = interacting_with
	if(!isliving(love_target) || love_target.stat == DEAD)
		to_chat(user, span_warning(LANG("obj.eba29c4a", null)))
		return ITEM_INTERACT_BLOCKING
	if(ismegafauna(love_target))
		to_chat(user, span_warning(LANG("obj.e1b9e7cb", null)))
		return ITEM_INTERACT_BLOCKING
	if(user == love_target)
		to_chat(user, span_warning(LANG("obj.ab5cb1cc", null)))
		return ITEM_INTERACT_BLOCKING
	if(love_target.has_status_effect(/datum/status_effect/in_love))
		to_chat(user, span_warning(LANG("obj.1339ea17", list(love_target))))
		return ITEM_INTERACT_BLOCKING

	love_target.visible_message(span_danger(LANG("obj.61a936f4", list(user, love_target))),
		span_userdanger(LANG("obj.c8572f3a", list(user))))

	if(!do_after(user, 5 SECONDS, target = love_target))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.6aa52c23", list(love_target))))
	to_chat(love_target, span_notice(LANG("obj.9d4040aa", list(user, user.p_they(), user.p_s()))))
	love_target.add_ally(user)
	love_target.apply_status_effect(/datum/status_effect/in_love, user)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Pressure potion - Charged Dark Blue
/obj/item/slimepotion/spaceproof
	name = "slime pressurization potion"
	desc = "A potent chemical sealant that will render any article of clothing airtight. Has two uses."
	icon_state = "potblack"
	var/uses = 2

/obj/item/slimepotion/spaceproof/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(uses <= 0)
		qdel(src)
		return ITEM_INTERACT_BLOCKING
	var/obj/item/clothing/clothing = interacting_with
	if(!istype(clothing))
		to_chat(user, span_warning(LANG("obj.a29bdeb8", null)))
		return ITEM_INTERACT_BLOCKING
	if(istype(clothing, /obj/item/clothing/suit/space))
		to_chat(user, span_warning(LANG("obj.4e50bdaa", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING
	if(clothing.min_cold_protection_temperature == SPACE_SUIT_MIN_TEMP_PROTECT && (clothing.clothing_flags & STOPSPRESSUREDAMAGE))
		to_chat(user, span_warning(LANG("obj.4e50bdaa", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.7f9d572a", list(clothing))))
	clothing.name = "pressure-resistant [clothing.name]"
	clothing.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	clothing.add_atom_colour(color_transition_filter(COLOR_NAVY, SATURATION_OVERRIDE), FIXED_COLOUR_PRIORITY)
	clothing.min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing.cold_protection = clothing.body_parts_covered
	clothing.clothing_flags |= STOPSPRESSUREDAMAGE
	uses--
	if(uses <= 0)
		qdel(src)
	return ITEM_INTERACT_SUCCESS

//Enhancer potion - Charged Cerulean
/obj/item/slimepotion/enhancer/max
	name = "extract maximizer"
	desc = "An extremely potent chemical mix that will maximize a slime extract's uses."
	icon_state = "potcerulean"

//Lavaproofing potion - Charged Red
/obj/item/slimepotion/lavaproof
	name = "slime lavaproofing potion"
	desc = "A strange, reddish goo said to repel lava as if it were water, without reducing flammability. Has two uses."
	icon_state = "potyellow"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	var/uses = 2

/obj/item/slimepotion/lavaproof/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(uses <= 0)
		qdel(src)
		return ITEM_INTERACT_BLOCKING
	if(!isitem(interacting_with))
		to_chat(user, span_warning(LANG("obj.5e40a3d7", null)))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/clothing = interacting_with
	to_chat(user, span_notice(LANG("obj.e3b2b4ee", list(clothing))))
	clothing.name = "lavaproof [clothing.name]"
	clothing.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	clothing.add_atom_colour(color_transition_filter(COLOR_MAROON, SATURATION_OVERRIDE), FIXED_COLOUR_PRIORITY)
	clothing.resistance_flags |= LAVA_PROOF
	if (isclothing(clothing))
		var/obj/item/clothing/clothing_real = clothing
		clothing_real.clothing_flags |= LAVAPROTECT
		clothing_real.resistance_flags |= FIRE_PROOF
	uses--
	if(uses <= 0)
		qdel(src)
	return ITEM_INTERACT_SUCCESS

//Revival potion - Charged Grey
/obj/item/slimepotion/slime_reviver
	name = "slime revival potion"
	desc = "Infused with plasma and compressed gel, this brings dead slimes back to life."
	icon_state = "potgrey"

/obj/item/slimepotion/slime_reviver/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	var/mob/living/basic/slime/revive_target = interacting_with
	if(!isslime(revive_target))
		to_chat(user, span_warning(LANG("obj.c5a061c0", null)))
		return ITEM_INTERACT_BLOCKING
	if(revive_target.stat != DEAD)
		to_chat(user, span_warning(LANG("obj.ebe8d7b1", null)))
		return ITEM_INTERACT_BLOCKING
	if(revive_target.maxHealth <= 0)
		to_chat(user, span_warning(LANG("obj.b11bebe8", null)))
		return ITEM_INTERACT_BLOCKING
	user.do_attack_animation(interacting_with)
	revive_target.revive(HEAL_ALL)
	revive_target.visible_message(span_notice(LANG("obj.099b92cd", list(revive_target))))
	revive_target.maxHealth -= 10 //Revival isn't healthy.
	revive_target.health -= 10
	revive_target.regenerate_icons()
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//Stabilizer potion - Charged Blue
/obj/item/slimepotion/slime/chargedstabilizer
	name = "slime omnistabilizer"
	desc = "An extremely potent chemical mix that will stop a slime from mutating completely."
	icon_state = "potcyan"

/obj/item/slimepotion/slime/chargedstabilizer/interact_with_slime(mob/living/basic/slime/interacting_slime, mob/living/user, list/modifiers)
	if(IS_UNCONSCIOUS_OR_CRIT(interacting_slime))
		to_chat(user, span_warning(LANG("obj.8820e387", null)))
		return ITEM_INTERACT_BLOCKING
	if(interacting_slime.mutation_chance == 0)
		to_chat(user, span_warning(LANG("obj.8bb933d2", null)))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.79155b64", null)))
	interacting_slime.mutation_chance = 0
	qdel(src)
	return ITEM_INTERACT_SUCCESS
