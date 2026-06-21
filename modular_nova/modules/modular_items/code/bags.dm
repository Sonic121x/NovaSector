/// Base pouch type. Fits in pockets, as its main gimmick.
/obj/item/storage/pouch
	name = "储物袋"
	desc = "这是一个用深色织物制成的普通小袋。它有一个夹子，可以固定在口袋里。"
	icon = 'modular_nova/modules/modular_items/icons/storage.dmi'
	icon_state = "survival"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_POCKETS
	storage_type = /datum/storage/pouch

/datum/storage/pouch
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_slots = 5

/datum/atom_skin/ammo_pouch
	abstract_type = /datum/atom_skin/ammo_pouch

/datum/atom_skin/ammo_pouch/ammo
	preview_name = "Ammo Pouch"
	new_icon_state = "ammopouch"

/datum/atom_skin/ammo_pouch/casing
	new_name = "casing pouch"
	new_desc = "A pouch for your ammo that goes in your pocket, carefully segmented for holding shell casings and nothing else."
	preview_name = "Casing Pouch"
	new_icon_state = "casingpouch"

/datum/atom_skin/ammo_pouch/casing/apply(atom/apply_to, mob/user)
	. = ..()
	apply_to.create_storage(storage_type = /datum/storage/casing_pouch)

/obj/item/storage/pouch/ammo
	name = "弹药袋"
	desc = "一个可以放进口袋的弹药袋。"
	icon = 'modular_nova/modules/modular_items/icons/storage.dmi'
	icon_state = "ammopouch"
	w_class = WEIGHT_CLASS_BULKY
	custom_price = PAYCHECK_CREW * 4
	storage_type = /datum/storage/pouch/ammo

/obj/item/storage/pouch/ammo/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/ammo_pouch)

/datum/storage/pouch/ammo
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_total_storage = 12
	max_slots = 4

/datum/storage/pouch/ammo/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/ammo_box/magazine,
		/obj/item/ammo_casing,
		/obj/item/ammo_box/speedloader,
	))

/datum/storage/casing_pouch
	max_specific_storage = WEIGHT_CLASS_TINY
	numerical_stacking = TRUE
	max_slots = 10
	max_total_storage = WEIGHT_CLASS_TINY * 10

/datum/storage/casing_pouch/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/ammo_casing))

/obj/item/storage/pouch/material
	name = "材料袋"
	desc = "一个用于存放板材和RCD弹药的口袋袋，它能挂在您通常放东西的口袋位置。"
	icon = 'modular_nova/modules/modular_items/icons/storage.dmi'
	icon_state = "materialpouch"
	w_class = WEIGHT_CLASS_BULKY
	custom_price = PAYCHECK_CREW * 4
	storage_type = /datum/storage/pouch/material

/datum/storage/pouch/material
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_total_storage = INFINITY
	max_slots = 2
	numerical_stacking = TRUE

/datum/storage/pouch/material/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/rcd_ammo,
		/obj/item/stack/sheet,
	))

/// It's a pocket medkit. Use sparingly?
/obj/item/storage/pouch/medical
	name = "医疗包袋"
	desc = "一个为野战医疗护理而分隔的标准医疗包袋。配有一套口袋夹。"
	resistance_flags = FIRE_PROOF
	icon_state = "medkit"
	storage_type = /datum/storage/pouch/medical

/datum/storage/pouch/medical
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_slots = 7
	max_total_storage = 14

/datum/storage/pouch/medical/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/applicator/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel,
		/obj/item/reagent_containers/spray,
		/obj/item/reagent_containers/hypospray,
		/obj/item/storage/pill_bottle,
		/obj/item/storage/box/bandages,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/reagent_containers/blood,
		/obj/item/stack/medical/wrap/sticky_tape,

	))

/obj/item/storage/pouch/medical/loaded
	desc = parent_type::desc + "已重新包装了空间站标准医疗用品。"

/obj/item/storage/pouch/medical/loaded/PopulateContents()
	generate_items_inside(list(
		/obj/item/stack/medical/wrap/gauze/twelve = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/healthanalyzer/simple = 1,
	))

/// It's... not as egregious as a full pocket medkit.
/obj/item/storage/pouch/medical/firstaid
	name = "急救袋"
	desc = "一个标准的普通急救袋，为野战医疗护理的基本必需品进行了分隔。配有一个口袋夹。"
	icon_state = "firstaid"
	storage_type = /datum/storage/pouch/medical/small

/datum/storage/pouch/medical/small
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_slots = 5
	max_total_storage = WEIGHT_CLASS_SMALL * 5
	/*
	hi. you might think this is egregious. five slots? that's a lot!
	here's a thought: the pocket first aid kit from the colonial replicator [modular_nova\modules\food_replicator\code\storage.dm] has
	mostly unrestricted storage, limited by having 4 max total storage, so at best you're only fitting 4 tiny items. but that's 4 of *any* tiny item.
	or 2 small items (that aren't guns/mags). so it's basically just turning 1 pocket slot into 2, if you think about it hard enough.
	this is a thing you have to buy from cargo's goodies tab. not even an import. and it only fits medical supplies.
	i think it can have a lil extra storage as a treat.
	*/

/obj/item/storage/pouch/medical/firstaid/loaded/Initialize(mapload)
	. = ..()
	desc += " Repackaged with station-standard medical supplies."
	var/static/items_inside = list(
		/obj/item/stack/medical/suture = 1,
		/obj/item/stack/medical/mesh = 1,
		/obj/item/storage/box/bandages = 1,
		/obj/item/stack/medical/wrap/gauze/twelve = 1,
		/obj/item/reagent_containers/hypospray/medipen/ekit = 1,
	)
	generate_items_inside(items_inside, src)

/obj/item/storage/pouch/medical/firstaid/stabilizer/Initialize(mapload)
	. = ..()
	desc += " Repackaged with a wound stabilization-focused loadout."
	var/static/items_inside = list(
		/obj/item/cautery = 1,
		/obj/item/bonesetter = 1,
		/obj/item/stack/medical/wrap/gauze/twelve = 1,
		/obj/item/reagent_containers/hypospray/medipen/ekit = 2,
	)
	generate_items_inside(items_inside, src)

/obj/item/storage/pouch/medical/firstaid/advanced/Initialize(mapload)
	. = ..()
	desc += " Repackaged with improved medical supplies."
	var/static/items_inside = list(
		/obj/item/stack/medical/suture/medicated = 2,
		/obj/item/stack/medical/mesh/advanced = 1,
		/obj/item/stack/medical/wrap/gauze/twelve = 1,
		/obj/item/reagent_containers/hypospray/medipen/ekit = 1,
	)
	generate_items_inside(items_inside, src)
