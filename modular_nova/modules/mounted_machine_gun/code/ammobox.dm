/obj/item/ammo_box/magazine/mmg_box
	name = "\improper .50 BMG 弹药箱"
	desc = "一个装满弹链供弹弹药的盒子。"
	icon = 'modular_nova/modules/mounted_machine_gun/icons/turret_objects.dmi'
	icon_state = "ammobox"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	max_ammo = 50
	ammo_type = /obj/item/ammo_casing/b50cal
	caliber = CALIBER_50BMG

/obj/item/ammo_casing/b50cal
	name = ".50 BMG 子弹弹壳"
	icon_state = ".50"
	caliber = CALIBER_50BMG
	projectile_type = /obj/projectile/bullet/c50cal

/obj/projectile/bullet/c50cal
	name = ".50 BMG 子弹"
	damage = 30
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 1.4
	light_color = COLOR_SOFT_RED
	ricochets_max = 4
	ricochet_chance = 30
	icon_state = "redtrac"
