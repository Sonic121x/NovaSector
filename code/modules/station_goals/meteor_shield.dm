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
	name = "空间站护盾"
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
	name = "\improper 流星护盾卫星"
	desc = "一个流星点防御卫星。"
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
		. += span_notice("它目前处于激活状态。你可以与之互动来关闭它。")
		if(obj_flags & EMAGGED)
			. += span_warning("它没有发出通常的哔哔声和提示音，而是产生一种奇怪且持续的白噪音嘶嘶声……")
		else
			. += span_notice("它发出周期性的哔哔声和提示音，与卫星网络进行通信。")
	else
		. += span_notice("它目前处于禁用状态。你可以与之互动来启动它。")
		if(obj_flags & EMAGGED)
			. += span_warning("但似乎有什么地方不对劲……？")

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
		balloon_alert(user, "寻找[active ? "off" : "on"]按钮")
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
		balloon_alert(user, "已经电磁入侵过了！")
		return FALSE
	if(!COOLDOWN_FINISHED(src, shared_emag_cooldown))
		balloon_alert(user, "冷却中！")
		to_chat(user, span_warning("上一个被电磁脉冲攻击的卫星需要[DisplayTimeText(COOLDOWN_TIMELEFT(src, shared_emag_cooldown))]来重新校准。这么快就攻击另一个可能会损坏卫星网络。"))
		return FALSE
	var/cooldown_applied = METEOR_SHIELD_EMAG_COOLDOWN
	COOLDOWN_START(src, shared_emag_cooldown, cooldown_applied)
	obj_flags |= EMAGGED
	to_chat(user, span_notice("你访问了卫星的调试模式，它开始发出奇怪的信号，增加了流星撞击的几率。"))
	AddComponent(/datum/component/gps, "Corrupted Meteor Shield Attraction Signal")
	say("Recalibrating... ETA:[DisplayTimeText(cooldown_applied)].")
	if(active) //if we allowed inactive updates a sat could be worth -1 active meteor shields on first emag
		update_emagged_meteor_sat(user)
	return TRUE

/obj/machinery/satellite/meteor_shield/proc/update_emagged_meteor_sat(mob/user)
	if(!active)
		change_meteor_chance(0.5)
		emagged_active_meteor_shields--
		if(user)
			balloon_alert(user, "流星概率减半")
		return
	change_meteor_chance(2)
	emagged_active_meteor_shields++
	if(user)
		balloon_alert(user, "陨石概率翻倍")
	if(emagged_active_meteor_shields > highest_emagged_threshold_reached)
		highest_emagged_threshold_reached = emagged_active_meteor_shields
		handle_new_emagged_shield_threshold()

/obj/machinery/satellite/meteor_shield/proc/handle_new_emagged_shield_threshold()
	switch(highest_emagged_threshold_reached)
		if(EMAGGED_METEOR_SHIELD_THRESHOLD_ONE)
			say("Warning. Meteor strike probability entering dangerous ranges for more exotic meteors.")
		if(EMAGGED_METEOR_SHIELD_THRESHOLD_TWO)
			say("Warning. Risk of dark matter congealment entering existent ranges. Further tampering will be reported.")
		if(EMAGGED_METEOR_SHIELD_THRESHOLD_THREE)
			say("Warning. Further tampering has been reported.")
			priority_announce("警告。对陨石卫星的篡改将使空间站面临遭遇奇特、致命陨石撞击的风险。请通过检查您的GPS设备以寻找异常信号，并拆除被篡改的陨石护盾来进行干预。", "异常陨石信号警告")
		if(EMAGGED_METEOR_SHIELD_THRESHOLD_FOUR)
			say("Warning. Warning. Dark Matt-eor on course for station.")
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
