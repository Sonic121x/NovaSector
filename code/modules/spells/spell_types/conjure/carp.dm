/datum/action/cooldown/spell/conjure/carp
	name = "召唤鲤鱼"
	desc = "这个咒语能召唤出一条普通的鲤鱼。"
	sound = 'sound/effects/magic/summon_karp.ogg'

	school = SCHOOL_CONJURATION
	cooldown_time = 2 MINUTES

	invocation = "NOUK FHUNMM SACP RISSKA!"
	invocation_type = INVOCATION_SHOUT

	summon_radius = 1
	summon_type = list(/mob/living/basic/carp)
