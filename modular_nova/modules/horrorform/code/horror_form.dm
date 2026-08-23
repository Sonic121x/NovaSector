/datum/action/changeling/horror_form //Horror Form: turns the changeling into a terrifying abomination
	name = "Horror Form"
	desc = "We tear apart our human disguise, revealing our true form."
	helptext = "We will become an unstoppable force of destruction. If we die in this form, we will reach equilibrium and explode into a shower of gore! We require the absorption of at least one other human, and 15 extracts of DNA."
	button_icon = 'modular_nova/modules/horrorform/icons/actions_changeling.dmi'
	button_icon = 'modular_nova/modules/horrorform/icons/actions_changeling.dmi'
	button_icon_state = "horror_form"
	background_icon_state = "bg_changeling"
	chemical_cost = 50
	dna_cost = 4 //Tier 4
	req_dna = 15
	req_absorbs = 1
	req_human = 1
	req_stat = SOFT_CRIT

/datum/action/changeling/horror_form/sting_action(mob/living/carbon/human/user)
	..()
	if(!user || HAS_TRAIT(user, TRAIT_NO_TRANSFORM))
		return 0
	user.visible_message(span_warning(LANG("datum.8f1cbf7347b4a3ef", list(user))), \
						span_danger(LANG("datum.0fbf72b87abb90eb", null)))
	if(!do_after(user, 3 SECONDS, target = user, timed_action_flags = IGNORE_HELD_ITEM))
		user.visible_message(span_warning(LANG("datum.54ea05030eddc7b3", list(user))), \
							span_warning(LANG("datum.058a9514885bc306", null)))
		return 0
	user.visible_message(span_warning(LANG("datum.ffcb520c4647a173", list(user))), \
						span_userdanger(LANG("datum.c7113ebbcdf17f6e", null)))
	if(user.handcuffed)
		var/obj/O = user.get_item_by_slot(ITEM_SLOT_HANDCUFFED)
		if(istype(O))
			qdel(O)
	if(user.legcuffed)
		var/obj/O = user.get_item_by_slot(ITEM_SLOT_LEGCUFFED)
		if(istype(O))
			qdel(O)
	if(user.wear_suit && user.wear_suit.breakouttime)
		var/obj/item/clothing/suit/S = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		if(istype(S))
			qdel(S)
	if(istype(user.loc, /obj/structure/closet))
		var/obj/structure/closet/C = user.loc
		if(istype(C))
			if(C && user.loc == C)
				C.visible_message(span_warning(LANG("datum.5cc0a5a077911538", list(C))))
				new /obj/effect/decal/cleanable/greenglow(C.drop_location())
				C.welded = FALSE
				C.locked = FALSE
				C.broken = TRUE
				C.open()

	var/mob/living/basic/true_changeling/new_mob = new(get_turf(user))

	//Currently this is a thing as changeling ID's are not longer a thing
	//Feel free to re-add them whomever wants to -Azarak
	var/changeling_name
	if(user.gender == FEMALE)
		changeling_name = "Ms. "
	else if(user.gender == MALE)
		changeling_name = "Mr. "
	else
		changeling_name = "Mx. "
	changeling_name += pick(GLOB.greek_letters) //Abductor suffixes are the same ones as changelings

	new_mob.real_name = changeling_name
	new_mob.name = new_mob.real_name
	new_mob.stored_changeling = user
	user.loc = new_mob
	ADD_TRAIT(user, TRAIT_GODMODE, "Changeling_True_Form")
	user.mind.transfer_to(new_mob)
	user.spawn_gibs()
	//feedback_add_details("changeling_powers","HF")
	return 1
