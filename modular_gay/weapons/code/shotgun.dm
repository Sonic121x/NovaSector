/obj/item/gun/ballistic/shotgun/makeshift
	name = "generic shotgun"
	icon = 'modular_gay/weapons/icon/gunz.dmi'
	lefthand_file = 'modular_gay/weapons/icon/lefthand.dmi'
	righthand_file = 'modular_gay/weapons/icon/righthand.dmi'
	worn_icon = 'modular_gay/weapons/icon/worn.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BACK | ITEM_SLOT_OCLOTHING
	bolt_type = BOLT_TYPE_LOCKING
	force = 15
	wound_bonus = 0

/obj/item/gun/ballistic/rifle/boltaction/makeshift/singleshot
	name = "\improper makeshift single shotgun"
	desc = "一把自制的单发霰弹枪, 发射12g口径弹药."
	icon = 'modular_gay/weapons/icon/gunz.dmi'
	lefthand_file = 'modular_gay/weapons/icon/lefthand.dmi'
	righthand_file = 'modular_gay/weapons/icon/righthand.dmi'
	worn_icon = 'modular_gay/weapons/icon/worn.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	icon_state = "singleshot"
	inhand_icon_state = "singleshot"
	worn_icon_state = "singleshot"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BACK | ITEM_SLOT_OCLOTHING
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/singleshot
	rack_sound = 'modular_gay/sound/weapons/breakaction_open2.ogg'
	lock_back_sound = 'modular_gay/sound/weapons/breakaction_open2.ogg'
	bolt_drop_sound = 'modular_gay/sound/weapons/breakaction_close2.ogg'
	load_sound = 'modular_gay/sound/weapons/gunsounds/caravan/caravanload2.ogg'
	load_empty_sound = 'modular_gay/sound/weapons/gunsounds/caravan/caravanload2.ogg'
	eject_sound = 'modular_gay/sound/weapons/gunsounds/caravan/caravanunload2.ogg'
	eject_empty_sound = 'modular_gay/sound/weapons/gunsounds/caravan/caravanunload2.ogg'
	fire_sound = 'modular_gay/sound/weapons/gunsounds/caravan/caravan2.ogg'
	fire_delay = 0.45 SECONDS
	spread = 0
	recoil = 1.75
	projectile_damage_multiplier = 1.25
	jamming_chance = 0
	force = 15

/obj/item/ammo_box/magazine/internal/singleshot
	name = "makeshift single shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/birdshot
	caliber = CALIBER_SHOTGUN
	max_ammo = 1

/obj/item/gun/ballistic/shotgun/makeshift/huntingshot
	name = "\improper makeshift auto shotgun"
	desc = "一把自制的霰弹枪, 发射12g口径弹药."
	icon_state = "huntingshot"
	inhand_icon_state = "huntingshot"
	worn_icon_state = "huntingshot"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/huntingshot
	rack_sound = 'modular_gay/sound/weapons/gunsounds/huntingshot/huntingshotpump.ogg'
	load_sound = 'modular_gay/sound/weapons/gunsounds/huntingshot/huntingshotload2.ogg'
	load_empty_sound = 'modular_gay/sound/weapons/gunsounds/huntingshot/huntingshotload2.ogg'
	eject_sound = 'modular_gay/sound/weapons/gunsounds/huntingshot/huntingshoteject.ogg'
	eject_empty_sound = 'modular_gay/sound/weapons/gunsounds/huntingshot/huntingshoteject.ogg'
	fire_sound = 'modular_gay/sound/weapons/gunsounds/huntingshot/huntingshot2.ogg'
	projectile_damage_multiplier = 0.9
	recoil = 1.25
	fire_delay = 0.6 SECONDS
	rack_delay = 0.6 SECONDS

/obj/item/ammo_box/magazine/internal/huntingshot
	name = "makeshift single shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/birdshot
	caliber = CALIBER_SHOTGUN
	max_ammo = 4