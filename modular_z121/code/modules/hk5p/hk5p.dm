//  HK5P冲锋枪
/obj/item/gun/ballistic/automatic/hk5p
	name = "HK5P冲锋枪"
	desc = "结构与二十世纪的MP5冲锋枪十分相似，据说当时这把枪是用于反恐的高精度冲锋枪。这把枪使用Sol标准手枪弹匣"

	icon = 'modular_z121/icons/obj/guns/hk5p.dmi'
	icon_state = "hk5p"

	worn_icon = 'modular_z121/icons/mob/guns/hk5p_worn.dmi'
	worn_icon_state = "hk5p"

	lefthand_file = 'modular_z121/icons/mob/guns/hk5p_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/hk5p_righthand.dmi'
	inhand_icon_state = "hk5p"

	inhand_x_dimension = 64
	inhand_y_dimension = 64


	fire_sound = 'modular_z121/sound/guns/hk5p/hk5p_fire.ogg'
	fire_sound_volume = 35
	suppressed_sound = 'modular_z121/sound/guns/hk5p/hk5p_fire_suppressed.ogg'
	empty_indicator = TRUE //弹药耗尽贴图

	special_mags = TRUE

	w_class = WEIGHT_CLASS_BULKY  // 很重
	weapon_weight = WEAPON_HEAVY //双手武器
	slot_flags = ITEM_SLOT_BACK  // 背身上

	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	special_mags = TRUE	//  不同的弹匣贴图

	//  可安装消音器
	can_suppress = TRUE
	suppressor_x_offset = 9
	suppressor_y_offset = 0

	burst_size = 3
	burst_delay = 0.1 SECONDS
	fire_delay = 0.5 SECONDS
	spread = 5

/obj/item/gun/ballistic/automatic/hk5p/Initialize(mapload)
	. = ..()

	give_autofire()

/obj/item/gun/ballistic/automatic/hk5p/proc/give_autofire()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/hk5p/no_mag
	spawnwithmagazine = FALSE
