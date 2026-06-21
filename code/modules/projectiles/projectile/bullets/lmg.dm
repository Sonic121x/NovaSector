// C3D (Borgs)

/obj/projectile/bullet/c3d
	damage = 20

// Mech LMG

/obj/projectile/bullet/lmg
	damage = 20

// Mech FNX-99

/obj/projectile/bullet/incendiary/fnx99
	damage = 20

// Turrets

/obj/projectile/bullet/manned_turret
	damage = 20

/obj/projectile/bullet/manned_turret/hmg
	icon_state = "redtrac"

/obj/projectile/bullet/syndicate_turret
	damage = 20

// 7mm (SAW)

/obj/projectile/bullet/a7mm
	name = "7毫米子弹"
	damage = 30
	armour_penetration = 5
	wound_bonus = -50
	wound_falloff_tile = 0

/obj/projectile/bullet/a7mm/ap
	name = "7毫米穿甲弹"
	damage = 25
	armour_penetration = 75

/obj/projectile/bullet/a7mm/hp
	name = "7毫米空尖弹"
	damage = 50
	sharpness = SHARP_EDGED
	weak_against_armour = TRUE
	wound_bonus = -40
	exposed_wound_bonus = 30
	wound_falloff_tile = -8

/obj/projectile/bullet/incendiary/a7mm
	name = "7毫米燃烧弹"
	damage = 15
	fire_stacks = 3

/obj/projectile/bullet/a7mm/match
	name = "7毫米竞赛弹"
	ricochets_max = 2
	ricochet_chance = 60
	ricochet_auto_aim_range = 4
	ricochet_incidence_leeway = 55

/obj/projectile/bullet/a7mm/bouncy
	name = "7毫米橡胶弹"
	damage = 20
	ricochets_max = 40
	ricochet_chance = 500 // will bounce off anything and everything, whether they like it or not
	ricochet_auto_aim_range = 4
	ricochet_incidence_leeway = 0
	ricochet_decay_chance = 0.9
