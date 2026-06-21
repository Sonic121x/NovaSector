// 7mm (SAW)

/obj/item/ammo_casing/m7mm
	name = "7毫米子弹弹壳"
	desc = "一个7毫米子弹弹壳。"
	icon_state = "762-casing"
	caliber = CALIBER_A7MM
	projectile_type = /obj/projectile/bullet/a7mm

/obj/item/ammo_casing/m7mm/ap
	name = "7毫米穿甲子弹弹壳"
	desc = "一个7毫米子弹弹壳，设计有硬化弹芯以帮助穿透装甲目标。"
	projectile_type = /obj/projectile/bullet/a7mm/ap

/obj/item/ammo_casing/m7mm/hollow
	name = "7毫米空尖子弹弹壳"
	desc = "一个7毫米子弹弹壳，设计用于对无装甲目标造成更多伤害。"
	projectile_type = /obj/projectile/bullet/a7mm/hp

/obj/item/ammo_casing/m7mm/incen
	name = "7毫米燃烧子弹弹壳"
	desc = "一个7毫米子弹弹壳，弹头设计有化学填充胶囊，破裂时与大气反应产生火球，将目标吞没在火焰中。"
	projectile_type = /obj/projectile/bullet/incendiary/a7mm

/obj/item/ammo_casing/m7mm/match
	name = "7毫米比赛级子弹弹壳"
	desc = "一个按照极高标准制造的7毫米子弹弹壳，你可以用它打出一些很酷的特技射击。"
	projectile_type = /obj/projectile/bullet/a7mm/match

/obj/item/ammo_casing/m7mm/bouncy
	name = "7毫米橡胶子弹弹壳"
	desc = "一个按照极其糟糕的标准制造的7毫米橡胶子弹弹壳，在走廊里喷洒这个会惹恼很多人。"
	projectile_type = /obj/projectile/bullet/a7mm/bouncy
