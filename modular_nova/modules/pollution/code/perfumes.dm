/obj/item/perfume
	desc = "一瓶气味宜人的香水。"
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
		. += "It has [uses_remaining] use\s left."
	else
		. += "It is empty."
	if(has_cap)
		. += span_notice("Alt-点击 [src] 来 [ cap ? "take the cap off" : "put the cap on"]。")

/obj/item/perfume/click_alt(mob/user)
	toggle_cap(user)
	return CLICK_ACTION_SUCCESS

/obj/item/perfume/attack_self(mob/user, modifiers)
	toggle_cap(user)

/// Proc to handle removing the cap of the perfume bottle.
/obj/item/perfume/proc/toggle_cap(mob/user)
	if(has_cap && user.can_perform_action(src, NEED_DEXTERITY))
		cap = !cap
		to_chat(user, span_notice("[src] 的盖子现在是 [cap ? "on" : "off"]。"))
		update_appearance()

/obj/item/perfume/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(.)
		return
	if(!ismovable(interacting_with))
		return
	if(has_cap && cap)
		to_chat(user, span_warning("先把瓶盖取下来！"))
		return TRUE
	if(uses_remaining <= 0)
		to_chat(user, span_warning("\The [src] 是空的！"))
		return TRUE
	uses_remaining--
	var/turf/my_turf = get_turf(user)
	my_turf.pollute_turf(fragrance_type, 20)
	user.visible_message(span_notice("[user] 用 \the [src] 朝 [interacting_with] 喷了喷。"), span_notice("你用 \the [src] 朝 [interacting_with] 喷了喷。"))
	user.changeNext_move(CLICK_CD_RANGE*2)
	playsound(my_turf, 'sound/effects/spray2.ogg', 50, TRUE, -6)
	interacting_with.AddComponent(/datum/component/temporary_pollution_emission, fragrance_type, 5, 10 MINUTES)

/obj/item/perfume/cologne
	name = "古龙水瓶"
	desc = "这款一定能吸引女士们。"
	fragrance_type = /datum/pollutant/fragrance/cologne

/obj/item/perfume/wood
	name = "木质香水瓶"
	fragrance_type = /datum/pollutant/fragrance/wood

/obj/item/perfume/rose
	name = "玫瑰香水瓶"
	fragrance_type = /datum/pollutant/fragrance/rose

/obj/item/perfume/jasmine
	name = "茉莉香水瓶"
	fragrance_type = /datum/pollutant/fragrance/jasmine

/obj/item/perfume/mint
	name = "薄荷香水瓶"
	fragrance_type = /datum/pollutant/fragrance/mint

/obj/item/perfume/vanilla
	name = "香草香水瓶"
	fragrance_type = /datum/pollutant/fragrance/vanilla

/obj/item/perfume/pear
	name = "梨子香水瓶"
	fragrance_type = /datum/pollutant/fragrance/pear

/obj/item/perfume/strawberry
	name = "草莓香水瓶"
	fragrance_type = /datum/pollutant/fragrance/strawberry

/obj/item/perfume/cherry
	name = "樱桃香水瓶"
	fragrance_type = /datum/pollutant/fragrance/cherry

/obj/item/perfume/amber
	name = "琥珀香水瓶"
	fragrance_type = /datum/pollutant/fragrance/amber
