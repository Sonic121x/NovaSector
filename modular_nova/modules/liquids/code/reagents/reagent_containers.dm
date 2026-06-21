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
		to_chat(user, span_warning("它着火的时候你没法舀起任何东西！"))
		return TRUE

	if(liquids.height == 1)
		to_chat(user, span_warning("水坑太浅了，舀不起任何东西！"))
		return TRUE

	var/free_space = reagents.maximum_volume - reagents.total_volume
	if(free_space <= 0)
		to_chat(user, span_warning("你没法往[src]里装更多液体了！"))
		return TRUE

	var/desired_transfer = amount_per_transfer_from_this
	if(desired_transfer > free_space)
		desired_transfer = free_space

	var/datum/reagents/tempr = liquids.take_reagents_flat(desired_transfer)
	tempr.trans_to(reagents, tempr.total_volume)
	to_chat(user, span_notice("你用[src]舀起了大约[amount_per_transfer_from_this]单位的液体。"))
	qdel(tempr)
	user.changeNext_move(CLICK_CD_MELEE)
	return TRUE
