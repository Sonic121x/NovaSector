/obj/item/gun/ballistic/automatic/wt550
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/wt550m9/rub
	name = "\improper WT-550弹匣（4.6x30mm橡胶弹）"
	desc = "一个顶部装填的4.6x30mm弹匣，专门用于携带非致命弹药。"
	ammo_band_color = "#2596be"
	ammo_type = /obj/item/ammo_casing/c46x30mm/rubber

/obj/item/ammo_casing/c46x30mm/rubber
	name = "4.6x30mm 橡胶子弹弹壳"
	desc = "一个 4.6x30mm 橡胶子弹弹壳。它的致命性较低。你还指望有什么高见吗？"
	projectile_type = /obj/projectile/bullet/c46x30mm/rubber

/obj/projectile/bullet/c46x30mm/rubber
	name = "4.6x30mm 橡胶子弹"
	damage = 5
	stamina = 20
	wound_bonus = -10
	ricochets_max = 2
	ricochet_incidence_leeway = 0
	ricochet_chance = 70
	ricochet_decay_damage = 0.7
	sharpness = NONE

/obj/item/storage/toolbox/ammobox/wt550
	name = "弹药箱 (wt-550)"
	desc = "如果标签准确的话，这里面装的是'标准容量弹药全尺寸弹药容量弹匣射击枪用于 Wt-550 枪步枪安保最佳价格'。"

/obj/item/storage/toolbox/ammobox/wt550/PopulateContents()
	for(var/i in 1 to 6)
		var/glib = pick(/obj/item/ammo_box/magazine/wt550m9, /obj/item/ammo_box/magazine/wt550m9/rub, /obj/item/ammo_box/magazine/wt550m9/wtic, /obj/item/ammo_box/magazine/wt550m9/wtap)
		new glib(src)
