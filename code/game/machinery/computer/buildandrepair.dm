// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/frame/computer
	name = "computer frame"
	desc = "A frame for constructing your own computer. Or console. Whichever name you prefer."
	icon_state = "0"
	base_icon_state = ""
	state = FRAME_COMPUTER_STATE_EMPTY
	board_type = /obj/item/circuitboard/computer

/obj/structure/frame/computer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/simple_rotation)
	register_context()

/obj/structure/frame/computer/atom_deconstruct(disassembled = TRUE)
	var/atom/drop_loc = drop_location()
	if(state == FRAME_COMPUTER_STATE_GLASSED)
		if(disassembled)
			new /obj/item/stack/sheet/glass(drop_loc, 2)
		else
			new /obj/item/shard(drop_loc)
			new /obj/item/shard(drop_loc)
	if(state >= FRAME_COMPUTER_STATE_WIRED)
		new /obj/item/stack/cable_coil(drop_loc, 5)
	return ..()

/obj/structure/frame/computer/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	switch(state)
		if(FRAME_COMPUTER_STATE_EMPTY)
			if(held_item.tool_behaviour == TOOL_WRENCH)
				context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Unan" : "An"]chor"
				return CONTEXTUAL_SCREENTIP_SET
			else if(anchored && istype(held_item, /obj/item/circuitboard/computer))
				context[SCREENTIP_CONTEXT_LMB] = "Install board"
				return CONTEXTUAL_SCREENTIP_SET
			else if(held_item.tool_behaviour == TOOL_WELDER)
				context[SCREENTIP_CONTEXT_LMB] = "Unweld frame"
				return CONTEXTUAL_SCREENTIP_SET
			else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
				context[SCREENTIP_CONTEXT_LMB] = "Disassemble frame"
				return CONTEXTUAL_SCREENTIP_SET
		if(FRAME_COMPUTER_STATE_BOARD_INSTALLED)
			if(held_item.tool_behaviour == TOOL_CROWBAR)
				context[SCREENTIP_CONTEXT_LMB] = "Pry out board"
				return CONTEXTUAL_SCREENTIP_SET
			else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
				context[SCREENTIP_CONTEXT_LMB] = "Secure board"
				return CONTEXTUAL_SCREENTIP_SET
		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
				context[SCREENTIP_CONTEXT_LMB] = "Unsecure board"
				return CONTEXTUAL_SCREENTIP_SET
			else if(istype(held_item, /obj/item/stack/cable_coil))
				context[SCREENTIP_CONTEXT_LMB] = "Install cable"
				return CONTEXTUAL_SCREENTIP_SET
		if(FRAME_COMPUTER_STATE_WIRED)
			if(held_item.tool_behaviour == TOOL_WIRECUTTER)
				context[SCREENTIP_CONTEXT_LMB] = "Cut out cable"
				return CONTEXTUAL_SCREENTIP_SET
			else if(istype(held_item, /obj/item/stack/sheet/glass))
				context[SCREENTIP_CONTEXT_LMB] = "Install panel"
				return CONTEXTUAL_SCREENTIP_SET
		if(FRAME_COMPUTER_STATE_GLASSED)
			if(held_item.tool_behaviour == TOOL_CROWBAR)
				context[SCREENTIP_CONTEXT_LMB] = "Pry out glass"
				return CONTEXTUAL_SCREENTIP_SET
			else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
				context[SCREENTIP_CONTEXT_LMB] = "Complete frame"
				return CONTEXTUAL_SCREENTIP_SET

/obj/structure/frame/computer/examine(user)
	. = ..()

	switch(state)
		if(FRAME_STATE_EMPTY)
			. += span_notice(LANG("obj.9315b531ec200166", list(EXAMINE_HINT("anchored"), anchored ? "loose." : "into place.")))
			if(anchored)
				. += span_warning(LANG("obj.5cbee47b6e751023", null))
			else
				. += span_notice(LANG("obj.a8e6c385fc246784", list(EXAMINE_HINT("welded"), EXAMINE_HINT("screwed"))))
		if(FRAME_COMPUTER_STATE_BOARD_INSTALLED)
			. += span_notice(LANG("obj.9acc7fc47feae2dd", list(EXAMINE_HINT("pried"))))
			. += span_info(LANG("obj.56a31c251465ab12", list(EXAMINE_HINT("screwed"))))
		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			. += span_notice(LANG("obj.6f63985c25225cc3", list(EXAMINE_HINT("screwed"))))
			. += span_info(LANG("obj.1e6756696ebdbde2", list(EXAMINE_HINT("wired"))))
		if(FRAME_COMPUTER_STATE_WIRED)
			. += span_notice(LANG("obj.fccc9815126be362", list(EXAMINE_HINT("cut"))))
			. += span_info(LANG("obj.18ea9037fe60ba4d", list(EXAMINE_HINT("fitted"))))
		if(FRAME_COMPUTER_STATE_GLASSED)
			. += span_notice(LANG("obj.907c3a0f678eaa53", list(EXAMINE_HINT("pried"))))
			. += span_info(LANG("obj.810e24e0f6206b74", list(EXAMINE_HINT("screwed"))))

/obj/structure/frame/computer/circuit_added(obj/item/circuitboard/added)
	state = FRAME_COMPUTER_STATE_BOARD_INSTALLED
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/frame/computer/circuit_removed(obj/item/circuitboard/removed)
	state = FRAME_COMPUTER_STATE_EMPTY
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/frame/computer/install_board(mob/living/user, obj/item/circuitboard/computer/board, by_hand)
	if(state != FRAME_COMPUTER_STATE_EMPTY)
		balloon_alert(user, LANG("obj.67103b9eaad4c44d", null))
		return FALSE
	. = ..()
	if(. && !by_hand) // Installing via RPED auto-secures it
		state = FRAME_COMPUTER_STATE_BOARD_SECURED
		update_appearance(UPDATE_ICON_STATE)
	return .

/obj/structure/frame/computer/install_parts_from_part_replacer(mob/living/user, obj/item/storage/part_replacer/replacer, no_sound = FALSE)
	switch(state)
		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			var/obj/item/stack/cable_coil/cable = locate() in replacer
			if(isnull(cable))
				return FALSE

			if(add_cabling(user, cable, time = 0))
				if(!no_sound)
					replacer.play_rped_effect()
					no_sound = TRUE
				return install_parts_from_part_replacer(user, replacer, no_sound = no_sound)  // Recursive call to handle the next part

			return FALSE

		if(FRAME_COMPUTER_STATE_WIRED)
			var/obj/item/stack/sheet/glass/glass_sheets = locate() in replacer
			if(isnull(glass_sheets))
				return FALSE

			if(add_glass(user, glass_sheets, time = 0))
				if(!no_sound)
					replacer.play_rped_effect()
				return TRUE

			return FALSE

/obj/structure/frame/computer/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .

	switch(state)
		if(FRAME_COMPUTER_STATE_EMPTY)
			if(istype(tool, /obj/item/storage/part_replacer))
				return install_circuit_from_part_replacer(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			if(istype(tool, /obj/item/stack/cable_coil))
				return add_cabling(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

			if(istype(tool, /obj/item/storage/part_replacer))
				return install_parts_from_part_replacer(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_WIRED)
			if(istype(tool, /obj/item/stack/sheet/glass))
				return add_glass(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

			if(istype(tool, /obj/item/storage/part_replacer))
				return install_parts_from_part_replacer(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

/obj/structure/frame/computer/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .

	switch(state)
		if(FRAME_COMPUTER_STATE_BOARD_INSTALLED)
			tool.play_tool_sound(src)
			balloon_alert(user, LANG("obj.c5ab0826d6e51be3", null))
			state = FRAME_COMPUTER_STATE_BOARD_SECURED
			update_appearance(UPDATE_ICON_STATE)
			return ITEM_INTERACT_SUCCESS

		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			tool.play_tool_sound(src)
			balloon_alert(user, LANG("obj.d67779af2365bbee", null))
			state = FRAME_COMPUTER_STATE_BOARD_INSTALLED
			update_appearance(UPDATE_ICON_STATE)
			return ITEM_INTERACT_SUCCESS

		if(FRAME_COMPUTER_STATE_WIRED)
			if(!user.combat_mode)
				balloon_alert(user, LANG("obj.57cb305df6dfa9d6", null))
				return ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_GLASSED)
			if(finalize_construction(user, tool))
				return ITEM_INTERACT_SUCCESS
			return ITEM_INTERACT_BLOCKING

/obj/structure/frame/computer/crowbar_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE

	switch(state)
		if(FRAME_COMPUTER_STATE_BOARD_INSTALLED)
			tool.play_tool_sound(src)
			balloon_alert(user, LANG("obj.6bf68b4883ef1d50", null))
			circuit.add_fingerprint(user)
			circuit.forceMove(drop_location())
			return ITEM_INTERACT_SUCCESS

		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			balloon_alert(user, LANG("obj.cbb665f74ba75029", null))
			return ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_WIRED)
			balloon_alert(user, LANG("obj.54ba1ec9c1262726", null))
			return ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_GLASSED)
			tool.play_tool_sound(src)
			balloon_alert(user, LANG("obj.480f94595c86366a", null))
			state = FRAME_COMPUTER_STATE_WIRED
			update_appearance(UPDATE_ICON_STATE)
			var/obj/item/stack/sheet/glass/dropped_glass = new (drop_location(), 2)
			if (!QDELETED(dropped_glass))
				dropped_glass.add_fingerprint(user)
			return ITEM_INTERACT_SUCCESS

/obj/structure/frame/computer/wirecutter_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE

	if(state != FRAME_COMPUTER_STATE_WIRED)
		return ITEM_INTERACT_BLOCKING

	tool.play_tool_sound(src)
	balloon_alert(user, LANG("obj.cc1d6a362f69664d", null))
	state = FRAME_COMPUTER_STATE_BOARD_SECURED
	update_appearance(UPDATE_ICON_STATE)

	var/obj/item/stack/cable_coil/dropped_cables = new (drop_location(), 5)
	if (!QDELETED(dropped_cables))
		dropped_cables.add_fingerprint(user)
	return ITEM_INTERACT_SUCCESS

/**
 * Adds cable to the computer to wire it
 * Arguments
 *
 * * mob/living/user - the player who is adding the cable
 * * obj/item/stack/cable_coil/cable - the cable we are trying to add
 * * time - time taken to complete the operation
 */
/obj/structure/frame/computer/proc/add_cabling(mob/living/user, obj/item/stack/cable_coil/cable, time = 2 SECONDS)
	PRIVATE_PROC(TRUE)

	if(state != FRAME_COMPUTER_STATE_BOARD_SECURED)
		return FALSE
	if(!cable.tool_start_check(user, amount = 5))
		return FALSE
	if(time > 0)
		balloon_alert(user, LANG("obj.a59792f9eab1ed31", null))
	if(!cable.use_tool(src, user, time, volume = 50, amount = 5) || state != FRAME_COMPUTER_STATE_BOARD_SECURED)
		return FALSE

	state = FRAME_COMPUTER_STATE_WIRED
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/**
 * Adds glass sheets to the computer to complete the screen
 * Arguments
 *
 * * mob/living/user - the player who is adding the glass
 * * obj/item/stack/sheet/glass/glass - the glass we are trying to add
 * * time - time taken to complete the operation
 */
/obj/structure/frame/computer/proc/add_glass(mob/living/user, obj/item/stack/sheet/glass/glass, time = 2 SECONDS)
	PRIVATE_PROC(TRUE)

	if(state != FRAME_COMPUTER_STATE_WIRED)
		return FALSE
	if(!glass.tool_start_check(user, amount = 2))
		return FALSE
	if(time > 0)
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		balloon_alert(user, LANG("obj.87806593ba68bc0d", null))
	if(!glass.use_tool(src, user, time, amount = 2) || state != FRAME_COMPUTER_STATE_WIRED)
		return FALSE

	state = FRAME_COMPUTER_STATE_GLASSED
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/structure/frame/computer/finalize_construction(mob/living/user, obj/item/tool)
	if(!anchored)
		balloon_alert(user, LANG("obj.6b9690c56178f65a", null))
		return FALSE

	tool.play_tool_sound(src)
	var/obj/machinery/new_machine = new circuit.build_path(loc)
	new_machine.balloon_alert(user, LANG("obj.a5065fe1ee66616d", null))
	new_machine.setDir(dir)
	transfer_fingerprints_to(new_machine)
	// NOVA EDIT ADDITION BEGIN - Connecting Computers
	for(var/obj/machinery/computer/selected in range(1,src))
		selected.update_overlays()
	// NOVA EDIT ADDITION END - Connecting Computers

	if(istype(new_machine, /obj/machinery/computer))
		var/obj/machinery/computer/new_computer = new_machine

		new_machine.clear_components()

		// Set anchor state and move the frame's parts over to the new machine.
		// Then refresh parts and call on_construction().
		new_computer.set_anchored(anchored)
		new_computer.component_parts = list(circuit)
		new_computer.circuit = circuit

		circuit.forceMove(new_computer)

		for(var/atom/movable/movable_part in src)
			movable_part.forceMove(new_computer)
			new_computer.component_parts += movable_part

		new_computer.RefreshParts()
		new_computer.on_construction(user)

	qdel(src)
	return TRUE

/// Helpers for rcd
/obj/structure/frame/computer/rcd
	icon = 'icons/hud/radial.dmi'
	icon_state = "cnorth"
	anchored = TRUE

/obj/structure/frame/computer/rcd/Initialize(mapload)
	// yeah...
	name = "computer frame"
	icon = 'icons/obj/devices/stock_parts.dmi'
	return ..()

/obj/structure/frame/computer/rcd/north
	dir = NORTH
	name = "Computer North"
	icon_state = "cnorth"

/obj/structure/frame/computer/rcd/south
	dir = SOUTH
	name = "Computer South"
	icon_state = "csouth"

/obj/structure/frame/computer/rcd/east
	dir = EAST
	name = "Computer East"
	icon_state = "ceast"

/obj/structure/frame/computer/rcd/west
	dir = WEST
	name = "Computer West"
	icon_state = "cwest"
