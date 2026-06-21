//Holds defibs does NOT recharge them
//You can activate the mount with an empty hand to grab the paddles
//Not being adjacent will cause the paddles to snap back
/obj/machinery/defibrillator_mount
	name = "除颤器墙挂"
	desc = "用来挂住除颤器。如果上面挂着一台除颤器，你可以取下电极板。"
	icon = 'icons/obj/machines/defib_mount.dmi'
	icon_state = "defibrillator_mount"
	density = FALSE
	use_power = NO_POWER_USE
	active_power_usage = 40 * BASE_MACHINE_ACTIVE_CONSUMPTION
	power_channel = AREA_USAGE_EQUIP
	req_one_access = list(ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_SECURITY) //used to control clamps
	processing_flags = NONE
	/// The mount's defib
	var/obj/item/defibrillator/defib
	/// if true, and a defib is loaded, it can't be removed without unlocking the clamps
	var/clamps_locked = FALSE
	/// the type of wallframe it 'disassembles' into
	var/wallframe_type = /obj/item/wallframe/defib_mount

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/defibrillator_mount, 28)

/obj/machinery/defibrillator_mount/Initialize(mapload)
	. = ..()
	if(mapload)
		find_and_mount_on_atom()

/obj/machinery/defibrillator_mount/loaded/Initialize(mapload) //loaded subtype for mapping use
	. = ..()
	defib = new/obj/item/defibrillator/loaded(src)

/obj/machinery/defibrillator_mount/Destroy()
	QDEL_NULL(defib)
	return ..()

/obj/machinery/defibrillator_mount/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == defib)
		// Make sure processing ends before the defib is nulled
		end_processing()
		defib = null
		update_appearance()

/obj/machinery/defibrillator_mount/examine(mob/user)
	. = ..()
	if(defib)
		. += span_notice("上面连接着一个除颤器单元，Alt+点击来移除.")
		if(SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED)
			. += span_notice("由于安全情况，可以通过滑动任何 ID 来切换其锁定夹。")
		else
			. += span_notice("其夹具锁可以[clamps_locked ? "dis" : ""]通过刷取ID而开启")

/obj/machinery/defibrillator_mount/update_overlays()
	. = ..()
	if(isnull(defib))
		return

	var/mutable_appearance/defib_overlay = mutable_appearance(icon, "defib", layer = layer+0.01, offset_spokesman = src)

	if(defib.powered)
		var/obj/item/stock_parts/power_store/cell = defib.cell
		var/mutable_appearance/safety = mutable_appearance(icon, defib.safety ? "online" : "emagged", offset_spokesman = src)
		var/mutable_appearance/charge_overlay = mutable_appearance(icon, "charge[CEILING((cell.charge / cell.maxcharge) * 4, 1) * 25]", offset_spokesman = src)

		defib_overlay.overlays += list(safety, charge_overlay)

	if(clamps_locked)
		var/mutable_appearance/clamps = mutable_appearance(icon, "clamps", offset_spokesman = src)
		defib_overlay.overlays += clamps

	. += defib_overlay

//defib interaction
/obj/machinery/defibrillator_mount/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!defib)
		to_chat(user, span_warning("没有装载除颤器单元！"))
		return
	if(defib.paddles.loc != defib)
		to_chat(user, span_warning("[defib.paddles.loc == user ? "You are already" : "Someone else is"]拿着[defib]的电极板！"))
		return
	if(!in_range(src, user))
		to_chat(user, span_warning("[defib]的电极板过度伸展，从你手中脱出！"))
		return
	user.put_in_hands(defib.paddles)

/obj/machinery/defibrillator_mount/attackby(obj/item/item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(istype(item, /obj/item/defibrillator))
		if(defib)
			to_chat(user, span_warning("[src]上已经有了一个除颤器!"))
			return
		var/obj/item/defibrillator/new_defib = item
		if(!new_defib.get_cell())
			to_chat(user, span_warning("只有装了电池的除颤器可以被置入[src]!"))
			return
		if(HAS_TRAIT(new_defib, TRAIT_NODROP) || !user.transferItemToLoc(new_defib, src))
			to_chat(user, span_warning("[new_defib] 粘在你手上了！"))
			return
		user.visible_message(span_notice("[user] 将 [new_defib] 连接到 [src] 上！"), \
		span_notice("你将[new_defib]按入支架，它咔哒一声就位了。"))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		// Make sure the defib is set before processing begins.
		defib = new_defib
		begin_processing()
		update_appearance()
		return
	else if(defib && item == defib.paddles)
		defib.paddles.snap_back()
		return

	if(!item.GetID() || (!allowed(user) && SSsecurity_level.get_current_level_as_number() < SEC_LEVEL_RED)) //anyone can toggle the clamps in red alert!
		to_chat(user, span_warning("权限不足."))
		return
	if(!defib)
		to_chat(user, span_warning("您不能在没有除颤器的夹子上接合"))
		return
	clamps_locked = !clamps_locked
	to_chat(user, span_notice("夹钳[clamps_locked ? "" : "dis"]锁。"))
	update_appearance()

/obj/machinery/defibrillator_mount/multitool_act(mob/living/user, obj/item/multitool)
	..()
	if(!defib)
		to_chat(user, span_warning("上面没有除颤器可夹住."))
		return TRUE
	if(!clamps_locked)
		to_chat(user, span_warning("[src]的夹钳已松开！"))
		return TRUE
	user.visible_message(span_notice("[user] 将 [multitool] 插入 [src]的ID槽位中..."), \
	span_notice("你开始覆盖[src]上的夹具..."))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	if(!do_after(user, 10 SECONDS, target = src) || !clamps_locked)
		return
	user.visible_message(span_notice("[user][multitool]脉冲,[src]的夹具向上滑动."), \
	span_notice("你覆写了[src]上的锁定夹具!"))
	playsound(src, 'sound/machines/locktoggle.ogg', 50, TRUE)
	clamps_locked = FALSE
	update_appearance()
	return TRUE

/obj/machinery/defibrillator_mount/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(!wallframe_type)
		return ..()
	if(user.combat_mode)
		return ..()
	if(defib)
		to_chat(user, span_warning("当装载有除颤器单元时，支架无法分解！"))
		..()
		return TRUE
	new wallframe_type(get_turf(src))
	qdel(src)
	tool.play_tool_sound(user)
	to_chat(user, span_notice("你从墙上中拆除了[src]."))
	return TRUE

/obj/machinery/defibrillator_mount/click_alt(mob/living/carbon/user)
	if(!defib)
		to_chat(user, span_warning("很难从没有除颤装置的支架上取下除颤装置。"))
		return CLICK_ACTION_BLOCKING
	if(clamps_locked)
		to_chat(user, span_warning("你试图拉出[defib],但壁挂的夹具紧紧锁定着!"))
		return CLICK_ACTION_BLOCKING
	if(!user.put_in_hands(defib))
		to_chat(user, span_warning("你需要空出手来！"))
		user.visible_message(span_notice("[user]把[src]从[defib]上解开,使其掉落地上。"), \
		span_notice("你把[defib]从[src]上滑出并解除充电线缆,使其掉落地上."))
	else
		user.visible_message(span_notice("[user]把[src]从[defib]上解开."), \
		span_notice("你从 [src] 中滑出 [defib] 并解开充电线。"))
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	return CLICK_ACTION_SUCCESS

/obj/machinery/defibrillator_mount/charging
	name = "PENLITE除颤器墙挂"
	desc = "用来挂住除颤器。如果上面挂着一台除颤器，你可以取下电极板。这种PENLITE变型还允许为除颤器缓慢的被动充能。"
	icon_state = "penlite_mount"
	use_power = IDLE_POWER_USE
	wallframe_type = /obj/item/wallframe/defib_mount/charging


/obj/machinery/defibrillator_mount/charging/Initialize(mapload)
	. = ..()
	if(is_operational)
		begin_processing()


/obj/machinery/defibrillator_mount/charging/on_set_is_operational(old_value)
	if(old_value) //Turned off
		end_processing()
	else //Turned on
		begin_processing()


/obj/machinery/defibrillator_mount/charging/process(seconds_per_tick)
	if(isnull(defib))
		return
	var/obj/item/stock_parts/power_store/defib_cell = defib.get_cell()
	if(isnull(defib_cell)) // Something is very wrong if we hit this, so we should stack trace
		stack_trace("[src] was set to process with no cell inside its defib")
		return PROCESS_KILL
	if(defib_cell.charge < defib_cell.maxcharge)
		charge_cell(active_power_usage * seconds_per_tick, defib_cell)
		defib.update_power()

//wallframe, for attaching the mounts easily
/obj/item/wallframe/defib_mount
	name = "未挂除颤器墙挂"
	desc = "除颤器墙挂的框架 挂置后 可用扳手将其拆下"
	icon = 'icons/obj/machines/defib_mount.dmi'
	icon_state = "defibrillator_mount"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	w_class = WEIGHT_CLASS_BULKY
	result_path = /obj/machinery/defibrillator_mount
	pixel_shift = 28

/obj/item/wallframe/defib_mount/charging
	name = "未挂PENLITE除颤器墙挂"
	desc = "PENLITE除颤器墙挂的框架  与普通款不同 可以为塞入的除颤器被动充能"
	icon_state = "penlite_mount"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass = SMALL_MATERIAL_AMOUNT, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 0.5)
	result_path = /obj/machinery/defibrillator_mount/charging

//mobile defib

/obj/machinery/defibrillator_mount/mobile
	name = "移动式除颤器挂架"
	icon_state = "mobile"
	anchored = FALSE
	density = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5.15, /datum/material/silver = SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.5)

/obj/machinery/defibrillator_mount/mobile/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement)

/obj/machinery/defibrillator_mount/mobile/find_and_mount_on_atom(mark_for_late_init, late_init)
	return //its mobile

/obj/machinery/defibrillator_mount/mobile/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return ..()
	if(defib)
		to_chat(user, span_warning("当装载有除颤器单元时，支架无法分解！"))
		..()
		return TRUE
	balloon_alert(user, "正在解构...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 5 SECONDS))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, vary = TRUE)
		deconstruct()
	return TRUE

/obj/machinery/defibrillator_mount/mobile/on_deconstruction(disassembled)
	var/atom/drop = drop_location()
	if(disassembled)
		new /obj/item/stack/sheet/iron(drop, 5)
		new /obj/item/stack/sheet/mineral/silver(drop)
		new /obj/item/stack/cable_coil(drop, 15)
	else
		new /obj/item/stack/sheet/iron(drop, 5)

///For mapping
/obj/machinery/defibrillator_mount/mobile/immobile
	anchored = TRUE
	name = "defibrillator mount"
