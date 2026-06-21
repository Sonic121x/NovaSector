
/datum/action/item_action/cult_dagger
	name = "绘制血之符文"
	desc = "使用仪式匕首创造一个强大的血之符文"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"
	buttontooltipstyle = "cult"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	default_button_position = "6:157,4:-2"

/datum/action/item_action/cult_dagger/Grant(mob/grant_to)
	if(!IS_CULTIST(grant_to))
		return

	return ..()

/datum/action/item_action/cult_dagger/do_effect(trigger_flags)
	if(!isliving(owner))
		to_chat(owner, span_warning("你缺乏进行此操作所需的生命能量。"))
		return FALSE

	var/obj/item/target_item = target
	var/mob/living/living_owner = owner
	if(target in owner.held_items)
		target_item.attack_self(owner)
		return TRUE

	if(owner.can_equip(target_item, ITEM_SLOT_HANDS))
		owner.temporarilyRemoveItemFromInventory(target_item)
		owner.put_in_hands(target_item)
		target_item.attack_self(owner)
		return TRUE

	if (living_owner.usable_hands <= 0)
		to_chat(living_owner, span_warning("你没有可用的手！"))
	else
		to_chat(living_owner, span_warning("你的手已经满了！"))
	return FALSE
