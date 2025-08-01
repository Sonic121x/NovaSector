
/obj/item/ammo_box/magazine/aa12
	name = "\improper AA12弹匣"
	desc = "可容纳8发霰弹的弹匣，对于非战斗人员已经足够了"

	icon = 'modular_z121/icons/obj/guns/aa12.dmi'
	icon_state = "aa12_mag"
	base_icon_state = "aa12_mag"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL

	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 8

/obj/item/ammo_box/magazine/aa12/starts_empty
	start_empty = TRUE


/obj/item/ammo_box/magazine/aa12/drum
	name = "\improper AA12弹鼓"
	desc = "可容纳20发霰弹的弹鼓，容量大的惊人，体积也大的惊人"

	icon = 'modular_z121/icons/obj/guns/aa12.dmi'
	icon_state = "aa12_mag_drum"
	base_icon_state = "aa12_mag_drum"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_NORMAL

	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 20

/obj/item/ammo_box/magazine/aa12/drum/starts_empty
	start_empty = TRUE
