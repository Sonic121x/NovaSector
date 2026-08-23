// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
//attack with an item - open/close cover, insert cell, or (un)lock interface

/obj/machinery/power/apc/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = NONE
	if(HAS_TRAIT(tool, TRAIT_APC_SHOCKING))
		. = fork_outlet_act(user, tool)
		if(.)
			return .

	if(tool.GetID())
		togglelock(user)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stock_parts/power_store))
		. = cell_act(user, tool)
	else if(istype(tool, /obj/item/stack/cable_coil))
		. = cable_act(user, tool, LAZYACCESS(modifiers, RIGHT_CLICK))
	else if(istype(tool, /obj/item/electronics/apc))
		. = electronics_act(user, tool)
	else if(istype(tool, /obj/item/electroadaptive_pseudocircuit))
		. = pseudocircuit_act(user, tool)
	else if(istype(tool, /obj/item/wallframe/apc))
		. = wallframe_act(user, tool)
	if(.)
		return .

	if(panel_open && !opened && is_wire_tool(tool))
		wires.interact(user)
		return ITEM_INTERACT_SUCCESS

	return .

/// Called when we interact with the APC with an item with which we can get shocked when we stuff it into an APC
/obj/machinery/power/apc/proc/fork_outlet_act(mob/living/user, obj/item/tool)
	var/metal = 0
	var/shock_source = null
	metal += LAZYACCESS(tool.custom_materials, SSmaterials.get_material(/datum/material/iron))//This prevents wooden rolling pins from shocking the user

	if(cell || terminal) //The mob gets shocked by whichever powersource has the most electricity
		if(cell && terminal)
			shock_source = cell.charge > terminal.powernet.avail ? cell : terminal.powernet
		else
			shock_source = terminal?.powernet || cell

	if(shock_source && metal && (panel_open || opened)) //Now you're cooking with electricity
		if(!electrocute_mob(user, shock_source, src, siemens_coeff = 1, dist_check = TRUE))//People with insulated gloves just attack the APC normally. They're just short of magical anyway
			return NONE
		do_sparks(5, TRUE, src)
		user.visible_message(span_notice(LANG("obj.af35b8b45b27728c", list(user.name, tool, src))))
		if(shock_source == cell)//If the shock is coming from the cell just fully discharge it, because it's funny
			cell.use(cell.charge)
		return ITEM_INTERACT_SUCCESS

/// Called when we interact with the APC with a cell, attempts to insert it
/obj/machinery/power/apc/proc/cell_act(mob/living/user, obj/item/stock_parts/power_store/new_cell)
	if(!opened)
		return NONE

	if(cell)
		balloon_alert(user, LANG("obj.d2ad27b2fb0eb6cd", null))
		return ITEM_INTERACT_BLOCKING
	if(machine_stat & MAINT)
		balloon_alert(user, LANG("obj.6816f95a0a0366a8", null))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(new_cell, src))
		return ITEM_INTERACT_BLOCKING
	cell = new_cell
	user.visible_message(span_notice(LANG("obj.579519a7929557f4", list(user.name, src.name))))
	balloon_alert(user, LANG("obj.9dcbef06e4056599", null))
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/// Checks if we can place a terminal on the APC
/obj/machinery/power/apc/proc/can_place_terminal(mob/living/user, obj/item/stack/cable_coil/installing_cable, silent = TRUE)
	if(!opened)
		return FALSE
	var/turf/host_turf = get_turf(src)
	if(host_turf.underfloor_accessibility < UNDERFLOOR_INTERACTABLE)
		if(!silent && user)
			balloon_alert(user, LANG("obj.0d1f39e91e5c3d13", null))
		return FALSE
	if(!isnull(terminal))
		if(!silent && user)
			balloon_alert(user, LANG("obj.9a6e26bd7aeebe89", null))
		return FALSE
	if(!has_electronics)
		if(!silent && user)
			balloon_alert(user, LANG("obj.407f6b742b10b2b3", null))
		return FALSE
	if(panel_open)
		if(!silent && user)
			balloon_alert(user, LANG("obj.b79d108a1232b284", null))
		return FALSE
	if(installing_cable.get_amount() < 10)
		if(!silent && user)
			balloon_alert(user, LANG("obj.60843c8e396801fc", null))
		return FALSE
	return TRUE

/// Called when we interact with the APC with a cable, attempts to wire the APC and create a terminal
/obj/machinery/power/apc/proc/cable_act(mob/living/user, obj/item/stack/cable_coil/installing_cable, is_right_clicking)
	if(!opened)
		return NONE
	if(!can_place_terminal(user, installing_cable, silent = FALSE))
		return ITEM_INTERACT_BLOCKING

	var/terminal_cable_layer = cable_layer // Default to machine's cable layer
	if(is_right_clicking)
		var/choice = tgui_input_list(user, LANG("obj.4ece58d613775621", null), LANG("obj.3925bd2623a78950", null), GLOB.cable_name_to_layer)
		if(isnull(choice) \
			|| !user.is_holding(installing_cable) \
			|| !user.Adjacent(src) \
			|| user.incapacitated \
			|| !can_place_terminal(user, installing_cable, silent = TRUE) \
		)
			return ITEM_INTERACT_BLOCKING
		terminal_cable_layer = GLOB.cable_name_to_layer[choice]

	user.visible_message(span_notice(LANG("obj.c7315fb94c48c763", list(user.name))))
	balloon_alert(user, LANG("obj.a59792f9eab1ed31", null))
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)

	if(!do_after(user, 2 SECONDS, target = src))
		return ITEM_INTERACT_BLOCKING
	if(!can_place_terminal(user, installing_cable, silent = TRUE))
		return ITEM_INTERACT_BLOCKING
	var/turf/our_turf = get_turf(src)
	var/obj/structure/cable/cable_node = our_turf.get_cable_node(terminal_cable_layer)
	if(prob(50) && electrocute_mob(usr, cable_node, cable_node, 1, TRUE))
		do_sparks(5, TRUE, src)
		return ITEM_INTERACT_BLOCKING
	installing_cable.use(10)
	user.visible_message(span_notice(LANG("obj.4316c660f45b4c77", list(user.name))))
	balloon_alert(user, LANG("obj.e501673bff119620", null))
	make_terminal(terminal_cable_layer)
	terminal.connect_to_network()
	return ITEM_INTERACT_SUCCESS

/// Called when we interact with the APC with APC electronics, attempts to install the board
/obj/machinery/power/apc/proc/electronics_act(mob/living/user, obj/item/electronics/apc/installing_board)
	if(!opened)
		return NONE

	if(has_electronics)
		balloon_alert(user, LANG("obj.4d9035707e5fd18b", null))
		return ITEM_INTERACT_BLOCKING

	if(machine_stat & BROKEN)
		balloon_alert(user, LANG("obj.c9c907fd134423f4", null))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice(LANG("obj.a3ba49378319196a", list(user.name, src))))
	balloon_alert(user, LANG("obj.f9ee154df06bd6db", null))
	playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)

	if(!do_after(user, 1 SECONDS, target = src) || has_electronics)
		return ITEM_INTERACT_BLOCKING

	has_electronics = APC_ELECTRONICS_INSTALLED
	locked = FALSE
	balloon_alert(user, LANG("obj.c7e431bd4f4be511", null))
	qdel(installing_board)
	return ITEM_INTERACT_SUCCESS

/// Called when we interact with the APC with an electroadaptive pseudocircuit, used by cyborgs to install a board or weak cell
/obj/machinery/power/apc/proc/pseudocircuit_act(mob/living/user, obj/item/electroadaptive_pseudocircuit/pseudocircuit)
	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, LANG("obj.10a69676d19a14fe", null))
			return ITEM_INTERACT_BLOCKING
		if(!pseudocircuit.adapt_circuit(user, circuit_cost = 0.05 * STANDARD_CELL_CHARGE))
			return ITEM_INTERACT_BLOCKING
		user.visible_message(
			span_notice(LANG("obj.bdc98e79de4f6d08", list(user, src))),
			span_notice(LANG("obj.77df737f83111d6e", list(src))),
		)
		has_electronics = APC_ELECTRONICS_INSTALLED
		locked = FALSE
		return ITEM_INTERACT_SUCCESS

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, LANG("obj.12c380ab46864a97", null))
			return ITEM_INTERACT_BLOCKING
		if(!pseudocircuit.adapt_circuit(user, circuit_cost = 0.5 * STANDARD_CELL_CHARGE))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/stock_parts/power_store/battery/crap/empty/bad_cell = new(src)
		bad_cell.forceMove(src)
		cell = bad_cell
		user.visible_message(
			span_notice(LANG("obj.1ece14d738d7fd29", list(user, src))),
			span_warning(LANG("obj.76eec66296844f81", list(pseudocircuit.name, src))),
		)
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	balloon_alert(user, LANG("obj.45fbfeb5546bade0", null))
	return ITEM_INTERACT_BLOCKING

/// Called when we interact with the APC with and APC frame, used for replacing a damaged cover/frame
/obj/machinery/power/apc/proc/wallframe_act(mob/living/user, obj/item/wallframe/apc/wallframe)
	if(!opened)
		return NONE

	if(!(machine_stat & BROKEN || opened == APC_COVER_REMOVED || atom_integrity < max_integrity)) // There is nothing to repair
		balloon_alert(user, LANG("obj.0116725fc2593218", null))
		return ITEM_INTERACT_BLOCKING
	if((machine_stat & BROKEN) && opened == APC_COVER_REMOVED && has_electronics && terminal) // Cover is the only thing broken, we do not need to remove elctronicks to replace cover
		user.visible_message(span_notice(LANG("obj.4df99cf8f28232d3", list(user.name))))
		balloon_alert(user, LANG("obj.aac509799af72fd2", null))
		if(!do_after(user, 2 SECONDS, target = src)) // replacing cover is quicker than replacing whole frame
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, LANG("obj.832af6635c70a869", null))
		qdel(wallframe)
		update_integrity(30) //needs to be welded to fully repair but can work without
		set_machine_stat(machine_stat & ~(BROKEN|MAINT))
		opened = APC_COVER_OPENED
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	if(has_electronics)
		balloon_alert(user, LANG("obj.56319525b1463a1f", null))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_notice(LANG("obj.a693882ff9c5b8c4", list(user.name))))
	balloon_alert(user, LANG("obj.ffc63280f8da913e", null))
	if(!do_after(user, 5 SECONDS, target = src))
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, LANG("obj.42c40a50c483063c", null))
	qdel(wallframe)
	set_machine_stat(machine_stat & ~BROKEN)
	atom_integrity = max_integrity
	if(opened == APC_COVER_REMOVED)
		opened = APC_COVER_OPENED
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/apc/crowbar_act(mob/user, obj/item/crowbar)
	. = TRUE

	//Prying off broken cover
	if((opened == APC_COVER_CLOSED || opened == APC_COVER_OPENED) && (machine_stat & BROKEN))
		crowbar.play_tool_sound(src)
		balloon_alert(user, LANG("obj.1c42ba097851f484", null))
		if(!crowbar.use_tool(src, user, 5 SECONDS))
			return
		opened = APC_COVER_REMOVED
		balloon_alert(user, LANG("obj.3fa5ffcf502e1c23", null))
		update_appearance()
		return

	//Opening and closing cover
	if((!opened && opened != APC_COVER_REMOVED) && !(machine_stat & BROKEN))
		if(coverlocked && !(machine_stat & MAINT)) // locked...
			balloon_alert(user, LANG("obj.6446542712364e40", null))
			return
		else if(panel_open)
			balloon_alert(user, LANG("obj.7a9a3fb0999b493a", null))
			return
		else
			opened = APC_COVER_OPENED
			update_appearance()
			return

	if((opened && has_electronics == APC_ELECTRONICS_SECURED) && !(machine_stat & BROKEN))
		opened = APC_COVER_CLOSED
		coverlocked = TRUE //closing cover relocks it
		balloon_alert(user, LANG("obj.fd4ae50647af52d6", null))
		update_appearance()
		return

	//Taking out the electronics
	if(!opened || has_electronics != APC_ELECTRONICS_INSTALLED)
		return
	if(terminal)
		balloon_alert(user, LANG("obj.6a718aca6744acda", null))
		return
	crowbar.play_tool_sound(src)
	if(!crowbar.use_tool(src, user, 50))
		return
	if(has_electronics != APC_ELECTRONICS_INSTALLED)
		return
	has_electronics = APC_ELECTRONICS_MISSING
	if(machine_stat & BROKEN)
		user.visible_message(span_notice(LANG("obj.01bda195bab6a38e", list(user.name, name))), \
			span_hear(LANG("obj.b765f6e12ee777cd", null)))
		balloon_alert(user, LANG("obj.93b82b02609da2cf", null))
		return
	else if(obj_flags & EMAGGED)
		obj_flags &= ~EMAGGED
		user.visible_message(span_notice(LANG("obj.1a807a7777da8331", list(user.name, name))))
		balloon_alert(user, LANG("obj.82e0629bac42c153", null))
		return
	else if(malfhack)
		user.visible_message(span_notice(LANG("obj.40df041ed1c17f31", list(user.name, name))))
		balloon_alert(user, LANG("obj.75d73b942c098c7a", null))
		malfai = null
		malfhack = 0
		return
	user.visible_message(span_notice(LANG("obj.3abfa99d59e025b4", list(user.name, name))))
	balloon_alert(user, LANG("obj.6e38fb3f83f72ee7", null))
	new /obj/item/electronics/apc(loc)
	return

/obj/machinery/power/apc/screwdriver_act(mob/living/user, obj/item/W)
	if(..())
		return TRUE
	. = TRUE

	if(!opened)
		if(obj_flags & EMAGGED)
			balloon_alert(user, LANG("obj.8aa6037ff9eaa6b9", null))
			return
		toggle_panel_open()
		balloon_alert(user, LANG("obj.ac8966cf0cdb5091", list(panel_open ? "exposed" : "unexposed")))
		W.play_tool_sound(src)
		update_appearance()
		return

	if(cell)
		user.visible_message(span_notice(LANG("obj.ea367116b2948c11", list(user, cell, src))))
		balloon_alert(user, LANG("obj.0dfdca6e675f39e2", null))
		var/turf/user_turf = get_turf(user)
		cell.forceMove(user_turf)
		cell = null
		charging = APC_NOT_CHARGING
		update_appearance()
		return

	switch (has_electronics)
		if(APC_ELECTRONICS_INSTALLED)
			has_electronics = APC_ELECTRONICS_SECURED
			set_machine_stat(machine_stat & ~MAINT)
			W.play_tool_sound(src)
			balloon_alert(user, LANG("obj.e041e2cfadb71bcb", null))
		if(APC_ELECTRONICS_SECURED)
			has_electronics = APC_ELECTRONICS_INSTALLED
			set_machine_stat(machine_stat | MAINT)
			W.play_tool_sound(src)
			balloon_alert(user, LANG("obj.6744f6f3d1832e3e", null))
		else
			balloon_alert(user, LANG("obj.97b3363ec47e40f1", null))
			return
	update_appearance()

/obj/machinery/power/apc/wirecutter_act(mob/living/user, obj/item/W)
	. = ..()
	if(terminal && opened)
		terminal.dismantle(user, W)
		return TRUE

/obj/machinery/power/apc/welder_act(mob/living/user, obj/item/welder)
	. = ..()

	//repairing the cover
	if((atom_integrity < max_integrity) && has_electronics)
		if(opened == APC_COVER_REMOVED)
			balloon_alert(user, LANG("obj.c39fc94901779004", null))
			return
		if (machine_stat & BROKEN)
			balloon_alert(user, LANG("obj.6a314f11fac591f6", null))
			return
		if(!welder.tool_start_check(user, amount=1))
			return
		balloon_alert(user, LANG("obj.b52342a8e93a2ba2", null))
		if(welder.use_tool(src, user, 4 SECONDS, volume = 50))
			update_integrity(min(atom_integrity += 50,max_integrity))
			balloon_alert(user, LANG("obj.65ced1e8b5b56733", null))
		return ITEM_INTERACT_SUCCESS

	//disassembling the frame
	if(!opened || has_electronics || terminal)
		return
	if(!welder.tool_start_check(user, amount=1))
		return
	user.visible_message(span_notice(LANG("obj.99cc3d1a4ecdc91a", list(user.name, src))), \
						span_hear(LANG("obj.1aa82fa3545466eb", null)))
	balloon_alert(user, LANG("obj.7e2a00fe9595980c", null))
	if(!welder.use_tool(src, user, 50, volume=50))
		return
	if((machine_stat & BROKEN) || opened == APC_COVER_REMOVED)
		new /obj/item/stack/sheet/iron(loc)
		user.visible_message(span_notice(LANG("obj.ab2bd59f2595f206", list(user.name, src, welder))))
		user.balloon_alert(user, LANG("obj.766b2d3cbd260d32", null))
	else
		new /obj/item/wallframe/apc(loc)
		user.visible_message(span_notice(LANG("obj.7cafae7f085021d5", list(user.name, src, welder))))
		user.balloon_alert(user, LANG("obj.7dd741fd53ece918", null))
	qdel(src)
	return TRUE

/obj/machinery/power/apc/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!(the_rcd.construction_upgrades & RCD_UPGRADE_SIMPLE_CIRCUITS))
		return FALSE

	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, LANG("obj.10a69676d19a14fe", null))
			return FALSE
		return list("delay" = 2 SECONDS, "cost" = 1)

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, LANG("obj.12c380ab46864a97", null))
			return FALSE
		return list("delay" = 5 SECONDS, "cost" = 10)

	balloon_alert(user, LANG("obj.45fbfeb5546bade0", null))
	return FALSE

/obj/machinery/power/apc/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	if(!(the_rcd.construction_upgrades & RCD_UPGRADE_SIMPLE_CIRCUITS) || rcd_data[RCD_DESIGN_MODE] != RCD_WALLFRAME)
		return FALSE

	if(!has_electronics)
		if(machine_stat & BROKEN)
			balloon_alert(user, LANG("obj.10a69676d19a14fe", null))
			return
		balloon_alert(user, LANG("obj.6e4e1b36477cf55c", null))
		has_electronics = TRUE
		locked = TRUE
		return TRUE

	if(!cell)
		if(machine_stat & MAINT)
			balloon_alert(user, LANG("obj.12c380ab46864a97", null))
			return FALSE
		var/obj/item/stock_parts/power_store/battery/crap/empty/C = new(src)
		C.forceMove(src)
		cell = C
		balloon_alert(user, LANG("obj.641179914ee919b9", null))
		update_appearance()
		return TRUE

	balloon_alert(user, LANG("obj.45fbfeb5546bade0", null))
	return FALSE

/obj/machinery/power/apc/emag_act(mob/user, obj/item/card/emag/emag_card)
	if((obj_flags & EMAGGED) || malfhack)
		return FALSE

	if(opened)
		balloon_alert(user, LANG("obj.98113f143e45b6e8", null))
		return FALSE
	else if(panel_open)
		balloon_alert(user, LANG("obj.feaafe3679c78ec3", null))
		return FALSE
	else if(machine_stat & (BROKEN|MAINT))
		balloon_alert(user, LANG("obj.bccffc95efe66ad7", null))
		return FALSE
	else
		flick("apc-spark", src)
		playsound(src, SFX_SPARKS, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		obj_flags |= EMAGGED
		locked = FALSE
		balloon_alert(user, LANG("obj.6e34adce99fd53d1", null))
		update_appearance()
		flicker_hacked_icon()
		return TRUE

// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		if(cell)
			cell.emp_act(severity)
		if(occupier)
			occupier.emp_act(severity)
	if(. & EMP_PROTECT_SELF)
		return
	lighting = APC_CHANNEL_OFF
	equipment = APC_CHANNEL_OFF
	environ = APC_CHANNEL_OFF
	update_appearance()
	update()
	addtimer(CALLBACK(src, PROC_REF(reset), APC_RESET_EMP), 60 SECONDS)

/obj/machinery/power/apc/proc/togglelock(mob/living/user)
	if(obj_flags & EMAGGED)
		balloon_alert(user, LANG("obj.8aa6037ff9eaa6b9", null))
	else if(opened)
		balloon_alert(user, LANG("obj.98113f143e45b6e8", null))
	else if(panel_open)
		balloon_alert(user, LANG("obj.feaafe3679c78ec3", null))
	else if(machine_stat & (BROKEN|MAINT))
		balloon_alert(user, LANG("obj.bccffc95efe66ad7", null))
	else
		if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN) && ((!malfhack && !remote_control_user) || (malfhack && (malfai == user || (user in malfai.connected_robots)))))
			locked = !locked
			balloon_alert(user, locked ? "locked" : "unlocked")
			update_appearance()
		else
			balloon_alert(user, LANG("obj.1bd3ceeb3a56d0d5", null))
