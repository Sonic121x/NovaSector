/datum/action/cooldown/spell/conjure/creature
	name = "召唤生物群集"
	desc = "这一咒语破坏了现实的结构，致使可怕的恶魔纷纷涌现出来。"
	sound = 'sound/effects/magic/summonitems_generic.ogg'

	school = SCHOOL_CONJURATION
	cooldown_time = 2 MINUTES

	invocation = "IA IA!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE

	summon_radius = 3
	summon_type = list(/mob/living/basic/creature)
	summon_amount = 10
