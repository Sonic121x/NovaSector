/datum/round_event_control/wizard/summonguns //The Classic
	name = "召唤枪支"
	weight = 1
	typepath = /datum/round_event/wizard/summonguns
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "为每个人召唤一把枪。可能会把人变成生存主义者。"

/datum/round_event_control/wizard/summonguns/New()
	if(CONFIG_GET(flag/no_summon_guns))
		weight = 0
	return ..()

/datum/round_event/wizard/summonguns/start()
	summon_guns(survivor_probability = 10)

/datum/round_event_control/wizard/summonmagic //The Somewhat Less Classic
	name = "召唤法术"
	weight = 1
	typepath = /datum/round_event/wizard/summonmagic
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "为每个人召唤一件魔法物品。可能会把人变成生存主义者。"

/datum/round_event_control/wizard/summonmagic/New()
	if(CONFIG_GET(flag/no_summon_magic))
		weight = 0
	return ..()

/datum/round_event/wizard/summonmagic/start()
	summon_magic(survivor_probability = 10)
