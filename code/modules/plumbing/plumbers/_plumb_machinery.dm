// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**Basic plumbing object.
* It doesn't really hold anything special, YET.
* Objects that are plumbing but not a subtype are as of writing liquid pumps and the reagent_dispenser tank
* Also please note that the plumbing component is toggled on and off by the component using a signal from default_unfasten_wrench, so dont worry about it
*/
/obj/machinery/plumbing
	name = "pipe thing"
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

	. += span_notice(LANG("obj.788bb1064cd758d0", list(reagents.maximum_volume)))
	if(reagents.total_volume)
		for(var/datum/reagent/reg as anything in reagents.reagent_list)
			. += span_notice(LANG("obj.d353620de6ca6337", list(round(reg.volume, CHEMICAL_VOLUME_ROUNDING), reg.name)))
	else
		. += span_notice(LANG("obj.aa75d1565980cc59", null))

	if(anchored)
		. += span_notice(LANG("obj.7641f909d43c346d", list(EXAMINE_HINT("anchored"))))
	else
		. += span_warning(LANG("obj.41f513549c79a917", list(EXAMINE_HINT("anchored"))))
		. += span_notice(LANG("obj.fa5fc7965e12e9d0", list(EXAMINE_HINT("welded"))))

	. += span_notice(LANG("obj.02b50ffa4d4fa614", list(EXAMINE_HINT("plunger"))))

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
		balloon_alert(user, LANG("obj.3e9391607cda6ee1", null))
		return ITEM_INTERACT_BLOCKING

	if(I.tool_start_check(user, amount = 1))
		to_chat(user, span_notice(LANG("obj.789a7181a99ade4d", list(src))))
		if(I.use_tool(src, user, 1.5 SECONDS, volume = 50))
			deconstruct(TRUE)
			to_chat(user, span_notice(LANG("obj.54e5a2bb7dba2176", list(src))))
			return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/machinery/plumbing/plunger_act(obj/item/plunger/attacking_plunger, mob/living/user, reinforced)
	user.balloon_alert_to_viewers(LANG("obj.6051e050a7898871", null))
	if(!do_after(user, 3 SECONDS, target = src))
		return TRUE
	user.balloon_alert_to_viewers(LANG("obj.670c9c2c9c8b5fe6", null))
	reagents.expose(get_turf(src), TOUCH) //splash on the floor
	reagents.clear_reagents()
	return TRUE
