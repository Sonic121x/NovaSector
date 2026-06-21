/datum/borer_evolution/hivelord
	evo_type = BORER_EVOLUTION_HIVELORD

// T1
/datum/borer_evolution/hivelord/produce_offspring
	name = "产卵"
	desc = "产下一枚卵，你的宿主会将其呕吐出来。"
	gain_text = "The way that a Cortical Borer produces an egg is a strange one. So far, we have not seen how it produces one, or it doing so outside a host."
	tier = 1
	unlocked_evolutions = list(/datum/borer_evolution/hivelord/blood_chemical)
	evo_cost = 1

/datum/borer_evolution/hivelord/produce_offspring/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	var/datum/action/cooldown/borer/produce_offspring/attack_action = new(cortical_owner)
	attack_action.Grant(cortical_owner)

// T2
/datum/borer_evolution/hivelord/blood_chemical
	name = "学习血液化学品"
	desc = "从宿主的血液中学习一种可合成的化学品。"
	gain_text = "As we were dissecting a former host monkey's fecal matter, I noticed a high concentration of banana matter, despite us not feeding them any for the past week."
	tier = 2
	unlocked_evolutions = list(/datum/borer_evolution/hivelord/movespeed)

/datum/borer_evolution/hivelord/blood_chemical/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	var/datum/action/cooldown/borer/learn_bloodchemical/attack_action = new(cortical_owner)
	attack_action.Grant(cortical_owner)

// T3
/datum/borer_evolution/hivelord/movespeed
	name = "能量提升"
	desc = "大幅提升你的速度。"
	gain_text = "And as I watched, the Cortical Borer was able to complete the course in just over half the time it had last week."
	mutually_exclusive = TRUE
	tier = 3
	unlocked_evolutions = list(/datum/borer_evolution/hivelord/stealth_mode)

/datum/borer_evolution/hivelord/movespeed/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.add_movespeed_modifier(/datum/movespeed_modifier/borer_speed)

// T4
/datum/borer_evolution/hivelord/stealth_mode
	name = "潜行模式"
	desc = "在潜行模式下，你在宿主体内的存在感会大大降低，但你也无法获得被动增益。"
	gain_text = "As I was writing my report one day, I noticed that one of the worms had slipped out of its cage and into a monkey without so much as a sound. Fascinating how they seem to know the importance of sound."
	tier = 4
	unlocked_evolutions = list(/datum/borer_evolution/hivelord/produce_offspring_alone)

/datum/borer_evolution/hivelord/stealth_mode/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	var/datum/action/cooldown/borer/stealth_mode/attack_action = new(cortical_owner)
	attack_action.Grant(cortical_owner)

// T5
/datum/borer_evolution/hivelord/produce_offspring_alone
	name = "产卵 II"
	desc = "允许你在宿主体外产卵，但会消耗生命值和化学品。"
	gain_text = "One of the worms seems to have taken an... Alpha position in the hive, producing more eggs than the others. Most worryingly, eggs have shown up without them having a host, but I haven't *seen* them lay any..."
	evo_cost = 3
	tier = 5
	unlocked_evolutions = list(
		/datum/borer_evolution/sugar_immunity,
		/datum/borer_evolution/synthetic_borer,
		/datum/borer_evolution/synthetic_chems_positive,
		/datum/borer_evolution/synthetic_chems_negative,
	)

/datum/borer_evolution/hivelord/produce_offspring_alone/on_evolve(mob/living/basic/cortical_borer/cortical_owner)
	. = ..()
	cortical_owner.upgrade_flags |= BORER_ALONE_PRODUCTION
