// 4.6x30mm (Autorifles)

/obj/item/ammo_casing/c46x30mm
	name = "4.6x30mm 子弹弹壳"
	desc = "一颗 4.6x30mm 子弹弹壳。"
	caliber = CALIBER_46X30MM
	projectile_type = /obj/projectile/bullet/c46x30mm

/obj/item/ammo_casing/c46x30mm/ap
	name = "4.6x30mm 穿甲弹弹壳"
	desc = "一颗 4.6x30mm 穿甲弹弹壳。"
	projectile_type = /obj/projectile/bullet/c46x30mm/ap

/obj/item/ammo_casing/c46x30mm/inc
	name = "4.6x30mm 燃烧弹弹壳"
	desc = "一颗 4.6x30mm 燃烧弹弹壳。"
	projectile_type = /obj/projectile/bullet/incendiary/c46x30mm

// .45 (M1911 + C20r)

/obj/item/ammo_casing/c45
	name = ".45 子弹弹壳"
	desc = "一颗 .45 子弹弹壳。"
	caliber = CALIBER_45
	projectile_type = /obj/projectile/bullet/c45

/obj/item/ammo_casing/c45/spent
	projectile_type = null

/obj/item/ammo_casing/c45/ap
	name = ".45 穿甲弹弹壳"
	desc = "A .45 bullet casing."
	projectile_type = /obj/projectile/bullet/c45/ap

/obj/item/ammo_casing/c45/hp
	name = ".45空尖弹弹壳"
	desc = "一颗 .45 子弹弹壳。"
	projectile_type = /obj/projectile/bullet/c45/hp

/obj/item/ammo_casing/c45/inc
	name = ".45 燃烧弹弹壳"
	desc = "A .45 bullet casing."
	projectile_type = /obj/projectile/bullet/incendiary/c45

/obj/item/ammo_casing/c45/reaper
	name = ".45 reaper bullet casing"
	desc = "A .45 reaper bullet casing."
	projectile_type = /obj/projectile/bullet/c45/reaper
