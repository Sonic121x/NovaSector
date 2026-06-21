/obj/structure/door_assembly
	name = "气闸组件"
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
	name = "大型气闸组件"
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
	update_overlays()

/obj/structure/door_assembly/multi_tile/Move()
	. = ..()
	set_bounds()

/obj/structure/door_assembly/examine(mob/user)
	. = ..()
	switch(state)
		if(AIRLOCK_ASSEMBLY_NEEDS_WIRES)
			if(anchored)
				. += span_notice("锚定螺栓已用<b>扳手</b>固定，但维护面板缺少<i>电线</i>。")
			else
				. += span_notice("这个组件已经<b>焊接在一起</b>，但固定螺栓<i>没有拧紧</i>。")
		if(AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			. += span_notice("维护面板已经<b>接好线</b>，但电路插槽是<i>空的</i>。")
		if(AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
			. += span_notice("电路<b>松散地连接</b>在插槽上，但维护面板<i>没有拧紧且处于打开状态</i>。")
	if(!mineral && !nomineral && !glass && !noglass)
		. += span_notice("有用于玻璃窗和矿物盖板的<i>空</i>插槽。")
	else if(!mineral && !nomineral && glass && !noglass)
		. += span_notice("有用于矿物盖板的<i>空</i>插槽。")
	else if(!glass && !noglass)
		. += span_notice("有用于玻璃窗的<i>空</i>插槽。")
	if(created_name)
		. += span_notice("组件上有一个小的<i>纸质</i>标牌，上面写着'[created_name]'。")

/obj/structure/door_assembly/attackby(obj/item/tool, mob/living/user, list/modifiers, list/attack_modifiers)
	if((tool.tool_behaviour == TOOL_WELDER) && (mineral || glass || !anchored ))
		if(!tool.tool_start_check(user, amount=1))
			return

		if(mineral)
			var/obj/item/stack/sheet/mineral/mineral_path = text2path("/obj/item/stack/sheet/mineral/[mineral]")
			user.visible_message(span_notice("[user] 将气闸组件上的[mineral]覆板焊了下来。"), span_notice("你开始将气闸组件上的[mineral]覆板焊下来..."))
			if(tool.use_tool(src, user, 40, volume=50))
				to_chat(user, span_notice("你将[mineral]覆板焊了下来。"))
				new mineral_path(loc, 2)
				var/obj/structure/door_assembly/PA = new previous_assembly(loc)
				transfer_assembly_vars(src, PA)

		else if(glass)
			user.visible_message(span_notice("[user] 将气闸组件中的玻璃板焊了出来。"), span_notice("你开始将气闸组件中的玻璃板焊出来..."))
			if(tool.use_tool(src, user, 40, volume=50))
				to_chat(user, span_notice("你将玻璃板焊了出来。"))
				if(heat_proof_finished)
					new /obj/item/stack/sheet/rglass(get_turf(src))
					heat_proof_finished = FALSE
				else
					new /obj/item/stack/sheet/glass(get_turf(src))
				glass = 0
		else if(!anchored)
			user.visible_message(span_warning("[user]拆解了气闸组件."), \
								span_notice("你开始拆解气闸组件..."))
			if(tool.use_tool(src, user, 40, volume=50))
				to_chat(user, span_notice("你拆解了气闸组件."))
				deconstruct(TRUE)

	else if(tool.tool_behaviour == TOOL_WRENCH)
		if(!anchored )
			var/door_check = 1
			for(var/obj/machinery/door/D in loc)
				if(!D.sub_door)
					door_check = 0
					break

			if(door_check)
				user.visible_message(span_notice("[user] 将气闸组件固定在地板上。"), \
					span_notice("你开始把气闸组件固定在地板上..."), \
					span_hear("You hear wrenching."))

				if(tool.use_tool(src, user, 40, volume=100))
					if(anchored)
						return
					to_chat(user, span_notice("你固定了气闸组件."))
					name = "secured airlock assembly"
					set_anchored(TRUE)
			else
				to_chat(user, "这里已经有一扇门了！")

		else
			user.visible_message(span_notice("[user] 将气闸组件从地板上松开。"), \
				span_notice("你开始将气闸组件从地板上松开..."), \
				span_hear("You hear wrenching."))
			if(tool.use_tool(src, user, 40, volume=100))
				if(!anchored)
					return
				to_chat(user, span_notice("你解除固定了气闸组件."))
				name = "气闸组件"
				set_anchored(FALSE)

	else if(istype(tool, /obj/item/stack/cable_coil) && state == AIRLOCK_ASSEMBLY_NEEDS_WIRES && anchored )
		if(!tool.tool_start_check(user, amount=1))
			return

		user.visible_message(span_notice("[user] 给气闸组件接线。"), \
							span_notice("你开始给气闸组件接线..."))
		if(tool.use_tool(src, user, 40, amount=1))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_WIRES)
				return
			state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
			to_chat(user, span_notice("你给气闸组件接好了线。"))
			name = "wired airlock assembly"

	else if((tool.tool_behaviour == TOOL_WIRECUTTER) && state == AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS )
		user.visible_message(span_notice("[user] 从气闸组件上剪断了电线。"), \
							span_notice("你开始从气闸组件上剪断电线..."))

		if(tool.use_tool(src, user, 40, volume=100))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
				return
			to_chat(user, span_notice("你从气闸组件上剪断了电线。"))
			new/obj/item/stack/cable_coil(get_turf(user), 1)
			state = AIRLOCK_ASSEMBLY_NEEDS_WIRES
			name = "secured airlock assembly"

	else if(istype(tool, /obj/item/electronics/airlock) && state == AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS )
		tool.play_tool_sound(src, 100)
		user.visible_message(span_notice("[user] 将电子元件安装到气闸组件中。"), \
							span_notice("你开始将电子元件安装到气闸组件中..."))
		if(do_after(user, 4 SECONDS, target = src))
			if( state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS )
				return
			if(!user.transferItemToLoc(tool, src))
				return

			to_chat(user, span_notice("你装入气闸电路。"))
			state = AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER
			name = "气闸组件近成品"
			electronics = tool


	else if((tool.tool_behaviour == TOOL_CROWBAR) && state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER )
		user.visible_message(span_notice("[user]从气闸组件中移除电路。."), \
								span_notice("你开始从气闸组件中移除电路..."))

		if(tool.use_tool(src, user, 40, volume=100))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
				return
			to_chat(user, span_notice("你移除了气闸电路。"))
			state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
			name = "wired airlock assembly"
			var/obj/item/electronics/airlock/ae
			if (!electronics)
				ae = new/obj/item/electronics/airlock( loc )
			else
				ae = electronics
				electronics = null
				ae.forceMove(src.loc)

	else if(istype(tool, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/sheet = tool
		if(!glass && (istype(sheet, /obj/item/stack/sheet/rglass) || istype(sheet, /obj/item/stack/sheet/glass)))
			if(noglass)
				to_chat(user, span_warning("你无法将 [sheet] 添加到 [src]！"))
				return
			playsound(src, 'sound/items/tools/crowbar.ogg', 100, TRUE)
			user.visible_message(span_notice("[user] 将 [sheet.name] 添加到气闸组件中。"), \
								span_notice("你开始将 [sheet.name] 安装到气闸组件中..."))
			if(do_after(user, 4 SECONDS, target = src))
				if(sheet.get_amount() < 1 || glass)
					return
				if(sheet.type == /obj/item/stack/sheet/rglass)
					to_chat(user, span_notice("你将 [sheet.name] 窗户安装到气闸组件中。"))
					heat_proof_finished = 1 //reinforced glass makes the airlock heat-proof
					name = "隔热窗气闸组件近成品"
				else
					to_chat(user, span_notice("你将普通玻璃窗户安装到气闸组件中。"))
					name = "有窗气闸组件近成品"
				sheet.use(1)
				glass = TRUE
			return

		if(istype(sheet, /obj/item/stack/sheet/mineral) && sheet.construction_path_type)
			if(nomineral || mineral)
				to_chat(user, span_warning("你无法将 [sheet] 添加到 [src]！"))
				return

			var/M = sheet.construction_path_type
			var/mineralassembly = text2path("/obj/structure/door_assembly/door_assembly_[M]")
			if(!ispath(mineralassembly))
				to_chat(user, span_warning("你无法将 [sheet] 添加到 [src]！"))
				return
			if(sheet.get_amount() < 2)
				to_chat(user, span_warning("你至少需要两块板材才能添加矿物覆盖层！"))
				return

			playsound(src, 'sound/items/tools/crowbar.ogg', 100, TRUE)
			user.visible_message(span_notice("[user] 将 [sheet.name] 添加到气闸组件中。"), \
				span_notice("你开始将 [sheet.name] 安装到气闸组件中..."))
			if(!do_after(user, 4 SECONDS, target = src) || sheet.get_amount() < 2 || mineral)
				return
			to_chat(user, span_notice("你将 [M] 板材安装到气闸组件中。"))
			sheet.use(2)
			var/obj/structure/door_assembly/MA = new mineralassembly(loc)

			if(MA.noglass && glass) //in case the new door doesn't support glass. prevents the new one from reverting to a normal airlock after being constructed.
				var/obj/item/stack/sheet/dropped_glass
				if(heat_proof_finished)
					dropped_glass = new /obj/item/stack/sheet/rglass(drop_location())
					heat_proof_finished = FALSE
				else
					dropped_glass = new /obj/item/stack/sheet/glass(drop_location())
				glass = FALSE
				to_chat(user, span_notice("当你完成时，一块 [dropped_glass.singular_name] 从 [MA] 的框架中掉了出来。"))

			transfer_assembly_vars(src, MA, TRUE)

	else if((tool.tool_behaviour == TOOL_SCREWDRIVER) && state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER )
		user.visible_message(span_notice("[user] 完成了气闸的组装。"), \
			span_notice("你开始完成气闸的组装..."))

		if(tool.use_tool(src, user, 40, volume=100))
			if(loc && state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
				to_chat(user, span_notice("你完成了气闸的组装。"))
				finish_door()
	else
		return ..()
	update_name()
	update_appearance()

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
				name = "安全的"
		if(AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			name = "接线的"
		if(AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
			name = "快完成的"
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
