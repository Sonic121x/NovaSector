/obj/item/storage/belt/holster/pre_attack_secondary(atom/target, mob/living/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	// Right clicking your holster on a suit-slot piece of clothing will try to fit it for that individual item.
	// This will let you wear it in its suit slot. Foley workaround for mass Initialize() issues. Also, it's kinda cool.
	if (!istype(target, /obj/item/clothing/suit))
		balloon_alert(user, LANG("obj.2385b9033b18ffbf", null))
		return

	var/obj/item/clothing/suit/clothing_to_mod = target
	if (/obj/item/storage/belt/holster in clothing_to_mod.allowed)
		balloon_alert(user, LANG("obj.0d79cc4a1f724b40", null))
		return

	user.visible_message(span_notice(LANG("obj.2812acac43967941", list(user, src, clothing_to_mod))), span_notice(LANG("obj.1201a461136037ec", list(src, clothing_to_mod))))

	if (do_after(user, 1.5 SECONDS))
		clothing_to_mod.allowed += list(/obj/item/storage/belt/holster)
		playsound(user.loc, 'sound/items/equip/toolbelt_equip.ogg', 50)
		balloon_alert(user, LANG("obj.d2eac8437c34220a", null))
	else
		balloon_alert(user, LANG("obj.c67b5d274d6e724b", null))

/obj/item/storage/belt/holster/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.fc61b40428b4728c", null))

/obj/item/storage/belt/holster
	// use a pen to rename your holster to something based (or cringe if that's your jam)
	obj_flags = UNIQUE_RENAME
