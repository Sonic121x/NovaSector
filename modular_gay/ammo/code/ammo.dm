/obj/item/ammo_casing/makeshift/c9mm
	name = "9mm makeshift casing"
	desc = "a 9mm makeshift casing."
	caliber = "9mm"
	icon = 'modular_gay/ammo/icon/ammo.dmi'
	icon_state = "pistol-brass"
	base_icon_state = "pistol-brass"
	projectile_type = /obj/projectile/bullet/c9mm
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/makeshift/c9mm

/obj/item/ammo_box/magazine/ammo_stack/makeshift/c9mm
	name = "9mm makeshift casings"
	desc = "A stack of 9mm makeshift casings."
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/makeshift/c9mm
	casing_phrasing = "casing"
	max_ammo = 10
	casing_w_spacing = 3
	casing_z_padding = 4

/obj/projectile/bullet/c9mm
	name = "9mm makeshift bullet"
	icon = 'modular_gay/ammo/icon/projectile.dmi'
	icon_state = "merehandgun_bullet"
	damage = 20
	wound_bonus = -10
	exposed_wound_bonus = 15
	speed = 1.25
	armour_penetration = -10
	embed_type = null
	sharpness = SHARP_POINTY

/obj/item/ammo_casing/makeshift/c22
	name = ".22 makeshift casing"
	desc = "a .22 makeshift casing."
	caliber = ".22"
	icon = 'modular_gay/ammo/icon/ammo.dmi'
	icon_state = "pistol-brass"
	base_icon_state = "pistol-brass"
	projectile_type = /obj/projectile/bullet/c22
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/makeshift/c22

/obj/item/ammo_box/magazine/ammo_stack/makeshift/c22
	name = ".22 makeshift casings"
	desc = "A stack of .22 makeshift casings."
	caliber = ".22"
	ammo_type = /obj/item/ammo_casing/makeshift/c22
	casing_phrasing = "casing"
	max_ammo = 15
	casing_w_spacing = 3
	casing_z_padding = 4

/obj/projectile/bullet/c22
	name = ".22 makeshift bullet"
	icon = 'modular_gay/ammo/icon/projectile.dmi'
	icon_state = "bb"
	damage = 8
	wound_bonus = 30
	exposed_wound_bonus = 30
	speed = 1.5
	armour_penetration = -20
	embed_type = null
	sharpness = SHARP_POINTY

/obj/item/ammo_casing/makeshift/c7758
	name = "7.7x58mm makeshift casing"
	desc = "a 7.7x58mm makeshift casing."
	caliber = "7.7x58mm"
	icon = 'modular_gay/ammo/icon/ammo.dmi'
	icon_state = "rifle-brass"
	base_icon_state = "rifle-brass"
	projectile_type = /obj/projectile/bullet/c7758
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/makeshift/c7758

/obj/item/ammo_box/magazine/ammo_stack/makeshift/c7758
	name = "7.7x58mm makeshift casings"
	desc = "A stack of 7.7x58mm makeshift casings."
	caliber = "7.7x58mm"
	ammo_type = /obj/item/ammo_casing/makeshift/c7758
	casing_phrasing = "casing"
	max_ammo = 8
	casing_w_spacing = 3
	casing_z_padding = 4

/obj/projectile/bullet/c7758
	name = "7.7x58mm makeshift bullet"
	icon = 'modular_gay/ammo/icon/projectile.dmi'
	icon_state = "medium_bullet"
	damage = 55
	wound_bonus = 10
	exposed_wound_bonus = 30
	speed = 2
	armour_penetration = 10
	embed_type = null
	sharpness = SHARP_POINTY

/obj/item/ammo_casing/makeshift/c308
	name = ".308 makeshift casing"
	desc = "a .308 makeshift casing."
	caliber = ".308"
	icon = 'modular_gay/ammo/icon/ammo.dmi'
	icon_state = "rifle-brass"
	base_icon_state = "rifle-brass"
	projectile_type = /obj/projectile/bullet/c308
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/makeshift/c308

/obj/item/ammo_box/magazine/ammo_stack/makeshift/c308
	name = ".308 makeshift casings"
	desc = "A stack of .308 makeshift casings."
	caliber = ".308"
	ammo_type = /obj/item/ammo_casing/makeshift/c308
	casing_phrasing = "casing"
	max_ammo = 8
	casing_w_spacing = 3
	casing_z_padding = 4

/obj/projectile/bullet/c308
	name = ".308 makeshift bullet"
	icon = 'modular_gay/ammo/icon/projectile.dmi'
	icon_state = "medium_bullet"
	damage = 48
	wound_bonus = 10
	exposed_wound_bonus = 30
	speed = 2
	armour_penetration = 20
	embed_type = /datum/embedding/bullet/birdshot
	sharpness = SHARP_POINTY

/obj/item/ammo_casing/shotgun/birdshot
	name = "makeshift 12 guage birdshot shell"
	desc = "A makeshift 12 guage birdshot shell for hunting birds, or human."
	icon = 'modular_gay/ammo/icon/ammo.dmi'
	icon_state = "birdshot"
	base_icon_state = "birdshot"
	caliber = CALIBER_SHOTGUN
	pellets = 6
	variance = 10
	projectile_type = /obj/projectile/bullet/pellet/birdshot
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/makeshift/birdshot

/obj/item/ammo_box/magazine/ammo_stack/makeshift/birdshot
	name = " makeshift 12 guage birdshot shells"
	desc = "A stack of .308 makeshift casings."
	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun/birdshot
	casing_phrasing = "shell"
	max_ammo = 8
	casing_w_spacing = 3
	casing_z_padding = 4

/obj/projectile/bullet/pellet/birdshot
	name = "12 guage birdshot pellet"
	icon = 'modular_gay/ammo/icon/projectile.dmi'
	icon_state = "buckshot"
	damage = 8
	wound_bonus = -30
	exposed_wound_bonus = 40
	speed = 1.25
	armour_penetration = -50
	sharpness = SHARP_POINTY
	embed_type = null
	ricochets_max = 1
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.8

/datum/embedding/bullet/birdshot
	embed_chance = 25
	fall_chance = 2
	jostle_chance = 2
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.4
	pain_mult = 3
	jostle_pain_mult = 5
	rip_time = 1 SECONDS