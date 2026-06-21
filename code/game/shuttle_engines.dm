#define ENGINE_UNWRENCHED 0
#define ENGINE_WRENCHED 1
#define ENGINE_WELDED 2
///How long it takes to weld/unweld an engine in place.
#define ENGINE_WELDTIME (20 SECONDS)

/obj/machinery/power/shuttle_engine
	name = "引擎"
	desc = "一种用于驱动穿梭机的蓝移引擎。"
	icon = 'icons/turf/shuttle.dmi'
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	smoothing_groups = SMOOTH_GROUP_SHUTTLE_PARTS
	armor_type = /datum/armor/power_shuttle_engine
	can_atmos_pass = ATMOS_PASS_DENSITY
	max_integrity = 500
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/engine

	///How well the engine affects the ship's speed.
	var/engine_power = 1
	///Construction state of the Engine.
	var/engine_state = ENGINE_WELDED //welding shmelding //i love welding //welding's the best

	///The mobile ship we are connected to.
	var/obj/docking_port/mobile/connected_ship = null

	var/static/list/connections = list(COMSIG_TURF_ADDED_TO_SHUTTLE = PROC_REF(on_turf_added_to_shuttle))

/datum/armor/power_shuttle_engine
	melee = 100
	bullet = 10
	laser = 10
	fire = 50
	acid = 70

/obj/machinery/power/shuttle_engine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/simple_rotation)
	register_context()
	if(!mapload)
		engine_state = ENGINE_UNWRENCHED
		anchored = FALSE

/obj/machinery/power/shuttle_engine/Destroy(force)
	if(engine_state == ENGINE_WELDED)
		alter_engine_power(-engine_power)
	unsync_ship()
	return ..()

/obj/machinery/power/shuttle_engine/on_construction(mob/user)
	. = ..()
	if(anchored)
		engine_state = ENGINE_WRENCHED
		connect_to_shuttle(port = SSshuttle.get_containing_shuttle(src)) //connect to a new ship, if needed
		if(isnull(connected_ship))
			AddElement(/datum/element/connect_loc, connections)

/obj/machinery/power/shuttle_engine/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	if(!port)
		return FALSE
	connected_ship = port
	connected_ship.engine_list += src
	if(mapload)
		connected_ship.initial_engine_power += engine_power
	if(engine_state == ENGINE_WELDED)
		alter_engine_power(engine_power)

/obj/machinery/power/shuttle_engine/examine(mob/user)
	. = ..()
	switch(engine_state)
		if(ENGINE_UNWRENCHED)
			. += span_notice("\The [src] 未用螺栓固定在地板上。需要用扳手将其固定在地板上才能完成安装。")
		if(ENGINE_WRENCHED)
			. += span_notice("\The [src] 已用螺栓固定在地板上，可以用扳手松开。需要将其焊接到地板上才能完成安装。")
		if(ENGINE_WELDED)
			. += span_notice("\The [src] 已焊接到地板上，可以将其焊开。目前它已完全安装完毕。")

/obj/machinery/power/shuttle_engine/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(held_item?.tool_behaviour == TOOL_WELDER && engine_state == ENGINE_WRENCHED)
		context[SCREENTIP_CONTEXT_LMB] = "Weld to Floor"
	if(held_item?.tool_behaviour == TOOL_WELDER && engine_state == ENGINE_WELDED)
		context[SCREENTIP_CONTEXT_LMB] = "Unweld from Floor"
	if(held_item?.tool_behaviour == TOOL_WRENCH && engine_state == ENGINE_UNWRENCHED)
		context[SCREENTIP_CONTEXT_LMB] = "Wrench to Floor"
	if(held_item?.tool_behaviour == TOOL_WRENCH && engine_state == ENGINE_WRENCHED)
		context[SCREENTIP_CONTEXT_LMB] = "Unwrench from Floor"
	return CONTEXTUAL_SCREENTIP_SET

/**
 * Called on destroy and when we need to unsync an engine from their ship.
 */
/obj/machinery/power/shuttle_engine/proc/unsync_ship()
	if(connected_ship)
		connected_ship.engine_list -= src
		connected_ship = null
	RemoveElement(/datum/element/connect_loc, connections)

//Ugh this is a lot of copypasta from emitters, welding need some boilerplate reduction
/obj/machinery/power/shuttle_engine/can_be_unfasten_wrench(mob/user, silent)
	if(engine_state == ENGINE_WELDED)
		if(!silent)
			to_chat(user, span_warning("[src]被焊接在了地板上！"))
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/power/shuttle_engine/default_unfasten_wrench(mob/user, obj/item/tool, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		if(anchored)
			connect_to_shuttle(port = SSshuttle.get_containing_shuttle(src)) //connect to a new ship, if needed
			if(isnull(connected_ship))
				AddElement(/datum/element/connect_loc, connections)
			engine_state = ENGINE_WRENCHED
		else
			unsync_ship() //not part of the ship anymore
			engine_state = ENGINE_UNWRENCHED

/obj/machinery/power/shuttle_engine/proc/on_turf_added_to_shuttle(turf/source, obj/docking_port/mobile/port)
	SIGNAL_HANDLER
	connect_to_shuttle(port = port)

/obj/machinery/power/shuttle_engine/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/shuttle_engine/welder_act(mob/living/user, obj/item/tool)
	. = ..()
	switch(engine_state)
		if(ENGINE_UNWRENCHED)
			to_chat(user, span_warning("\The [src] 需要用扳手固定在地板上！"))
		if(ENGINE_WRENCHED)
			if(!tool.tool_start_check(user, heat_required = HIGH_TEMPERATURE_REQUIRED))
				return TRUE

			user.visible_message(span_notice("[user.name] 开始将 \the [src] 焊接到地板上。"), \
				span_notice("你开始将\the [src]焊接到地板上..."), \
				span_hear("You hear welding."))

			if(tool.use_tool(src, user, ENGINE_WELDTIME, volume = 50))
				engine_state = ENGINE_WELDED
				to_chat(user, span_notice("你将\the [src]焊接到地板上。"))
				alter_engine_power(engine_power)

		if(ENGINE_WELDED)
			if(!tool.tool_start_check(user, heat_required = HIGH_TEMPERATURE_REQUIRED))
				return TRUE

			user.visible_message(span_notice("[user.name]开始将\the [src]从地板上切割下来。"), \
				span_notice("你开始将\the [src]从地板上切割下来..."), \
				span_hear("You hear welding."))

			if(tool.use_tool(src, user, ENGINE_WELDTIME, volume = 50))
				engine_state = ENGINE_WRENCHED
				to_chat(user, span_notice("你将\the [src]从地板上切割下来。"))
				alter_engine_power(-engine_power)
	return TRUE

//Propagates the change to the shuttle.
/obj/machinery/power/shuttle_engine/proc/alter_engine_power(mod)
	if(mod && connected_ship)
		connected_ship.alter_engines(mod)

/obj/machinery/power/shuttle_engine/heater
	name = "引擎加热器"
	desc = "将能量导向压缩粒子以为引擎提供动力。"
	icon_state = "heater"
	circuit = /obj/item/circuitboard/machine/engine/heater
	engine_power = 0 // todo make these into 2x1 parts

/obj/machinery/power/shuttle_engine/propulsion
	name = "推进引擎"
	icon_state = "propulsion"
	desc = "一种标准可靠的蓝空间引擎，被多种穿梭艇使用。"
	circuit = /obj/item/circuitboard/machine/engine/propulsion
	opacity = TRUE

/obj/machinery/power/shuttle_engine/propulsion/left
	name = "左侧推进引擎"
	icon_state = "propulsion_l"

/obj/machinery/power/shuttle_engine/propulsion/right
	name = "右侧推进引擎"
	icon_state = "propulsion_r"

/obj/machinery/power/shuttle_engine/propulsion/burst
	name = "爆发引擎"
	desc = "一种通过释放大量蓝空间爆发来推进的引擎。"

/obj/machinery/power/shuttle_engine/propulsion/burst/left
	name = "左侧爆发引擎"
	icon_state = "burst_l"

/obj/machinery/power/shuttle_engine/propulsion/burst/right
	name = "右侧爆发引擎"
	icon_state = "burst_r"

/obj/machinery/power/shuttle_engine/large
	name = "引擎"
	icon = 'icons/obj/fluff/2x2.dmi'
	icon_state = "large_engine"
	desc = "一个非常庞大的蓝空间引擎，用于推进非常庞大的飞船。"
	circuit = null
	opacity = TRUE
	bound_width = 64
	bound_height = 64
	appearance_flags = LONG_GLIDE

/obj/machinery/power/shuttle_engine/huge
	name = "引擎"
	icon = 'icons/obj/fluff/3x3.dmi'
	icon_state = "huge_engine"
	desc = "一个极其庞大的蓝空间引擎，用于推进极其庞大的飞船。"
	circuit = null
	opacity = TRUE
	bound_width = 96
	bound_height = 96
	appearance_flags = LONG_GLIDE

#undef ENGINE_UNWRENCHED
#undef ENGINE_WRENCHED
#undef ENGINE_WELDED
#undef ENGINE_WELDTIME
