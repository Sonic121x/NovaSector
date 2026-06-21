/datum/mutation/void
	name = "虚空磁石"
	desc = "一种罕见的基因组，会吸引通常无法观测到的奇异力量。"
	quality = MINOR_NEGATIVE //upsides and downsides
	text_gain_indication = span_notice("你感觉到一股沉重、迟钝的力量正在墙外注视着你。")
	instability = POSITIVE_INSTABILITY_MODERATE // useful, but has large drawbacks
	power_path = /datum/action/cooldown/spell/void/cursed
	energy_coeff = 1
	synchronizer_coeff = 1

/datum/mutation/void/setup()
	. = ..()
	var/datum/action/cooldown/spell/void/cursed/to_modify = .
	if(!istype(to_modify)) // null or invalid
		return

	to_modify.curse_probability_modifier = GET_MUTATION_SYNCHRONIZER(src)
	return .

/// The base "void invocation" action. No side effects.
/datum/action/cooldown/spell/void
	name = "召唤虚空"
	desc = "将你暂时拉入虚空口袋，使你无敌。"
	button_icon_state = "void_magnet"

	school = SCHOOL_EVOCATION
	cooldown_time = 1 MINUTES

	invocation = "DOOOOOOOOOOOOOOOOOOOOM!!!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	antimagic_flags = NONE

/datum/action/cooldown/spell/void/is_valid_target(atom/cast_on)
	return isturf(cast_on.loc)

/datum/action/cooldown/spell/void/cast(atom/cast_on)
	. = ..()
	new /obj/effect/immortality_talisman/void(get_turf(cast_on), cast_on)

/// The cursed "void invocation" action, that has a chance of casting itself on its owner randomly on life ticks.
/datum/action/cooldown/spell/void/cursed
	name = "召集虚空" //magic the gathering joke here
	desc = "一种罕见的基因组，会吸引通常无法观测到的奇异力量。有时可能会随机将你拉入其中。"
	/// A multiplier applied to the probability of the curse appearing every life tick
	var/curse_probability_modifier = 1

/datum/action/cooldown/spell/void/cursed/Grant(mob/grant_to)
	. = ..()
	if(!owner)
		return

	RegisterSignal(grant_to, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/action/cooldown/spell/void/cursed/Remove(mob/remove_from)
	UnregisterSignal(remove_from, COMSIG_LIVING_LIFE)
	return ..()

/// Signal proc for [COMSIG_LIVING_LIFE]. Has a chance of casting itself randomly.
/datum/action/cooldown/spell/void/cursed/proc/on_life(mob/living/source, seconds_per_tick)
	SIGNAL_HANDLER

	if(HAS_TRAIT(source, TRAIT_STASIS) || source.stat == DEAD)
		return

	if(!is_valid_target(source))
		return

	var/prob_of_curse = 0.25

	var/mob/living/carbon/carbon_source = source
	if(istype(carbon_source) && carbon_source.dna)
		// If we have DNA, the probability of curse changes based on how stable we are
		prob_of_curse += ((100 - carbon_source.dna.stability) / 40)

	prob_of_curse *= curse_probability_modifier

	if(!SPT_PROB(prob_of_curse, seconds_per_tick))
		return

	cast(source)
