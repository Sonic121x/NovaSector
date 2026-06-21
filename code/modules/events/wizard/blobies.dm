/datum/round_event_control/wizard/blobies //avast!
	name = "僵尸爆发"
	weight = 3
	typepath = /datum/round_event/wizard/blobies
	max_occurrences = 3
	description = "在每个尸体上生成一个凝胶芽孢。"
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/blobies/start()

	for(var/mob/living/carbon/human/H in GLOB.dead_mob_list)
		new /mob/living/basic/blob_minion/spore/minion(H.loc) // Creates zombies which ghosts can control
