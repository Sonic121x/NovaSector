/datum/action/changeling/adrenaline
	name = "基因刺激"
	desc = "我们将化学物质浓缩成一种强效兴奋剂，使我们的形态对失能状态具有惊人的抵抗力。消耗25点化学物质。"
	helptext = "Disregard any condition that has stunned us and suffuse our form with FOUR units of Changeling Adrenaline; our form recovers massive stamina and simply disregards any pain or fatigue during its effects."
	button_icon_state = "adrenaline"
	category = "combat"
	chemical_cost = 25 // similar cost to biodegrade, as they serve similar purposes
	dna_cost = 2
	req_human = FALSE
	req_stat = CONSCIOUS
	disabled_by_fire = TRUE

//Recover from stuns.
/datum/action/changeling/adrenaline/sting_action(mob/living/carbon/user)
	..()

	// Get us standing up.
	user.SetAllImmobility(0)
	user.set_stamina_loss(0)
	user.set_resting(FALSE, instant = TRUE)

	user.reagents.add_reagent(/datum/reagent/medicine/changelingadrenaline, 4) //Tank 5 consecutive baton hits

	to_chat(user, span_changeling("这种为我们生物学特性精确调制的兴奋剂带来的惊人冲击令人振奋。我们不会被制服。"))

	return TRUE
