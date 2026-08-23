// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/swapper
	name = "quantum spin inverter"
	desc = "An experimental device that is able to swap the locations of two entities by switching their particles' spin values. Must be linked to another device to function."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "swapper"
	inhand_icon_state = "electronic"
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NOBLUDGEON
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING
	custom_materials = list(/datum/material/bluespace = SHEET_MATERIAL_AMOUNT, /datum/material/gold = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT)
	/// Cooldown for usage
	var/cooldown = 30 SECONDS
	/// Next available time
	var/next_use = 0
	/// Swapper linked to this obj
	var/obj/item/swapper/linked_swapper

/obj/item/swapper/Destroy()
	if(linked_swapper)
		linked_swapper.linked_swapper = null //*inception music*
		linked_swapper.update_appearance()
		linked_swapper = null
	return ..()

/obj/item/swapper/update_icon_state()
	icon_state = "swapper[linked_swapper ? "-linked" : null]"
	return ..()

/obj/item/swapper/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/swapper))
		return NONE
	var/obj/item/swapper/other_swapper = tool
	if(other_swapper.linked_swapper)
		to_chat(user, span_warning(LANG("obj.8285a548ab3b3b24", list(other_swapper))))
		return ITEM_INTERACT_BLOCKING
	if(linked_swapper)
		to_chat(user, span_warning(LANG("obj.8285a548ab3b3b24", list(src))))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.44fad32a002399ce", null)))
	linked_swapper = other_swapper
	other_swapper.linked_swapper = src
	update_appearance()
	linked_swapper.update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/swapper/attack_self(mob/living/user)
	if(world.time < next_use)
		to_chat(user, span_warning(LANG("obj.ebecee81f11d5508", list(src))))
		return
	//NOVA EDIT BEGIN
	var/turf/my_turf = get_turf(src)
	if(is_away_level(my_turf.z))
		to_chat(user, LANG("obj.cd44f8b6122f897f", list(src)))
		return
	//NOVA EDIT END
	if(QDELETED(linked_swapper))
		to_chat(user, span_warning(LANG("obj.bb1062b497de8110", list(src))))
		return
	playsound(src, 'sound/items/weapons/flash.ogg', 25, TRUE)
	to_chat(user, span_notice(LANG("obj.93dc532f3683b9e1", list(src))))
	playsound(linked_swapper, 'sound/items/weapons/flash.ogg', 25, TRUE)
	if(ismob(linked_swapper.loc))
		var/mob/holder = linked_swapper.loc
		to_chat(holder, span_notice(LANG("obj.d10a43ce3772714d", list(linked_swapper))))
	next_use = world.time + cooldown //only the one used goes on cooldown
	addtimer(CALLBACK(src, PROC_REF(swap), user), 2.5 SECONDS)

/obj/item/swapper/examine(mob/user)
	. = ..()
	if(world.time < next_use)
		. += span_warning(LANG("obj.8d1266abc75bcb71", list(DisplayTimeText(next_use - world.time))))
	if(linked_swapper)
		. += span_notice(LANG("obj.9b2ab3148332ffd3", null))
	else
		. += span_notice(LANG("obj.be5dee28a69b4bf3", null))

/obj/item/swapper/click_alt(mob/living/user)
	to_chat(user, span_notice(LANG("obj.1b692aa0dd68f481", null)))
	if(!QDELETED(linked_swapper))
		linked_swapper.linked_swapper = null
		linked_swapper.update_appearance()
		linked_swapper = null
	update_appearance()
	return CLICK_ACTION_SUCCESS

/**
 * Swaps two atoms following the activation of a swapper item.
 * If a mob is holding a swapper, it will carry the mob as-per the rules of do_teleport().
 */
/obj/item/swapper/proc/swap(mob/user)
	if(QDELETED(linked_swapper) || isnull(linked_swapper.loc) || world.time < linked_swapper.cooldown)
		return

	var/atom/movable/container_A = get_teleportable_container(src)
	var/atom/movable/container_B = get_teleportable_container(linked_swapper)
	var/target_A = container_A.drop_location()
	var/target_B = container_B.drop_location()

	playsound(target_A, 'sound/effects/swapper/swap_a.ogg', 30, TRUE)
	playsound(target_B, 'sound/effects/swapper/swap_b.ogg', 30, TRUE)
	if(do_teleport(container_A, target_B, channel = TELEPORT_CHANNEL_QUANTUM))
		do_teleport(container_B, target_A, channel = TELEPORT_CHANNEL_QUANTUM)
		if(ismob(container_B))
			var/mob/swapped_mob = container_B
			to_chat(swapped_mob, span_warning(LANG("obj.d4239674625b24cb", list(linked_swapper))))
