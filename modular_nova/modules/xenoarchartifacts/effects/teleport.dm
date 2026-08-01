/datum/artifact_effect/teleport
	log_name = "Teleport"
	type_name = ARTIFACT_EFFECT_BLUESPACE

/datum/artifact_effect/teleport/do_effect_touch(mob/user)
	. = ..()
	if(!.)
		return
	if(teleport_around(user, 10))
		user.visible_message(
			span_warning(LANG("datum.d8c54a6a", list(user))),
			span_warning(LANG("datum.fc17dd20", null)),
			blind_message = span_hear(LANG("datum.f3571fe9", null)),
		)

/datum/artifact_effect/teleport/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/living_mob in range(range, curr_turf))
		if(teleport_around(living_mob, 20))
			living_mob.visible_message(
				span_warning(LANG("datum.fc07fa9a", list(living_mob))),
				span_warning(LANG("datum.325c879e", null)),
				blind_message = span_hear(LANG("datum.f3571fe9", null)),
			)

/datum/artifact_effect/teleport/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/living_mob in range(range, curr_turf))
		if(teleport_around(living_mob, round(1 * used_power)))
			living_mob.visible_message(
				span_warning(LANG("datum.fc07fa9a", list(living_mob))),
				span_warning(LANG("datum.325c879e", null)),
				blind_message = span_hear(LANG("datum.f3571fe9", null)),
			)

/datum/artifact_effect/teleport/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/living_mob in range(7, curr_turf))
		if(teleport_around(living_mob, 50))
			living_mob.visible_message(
				span_warning(LANG("datum.fc07fa9a", list(living_mob))),
				span_warning(LANG("datum.325c879e", null)),
				blind_message = span_hear(LANG("datum.f3571fe9", null)),
			)

/**
 * Randomly teleports receiver
 *
 * Arguments:
 * * receiver - mob to apply sleep to
 * * max_range - maximum teleport range
 */
/datum/artifact_effect/teleport/proc/teleport_around(mob/receiver, max_range)
	var/weakness = get_anomaly_protection(receiver)
	if(!weakness)
		return FALSE
	do_sparks(rand(3,6), 1, src.holder)
	var/turf/target_turf = pick(orange(get_turf(receiver), max_range * weakness))
	do_teleport(receiver, target_turf, 4)
	do_sparks(rand(3,6), 1,  get_turf(receiver))
	return TRUE
