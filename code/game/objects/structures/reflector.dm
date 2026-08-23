// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/reflector
	name = "reflector base"
	icon = 'icons/obj/structures.dmi'
	icon_state = "reflector_map"
	desc = "A base for reflector assemblies."
	anchored = FALSE
	density = FALSE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)
	var/deflector_icon_state
	var/mutable_appearance/deflector_overlay
	var/finished = FALSE
	var/admin = FALSE //Can't be rotated or deconstructed
	var/can_rotate = TRUE
	var/framebuildstacktype = /obj/item/stack/sheet/iron
	var/framebuildstackamount = 5
	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 0
	var/list/allowed_projectile_typecache = list(/obj/projectile/beam, /obj/projectile/energy/nuclear_particle)
	var/rotation_angle = -1

/obj/structure/reflector/Initialize(mapload)
	. = ..()
	icon_state = "reflector_base"
	allowed_projectile_typecache = typecacheof(allowed_projectile_typecache)
	if(deflector_icon_state)
		deflector_overlay = mutable_appearance(icon, deflector_icon_state)
		// We offset our physical position DOWN, because TRANSFORM IS A FUCK
		deflector_overlay.pixel_y = -32
		deflector_overlay.pixel_z = 32
		add_overlay(deflector_overlay)

	if(rotation_angle == -1)
		set_angle(dir2angle(dir))
	else
		set_angle(rotation_angle)

	if(admin)
		can_rotate = FALSE

	AddComponent(/datum/component/usb_port, typecacheof(list(/obj/item/circuit_component/reflector), only_root_path = TRUE))

/obj/structure/reflector/examine(mob/user)
	. = ..()
	if(finished)
		. += LANG("obj.8516165543a1a005", list(rotation_angle, can_rotate ? "unlocked" : "locked"))
		if(!admin)
			if(can_rotate)
				. += span_notice(LANG("obj.0dfd560c2596facd", null))
				. += span_notice(LANG("obj.791dda474f117a3a", null))
			else
				. += span_notice(LANG("obj.f68e082e5f6ff037", null))

/obj/structure/reflector/proc/set_angle(new_angle)
	if(can_rotate)
		rotation_angle = new_angle
		if(deflector_overlay)
			cut_overlay(deflector_overlay)
			deflector_overlay.transform = turn(matrix(), new_angle)
			add_overlay(deflector_overlay)


/obj/structure/reflector/setDir(new_dir)
	return ..(NORTH)

/obj/structure/reflector/bullet_act(obj/projectile/proj)
	var/pdir = proj.dir
	var/pangle = proj.angle
	var/ploc = get_turf(proj)
	if(!finished || !allowed_projectile_typecache[proj.type] || !(proj.dir in GLOB.cardinals))
		return ..()
	if(auto_reflect(proj, pdir, ploc, pangle) != BULLET_ACT_FORCE_PIERCE)
		return ..()
	return BULLET_ACT_FORCE_PIERCE

/obj/structure/reflector/proc/auto_reflect(obj/projectile/proj, pdir, turf/ploc, pangle)
	proj.ignore_source_check = TRUE
	proj.range = proj.maximum_range
	proj.maximum_range = max(proj.maximum_range--, 0)
	return BULLET_ACT_FORCE_PIERCE

/obj/structure/reflector/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	if(admin && tool.tool_behaviour)
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/structure/reflector/screwdriver_act(mob/living/user, obj/item/tool)
	can_rotate = !can_rotate
	to_chat(user, span_notice(LANG("obj.13ce15bbabaf6229", list(can_rotate ? "unlock" : "lock", src))))
	tool.play_tool_sound(src)
	return ITEM_INTERACT_SUCCESS

/obj/structure/reflector/wrench_act(mob/living/user, obj/item/tool)
	if(anchored)
		to_chat(user, span_warning(LANG("obj.2893b16b1d8ee846", list(src))))
		return ITEM_INTERACT_SUCCESS
	user.visible_message(span_notice(LANG("obj.87859cea46929693", list(user, src))), span_notice(LANG("obj.344c0686a869a413", list(src))))
	if(!tool.use_tool(src, user, 8 SECONDS, volume=50))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.fc81480614a78c5d", list(src))))
	new framebuildstacktype(drop_location(), framebuildstackamount)
	if(buildstackamount)
		new buildstacktype(drop_location(), buildstackamount)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/structure/reflector/welder_act(mob/living/user, obj/item/tool)
	if(!tool.tool_start_check(user, amount=1))
		return ITEM_INTERACT_BLOCKING
	if(atom_integrity < max_integrity)
		user.visible_message(span_notice(LANG("obj.7cfba828a395f44c", list(user, src))),
							span_notice(LANG("obj.93449ef42b686baf", list(src))),
							span_hear(LANG("obj.1aa82fa3545466eb", null)))
		if(tool.use_tool(src, user, 4 SECONDS, volume=40))
			atom_integrity = max_integrity
			user.visible_message(span_notice(LANG("obj.639f2d4fef2753bc", list(user, src))), \
								span_notice(LANG("obj.616dfcb178896bec", list(src))))
	else if(!anchored)
		user.visible_message(span_notice(LANG("obj.9600c36405630174", list(user, src))),
							span_notice(LANG("obj.7765e0fab90f0928", list(src))),
							span_hear(LANG("obj.1aa82fa3545466eb", null)))
		if (tool.use_tool(src, user, 2 SECONDS, volume=50))
			set_anchored(TRUE)
			to_chat(user, span_notice(LANG("obj.46f0194bbe668d3b", list(src))))
	else
		user.visible_message(span_notice(LANG("obj.078cc3d361bb45af", list(user, src))),
							span_notice(LANG("obj.41ed57fe66669269", list(src))),
							span_hear(LANG("obj.1aa82fa3545466eb", null)))
		if (tool.use_tool(src, user, 2 SECONDS, volume=50))
			set_anchored(FALSE)
			to_chat(user, span_notice(LANG("obj.6a908a91e8707af7", list(src))))

	return ITEM_INTERACT_SUCCESS

/obj/structure/reflector/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(admin)
		return ITEM_INTERACT_BLOCKING
	//Finishing the frame
	if(!istype(tool, /obj/item/stack/sheet))
		return NONE

	if(finished)
		return ITEM_INTERACT_BLOCKING

	var/obj/item/stack/sheet/using_stack = tool
	if(istype(using_stack, /obj/item/stack/sheet/glass))
		if(!using_stack.use(5))
			to_chat(user, span_warning(LANG("obj.436be82e68d359df", null)))
			return ITEM_INTERACT_BLOCKING

		new /obj/structure/reflector/single(drop_location())
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	if(istype(using_stack, /obj/item/stack/sheet/rglass))
		if(!using_stack.use(10))
			to_chat(user, span_warning(LANG("obj.f81de041712febf4", null)))
			return ITEM_INTERACT_BLOCKING

		new /obj/structure/reflector/double(drop_location())
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	if(istype(using_stack, /obj/item/stack/sheet/mineral/diamond))
		if(!using_stack.use(1))
			return ITEM_INTERACT_BLOCKING

		new /obj/structure/reflector/box(drop_location())
		qdel(src)
		return ITEM_INTERACT_SUCCESS

/obj/structure/reflector/proc/rotate(mob/user)
	if (!can_rotate || admin)
		to_chat(user, span_warning(LANG("obj.1fabeebe0bb9f074", null)))
		return FALSE
	var/new_angle = tgui_input_number(user, LANG("obj.19bfb52d04bc5bf6", null), LANG("obj.edfa1be4f6498a3f", null), rotation_angle, 360)
	if(isnull(new_angle) || QDELETED(user) || QDELETED(src) || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return FALSE
	set_angle(SIMPLIFY_DEGREES(new_angle))
	return TRUE

//TYPES OF REFLECTORS, SINGLE, DOUBLE, BOX

//SINGLE

/obj/structure/reflector/single
	name = "reflector"
	deflector_icon_state = "reflector"
	desc = "An angled mirror for reflecting laser beams."
	density = TRUE
	finished = TRUE
	buildstacktype = /obj/item/stack/sheet/glass
	buildstackamount = 5

/obj/structure/reflector/single/anchored
	anchored = TRUE

/obj/structure/reflector/single/mapping
	admin = TRUE
	anchored = TRUE

/obj/structure/reflector/single/auto_reflect(obj/projectile/proj, pdir, turf/ploc, pangle)
	var/incidence = GET_ANGLE_OF_INCIDENCE(rotation_angle, (proj.angle + 180))
	if(abs(incidence) > 90 && abs(incidence) < 270)
		return FALSE
	var/new_angle = SIMPLIFY_DEGREES(rotation_angle + incidence)
	proj.set_angle_centered(loc, new_angle)
	return ..()

//DOUBLE

/obj/structure/reflector/double
	name = "double sided reflector"
	deflector_icon_state = "reflector_double"
	desc = "A double sided angled mirror for reflecting laser beams."
	density = TRUE
	finished = TRUE
	buildstacktype = /obj/item/stack/sheet/rglass
	buildstackamount = 10
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 10)

/obj/structure/reflector/double/anchored
	anchored = TRUE

/obj/structure/reflector/double/mapping
	admin = TRUE
	anchored = TRUE

/obj/structure/reflector/double/auto_reflect(obj/projectile/proj, pdir, turf/ploc, pangle)
	var/incidence = GET_ANGLE_OF_INCIDENCE(rotation_angle, (proj.angle + 180))
	var/new_angle = SIMPLIFY_DEGREES(rotation_angle + incidence)
	proj.forceMove(loc)
	proj.set_angle_centered(loc, new_angle)
	return ..()

//BOX

/obj/structure/reflector/box
	name = "reflector box"
	deflector_icon_state = "reflector_box"
	desc = "A box with an internal set of mirrors that reflects all laser beams in a single direction."
	density = TRUE
	finished = TRUE
	buildstacktype = /obj/item/stack/sheet/mineral/diamond
	buildstackamount = 1
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10, /datum/material/diamond = SHEET_MATERIAL_AMOUNT)

/obj/structure/reflector/box/anchored
	anchored = TRUE

/obj/structure/reflector/box/mapping
	admin = TRUE
	anchored = TRUE

/obj/structure/reflector/box/auto_reflect(obj/projectile/proj)
	proj.set_angle_centered(loc, rotation_angle)
	return ..()

/obj/structure/reflector/ex_act()
	if(admin)
		return FALSE
	return ..()

/obj/structure/reflector/singularity_act()
	if(admin)
		return
	else
		return ..()

//	USB

/obj/item/circuit_component/reflector
	display_name = "Reflector"
	desc = "Allows you to adjust the angle of a reflector."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL

	///angle the reflector will be set to at trigger unless locked
	var/datum/port/input/angle

	var/obj/structure/reflector/attached_reflector

/obj/item/circuit_component/reflector/populate_ports()
	angle = add_input_port("Angle", PORT_TYPE_NUMBER)

/obj/item/circuit_component/reflector/register_usb_parent(atom/movable/parent)
	. = ..()
	if(istype(parent, /obj/structure/reflector))
		attached_reflector = parent

/obj/item/circuit_component/reflector/unregister_usb_parent(atom/movable/parent)
	attached_reflector = null
	return ..()

/obj/item/circuit_component/reflector/input_received(datum/port/input/port)
	attached_reflector?.set_angle(angle.value)

// tgui menu

/obj/structure/reflector/ui_interact(mob/user, datum/tgui/ui)
	if(!finished)
		user.balloon_alert(user, LANG("obj.dead6374540925c6", null))
		return
	if(!can_rotate)
		user.balloon_alert(user, LANG("obj.e8f6efb5b84f5bbd", null))
		ui?.close()
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Reflector")
		ui.open()

/obj/structure/reflector/attack_robot(mob/user)
	ui_interact(user)
	return

/obj/structure/reflector/ui_state(mob/user)
	return GLOB.physical_state //Prevents borgs from adjusting this at range

/obj/structure/reflector/ui_data(mob/user)
	var/list/data = list()
	data["rotation_angle"] = rotation_angle
	data["reflector_name"] = name

	return data

/obj/structure/reflector/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("rotate")
			if (!can_rotate || admin)
				return FALSE
			var/new_angle = params["rotation_angle"]
			if(!isnull(new_angle))
				set_angle(SIMPLIFY_DEGREES(new_angle))
			return TRUE
		if("calculate")
			if (!can_rotate || admin)
				return FALSE
			var/new_angle = rotation_angle + params["rotation_angle"]
			if(!isnull(new_angle))
				set_angle(SIMPLIFY_DEGREES(new_angle))
			return TRUE

/obj/structure/reflector/wrenched

/obj/structure/reflector/wrenched/Initialize(mapload)
	. = ..()

	set_anchored(TRUE)
