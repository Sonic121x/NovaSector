///Sound played when boulders are teleported manually by hand
#define MANUAL_TELEPORT_SOUND 'sound/machines/mining/manual_teleport.ogg'
///Sound played when boulders are teleported automatically in process()
#define AUTO_TELEPORT_SOUND 'sound/machines/mining/auto_teleport.ogg'
///Time taken to spawn a boulder, also the cooldown applied before the next manual teleportation
#define TELEPORTATION_TIME (1.5 SECONDS)
///Cooldown for automatic teleportation after processing boulders_processing_max number of boulders
#define BATCH_COOLDOWN (3 SECONDS)
///Special case when we are trying to teleport a boulder but there is already another boulder in our loc
#define TURF_BLOCKED_BY_BOULDER -1

/obj/machinery/brm
	name = "岩石回收矩阵"
	desc = "一种传送矩阵，用于从矿脉喷口回收由采矿节点挖掘出的巨石。"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "brm"
	base_icon_state = "brm"
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.5
	circuit = /obj/item/circuitboard/machine/brm
	processing_flags = START_PROCESSING_MANUALLY
	anchored = TRUE
	density = TRUE

	/// How many boulders can we process maximum per loop?
	var/boulders_processing_max = 1
	/// Are we trying to actively collect boulders automatically?
	var/toggled_on = FALSE
	///Have we finished processing a full batch of boulders
	var/batch_processing = FALSE

	/// Cooldown used for left click teleportation.
	COOLDOWN_DECLARE(manual_teleport_cooldown)
	/// Cooldown used for automatic teleportation after processing boulders_processing_max number of boulders.
	COOLDOWN_DECLARE(batch_start_cooldown)
	// NOVA EDIT ADDITION START
	/// Defines which areas this machine is allowed to operate. By default only the station but done this way in case its needed to be varedited by an admin. DO NOT ALLOW THIS FOR THE GHOST ROLES.
	var/static/list/allowed_areas_to_work = typecacheof(list(
		/area/station,
		/area/mine,
	))
	// NOVA EDIT ADDITION END

/obj/machinery/brm/Initialize(mapload)
	. = ..()
	register_context()

/obj/machinery/brm/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE

	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Teleport single boulder"
		context[SCREENTIP_CONTEXT_RMB] = "Toggle [toggled_on ? "Off" : "On"] automatic boulder retrieval"
		return CONTEXTUAL_SCREENTIP_SET

	if(!isnull(held_item))
		if(held_item.tool_behaviour == TOOL_WRENCH)
			context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Unan" : "An"]chor"
			return CONTEXTUAL_SCREENTIP_SET
		else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
			context[SCREENTIP_CONTEXT_LMB] = "[panel_open ? "Close" : "Open"] panel"
			return CONTEXTUAL_SCREENTIP_SET
		else if(panel_open && held_item.tool_behaviour == TOOL_CROWBAR)
			context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
			return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/brm/examine(mob/user)
	. = ..()
	. += span_notice("小屏幕上显示有[span_boldnotice("[SSore_generation.available_boulders.len] boulders")]可供传送。")
	. += span_notice("一次最多可收集<b>[boulders_processing_max] 块</b>巨石。")
	. += span_notice("Automatic boulder retrieval can be toggled [EXAMINE_HINT("[toggled_on ? "关闭" : "On"]")] with [EXAMINE_HINT("Right Click")].")

	if(anchored)
		. += span_notice("它已[EXAMINE_HINT("anchored")]就位。")
	else
		. += span_warning("需要[EXAMINE_HINT("anchored")]才能开始操作。")

	. += span_notice("Its maintenance panel can be [EXAMINE_HINT("screwed")] [panel_open ? "closed" : "open"].")

	if(panel_open)
		. += span_notice("The whole machine can be [EXAMINE_HINT("pried")] apart.")

/obj/machinery/brm/update_icon_state()
	icon_state = base_icon_state

	if(!anchored || !is_operational || machine_stat & (BROKEN | NOPOWER) || panel_open)
		icon_state = "[icon_state]-off"
		return

	if(toggled_on)
		icon_state = "[icon_state]-toggled"
		return

	return ..()

/obj/machinery/brm/wrench_act(mob/living/user, obj/item/tool)
	. = ITEM_INTERACT_BLOCKING
	if(default_unfasten_wrench(user, tool, time = 1.5 SECONDS) == SUCCESSFUL_UNFASTEN)
		update_appearance(UPDATE_ICON_STATE)
		return ITEM_INTERACT_SUCCESS

/obj/machinery/brm/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/brm/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

///To allow boulders on a conveyor belt to move unobstructed if multiple machines are made on a single line
/obj/machinery/brm/CanAllowThrough(atom/movable/mover, border_dir)
	if(!anchored)
		return FALSE
	if(istype(mover, /obj/item/boulder))
		return TRUE
	return ..()

/obj/machinery/brm/RefreshParts()
	. = ..()

	boulders_processing_max = 0
	for(var/datum/stock_part/part in component_parts)
		boulders_processing_max += part.tier

	boulders_processing_max = ROUND_UP((boulders_processing_max / 12) * 7)

/obj/machinery/brm/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || panel_open)
		return
	if(!handle_teleport_conditions(user))
		return

	var/result = pre_collect_boulder()
	if(result == TURF_BLOCKED_BY_BOULDER)
		balloon_alert(user, "没有空间！")
	else if(result)
		balloon_alert(user, "传送中...")
	COOLDOWN_START(src, manual_teleport_cooldown, TELEPORTATION_TIME)

	return TRUE

/**
 * Handles qualifiers for enabling teleportation of boulders.
 * Returns TRUE if the teleportation can proceed, FALSE otherwise.
 * Arguments
 *
 * * mob/user - the mob to inform if conditions aren't met
 */
/obj/machinery/brm/proc/handle_teleport_conditions(mob/user)
	PRIVATE_PROC(TRUE)

	// NOVA EDIT ADDITION START
	var/area/teleport_area = get_area(src)
	if (!is_type_in_typecache(teleport_area, allowed_areas_to_work))
		balloon_alert(user, "不能在这里使用！")
		return FALSE
	// NOVA EDIT ADDITION END
	if(!COOLDOWN_FINISHED(src, manual_teleport_cooldown))
		return FALSE
	if(panel_open)
		balloon_alert(user, "先关闭面板！")
		return FALSE
	if(batch_processing)
		balloon_alert(user, "批次仍在处理中！")
		return FALSE
	playsound(src, MANUAL_TELEPORT_SOUND, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return TRUE

/obj/machinery/brm/attack_ai(mob/user)
	. = ..()
	if(. || panel_open)
		return
	if(!handle_teleport_conditions(user))
		return

	var/result = pre_collect_boulder()
	if(result == TURF_BLOCKED_BY_BOULDER)
		balloon_alert(user, "没有空间！")
	else if(result)
		balloon_alert(user, "传送中...")

	COOLDOWN_START(src, manual_teleport_cooldown, TELEPORTATION_TIME)

	return TRUE

/obj/machinery/brm/attack_robot(mob/user)
	. = ..()
	if(. || panel_open)
		return
	if(!handle_teleport_conditions(user))
		return

	var/result = pre_collect_boulder()
	if(result == TURF_BLOCKED_BY_BOULDER)
		balloon_alert(user, "空间不足！")
	else if(result)
		balloon_alert(user, "传送中...")

	COOLDOWN_START(src, manual_teleport_cooldown, TELEPORTATION_TIME)

	return TRUE

/obj/machinery/brm/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || panel_open)
		return
	if(!anchored)
		balloon_alert(user, "请先固定！")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	toggle_auto_on(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/**
 * Toggles automatic boulder retrieval on.
 * Adjusts the teleportation sound, icon state, and begins processing.
 * Arguments
 *
 * * mob/user - the player who has toggled us
 */
/obj/machinery/brm/proc/toggle_auto_on(mob/user)
	PRIVATE_PROC(TRUE)

	// NOVA EDIT ADDITION START
	var/area/teleport_area = get_area(src)
	if (!is_type_in_typecache(teleport_area, allowed_areas_to_work))
		balloon_alert(user, "此处无法使用！")
		return FALSE
	// NOVA EDIT ADDITION END
	if(panel_open)
		balloon_alert(user, "请先关闭面板！")
		return
	if(!anchored)
		balloon_alert(user, "请先固定！")
		return
	if(!is_operational || machine_stat & (BROKEN | NOPOWER))
		return

	toggled_on = ! toggled_on
	if(toggled_on)
		begin_processing()
	else
		end_processing()
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/brm/attack_ai_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || panel_open)
		return
	if(!anchored)
		balloon_alert(user, "未固定！")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	toggle_auto_on(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/brm/attack_robot_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || panel_open)
		return
	if(!user.can_perform_action(src, ALLOW_SILICON_REACH | FORBID_TELEKINESIS_REACH))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!anchored)
		balloon_alert(user, "未固定！")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	toggle_auto_on(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/brm/process()
	if(!toggled_on)
		return PROCESS_KILL

	//have some cooldown after processing the previous batch of boulders
	if(batch_processing || !COOLDOWN_FINISHED(src, batch_start_cooldown))
		return

	pre_collect_boulder(FALSE, boulders_processing_max)

/**
 * Begins to collect a boulder from the available boulders list in SSore_generation.
 * Boulders must be in the available boulders list.
 * A selected boulder is picked randomly.
 * Arguments
 *
 * * feedback - should we play sound and display allert if now boulders are available
 * * boulders_remaining - how many boulders we want to try & collect spawning a boulder every TELEPORTATION_TIME seconds
 */
/obj/machinery/brm/proc/pre_collect_boulder(feedback = TRUE, boulders_remaining = 1)
	PRIVATE_PROC(TRUE)

	batch_processing = TRUE

	//not within operation parameters
	if(!anchored || panel_open || !is_operational || machine_stat & (BROKEN | NOPOWER))
		batch_processing = FALSE
		return FALSE

	//There is an boulder in our loc. it has be removed so we don't clog up our loc with even more boulders
	if(locate(/obj/item/boulder) in loc)
		batch_processing = FALSE
		return TURF_BLOCKED_BY_BOULDER

	//no more boulders
	if(!SSore_generation.available_boulders.len)
		if(feedback)
			playsound(loc, 'sound/machines/synth/synth_no.ogg', 30 , TRUE)
			balloon_alert_to_viewers("no boulders to collect!")
		batch_processing = FALSE
		return FALSE

	//pick & spawn the boulder
	flick("brm-flash", src)
	playsound(src, toggled_on ? AUTO_TELEPORT_SOUND : MANUAL_TELEPORT_SOUND, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	var/obj/item/boulder/random_boulder = pick(SSore_generation.available_boulders)
	SSore_generation.available_boulders -= random_boulder
	random_boulder.forceMove(drop_location())
	random_boulder.pixel_x = rand(-2, 2)
	random_boulder.pixel_y = rand(-2, 2)
	balloon_alert_to_viewers("boulder appears!")
	use_energy(active_power_usage)

	//try again if we have more boulders to work with
	boulders_remaining -= 1
	if(boulders_remaining <= 0)
		COOLDOWN_START(src, batch_start_cooldown, BATCH_COOLDOWN)
		batch_processing = FALSE
		return TRUE
	else
		addtimer(CALLBACK(src, PROC_REF(pre_collect_boulder), feedback, boulders_remaining, FALSE), TELEPORTATION_TIME)

#undef MANUAL_TELEPORT_SOUND
#undef AUTO_TELEPORT_SOUND
#undef TELEPORTATION_TIME
#undef BATCH_COOLDOWN
#undef TURF_BLOCKED_BY_BOULDER
