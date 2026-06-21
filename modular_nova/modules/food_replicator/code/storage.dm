/obj/item/storage/pouch/cin_medipens
	name = "殖民医疗笔袋"
	desc = "一个可以放进口袋的（医疗）笔袋。"
	icon = 'modular_nova/modules/food_replicator/icons/pouch.dmi'
	icon_state = "medipen_pouch"
	storage_type = /datum/storage/pouch/medipens

/obj/item/storage/pouch/cin_medipens/update_icon_state()
	icon_state = "[initial(icon_state)]_[contents.len]"
	return ..()

/obj/item/storage/pouch/cin_medipens/Initialize(mapload)
	. = ..()
	update_appearance()

/datum/storage/pouch/medipens
	max_specific_storage = WEIGHT_CLASS_TINY
	max_total_storage = WEIGHT_CLASS_TINY * 8
	max_slots = 8

/datum/storage/pouch/medipens/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/reagent_containers/hypospray/medipen,
		/obj/item/pen,
		/obj/item/flashlight/pen,
	))

/obj/item/storage/pouch/cin_medkit
	name = "殖民急救包"
	desc = "一个可以放进口袋的医疗箱。也可用于存放与医疗无关的物品，但枪支、弹药和原材料除外。"
	icon = 'modular_nova/modules/food_replicator/icons/pouch.dmi'
	icon_state = "cfak"
	storage_type = /datum/storage/pouch/colonial_med

/datum/storage/pouch/colonial_med
	max_slots = 4
	max_total_storage = WEIGHT_CLASS_SMALL * 4
	max_specific_storage = WEIGHT_CLASS_SMALL

/datum/storage/pouch/colonial_med/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(
		cant_hold_list = list(
			/obj/item/gun,
			/obj/item/ammo_box,
			/obj/item/ammo_casing,
			/obj/item/stack/sheet,
		)
	)

/obj/item/storage/pouch/cin_general
	name = "殖民通用袋"
	desc = "一个可以放进口袋的合成皮革通用袋。"
	icon = 'modular_nova/modules/food_replicator/icons/pouch.dmi'
	icon_state = "gen_pouch"
	storage_type = /datum/storage/colonial_gen

/datum/storage/colonial_gen
	max_slots = 3
	max_total_storage = WEIGHT_CLASS_SMALL * 3
	max_specific_storage = WEIGHT_CLASS_SMALL
