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
	to_chat(user, span_notice("一股舒缓的能量使你精神焕发。"))
	heal_target(user, 25)

/datum/artifact_effect/heal/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice("一股能量波使你精神焕发。"))
		heal_target(receiver, rand(1,3)/2 * seconds_per_tick)

/datum/artifact_effect/heal/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice("一股能量波使你精神焕发。"))
		heal_target(receiver, 2.5 * used_power * seconds_per_tick)

/datum/artifact_effect/heal/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(7, curr_turf))
		to_chat(receiver, span_notice("一股能量波治愈了你的伤口。"))
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
	to_chat(user, span_notice("你的系统报告受损组件正在自行修复！"))
	heal_target(user, 25)

/datum/artifact_effect/roboheal/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice("系统警报：检测到有益能量场！"))
		heal_target(receiver, 0.5 * seconds_per_tick)

/datum/artifact_effect/roboheal/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice("系统警报：结构损伤已被能量脉冲修复！"))
		heal_target(receiver, 2.5 * used_power * seconds_per_tick)

/datum/artifact_effect/roboheal/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(7, curr_turf))
		to_chat(receiver, span_notice("系统警报：结构损伤已被能量脉冲修复！"))
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
	to_chat(user, span_warning("一股痛苦的能量放电击中了你！"))
	deal_damage(user, 10)
	return TRUE

/datum/artifact_effect/hurt/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(range, curr_turf))
		to_chat(receiver, span_warning("你感觉到附近有某种东西散发出痛苦的力量。"))
		deal_damage(receiver, 0.5 * seconds_per_tick)

/datum/artifact_effect/hurt/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(range, curr_turf))
		to_chat(receiver, span_notice("一股能量波使你精力充沛，同时撕裂了你的血肉。"))
		deal_damage(receiver, 2.5 * (used_power / 3) * seconds_per_tick)

/datum/artifact_effect/hurt/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/receiver in range(7, curr_turf))
		to_chat(receiver, span_warning("你感到剧烈的疼痛"))
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
	to_chat(user, span_warning("你的系统报告遭受了严重损伤！"))
	deal_damage(user, 10)

/datum/artifact_effect/robohurt/do_effect_aura(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(range, curr_turf))
		to_chat(receiver, span_warning("系统警报：检测到有害能量场！"))
		deal_damage(receiver, 0.5 * seconds_per_tick)

/datum/artifact_effect/robohurt/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/used_power = .
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(range, curr_turf))
		to_chat(receiver, span_warning("系统警报：能量脉冲造成了结构损伤！"))
		deal_damage(receiver, 0.25 * used_power * seconds_per_tick)

/datum/artifact_effect/robohurt/do_effect_destroy()
	var/turf/curr_turf = get_turf(holder)
	for(var/mob/living/silicon/receiver in range(7, curr_turf))
		to_chat(receiver, span_warning("系统警报：能量脉冲造成了严重结构损伤！"))
		deal_damage(receiver, 50)
