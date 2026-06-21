/obj/item/clothing/under/colonial
	name = "殖民者服装"
	desc = "一件精致的白色缎面衬衫和一条棉混纺裤子，配有一条黑色合成皮革腰带。"
	icon = 'modular_nova/modules/food_replicator/icons/clothing.dmi'
	worn_icon = 'modular_nova/modules/food_replicator/icons/clothing_worn.dmi'
	worn_icon_digi = 'modular_nova/modules/food_replicator/icons/clothing_digi.dmi'
	icon_state = "under_colonial"

/obj/item/clothing/under/colonial/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(isteshari(equipper))
		to_chat(equipper, span_warning("[src] 对你来说太大了！"))
		return FALSE

	return ..()

/obj/item/clothing/shoes/jackboots/colonial
	name = "殖民者半筒靴"
	desc = "经典的无鞋带靴子，配有坚固的塑料鞋头，理论上可以保护你的脚趾不被压碎。"
	icon = 'modular_nova/modules/food_replicator/icons/clothing.dmi'
	worn_icon = 'modular_nova/modules/food_replicator/icons/clothing_worn.dmi'
	worn_icon_digi = 'modular_nova/modules/food_replicator/icons/clothing_digi.dmi'
	icon_state = "boots_colonial"

/obj/item/clothing/shoes/jackboots/colonial/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(isteshari(equipper))
		to_chat(equipper, span_warning("[src] 对你来说太大了！"))
		return FALSE

	return ..()

/obj/item/clothing/neck/cloak/colonial
	name = "殖民斗篷"
	desc = "一件用厚重防水布制成的斗篷。得益于其设计，几乎能防风防水。"
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_nova/modules/food_replicator/icons/clothing.dmi'
	worn_icon = 'modular_nova/modules/food_replicator/icons/clothing_worn.dmi'
	worn_icon_digi = 'modular_nova/modules/food_replicator/icons/clothing_digi.dmi'
	icon_state = "cloak_colonial"
	allowed = /obj/item/clothing/suit/jacket/leather::allowed // these are special and can be worn in the suit slot, so we need this var to be defined

/obj/item/clothing/neck/cloak/colonial/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(isteshari(equipper))
		to_chat(equipper, span_warning("[src] 对你来说太大了！"))
		return FALSE

	return ..()

/obj/item/clothing/head/hats/colonial
	name = "殖民帽"
	desc = "一顶用防水布制成、外层覆有纺织物的蓬松帽子。它坚固舒适，并且似乎能很好地保持其形状。"
	icon = 'modular_nova/modules/food_replicator/icons/clothing.dmi'
	worn_icon = 'modular_nova/modules/food_replicator/icons/clothing_worn.dmi'
	worn_icon_digi = 'modular_nova/modules/food_replicator/icons/clothing_digi.dmi'
	icon_state = "cap_colonial"
	inhand_icon_state = null
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/hats/colonial/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(isteshari(equipper))
		to_chat(equipper, span_warning("[src] 对你来说太大了！"))
		return FALSE

	return ..()

/obj/item/clothing/accessory/webbing/colonial
	name = "纤薄殖民携行背心"
	desc = "一种多功能的个人携行装备，深受殖民者和囤积者的喜爱。足够紧凑，可以穿在笨重的衣物下面。"
	icon = 'modular_nova/modules/food_replicator/icons/clothing.dmi'
	worn_icon = 'modular_nova/modules/food_replicator/icons/clothing_worn.dmi'
	icon_state = "accessory_webbing"
