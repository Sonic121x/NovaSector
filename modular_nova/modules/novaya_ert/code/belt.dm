/obj/item/storage/belt/military/nri
	name = "绿色战术腰带"
	desc = "一条用于存放军用级硬件的绿色战术腰带。"
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/species/teshari/belt.dmi'
	icon_state = "russian_green_belt"
	inhand_icon_state = "security"
	worn_icon_state = "russian_green_belt"

/obj/item/storage/belt/military/nri/captain
	name = "黑色战术腰带"
	desc = "一条用于存放军用级硬件的黑色战术腰带。"
	icon_state = "russian_black_belt"
	worn_icon_state = "russian_black_belt"

/obj/item/storage/belt/military/nri/medic
	name = "蓝色战术腰带"
	desc = "一条用于存放军用级硬件的蓝色战术腰带。"
	icon_state = "russian_white_belt"
	worn_icon_state = "russian_white_belt"

/obj/item/storage/belt/military/nri/engineer
	name = "棕色战术腰带"
	desc = "一条用于存放军用级硬件的棕色战术腰带。"
	icon_state = "russian_brown_belt"
	worn_icon_state = "russian_brown_belt"

/obj/item/storage/belt/military/nri/plus_mre/PopulateContents()
	new /obj/item/storage/box/nri_survival_pack/inspector(src)

/obj/item/storage/belt/military/nri/soldier/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/magazine/lanca = 4,
		/obj/item/knife/combat = 1,
		/obj/item/grenade/smokebomb = 1,
		/obj/item/grenade/frag = 1,
	),src)

/obj/item/storage/belt/military/nri/heavy/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/magazine/m9mm_aps = 4,
		/obj/item/knife/combat = 1,
		/obj/item/grenade/smokebomb = 1,
		/obj/item/grenade/frag = 1,
	),src)

/obj/item/storage/belt/military/nri/captain/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/magazine/lanca = 4,
		/obj/item/knife/combat = 1,
		/obj/item/grenade/smokebomb = 1,
		/obj/item/grenade/frag = 1,
	),src)

/obj/item/storage/belt/military/nri/medic/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/magazine/miecz = 4,
		/obj/item/knife/combat = 1,
		/obj/item/grenade/smokebomb = 1,
		/obj/item/grenade/frag = 1,
	),src)

/obj/item/storage/belt/military/nri/engineer/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/magazine/miecz = 4,
		/obj/item/knife/combat = 1,
		/obj/item/grenade/smokebomb = 1,
		/obj/item/grenade/frag = 1,
	),src)
