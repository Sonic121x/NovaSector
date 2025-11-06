/obj/item/gun/ballistic/automatic/pistol/tac9
	name = "TAC-9 战斗手枪"
	desc = "一把附带了光学瞄具和手电筒的制式9mm手枪，使用了21世纪的闭锁式结构，简单牢靠。\
	它的握把坚固到可以把人砸成重伤，你可以试着用它逼供犯人或震慑你的人质"
	w_class = WEIGHT_CLASS_NORMAL

	icon = 'modular_z121/icons/obj/guns/tac9.dmi'
	icon_state = "tac9"

	accepted_magazine_type = /obj/item/ammo_box/magazine/tac9
	can_suppress = TRUE
	suppressor_x_offset = 11
	suppressor_y_offset = 0

	fire_sound = 'modular_z121/sound/guns/tac9/tac9_fire.ogg'
	fire_sound_volume = 45

	fire_delay = 0.8 SECONDS
	force = 15		//	一些情况可以当近战武器使用
	projectile_speed_multiplier = 1.5

/obj/item/gun/ballistic/automatic/pistol/tac9/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \

// 	弹匣
/obj/item/ammo_box/magazine/tac9
	name = "TAC-9 弹匣"
	desc = "可容纳15发9mm子弹的弹匣，TAC-9的专用弹匣，别弄丢了"
	icon = 'modular_z121/icons/obj/guns/tac9.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 15
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/tac9/starts_empty
	start_empty = TRUE

