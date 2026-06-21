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
	to_chat(user, span_notice("你开始拆开包裹……"))
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
			. += span_info("There's a [EXAMINE_HINT(note.name)] attached to it. You can't read it from here.")
		else
			. += span_info("上面附着一张[EXAMINE_HINT(note.name)]……")
			. += note.examine(user)
	if(sticker)
		. += span_notice("There's a [EXAMINE_HINT("barcode")] attached to the side. The package is marked for [EXAMINE_HINT("export.")]")
	if(sort_tag)
		. += span_notice("There's a [EXAMINE_HINT("sorting tag")] with the destination set to [EXAMINE_HINT("[GLOB.TAGGERLOCATIONS[sort_tag]].")]")

/obj/item/delivery/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	SIGNAL_HANDLER
	if(!hasmob)
		disposal_holder.destinationTag = sort_tag

/obj/item/delivery/relay_container_resist_act(mob/living/user, obj/container)
	if(ismovable(loc))
		var/atom/movable/movable_loc = loc //can't unwrap the wrapped container if it's inside something.
		movable_loc.relay_container_resist_act(user, container)
		return
	to_chat(user, span_notice("你靠在[container]的背面，开始用力撕扯包裹它的包装纸。"))
	if(do_after(user, 5 SECONDS, target = container))
		if(!user || user.stat != CONSCIOUS || user.loc != container || container.loc != src)
			return
		to_chat(user, span_notice("你成功移除了[container]的包装！"))
		container.forceMove(loc)
		unwrap_contents()
		post_unwrap_contents(user)
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, span_warning("你未能移除[container]的包装！"))

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

/obj/item/delivery/attackby(obj/item/item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(item, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/dest_tagger = item

		if(sort_tag != dest_tagger.currTag)
			var/tag = uppertext(GLOB.TAGGERLOCATIONS[dest_tagger.currTag])
			to_chat(user, span_notice("*[tag]*"))
			sort_tag = dest_tagger.currTag
			playsound(loc, 'sound/machines/beep/twobeep_high.ogg', 100, TRUE)
			update_appearance()

	else if(istype(item, /obj/item/stack/wrapping_paper) && !giftwrapped)
		var/obj/item/stack/wrapping_paper/wrapping_paper = item
		if(wrapping_paper.use(3))
			user.visible_message(span_notice("[user]用节日包装纸包裹了包裹！"))
			giftwrapped = TRUE
			greyscale_config = text2path("/datum/greyscale_config/gift[icon_state]")
			set_greyscale(colors = wrapping_paper.greyscale_colors)
			update_appearance()
		else
			to_chat(user, span_warning("你需要更多包装纸！"))

	else if(istype(item, /obj/item/paper))
		if(note)
			to_chat(user, span_warning("这个包裹已经附有便条了！"))
			return
		if(!user.transferItemToLoc(item, src))
			to_chat(user, span_warning("出于某种原因，你无法附上[item]！"))
			return
		user.visible_message(span_notice("[user]将[item]附在[src]上。"), span_notice("你将[item]附在[src]上。"))
		note = item
		update_appearance()

	else if(istype(item, /obj/item/universal_scanner))
		var/obj/item/universal_scanner/sales_tagger = item
		if(sales_tagger.scanning_mode != SCAN_SALES_TAG)
			return
		if(sticker)
			to_chat(user, span_warning("这个包裹已经贴有条形码了！"))
			return
		if(!(sales_tagger.payments_acc))
			to_chat(user, span_warning("先在 [sales_tagger] 上刷一下ID卡！"))
			return
		if(sales_tagger.paper_count <= 0)
			to_chat(user, span_warning("[sales_tagger] 没纸了！"))
			return
		user.visible_message(span_notice("[user] 将一个条形码贴到 [src] 上。"), span_notice("你将一个条形码贴到 [src] 上。"))
		sales_tagger.paper_count -= 1
		sticker = new /obj/item/barcode(src)
		sticker.payments_acc = sales_tagger.payments_acc	//new tag gets the tagger's current account.
		sticker.cut_multiplier = sales_tagger.cut_multiplier	//same, but for the percentage taken.

		for(var/obj/wrapped_item in get_all_contents())
			if(HAS_TRAIT(wrapped_item, TRAIT_NO_BARCODES))
				continue
			wrapped_item.AddComponent(/datum/component/pricetag, list(sticker.payments_acc), sales_tagger.cut_multiplier)
		update_appearance()

	else if(istype(item, /obj/item/barcode))
		var/obj/item/barcode/stickerA = item
		if(sticker)
			to_chat(user, span_warning("这个包裹已经贴有条形码了！"))
			return
		if(!(stickerA.payments_acc))
			to_chat(user, span_warning("这个条形码似乎是无效的。看来现在它是垃圾了。"))
			return
		if(!user.transferItemToLoc(item, src))
			to_chat(user, span_warning("出于某种原因，你无法附上[item]！"))
			return
		sticker = stickerA
		for(var/obj/wrapped_item in get_all_contents())
			if(HAS_TRAIT(wrapped_item, TRAIT_NO_BARCODES))
				continue
			wrapped_item.AddComponent(/datum/component/pricetag, list(sticker.payments_acc), sticker.cut_multiplier)
		update_appearance()

	else if(istype(item, /obj/item/boxcutter))
		var/obj/item/boxcutter/boxcutter_item = item
		if(HAS_TRAIT(boxcutter_item, TRAIT_TRANSFORM_ACTIVE))
			if(!attempt_pre_unwrap_contents(user, time = 0.5 SECONDS))
				return
			unwrap_contents()
			balloon_alert(user, "正在切开包裹...")
			post_unwrap_contents(user, rip_open = FALSE)
		else
			balloon_alert(user, "启动开箱刀！")

	else
		return ..()

/obj/item/delivery/nameformat(input, user)
	playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
	return "[name] ([input])" // This just repeatedly adds new labels, but i think that's intentional?

/**
 * # Wrapped up crates and lockers - too big to carry.
 */
/obj/item/delivery/big
	name = "大包裹"
	desc = "一个大型货运包裹。"
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
	name = "包裹"
	desc = "一个棕色的纸制快递包裹。"
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
	name = "目的地标记器"
	desc = "用于设定已妥善包装的包裹送达目的地。"
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

/obj/item/dest_tagger/borg
	name = "赛博目的地标记器"
	desc = "这种标签通常会被投递邮件系统误认为是一封无害的包裹。实际上，它也能作为常规的收件标签使用。"

/obj/item/dest_tagger/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 开始标记 [user.p_their()] 最终目的地！看起来 [user.p_theyre()] 试图自杀！"))
	if (islizard(user))
		to_chat(user, span_notice("*地狱*"))//lizard nerf
	else
		to_chat(user, span_notice("*天堂*"))
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
	name = "售货标记器"
	desc = "一个扫描仪，能让您为待售的包装商品打上标签，从而将利润与货物所有者进行分配。"
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
	. += span_notice("[src] 有 [paper_count]/[max_paper_count] 个可用条形码。用纸补充。")
	. += span_notice("销售利润分成当前设置为 [round(cut_multiplier*100)]%。<b>Alt-点击</b>以更改。")
	if(payments_acc)
		. += span_notice("<b>Ctrl-点击</b>以清除已注册账户。")

/obj/item/sales_tagger/attackby(obj/item/item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(isidcard(item))
		var/obj/item/card/id/potential_acc = item
		if(potential_acc.registered_account)
			if(payments_acc == potential_acc.registered_account)
				to_chat(user, span_notice("ID卡已注册。"))
				return
			else
				payments_acc = potential_acc.registered_account
				playsound(src, 'sound/machines/ping.ogg', 40, TRUE)
				to_chat(user, span_notice("[src] 注册了ID卡。标记一个已包装的物品以创建条形码。"))
		else if(!potential_acc.registered_account)
			to_chat(user, span_warning("这张ID卡没有注册账户！"))
			return
	if(istype(item, /obj/item/paper))
		if (!(paper_count >= max_paper_count))
			paper_count += 10
			qdel(item)
			if (paper_count >= max_paper_count)
				paper_count = max_paper_count
				to_chat(user, span_notice("[src] 的纸张供应现已满。"))
				return
			to_chat(user, span_notice("你补充了[src]的纸张供应，还剩[paper_count]张。"))
			return
		else
			to_chat(user, span_notice("[src]的纸张供应已满。"))
			return

/obj/item/sales_tagger/attack_self(mob/user)
	. = ..()
	if(paper_count <= 0)
		to_chat(user, span_warning("你的纸用完了！'。"))
		return
	if(!payments_acc)
		to_chat(user, span_warning("你需要先用ID卡刷一下[src]。"))
		return
	paper_count -= 1
	playsound(src, 'sound/machines/click.ogg', 40, TRUE)
	to_chat(user, span_notice("你打印了一张新的条形码。"))
	var/obj/item/barcode/new_barcode = new /obj/item/barcode(src)
	new_barcode.payments_acc = payments_acc		// The sticker gets the scanner's registered account.
	new_barcode.cut_multiplier = cut_multiplier		// Also the registered percent cut.
	user.put_in_hands(new_barcode)

/obj/item/sales_tagger/item_ctrl_click(mob/user)
	payments_acc = null
	to_chat(user, span_notice("你清除了已注册的账户。"))
	return CLICK_ACTION_SUCCESS

/obj/item/sales_tagger/click_alt(mob/user)
	var/potential_cut = input("你想向注册的卡支付多少？","利润百分比 ([round(cut_min*100)]% - [round(cut_max*100)]%)") as num|null
	if(!potential_cut)
		cut_multiplier = initial(cut_multiplier)
	cut_multiplier = clamp(round(potential_cut/100, cut_min), cut_min, cut_max)
	to_chat(user, span_notice("带有条形码的包裹售出后，将获得[round(cut_multiplier*100)]%的利润。"))
	return CLICK_ACTION_SUCCESS
