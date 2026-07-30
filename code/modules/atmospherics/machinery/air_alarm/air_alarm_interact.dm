// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/obj/machinery/airalarm/crowbar_act(mob/living/user, obj/item/tool)
	if(buildstage != AIR_ALARM_BUILD_NO_WIRES)
		return
	user.visible_message(span_notice(LANG("obj.fe9f9988", list(user.name, name))), \
						span_notice(LANG("obj.330c1e13", null)))
	tool.play_tool_sound(src)
	if (tool.use_tool(src, user, 20))
		if (buildstage == AIR_ALARM_BUILD_NO_WIRES)
			to_chat(user, span_notice(LANG("obj.d9785d64", null)))
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
	to_chat(user, span_notice(LANG("obj.37462ae8", list(panel_open ? "exposed" : "unexposed"))))
	update_appearance()
	return TRUE

/obj/machinery/airalarm/wirecutter_act(mob/living/user, obj/item/tool)
	if(!(buildstage == AIR_ALARM_BUILD_COMPLETE && panel_open && wires.is_all_cut()))
		return
	tool.play_tool_sound(src)
	to_chat(user, span_notice(LANG("obj.29430b26", null)))
	var/obj/item/stack/cable_coil/cables = new(drop_location(), 5)
	user.put_in_hands(cables)
	buildstage = AIR_ALARM_BUILD_NO_WIRES
	update_appearance()
	return TRUE

/obj/machinery/airalarm/wrench_act(mob/living/user, obj/item/tool)
	if(buildstage != AIR_ALARM_BUILD_NO_CIRCUIT)
		return
	to_chat(user, span_notice(LANG("obj.5aa4bf16", list(src))))
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
		balloon_alert(user, LANG("obj.3bf49b8d", null))
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
		to_chat(user, span_warning(LANG("obj.499cb459", null)))
	else
		if(HAS_SILICON_ACCESS(user))
			locked = !locked
			return
		if(src.allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
			locked = !locked
			to_chat(user, span_notice(LANG("obj.5957d086", list(locked ? "lock" : "unlock"))))
			if(!locked)
				ui_interact(user)
		else
			to_chat(user, span_danger(LANG("obj.077f9b52", null)))

/obj/machinery/airalarm/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	visible_message(span_warning(LANG("obj.b7523a48", list(src))))
	balloon_alert(user, LANG("obj.fd657733", null))
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

/obj/machinery/airalarm/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	update_last_used(user)
	switch(buildstage)
		if(AIR_ALARM_BUILD_COMPLETE)
			if(tool.GetID())// trying to unlock the interface with an ID card
				togglelock(user)
				return ITEM_INTERACT_SUCCESS

			if(panel_open && is_wire_tool(tool))
				wires.interact(user)
				return ITEM_INTERACT_SUCCESS

			return NONE

		if(AIR_ALARM_BUILD_NO_WIRES)
			if(!istype(tool, /obj/item/stack/cable_coil))
				return NONE

			var/obj/item/stack/cable_coil/cable = tool
			if(cable.get_amount() < 5)
				to_chat(user, span_warning(LANG("obj.44b093d6", null)))
				return ITEM_INTERACT_BLOCKING

			user.visible_message(span_notice(LANG("obj.24088500", list(user.name))), \
								span_notice(LANG("obj.dcfa80c4", null)))
			if(!do_after(user, 2 SECONDS, target = src))
				return ITEM_INTERACT_BLOCKING

			if(cable.get_amount() < 5 || buildstage != AIR_ALARM_BUILD_NO_WIRES)
				return ITEM_INTERACT_BLOCKING

			cable.use(5)
			to_chat(user, span_notice(LANG("obj.038ce342", null)))
			wires.repair()
			aidisabled = FALSE
			locked = FALSE
			shorted = FALSE
			danger_level = AIR_ALARM_ALERT_NONE
			buildstage = AIR_ALARM_BUILD_COMPLETE
			select_mode(user, /datum/air_alarm_mode/filtering)
			update_appearance()
			return ITEM_INTERACT_SUCCESS

		if(AIR_ALARM_BUILD_NO_CIRCUIT)
			if(istype(tool, /obj/item/electronics/airalarm))
				if(!user.temporarilyRemoveItemFromInventory(tool))
					return ITEM_INTERACT_BLOCKING

				to_chat(user, span_notice(LANG("obj.a4c18684", null)))
				buildstage = AIR_ALARM_BUILD_NO_WIRES
				update_appearance()
				qdel(tool)
				return ITEM_INTERACT_SUCCESS

			if(istype(tool, /obj/item/electroadaptive_pseudocircuit))
				if(!astype(tool, /obj/item/electroadaptive_pseudocircuit).adapt_circuit(user, circuit_cost = 0.025 * STANDARD_CELL_CHARGE))
					return ITEM_INTERACT_BLOCKING

				user.visible_message(span_notice(LANG("obj.bdc98e79", list(user, src))), \
				span_notice(LANG("obj.1f2fc2a5", null)))
				buildstage = AIR_ALARM_BUILD_NO_WIRES
				update_appearance()
				return ITEM_INTERACT_SUCCESS

			return NONE

	return NONE

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
	name = "air alarm electronics"
	icon_state = "airalarm_electronics"

/obj/item/wallframe/airalarm
	name = "air alarm frame"
	desc = "Used for building Air Alarms."
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "alarm_bitem"
	result_path = /obj/machinery/airalarm
	pixel_shift = 27

/obj/item/wallframe/airalarm/try_build(atom/support, mob/user)
	var/area/A = get_area(user)
	if(A.always_unpowered)
		balloon_alert(user, LANG("obj.503cb4c5", null))
		return FALSE
	return ..()
