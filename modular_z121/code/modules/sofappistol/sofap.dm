//  SOFAP 自动手枪

/obj/item/gun/ballistic/automatic/pistol/sofap
	name = "\improper SOFAP 自动手枪"
	desc = "一把可全自动开火的自动手枪，使用 .35 sol 制式弹匣，开火迅速，但伤害不高。枪口刻有可以固定消音器的螺纹，还配有一个可以挂载战术手电的导轨。"

	icon = 'modular_z121/icons/obj/guns/sofap.dmi'
	icon_state = "sofap"

	lefthand_file = 'modular_z121/icons/mob/guns/sofap_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/sofap_righthand.dmi'
	inhand_icon_state = "sofap"

	fire_sound = 'modular_z121/sound/guns/sofap/sofap_fire.ogg'
	suppressed_sound = 'modular_z121/sound/guns/sofap/sofap_fire_suppressed.ogg'

	//  中等物品大小
	w_class = WEIGHT_CLASS_NORMAL

	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	special_mags = TRUE	//  不同的弹匣贴图
	empty_indicator = TRUE  //弹药耗尽贴图

	//  可安装消音器
	can_suppress = TRUE

	suppressor_x_offset = 6
	suppressor_y_offset = 0

	fire_delay = 0.15 SECONDS
	actions_types = list()//无法切换射击模式
	spread = 5

	//  0.4x 伤害修正
	projectile_damage_multiplier = 0.4

	//  开膛待击
	bolt_type = BOLT_TYPE_OPEN

//  SOFAP 可挂载战术手电
/obj/item/gun/ballistic/automatic/pistol/sofap/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'modular_z121/icons/obj/guns/sofap.dmi', \
		light_overlay = "sofap_flashlight", \
		overlay_x = 0, \
		overlay_y = 0)

//  SOFAP 可以全自动开火
/obj/item/gun/ballistic/automatic/pistol/sofap/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)
