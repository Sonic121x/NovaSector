//--- BOWIE'S KNIFE (bowie knife)---


/obj/item/knife/bowie
	name = "\improper 博伊刀"
	desc = "A frontiersman's classic, closer to a shortsword than a knife. It boasts a full-tanged build, a brass handguard and pommel, a wicked sharp point, and a large, heavy blade, It's almost everything you could want in a knife, besides portability."
	icon = 'modular_nova/modules/knives/icons/bowie.dmi'
	icon_state = "bowiehand"
	inhand_icon_state = "bowiehand"
	lefthand_file = 'modular_nova/modules/knives/icons/bowie_lefthand.dmi'
	righthand_file = 'modular_nova/modules/knives/icons/bowie_righthand.dmi'
	worn_icon_state = "knife"
	force = 20 // Zoowee Momma!
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 15
	wound_bonus = 10 //scalpel tier
	exposed_wound_bonus = 20 // Very-bigly

/obj/item/storage/belt/bowie_sheath
	name = "\improper 博伊刀刀鞘"
	desc = "一个装饰过的皮革刀鞘，配有黄铜鞘尖。正中央有一个大口袋夹，便于携带这把原本笨重的刀。"
	icon = 'modular_nova/modules/knives/icons/bowiepocket.dmi'
	icon_state = "bowiesheath"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	interaction_flags_click = NEED_DEXTERITY
	storage_type = /datum/storage/bowie

/datum/storage/bowie
	max_slots = 1
	max_specific_storage = WEIGHT_CLASS_BULKY

/datum/storage/bowie/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(/obj/item/knife/bowie)

/obj/item/storage/belt/bowie_sheath/click_alt(mob/user)
	if(length(contents))
		var/obj/item/knife = contents[1]
		user.visible_message(span_notice("[user] 从 [src] 中取出了 [knife]。"), span_notice("你从 [src] 中取出了 [knife]。"))
		user.put_in_hands(knife)
		update_appearance()
		return CLICK_ACTION_SUCCESS
	else
		to_chat(user, span_warning("[src] 是空的！"))
		return CLICK_ACTION_BLOCKING

/obj/item/storage/belt/bowie_sheath/update_icon_state()
	icon_state = initial(icon_state)
	if(contents.len)
		icon_state += "e-knife"
	return ..()

/obj/item/storage/belt/bowie_sheath/PopulateContents()
	new /obj/item/knife/bowie(src)
	update_appearance()
