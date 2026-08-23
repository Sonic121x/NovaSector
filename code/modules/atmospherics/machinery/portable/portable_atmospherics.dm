// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define PORTABLE_ATMOS_IGNORE_ATMOS_LIMIT 0

/obj/machinery/portable_atmospherics
	name = "portable_atmospherics"
	icon = 'icons/obj/pipes_n_cables/atmos.dmi'
	use_power = NO_POWER_USE
	max_integrity = 250
	armor_type = /datum/armor/machinery_portable_atmospherics
	anchored = FALSE
	layer = ABOVE_OBJ_LAYER
	interaction_flags_click = NEED_DEXTERITY
	damage_deflection = 11

	///Stores the gas mixture of the portable component. Don't access this directly, use return_air() so you support the temporary processing it provides
	var/datum/gas_mixture/air_contents
	///Stores the gas mixture in string form for map loading and saving
	var/initial_gas_mix
	///Stores the reference of the connecting port
	var/obj/machinery/atmospherics/components/unary/portables_connector/connected_port
	///Stores the reference of the tank the machine is holding
	var/obj/item/tank/holding
	///Volume (in L) of the inside of the machine
	var/volume = 0
	///Used to track if anything of note has happen while running process_atmos().
	///Treat it as a process_atmos() scope var, we just declare it here to pass it between parent calls.
	///Should be false on start of every process_atmos() proc, since true means we'll process again next tick.
	var/excited = FALSE

	/// Max amount of heat allowed inside the machine before it starts to melt. [PORTABLE_ATMOS_IGNORE_ATMOS_LIMIT] is special value meaning we are immune.
	var/temp_limit = 10000
	/// Max amount of pressure allowed inside of the canister before it starts to break. [PORTABLE_ATMOS_IGNORE_ATMOS_LIMIT] is special value meaning we are immune.
	var/pressure_limit = 500000

	/// Should reactions inside the object be suppressed
	var/suppress_reactions = FALSE
	/// Is there a hypernoblium crystal inserted into this
	var/nob_crystal_inserted = FALSE
	var/insert_sound = 'sound/effects/compressed_air/tank_insert_clunky.ogg'
	var/remove_sound = 'sound/effects/compressed_air/tank_remove_thunk.ogg'
	var/sound_vol = 50

/datum/armor/machinery_portable_atmospherics
	energy = 100
	fire = 60
	acid = 30

/obj/machinery/portable_atmospherics/get_save_vars()
	. = ..()
	var/datum/gas_mixture/gasmix = air_contents
	initial_gas_mix = gasmix.to_string()
	. += NAMEOF(src, initial_gas_mix)
	return .

/obj/machinery/portable_atmospherics/Initialize(mapload)
	. = ..()
	if(initial_gas_mix)
		air_contents = SSair.parse_gas_string(initial_gas_mix)
	else
		air_contents = new
		air_contents.temperature = T20C
	air_contents.volume = volume
	SSair.start_processing_machine(src)
	AddElement(/datum/element/climbable, climb_time = 3 SECONDS, climb_stun = 3 SECONDS)
	AddElement(/datum/element/elevation, pixel_shift = 8)
	register_context()

/obj/machinery/portable_atmospherics/on_construction(mob/user)
	. = ..()
	set_anchored(FALSE)

/obj/machinery/portable_atmospherics/on_deconstruction(disassembled)
	if(nob_crystal_inserted)
		new /obj/item/hypernoblium_crystal(src)

	return ..()

/obj/machinery/portable_atmospherics/Destroy()
	disconnect(destroyed = TRUE)
	air_contents = null
	if(holding)
		unregister_holding()
	SSair.stop_processing_machine(src)

	return ..()

/obj/machinery/portable_atmospherics/examine(mob/user)
	. = ..()
	if(nob_crystal_inserted)
		. += LANG("obj.af2505bf413597ed", null)
	if(suppress_reactions)
		. += LANG("obj.df2d77793c000f84", null)

/obj/machinery/portable_atmospherics/ex_act(severity, target)
	if(resistance_flags & INDESTRUCTIBLE)
		return FALSE //Indestructible cans shouldn't release air

	if(severity == EXPLODE_DEVASTATE || target == src)
		//This explosion will destroy the can, release its air.
		var/turf/local_turf = get_turf(src)
		local_turf.assume_air(air_contents)

	return ..()

/obj/machinery/portable_atmospherics/process_atmos()
	excited = (!suppress_reactions && (excited || air_contents.react(src)))
	if(!excited)
		return PROCESS_KILL
	excited = FALSE

/obj/machinery/portable_atmospherics/welder_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return ITEM_INTERACT_SKIP_TO_ATTACK
	if(atom_integrity >= max_integrity || (machine_stat & BROKEN) || !tool.tool_start_check(user, amount = 1, heat_required = HIGH_TEMPERATURE_REQUIRED))
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, LANG("obj.b52342a8e93a2ba2", null))
	while(tool.use_tool(src, user, 2.5 SECONDS, volume=40))
		atom_integrity = min(atom_integrity + 25, max_integrity)
		if(atom_integrity >= max_integrity)
			balloon_alert(user, LANG("obj.65ced1e8b5b56733", null))
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, LANG("obj.0aa1744ab7dc3eee", null))

	return ITEM_INTERACT_SUCCESS

/obj/machinery/portable_atmospherics/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(!isliving(user) || !Adjacent(user))
		return .
	if(held_item?.tool_behaviour == TOOL_WELDER)
		context[SCREENTIP_CONTEXT_LMB] = "Repair"
		return CONTEXTUAL_SCREENTIP_SET

/// Take damage if a variable is exceeded. Damage is equal to temp/limit * heat/limit.
/// The damage multiplier is treated as 1 if something is being ignored while the other one is exceeded.
/// On most cases only one will be exceeded, so the other one is scaled down.
/obj/machinery/portable_atmospherics/proc/take_atmos_damage()
	var/taking_damage = FALSE

	var/temp_damage = 1
	var/pressure_damage = 1

	if(temp_limit != PORTABLE_ATMOS_IGNORE_ATMOS_LIMIT)
		temp_damage = air_contents.temperature / temp_limit
		taking_damage = temp_damage > 1

	if(pressure_limit != PORTABLE_ATMOS_IGNORE_ATMOS_LIMIT)
		pressure_damage = air_contents.return_pressure() / pressure_limit
		taking_damage = taking_damage || pressure_damage > 1

	if(!taking_damage)
		return FALSE

	take_damage(clamp(temp_damage * pressure_damage, 5, 50), BURN, 0)
	return TRUE

/obj/machinery/portable_atmospherics/return_air()
	SSair.start_processing_machine(src)
	return air_contents

/obj/machinery/portable_atmospherics/return_analyzable_air()
	return air_contents

/**
 * Allow the portable machine to be connected to a connector
 * Arguments:
 * * new_port - the connector that we trying to connect to
 */
/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/components/unary/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return FALSE

	//Make sure are close enough for a valid connection
	if(new_port.loc != get_turf(src))
		return FALSE

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	var/datum/pipeline/connected_port_parent = connected_port.parents[1]
	connected_port_parent.reconcile_air()

	set_anchored(TRUE) //Prevent movement
	pixel_x = new_port.pixel_x
	pixel_y = new_port.pixel_y

	SSair.start_processing_machine(src)
	update_appearance()
	return TRUE

/obj/machinery/portable_atmospherics/Move()
	. = ..()
	if(.)
		disconnect()

/**
 * Allow the portable machine to be disconnected from the connector
 */
/obj/machinery/portable_atmospherics/proc/disconnect(destroyed = FALSE)
	if(!connected_port)
		return FALSE
	connected_port.connected_device = null
	connected_port = null
	if (destroyed)
		return TRUE

	set_anchored(FALSE)
	pixel_x = 0
	pixel_y = 0

	SSair.start_processing_machine(src)
	update_appearance()
	return TRUE

/obj/machinery/portable_atmospherics/click_alt(mob/living/user)
	if(!holding)
		return CLICK_ACTION_BLOCKING
	to_chat(user, span_notice(LANG("obj.cbed32661d4c054a", list(holding, src))))
	replace_tank(user, TRUE)
	return CLICK_ACTION_SUCCESS

/obj/machinery/portable_atmospherics/examine(mob/user)
	. = ..()
	if(!holding)
		return
	. += span_notice("\The [src] contains [holding]. Alt-click [src] to remove it.")+\
		span_notice("Click [src] with another gas tank to hot swap [holding].")

/**
 * Allow the player to place a tank inside the machine.
 * Arguments:
 * * User: the player doing the act
 * * close_valve: used in the canister.dm file, check if the valve is open or not
 * * new_tank: the tank we are trying to put in the machine
 */
/obj/machinery/portable_atmospherics/proc/replace_tank(mob/living/user, close_valve, obj/item/tank/new_tank)
	if(machine_stat & BROKEN)
		return FALSE
	if(!user)
		return FALSE
	if(new_tank && !user.transferItemToLoc(new_tank, src))
		return FALSE

	if(holding && new_tank)//for when we are actually switching tanks
		investigate_log("had its internal [holding] swapped with [new_tank] by [key_name(user)].", INVESTIGATE_ATMOS)
		to_chat(user, span_notice(LANG("obj.fdae5e9cd4fecf82", list(holding, src, new_tank))))
		user.put_in_hands(holding)
		UnregisterSignal(holding, COMSIG_QDELETING)
		holding = new_tank
		RegisterSignal(holding, COMSIG_QDELETING, PROC_REF(unregister_holding))
		playsound(src, insert_sound, sound_vol)
		playsound(src, remove_sound, sound_vol)
	else if(holding)//we remove a tank
		investigate_log("had its internal [holding] removed by [key_name(user)].", INVESTIGATE_ATMOS)
		to_chat(user, span_notice(LANG("obj.cbed32661d4c054a", list(holding, src))))
		if(Adjacent(user))
			user.put_in_hands(holding)
		else
			holding.forceMove(get_turf(src))
		playsound(src, remove_sound, sound_vol)
		UnregisterSignal(holding, COMSIG_QDELETING)
		holding = null
	else if(new_tank)//we insert the tank
		investigate_log("had [new_tank] inserted into it by [key_name(user)].", INVESTIGATE_ATMOS)
		to_chat(user, span_notice(LANG("obj.8ce99939bf01b695", list(new_tank, src))))
		holding = new_tank
		playsound(src, insert_sound, sound_vol)
		RegisterSignal(holding, COMSIG_QDELETING, PROC_REF(unregister_holding))

	SSair.start_processing_machine(src)
	update_appearance()
	return TRUE

/obj/machinery/portable_atmospherics/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/tank))
		return NONE

	if(!replace_tank(user, FALSE, tool))
		return ITEM_INTERACT_BLOCKING

	return ITEM_INTERACT_SUCCESS

/obj/machinery/portable_atmospherics/wrench_act(mob/living/user, obj/item/wrench)
	if(machine_stat & BROKEN)
		return FALSE
	if(connected_port)
		investigate_log("was disconnected from [connected_port] by [key_name(user)].", INVESTIGATE_ATMOS)
		disconnect()
		wrench.play_tool_sound(src)
		user.visible_message( \
			LANG("obj.4acbf7f4975d45b7", list(user, src)), \
			span_notice(LANG("obj.4750b2731c4a628e", list(src))), \
			span_hear(LANG("obj.aa8a193f8da7c41c", null)))
		update_appearance()
		return TRUE
	var/obj/machinery/atmospherics/components/unary/portables_connector/possible_port = locate(/obj/machinery/atmospherics/components/unary/portables_connector) in loc
	if(!possible_port)
		to_chat(user, span_notice(LANG("obj.1ee6cac099b952f7", null)))
		return FALSE
	if(!connect(possible_port))
		to_chat(user, span_notice(LANG("obj.85a77c70e9c1960e", list(name))))
		return FALSE
	wrench.play_tool_sound(src)
	user.visible_message( \
		LANG("obj.1450de580c437995", list(user, src)), \
		span_notice(LANG("obj.ea2a40d37a6615b9", list(src))), \
		span_hear(LANG("obj.aa8a193f8da7c41c", null)))
	update_appearance()
	investigate_log("was connected to [possible_port] by [key_name(user)].", INVESTIGATE_ATMOS)
	return TRUE

/obj/machinery/portable_atmospherics/atom_break(damage_flag)
	. = ..()
	damage_deflection = 0

/obj/machinery/portable_atmospherics/atom_fix()
	. = ..()
	damage_deflection = initial(damage_deflection)

/obj/machinery/portable_atmospherics/attacked_by(obj/item/item, mob/user)
	. = ..()
	if(. <= 0)
		return
	investigate_log("was smacked with \a [item] by [key_name(user)].", INVESTIGATE_ATMOS)
	add_hiddenprint(user)

/// Holding tanks can get to zero integrity and be destroyed without other warnings due to pressure change.
/// This checks for that case and removes our reference to it.
/obj/machinery/portable_atmospherics/proc/unregister_holding()
	SIGNAL_HANDLER

	UnregisterSignal(holding, COMSIG_QDELETING)
	holding = null

/// Insert Hypernob crystal into the machine
/obj/machinery/portable_atmospherics/proc/insert_nob_crystal()
	nob_crystal_inserted = TRUE

#undef PORTABLE_ATMOS_IGNORE_ATMOS_LIMIT
