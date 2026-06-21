//Accelerator Casing
/obj/item/ammo_casing/energy/kinetic/railgun
	projectile_type = /obj/projectile/kinetic/railgun
	fire_sound = 'sound/items/weapons/beam_sniper.ogg'

/obj/item/ammo_casing/energy/kinetic/repeater
	projectile_type = /obj/projectile/kinetic/repeater
	e_cost = LASER_SHOTS(3, STANDARD_CELL_CHARGE * 0.5)

/obj/item/ammo_casing/energy/kinetic/shotgun
	projectile_type = /obj/projectile/kinetic/shotgun
	pellets = 3
	variance = 50

/obj/item/ammo_casing/energy/kinetic/glock
	projectile_type = /obj/projectile/kinetic/glock

/obj/item/ammo_casing/energy/kinetic/shockwave
	projectile_type = /obj/projectile/kinetic/shockwave
	pellets = 8
	variance = 360
	fire_sound = 'sound/items/weapons/gun/general/cannon.ogg'

//Accelerator Projectiles

/obj/projectile/kinetic
	var/mod_mult = 1 // Indicates to which value the damage modkit multiplicates its bonus, useful for multi proyectile pka's where the bonus is otherwise is applied to each proyectile and increases more than intended.

/obj/projectile/kinetic/railgun
	name = "超强动能"
	damage = 100
	range = 7
	pressure_decrease = 0.10
	speed = 10
	projectile_piercing = PASSMOB

/obj/projectile/kinetic/repeater
	name = "高速动能"
	damage = 20
	range = 4
	mod_mult = 0.5

/obj/projectile/kinetic/shotgun
	name = "分裂动能"
	damage = 20

/obj/projectile/kinetic/glock
	name = "轻型动能"
	damage = 10

/obj/projectile/kinetic/shockwave
	name = "震荡动能"
	range = 1
