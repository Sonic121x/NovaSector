// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define CART_HAS_MINIMUM_REAGENT_VOLUME !(reagents.total_volume < 1)

/obj/structure/mop_bucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/service/janitor.dmi'
	icon_state = "mopbucket"
	density = TRUE
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	/// The icon used for the water overlay
	var/water_icon = "mopbucket_water"

/obj/structure/mop_bucket/Initialize(mapload)
	. = ..()
	create_reagents(100, OPENCONTAINER)
	register_context()

/obj/structure/mop_bucket/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(istype(held_item, /obj/item/mop))
		context[SCREENTIP_CONTEXT_RMB] = "Wet [held_item]"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/reagent_containers))
		context[SCREENTIP_CONTEXT_LMB] = "Fill mop bucket"
		return CONTEXTUAL_SCREENTIP_SET

	return .

/obj/structure/mop_bucket/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/mop))
		if(tool.reagents.total_volume >= tool.reagents.maximum_volume)
			balloon_alert(user, LANG("obj.71c16304", null))
			return ITEM_INTERACT_BLOCKING

		if(!CART_HAS_MINIMUM_REAGENT_VOLUME)
			balloon_alert(user, LANG("obj.6ef93b07", null))
			return ITEM_INTERACT_BLOCKING

		reagents.trans_to(tool, tool.reagents.maximum_volume, transferred_by = user)
		balloon_alert(user, LANG("obj.70f002da", null))
		playsound(src, 'sound/effects/slosh.ogg', 25, vary = TRUE)
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/structure/mop_bucket/update_overlays()
	. = ..()
	if(reagents.total_volume > 0)
		. += water_icon

/obj/structure/mop_bucket/janitorialcart
	name = "janitorial cart"
	desc = "This is the alpha and omega of sanitation."
	icon_state = "cart"
	water_icon = "cart_water"
	var/obj/item/storage/bag/trash/mybag
	var/obj/item/mop/mymop
	var/obj/item/pushbroom/mybroom
	var/obj/item/reagent_containers/spray/cleaner/myspray
	var/obj/item/lightreplacer/myreplacer
	var/list/obj/item/clothing/suit/caution/held_signs = list()
	var/max_signs = 4

/obj/structure/mop_bucket/janitorialcart/Initialize(mapload)
	. = ..()
	reagents.maximum_volume *= 2.5
	GLOB.janitor_devices += src

/obj/structure/mop_bucket/janitorialcart/Destroy()
	GLOB.janitor_devices -= src
	QDEL_NULL(myreplacer)
	QDEL_NULL(myspray)
	QDEL_NULL(mybroom)
	QDEL_NULL(mymop)
	QDEL_NULL(mybag)
	QDEL_LIST(held_signs)
	return ..()

/obj/structure/mop_bucket/janitorialcart/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(istype(arrived, /obj/item/storage/bag/trash))
		mybag = arrived
	else if(istype(arrived, /obj/item/mop))
		mymop = arrived
	else if(istype(arrived, /obj/item/pushbroom))
		mybroom = arrived
	else if(istype(arrived, /obj/item/reagent_containers/spray/cleaner))
		myspray = arrived
	else if(istype(arrived, /obj/item/lightreplacer))
		myreplacer = arrived
	else if(istype(arrived, /obj/item/clothing/suit/caution))
		held_signs += arrived
	update_appearance(UPDATE_OVERLAYS)
	return ..()

/obj/structure/mop_bucket/janitorialcart/Exited(atom/movable/gone, direction)
	if(gone == mybag)
		mybag = null
	else if(gone == mymop)
		mymop = null
	else if(gone == mybroom)
		mybroom = null
	else if(gone == myspray)
		myspray = null
	else if(gone == myreplacer)
		myreplacer = null
	else if(gone in held_signs)
		held_signs -= gone
	if(!QDELING(src))
		update_appearance(UPDATE_OVERLAYS)
	return ..()

/obj/structure/mop_bucket/janitorialcart/examine(mob/user)
	. = ..()
	if(contents.len)
		. += span_bold(span_info(LANG("obj.5b771b04", null)))
		for(var/thing in sort_names(contents))
			if(thing in held_signs)
				continue //we'll do this after.
			. += LANG("obj.6dcfac0e", list(icon2html(thing, user), thing))
		if(held_signs.len)
			var/obj/item/clothing/suit/caution/sign_obj = held_signs[1]
			if(held_signs.len > 1)
				. += LANG("obj.a6311896", list(icon2html(sign_obj, user), convert_integer_to_words(length(held_signs)), sign_obj.name))
			else
				. += LANG("obj.6dcfac0e", list(icon2html(sign_obj, user), sign_obj))
		. += span_notice(LANG("obj.0c5f484d", list(contents.len > 1 ? "search [src]" : "remove [contents[1]]")))
		if(mybag)
			. += span_notice(LANG("obj.cae1c298", list(weight_class_to_text(mybag.atom_storage.max_specific_storage), mybag)))
		if(mymop)
			. += span_notice(LANG("obj.f316d653", list(mymop)))
	if(CART_HAS_MINIMUM_REAGENT_VOLUME)
		. += span_notice(LANG("obj.ebc4965e", null))
		. += span_info(LANG("obj.ef1146fe", list(get_turf(src))))

/obj/structure/mop_bucket/janitorialcart/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(isnull(held_item) && contents.len)
		if(mymop)
			context[SCREENTIP_CONTEXT_RMB] = "Remove [mymop]"
			. = CONTEXTUAL_SCREENTIP_SET
		if(contents.len == 1)
			context[SCREENTIP_CONTEXT_LMB] = "Remove [contents[1]]"
			. = CONTEXTUAL_SCREENTIP_SET
		context[SCREENTIP_CONTEXT_LMB] = "Search cart"
		. = CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/mop) && !mymop)
		context[SCREENTIP_CONTEXT_LMB] = "Insert [held_item]"
		. = CONTEXTUAL_SCREENTIP_SET
	if(istype(held_item, /obj/item/pushbroom) && !mybroom)
		context[SCREENTIP_CONTEXT_LMB] = "Insert [held_item]"
		. = CONTEXTUAL_SCREENTIP_SET
	if(istype(held_item, /obj/item/storage/bag/trash) && !mybag)
		context[SCREENTIP_CONTEXT_LMB] = "Insert [held_item]"
		. = CONTEXTUAL_SCREENTIP_SET
	if(istype(held_item, /obj/item/reagent_containers/spray/cleaner) && !myspray)
		context[SCREENTIP_CONTEXT_LMB] = "Insert [held_item]"
		. = CONTEXTUAL_SCREENTIP_SET
	if(istype(held_item, /obj/item/clothing/suit/caution) && held_signs.len < max_signs)
		context[SCREENTIP_CONTEXT_LMB] = "Insert [held_item]"
		. = CONTEXTUAL_SCREENTIP_SET
	if(istype(held_item, /obj/item/lightreplacer) && !myreplacer)
		context[SCREENTIP_CONTEXT_LMB] = "Insert [held_item]"
		. = CONTEXTUAL_SCREENTIP_SET
	if(istype(held_item) && held_item.tool_behaviour == TOOL_CROWBAR && CART_HAS_MINIMUM_REAGENT_VOLUME)
		context[SCREENTIP_CONTEXT_LMB] = "Dump [src]'s mop bucket on [get_turf(src)]"
		. = CONTEXTUAL_SCREENTIP_SET
	if(!isnull(held_item) && mybag?.atom_storage?.max_specific_storage >= held_item.w_class)
		context[SCREENTIP_CONTEXT_RMB] = "Insert [held_item] into [mybag]"
		. = CONTEXTUAL_SCREENTIP_SET

	return . || NONE

/obj/structure/mop_bucket/janitorialcart/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/mop))
		if(mymop)
			balloon_alert(user, LANG("obj.8af97977", list(mymop)))
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, LANG("obj.56f6de96", list(tool)))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/pushbroom))
		if(mybroom)
			balloon_alert(user, LANG("obj.8af97977", list(mybroom)))
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, LANG("obj.56f6de96", list(tool)))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/storage/bag/trash))
		if(mybag)
			balloon_alert(user, LANG("obj.8af97977", list(mybag)))
			return ITEM_INTERACT_BLOCKING

		var/obj/item/storage/bag/trash/insert = tool
		if(!insert.insertable)
			balloon_alert(user, LANG("obj.aaf11e7f", null))
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, LANG("obj.07b7e630", list(tool)))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/reagent_containers/spray/cleaner))
		if(myspray)
			balloon_alert(user, LANG("obj.8af97977", list(myspray)))
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, LANG("obj.56f6de96", list(tool)))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/lightreplacer))
		if(myreplacer)
			balloon_alert(user, LANG("obj.8af97977", list(myreplacer)))
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, LANG("obj.56f6de96", list(tool)))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/clothing/suit/caution))
		if(held_signs.len >= max_signs)
			balloon_alert(user, LANG("obj.ed6f6e28", null))
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, LANG("obj.56f6de96", list(tool)))
		return ITEM_INTERACT_SUCCESS

	return ..()

/obj/structure/mop_bucket/janitorialcart/crowbar_act(mob/living/user, obj/item/tool)
	if(!CART_HAS_MINIMUM_REAGENT_VOLUME)
		balloon_alert(user, LANG("obj.e7ae6c26", null))
		return ITEM_INTERACT_SUCCESS
	user.balloon_alert_to_viewers(LANG("obj.e797d485", list(src)), LANG("obj.07dad763", list(src)))
	user.visible_message(span_notice(LANG("obj.be83cc5e", list(user, src))), span_notice(LANG("obj.f7d8c6f7", list(src))))
	if(tool.use_tool(src, user, 5 SECONDS, volume = 50))
		balloon_alert(user, LANG("obj.19759518", list(src)))
		to_chat(user, span_notice(LANG("obj.f92781e2", list(src))))
		reagents.expose(loc)
		reagents.clear_reagents()
		update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/structure/mop_bucket/janitorialcart/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(ITEM_INTERACT_ANY_BLOCKER & .)
		return .

	if(!mybag?.atom_storage.attempt_insert(tool, user))
		return .

	return ITEM_INTERACT_SUCCESS

/obj/structure/mop_bucket/janitorialcart/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	var/list/items = list()
	if(mybag)
		items += list("Trash bag" = image(icon = mybag.icon, icon_state = mybag.icon_state))
	if(mymop)
		items += list("Mop" = image(icon = mymop.icon, icon_state = mymop.icon_state))
	if(mybroom)
		items += list("Broom" = image(icon = mybroom.icon, icon_state = mybroom.icon_state))
	if(myspray)
		items += list("Spray bottle" = image(icon = myspray.icon, icon_state = myspray.icon_state))
	if(myreplacer)
		items += list("Light replacer" = image(icon = myreplacer.icon, icon_state = myreplacer.icon_state))
	if(held_signs.len)
		var/obj/item/clothing/suit/caution/sign = held_signs[1]
		items += list("Sign" = image(icon = sign.icon, icon_state = sign.icon_state))

	if(!length(items))
		return

	var/pick = items[1]
	if(length(items) > 1)
		items = sort_list(items)
		pick = show_radial_menu(user, src, items, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 38, require_near = TRUE)

	if(!pick)
		return
	switch(pick)
		if("Trash bag")
			if(!mybag)
				return
			balloon_alert(user, LANG("obj.cf015430", list(mybag)))
			user.put_in_hands(mybag)
		if("Mop")
			if(!mymop)
				return
			balloon_alert(user, LANG("obj.c6b4aa68", list(mymop)))
			user.put_in_hands(mymop)
		if("Broom")
			if(!mybroom)
				return
			balloon_alert(user, LANG("obj.c6b4aa68", list(mybroom)))
			user.put_in_hands(mybroom)
		if("Spray bottle")
			if(!myspray)
				return
			balloon_alert(user, LANG("obj.c6b4aa68", list(myspray)))
			user.put_in_hands(myspray)
		if("Light replacer")
			if(!myreplacer)
				return
			balloon_alert(user, LANG("obj.c6b4aa68", list(myreplacer)))
			user.put_in_hands(myreplacer)
		if("Sign")
			if(!held_signs.len)
				return
			var/obj/item/clothing/suit/caution/removed_sign = held_signs[1]
			if(length(held_signs) > 1)
				balloon_alert(user, LANG("obj.6980add6", list(removed_sign)))
			else
				balloon_alert(user, LANG("obj.c6b4aa68", list(removed_sign)))
			user.put_in_hands(removed_sign)
		else
			return

/obj/structure/mop_bucket/janitorialcart/attack_hand_secondary(mob/user, list/modifiers)
	if(!mymop)
		return SECONDARY_ATTACK_CONTINUE_CHAIN
	balloon_alert(user, LANG("obj.c6b4aa68", list(mymop)))
	user.put_in_hands(mymop)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 */
/obj/structure/mop_bucket/janitorialcart/proc/check_menu(mob/living/user)
	return istype(user) && !user.incapacitated

/obj/structure/mop_bucket/janitorialcart/update_overlays()
	. = ..()
	if(mybag)
		. += istype(mybag, /obj/item/storage/bag/trash/bluespace) ? "cart_bluespace_garbage" : "cart_garbage"
	if(mymop)
		. += "cart_mop"
	if(mybroom)
		. += "cart_broom"
	if(myspray)
		. += "cart_spray"
	if(myreplacer)
		. += "cart_replacer"
	if(held_signs.len)
		. += "cart_sign[min(held_signs.len, 4)]"

#undef CART_HAS_MINIMUM_REAGENT_VOLUME
