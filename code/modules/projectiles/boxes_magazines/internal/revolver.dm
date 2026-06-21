/obj/item/ammo_box/magazine/internal/cylinder/rev38
	name = "侦探左轮手枪弹筒"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = CALIBER_38
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/cylinder/rev762
	name = "\improper 纳甘特左轮弹匣"
	ammo_type = /obj/item/ammo_casing/n762
	caliber = CALIBER_N762
	max_ammo = 7

/obj/item/ammo_box/magazine/internal/cylinder/rus357
	name = "\improper 俄罗斯式左轮手枪弹筒"
	ammo_type = /obj/item/ammo_casing/c357
	caliber = CALIBER_357
	max_ammo = 6
	ammo_box_multiload = AMMO_BOX_MULTILOAD_NONE // presumably so you don't teleport in a full cylinder and end up shooting yourself immediately
	start_empty = TRUE

/obj/item/ammo_box/magazine/internal/cylinder/rus357/Initialize(mapload)
	. = ..()
	for (var/i in 1 to max_ammo - 1)
		stored_ammo += new /obj/item/ammo_casing/c357/spent(src)
	stored_ammo += new /obj/item/ammo_casing/c357(src)

/obj/item/ammo_box/magazine/internal/cylinder/peashooter
	name = "豌豆射手弹巢"
	ammo_type = /obj/item/ammo_casing/pea
	caliber = CALIBER_PEA
	max_ammo = 7
