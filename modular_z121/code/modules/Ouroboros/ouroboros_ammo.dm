/obj/item/ammo_casing/energy/ouroboros/disable
	projectile_type = /obj/projectile/beam/disabler
	select_name = "镇爆"
	e_cost = LASER_SHOTS(20, STANDARD_CELL_CHARGE)
	fire_sound = 'sound/items/weapons/taser2.ogg'
	harmful = FALSE
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/blue
	muzzle_flash_color = LIGHT_COLOR_CYAN

/obj/item/ammo_casing/energy/ouroboros/kill
	projectile_type = /obj/projectile/beam/laser/ouroboros
	select_name = "杀伤"
	e_cost = LASER_SHOTS(25, STANDARD_CELL_CHARGE)
	fire_sound = 'modular_nova/modules/modular_weapons/sounds/laser_firing/laser.ogg'
	muzzle_flash_color = COLOR_SOFT_RED

/obj/projectile/beam/laser/ouroboros
	damage = 20

/obj/item/ammo_casing/energy/ouroboros/hellfire
	projectile_type = /obj/projectile/beam/laser/hellfire
	select_name = "地狱火"
	e_cost = LASER_SHOTS(12, STANDARD_CELL_CHARGE)
	fire_sound = 'modular_nova/modules/modular_weapons/sounds/laser_firing/incinerate.ogg'

/obj/item/ammo_casing/energy/ouroboros/ion
	projectile_type = /obj/projectile/ion/weak
	select_name = "离子"
	e_cost = LASER_SHOTS(4, STANDARD_CELL_CHARGE)
	fire_sound = 'sound/items/weapons/ionrifle.ogg'
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/blue
	muzzle_flash_color = LIGHT_COLOR_BLUE

/obj/item/ammo_casing/energy/ouroboros/stun
	projectile_type = /obj/projectile/energy/electrode
	select_name = "泰瑟"
	e_cost = LASER_SHOTS(4, STANDARD_CELL_CHARGE)
	fire_sound = 'sound/items/weapons/taser.ogg'
	harmful = FALSE
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect
	muzzle_flash_color = LIGHT_COLOR_DIM_YELLOW

/obj/item/ammo_casing/energy/ouroboros/xray
	projectile_type = /obj/projectile/beam/xray
	select_name = "X光束"
	e_cost = LASER_SHOTS(14, STANDARD_CELL_CHARGE)
	fire_sound = 'sound/items/weapons/laser3.ogg'
	muzzle_flash_color = LIGHT_COLOR_GREEN
