/obj/item/flatpack
	name = "扁平包装"
	desc = "一个装有紧凑包装机器的盒子。使用多功能工具部署。"
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "flatpack"
	density = TRUE
	w_class = WEIGHT_CLASS_HUGE //cart time
	throw_range = 2
	item_flags = SLOWS_WHILE_IN_HAND | IMMUTABLE_SLOW
	slowdown = 2.5
	drag_slowdown = 3.5 //use the cart stupid
	custom_premium_price = PAYCHECK_COMMAND * 1.5

	/// The board we deploy
	var/obj/item/circuitboard/machine/board

/obj/item/flatpack/Initialize(mapload, obj/item/circuitboard/machine/new_board)
	if(isnull(board) && isnull(new_board))
		return INITIALIZE_HINT_QDEL //how

	. = ..()

	var/static/list/tool_behaviors = list(
			TOOL_MULTITOOL = list(
				SCREENTIP_CONTEXT_LMB = "Deploy",
			),
		)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

	board = !isnull(new_board) ? new_board : new board(src) // i got board
	if(board.loc != src)
		board.forceMove(src)
	var/obj/machinery/build = initial(board.build_path)
	name = "扁平包装 ([initial(build.name)])"

/obj/item/flatpack/Destroy()
	QDEL_NULL(board)
	. = ..()

/obj/item/flatpack/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !isobserver(user))
		return

	if(loc == user)
		. += span_warning("你不能在手持时部署。")
	else if(isturf(loc))
		var/turf/location = loc
		if(!isopenturf(location))
			. += span_warning("无法在此位置部署")
		else if(location.is_blocked_turf(source_atom = src))
			. += span_warning("没有部署空间")

/obj/item/flatpack/multitool_act(mob/living/user, obj/item/tool)
	. = NONE

	if(isnull(board))
		return ITEM_INTERACT_BLOCKING
	if(!isturf(loc))
		balloon_alert(user, "必须部署在地板上")
		return ITEM_INTERACT_BLOCKING
	var/turf/location = loc
	if(!isopenturf(location))
		balloon_alert(user, "无法在此部署")
		return ITEM_INTERACT_BLOCKING
	else if(location.is_blocked_turf(source_atom = src))
		balloon_alert(user, "没有空间部署")
		return ITEM_INTERACT_BLOCKING
	balloon_alert_to_viewers("deploying!")
	if(!do_after(user, 1 SECONDS, target = src))
		return ITEM_INTERACT_BLOCKING

	new /obj/effect/temp_visual/mook_dust(loc)
	var/obj/item/circuitboard/machine/leaving_circuit = board
	if(contents.len > 1)
		leaving_circuit.replacement_parts = leaving_circuit.flatten_component_list()
		for(var/obj/item/flatpack_component in src)
			if(flatpack_component == leaving_circuit)
				continue
			for(var/i in 1 to leaving_circuit.replacement_parts.len)
				var/obj/item/machine_component = leaving_circuit.replacement_parts[i]
				if(!ispath(machine_component, /obj/item))
					continue
				if(flatpack_component.type == machine_component)
					leaving_circuit.replacement_parts[i] = flatpack_component
					break

	board = null
	var/obj/machinery/new_machine = new leaving_circuit.build_path(loc, board = leaving_circuit)
	new_machine.on_construction(user)
	loc.visible_message(span_warning("[src] 部署了！"))
	playsound(src, 'sound/machines/terminal/terminal_eject.ogg', 70, TRUE)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

///Maximum number of flatpacks in a cart
#define MAX_FLAT_PACKS 3

/obj/structure/flatpack_cart
	name = "扁平包装推车"
	desc = "专门用于存放来自扁平包装机的扁平包装的推车，能均匀分配重量。很方便！"
	icon = 'icons/obj/structures.dmi'
	icon_state = "flatcart"
	density = TRUE
	opacity = FALSE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 8, /datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT)

/obj/structure/flatpack_cart/Initialize(mapload)
	. = ..()

	register_context()

	AddElement(/datum/element/noisy_movement, volume = 45) // i hate noise

/obj/structure/flatpack_cart/atom_deconstruct(disassembled)
	for(var/atom/movable/content as anything in contents)
		content.forceMove(drop_location())

/obj/structure/flatpack_cart/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(istype(held_item, /obj/item/flatpack))
		context[SCREENTIP_CONTEXT_LMB] = "Load pack"
		return CONTEXTUAL_SCREENTIP_SET

/obj/structure/flatpack_cart/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !isobserver(user))
		return

	. += "From bottom to top, this cart contains:"
	for(var/obj/item/flatpack as anything in contents)
		. += flatpack.name

/obj/structure/flatpack_cart/update_overlays()
	. = ..()

	var/offset = 0
	for(var/item in contents)
		var/mutable_appearance/flatpack_overlay = mutable_appearance(icon, "flatcart_flat", layer = layer + (offset * 0.01))
		flatpack_overlay.pixel_z = offset
		offset += 4
		. += flatpack_overlay

/obj/structure/flatpack_cart/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.put_in_hands(contents[length(contents)]) //topmost box
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/flatpack_cart/item_interaction(mob/living/user, obj/item/attacking_item, params)
	if(!istype(attacking_item, /obj/item/flatpack) || user.combat_mode || attacking_item.flags_1 & HOLOGRAM_1 || attacking_item.item_flags & ABSTRACT)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if (length(contents) >= MAX_FLAT_PACKS)
		balloon_alert(user, "满了！")
		return ITEM_INTERACT_BLOCKING
	if (!user.transferItemToLoc(attacking_item, src))
		return ITEM_INTERACT_BLOCKING
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

#undef MAX_FLAT_PACKS

// Engineering flatpacks

/obj/item/flatpack/flatpacker // a roundstart flatpacker is NICE you can gahdamn tell the time and everythin'
	name = "扁平包装机"
	board = /obj/item/circuitboard/machine/flatpacker
	custom_premium_price = PAYCHECK_COMMAND

/obj/item/flatpack/shuttle_engine
	name = "shuttle propulsion engine"
	board = /obj/item/circuitboard/machine/engine/propulsion
	custom_premium_price = PAYCHECK_CREW * 2

// Cargo flatpacks

/obj/item/flatpack/mailsorter // to have a roundstart mail sorter at cargo
	name = "邮件分拣机"
	board = /obj/item/circuitboard/machine/mailsorter
	custom_premium_price = PAYCHECK_CREW * 1.5
