// Disposal pipe construction
// This is the pipe that you drag around, not the attached ones.

/obj/structure/disposalconstruct
	name = "废物处理管道段"
	desc = "用于建造废物处理系统的巨大管道段。"
	icon = 'icons/obj/pipes_n_cables/disposal.dmi'
	icon_state = "conpipe"
	anchored = FALSE
	density = FALSE
	pressure_resistance = 5*ONE_ATMOSPHERE
	max_integrity = 200
	var/obj/pipe_type = /obj/structure/disposalpipe/segment
	var/pipename

/obj/structure/disposalconstruct/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return
	set_density(anchorvalue ? initial(pipe_type.density) : FALSE)

/obj/structure/disposalconstruct/Initialize(mapload, _pipe_type, _dir = SOUTH, flip = FALSE, obj/make_from)
	. = ..()
	if(make_from)
		pipe_type = make_from.type
		setDir(make_from.dir)
		set_anchored(TRUE)

	else
		if(_pipe_type)
			pipe_type = _pipe_type
		setDir(_dir)

	pipename = initial(pipe_type.name)

	AddElement(/datum/element/simple_rotation, post_rotation_proccall = PROC_REF(post_rotation))
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

	// this only gets used by pipes created by RPDs or pipe dispensers
	if(flip)
		// Rotate, bypassing simple_rotation for 180 degrees at once
		setDir(turn(dir, ROTATION_FLIP))
		post_rotation(usr, ROTATION_FLIP)

	update_appearance(UPDATE_ICON)

/obj/structure/disposalconstruct/Move()
	var/old_dir = dir
	..()
	setDir(old_dir) //pipes changing direction when moved is just annoying and buggy

/obj/structure/disposalconstruct/update_icon_state()
	if(ispath(pipe_type, /obj/machinery/disposal/bin))
		// Disposal bins receive special icon treating
		icon_state = "[anchored ? "con" : null]disposal"
		return ..()

	icon_state = "[is_pipe() ? "con" : null][initial(pipe_type.icon_state)]"
	return ..()

// Extra layer handling
/obj/structure/disposalconstruct/update_icon()
	. = ..()
	if(!is_pipe())
		return

	layer = anchored ? initial(pipe_type.layer) : initial(layer)

/obj/structure/disposalconstruct/proc/get_disposal_dir()
	if(!is_pipe())
		return NONE

	var/obj/structure/disposalpipe/temp = pipe_type
	var/initialize_dirs = initial(temp.initialize_dirs)
	var/dpdir = NONE

	if(ISDIAGONALDIR(dir)) // Bent pipes
		return dir

	if(initialize_dirs != DISP_DIR_NONE)
		dpdir = dir

		if(initialize_dirs & DISP_DIR_LEFT)
			dpdir |= turn(dir, 90)
		if(initialize_dirs & DISP_DIR_RIGHT)
			dpdir |= turn(dir, -90)
		if(initialize_dirs & DISP_DIR_FLIP)
			dpdir |= REVERSE_DIR(dir)
	return dpdir

/obj/structure/disposalconstruct/proc/post_rotation(mob/user, degrees)
	if(degrees == ROTATION_FLIP)
		var/obj/structure/disposalpipe/temp = pipe_type
		if(initial(temp.flip_type))
			if(ISDIAGONALDIR(dir)) // Fix RPD-induced diagonal turning
				setDir(turn(dir, 45))
			pipe_type = initial(temp.flip_type)
	update_appearance()


// construction/deconstruction
// wrench: (un)anchor
// weldingtool: convert to real pipe
/obj/structure/disposalconstruct/wrench_act(mob/living/user, obj/item/I)
	..()
	if(anchored)
		set_anchored(FALSE)
		to_chat(user, span_notice("你将 [pipename] 从地板下拆下。"))
	else
		var/ispipe = is_pipe() // Indicates if we should change the level of this pipe

		var/turf/T = get_turf(src)
		if(T.underfloor_accessibility < UNDERFLOOR_INTERACTABLE && isfloorturf(T))
			var/obj/item/crowbar/held_crowbar = user.is_holding_tool_quality(TOOL_CROWBAR)
			if(!held_crowbar || !T.crowbar_act(user, held_crowbar))
				to_chat(user, span_warning("只有在移除地板板材后，你才能安装 [pipename]！"))
				return TRUE

		if(!ispipe && iswallturf(T))
			to_chat(user, span_warning("你不能在墙上建造 [pipename]，只能建造废物处理管道！"))
			return TRUE

		if(ispipe)
			var/dpdir = get_disposal_dir()
			for(var/obj/structure/disposalpipe/CP in T)
				var/pdir = CP.dpdir
				if(istype(CP, /obj/structure/disposalpipe/broken))
					pdir = CP.dir
				if(pdir & dpdir)
					if(istype(CP, /obj/structure/disposalpipe/broken))
						qdel(CP)
					else
						to_chat(user, span_warning("该位置已有一个废物处理管道！"))
						return TRUE

		else // Disposal or outlet
			var/found_trunk = locate(/obj/structure/disposalpipe/trunk) in T

			if(!found_trunk)
				to_chat(user, span_warning("[pipename] 需要下方有一个主干管道才能工作！"))
				return TRUE

		set_anchored(TRUE)
		to_chat(user, span_notice("你将 [pipename] 安装到地板下。"))
	I.play_tool_sound(src, 100)
	update_appearance()
	return TRUE

/obj/structure/disposalconstruct/welder_act(mob/living/user, obj/item/I)
	..()
	if(anchored)
		var/turf/T = get_turf(src)
		if(!is_pipe() && ((locate(/obj/machinery/disposal) in T) || ((locate(/obj/structure/disposaloutlet) in T))))
			to_chat(user, span_warning("此处已有一个废物处理机器！"))
			return TRUE

		if(!I.tool_start_check(user, amount=1, heat_required = HIGH_TEMPERATURE_REQUIRED))
			return TRUE

		to_chat(user, span_notice("你开始将 [pipename] 焊接就位..."))
		if(I.use_tool(src, user, 8, volume=50))
			to_chat(user, span_notice("[pipename] 已被焊接就位。"))
			var/obj/O = new pipe_type(loc, src)
			transfer_fingerprints_to(O)

	else
		to_chat(user, span_warning("你需要先将其固定到板材上！"))
	return TRUE

/obj/structure/disposalconstruct/proc/is_pipe()
	return ispath(pipe_type, /obj/structure/disposalpipe)

//helper proc that makes sure you can place the construct (i.e no dense objects stacking)
/obj/structure/disposalconstruct/proc/can_place()
	if(is_pipe())
		return TRUE

	for(var/obj/structure/disposalconstruct/DC in get_turf(src))
		if(DC == src)
			continue

		if(!DC.is_pipe()) //there's already a chute/outlet/bin there
			return FALSE

	return TRUE
