// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/airlocks/station/public.dmi'
	icon_state = "construction"
	var/overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
	anchored = FALSE
	density = TRUE
	max_integrity = 200
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4)
	/// Airlock's current construction state
	var/state = AIRLOCK_ASSEMBLY_NEEDS_WIRES
	var/base_name = "Airlock"
	var/created_name = null
	var/mineral = null
	var/obj/item/electronics/airlock/electronics = null
	/// Do we perform the extra checks required for multi-tile (large) airlocks
	var/multi_tile = FALSE
	/// The type path of the airlock once completed (solid version)
	var/airlock_type = /obj/machinery/door/airlock
	/// The type path of the airlock once completed (glass version)
	var/glass_type = /obj/machinery/door/airlock/glass
	/// FALSE = glass can be installed. TRUE = glass is already installed.
	var/glass = FALSE
	/// Whether to heat-proof the finished airlock
	var/heat_proof_finished = FALSE
	/// If you're changing the airlock material, what is the previous type
	var/previous_assembly = /obj/structure/door_assembly
	/// Airlocks with no glass version, also cannot be modified with sheets
	var/noglass = FALSE
	/// Airlock with glass version, but cannot be modified with sheets
	var/nomineral = FALSE
	/// What type of material the airlock drops when deconstructed
	var/material_type = /obj/item/stack/sheet/iron
	/// Amount of material the airlock drops when deconstructed
	var/material_amt = 4

/obj/structure/door_assembly/multi_tile
	name = "large airlock assembly"
	icon = 'icons/obj/doors/airlocks/multi_tile/public/glass.dmi'
	overlays_file = 'icons/obj/doors/airlocks/multi_tile/public/overlays.dmi'
	base_name = "large airlock"
	glass_type = /obj/machinery/door/airlock/multi_tile/public/glass
	airlock_type = /obj/machinery/door/airlock/multi_tile/public/glass
	dir = EAST
	multi_tile = TRUE
	glass = TRUE
	nomineral = TRUE
	material_amt = 8

/obj/structure/door_assembly/Initialize(mapload)
	. = ..()
	obj_flags |= UNIQUE_RENAME | RENAME_NO_DESC
	update_appearance()
	update_name()

/obj/structure/door_assembly/multi_tile/Initialize(mapload)
	. = ..()
	set_bounds()
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/door_assembly/multi_tile/Move()
	. = ..()
	set_bounds()

/obj/structure/door_assembly/examine(mob/user)
	. = ..()
	switch(state)
		if(AIRLOCK_ASSEMBLY_NEEDS_WIRES)
			if(anchored)
				. += span_notice(LANG("obj.5050a058c33dad74", null))
			else
				. += span_notice(LANG("obj.77a77015d40f6f78", null))
		if(AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			. += span_notice(LANG("obj.95f8ce7c7dc3d15d", null))
		if(AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
			. += span_notice(LANG("obj.637b8cc233046d5c", null))
	if(!mineral && !nomineral && !glass && !noglass)
		. += span_notice(LANG("obj.25999ffe3428b79c", null))
	else if(!mineral && !nomineral && glass && !noglass)
		. += span_notice(LANG("obj.e918389d3d669d9c", null))
	else if(!glass && !noglass)
		. += span_notice(LANG("obj.63aaa8839aa2581b", null))
	if(created_name)
		. += span_notice(LANG("obj.4cbafcc7a3cf090f", list(created_name)))

/obj/structure/door_assembly/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(anchored && state == AIRLOCK_ASSEMBLY_NEEDS_WIRES && istype(tool, /obj/item/stack/cable_coil))
		if(!tool.tool_start_check(user, amount=1))
			return ITEM_INTERACT_BLOCKING

		user.visible_message(span_notice(LANG("obj.0560dc7b9c900072", list(user))), \
							span_notice(LANG("obj.1cbdf49bdae134ff", null)))
		if(!tool.use_tool(src, user, 40, amount=1))
			return ITEM_INTERACT_BLOCKING

		if(state != AIRLOCK_ASSEMBLY_NEEDS_WIRES)
			return ITEM_INTERACT_BLOCKING

		state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
		to_chat(user, span_notice(LANG("obj.a0099c5235df5e4b", null)))
		name = "wired airlock assembly"
		update_name()
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(state == AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS && istype(tool, /obj/item/electronics/airlock))
		tool.play_tool_sound(src, 100)
		user.visible_message(span_notice(LANG("obj.1dc6640c2caf0f95", list(user))), \
							span_notice(LANG("obj.fb1066e61a51ca9e", null)))
		if(!do_after(user, 4 SECONDS, target = src))
			return ITEM_INTERACT_BLOCKING

		if(state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.2b65dc1211c06809", null)))
		state = AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER
		name = "near finished airlock assembly"
		electronics = tool
		update_name()
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/sheet = tool
		if(!glass && (istype(sheet, /obj/item/stack/sheet/rglass) || istype(sheet, /obj/item/stack/sheet/glass)))
			if(noglass)
				to_chat(user, span_warning(LANG("obj.ad6e1ca4182a1892", list(sheet, src))))
				return ITEM_INTERACT_BLOCKING
			playsound(src, 'sound/items/tools/crowbar.ogg', 100, TRUE)
			user.visible_message(span_notice(LANG("obj.0886ae47c850c8f3", list(user, sheet.name))), \
								span_notice(LANG("obj.4f07aac030baad1d", list(sheet.name))))
			if(!do_after(user, 4 SECONDS, target = src))
				return ITEM_INTERACT_BLOCKING
			if(sheet.get_amount() < 1 || glass)
				return ITEM_INTERACT_BLOCKING
			if(sheet.type == /obj/item/stack/sheet/rglass)
				to_chat(user, span_notice(LANG("obj.900bec0255fcb1fc", list(sheet.name))))
				heat_proof_finished = TRUE //reinforced glass makes the airlock heat-proof
				name = "near finished heat-proofed window airlock assembly"
			else
				to_chat(user, span_notice(LANG("obj.b093321866bf487f", null)))
				name = "near finished window airlock assembly"
			sheet.use(1)
			glass = TRUE
			update_name()
			update_appearance()
			return ITEM_INTERACT_SUCCESS

		if(istype(sheet, /obj/item/stack/sheet/mineral) && sheet.construction_path_type)
			if(nomineral || mineral)
				to_chat(user, span_warning(LANG("obj.ad6e1ca4182a1892", list(sheet, src))))
				return ITEM_INTERACT_BLOCKING

			var/type_path_extension = sheet.construction_path_type
			var/mineralassembly = text2path("/obj/structure/door_assembly/door_assembly_[type_path_extension]")
			if(!ispath(mineralassembly))
				to_chat(user, span_warning(LANG("obj.ad6e1ca4182a1892", list(sheet, src))))
				return ITEM_INTERACT_BLOCKING

			if(sheet.get_amount() < 2)
				to_chat(user, span_warning(LANG("obj.74f6b8a1b31bcf05", null)))
				return ITEM_INTERACT_BLOCKING

			playsound(src, 'sound/items/tools/crowbar.ogg', 100, TRUE)
			user.visible_message(span_notice(LANG("obj.0886ae47c850c8f3", list(user, sheet.name))), \
								span_notice(LANG("obj.4f07aac030baad1d", list(sheet.name))))
			if(!do_after(user, 4 SECONDS, target = src) || sheet.get_amount() < 2 || mineral)
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_notice(LANG("obj.fa17052811a33fd0", list(type_path_extension))))
			sheet.use(2)
			var/obj/structure/door_assembly/replacement_assembly = new mineralassembly(loc)

			if(replacement_assembly.noglass && glass) //in case the new door doesn't support glass. prevents the new one from reverting to a normal airlock after being constructed.
				var/obj/item/stack/sheet/dropped_glass
				if(heat_proof_finished)
					dropped_glass = new /obj/item/stack/sheet/rglass(drop_location())
					heat_proof_finished = FALSE
				else
					dropped_glass = new /obj/item/stack/sheet/glass(drop_location())
				glass = FALSE
				to_chat(user, span_notice(LANG("obj.97ab5136da083cb3", list(dropped_glass.singular_name, replacement_assembly))))

			transfer_assembly_vars(src, replacement_assembly, TRUE)
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/structure/door_assembly/welder_act(mob/living/user, obj/item/tool)
	if(!mineral && !glass && anchored)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(!tool.tool_start_check(user, amount=1))
		return ITEM_INTERACT_BLOCKING

	if(mineral)
		var/obj/item/stack/sheet/mineral/mineral_path = text2path("/obj/item/stack/sheet/mineral/[mineral]")
		user.visible_message(span_notice(LANG("obj.595e3c41208e6676", list(user, mineral))), span_notice(LANG("obj.c5680a9bb16235aa", list(mineral))))
		if(!tool.use_tool(src, user, 40, volume=50))
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice(LANG("obj.04c8751b001e383f", list(mineral))))
		new mineral_path(loc, 2)
		var/obj/structure/door_assembly/PA = new previous_assembly(loc)
		transfer_assembly_vars(src, PA)
		update_name()
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(glass)
		user.visible_message(span_notice(LANG("obj.6c6545fd2bb99689", list(user))), \
							span_notice(LANG("obj.4d93a37290e9d3dd", null)))
		if(!tool.use_tool(src, user, 40, volume=50))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.d9d49b97309c1a8b", null)))
		if(heat_proof_finished)
			new /obj/item/stack/sheet/rglass(get_turf(src))
			heat_proof_finished = FALSE
		else
			new /obj/item/stack/sheet/glass(get_turf(src))
		glass = FALSE
		update_name()
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(!anchored)
		user.visible_message(span_warning(LANG("obj.e0983c73542f73da", list(user))), \
							span_notice(LANG("obj.86d28134bf4d5aa0", null)))
		if(!tool.use_tool(src, user, 40, volume=50))
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice(LANG("obj.74c1dfb1cd1e5356", null)))
		deconstruct(TRUE)
		return ITEM_INTERACT_SUCCESS
	// no return NONE at end because it's not possible we end up here

/obj/structure/door_assembly/wrench_act(mob/living/user, obj/item/tool)
	if(anchored)
		user.visible_message(span_notice(LANG("obj.e46bef59da1abd33", list(user))), \
							span_notice(LANG("obj.07e30e4a005249bd", null)), \
							span_hear(LANG("obj.7eacbf566316e99f", null)))
		if(!tool.use_tool(src, user, 40, volume=100))
			return ITEM_INTERACT_BLOCKING

		if(!anchored)
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.a50cb0b58a228b72", null)))
		name = "airlock assembly"
		set_anchored(FALSE)
		update_name()
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	var/door_check = FALSE
	for(var/obj/machinery/door/competitor in loc)
		if(!competitor.sub_door)
			door_check = TRUE
			break

	if(door_check)
		to_chat(user, LANG("obj.f23c1bd4f9f2109a", null))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice(LANG("obj.ca15796db0d406f8", list(user))), \
						span_notice(LANG("obj.e76a0edae595fe5f", null)), \
						span_hear(LANG("obj.7eacbf566316e99f", null)))

	if(!tool.use_tool(src, user, 40, volume=100))
		return ITEM_INTERACT_BLOCKING

	if(anchored)
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.e09cecebf5c415d8", null)))
	name = "secured airlock assembly"
	set_anchored(TRUE)
	update_name()
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/structure/door_assembly/wirecutter_act(mob/living/user, obj/item/tool)
	if(state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
		return ITEM_INTERACT_SKIP_TO_ATTACK
	user.visible_message(span_notice(LANG("obj.bf1d728fc5ac0288", list(user))), \
						span_notice(LANG("obj.7b33ed7cf88526f4", null)))

	if(!tool.use_tool(src, user, 40, volume=100))
		return ITEM_INTERACT_BLOCKING
	if(state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.442275504e2c2286", null)))
	new/obj/item/stack/cable_coil(get_turf(user), 1)
	state = AIRLOCK_ASSEMBLY_NEEDS_WIRES
	name = "secured airlock assembly"
	update_name()
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/structure/door_assembly/crowbar_act(mob/living/user, obj/item/tool)
	if(state != AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
		return ITEM_INTERACT_SKIP_TO_ATTACK
	user.visible_message(span_notice(LANG("obj.a05c355a0fbc637e", list(user))), \
						span_notice(LANG("obj.bef30a550e4732a2", null)))

	if(!tool.use_tool(src, user, 40, volume=100))
		return ITEM_INTERACT_BLOCKING

	if(state != AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.a5dac4b826ccd223", null)))
	state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
	name = "wired airlock assembly"
	var/obj/item/electronics/airlock/ae
	if (!electronics)
		ae = new/obj/item/electronics/airlock(loc)
	else
		ae = electronics
		electronics = null
		ae.forceMove(src.loc)
	update_name()
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/structure/door_assembly/screwdriver_act(mob/living/user, obj/item/tool)
	if(state != AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	user.visible_message(span_notice(LANG("obj.041fc707d71bdf45", list(user))), \
						span_notice(LANG("obj.e58cd140f00ca1cc", null)))
	if(!tool.use_tool(src, user, 40, volume=100))
		return ITEM_INTERACT_BLOCKING

	if(!loc || state != AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.7edea114d4152db8", null)))
	finish_door()
	return ITEM_INTERACT_SUCCESS

/obj/structure/door_assembly/proc/finish_door()
	var/obj/machinery/door/airlock/door
	if(glass)
		door = new glass_type( loc )
	else
		door = new airlock_type( loc )
	door.setDir(dir)
	door.unres_sides = electronics.unres_sides
	door.electronics = electronics
	door.heat_proof = heat_proof_finished
	door.security_level = 0
	if(electronics.shell)
		door.AddComponent( \
			/datum/component/shell, \
			unremovable_circuit_components = list(new /obj/item/circuit_component/airlock, new /obj/item/circuit_component/airlock_access_event, new /obj/item/circuit_component/remotecam/airlock), \
			capacity = SHELL_CAPACITY_LARGE, \
			shell_flags = SHELL_FLAG_ALLOW_FAILURE_ACTION|SHELL_FLAG_REQUIRE_ANCHOR \
		)
	if(electronics.one_access)
		door.req_one_access = electronics.accesses
	else
		door.req_access = electronics.accesses
	if(created_name)
		door.name = created_name
	else if(electronics.passed_name)
		door.name = sanitize(electronics.passed_name)
	else
		door.name = base_name
	if(electronics.passed_cycle_id)
		door.closeOtherId = electronics.passed_cycle_id
		door.update_other_id()
	if(door.unres_sides)
		door.unres_latch = TRUE
	door.previous_airlock = previous_assembly
	electronics.forceMove(door)
	door.autoclose = TRUE
	door.close()
	door.update_appearance()

	qdel(src)
	return door

/obj/structure/door_assembly/update_overlays()
	. = ..()
	if(!glass)
		. += get_airlock_overlay("fill_construction", icon, src, TRUE)
	else
		. += get_airlock_overlay("glass_construction", overlays_file, src, TRUE)
	. += get_airlock_overlay("panel_c[state+1]", overlays_file, src, TRUE)

/obj/structure/door_assembly/update_name()
	name = ""
	switch(state)
		if(AIRLOCK_ASSEMBLY_NEEDS_WIRES)
			if(anchored)
				name = "secured "
		if(AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			name = "wired "
		if(AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
			name = "near finished "
	name += "[heat_proof_finished ? "heat-proofed " : ""][glass ? "window " : ""][base_name] assembly"
	return ..()

/obj/structure/door_assembly/proc/transfer_assembly_vars(obj/structure/door_assembly/source, obj/structure/door_assembly/target, previous = FALSE)
	target.glass = source.glass
	target.heat_proof_finished = source.heat_proof_finished
	target.created_name = source.created_name
	target.state = source.state
	target.set_anchored(source.anchored)
	if(previous)
		target.previous_assembly = source.type
	if(electronics)
		target.electronics = source.electronics
		source.electronics.forceMove(target)
	target.update_appearance()
	target.update_name()
	qdel(source)

/obj/structure/door_assembly/atom_deconstruct(disassembled = TRUE)
	var/turf/target_turf = get_turf(src)
	if(!disassembled)
		material_amt = rand(2,4)
	new material_type(target_turf, material_amt)
	if(glass)
		if(disassembled)
			if(heat_proof_finished)
				new /obj/item/stack/sheet/rglass(target_turf)
			else
				new /obj/item/stack/sheet/glass(target_turf)
		else
			new /obj/item/shard(target_turf)
	if(mineral)
		var/obj/item/stack/sheet/mineral/mineral_path = text2path("/obj/item/stack/sheet/mineral/[mineral]")
		new mineral_path(target_turf, 2)

/obj/structure/door_assembly/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("delay" = 5 SECONDS, "cost" = 16)
	return FALSE

/obj/structure/door_assembly/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	if(rcd_data[RCD_DESIGN_MODE] == RCD_DECONSTRUCT)
		qdel(src)
		return TRUE
	return FALSE

/obj/structure/door_assembly/nameformat(input, mob/living/user)
	created_name = input
	return input

/obj/structure/door_assembly/rename_reset()
	created_name = null
