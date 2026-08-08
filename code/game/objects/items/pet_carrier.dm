// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define pet_carrier_full(carrier) carrier.occupants.len >= carrier.max_occupants || carrier.occupant_weight >= carrier.max_occupant_weight

//Used to transport little animals without having to drag them across the station.
//Comes with a handy lock to prevent them from running off.
/obj/item/pet_carrier
	name = "pet carrier"
	desc = "A big white-and-blue pet carrier. Good for carrying <s>meat to the chef</s> cute animals around."
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/pet_carrier"
	post_init_icon_state = "pet_carrier_open"
	base_icon_state = "pet_carrier"
	inhand_icon_state = "pet_carrier"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	greyscale_config = /datum/greyscale_config/pet_carrier
	greyscale_config_inhand_left = /datum/greyscale_config/pet_carrier_inhands_left
	greyscale_config_inhand_right = /datum/greyscale_config/pet_carrier_inhands_right
	greyscale_colors = COLOR_BLUE
	force = 5
	attack_verb_continuous = list("bashes", "carries")
	attack_verb_simple = list("bash", "carry")
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 3
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 7.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	interaction_flags_mouse_drop = NEED_DEXTERITY
	/// Is the pet carrier open? Allows you to collect/remove pets.
	var/open = TRUE
	/// Does this carrier allow locking? Disabled for the small pet carrier.
	var/allows_locking = TRUE
	/// Is this carrier locked? Locks don't require access, just an alt click.
	var/locked = FALSE
	/// List of all mob occupants from inside of the pet carrier.
	var/list/occupants = list()
	/// Combined weight of all mob occupants based on the MOB_SIZE_ defines.
	var/occupant_weight = 0
	/// Maximum number of mobs that can fit in a pet carrier, so you can't have infinite mice or something in one carrier
	var/max_occupants = 3
	/// Maximum weight of a mob that can be carried. This is calculated from the mob sizes of occupants
	var/max_occupant_weight = MOB_SIZE_SMALL

	/// Sound played when the mob carrier is opened.
	var/open_sound = 'sound/items/handling/cardboard_box/cardboard_box_rustle.ogg'
	/// Sound played when the mob carrier is closed.
	var/close_sound = 'sound/items/handling/cardboard_box/cardboardbox_drop.ogg'

/obj/item/pet_carrier/Initialize(mapload)
	. = ..()
	register_context()
	AddElement(/datum/element/cuffable_item)

/obj/item/pet_carrier/Destroy()
	if(occupants.len)
		for(var/V in occupants)
			remove_occupant(V)
	return ..()

/obj/item/pet_carrier/Exited(atom/movable/gone, direction)
	. = ..()
	if(isliving(gone) && (gone in occupants))
		var/mob/living/living_gone = gone
		occupants -= gone
		occupant_weight -= living_gone.mob_size

/obj/item/pet_carrier/examine(mob/user)
	. = ..()
	if(occupants.len)
		for(var/V in occupants)
			var/mob/living/L = V
			. += span_notice(LANG("obj.d4be8cd2", list(L)))
	else
		. += span_notice(LANG("obj.77fc42cd", null))

	// At some point these need to be converted to contextual screentips
	. += span_notice(LANG("obj.e0f549c4", list(open ? "close" : "open")))
	if(!open && allows_locking)
		. += span_notice(LANG("obj.fdd643c6", list(locked ? "unlock" : "lock")))

/obj/item/pet_carrier/attack_self(mob/living/user)
	if(open)
		to_chat(user, span_notice(LANG("obj.d63afb95", list(src))))
		playsound(user, close_sound, 50, TRUE)
		open = FALSE
	else
		if(locked)
			to_chat(user, span_warning(LANG("obj.9d5df8ce", list(src))))
			return
		to_chat(user, span_notice(LANG("obj.0cb0e5bf", list(src))))
		playsound(user, open_sound, 50, TRUE)
		open = TRUE
	update_appearance()

/obj/item/pet_carrier/click_alt(mob/living/user)
	if(open || !allows_locking)
		return CLICK_ACTION_BLOCKING
	locked = !locked
	to_chat(user, span_notice(LANG("obj.f34132e6", list(locked ? "down" : "up"))))
	if(locked)
		playsound(user, 'sound/machines/airlock/boltsdown.ogg', 30, TRUE)
	else
		playsound(user, 'sound/machines/airlock/boltsup.ogg', 30, TRUE)
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/pet_carrier/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.combat_mode || !isliving(interacting_with))
		return NONE
	if(!open)
		to_chat(user, span_warning(LANG("obj.1f3745b2", list(src))))
		return ITEM_INTERACT_BLOCKING
	var/mob/living/target = interacting_with
	if(target.mob_size > max_occupant_weight)
		if(ishuman(target))
			if(isfeline(target) || HAS_TRAIT(target, TRAIT_CATLIKE_INSTINCT))
				to_chat(user, span_warning(LANG("obj.6dd75ce0", null)))
			else
				to_chat(user, span_warning(LANG("obj.6b4e5a5e", null)))
		else
			to_chat(user, span_warning(LANG("obj.7e7df868", list(target, name))))
		return ITEM_INTERACT_BLOCKING
	if(user == target)
		to_chat(user, span_warning(LANG("obj.ab1d9db7", null)))
		return ITEM_INTERACT_BLOCKING
	load_occupant(user, target)
	return ITEM_INTERACT_SUCCESS

/obj/item/pet_carrier/relaymove(mob/living/user, direction)
	if(open)
		loc.visible_message(span_notice(LANG("obj.dc5ea840", list(user, src))), \
		span_warning(LANG("obj.76224ddb", list(user, src))))
		remove_occupant(user)
		return
	else if(!locked)
		loc.visible_message(span_notice(LANG("obj.50131e72", list(user, src))), \
		span_warning(LANG("obj.bd4c23e0", list(user, src))))
		open = TRUE
		update_appearance()
		return
	else if(user.client)
		container_resist_act(user)

/obj/item/pet_carrier/container_resist_act(mob/living/user)
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	if(user.mob_size <= MOB_SIZE_SMALL)
		to_chat(user, span_notice(LANG("obj.58a79025", list(src))))
		to_chat(loc, span_warning(LANG("obj.8c3cd2c5", list(user))))
		if(!do_after(user, rand(300, 400), target = user) || open || !locked || !(user in occupants))
			return
		loc.visible_message(span_warning(LANG("obj.90127c57", list(user, src))), null, null, null, user)
		to_chat(user, span_bolddanger(LANG("obj.dbbc7e43", null)))
		locked = FALSE
		playsound(src, 'sound/machines/airlock/boltsup.ogg', 30, TRUE)
		update_appearance()
	else
		loc.visible_message(span_warning(LANG("obj.2e27f495", list(src))), null, null, null, user)
		to_chat(user, span_notice(LANG("obj.50248e7e", list(src))))
		if(!do_after(user, 20 SECONDS, target = user) || open || !locked || !(user in occupants))
			return
		loc.visible_message(span_warning(LANG("obj.a10af49b", list(user, src))), null, null, null, user)
		to_chat(user, span_notice(LANG("obj.f3b47c38", list(src))))
		locked = FALSE
		open = TRUE
		update_appearance()
		remove_occupant(user)

/obj/item/pet_carrier/update_icon_state()
	if(open)
		icon_state = "[base_icon_state]_open"
		return ..()
	icon_state = "[base_icon_state]_[!occupants.len ? "closed" : "occupied"]_[locked ? "locked" : "unlocked"]"
	return ..()

/obj/item/pet_carrier/mouse_drop_dragged(atom/over_atom, mob/user, src_location, over_location, params)
	if(isopenturf(over_atom) && open && occupants.len)
		user.visible_message(span_notice(LANG("obj.13965714", list(user, src))), \
		span_notice(LANG("obj.0293051b", list(src, over_atom))))
		for(var/V in occupants)
			remove_occupant(V, over_atom)

/obj/item/pet_carrier/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(!locked)
		context[SCREENTIP_CONTEXT_LMB] = open ? "Close door" : "Open door"
		return TRUE
	if(allows_locking)
		context[SCREENTIP_CONTEXT_ALT_LMB] = locked ? "Unlock door" : "Lock door"
		return  TRUE

/obj/item/pet_carrier/proc/load_occupant(mob/living/user, mob/living/target)
	if(pet_carrier_full(src))
		to_chat(user, span_warning(LANG("obj.c110f18e", list(src))))
		return
	user.visible_message(span_notice(LANG("obj.1693085c", list(user, target, src))), \
	span_notice(LANG("obj.2b7d648d", list(target, src))), null, null, target)
	to_chat(target, span_userdanger(LANG("obj.db00533d", list(user, user.p_their(), name))))
	if(!do_after(user, 3 SECONDS, target))
		return
	if(target in occupants)
		return
	if(pet_carrier_full(src)) //Run the checks again, just in case
		to_chat(user, span_warning(LANG("obj.c110f18e", list(src))))
		return
	user.visible_message(span_notice(LANG("obj.049974f6", list(user, target, src))), \
	span_notice(LANG("obj.91f19664", list(target, src))), null, null, target)
	to_chat(target, span_userdanger(LANG("obj.fd3be8b5", list(user, user.p_their(), name))))
	add_occupant(target)

/obj/item/pet_carrier/proc/add_occupant(mob/living/occupant)
	if((occupant in occupants) || !istype(occupant))
		return
	occupant.forceMove(src)
	occupants += occupant
	occupant_weight += occupant.mob_size

/obj/item/pet_carrier/proc/remove_occupant(mob/living/occupant, turf/new_turf)
	if(!(occupant in occupants) || !istype(occupant))
		return
	occupant.forceMove(new_turf ? new_turf : drop_location())
	occupants -= occupant
	occupant_weight -= occupant.mob_size
	occupant.setDir(SOUTH)

/obj/item/pet_carrier/biopod
	name = "biopod"
	desc = "Alien device used for undescribable purpose. Or carrying pets."
	icon = 'icons/obj/pet_carrier.dmi'
	icon_state = "biopod_open"
	post_init_icon_state = null
	base_icon_state = "biopod"
	inhand_icon_state = "biopod"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = null

/obj/item/pet_carrier/small
	name = "small pet carrier"
	desc = "A small pet carrier for miniature sized animals."
	icon = 'icons/obj/pet_carrier.dmi'
	icon_state = "small_carrier_open"
	post_init_icon_state = null
	w_class = WEIGHT_CLASS_NORMAL
	base_icon_state = "small_carrier"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = null

	max_occupants = 1
	allows_locking = FALSE

/obj/item/pet_carrier/small/mouse
	name = "small mouse carrier"
	desc = "A small pet carrier for miniature sized animals. This looks prepared for a mouse."
	icon_state = "small_carrier_occupied_unlocked"
	open = FALSE

/obj/item/pet_carrier/small/mouse/Initialize(mapload)
	var/mob/living/basic/mouse/hero_mouse = new /mob/living/basic/mouse(src)
	add_occupant(hero_mouse) //mouse hero
	return ..()

#undef pet_carrier_full
