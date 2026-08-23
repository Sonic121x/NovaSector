/obj/item/perfume
	desc = "A bottle of pleasantly smelling fragrance."
	icon = 'modular_nova/modules/pollution/icons/perfume.dmi'
	icon_state = "perfume"
	inhand_icon_state = "cleaner"
	worn_icon_state = "spraybottle"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	/// What type of the pollutant will this perfume be using
	var/fragrance_type
	/// How many uses remaining has it got
	var/uses_remaining = 10
	/// Whether the cap of the perfume is on or off
	var/cap = TRUE
	/// Whether we have a cap or not
	var/has_cap = TRUE

/obj/item/perfume/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/perfume/update_icon_state()
	icon_state = (has_cap && cap) ? "[initial(icon_state)]_cap" : initial(icon_state)
	return ..()

/obj/item/perfume/examine(mob/user)
	. = ..()
	if(uses_remaining)
		. += LANG("obj.5bf37df5de0917f2", list(uses_remaining))
	else
		. += LANG("obj.53b0d090ad9fbc27", null)
	if(has_cap)
		. += span_notice(LANG("obj.ffde040dcd2e2881", list(src, cap ? "take the cap off" : "put the cap on")))

/obj/item/perfume/click_alt(mob/user)
	toggle_cap(user)
	return CLICK_ACTION_SUCCESS

/obj/item/perfume/attack_self(mob/user, modifiers)
	toggle_cap(user)

/// Proc to handle removing the cap of the perfume bottle.
/obj/item/perfume/proc/toggle_cap(mob/user)
	if(has_cap && user.can_perform_action(src, NEED_DEXTERITY))
		cap = !cap
		to_chat(user, span_notice(LANG("obj.d97784730c871d9f", list(src, cap ? "on" : "off"))))
		update_appearance()

/obj/item/perfume/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(.)
		return
	if(!ismovable(interacting_with))
		return
	if(has_cap && cap)
		to_chat(user, span_warning(LANG("obj.714613962be744cb", null)))
		return TRUE
	if(uses_remaining <= 0)
		to_chat(user, span_warning(LANG("obj.9104a6b2d5c7ff59", list(src))))
		return TRUE
	uses_remaining--
	var/turf/my_turf = get_turf(user)
	my_turf.pollute_turf(fragrance_type, 20)
	user.visible_message(span_notice(LANG("obj.7bd824067cd2635d", list(user, interacting_with, src))), span_notice(LANG("obj.3258487664ec9046", list(interacting_with, src))))
	user.changeNext_move(CLICK_CD_RANGE*2)
	playsound(my_turf, 'sound/effects/spray2.ogg', 50, TRUE, -6)
	interacting_with.AddComponent(/datum/component/temporary_pollution_emission, fragrance_type, 5, 10 MINUTES)

/obj/item/perfume/cologne
	name = "cologne bottle"
	desc = "This one is sure to attract ladies."
	fragrance_type = /datum/pollutant/fragrance/cologne

/obj/item/perfume/wood
	name = "wood perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/wood

/obj/item/perfume/rose
	name = "rose perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/rose

/obj/item/perfume/jasmine
	name = "jasmine perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/jasmine

/obj/item/perfume/mint
	name = "mint perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/mint

/obj/item/perfume/vanilla
	name = "vanilla perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/vanilla

/obj/item/perfume/pear
	name = "pear perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/pear

/obj/item/perfume/strawberry
	name = "strawberry perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/strawberry

/obj/item/perfume/cherry
	name = "cherry perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/cherry

/obj/item/perfume/amber
	name = "amber perfume bottle"
	fragrance_type = /datum/pollutant/fragrance/amber
