/// Ties the target's shoes
/datum/smite/knot_shoes
	name = "Knot Shoes-打鞋结"

/datum/smite/knot_shoes/effect(client/user, mob/living/target)
	. = ..()
	if (!iscarbon(target))
		to_chat(user, span_warning("此功能必须对碳基生物使用。"), confidential = TRUE)
		return
	var/mob/living/carbon/dude = target
	var/obj/item/clothing/shoes/sick_kicks = dude.shoes
	if (!sick_kicks || sick_kicks.fastening_type == SHOES_SLIPON)
		to_chat(user, span_warning("[dude] 没有可打结的鞋子！"), confidential = TRUE)
		return
	sick_kicks.adjust_laces(SHOES_KNOTTED)
