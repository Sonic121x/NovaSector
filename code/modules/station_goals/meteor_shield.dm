// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// number of emagged meteor shields to get the first warning, a simple say message
#define EMAGGED_METEOR_SHIELD_THRESHOLD_ONE 3
/// number of emagged meteor shields to get the second warning, telling the user an announcement is coming
#define EMAGGED_METEOR_SHIELD_THRESHOLD_TWO 6
/// number of emagged meteor shields to get the third warning + an announcement to the crew
#define EMAGGED_METEOR_SHIELD_THRESHOLD_THREE 7
/// number of emagged meteor shields to get the fourth... ah shit the dark matt-eor is coming.
#define EMAGGED_METEOR_SHIELD_THRESHOLD_FOUR 10
/// how long between emagging meteor shields you have to wait
#define METEOR_SHIELD_EMAG_COOLDOWN 1 MINUTES

//Station Shield
// A chain of satellites encircles the station
// Satellites be actived to generate a shield that will block unorganic matter from passing it.
/datum/station_goal/station_shield
	name = "Station Shield"
	requires_space = TRUE
	var/coverage_goal = 500
	VAR_PRIVATE/cached_coverage_length

/datum/station_goal/station_shield/get_report()
	return list(
		"The station is located in a zone full of space debris.",
		"We have a prototype shielding system you must deploy to reduce collision-related accidents.",
		"",
		"You can order the satellites and control systems at cargo.",
	).Join("\n")


/datum/station_goal/station_shield/on_report()
	//Unlock
	var/datum/supply_pack/P = SSshuttle.supply_packs[/datum/supply_pack/engineering/shield_sat]
	P.order_flags |= ORDER_SPECIAL_ENABLED

	P = SSshuttle.supply_packs[/datum/supply_pack/engineering/shield_sat_control]
	P.order_flags |= ORDER_SPECIAL_ENABLED

/datum/station_goal/station_shield/check_completion()
	if(..())
		return TRUE
	update_coverage()
	if(cached_coverage_length >= coverage_goal)
		return TRUE
	return FALSE

/datum/station_goal/station_shield/proc/get_coverage()
	return cached_coverage_length

/// Gets the coverage of all active meteor shield satellites
/// Can be expensive, ensure you need this before calling it
/datum/station_goal/station_shield/proc/update_coverage()
	var/list/coverage = list()
	for(var/obj/machinery/satellite/meteor_shield/shield_satt as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/satellite/meteor_shield))
		if(!shield_satt.active || !is_station_level(shield_satt.z))
			continue
		for(var/turf/covered in view(shield_satt.kill_range, shield_satt))
			coverage |= covered
	cached_coverage_length = length(coverage)

/obj/machinery/satellite/meteor_shield
	name = "\improper Meteor Shield Satellite"
	desc = "A meteor point-defense satellite."
	mode = "M-SHIELD"
	/// the range a meteor shield sat can destroy meteors
	var/kill_range = 14

	//emag behavior dark matt-eor stuff

	/// Proximity monitor associated with this atom, needed for it to work.
	var/datum/proximity_monitor/proximity_monitor

	/// amount of emagged active meteor shields
	var/static/emagged_active_meteor_shields = 0
	/// the highest amount of shields you've ever emagged
	var/static/highest_emagged_threshold_reached = 0
	/// cooldown on emagging meteor shields because instantly summoning a dark matt-eor is very unfun
	STATIC_COOLDOWN_DECLARE(shared_emag_cooldown)

/obj/machinery/satellite/meteor_shield/examine(mob/user)
	. = ..()
	if(active)
		. += span_notice(LANG("obj.ec926d966fad4dda", null))
		if(obj_flags & EMAGGED)
			. += span_warning(LANG("obj.dcc51c7610597536", null))
		else
			. += span_notice(LANG("obj.cafef0d6b25a7ca3", null))
	else
		. += span_notice(LANG("obj.6c0105400b5f9673", null))
		if(obj_flags & EMAGGED)
			. += span_warning(LANG("obj.cbd64c27a7759d80", null))

/obj/machinery/satellite/meteor_shield/proc/space_los(meteor)
	for(var/turf/T in get_line(src,meteor))
		if(!isspaceturf(T))
			return FALSE
	return TRUE

/obj/machinery/satellite/meteor_shield/Initialize(mapload)
	. = ..()
	proximity_monitor = new(src, /* range = */ 0)

/obj/machinery/satellite/meteor_shield/HasProximity(atom/movable/proximity_check_mob)
	. = ..()
	if(!istype(proximity_check_mob, /obj/effect/meteor))
		return
	var/obj/effect/meteor/meteor_to_destroy = proximity_check_mob
	if(space_los(meteor_to_destroy))
		var/turf/beam_from = get_turf(src)
		beam_from.Beam(get_turf(meteor_to_destroy), icon_state="sat_beam", time = 5)
		if(meteor_to_destroy.shield_defense(src))
			qdel(meteor_to_destroy)

/obj/machinery/satellite/meteor_shield/toggle(user)
	if(user)
		balloon_alert(user, LANG("obj.371b2e5f5ed40561", list(active ? "off" : "on")))
	if(user && !do_after(user, 2 SECONDS, src, IGNORE_HELD_ITEM))
		return FALSE
	if(!..(user))
		return FALSE
	if(obj_flags & EMAGGED)
		update_emagged_meteor_sat(user)

	if(active)
		proximity_monitor.set_range(kill_range)
	else
		proximity_monitor.set_range(0)


	var/datum/station_goal/station_shield/goal = SSstation.get_station_goal(/datum/station_goal/station_shield)
	goal?.update_coverage()

/obj/machinery/satellite/meteor_shield/Destroy()
	. = ..()
	QDEL_NULL(proximity_monitor)
	if(obj_flags & EMAGGED)
		//satellites that are destroying are not active, this will count down the number of emagged sats
		update_emagged_meteor_sat()

/obj/machinery/satellite/meteor_shield/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		balloon_alert(user, LANG("obj.9bab397b17f019dd", null))
		return FALSE
	if(!COOLDOWN_FINISHED(src, shared_emag_cooldown))
		balloon_alert(user, LANG("obj.d4ae5d4dded19efe", null))
		to_chat(user, span_warning(LANG("obj.81d725ea96eb3097", list(DisplayTimeText(COOLDOWN_TIMELEFT(src, shared_emag_cooldown))))))
		return FALSE
	var/cooldown_applied = METEOR_SHIELD_EMAG_COOLDOWN
	COOLDOWN_START(src, shared_emag_cooldown, cooldown_applied)
	obj_flags |= EMAGGED
	to_chat(user, span_notice(LANG("obj.342bb80d18e955cb", null)))
	AddComponent(/datum/component/gps, "Corrupted Meteor Shield Attraction Signal")
	say(LANG("obj.5609c3a2f427e525", list(DisplayTimeText(cooldown_applied))))
	if(active) //if we allowed inactive updates a sat could be worth -1 active meteor shields on first emag
		update_emagged_meteor_sat(user)
	return TRUE

/obj/machinery/satellite/meteor_shield/proc/update_emagged_meteor_sat(mob/user)
	if(!active)
		change_meteor_chance(0.5)
		emagged_active_meteor_shields--
		if(user)
			balloon_alert(user, LANG("obj.f59256a62993efc0", null))
		return
	change_meteor_chance(2)
	emagged_active_meteor_shields++
	if(user)
		balloon_alert(user, LANG("obj.68dc5b63f3824085", null))
	if(emagged_active_meteor_shields > highest_emagged_threshold_reached)
		highest_emagged_threshold_reached = emagged_active_meteor_shields
		handle_new_emagged_shield_threshold()

/obj/machinery/satellite/meteor_shield/proc/handle_new_emagged_shield_threshold()
	switch(highest_emagged_threshold_reached)
		if(EMAGGED_METEOR_SHIELD_THRESHOLD_ONE)
			say(LANG("obj.fd6dd9dec045ca4c", null))
		if(EMAGGED_METEOR_SHIELD_THRESHOLD_TWO)
			say(LANG("obj.80bc2068accd2790", null))
		if(EMAGGED_METEOR_SHIELD_THRESHOLD_THREE)
			say(LANG("obj.1b68c7b90eaa8178", null))
			priority_announce("Warning. Tampering of meteor satellites puts the station at risk of exotic, deadly meteor collisions. Please intervene by checking your GPS devices for strange signals, and dismantling the tampered meteor shields.", "Strange Meteor Signal Warning")
		if(EMAGGED_METEOR_SHIELD_THRESHOLD_FOUR)
			say(LANG("obj.9c18e999dfdce842", null))
			force_event_async(/datum/round_event_control/dark_matteor, "an array of tampered meteor satellites")

/obj/machinery/satellite/meteor_shield/proc/change_meteor_chance(mod)
	// Update the weight of all meteor events
	for(var/datum/round_event_control/meteor_wave/meteors in SSevents.control)
		meteors.weight *= mod
	for(var/datum/round_event_control/stray_meteor/stray_meteor in SSevents.control)
		stray_meteor.weight *= mod


#undef EMAGGED_METEOR_SHIELD_THRESHOLD_ONE
#undef EMAGGED_METEOR_SHIELD_THRESHOLD_TWO
#undef EMAGGED_METEOR_SHIELD_THRESHOLD_THREE
#undef EMAGGED_METEOR_SHIELD_THRESHOLD_FOUR

#undef METEOR_SHIELD_EMAG_COOLDOWN
