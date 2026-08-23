// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define WINDOOR_LEFT "l"
#define WINDOOR_RIGHT "r"

/obj/structure/windoor_assembly
	icon = 'icons/obj/doors/windoor.dmi'

	name = "windoor Assembly"
	icon_state = "l_windoor_assembly01"
	desc = "A small glass and wire assembly for windoors."
	anchored = FALSE
	density = FALSE
	dir = NORTH
	obj_flags = CAN_BE_HIT | BLOCKS_CONSTRUCTION_DIR | UNIQUE_RENAME | RENAME_NO_DESC
	set_dir_on_move = FALSE
	can_atmos_pass = ATMOS_PASS_PROC
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 5, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5)

	/// Reference to the airlock electronics inside for determining window access.
	var/obj/item/electronics/airlock/electronics = null
	/// Player generated name string from renaming.
	var/created_name = null

	//Vars to help with the icon's name
	///Does the windoor open to the left or right?
	var/facing = WINDOOR_LEFT
	///Whether or not this creates a secure windoor
	var/secure = FALSE
	/**
	  * Windoor (window door) assembly -Nodrak      ----------- with comments clarifying what's actually happening, and how we know what step we're on
	  * Step 1: Create a windoor out of rglass                                       -no variables modified. Destroy via welder
	  * Step 2: Add r-glass to the assembly to make a secure windoor (Optional)      -tracked by secure, can be done anytime before cables_added is TRUE. Cannot be undone
	  * Step 3: Rotate or Flip the assembly to face and open the way you want        -tracked by facing, can be done any time before anchoring via wrench right click
	  * Step 4: Wrench the assembly in place                                         -tracked by anchored, no requisites, undone with wrench as well if cabling not yet inserted
	  * Step 5: Add cables to the assembly									         -tracked by cables_added, requires being anchored, undoable with wirecutters with no requisites until full completion
	  * Step 6: Set access for the door.                                             -tracked by electronics, requires cabling to install electronics, undoable with screwdriver requiring cabling to remain
	  * Step 7: Crowbar the door to complete                                         -requires cabling & electronics, not undoable. obviously.
	 */

	var/cables_added = FALSE


/obj/structure/windoor_assembly/Initialize(mapload, set_dir)
	. = ..()
	if(set_dir)
		setDir(set_dir)
	air_update_turf(TRUE, TRUE)

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)

	AddElement(/datum/element/connect_loc, loc_connections)
	AddElement(/datum/element/simple_rotation, ROTATION_NEEDS_ROOM)

/obj/structure/windoor_assembly/Destroy()
	set_density(FALSE)
	air_update_turf(TRUE, FALSE)
	return ..()

/obj/structure/windoor_assembly/Move()
	var/turf/T = loc
	. = ..()
	move_update_air(T)

/obj/structure/windoor_assembly/update_icon_state()
	icon_state = "[facing]_[secure ? "secure_" : ""]windoor_assembly[cables_added ? "02" : "01"]"
	return ..()

/obj/structure/windoor_assembly/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()

	if(border_dir == dir)
		return

	if(istype(mover, /obj/structure/window))
		var/obj/structure/window/moved_window = mover
		return valid_build_direction(loc, moved_window.dir, is_fulltile = moved_window.fulltile)

	if(istype(mover, /obj/structure/windoor_assembly) || istype(mover, /obj/machinery/door/window))
		return valid_build_direction(loc, mover.dir, is_fulltile = FALSE)

/obj/structure/windoor_assembly/can_atmos_pass(turf/T, vertical = FALSE)
	if(get_dir(loc, T) == dir)
		return !density
	else
		return TRUE

/obj/structure/windoor_assembly/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving.movement_type & PHASING)
		return

	if(leaving == src)
		return // Let's not block ourselves.

	if (leaving.pass_flags & pass_flags_self)
		return

	if (direction == dir && density)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/windoor_assembly/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	//I really should have spread this out across more states but thin little windoors are hard to sprite.
	add_fingerprint(user)
	if(!cables_added)
		//Adding plasteel makes the assembly a secure windoor assembly. Step 2 (optional) complete.
		if(istype(tool, /obj/item/stack/sheet/plasteel) && !secure)
			var/obj/item/stack/sheet/plasteel/reinforcement = tool
			if(reinforcement.get_amount() < 2)
				to_chat(user, span_warning(LANG("obj.d0ad9de358fda04e", null)))
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_notice(LANG("obj.8042a31e3fca1d03", null)))

			if(!do_after(user, 4 SECONDS, target = src))
				return ITEM_INTERACT_BLOCKING

			if(!src || secure || reinforcement.get_amount() < 2)
				return ITEM_INTERACT_BLOCKING

			reinforcement.use(2)
			to_chat(user, span_notice(LANG("obj.ba48339d974d29f2", null)))
			secure = TRUE
			if(anchored)
				name = "secure anchored windoor assembly"
			else
				name = "secure windoor assembly"
			update_appearance()
			return ITEM_INTERACT_SUCCESS

		//Adding cable to the assembly. Step 5 complete.
		if(istype(tool, /obj/item/stack/cable_coil) && anchored)
			user.visible_message(span_notice(LANG("obj.2bd6d78586d43c7b", list(user))), span_notice(LANG("obj.e8308e6da25f1e5a", null)))

			if(!do_after(user, 4 SECONDS, target = src))
				return ITEM_INTERACT_BLOCKING

			if(!anchored || cables_added)
				return ITEM_INTERACT_BLOCKING

			var/obj/item/stack/cable_coil/wiring = tool
			if(!wiring.use(1))
				to_chat(user, span_warning(LANG("obj.bc76c590ac48b662", null)))
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_notice(LANG("obj.d99b42df6e624a1a", null)))
			cables_added = TRUE
			if(secure)
				name = "secure wired windoor assembly"
			else
				name = "wired windoor assembly"
			update_appearance()
			return ITEM_INTERACT_SUCCESS

		return NONE

	//cables_added TRUE beyond this point

	//Adding airlock electronics for access. Step 6 complete.
	if(istype(tool, /obj/item/electronics/airlock))

		tool.play_tool_sound(src, 100)
		user.visible_message(span_notice(LANG("obj.1dc6640c2caf0f95", list(user))),
							span_notice(LANG("obj.fb1066e61a51ca9e", null)))

		if(!do_after(user, 4 SECONDS, target = src))
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		if(!src || electronics)
			tool.forceMove(drop_location())
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.2b65dc1211c06809", null)))
		name = "near finished windoor assembly"
		electronics = tool
		return ITEM_INTERACT_SUCCESS

	return NONE

//dissasemble entirely unworked assembly
/obj/structure/windoor_assembly/welder_act(mob/living/user, obj/item/tool)
	if(cables_added)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(!anchored)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(!tool.tool_start_check(user, amount=1))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice(LANG("obj.191a39045c3fe552", list(user))),
						span_notice(LANG("obj.88c5f1a0d49aa8d5", null)))

	if(!tool.use_tool(src, user, 4 SECONDS, volume = 50))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.e595521901309aeb", null)))
	var/obj/item/stack/sheet/rglass/dropped_glass = new (get_turf(src), 5)
	if(!QDELETED(dropped_glass))
		dropped_glass.add_fingerprint(user)
	if(secure)
		var/obj/item/stack/rods/dropped_rods = new (get_turf(src), 4)
		if(!QDELETED(dropped_rods))
			dropped_rods.add_fingerprint(user)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

//secure or unsecure unworked assembly
/obj/structure/windoor_assembly/wrench_act(mob/living/user, obj/item/tool)
	if(cables_added)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(!anchored)
		for(var/obj/machinery/door/window/competitor in loc)
			if(competitor.dir == dir)
				to_chat(user, span_warning(LANG("obj.b9e2eb2cc4acfca4", null)))
				return ITEM_INTERACT_BLOCKING

		user.visible_message(span_notice(LANG("obj.49b00f4efcfac2ce", list(user))),
							span_notice(LANG("obj.b5c22584d660b783", null)))
		if(!tool.use_tool(src, user, 4 SECONDS, volume=100))
			return ITEM_INTERACT_BLOCKING

		if(anchored)
			return ITEM_INTERACT_BLOCKING

		for(var/obj/machinery/door/window/competitor in loc)
			if(competitor.dir == dir)
				to_chat(user, span_warning(LANG("obj.b9e2eb2cc4acfca4", null)))
				return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.feaf53d7063a74b2", null)))
		set_anchored(TRUE)
		if(secure)
			name = "secure anchored windoor assembly"
		else
			name = "anchored windoor assembly"
		return ITEM_INTERACT_SUCCESS

	//Unwrenching an unsecure assembly un-anchors it. Step 4 undone
	user.visible_message(span_notice(LANG("obj.b8259a4ac836e1b9", list(user))),
						span_notice(LANG("obj.b3d125dabf52f537", null)))

	if(!tool.use_tool(src, user, 4 SECONDS, volume=100))
		return ITEM_INTERACT_BLOCKING
	if(!anchored)
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.f8d3bc8f28ce4fed", null)))
	set_anchored(FALSE)
	if(secure)
		name = "secure windoor assembly"
	else
		name = "windoor assembly"
	return ITEM_INTERACT_SUCCESS

//Flips the windoor assembly, determines whether the door opens to the left or the right
/obj/structure/windoor_assembly/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(anchored)
		return NONE
	if(facing == WINDOOR_LEFT)
		to_chat(usr, span_notice(LANG("obj.450e75fd01e78c6a", null)))
		facing = WINDOOR_RIGHT
	else
		facing = WINDOOR_LEFT
		to_chat(usr, span_notice(LANG("obj.a3cf90b7ec445e1b", null)))

	update_appearance()
	return ITEM_INTERACT_SUCCESS

//remove cabling
/obj/structure/windoor_assembly/wirecutter_act(mob/living/user, obj/item/tool)
	if(!cables_added)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	user.visible_message(span_notice(LANG("obj.bf1d728fc5ac0288", list(user))), \
						span_notice(LANG("obj.345e875949792065", null)))
	if(!tool.use_tool(src, user, 4 SECONDS, volume=100))
		return ITEM_INTERACT_BLOCKING

	if(!cables_added)
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.048e7ef767df48c9", null)))
	new/obj/item/stack/cable_coil(get_turf(user), 1)
	cables_added = FALSE
	if(secure)
		name = "secure anchored windoor assembly"
	else
		name = "anchored windoor assembly"
	update_appearance()
	return ITEM_INTERACT_SUCCESS

//remove airlock electronics
/obj/structure/windoor_assembly/screwdriver_act(mob/living/user, obj/item/tool)
	if(!cables_added)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(!electronics)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	user.visible_message(span_notice(LANG("obj.a05c355a0fbc637e", list(user))),
						span_notice(LANG("obj.e494d3b2a3374337", null)))

	if(!tool.use_tool(src, user, 4 SECONDS, volume=100) && electronics)
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.a5dac4b826ccd223", null)))
	name = "wired windoor assembly"
	var/obj/item/electronics/airlock/scrap
	scrap = electronics
	electronics = null
	scrap.forceMove(drop_location())
	return ITEM_INTERACT_SUCCESS

//finishes door
/obj/structure/windoor_assembly/crowbar_act(mob/living/user, obj/item/tool)
	if(!cables_added)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(!electronics)
		to_chat(usr, span_warning(LANG("obj.0098cf0367eb3c29", null)))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice(LANG("obj.a78577a68f8e85b6", list(user))),
						span_notice(LANG("obj.84e887db531622d9", null)))

	if(!tool.use_tool(src, user, 4 SECONDS, volume=100) || !electronics)
		return ITEM_INTERACT_BLOCKING
	set_density(TRUE) //Shouldn't matter but just incase <-- in case what?
	to_chat(user, span_notice(LANG("obj.640bb6ba46266669", null)))
	finish_door()
	return ITEM_INTERACT_SUCCESS

/obj/structure/windoor_assembly/examine(mob/user)
	. = ..()
	if(!anchored)
		. += span_notice(LANG("obj.a7438b4a3bcfb8e7", list(src, span_boldnotice("wrenched"))))
		. += span_notice(LANG("obj.df3132c2178c983f", list(src, span_boldnotice("cut apart"), span_boldnotice("welder"))))
		return .

	if(!cables_added)
		. += span_notice(LANG("obj.c884d56af0a83232", list(src, span_boldnotice("wiring"), span_boldnotice("un-wrenched"))))
		return .

	if(!electronics)
		. += span_notice(LANG("obj.8a016b759b07cc4f", list(src, span_boldnotice("airlock electronics"), span_boldnotice("wirecutters"))))
		return .

	. += span_notice(LANG("obj.8289058c3c1d4edd", list(src, span_boldnotice("levered"), span_boldnotice("crowbar"))))

/obj/structure/windoor_assembly/proc/finish_door()
	var/obj/machinery/door/window/windoor
	if(secure)
		windoor = new /obj/machinery/door/window/brigdoor(loc)
		if(facing == WINDOOR_LEFT)
			windoor.icon_state = "leftsecureopen"
			windoor.base_state = "leftsecure"
		else
			windoor.icon_state = "rightsecureopen"
			windoor.base_state = "rightsecure"

	else
		windoor = new /obj/machinery/door/window(loc)
		if(facing == WINDOOR_LEFT)
			windoor.icon_state = "leftopen"
			windoor.base_state = "left"
		else
			windoor.icon_state = "rightopen"
			windoor.base_state = "right"

	windoor.setDir(dir)
	windoor.set_density(FALSE)
	if(created_name)
		windoor.name = created_name
	else if(electronics.passed_name)
		windoor.name = sanitize(electronics.passed_name)
	if(electronics.one_access)
		windoor.req_one_access = electronics.accesses
	else
		windoor.req_access = electronics.accesses
	if(electronics.unres_sides)
		windoor.unres_sides = electronics.unres_sides
		switch(dir)
			if(NORTH,SOUTH)
				windoor.unres_sides &= ~EAST
				windoor.unres_sides &= ~WEST
			if(EAST,WEST)
				windoor.unres_sides &= ~NORTH
				windoor.unres_sides &= ~SOUTH
		windoor.unres_latch = TRUE
	electronics.forceMove(windoor)
	windoor.electronics = electronics
	windoor.autoclose = TRUE
	windoor.close()
	windoor.update_appearance()

	qdel(src)


//Flips the windoor assembly, determines whather the door opens to the left or the right
GAME_VERB_SRC(/obj/structure/windoor_assembly, flip, oview(1), "翻转窗门组件", null)

	if(IS_UNCONSCIOUS_OR_CRIT(usr) || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_USE))
			return

	if(facing == "l")
		to_chat(usr, span_notice(LANG("obj.450e75fd01e78c6a", null)))
		facing = "r"
	else
		facing = "l"
		to_chat(usr, span_notice(LANG("obj.a3cf90b7ec445e1b", null)))

	update_appearance()
	return

/obj/structure/windoor_assembly/nameformat(input, user)
	created_name = input
	return input

/obj/structure/windoor_assembly/rename_reset()
	created_name = initial(created_name)

#undef WINDOOR_LEFT
#undef WINDOOR_RIGHT
