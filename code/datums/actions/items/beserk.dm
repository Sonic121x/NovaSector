/datum/action/item_action/berserk_mode
	name = "狂暴"
	desc = "短时间内提升你的移动速度和近战速度，同时增加近战护甲。"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "berserk_mode"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

/datum/action/item_action/berserk_mode/do_effect(trigger_flags)
	var/obj/item/clothing/head/hooded/berserker/berserk = target
	berserk.berserk_mode(owner)
	return TRUE

/datum/action/item_action/berserk_mode/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(target, /obj/item/clothing/head/hooded/berserker))
		return FALSE

	var/obj/item/clothing/head/hooded/berserker/berserk = target
	if(berserk.berserk_active)
		if(feedback)
			to_chat(owner, span_warning("你已经处于狂暴状态了！"))
		return FALSE
	if(berserk.berserk_charge < 100)
		if(feedback)
			to_chat(owner, span_warning("你没有充满能量。"))
		return FALSE
	return TRUE
