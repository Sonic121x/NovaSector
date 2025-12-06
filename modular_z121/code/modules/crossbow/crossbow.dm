/obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/crossbow
	name = "内置单发弩箭弹匣"
	max_ammo = 1
	caliber = CALIBER_REBAR
	ammo_type = /obj/item/ammo_casing/rebar/bolt

/obj/item/gun/ballistic/rifle/rebarxbow/crossbow
	name = "十字弩"
	desc = "一把采用了现代工艺的十字弩，优势在于噪音很小，但威力欠佳。"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns32x.dmi'
	icon_state = "crossbow"

	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "crossbow"

	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "crossbow"

	empty_indicator = FALSE

	draw_time = 2 SECONDS

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/crossbow
