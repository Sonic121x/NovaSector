// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/delivery
	icon = 'icons/obj/storage/wrapping.dmi'
	inhand_icon_state = "deliverypackage"
	obj_flags = UNIQUE_RENAME | RENAME_NO_DESC
	var/giftwrapped = 0
	var/sort_tag = 0
	var/obj/item/paper/note
	var/obj/item/barcode/sticker

/obj/item/delivery/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))

/**
 * Initial check if manually unwrapping
 */
/obj/item/delivery/proc/attempt_pre_unwrap_contents(mob/user, time = 1.5 SECONDS)
	to_chat(user, span_notice(LANG("obj.7a94bf136aa5b2cc", null)))
	return do_after(user, time, target = user)

/**
 * Signals for unwrapping.
 */
/obj/item/delivery/proc/unwrap_contents()
	if(!sticker)
		return
	for(var/atom/movable/movable_content as anything in contents)
		SEND_SIGNAL(movable_content, COMSIG_ITEM_UNWRAPPED)

/**
 * Effects after completing unwrapping
 */
/obj/item/delivery/proc/post_unwrap_contents(mob/user, rip_open = TRUE)
	var/turf/turf_loc = get_turf(user || src)
	if(rip_open)
		playsound(loc, 'sound/items/poster/poster_ripped.ogg', 50, TRUE)
		new /obj/effect/decal/cleanable/wrapping(turf_loc)
	else
		playsound(loc, 'sound/items/box_cut.ogg', 50, TRUE)
		new /obj/item/stack/package_wrap/one(turf_loc)
	for(var/atom/movable/movable_content as anything in contents)
		movable_content.forceMove(turf_loc)

	qdel(src)

/obj/item/delivery/contents_explosion(severity, target)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			SSexplosions.high_mov_atom += contents
		if(EXPLODE_HEAVY)
			SSexplosions.med_mov_atom += contents
		if(EXPLODE_LIGHT)
			SSexplosions.low_mov_atom += contents

/obj/item/delivery/atom_deconstruct(dissambled = TRUE)
	unwrap_contents()
	post_unwrap_contents()

/obj/item/delivery/examine(mob/user)
	. = ..()
	if(note)
		if(!in_range(user, src))
			. += span_info(LANG("obj.f04df8ed8a05779d", list(EXAMINE_HINT(note.name))))
		else
			. += span_info(LANG("obj.5c28d3a346fa1b29", list(EXAMINE_HINT(note.name))))
			. += note.examine(user)
	if(sticker)
		. += span_notice(LANG("obj.7180780854705f22", list(EXAMINE_HINT("barcode"), EXAMINE_HINT("export."))))
	if(sort_tag)
		. += span_notice(LANG("obj.94d6c3a699b4358d", list(EXAMINE_HINT("sorting tag"), EXAMINE_HINT("[GLOB.TAGGERLOCATIONS[sort_tag]]."))))

/obj/item/delivery/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	SIGNAL_HANDLER
	if(!hasmob)
		disposal_holder.destinationTag = sort_tag

/obj/item/delivery/relay_container_resist_act(mob/living/user, obj/container)
	if(ismovable(loc))
		var/atom/movable/movable_loc = loc //can't unwrap the wrapped container if it's inside something.
		movable_loc.relay_container_resist_act(user, container)
		return
	to_chat(user, span_notice(LANG("obj.966c22fa96e2de9b", list(container))))
	if(do_after(user, 5 SECONDS, target = container))
		if(!user || IS_UNCONSCIOUS_OR_CRIT(user) || user.loc != container || container.loc != src)
			return
		to_chat(user, span_notice(LANG("obj.4bf27ae382a112a2", list(container))))
		container.forceMove(loc)
		unwrap_contents()
		post_unwrap_contents(user)
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, span_warning(LANG("obj.e5c385f194281f95", list(container))))

/obj/item/delivery/update_icon_state()
	. = ..()
	icon_state = giftwrapped ? "gift[base_icon_state]" : base_icon_state

/obj/item/delivery/update_overlays()
	. = ..()
	if(sort_tag)
		. += "[base_icon_state]_sort"
	if(note)
		. += "[base_icon_state]_note"
	if(sticker)
		. += "[base_icon_state]_barcode"

/obj/item/delivery/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/dest_tagger))
		var/relevant_tag = astype(tool, /obj/item/dest_tagger).currTag
		if(sort_tag == relevant_tag)
			return ITEM_INTERACT_BLOCKING
		var/tag = uppertext(GLOB.TAGGERLOCATIONS[relevant_tag])
		to_chat(user, span_notice("*[tag]*"))
		sort_tag = relevant_tag
		playsound(loc, 'sound/machines/beep/twobeep_high.ogg', 100, TRUE)
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stack/wrapping_paper))
		if(giftwrapped)
			return ITEM_INTERACT_BLOCKING
		var/obj/item/stack/wrapping_paper/wrapping_paper = tool
		if(!wrapping_paper.use(3))
			to_chat(user, span_warning(LANG("obj.7f44344b5179998a", null)))
			return ITEM_INTERACT_BLOCKING
		user.visible_message(span_notice(LANG("obj.7eb9f94d645eca95", list(user))))
		giftwrapped = TRUE
		greyscale_config = text2path("/datum/greyscale_config/gift[icon_state]")
		set_greyscale(colors = wrapping_paper.greyscale_colors)
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/paper))
		if(note)
			to_chat(user, span_warning(LANG("obj.c71b2862cbe2cca8", null)))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			to_chat(user, span_warning(LANG("obj.3326bf5acb707046", list(tool))))
			return ITEM_INTERACT_BLOCKING
		user.visible_message(span_notice(LANG("obj.c24be4ca3d4ab352", list(user, tool, src))), span_notice(LANG("obj.c1fbc99dd596332a", list(tool, src))))
		note = tool
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/universal_scanner))
		var/obj/item/universal_scanner/sales_tagger = tool
		if(sales_tagger.scanning_mode != SCAN_SALES_TAG)
			return ITEM_INTERACT_BLOCKING
		if(sticker)
			to_chat(user, span_warning(LANG("obj.14e3b20ccbfb390b", null)))
			return ITEM_INTERACT_BLOCKING
		if(!(sales_tagger.payments_acc))
			to_chat(user, span_warning(LANG("obj.cba92c53e3feb5a7", list(sales_tagger))))
			return ITEM_INTERACT_BLOCKING
		if(sales_tagger.paper_count <= 0)
			to_chat(user, span_warning(LANG("obj.3b0e27cd91480ce4", list(sales_tagger))))
			return ITEM_INTERACT_BLOCKING
		user.visible_message(span_notice(LANG("obj.10af87a7d61e494c", list(user, src))), span_notice(LANG("obj.7eef88ad929aaa0d", list(src))))
		sales_tagger.paper_count -= 1
		sticker = new /obj/item/barcode(src)
		sticker.payments_acc = sales_tagger.payments_acc	//new tag gets the tagger's current account.
		sticker.cut_multiplier = sales_tagger.cut_multiplier	//same, but for the percentage taken.

		for(var/obj/wrapped_item in get_all_contents())
			if(HAS_TRAIT(wrapped_item, TRAIT_NO_BARCODES))
				continue
			wrapped_item.AddComponent(/datum/component/pricetag, list(sticker.payments_acc), sales_tagger.cut_multiplier)
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/barcode))
		var/obj/item/barcode/stickerA = tool
		if(sticker)
			to_chat(user, span_warning(LANG("obj.14e3b20ccbfb390b", null)))
			return ITEM_INTERACT_BLOCKING
		if(!(stickerA.payments_acc))
			to_chat(user, span_warning(LANG("obj.79873f081baa64d9", null)))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			to_chat(user, span_warning(LANG("obj.3326bf5acb707046", list(tool))))
			return ITEM_INTERACT_BLOCKING
		sticker = stickerA
		for(var/obj/wrapped_item in get_all_contents())
			if(HAS_TRAIT(wrapped_item, TRAIT_NO_BARCODES))
				continue
			wrapped_item.AddComponent(/datum/component/pricetag, list(sticker.payments_acc), sticker.cut_multiplier)
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/boxcutter))
		var/obj/item/boxcutter/boxcutter_item = tool
		if(!HAS_TRAIT(boxcutter_item, TRAIT_TRANSFORM_ACTIVE))
			balloon_alert(user, LANG("obj.271bb5a88a56d189", null))
			return ITEM_INTERACT_BLOCKING
		if(!attempt_pre_unwrap_contents(user, time = 0.5 SECONDS))
			return ITEM_INTERACT_BLOCKING
		unwrap_contents()
		post_unwrap_contents(user, rip_open = FALSE)
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/delivery/nameformat(input, user)
	playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
	return "[name] ([input])" // This just repeatedly adds new labels, but i think that's intentional?

/**
 * # Wrapped up crates and lockers - too big to carry.
 */
/obj/item/delivery/big
	name = "large parcel"
	desc = "A large delivery parcel."
	icon_state = "deliverycloset"
	density = TRUE
	interaction_flags_item = 0 // Disable the ability to pick it up. Wow!
	layer = BELOW_OBJ_LAYER
	pass_flags_self = PASSSTRUCTURE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	w_class = WEIGHT_CLASS_GIGANTIC

/obj/item/delivery/big/interact(mob/user)
	if(!attempt_pre_unwrap_contents(user))
		return
	unwrap_contents()
	post_unwrap_contents()

/**
 * # Wrapped up items small enough to carry.
 */
/obj/item/delivery/small
	name = "parcel"
	desc = "A brown paper delivery parcel."
	icon_state = "deliverypackage3"

/obj/item/delivery/small/attack_self(mob/user)
	if(!attempt_pre_unwrap_contents(user))
		return
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	unwrap_contents()
	for(var/atom/movable/movable_content as anything in contents)
		user.put_in_hands(movable_content)
	post_unwrap_contents(user)

/obj/item/delivery/small/attack_self_tk(mob/user)
	if(ismob(loc))
		var/mob/M = loc
		M.temporarilyRemoveItemFromInventory(src, TRUE)
		for(var/atom/movable/movable_content as anything in contents)
			M.put_in_hands(movable_content)
	else
		for(var/atom/movable/movable_content as anything in contents)
			movable_content.forceMove(loc)

	unwrap_contents()
	post_unwrap_contents(user)
	return ITEM_INTERACT_BLOCKING

/obj/item/dest_tagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon = 'icons/obj/devices/tool.dmi'
	icon_state = "cargo tagger"
	worn_icon_state = "cargotagger"
	var/currTag = 0 //Destinations are stored in code\globalvars\lists\flavor_misc.dm
	var/locked_destination = FALSE //if true, users can't open the destination tag window to prevent changing the tagger's current destination
	w_class = WEIGHT_CLASS_TINY
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.5)

/obj/item/dest_tagger/borg
	name = "cyborg destination tagger"
	desc = "Used to fool the disposal mail network into thinking that you're a harmless parcel. Does actually work as a regular destination tagger as well."

/obj/item/dest_tagger/suicide_act(mob/living/user)
	user.visible_message(span_suicide(LANG("obj.61f8c7ff0a1be29d", list(user, user.p_their(), user.p_theyre()))))
	if (islizard(user))
		to_chat(user, span_notice(LANG("obj.a23ae7b6ab4bb75d", null)))//lizard nerf
	else
		to_chat(user, span_notice(LANG("obj.f5abfedf2d6054cc", null)))
	playsound(src, 'sound/machines/beep/twobeep_high.ogg', 100, TRUE)
	return BRUTELOSS

/** Standard TGUI actions */
/obj/item/dest_tagger/ui_interact(mob/user, datum/tgui/ui)
	add_fingerprint(user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DestinationTagger", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/** If the user dropped the tagger */
/obj/item/dest_tagger/ui_state(mob/user)
	return GLOB.inventory_state

/** User activates in hand */
/obj/item/dest_tagger/attack_self(mob/user)
	if(!locked_destination)
		ui_interact(user)
		return

/** Data sent to TGUI window */
/obj/item/dest_tagger/ui_data(mob/user)
	var/list/data = list()
	data["locations"] = GLOB.TAGGERLOCATIONS
	data["currentTag"] = currTag
	return data

/** User clicks a button on the tagger */
/obj/item/dest_tagger/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("change")
			var/new_tag = round(text2num(params["index"]))
			if(new_tag == currTag || new_tag < 1 || new_tag > length(GLOB.TAGGERLOCATIONS))
				return
			currTag = new_tag
	return TRUE

/obj/item/sales_tagger
	name = "sales tagger"
	desc = "A scanner that lets you tag wrapped items for sale, splitting the profit between you and cargo."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "sales tagger"
	worn_icon_state = "salestagger"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	///The account which is receiving the split profits.
	var/datum/bank_account/payments_acc = null
	var/paper_count = 10
	var/max_paper_count = 20
	///The person who tagged this will receive the sale value multiplied by this number.
	var/cut_multiplier = 0.5
	///Maximum value for cut_multiplier.
	var/cut_max = 0.5
	///Minimum value for cut_multiplier.
	var/cut_min = 0.01

/obj/item/sales_tagger/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.f9a45b6431b23640", list(src, paper_count, max_paper_count)))
	. += span_notice(LANG("obj.7e0bbac3ee915114", list(round(cut_multiplier*100))))
	if(payments_acc)
		. += span_notice(LANG("obj.5f19d3b2f0f82253", null))

/obj/item/sales_tagger/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(isidcard(tool))
		var/obj/item/card/id/potential_acc = tool
		if(!potential_acc.registered_account)
			to_chat(user, span_warning(LANG("obj.51d0d893aa8f5b8c", null)))
			return ITEM_INTERACT_BLOCKING
		if(payments_acc == potential_acc.registered_account)
			to_chat(user, span_notice(LANG("obj.bde32b20fdab4985", null)))
			return ITEM_INTERACT_BLOCKING
		payments_acc = potential_acc.registered_account
		playsound(src, 'sound/machines/ping.ogg', 40, TRUE)
		to_chat(user, span_notice(LANG("obj.37931711e356b6ed", list(src))))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/paper))
		if ((paper_count >= max_paper_count))
			to_chat(user, span_notice(LANG("obj.d0c8fa5b04b8e819", list(src))))
			return ITEM_INTERACT_BLOCKING
		paper_count += 10
		qdel(tool)
		if (paper_count >= max_paper_count)
			paper_count = max_paper_count
			to_chat(user, span_notice(LANG("obj.607209767ae525aa", list(src))))
			return ITEM_INTERACT_SUCCESS
		to_chat(user, span_notice(LANG("obj.c2d63d9cfb07eff9", list(src, paper_count))))
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/sales_tagger/attack_self(mob/user)
	. = ..()
	if(paper_count <= 0)
		to_chat(user, span_warning(LANG("obj.dd4e47aa9f2b617e", null)))
		return
	if(!payments_acc)
		to_chat(user, span_warning(LANG("obj.eb7c0a75fd746c70", list(src))))
		return
	paper_count -= 1
	playsound(src, 'sound/machines/click.ogg', 40, TRUE)
	to_chat(user, span_notice(LANG("obj.193ff4f4a019fd4c", null)))
	var/obj/item/barcode/new_barcode = new /obj/item/barcode(src)
	new_barcode.payments_acc = payments_acc		// The sticker gets the scanner's registered account.
	new_barcode.cut_multiplier = cut_multiplier		// Also the registered percent cut.
	user.put_in_hands(new_barcode)

/obj/item/sales_tagger/item_ctrl_click(mob/user)
	payments_acc = null
	to_chat(user, span_notice(LANG("obj.a24c91ba85b22c40", null)))
	return CLICK_ACTION_SUCCESS

/obj/item/sales_tagger/click_alt(mob/user)
	var/potential_cut = input(LANG("obj.64a2bf7c13540cc7", null),LANG("obj.9464744c35f078e2", list(round(cut_min*100), round(cut_max*100)))) as num|null
	if(!potential_cut)
		cut_multiplier = initial(cut_multiplier)
	cut_multiplier = clamp(round(potential_cut/100, cut_min), cut_min, cut_max)
	to_chat(user, span_notice(LANG("obj.e1da57adb1b0b029", list(round(cut_multiplier*100)))))
	return CLICK_ACTION_SUCCESS
