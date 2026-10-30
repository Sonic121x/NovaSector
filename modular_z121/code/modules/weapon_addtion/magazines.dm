/obj/item/ammo_box/magazine/tac9
	name = "TAC-9 弹匣"
	desc = "可容纳15发9mm子弹的弹匣，容量不大不小，大小也适中"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "tac"
	base_icon_state = "tac"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 15
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/tac9/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 3)]"

/obj/item/ammo_box/magazine/tac9/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/m38_pistol
	name = "NT-38手枪弹匣"
	desc = "标准的NT-38手枪弹匣，可容纳12发.38弹药。"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "38mag"
	base_icon_state = "38mag"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = CALIBER_38
	max_ammo = 12
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_band_icon = "+38mag_ammo_band"
	ammo_band_color = null

/obj/item/ammo_box/magazine/m38_pistol/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 3)]"

/obj/item/ammo_box/magazine/m38_pistol/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/speedloader/bfr500
	name = "BFR-500 快速装弹器"
	desc = "BFR-500专用装弹器，它的大小非常大，就像是秤砣一样"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "bfr_loader"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/c357
	max_ammo = 5
	multiple_sprites = AMMO_BOX_PER_BULLET
	item_flags = NO_MAT_REDEMPTION

// /obj/item/ammo_box/magazine/evo_c9mm
// 	name = "EVO-13 冲锋枪弹匣"
// 	desc = "EVO-13的专用弹匣，可容纳30发子弹"
// 	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
// 	icon_state = "evo"
// 	base_icon_state = "evo"
// 	multiple_sprites = AMMO_BOX_FULL_EMPTY
// 	ammo_type = /obj/item/ammo_casing/c9mm
// 	caliber = CALIBER_9MM
// 	max_ammo = 30

// /obj/item/ammo_box/magazine/evo_c9mm/starts_empty
// 	start_empty = TRUE


/obj/item/ammo_box/magazine/europa
	name = "europa弹盒"
	desc = "可以容纳50发.20 Nuoli的弹盒，体积很大"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "europa_mag"

	w_class = WEIGHT_CLASS_NORMAL

	ammo_type = /obj/item/ammo_casing/c20nuoli
	caliber = CALIBER_20NUOLI
	max_ammo = 50

/obj/item/ammo_box/magazine/europa/update_icon_state()
	. = ..()
	icon_state = "europa_mag-[min(round(ammo_count(), 10), 50)]"

/obj/item/ammo_box/magazine/europa/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/europa/belt
	name = "europa弹链"
	desc = "可以容纳400发.20 Nuoli的弹链，很夸张"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "europa_belt"

	w_class = WEIGHT_CLASS_NORMAL

	ammo_type = /obj/item/ammo_casing/c20nuoli
	caliber = CALIBER_20NUOLI
	max_ammo = 400

/obj/item/ammo_box/magazine/europa/belt/update_icon_state()
	. = ..()
	icon_state = "europa_belt-[min(round(ammo_count(), 50), 400)]"

/obj/item/ammo_box/magazine/europa/belt/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/aa12
	name = "AA12 弹匣"
	desc = "可容纳8发霰弹的弹匣，它看上去有点大"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "aa12_standard"
	base_icon_state = "aa12_standard"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL

	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 8

/obj/item/ammo_box/magazine/aa12/starts_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/aa12/drum
	name = "AA12 弹鼓"
	desc = "可容纳15发霰弹的弹鼓，容量大的惊人，体积也大的惊人"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "aa12_drum"
	base_icon_state = "aa12_drum"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_NORMAL

	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 15

/obj/item/ammo_box/magazine/aa12/drum/starts_empty
	start_empty = TRUE

// /obj/item/ammo_box/magazine/dex4
// 	name = "DEX-4 弹匣"
// 	desc = "可容纳8发霰弹的弹匣"
// 	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
// 	icon_state = "dex"
// 	base_icon_state = "dex"
// 	multiple_sprites = AMMO_BOX_FULL_EMPTY
// 	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
// 	caliber = CALIBER_SHOTGUN
// 	max_ammo = 8

// /obj/item/ammo_box/magazine/dex4/starts_empty
// 	start_empty = TRUE
