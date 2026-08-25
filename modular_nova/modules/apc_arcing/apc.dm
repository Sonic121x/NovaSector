/obj/machinery/power/apc
	/// Has the APC been protected against arcing?
	var/arc_shielded = FALSE
	/// Should we be forcing arcing, assuming there isn't arc shielding?
	var/force_arcing = FALSE

/obj/machinery/power/apc/examine()
	. = ..()
	. += LANG("obj.299cd9151f050899", list(arc_shielded ? "has" : "does not have"))
	if(panel_open)
		if(arc_shielded)
			. += LANG("obj.8e4dbe4314ec330e", null)
		else
			. += LANG("obj.9332b3fcedfd0709", null)

/obj/machinery/power/apc/late_process(seconds_per_tick)
	. = ..()
	if(!cell || shorted)
		return
	var/excess = energy_to_power(surplus())
	if(((excess < APC_ARC_LOWERLIMIT) && !force_arcing) || arc_shielded)
		return
	var/shock_chance = 5
	if(excess >= APC_ARC_UPPERLIMIT)
		shock_chance = 15
	else if(excess >= APC_ARC_MEDIUMLIMIT)
		shock_chance = 10
	if(prob(shock_chance)) // sometimes arc, otherwise give the players a hint something is amiss
		// pick a random person in range to shock
		#define SHOCK_SOMEONE 1
		// create some sparks
		#define MAKE_SPARKS 2
		// cut the power for 2-4 seconds
		#define CAUSE_BROWNOUT 3

		var/effect = pick(list(
			SHOCK_SOMEONE,
			MAKE_SPARKS,
			CAUSE_BROWNOUT,
		))
		switch(effect)
			if(SHOCK_SOMEONE)
				var/list/shock_mobs = list()
				for(var/mob/living/creature in viewers(get_turf(src), 5)) // We only want to shock a single random mob in range, not all.
					shock_mobs += creature
				if(length(shock_mobs))
					var/mob/living/living_target = pick(shock_mobs)
					do_sparks(number = 3, cardinal_only = FALSE, source = living_target)
					living_target.electrocute_act(rand(5, 25), "electrical arc")
					playsound(get_turf(living_target), 'sound/effects/magic/lightningshock.ogg', 75, TRUE)
					Beam(living_target, icon_state = "lightning[rand(1, 12)]", icon = 'icons/effects/beam.dmi', time = 5)
					energy_fail(2)
			if(MAKE_SPARKS)
				do_sparks(number = 3, cardinal_only = FALSE, source = src)
			if(CAUSE_BROWNOUT)
				energy_fail(rand(2, 4)) // energy_fail does not use the SECONDS macro, so it's deliberately not used here in the arg. don't add it.
		#undef SHOCK_SOMEONE
		#undef MAKE_SPARKS
		#undef CAUSE_BROWNOUT


/obj/machinery/power/apc/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(.)
		return .

	if(istype(tool, /obj/item/stack/sheet/bronze) && panel_open)
		. = bronze_act(user, tool)

/// Handles interaction of adding arc shielding to apc with bronze
/obj/machinery/power/apc/proc/bronze_act(mob/living/user, obj/item/stack/sheet/bronze/bronze)
	if(arc_shielded)
		balloon_alert(user, LANG("obj.cc26e78ce890e727", null))
		return ITEM_INTERACT_BLOCKING
	bronze.use(1)
	balloon_alert(user, LANG("obj.b6b95150f35066c1", null))
	arc_shielded = TRUE
	playsound(src, 'sound/items/tools/rped.ogg', 20)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/apc/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(panel_open && arc_shielded)
		balloon_alert(user, LANG("obj.cf2b2bcbe072643f", null))
		arc_shielded = FALSE
		tool.play_tool_sound(src, 50)

/// Set all APCs to start (or stop) arcing
/proc/force_apc_arcing(force_mode = FALSE)
	for(var/obj/machinery/power/apc/controller as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/apc))
		controller.force_arcing = force_mode
