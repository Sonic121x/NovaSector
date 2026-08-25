/datum/artifact_effect/heal
	log_name = "Heal"
	type_name = ARTIFACT_EFFECT_ORGANIC

/**
 * Heals target mob
 *
 * Arguments:
 * * receiver - mob to heal
 * * healing_power - how much to heal
 */
/datum/artifact_effect/heal/proc/heal_target(mob/living/receiver, healing_power)
	if(ishuman(receiver))
		var/mob/living/carbon/human/human_mob = receiver
		var/weakness = get_anomaly_protection(human_mob)
		human_mob.heal_overall_damage(healing_power * weakness, healing_power * weakness)
		return
	receiver.heal_overall_damage(healing_power, healing_power)

/datum/artifact_effect/heal/do_effect_touch(mob/user)
	. = ..()
	if(!.)
		return
	to_chat(user, span_notice(LANG("datum.5e73b13a3ce330b0", null)))
	heal_target(user, 25)

/datum/artifact_effect/heal/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice(LANG("datum.869265e61c453ce4", null)))
		heal_target(receiver, rand(1,3)/2 * seconds_per_tick)

/datum/artifact_effect/heal/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice(LANG("datum.869265e61c453ce4", null)))
		heal_target(receiver, 2.5 * used_power * seconds_per_tick)

/datum/artifact_effect/heal/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(7, curr_turf))
		to_chat(receiver, span_notice(LANG("datum.7b9c29ebfba91cfa", null)))
		heal_target(receiver, 50)

/datum/artifact_effect/roboheal
	log_name = "Robo-heal"

/datum/artifact_effect/roboheal/New()
	. = ..()
	type_name = pick(ARTIFACT_EFFECT_ELECTRO, ARTIFACT_EFFECT_PARTICLE)

/**
 * Heals silicons only
 *
 * Arguments:
 * * receiver - mob to heal
 * * healing_power - how much to heal
 */
/datum/artifact_effect/roboheal/proc/heal_target(mob/living/receiver, healing_power)
	receiver.heal_overall_damage(healing_power, healing_power)

/datum/artifact_effect/roboheal/do_effect_touch(mob/user)
	. = ..()
	if(!.)
		return
	if(!issilicon(user))
		return
	to_chat(user, span_notice(LANG("datum.0ceedd17c9a670bb", null)))
	heal_target(user, 25)

/datum/artifact_effect/roboheal/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice(LANG("datum.6717886acbe32244", null)))
		heal_target(receiver, 0.5 * seconds_per_tick)

/datum/artifact_effect/roboheal/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice(LANG("datum.6e93c0d18174c133", null)))
		heal_target(receiver, 2.5 * used_power * seconds_per_tick)

/datum/artifact_effect/roboheal/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(7, curr_turf))
		to_chat(receiver, span_notice(LANG("datum.6e93c0d18174c133", null)))
		heal_target(receiver, 50)

/datum/artifact_effect/hurt
	log_name = "Hurt"

/**
 * Deals damage to mobs via take_overall_damage
 *
 * Arguments:
 * * receiver - mob to damage
 * * damage_power - how much to damage
 */
/datum/artifact_effect/hurt/proc/deal_damage(mob/living/receiver, damage_power)
	if(ishuman(receiver))
		var/mob/living/carbon/human/human_receiver = receiver
		var/weakness = get_anomaly_protection(human_receiver)
		human_receiver.take_overall_damage(damage_power * weakness, damage_power * weakness)
		return
	receiver.take_overall_damage(damage_power, damage_power)

/datum/artifact_effect/hurt/do_effect_touch(mob/user)
	. = ..()
	if(!.)
		return
	to_chat(user, span_warning(LANG("datum.c3c154f829f01e59", null)))
	deal_damage(user, 10)
	return TRUE

/datum/artifact_effect/hurt/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(range, curr_turf))
		to_chat(receiver, span_warning(LANG("datum.cb37d1032306409f", null)))
		deal_damage(receiver, 0.5 * seconds_per_tick)

/datum/artifact_effect/hurt/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice(LANG("datum.65ba11592ad4c03b", null)))
		deal_damage(receiver, 2.5 * (used_power / 3) * seconds_per_tick)

/datum/artifact_effect/hurt/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(7, curr_turf))
		to_chat(receiver, span_warning(LANG("datum.91e3881f35717a5a", null)))
		deal_damage(receiver, 50)

/datum/artifact_effect/robohurt
	log_name = "Robo-hurt"

/datum/artifact_effect/robohurt/New()
	. = ..()
	type_name = pick(ARTIFACT_EFFECT_ELECTRO, ARTIFACT_EFFECT_PARTICLE)

/**
 * Deals damage to silicons only
 *
 * Arguments:
 * * receiver - mob to damage
 * * damage_power - how much to damage
 */
/datum/artifact_effect/robohurt/proc/deal_damage(mob/living/receiver, damage_power)
	receiver.take_overall_damage(damage_power, damage_power)

/datum/artifact_effect/robohurt/do_effect_touch(mob/user)
	. = ..()
	if(!.)
		return
	if(!issilicon(user))
		return
	to_chat(user, span_warning(LANG("datum.e2ebcb42c145ad74", null)))
	deal_damage(user, 10)

/datum/artifact_effect/robohurt/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(range, curr_turf))
		to_chat(receiver, span_warning(LANG("datum.cc1dff8035e84570", null)))
		deal_damage(receiver, 0.5 * seconds_per_tick)

/datum/artifact_effect/robohurt/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(range, curr_turf))
		to_chat(receiver, span_warning(LANG("datum.e3ba8292a5208ccc", null)))
		deal_damage(receiver, 0.25 * used_power * seconds_per_tick)

/datum/artifact_effect/robohurt/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(7, curr_turf))
		to_chat(receiver, span_warning(LANG("datum.b9d5eb5e1e7d18d9", null)))
		deal_damage(receiver, 50)
