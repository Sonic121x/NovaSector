/obj/item/reagent_containers/Initialize(mapload, vol)
	. = ..()

	AddElement(/datum/element/liquids_interaction)

// Remove liquids from a turf using a reagent container.
/obj/item/reagent_containers/attack_liquids_turf(turf/target_turf, mob/living/user, obj/effect/abstract/liquid_turf/liquids)
	if(user.combat_mode)
		return FALSE

	if(!user.Adjacent(target_turf))
		return FALSE

	if(liquids.fire_state) //Use an extinguisher first
		to_chat(user, span_warning(LANG("obj.bfec6b9542e3d604", null)))
		return TRUE

	if(liquids.height == 1)
		to_chat(user, span_warning(LANG("obj.cccc4d604eca6152", null)))
		return TRUE

	var/free_space = reagents.maximum_volume - reagents.total_volume
	if(free_space <= 0)
		to_chat(user, span_warning(LANG("obj.10f5d04012887518", list(src))))
		return TRUE

	var/desired_transfer = amount_per_transfer_from_this
	if(desired_transfer > free_space)
		desired_transfer = free_space

	var/datum/reagents/tempr = liquids.take_reagents_flat(desired_transfer)
	tempr.trans_to(reagents, tempr.total_volume)
	to_chat(user, span_notice(LANG("obj.e2964bfcb7ca8b2a", list(amount_per_transfer_from_this, src))))
	qdel(tempr)
	user.changeNext_move(CLICK_CD_MELEE)
	return TRUE
