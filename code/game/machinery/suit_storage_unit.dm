
// SUIT STORAGE UNIT /////////////////
/obj/machinery/suit_storage_unit
	name = "套装存储单元"
	desc = "一个用于存放、充电和消毒设备的工业单元。它配有内置的紫外线烧灼机制。一个小警告标签提示不应将有机物质放入该单元。"
	icon = 'icons/obj/machines/suit_storage.dmi'
	icon_state = "classic"
	base_icon_state = "classic"
	power_channel = AREA_USAGE_EQUIP
	density = TRUE	// Becomes undense when the unit is open
	obj_flags = CAN_BE_HIT | BLOCKS_CONSTRUCTION | UNIQUE_RENAME | RENAME_NO_DESC
	interaction_flags_mouse_drop = NEED_DEXTERITY
	max_integrity = 250
	req_access = list()
	state_open = FALSE
	panel_open = FALSE
	circuit = /obj/item/circuitboard/machine/suit_storage_unit

	var/obj/item/clothing/suit/space/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null
	var/obj/item/clothing/mask/mask = null
	var/obj/item/mod/control/mod = null
	var/obj/item/storage = null
								// if you add more storage slots, update cook() to clear their radiation too.

	/// What type of spacesuit the unit starts with when spawned.
	var/suit_type = null
	/// What type of space helmet the unit starts with when spawned.
	var/helmet_type = null
	/// What type of breathmask the unit starts with when spawned.
	var/mask_type = null
	/// What type of MOD the unit starts with when spawned.
	var/mod_type = null
	/// What type of additional item the unit starts with when spawned.
	var/storage_type = null


	/// If the SSU's doors are locked closed. Can be toggled manually via the UI, but is also locked automatically when the UV decontamination sequence is running.
	var/locked = FALSE

	/// If the safety wire is cut/pulsed, the SSU can run the decontamination sequence while occupied by a mob. The mob will be burned during every cycle of cook().
	var/safeties = TRUE

	/// If UV decontamination sequence is running. See cook()
	var/uv = FALSE
	/**
	* If the hack wire is cut/pulsed.
	* Modifies effects of cook()
	* * If FALSE, decontamination sequence will clear radiation for all atoms (and their contents) contained inside the unit, and burn any mobs inside.
	* * If TRUE, decontamination sequence will delete all items contained within, and if occupied by a mob, intensifies burn damage delt. All wires will be cut at the end.
	*/
	var/uv_super = FALSE
	/// How many cycles remain for the decontamination sequence.
	var/uv_cycles = 6
	/// Cooldown for occupant breakout messages via relaymove()
	var/message_cooldown
	/// How long it takes to break out of the SSU.
	var/breakout_time = 30 SECONDS
	/// Power contributed by this machine to charge the mod suits cell without any capacitors
	var/base_charge_rate = 0.2 * STANDARD_CELL_RATE
	/// Final charge rate which is base_charge_rate + contribution by capacitors
	var/final_charge_rate = 0.25 * STANDARD_CELL_RATE
	/// is the card reader installed in this machine
	var/card_reader_installed = FALSE
	/// physical reference of the players id card to check for PERSONAL access level
	var/datum/weakref/id_card = null
	/// should we prevent further access change
	var/access_locked = FALSE

/obj/machinery/suit_storage_unit/standard_unit
	suit_type = /obj/item/clothing/suit/space/eva
	helmet_type = /obj/item/clothing/head/helmet/space/eva
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/spaceruin
	suit_type = /obj/item/clothing/suit/space
	helmet_type = /obj/item/clothing/head/helmet/space
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/tank/internals/oxygen

/obj/machinery/suit_storage_unit/captain
	mask_type = /obj/item/clothing/mask/gas/atmos/captain
	storage_type = /obj/item/tank/jetpack/captain
	mod_type = /obj/item/mod/control/pre_equipped/magnate

/obj/machinery/suit_storage_unit/centcom
	mask_type = /obj/item/clothing/mask/gas/atmos/centcom
	storage_type = /obj/item/tank/jetpack/captain
	mod_type = /obj/item/mod/control/pre_equipped/corporate

/obj/machinery/suit_storage_unit/engine
	mask_type = /obj/item/clothing/mask/breath
	mod_type = /obj/item/mod/control/pre_equipped/engineering

/obj/machinery/suit_storage_unit/atmos
	mask_type = /obj/item/clothing/mask/gas/atmos
	storage_type = /obj/item/watertank/atmos
	mod_type = /obj/item/mod/control/pre_equipped/atmospheric

/obj/machinery/suit_storage_unit/ce
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/clothing/shoes/magboots/advance
	mod_type = /obj/item/mod/control/pre_equipped/advanced

/obj/machinery/suit_storage_unit/security
	mask_type = /obj/item/clothing/mask/gas/sechailer
	mod_type = /obj/item/mod/control/pre_equipped/security

/obj/machinery/suit_storage_unit/hos
	mask_type = /obj/item/clothing/mask/gas/sechailer
	storage_type = /obj/item/tank/internals/oxygen
	mod_type = /obj/item/mod/control/pre_equipped/safeguard

/obj/machinery/suit_storage_unit/mining
	suit_type = /obj/item/clothing/suit/hooded/explorer
	mask_type = /obj/item/clothing/mask/gas/explorer

/obj/machinery/suit_storage_unit/mining/eva
	suit_type = null
	mask_type = /obj/item/clothing/mask/breath
	mod_type = /obj/item/mod/control/pre_equipped/mining

/obj/machinery/suit_storage_unit/medical
	mask_type = /obj/item/clothing/mask/breath/medical
	storage_type = /obj/item/tank/internals/oxygen
	mod_type = /obj/item/mod/control/pre_equipped/medical

/obj/machinery/suit_storage_unit/cmo
	mask_type = /obj/item/clothing/mask/breath/medical
	storage_type = /obj/item/tank/internals/oxygen
	mod_type = /obj/item/mod/control/pre_equipped/rescue

/obj/machinery/suit_storage_unit/rd
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/tank/internals/oxygen
	mod_type = /obj/item/mod/control/pre_equipped/research

/obj/machinery/suit_storage_unit/syndicate
	mask_type = /obj/item/clothing/mask/gas/syndicate
	storage_type = /obj/item/tank/jetpack/harness
	mod_type = /obj/item/mod/control/pre_equipped/nuclear

/obj/machinery/suit_storage_unit/syndicate/lavaland
	mod_type = /obj/item/mod/control/pre_equipped/nuclear/no_jetpack

/obj/machinery/suit_storage_unit/interdyne
	mask_type = /obj/item/clothing/mask/gas/syndicate
	storage_type = /obj/item/tank/internals/oxygen
	mod_type = /obj/item/mod/control/pre_equipped/interdyne

/obj/machinery/suit_storage_unit/void_old
	suit_type = /obj/item/clothing/suit/space/nasavoid/old
	helmet_type = /obj/item/clothing/head/helmet/space/nasavoid/old
	storage_type = /obj/item/tank/internals/oxygen/yellow

/obj/machinery/suit_storage_unit/void_old/jetpack
	storage_type = /obj/item/tank/jetpack/void

/obj/machinery/suit_storage_unit/radsuit
	name = "防辐射服存储单元"
	suit_type = /obj/item/clothing/suit/utility/radiation
	helmet_type = /obj/item/clothing/head/utility/radiation
	storage_type = /obj/item/geiger_counter

/obj/machinery/suit_storage_unit/nuke_med
	suit_type = /obj/item/clothing/suit/space/syndicate/black/med
	helmet_type = /obj/item/clothing/head/helmet/space/syndicate/black/med

/obj/machinery/suit_storage_unit/open
	state_open = TRUE
	density = FALSE

/obj/machinery/suit_storage_unit/industrial
	name = "工业套装存储单元"
	icon_state = "industrial"
	base_icon_state = "industrial"

/obj/machinery/suit_storage_unit/industrial/loader
	mod_type = /obj/item/mod/control/pre_equipped/loader

/obj/machinery/suit_storage_unit/Initialize(mapload)
	. = ..()

	set_access()
	set_wires(new /datum/wires/suit_storage_unit(src))
	if(suit_type)
		suit = new suit_type(src)
	if(helmet_type)
		helmet = new helmet_type(src)
	if(mask_type)
		mask = new mask_type(src)
	if(mod_type)
		mod = new mod_type(src)
	if(storage_type)
		storage = new storage_type(src)
	update_appearance()

	register_context()

/obj/machinery/suit_storage_unit/Destroy()
	QDEL_NULL(suit)
	QDEL_NULL(helmet)
	QDEL_NULL(mask)
	QDEL_NULL(mod)
	QDEL_NULL(storage)
	id_card = null
	return ..()

/obj/machinery/suit_storage_unit/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(isnull(held_item))
		return NONE

	var/screentip_change = FALSE
	if(istype(held_item, /obj/item/stock_parts/card_reader) && !locked && can_install_card_reader(user))
		context[SCREENTIP_CONTEXT_LMB] ="Install Reader"
		screentip_change = TRUE

	if(held_item.tool_behaviour == TOOL_MULTITOOL && !locked && !panel_open && !state_open && card_reader_installed)
		context[SCREENTIP_CONTEXT_LMB] ="[access_locked ? "Unlock" : "Lock"] Access Panel"
		screentip_change = TRUE

	if(!state_open && is_operational && card_reader_installed && !isnull((held_item.GetID())))
		context[SCREENTIP_CONTEXT_LMB] ="Change Access"
		screentip_change = TRUE

	return screentip_change ? CONTEXTUAL_SCREENTIP_SET : NONE


/obj/machinery/suit_storage_unit/update_overlays()
	. = ..()
	//if things aren't powered, these show anyways
	if(panel_open)
		. += "[base_icon_state]_panel"
	if(state_open)
		. += "[base_icon_state]_open"
		if(suit || mod)
			. += "[base_icon_state]_suit"
		if(helmet)
			. += "[base_icon_state]_helm"
		if(storage)
			. += "[base_icon_state]_storage"
	if(!(machine_stat & BROKEN || machine_stat & NOPOWER))
		if(state_open)
			. += "[base_icon_state]_lights_open"
		else
			if(uv)
				if(uv_super)
					. += "[base_icon_state]_super"
				. += "[base_icon_state]_lights_red"
			else
				. += "[base_icon_state]_lights_closed"
		//top lights
		if(uv)
			if(uv_super)
				. += "[base_icon_state]_uvstrong"
			else
				. += "[base_icon_state]_uv"
		else if(locked)
			. += "[base_icon_state]_locked"
		else
			. += "[base_icon_state]_ready"

/obj/machinery/suit_storage_unit/examine(mob/user)
	. = ..()
	if(card_reader_installed)
		. += span_notice("刷卡以更改访问级别。")
		. += span_notice("打开面板后，使用多功能工具来[access_locked ? "unlock" : "lock"]访问面板。")
	else
		. += span_notice("打开其面板后，可以安装读卡器以进行进一步的访问控制。")

/// copy over access of electronics
/obj/machinery/suit_storage_unit/proc/set_access(list/accesses)
	var/obj/item/electronics/airlock/electronics = locate() in component_parts
	if(QDELETED(electronics))
		return

	if(!isnull(accesses))
		electronics.accesses = accesses
	if(electronics.one_access)
		req_one_access = electronics.accesses
		req_access = null
	else
		req_access = electronics.accesses
		req_one_access = null

/obj/machinery/suit_storage_unit/RefreshParts()
	. = ..()

	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		final_charge_rate = base_charge_rate + (capacitor.tier * 0.05 * STANDARD_CELL_RATE)

	set_access()

/obj/machinery/suit_storage_unit/power_change()
	. = ..()
	if(!is_operational && state_open)
		open_machine()
		dump_inventory_contents()
	update_appearance()

/obj/machinery/suit_storage_unit/dump_inventory_contents()
	. = ..()
	helmet = null
	suit = null
	mask = null
	mod = null
	storage = null
	set_occupant(null)

/obj/machinery/suit_storage_unit/on_deconstruction(disassembled)
	if(card_reader_installed)
		new /obj/item/stock_parts/card_reader(loc)

/obj/machinery/suit_storage_unit/proc/access_check(mob/living/user)
	if(!isnull(id_card))
		var/obj/item/card/id/id = id_card?.resolve()
		if(!id) // reset to defaults
			name = initial(name)
			desc = initial(desc)
			id_card = null
			req_access = list()
			req_one_access = null
			set_access(list())
			return TRUE
		if(user.get_idcard() != id)
			balloon_alert(user, "不是你的单元！")
			return FALSE

	if(!allowed(user))
		balloon_alert(user, "访问被拒绝！")
		return FALSE

	return TRUE

/obj/machinery/suit_storage_unit/interact(mob/living/user)
	var/static/list/items

	if (!items)
		items = list(
			"suit" = create_silhouette_of(/obj/item/clothing/suit/space/eva),
			"helmet" = create_silhouette_of(/obj/item/clothing/head/helmet/space/eva),
			"mask" = create_silhouette_of(/obj/item/clothing/mask/breath),
			"mod" = create_silhouette_of(/obj/item/mod/control),
			"storage" = create_silhouette_of(/obj/item/tank/internals/oxygen),
		)

	. = ..()
	if (.)
		return

	if (!check_interactable(user))
		return

	var/list/choices = list()

	if (locked)
		choices["unlock"] = icon('icons/hud/radial.dmi', "radial_unlock")
	else if (state_open)
		choices["close"] = icon('icons/hud/radial.dmi', "radial_close")

		for (var/item_key in items)
			var/item = vars[item_key]
			if (item)
				choices[item_key] = item
			else
				// If the item doesn't exist, put a silhouette in its place
				choices[item_key] = items[item_key]
	else
		choices["open"] = icon('icons/hud/radial.dmi', "radial_open")
		choices["disinfect"] = icon('icons/hud/radial.dmi', "radial_disinfect")
		choices["lock"] = icon('icons/hud/radial.dmi', "radial_lock")

	var/choice = show_radial_menu(
		user,
		src,
		choices,
		custom_check = CALLBACK(src, PROC_REF(check_interactable), user),
		require_near = !HAS_SILICON_ACCESS(user),
		autopick_single_option = FALSE
	)

	if (!choice)
		return

	switch (choice)
		if ("open")
			if (!state_open)
				if(!access_check(user))
					return
				open_machine(drop = FALSE)
				if (occupant)
					dump_inventory_contents()
		if ("close")
			if (state_open)
				close_machine()
		if ("disinfect")
			if(!access_check(user))
				return
			if (occupant && safeties)
				say("Alert: safeties triggered, occupant detected!")
				return
			else if (!helmet && !mask && !suit && !mod && !storage && !occupant)
				to_chat(user, "[src]里面没有任何东西需要消毒！")
				return
			else
				if (occupant)
					var/mob/living/mob_occupant = occupant
					to_chat(mob_occupant, span_userdanger("[src]'s confines grow warm, then hot, then scorching. You're being burned [!mob_occupant.stat ? "alive" : "away"]!"))
				cook()
		if ("lock", "unlock")
			if(locked && !access_check(user))
				return
			if (!state_open)
				locked = !locked
				update_icon()
		else
			var/obj/item/item_to_dispense = vars[choice]
			if (item_to_dispense)
				vars[choice] = null
				try_put_in_hand(item_to_dispense, user)
				update_icon()
			else
				var/obj/item/in_hands = user.get_active_held_item()
				if (in_hands)
					attackby(in_hands, user)
				update_icon()

	interact(user)

/obj/machinery/suit_storage_unit/proc/check_interactable(mob/user)
	if (!state_open && !can_interact(user))
		return FALSE

	if (panel_open)
		return FALSE

	if (uv)
		return FALSE

	return TRUE

/obj/machinery/suit_storage_unit/proc/create_silhouette_of(atom/item)
	var/image/image = image(initial(item.icon), initial(item.icon_state))
	image.alpha = 128
	image.color = COLOR_RED
	return image

/obj/machinery/suit_storage_unit/mouse_drop_receive(atom/A, mob/living/user, params)
	if(!isliving(A))
		return
	var/mob/living/target = A
	if(!state_open)
		to_chat(user, span_warning("单元的门关着！"))
		return
	if(!is_operational)
		to_chat(user, span_warning("单元无法运作！"))
		return
	if(occupant || helmet || suit || storage)
		to_chat(user, span_warning("里面太乱了,放不下!"))
		return

	if(target == user)
		user.visible_message(span_warning("[user]开始挤进[src]！"), span_notice("你开始逐步进入 [src]..."))
	else
		target.visible_message(span_warning("[user]开始把[target]推进[src]！"), span_userdanger("[user]开始把你推进[src]！"))

	if(do_after(user, 3 SECONDS, target))
		if(occupant || helmet || suit || storage)
			return
		if(target == user)
			user.visible_message(span_warning("[user]滑进了[src]并在[user.p_them()]身后关上了门！"), span_notice("你溜进[src]狭窄的空间并关上了它的门。"))
		else
			target.visible_message(span_warning("[user]把[target]推进[src]并关上了它的门！"), span_userdanger("[user]把你推进[src]并关上了门！"))
		close_machine(target)
		add_fingerprint(user)

/**
 * UV decontamination sequence.
 * Duration is determined by the uv_cycles var.
 * Effects determined by the uv_super var.
 * * If FALSE, all atoms (and their contents) contained are cleared of radiation. If a mob is inside, they are burned every cycle.
 * * If TRUE, all items contained are destroyed, and burn damage applied to the mob is increased. All wires will be cut at the end.
 * All atoms still inside at the end of all cycles are ejected from the unit.
*/
/obj/machinery/suit_storage_unit/proc/cook()
	var/mob/living/mob_occupant = occupant
	if(uv_cycles)
		uv_cycles--
		uv = TRUE
		locked = TRUE
		update_appearance()
		if(mob_occupant)
			if(uv_super)
				mob_occupant.adjust_fire_loss(rand(20, 36))
			else
				mob_occupant.adjust_fire_loss(rand(10, 16))
			if(iscarbon(mob_occupant) && mob_occupant.stat < UNCONSCIOUS)
				//Awake, organic and screaming
				mob_occupant.emote("scream")
		addtimer(CALLBACK(src, PROC_REF(cook)), 5 SECONDS)
	else
		uv_cycles = initial(uv_cycles)
		uv = FALSE
		locked = FALSE
		if(uv_super)
			visible_message(span_warning("[src]的门伴随着刺耳的嘎吱声打开。一股恶臭的黑烟从其舱室中逸出。"))
			playsound(src, 'sound/machines/airlock/airlock_alien_prying.ogg', 50, TRUE)
			do_smoke(0, src, src, smoke_type = /datum/effect_system/fluid_spread/smoke/bad/black)
			QDEL_NULL(helmet)
			QDEL_NULL(suit)
			QDEL_NULL(mask)
			QDEL_NULL(mod)
			QDEL_NULL(storage)
			// The wires get damaged too.
			wires.cut_all()
		else
			if(!mob_occupant)
				visible_message(span_notice("[src]的门滑开了。发光的黄色灯光暗淡下来，变成了柔和的绿色。"))
			else
				visible_message(span_warning("[src]的门滑开了，一股令人作呕的焦肉味扑面而来。"))
				qdel(mob_occupant.GetComponent(/datum/component/irradiated))
			playsound(src, 'sound/machines/airlock/airlockclose.ogg', 25, TRUE)
			var/list/things_to_clear = list() //Done this way since using GetAllContents on the SSU itself would include circuitry and such.
			if(suit)
				things_to_clear += suit
				things_to_clear += suit.get_all_contents()
			if(helmet)
				things_to_clear += helmet
				things_to_clear += helmet.get_all_contents()
			if(mask)
				things_to_clear += mask
				things_to_clear += mask.get_all_contents()
			if(mod)
				things_to_clear += mod
				things_to_clear += mod.get_all_contents()
			if(storage)
				things_to_clear += storage
				things_to_clear += storage.get_all_contents()
			if(mob_occupant)
				things_to_clear += mob_occupant
				things_to_clear += mob_occupant.get_all_contents()
			for(var/am in things_to_clear) //Scorches away blood and forensic evidence, although the SSU itself is unaffected
				var/atom/movable/dirty_movable = am
				dirty_movable.wash(CLEAN_ALL)
		open_machine(FALSE)
		if(mob_occupant)
			dump_inventory_contents()

/obj/machinery/suit_storage_unit/process(seconds_per_tick)
	var/list/cells_to_charge = list()
	for(var/obj/item/charging in list(mod, suit, helmet, mask, storage))
		var/obj/item/stock_parts/power_store/cell_charging = charging.get_cell()
		if(!istype(cell_charging) || cell_charging.charge == cell_charging.maxcharge)
			continue

		cells_to_charge += cell_charging

	var/cell_count = length(cells_to_charge)
	if(cell_count <= 0)
		return

	var/charge_per_item = (final_charge_rate * seconds_per_tick) / cell_count
	for(var/obj/item/stock_parts/power_store/cell as anything in cells_to_charge)
		charge_cell(charge_per_item, cell, grid_only = TRUE)

/obj/machinery/suit_storage_unit/relaymove(mob/living/user, direction)
	if(locked)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, span_warning("[src]的门纹丝不动！"))
		return
	open_machine()
	dump_inventory_contents()

/obj/machinery/suit_storage_unit/container_resist_act(mob/living/user)
	if(!locked)
		open_machine()
		dump_inventory_contents()
		return
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_notice("你看见[user]正在猛踢[src]的门！"), \
		span_notice("你开始猛踢舱门...（这大约需要[DisplayTimeText(breakout_time)]。）"), \
		span_hear("你听到[src]发出一声重击。"))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src )
			return
		user.visible_message(span_warning("[user]成功从[src]里挣脱出来了！"), \
			span_notice("你成功从[src]里挣脱出来了！"))
		open_machine()
		dump_inventory_contents()

	add_fingerprint(user)
	if(locked)
		visible_message(span_notice("你看见[user]正在猛踢[src]的门！"), \
			span_notice("你开始猛踢舱门..."))
		addtimer(CALLBACK(src, PROC_REF(resist_open), user), 30 SECONDS)
	else
		open_machine()
		dump_inventory_contents()

/obj/machinery/suit_storage_unit/proc/resist_open(mob/user)
	if(!state_open && occupant && (user in src) && user.stat == CONSCIOUS) // Check they're still here.
		visible_message(span_notice("你看见[user]从[src]里冲了出来！"), \
			span_notice("你逃离了[src]的狭窄空间！"))
		open_machine()

/obj/machinery/suit_storage_unit/multitool_act(mob/living/user, obj/item/tool)
	if(!card_reader_installed || state_open)
		return ITEM_INTERACT_BLOCKING

	if(locked)
		balloon_alert(user, "请先解锁！")
		return ITEM_INTERACT_BLOCKING

	access_locked = !access_locked
	balloon_alert(user, "访问面板[access_locked ? "locked" : "unlocked"]")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/suit_storage_unit/proc/can_install_card_reader(mob/user)
	if(card_reader_installed || !panel_open || state_open || !is_operational)
		return FALSE

	if(locked)
		balloon_alert(user, "请先解锁！")
		return FALSE

	return TRUE

/obj/machinery/suit_storage_unit/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(user.combat_mode)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(istype(tool, /obj/item/stock_parts/card_reader) && can_install_card_reader(user))
		user.visible_message(span_notice("[user]正在安装读卡器。"),
					span_notice("你开始安装读卡器。"))
		if(!do_after(user, 4 SECONDS, target = src, extra_checks = CALLBACK(src, PROC_REF(can_install_card_reader), user)))
			return ITEM_INTERACT_BLOCKING
		qdel(tool)
		card_reader_installed = TRUE
		balloon_alert(user, "读卡器已安装")
		return ITEM_INTERACT_SUCCESS

	var/obj/item/card/id/id = null
	if(!state_open && is_operational && card_reader_installed && !isnull((id = tool.GetID())))
		if(panel_open)
			balloon_alert(user, "请关闭面板！")
			return ITEM_INTERACT_BLOCKING
		if(locked)
			balloon_alert(user, "请先解锁！")
			return ITEM_INTERACT_BLOCKING
		if(access_locked)
			balloon_alert(user, "访问面板已锁定！")
			return ITEM_INTERACT_BLOCKING

		// change the access type
		var/static/list/choices = list(
			"Personal",
			"Departmental",
			"None",
		)
		var/choice = tgui_input_list(user, "设置访问类型", "访问类型", choices)
		if(isnull(choice))
			return ITEM_INTERACT_BLOCKING
		id_card = null
		switch(choice)
			if("Personal") // only the player who swiped their id has access
				id_card = WEAKREF(id)
				name = "[id.registered_name] 防护服存储单元"
				desc = "归 [id.registered_name] 所有。[initial(desc)]"
			if("Departmental") // anyone who has the same access permissions as this id has access
				name = "[id.assignment] 防护服存储单元"
				desc = "这是一个 [id.assignment] 防护服存储单元。[initial(desc)]"
				set_access(id.GetAccess())
			if("None") // free for all
				name = initial(name)
				desc = initial(desc)
				req_access = list()
				req_one_access = null
				set_access(list())
		if(!isnull(id_card))
			balloon_alert(user, "现在归[id.registered_name]所有")
		else
			balloon_alert(user, "设置为[choice]")
		return ITEM_INTERACT_SUCCESS

	if(state_open && is_operational)
		if(istype(tool, /obj/item/clothing/suit))
			if(suit)
				to_chat(user, span_warning("该单元内已有一件防护服！"))
				return ITEM_INTERACT_BLOCKING
			if(!user.transferItemToLoc(tool, src))
				return ITEM_INTERACT_BLOCKING
			suit = tool
		else if(istype(tool, /obj/item/clothing/head))
			if(helmet)
				to_chat(user, span_warning("单元已经存有头盔！"))
				return ITEM_INTERACT_BLOCKING
			if(!user.transferItemToLoc(tool, src))
				return ITEM_INTERACT_BLOCKING
			helmet = tool
		else if(istype(tool, /obj/item/clothing/mask))
			if(mask)
				to_chat(user, span_warning("单元已经存有面具！"))
				return ITEM_INTERACT_BLOCKING
			if(!user.transferItemToLoc(tool, src))
				return ITEM_INTERACT_BLOCKING
			mask = tool
		else if(istype(tool, /obj/item/storage/backpack) || istype(tool, /obj/item/mod/control))
			if(mod)
				to_chat(user, span_warning("该单元内已有一个背包或MOD！"))
				return ITEM_INTERACT_BLOCKING
			if(!user.transferItemToLoc(tool, src))
				return ITEM_INTERACT_BLOCKING
			mod = tool
		else
			if(storage)
				to_chat(user, span_warning("辅助储物舱已满！"))
				return ITEM_INTERACT_BLOCKING
			if(!user.transferItemToLoc(tool, src))
				return ITEM_INTERACT_BLOCKING
			storage = tool
		visible_message(span_notice("[user] 将 [tool] 放入 [src]"), span_notice("你将 [tool] 装入 [src]。"))
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(panel_open)
		if(is_wire_tool(tool))
			wires.interact(user)
			return ITEM_INTERACT_SUCCESS
		else if(tool.tool_behaviour == TOOL_CROWBAR)
			return default_deconstruction_crowbar(user, tool)

	if(default_pry_open(user, tool) & ITEM_INTERACT_SUCCESS)
		dump_inventory_contents()
		return ITEM_INTERACT_SUCCESS

/* ref tg-git issue #45036
	screwdriving it open while it's running a decontamination sequence without closing the panel prior to finish
	causes the SSU to break due to state_open being set to TRUE at the end, and the panel becoming inaccessible.
*/
/obj/machinery/suit_storage_unit/screwdriver_act(mob/living/user, obj/item/tool)
	if(state_open)
		return NONE
	if(uv || locked)
		to_chat(user, span_warning("在它[locked ? "locked" : "decontaminating"]时无法打开面板"))
		return ITEM_INTERACT_BLOCKING

	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/suit_storage_unit/can_crowbar_pry_open()
	return ..() && !locked

/obj/machinery/suit_storage_unit/can_crowbar_deconstruct()
	return ..() && !locked

/obj/machinery/suit_storage_unit/rename_checks(mob/living/user)
	. = TRUE
	if(locked)
		balloon_alert(user, "先解锁！")
		return FALSE
	if(!access_check(user))
		balloon_alert(user, "这不是你能重命名的！")
		return FALSE

/// If the SSU needs to have any communications wires cut.
/obj/machinery/suit_storage_unit/proc/disable_modlink()
	if(isnull(mod))
		return

	mod.disable_modlink()
