/obj/item/ammo_box/magazine/europa
	name = "europa弹盒"
	desc = "可以容纳50发.40Sol long的弹盒，体积很大"
	icon = 'modular_z121/icons/obj/guns/europa_magazine.dmi'
	icon_state = "europa"

	w_class = WEIGHT_CLASS_NORMAL

	ammo_type = /obj/item/ammo_casing/c40sol
	caliber = CALIBER_SOL40LONG
	max_ammo = 50

/obj/item/ammo_box/magazine/europa/update_icon_state()
	. = ..()
	icon_state = "europa-[min(round(ammo_count(), 10), 50)]"

/obj/item/ammo_box/magazine/europa/starts_empty
	start_empty = TRUE
