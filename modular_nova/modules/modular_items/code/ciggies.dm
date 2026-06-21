/obj/item/holocigarette
	name = "全息香烟"
	desc = "一种使用全息甲板技术制造的香烟。想吸烟又不想承受所有副作用？试试全息香烟吧！"
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigoff"
	throw_speed = 0.5
	inhand_icon_state = "cigoff"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MASK
	// Note - these are in masks.dmi not in cigarette.dmi
	/// The icon state used when this is lit.
	var/icon_on = "cigon"
	/// The icon state used when this is extinguished.
	var/icon_off = "cigoff"
	var/lit = FALSE
	actions_types = list(/datum/action/item_action/toggle_lit)

/obj/item/holocigarette/cigar
	name = "璀璨宇宙雪茄"
	desc = "一种使用全息甲板技术制造的精致雪茄。看起来它们的包装上印有“璀璨宇宙”的品牌标识。"
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"

/datum/action/item_action/toggle_lit
	name = "点燃"
	desc = "点燃或熄灭全息香烟"

/datum/action/item_action/toggle_lit/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/holocigarette/smoked = target
	var/mob/living/carbon/smoker = owner
	if(smoked.lit == FALSE)
		smoked.icon_state = smoked.icon_on
		smoked.worn_icon_state = smoked.icon_on
		smoked.inhand_icon_state = smoked.icon_on
		smoked.lit = TRUE
		smoked.name = "点燃的 [smoked.name]"
	else
		smoked.icon_state = smoked.icon_off
		smoked.worn_icon_state = smoked.icon_off
		smoked.inhand_icon_state = smoked.icon_off
		smoked.lit = FALSE
		smoked.name = copytext_char(smoked.name, 5) //5 == length_char("lit ") + 1
	smoked.update_icon()
	smoker.update_worn_mask()
	smoker.update_held_items()
