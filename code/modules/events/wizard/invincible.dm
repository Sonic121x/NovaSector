/datum/round_event_control/wizard/invincible //Boolet Proof
	name = "无敌"
	weight = 3
	typepath = /datum/round_event/wizard/invincible
	max_occurrences = 5
	earliest_start = 0 MINUTES
	description = "每个人在短时间内都变得无敌。"
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 7

/datum/round_event/wizard/invincible/start()

	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		H.reagents.add_reagent(/datum/reagent/medicine/adminordrazine, 40) //100 ticks of absolute invinciblity (barring gibs)
		to_chat(H, span_notice("你感到自己刀枪不入，没有什么能伤害到你！"))
