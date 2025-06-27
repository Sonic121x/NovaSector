/obj/item/gun/ballistic/rifle/strzelec
	name = "\improper Strzelec 重型狙击步枪"
	desc = "这是把使用弹匣供弹的狙击步枪，有着一根厚重的枪栓，优秀的枪膛密封性让这把枪的子弹飞行速度变得很快"

	icon = 'modular_z121/icons/obj/guns/strzelec.dmi'
	icon_state = "strzelec"

	worn_icon = 'modular_z121/icons/mob/guns/strzelec_worn.dmi'
	worn_icon_state = "strzelec"

	lefthand_file = 'modular_z121/icons/mob/guns/strzelec_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/strzelec_righthand.dmi'
	inhand_icon_state = "strzelec"

	SET_BASE_PIXEL(-16, 0)

	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/strzelec
	internal_magazine = FALSE
	w_class = WEIGHT_CLASS_BULKY

	fire_sound = 'modular_z121/sound/guns/strzelec/strzelec_fire.ogg'

	projectile_speed_multiplier = 2


/obj/item/gun/ballistic/rifle/strzelec/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

/obj/item/gun/ballistic/rifle/strzelec/drop_bolt(user)
	if(do_after(user, 0.5 SECONDS, src, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE)))
		. = ..()

/obj/item/gun/ballistic/rifle/strzelec/rack(user)
	if(do_after(user, 0.5 SECONDS, src, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE)))
		. = ..()

/obj/item/gun/ballistic/rifle/strzelec/no_mag
	spawnwithmagazine = FALSE

/obj/item/ammo_box/magazine/strzelec
	name = "\improper Strzelec 弹匣"
	desc = "可容纳10发.310 Strilka子弹的弹匣"

	icon = 'modular_z121/icons/obj/guns/strzelec_mag.dmi'
	icon_state = "strzelec_mag"
	base_icon_state = "strzelec_mag"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL

	ammo_type = /obj/item/ammo_casing/strilka310
	caliber = CALIBER_STRILKA310
	max_ammo = 10

/obj/item/ammo_box/magazine/strzelec/starts_empty
	start_empty = TRUE
