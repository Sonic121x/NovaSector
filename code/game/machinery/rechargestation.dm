// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/recharge_station
	name = "recharging station"
	desc = "This device recharges energy-dependent lifeforms, like cyborgs, ethereals, and MODsuit users."
	icon = 'icons/obj/machines/borg_charger.dmi'
	icon_state = "borgcharger0"
	base_icon_state = "borgcharger"
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.1
	density = FALSE
	req_access = list(ACCESS_ROBOTICS)
	state_open = TRUE
	circuit = /obj/item/circuitboard/machine/cyborgrecharger
	occupant_typecache = list(/mob/living/silicon/robot, /mob/living/carbon/human, /mob/living/circuit_drone)
	processing_flags = NONE
	var/recharge_speed
	var/repairs
	///Callback for borgs & modsuits to provide their cell to us for charging
	var/datum/callback/charge_cell
	///Whether we're sending iron and glass to a cyborg. Requires Silo connection.
	var/sendmats = FALSE
	var/datum/remote_materials/materials


/obj/machinery/recharge_station/Initialize(mapload)
	. = ..()

	materials = new (
		src, \
		mapload, \
		mat_container_flags = MATCONTAINER_NO_INSERT, \
	)
	charge_cell = CALLBACK(src, PROC_REF(charge_target_cell))

	update_appearance()
	if(is_operational)
		begin_processing()

	if(!mapload)
		return

	var/area/my_area = get_area(src)
	if(!(my_area.type in GLOB.the_station_areas))
		return

	var/area_name = get_area_name(src, format_text = TRUE)
	if(area_name in GLOB.roundstart_station_borgcharger_areas)
		return
	GLOB.roundstart_station_borgcharger_areas += area_name

/obj/machinery/recharge_station/Destroy()
	QDEL_NULL(materials)
	charge_cell = null
	return ..()

/**
 * Mobs & borgs invoke this through a callback to recharge their cells
 * Arguments
 *
 * * obj/item/stock_parts/power_store/cell/target - the cell to charge, optional if provided else will draw power used directly
 * * seconds_per_tick - supplied from process()
 */
/obj/machinery/recharge_station/proc/charge_target_cell(obj/item/stock_parts/power_store/cell/target, seconds_per_tick)
	PRIVATE_PROC(TRUE)

	//charge the cell, account for heat loss from work done
	var/charge_given = charge_cell(recharge_speed * seconds_per_tick, target, grid_only = TRUE)
	if(charge_given)
		use_energy((charge_given + active_power_usage) * 0.01)

	return charge_given

/obj/machinery/recharge_station/RefreshParts()
	. = ..()
	recharge_speed = 0
	repairs = 0
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		recharge_speed += 5e-3 * capacitor.tier
	for(var/datum/stock_part/servo/servo in component_parts)
		repairs += servo.tier - 1
	for(var/obj/item/stock_parts/power_store/cell in component_parts)
		recharge_speed *= cell.maxcharge
	recharge_speed *= 4 //NOVA EDIT ADDITION

/obj/machinery/recharge_station/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice(LANG("obj.a1f1354ae648b5c2", list(display_power(recharge_speed, convert = FALSE))))
		if(materials.silo)
			. += span_notice(LANG("obj.9bb8f696aac68248", list(src)))
		if(repairs)
			. += span_notice(LANG("obj.cf202c99cb6525bf", list(src)))

/obj/machinery/recharge_station/on_set_is_operational(old_value)
	if(old_value) //Turned off
		end_processing()
	else //Turned on
		begin_processing()

/obj/machinery/recharge_station/relaymove(mob/living/user, direction)
	if(IS_UNCONSCIOUS_OR_CRIT(user))
		return
	open_machine()

/obj/machinery/recharge_station/emp_act(severity)
	. = ..()
	if(!(machine_stat & (BROKEN|NOPOWER)))
		if(occupant && !(. & EMP_PROTECT_CONTENTS))
			occupant.emp_act(severity)
		if (!(. & EMP_PROTECT_SELF))
			open_machine()

/obj/machinery/recharge_station/screwdriver_act(mob/living/user, obj/item/tool)
	return state_open ? default_deconstruction_screwdriver(user, tool) : NONE

/obj/machinery/recharge_station/crowbar_act(mob/living/user, obj/item/tool)
	return default_pry_open(user, tool, close_after_pry = FALSE, open_density = FALSE, closed_density = TRUE, deconstruct_on_fail = TRUE)

/obj/machinery/recharge_station/attack_ai_secondary(mob/user, list/modifiers)
	toggle_restock(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/recharge_station/attack_hand_secondary(mob/user, list/modifiers)
	toggle_restock(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/recharge_station/proc/toggle_restock(mob/user)
	if(sendmats)
		sendmats = FALSE
		say(LANG("obj.5adef8253913cb78", null))
		return
	if(state_open || !occupant)
		return
	if(!iscyborg(occupant))
		return
	if(!materials.silo)
		say(LANG("obj.d21318d629d36648", null))
		return
	if(materials.on_hold())
		say(LANG("obj.cc23e1759d96e946", null))
		return FALSE
	sendmats = TRUE
	say(LANG("obj.3a706c9e52de2455", null))

/obj/machinery/recharge_station/interact(mob/user)
	toggle_open()
	return TRUE

/obj/machinery/recharge_station/proc/toggle_open()
	if(state_open)
		close_machine(density_to_set = TRUE)
		toggle_restock() //defaults to enabled
	else
		open_machine()

/obj/machinery/recharge_station/open_machine(drop = TRUE, density_to_set = FALSE)
	. = ..()
	sendmats = FALSE
	update_use_power(IDLE_POWER_USE)

/obj/machinery/recharge_station/close_machine(atom/movable/target, density_to_set = TRUE)
	. = ..()
	if(occupant)
		update_use_power(ACTIVE_POWER_USE) //It always tries to charge, even if it can't.
		add_fingerprint(occupant)

/obj/machinery/recharge_station/update_icon_state()
	if(panel_open)
		icon_state = "borgdecon2"
		return ..()
	if(!is_operational)
		icon_state = "[base_icon_state]-u[state_open ? 0 : 1]"
		return ..()
	icon_state = "[base_icon_state][state_open ? 0 : (occupant ? 1 : 2)]"
	return ..()

/obj/machinery/recharge_station/process(seconds_per_tick)
	if(QDELETED(occupant) || !is_operational)
		return

	SEND_SIGNAL(occupant, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, charge_cell, seconds_per_tick, repairs, sendmats)
