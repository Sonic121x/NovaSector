/obj/item/storage/belt/holster/pre_attack_secondary(atom/target, mob/living/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	// Right clicking your holster on a suit-slot piece of clothing will try to fit it for that individual item.
	// This will let you wear it in its suit slot. Foley workaround for mass Initialize() issues. Also, it's kinda cool.
	if (!istype(target, /obj/item/clothing/suit))
		balloon_alert(user, "无法调整以适配此物品！")
		return

	var/obj/item/clothing/suit/clothing_to_mod = target
	if (/obj/item/storage/belt/holster in clothing_to_mod.allowed)
		balloon_alert(user, "已调整适配！")
		return

	user.visible_message(span_notice("[user]开始调整[src]以使其能妥善适配[clothing_to_mod]..."), span_notice("你开始调整[src]以使其能妥善适配[clothing_to_mod]..."))

	if (do_after(user, 1.5 SECONDS))
		clothing_to_mod.allowed += list(/obj/item/storage/belt/holster)
		playsound(user.loc, 'sound/items/equip/toolbelt_equip.ogg', 50)
		balloon_alert(user, "调整以适配！")
	else
		balloon_alert(user, "被打断了！")

/obj/item/storage/belt/holster/examine(mob/user)
	. = ..()
	. += span_notice("你可以<b>右键点击</b>一件套装槽衣物，尝试调整枪套以适配其存储槽位。")

/obj/item/storage/belt/holster
	// use a pen to rename your holster to something based (or cringe if that's your jam)
	obj_flags = UNIQUE_RENAME
