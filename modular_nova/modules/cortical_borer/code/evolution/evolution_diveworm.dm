/datum/borer_evolution/diveworm
	evo_type = BORER_EVOLUTION_DIVEWORM

// T1
/datum/borer_evolution/diveworm/health_per_level
	name = "生命值提升"
	desc = "增加每次升级时获得的生命值。"
	gain_text = "Over time, some of the more aggressive worms became harder to dissect post-mortem. Their skin membrane has become up to thrice as thick."
	tier = 1
	unlocked_evolutions = list(/datum/borer_evolution/diveworm/host_speed)
	evo_cost = 1

/datum/borer_evolution/diveworm/health_per_level/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.health_per_level += 2.5
	cortical_owner.recalculate_stats()

// T2
/datum/borer_evolution/diveworm/host_speed
	name = "钻入速度"
	desc = "减少在未隐藏状态下进入宿主所需的时间。"
	gain_text = "Once or twice, I would blink, and see the non-host monkeys be grappling with a worm that was cross the room just moments before."
	tier = 2
	unlocked_evolutions = list(/datum/borer_evolution/diveworm/expanded_chemicals)

/datum/borer_evolution/diveworm/host_speed/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.upgrade_flags |= BORER_FAST_BORING

// T3 + T1 path
/datum/borer_evolution/diveworm/expanded_chemicals
	name = "扩展化学物质列表"
	desc = "获得一系列新的、可用于解锁的诡谲化学物质。"
	gain_text = "Sometimes, I would just see a known host monkey... collapse, then get up, then collapse again. It was as if the worm was playing with it..."
	mutually_exclusive = TRUE
	tier = 3
	unlocked_evolutions = list(
		/datum/borer_evolution/diveworm/harm_increase,
		/datum/borer_evolution/diveworm/health_per_level/t2,
	)
	var/static/list/added_chemicals = list(
		/datum/reagent/toxin/fentanyl,
		/datum/reagent/toxin/staminatoxin,
		/datum/reagent/toxin/mutetoxin,
		/datum/reagent/toxin/mutagen,
		/datum/reagent/toxin/cyanide,
		/datum/reagent/drug/opium,
		/datum/reagent/drug/mushroomhallucinogen,
		/datum/reagent/inverse/oculine,
	)

/datum/borer_evolution/diveworm/expanded_chemicals/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.potential_chemicals |= added_chemicals

/datum/borer_evolution/diveworm/health_per_level/t2
	name = "生命值提升 II"
	tier = -1
	unlocked_evolutions = list(/datum/borer_evolution/diveworm/health_per_level/t3)
	evo_cost = 2

/datum/borer_evolution/diveworm/health_per_level/t3
	name = "生命值提升 III"
	tier = -1
	unlocked_evolutions = list()
	evo_cost = 2

// T4 + its path
/datum/borer_evolution/diveworm/harm_increase
	name = "毒素增强"
	desc = "增加你对宿主造成的被动与主动伤害，并提高其发生频率。"
	gain_text = "In captivity, some of the worms became more... brutish, larger. Most notably, hosts succumbed much quicker to them."
	tier = 4
	unlocked_evolutions = list(
		/datum/borer_evolution/diveworm/harm_increase/t2,
		/datum/borer_evolution/diveworm/empowered_offspring,
	)

/datum/borer_evolution/diveworm/harm_increase/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.host_harm_multiplier += 0.25

/datum/borer_evolution/diveworm/harm_increase/t2
	name = "毒素增强 II"
	desc = "进一步增加你对宿主造成的被动与主动伤害，并提高其发生频率。"
	tier = -1
	unlocked_evolutions = list(/datum/borer_evolution/diveworm/harm_increase/t3)

/datum/borer_evolution/diveworm/harm_increase/t3
	name = "毒素增强 III"
	desc = "进一步增加你对宿主造成的被动与主动伤害，并提高其发生频率。"
	tier = -1
	unlocked_evolutions = list()

// T5
/datum/borer_evolution/diveworm/empowered_offspring
	name = "强化子嗣"
	desc = "在死亡的宿主体内产卵，经过一段延迟后，一只强化的脑蛆将破体而出。"
	gain_text = "Most eggs would be regurgitated through the throat from their hosts... but one did not. They exploded out the chest like a horror movie. What a worrying discovery."
	evo_cost = 3
	tier = 5
	unlocked_evolutions = list(
		/datum/borer_evolution/sugar_immunity,
		/datum/borer_evolution/synthetic_borer,
		/datum/borer_evolution/synthetic_chems_negative,
	)

/datum/borer_evolution/diveworm/empowered_offspring/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	var/datum/action/cooldown/borer/empowered_offspring/attack_action = new(cortical_owner)
	attack_action.Grant(cortical_owner)
