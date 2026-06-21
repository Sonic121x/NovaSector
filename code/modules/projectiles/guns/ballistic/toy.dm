/obj/item/gun/ballistic/automatic/toy
	name = "泡沫动力SMG"
	desc = "一种原型三连发玩具冲锋枪。适合8岁及以上儿童使用。"
	icon_state = "saber"
	selector_switch_icon = TRUE
	inhand_icon_state = "gun"
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/smg
	fire_sound = 'sound/items/syringeproj.ogg'
	force = 0
	throwforce = 0
	burst_size = 3
	can_suppress = TRUE
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	casing_ejector = FALSE
	can_muzzle_flash = FALSE

/obj/item/gun/ballistic/automatic/toy/riot
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/smg/riot

/obj/item/gun/ballistic/automatic/pistol/toy
	name = "泡沫动力手枪"
	desc = "一个小巧、易于隐藏的玩具手枪。适合8岁及以上儿童。"
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/pistol
	fire_sound = 'sound/items/syringeproj.ogg'
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN

/obj/item/gun/ballistic/automatic/pistol/toy/riot
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/pistol/riot

/obj/item/gun/ballistic/automatic/pistol/riot/Initialize(mapload)
	magazine = new /obj/item/ammo_box/magazine/toy/pistol/riot(src)
	return ..()

/obj/item/gun/ballistic/automatic/pistol/toy/riot/clandestine
	projectile_damage_multiplier = 1.4

/obj/item/gun/ballistic/shotgun/toy
	name = "泡沫动力猎枪"
	desc = "一把带木质配件的玩具霰弹枪，底部可装四发子弹。适合8岁及以上儿童使用。"
	force = 0
	throwforce = 0
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/toy
	fire_sound = 'sound/items/syringeproj.ogg'
	clumsy_check = FALSE
	item_flags = NONE
	casing_ejector = FALSE
	can_suppress = FALSE
	weapon_weight = WEAPON_LIGHT
	pb_knockback = 0
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	can_muzzle_flash = FALSE

/obj/item/gun/ballistic/shotgun/toy/handle_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	. = ..()
	if(chambered && !chambered.loaded_projectile)
		qdel(chambered)

/obj/item/gun/ballistic/shotgun/toy/riot
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/shot/toy/riot

/obj/item/gun/ballistic/shotgun/toy/crossbow
	name = "泡沫动力弩"
	desc = "许多过度活跃的孩子都喜欢的玩具武器。适合 8 岁及以上儿童使用。"
	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "foamcrossbow"
	inhand_icon_state = "crossbow"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	worn_icon = null
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/toy/crossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	gun_flags = NONE
	can_muzzle_flash = FALSE

/obj/item/gun/ballistic/shotgun/toy/crossbow/riot
	spawn_magazine_type =  /obj/item/ammo_box/magazine/internal/shot/toy/crossbow/riot

/obj/item/gun/ballistic/automatic/c20r/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "'杜松' SMG"
	desc = "一款名为“C-20r”的三发连射冲锋式玩具手枪，属于后置式设计，适合 8 岁及以上儿童使用。"
	can_suppress = TRUE
	item_flags = NONE
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/smgm45
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/smgm45/riot
	casing_ejector = FALSE
	clumsy_check = FALSE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	can_muzzle_flash = FALSE

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/smgm45

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/smgm45/riot

/obj/item/gun/ballistic/automatic/l6_saw/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "'杜松' LMG"
	desc = "一把经过大量改装的玩具轻机枪，型号为“L6 SAW”。适合8岁及以上儿童使用。"
	fire_sound = 'sound/items/syringeproj.ogg'
	can_suppress = FALSE
	item_flags = NONE
	accepted_magazine_type = /obj/item/ammo_box/magazine/toy/m762
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/m762/riot
	casing_ejector = FALSE
	clumsy_check = FALSE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	can_muzzle_flash = FALSE

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/m762

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot
	spawn_magazine_type = /obj/item/ammo_box/magazine/toy/m762/riot
