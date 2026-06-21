/obj/item/clothing/head
	name = BODY_ZONE_HEAD
	icon = 'icons/obj/clothing/head/default.dmi'
	worn_icon = 'icons/mob/clothing/head/default.dmi'
	lefthand_file = 'icons/mob/inhands/clothing/hats_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/hats_righthand.dmi'
	abstract_type = /obj/item/clothing/head
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_HEAD

///Special throw_impact for hats to frisbee hats at people to place them on their heads/attempt to de-hat them.
/obj/item/clothing/head/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()
	///if the thrown object's target zone isn't the head
	if(thrownthing.target_zone != BODY_ZONE_HEAD)
		return
	///ignore any hats with the tinfoil counter-measure enabled
	if(clothing_flags & ANTI_TINFOIL_MANEUVER)
		return
	///if the hat happens to be capable of holding contents and has something in it. mostly to prevent super cheesy stuff like stuffing a mini-bomb in a hat and throwing it
	if(LAZYLEN(contents))
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/H = hit_atom
		if(istype(H.head, /obj/item))
			var/obj/item/WH = H.head
			///check if the item has NODROP
			if(HAS_TRAIT(WH, TRAIT_NODROP))
				H.visible_message(span_warning("[src] 从 [H] 的 [WH.name] 上弹开了！"), span_warning("[src] 从你的 [WH.name] 上弹开，掉到了地上。"))
				return
			///check if the item is an actual clothing head item, since some non-clothing items can be worn
			if(istype(WH, /obj/item/clothing/head))
				var/obj/item/clothing/head/WHH = WH
				///SNUG_FIT hats are immune to being knocked off
				if(WHH.clothing_flags & SNUG_FIT)
					H.visible_message(span_warning("[src] 从 [H] 的 [WHH.name] 上弹开了！"), span_warning("[src] 从你的 [WHH.name] 上弹开，掉到了地上。"))
					return
			///if the hat manages to knock something off
			if(H.dropItemToGround(WH))
				H.visible_message(span_warning("[src] 把 [WH] 从 [H] 的头上打掉了！"), span_warning("[WH] 突然被 [src] 从你的头上打掉了！"))
		if(H.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD, 0, 1, 1))
			H.visible_message(span_notice("[src] 稳稳地落在了 [H] 的头上！"), span_notice("[src] 完美地落在了你的头上！"))
			H.update_held_items() //force update hands to prevent ghost sprites appearing when throw mode is on
		return
	if(iscyborg(hit_atom))
		var/mob/living/silicon/robot/R = hit_atom
		var/obj/item/worn_hat = R.hat
		if(worn_hat && HAS_TRAIT(worn_hat, TRAIT_NODROP))
			R.visible_message(span_warning("[src] 从 [worn_hat] 上弹开，毫无效果！"), span_warning("[src] 从你强大的 [worn_hat.name] 上弹开，败落地掉在地上。"))
			return
		if(is_type_in_typecache(src, GLOB.blacklisted_borg_hats))//hats in the borg's blacklist bounce off
			R.visible_message(span_warning("[src] 从 [R] 身上弹开了！"), span_warning("[src] 从你身上弹开，掉在了地上。"))
			return
		else
			R.visible_message(span_notice("[src] 整齐地落在了 [R] 的头上！"), span_notice("[src] 完美地落在了你的头上。"))
			R.place_on_head(src) //hats aren't designed to snugly fit borg heads or w/e so they'll always manage to knock eachother off

/obj/item/clothing/head/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return
	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damagedhelmet")

/obj/item/clothing/head/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands, icon_file, mutant_styles) // NOVA EDIT CHANGE - ORIGINAL: /obj/item/clothing/gloves/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands, icon_file)
	. = ..()
	if (isinhands)
		return
	var/blood_overlay = get_blood_overlay("helmet")
	if (blood_overlay)
		. += blood_overlay

/obj/item/clothing/head/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_worn_head()
