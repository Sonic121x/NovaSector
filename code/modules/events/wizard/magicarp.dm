/datum/round_event_control/wizard/magicarp //these fish is loaded
	name = "鲤鱼王"
	weight = 1
	typepath = /datum/round_event/carp_migration/wizard
	max_occurrences = 1
	earliest_start = 0 MINUTES
	description = "召唤一群会发射魔法弹的鲤鱼。"
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 6
	admin_setup = list(/datum/event_admin_setup/carp_migration)

/datum/round_event/carp_migration/wizard
	carp_type = /mob/living/basic/carp/magic
	boss_type = /mob/living/basic/carp/magic/chaos
	fluff_signal = "Unknown magical entities"
