/datum/borer_evolution/upgrade_injection
	name = "注射升级"
	desc = "将你的最大注射量提升至10单位。"
	gain_text = "Their growth is astounding, their organs and glands can expand several times their size in mere days."
	unlocked_evolutions = list(/datum/borer_evolution/upgrade_injection/t2)
	tier = 1

/datum/borer_evolution/upgrade_injection/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.injection_rates_unlocked += cortical_owner.injection_rates[length(cortical_owner.injection_rates_unlocked) + 1]

/datum/borer_evolution/upgrade_injection/t2
	name = "注射升级 II"
	desc = "将你的最大注射量提升至25单位。"
	unlocked_evolutions = list(/datum/borer_evolution/upgrade_injection/t3)
	tier = 2

/datum/borer_evolution/upgrade_injection/t3
	name = "注射升级 III"
	desc = "将你的最大注射量提升至50单位。"
	unlocked_evolutions = list()
	tier = 3

/datum/borer_evolution/sugar_immunity
	name = "糖分免疫"
	desc = "使你或你的宿主对糖分的有害影响免疫。"
	gain_text = "Of the biggest ones, a few have managed to resist the effects of sugar. Truly concerning if we wish to keep them contained."
	evo_cost = 5
	tier = 6

/datum/borer_evolution/sugar_immunity/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.upgrade_flags |= BORER_SUGAR_IMMUNE

/datum/borer_evolution/synthetic_borer
	name = "合成体寄生"
	desc = "获得将合成人作为宿主的能力。"
	gain_text = "Now, we used robots to take care of the worms when they're alive, but one day... they all went haywire. Security took them down, closer inspection showed that the worms managed their way into the processing units."
	evo_cost = 6
	tier = 6

/datum/borer_evolution/synthetic_borer/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.organic_restricted = FALSE

/datum/borer_evolution/synthetic_chems_positive
	name = "合成体化学品 (+)"
	desc = "获得一系列有益的、与合成体兼容的化学品。"
	gain_text = "Once we had established that robots weren't safe either, we began to experiment with them. Interestingly enough, some of them never needed to be oiled again."
	tier = 6
	evo_cost = 6
	var/static/list/added_chemicals = list(
		/datum/reagent/consumable/ethanol/synthanol,
		/datum/reagent/medicine/system_cleaner,
		/datum/reagent/medicine/nanite_slurry,
		/datum/reagent/medicine/liquid_solder,
		/datum/reagent/fuel/oil,
		/datum/reagent/fuel,
	)

/datum/borer_evolution/synthetic_chems_positive/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.potential_chemicals |= added_chemicals

/datum/borer_evolution/synthetic_chems_negative
	name = "合成化学品 (-)"
	desc = "获得一份对合成人有害的化学品清单。"
	gain_text = "Good thing is, some of the worms were hostile to the robots, too. Corroded from the inside, some of them were basically husks."
	tier = 6
	evo_cost = 6
	var/static/list/added_chemicals = list(
		/datum/reagent/toxin/acid/fluacid, // More like anti everything but :shrug:
		/datum/reagent/thermite,
		/datum/reagent/pyrosium,
		/datum/reagent/oxygen,
	)

/datum/borer_evolution/synthetic_chems_negative/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.potential_chemicals |= added_chemicals
