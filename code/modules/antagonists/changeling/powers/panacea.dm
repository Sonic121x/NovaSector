/datum/action/changeling/panacea
	name = "组织万能药"
	desc = "从我们的形态中排出杂质：治愈疾病、移除寄生虫、使我们清醒、净化毒素与辐射、治愈创伤与脑损伤，并完全重置我们的遗传密码。消耗20点化学物质。"
	helptext = "Can be used while unconscious."
	button_icon_state = "anatomic_panacea"
	category = "utility"
	chemical_cost = 20
	dna_cost = 1
	req_stat = HARD_CRIT

//Heals the things that the other regenerative abilities don't.
/datum/action/changeling/panacea/sting_action(mob/user)
	to_chat(user, span_notice("我们净化了自身形态中的杂质。"))
	..()
	var/list/bad_organs = list(
		user.get_organ_by_type(/obj/item/organ/empowered_borer_egg), // NOVA EDIT ADDITION
		user.get_organ_by_type(/obj/item/organ/body_egg),
		user.get_organ_by_type(/obj/item/organ/legion_tumour),
		user.get_organ_by_type(/obj/item/organ/zombie_infection),
	)


	try_to_mutant_cure(user) //NOVA EDIT ADDITION

	for(var/o in bad_organs)
		var/obj/item/organ/O = o
		if(!istype(O))
			continue

		O.Remove(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 0)
		O.forceMove(get_turf(user))
	//NOVA EDIT Start: Cortical Borer
	var/mob/living/basic/cortical_borer/cb_inside = user.has_borer()
	if(cb_inside)
		cb_inside.leave_host()
	//NOVA EDIT Stop: Cortical Borer
	user.reagents.add_reagent(/datum/reagent/medicine/mutadone, 10)
	user.reagents.add_reagent(/datum/reagent/medicine/pen_acid, 20)
	user.reagents.add_reagent(/datum/reagent/medicine/antihol, 10)
	user.reagents.add_reagent(/datum/reagent/medicine/mannitol, 25)

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)

	if(isliving(user))
		var/mob/living/L = user
		for(var/thing in L.diseases)
			var/datum/disease/D = thing
			if(D.severity == DISEASE_SEVERITY_POSITIVE)
				continue
			D.cure()
	return TRUE
