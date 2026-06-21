/**Basic plumbing object.
* It doesn't really hold anything special, YET.
* Objects that are plumbing but not a subtype are as of writing liquid pumps and the reagent_dispenser tank
* Also please note that the plumbing component is toggled on and off by the component using a signal from default_unfasten_wrench, so dont worry about it
*/
/obj/machinery/plumbing
	name = "管状物"
	icon = 'icons/obj/pipes_n_cables/hydrochem/plumbers.dmi'
	icon_state = "pump"
	density = TRUE
	processing_flags = START_PROCESSING_MANUALLY
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 2.75
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	interaction_flags_machine = parent_type::interaction_flags_machine | INTERACT_MACHINE_OFFLINE
	reagents = /datum/reagents/plumbing

	///Plumbing machinery is always gonna need reagents, so we might aswell put it here
	var/buffer = 50
	///Flags for reagents, like INJECTABLE, TRANSPARENT bla bla everything thats in DEFINES/reagents.dm
	var/reagent_flags = TRANSPARENT | NO_REACT

/obj/machinery/plumbing/Initialize(mapload)
	. = ..()
	set_anchored(mapload)
	if(mapload)
		begin_processing()
	create_reagents(buffer, reagent_flags)
	AddElement(/datum/element/simple_rotation)
	register_context()

/obj/machinery/plumbing/create_reagents(max_vol, flags)
	if(!ispath(reagents))
		qdel(reagents)
	reagents = new reagents(max_vol, flags)
	reagents.my_atom = src

/obj/machinery/plumbing/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Unan" : "An"]chor"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_WELDER && !anchored)
		context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET
	else if(istype(held_item, /obj/item/plunger))
		context[SCREENTIP_CONTEXT_LMB] = "Flush"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/plumbing/examine(mob/user)
	. = ..()
	if(isobserver(user) || !in_range(src, user))
		return

	. += span_notice("最大容量显示为：<b>[reagents.maximum_volume]u 容量</b>。包含：")
	if(reagents.total_volume)
		for(var/datum/reagent/reg as anything in reagents.reagent_list)
			. += span_notice("[round(reg.volume, CHEMICAL_VOLUME_ROUNDING)]u 的 [reg.name]")
	else
		. += span_notice("空无一物。")

	if(anchored)
		. += span_notice("它已 [EXAMINE_HINT("anchored")] 就位。")
	else
		. += span_warning("需要 [EXAMINE_HINT("anchored")] 才能开始运作。")
		. += span_notice("它可以被 [EXAMINE_HINT("welded")] 拆开。")

	. += span_notice("可以用 [EXAMINE_HINT("plunger")] 来冲走试剂。")

/obj/machinery/plumbing/wrench_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE

	. = ITEM_INTERACT_BLOCKING
	if(default_unfasten_wrench(user, tool) == SUCCESSFUL_UNFASTEN)
		if(anchored)
			begin_processing()
		else
			end_processing()
		return ITEM_INTERACT_SUCCESS

/obj/machinery/plumbing/welder_act(mob/living/user, obj/item/I)
	if(user.combat_mode)
		return NONE

	if(anchored)
		balloon_alert(user, "先解除固定！")
		return ITEM_INTERACT_BLOCKING

	if(I.tool_start_check(user, amount = 1))
		to_chat(user, span_notice("你开始将 \the [src] 切开。"))
		if(I.use_tool(src, user, 1.5 SECONDS, volume = 50))
			deconstruct(TRUE)
			to_chat(user, span_notice("你将\the [src]切开了。"))
			return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/machinery/plumbing/plunger_act(obj/item/plunger/attacking_plunger, mob/living/user, reinforced)
	user.balloon_alert_to_viewers("furiously plunging...")
	if(!do_after(user, 3 SECONDS, target = src))
		return TRUE
	user.balloon_alert_to_viewers("finished plunging")
	reagents.expose(get_turf(src), TOUCH) //splash on the floor
	reagents.clear_reagents()
	return TRUE
