
/obj/machinery/airalarm/crowbar_act(mob/living/user, obj/item/tool)
	if(buildstage != AIR_ALARM_BUILD_NO_WIRES)
		return
	user.visible_message(span_notice("[user.name] 从 [name] 中取出了电子元件。"), \
						span_notice("你开始撬出电路板..."))
	tool.play_tool_sound(src)
	if (tool.use_tool(src, user, 20))
		if (buildstage == AIR_ALARM_BUILD_NO_WIRES)
			to_chat(user, span_notice("你取出了空气警报器的电子元件。"))
			new /obj/item/electronics/airalarm(drop_location())
			playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
			buildstage = AIR_ALARM_BUILD_NO_CIRCUIT
			update_appearance()
	return TRUE

/obj/machinery/airalarm/screwdriver_act(mob/living/user, obj/item/tool)
	if(buildstage != AIR_ALARM_BUILD_COMPLETE)
		return
	tool.play_tool_sound(src)
	toggle_panel_open()
	to_chat(user, span_notice("电线已被[panel_open ? "exposed" : "unexposed"]。"))
	update_appearance()
	return TRUE

/obj/machinery/airalarm/wirecutter_act(mob/living/user, obj/item/tool)
	if(!(buildstage == AIR_ALARM_BUILD_COMPLETE && panel_open && wires.is_all_cut()))
		return
	tool.play_tool_sound(src)
	to_chat(user, span_notice("你剪断了最后的电线。"))
	var/obj/item/stack/cable_coil/cables = new(drop_location(), 5)
	user.put_in_hands(cables)
	buildstage = AIR_ALARM_BUILD_NO_WIRES
	update_appearance()
	return TRUE

/obj/machinery/airalarm/wrench_act(mob/living/user, obj/item/tool)
	if(buildstage != AIR_ALARM_BUILD_NO_CIRCUIT)
		return
	to_chat(user, span_notice("You detach \the [src] from the wall."))
	tool.play_tool_sound(src)
	var/obj/item/wallframe/airalarm/alarm_frame = new(drop_location())
	user.put_in_hands(alarm_frame)
	qdel(src)
	return TRUE


/obj/machinery/airalarm/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if((buildstage == AIR_ALARM_BUILD_NO_CIRCUIT) && (the_rcd.construction_upgrades & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return list("delay" = 2 SECONDS, "cost" = 1)
	return FALSE

/obj/machinery/airalarm/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	if(rcd_data[RCD_DESIGN_MODE] == RCD_WALLFRAME)
		balloon_alert(user, "电路已安装")
		buildstage = AIR_ALARM_BUILD_NO_WIRES
		update_appearance()
		return TRUE
	return FALSE

/obj/machinery/airalarm/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(!can_interact(user))
		return
	if(!user.can_perform_action(src, ALLOW_SILICON_REACH) || !isturf(loc))
		return
	togglelock(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/airalarm/proc/togglelock(mob/living/user)
	if(machine_stat & (NOPOWER|BROKEN))
		to_chat(user, span_warning("它毫无反应！"))
	else
		if(HAS_SILICON_ACCESS(user))
			locked = !locked
			return
		if(src.allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
			locked = !locked
			to_chat(user, span_notice("你[ locked ? "lock" : "unlock"]了空气警报界面。"))
			if(!locked)
				ui_interact(user)
		else
			to_chat(user, span_danger("访问被拒绝。"))

/obj/machinery/airalarm/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	visible_message(span_warning("火花从[src]中迸出！"))
	balloon_alert(user, "身份验证传感器已扰乱")
	playsound(src, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return TRUE

/obj/machinery/airalarm/on_deconstruction(disassembled = TRUE)
	new /obj/item/stack/sheet/iron(loc, 2)
	if((buildstage == AIR_ALARM_BUILD_NO_WIRES) || (buildstage == AIR_ALARM_BUILD_COMPLETE))
		var/obj/item/electronics/airalarm/alarm = new(loc)
		if(!disassembled)
			alarm.take_damage(alarm.max_integrity * 0.5, sound_effect = FALSE)
	if((buildstage == AIR_ALARM_BUILD_COMPLETE))
		new /obj/item/stack/cable_coil(loc, 3)

/obj/machinery/airalarm/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	update_last_used(user)
	switch(buildstage)
		if(AIR_ALARM_BUILD_COMPLETE)
			if(W.GetID())// trying to unlock the interface with an ID card
				togglelock(user)
				return
			else if(panel_open && is_wire_tool(W))
				wires.interact(user)
				return
		if(AIR_ALARM_BUILD_NO_WIRES)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/cable = W
				if(cable.get_amount() < 5)
					to_chat(user, span_warning("你需要五段电缆来连接空气警报器！"))
					return
				user.visible_message(span_notice("[user.name] 正在给空气警报器接线。"), \
									span_notice("你开始给空气警报器接线..."))
				if (do_after(user, 2 SECONDS, target = src))
					if (cable.get_amount() >= 5 && buildstage == AIR_ALARM_BUILD_NO_WIRES)
						cable.use(5)
						to_chat(user, span_notice("你给空气警报器接好了线。"))
						wires.repair()
						aidisabled = FALSE
						locked = FALSE
						shorted = FALSE
						danger_level = AIR_ALARM_ALERT_NONE
						buildstage = AIR_ALARM_BUILD_COMPLETE
						select_mode(user, /datum/air_alarm_mode/filtering)
						update_appearance()
				return
		if(AIR_ALARM_BUILD_NO_CIRCUIT)
			if(istype(W, /obj/item/electronics/airalarm))
				if(user.temporarilyRemoveItemFromInventory(W))
					to_chat(user, span_notice("你插入了电路板。"))
					buildstage = AIR_ALARM_BUILD_NO_WIRES
					update_appearance()
					qdel(W)
				return

			if(istype(W, /obj/item/electroadaptive_pseudocircuit))
				var/obj/item/electroadaptive_pseudocircuit/P = W
				if(!P.adapt_circuit(user, circuit_cost = 0.025 * STANDARD_CELL_CHARGE))
					return
				user.visible_message(span_notice("[user] 制作了一块电路板并放入 [src]。"), \
				span_notice("你改装了一块空气警报器电路板并将其插入组件中。"))
				buildstage = AIR_ALARM_BUILD_NO_WIRES
				update_appearance()
				return

	return ..()

/obj/machinery/airalarm/proc/reset(wire)
	switch(wire)
		if(WIRE_POWER)
			if(!wires.is_cut(WIRE_POWER))
				shorted = FALSE
				update_appearance()
		if(WIRE_AI)
			if(!wires.is_cut(WIRE_AI))
				aidisabled = FALSE

/obj/machinery/airalarm/shock(mob/living/shocking, chance, shock_source, siemens_coeff)
	if(machine_stat & NOPOWER) // unpowered, no shock
		return FALSE
	return ..()

/obj/item/electronics/airalarm
	name = "空气警报器电子元件"
	icon_state = "airalarm_electronics"

/obj/item/wallframe/airalarm
	name = "air alarm frame"
	desc = "用于建造空气警报器。"
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "alarm_bitem"
	result_path = /obj/machinery/airalarm
	pixel_shift = 27

/obj/item/wallframe/airalarm/try_build(atom/support, mob/user)
	var/area/A = get_area(user)
	if(A.always_unpowered)
		balloon_alert(user, "无法放置在此区域！")
		return FALSE
	return ..()
