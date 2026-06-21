/datum/reagent/freon
	name = "Freon"
	description = "一种强效吸热剂。"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM  // Because nitrium/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "burning"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/freon/on_mob_metabolize(mob/living/breather)
	. = ..()
	breather.add_movespeed_modifier(/datum/movespeed_modifier/reagent/freon)

/datum/reagent/freon/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/freon)

/datum/reagent/halon
	name = "哈龙"
	description = "一种灭火气体，能移除氧气并冷却区域"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	color = "90560B"
	taste_description = "minty"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_RESISTHEAT)

/datum/reagent/halon/on_mob_metabolize(mob/living/breather)
	. = ..()
	breather.add_movespeed_modifier(/datum/movespeed_modifier/reagent/halon)

/datum/reagent/halon/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/halon)

/datum/reagent/healium
	name = "疗气"
	description = "一种具有治疗效果的强效催眠剂"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	color = "90560B"
	taste_description = "rubbery"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/healium/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.SetSleeping(1 SECONDS)

/datum/reagent/healium/on_mob_life(mob/living/breather, seconds_per_tick, metabolization_ratio)
	. = ..()
	breather.SetSleeping(30 SECONDS)
	var/need_mob_update
	need_mob_update = breather.adjust_fire_loss(-2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += breather.adjust_tox_loss(-5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += breather.adjust_brute_loss(-2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/hypernoblium
	name = "超铌"
	description = "一种抑制性气体，能阻止吸入者的气体反应。"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM // Because nitrium/freon/hyper-nob are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "searingly cold"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/hypernoblium/on_mob_life(mob/living/carbon/breather, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(isplasmaman(breather))
		breather.set_timed_status_effect(10 SECONDS * metabolization_ratio * seconds_per_tick, /datum/status_effect/hypernob_protection)

/datum/reagent/nitrium_high_metabolization
	name = "Nitrosyl plasmide-亚硝基质粒"
	description = "一种高活性副产物，能阻止你入睡，同时随时间推移造成递增的毒素伤害。"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM  // Because nitrium/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "E1A116"
	taste_description = "sourness"
	ph = 1.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	addiction_types = list(/datum/addiction/stimulants = 50)
	metabolized_traits = list(TRAIT_SLEEPIMMUNE)

/datum/reagent/nitrium_high_metabolization/on_mob_life(mob/living/carbon/breather, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = breather.adjust_stamina_loss(-4 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	need_mob_update += breather.adjust_tox_loss(0.1 * (current_cycle-1) * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype) // 1 toxin damage per cycle at cycle 10
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/nitrium_low_metabolization
	name = "Nitrium"
	description = "一种高活性气体，让你感觉更快。"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM // Because nitrium/freon/hypernoblium are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "burning"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/nitrium_low_metabolization/on_mob_metabolize(mob/living/breather)
	. = ..()
	breather.add_movespeed_modifier(/datum/movespeed_modifier/reagent/nitrium)

/datum/reagent/nitrium_low_metabolization/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/nitrium)

/datum/reagent/pluoxium
	name = "钚罗索仑-Pluoxium"
	description = "一种气体，在肺部扩散效率是氧气的八倍，并对睡眠中的患者具有器官愈合特性。"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	color = COLOR_GRAY
	taste_description = "irradiated air"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/pluoxium/on_mob_life(mob/living/carbon/breather, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!HAS_TRAIT(breather, TRAIT_KNOCKEDOUT))
		return

	for(var/obj/item/organ/organ_being_healed as anything in breather.organs)
		if(!organ_being_healed.damage)
			continue

		if(organ_being_healed.apply_organ_damage(-0.5 * metabolization_ratio * seconds_per_tick, required_organ_flag = ORGAN_ORGANIC))
			. = UPDATE_MOB_HEALTH

/datum/reagent/zauker
	name = "祖克"
	description = "一种对所有生物都有毒的不稳定气体。"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	color = "90560B"
	taste_description = "bitter"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE
	affected_biotype = MOB_ORGANIC | MOB_MINERAL | MOB_PLANT // "toxic to all living beings"
	affected_respiration_type = ALL

/datum/reagent/zauker/on_mob_life(mob/living/breather, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = breather.adjust_brute_loss(6 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += breather.adjust_oxy_loss(1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += breather.adjust_fire_loss(2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += breather.adjust_tox_loss(2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH
