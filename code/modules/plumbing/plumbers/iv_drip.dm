///modified IV that can be anchored and takes plumbing in- and output
/obj/machinery/iv_drip/plumbing
	name = "自动静脉滴注器"
	desc = "一种带有管道连接的改良静脉滴注器。从连接处接收的试剂直接注入其血液中，抽取的血液则进入内部储存器，然后流入管道。"
	icon_state = "plumb"
	base_icon_state = "plumb"
	density = TRUE
	use_internal_storage = TRUE
	subsystem_type = /datum/controller/subsystem/processing/plumbing
	processing_flags = START_PROCESSING_MANUALLY

/obj/machinery/iv_drip/plumbing/Initialize(mapload, layer)
	. = ..()
	if(mapload)
		begin_processing()
	AddComponent(/datum/component/plumbing/automated_iv, layer)
	AddElement(/datum/element/simple_rotation)

/obj/machinery/iv_drip/plumbing/quick_toggle(mob/living/user)
	return FALSE

/obj/machinery/iv_drip/plumbing/click_alt(mob/user)
	return NONE

/obj/machinery/iv_drip/plumbing/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(isnull(held_item) || held_item.tool_behaviour != TOOL_WRENCH)
		return
	context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Una" : "A"]nchor"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/iv_drip/plumbing/plunger_act(obj/item/plunger/attacking_plunger, mob/living/user, reinforced)
	user.balloon_alert_to_viewers("furiously plunging...", "plunging iv drip...")
	if(!do_after(user, 3 SECONDS, target = src))
		return TRUE
	user.balloon_alert_to_viewers("finished plunging")
	reagents.expose(get_turf(src), TOUCH) //splash on the floor
	reagents.clear_reagents()
	return TRUE

/obj/machinery/iv_drip/plumbing/wrench_act(mob/living/user, obj/item/tool)
	if(default_unfasten_wrench(user, tool) != SUCCESSFUL_UNFASTEN)
		return ITEM_INTERACT_BLOCKING
	if(anchored)
		begin_processing()
	else
		end_processing()
	return ITEM_INTERACT_SUCCESS
