/datum/action/changeling/chameleon_skin
	name = "变色皮肤"
	desc = "我们的皮肤色素会迅速改变以适应当前环境。消耗10点化学物质。"
	helptext = "Allows us to become invisible after a few seconds of standing still. Can be toggled on and off."
	button_icon_state = "chameleon_skin"
	category = "stealth"
	dna_cost = 1
	chemical_cost = 10
	req_human = TRUE

/datum/action/changeling/chameleon_skin/sting_action(mob/user)
	var/mob/living/carbon/human/cling = user //SHOULD always be human, because req_human = TRUE
	if(!istype(cling)) // req_human could be done in can_sting stuff.
		return
	..()
	if(cling.dna.get_mutation(/datum/mutation/chameleon/changeling))
		cling.dna.remove_mutation(/datum/mutation/chameleon/changeling, MUTATION_SOURCE_CHANGELING)
	else
		cling.dna.add_mutation(/datum/mutation/chameleon/changeling, MUTATION_SOURCE_CHANGELING)
	return TRUE

/datum/action/changeling/chameleon_skin/Remove(mob/user)
	if(user.has_dna())
		var/mob/living/carbon/cling = user
		cling.dna.remove_mutation(/datum/mutation/chameleon/changeling, MUTATION_SOURCE_CHANGELING)
	..()
