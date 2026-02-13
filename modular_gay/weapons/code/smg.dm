/obj/item/gun/ballistic/automatic/smg/makeshift
	name = "fully automatic generic submachine gun"
	icon = 'modular_gay/weapons/icon/gunz.dmi'
	lefthand_file = 'modular_gay/weapons/icon/lefthand.dmi'
	righthand_file = 'modular_gay/weapons/icon/righthand.dmi'
	worn_icon = 'modular_gay/weapons/icon/worn.dmi'
	bolt_type = BOLT_TYPE_LOCKING
	force = 10
	burst_size = 1

/obj/item/gun/ballistic/automatic/smg/makeshift/american180
	name = "\improper .22 submachine gun"
	desc = "A suppressed .22 submachine gun that feeds from a large pan magazine placed on top of the gun. An interesting weapon for interesting people."
	icon_state = "smg22"
	inhand_icon_state = "smg22"
	worn_icon_state = "smg22"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BACK | ITEM_SLOT_OCLOTHING
	accepted_magazine_type = /obj/item/ammo_box/magazine/makeshift/c22smg
	rack_sound = 'modular_gay/sound/weapons/gunsounds/22/22smg_rack.ogg'
	bolt_drop_sound = 'modular_gay/sound/weapons/gunsounds/22/22smg_rack.ogg'
	load_sound = 'modular_gay/sound/weapons/gunsounds/22/22smg_load.ogg'
	load_empty_sound = 'modular_gay/sound/weapons/gunsounds/22/22smg_load.ogg'
	eject_sound = 'modular_gay/sound/weapons/gunsounds/22/22smg_unload.ogg'
	eject_empty_sound = 'modular_gay/sound/weapons/gunsounds/22/22smg_unload.ogg'
	fire_sound = 'modular_gay/sound/weapons/gunsounds/22/22smg.ogg'
	fire_delay = 0.125 SECONDS
	spread = 0.5
	recoil = 0.2

/obj/item/gun/ballistic/automatic/smg/makeshift/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)
