/obj/item/ammo_box/magazine/recharge
	name = "电源包"
	desc = "一种用于镭射步枪的可充电、可拆卸电池。"
	icon_state = "oldrifle-20"
	base_icon_state = "oldrifle"
	ammo_type = /obj/item/ammo_casing/laser
	caliber = CALIBER_LASER
	max_ammo = 20

/obj/item/ammo_box/magazine/recharge/update_desc()
	. = ..()
	desc = "[initial(desc)] 还有[stored_ammo.len]发 \s 剩余."

/obj/item/ammo_box/magazine/recharge/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 4)]"

/obj/item/ammo_box/magazine/recharge/attack_self() //No popping out the "bullets"
	return
