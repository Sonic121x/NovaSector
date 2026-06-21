// Tarkon M6 PDW //

/obj/item/gun/ballistic/automatic/m6pdw
	name = "\improper M6个人防卫武器"
	desc = "一种设计用于近中距离作战的PDW。它的滑套似乎有点卡滞，积攒了多年的灰尘，并且其制造商印记和符号已被刮掉。"
	icon = 'modular_nova/modules/tarkon/icons/obj/guns/m6pdw.dmi'
	icon_state = "m6_pdw"
	inhand_icon_state = "m6_pdw"
	righthand_file = 'modular_nova/modules/tarkon/icons/mob/inhands/righthand.dmi'
	lefthand_file = 'modular_nova/modules/tarkon/icons/mob/inhands/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	spawnwithmagazine = FALSE
	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	can_suppress = FALSE
	fire_sound = 'sound/items/weapons/gun/pistol/shot_alt.ogg'
	rack_sound = 'sound/items/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/pistol/slide_drop.ogg'
	projectile_damage_multiplier = 1
	burst_size = 2
	fire_delay = 1.9
