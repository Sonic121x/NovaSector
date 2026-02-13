/obj/item/gun/ballistic/rifle/makeshift
	name = "generic rifle"
	icon = 'modular_gay/weapons/icon/gunz.dmi'
	worn_icon = 'modular_gay/weapons/icon/worn.dmi'
	lefthand_file = 'modular_gay/weapons/icon/lefthand.dmi'
	righthand_file = 'modular_gay/weapons/icon/righthand.dmi'
	internal_magazine = FALSE
	tac_reloads = FALSE
	slot_flags = ITEM_SLOT_SUITSTORE
	force = 15
	wound_bonus = 0

/obj/item/gun/ballistic/rifle/makeshift/battlerifle
	name = "\improper makeshift garand rifle"
	desc = "一把仿制的加兰德步枪, 发射.308口径弹药."
	icon_state = "battlerifle"
	inhand_icon_state = "battlerifle"
	worn_icon_state = "battler"
//	bolt_type = BOLT_TYPE_NO_BOLT
	bolt_type = BOLT_TYPE_LOCKING
	semi_auto = TRUE
	internal_magazine = FALSE
	accepted_magazine_type = /obj/item/ammo_box/magazine/makeshift/c308
	fire_sound = 'modular_gay/sound/weapons/battlerifle.ogg'
	eject_empty_sound = 'modular_gay/sound/weapons/battlerifleunload.ogg'
	eject_sound = 'modular_gay/sound/weapons/battlerifleunload.ogg'
	rack_sound = 'modular_gay/sound/weapons/gunsounds/battle_rifle/battle_rack.ogg'
	bolt_drop_sound = 'modular_gay/sound/weapons/gunsounds/battle_rifle/battle_rack.ogg'
	recoil = 1.75
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_OCLOTHING
	w_class = WEIGHT_CLASS_HUGE