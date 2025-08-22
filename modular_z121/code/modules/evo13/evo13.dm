/obj/item/gun/ballistic/automatic/evo
	name = "EVO-13 冲锋枪"
	desc = "这把枪是以21世纪的某把枪为原型，复原出来的产物，使用标准9mm子弹"

	icon = 'modular_z121/icons/obj/guns/evo.dmi'
	icon_state = "evo"

	worn_icon = 'modular_z121/icons/mob/guns/evo_worn.dmi'
	worn_icon_state = "evo"

	lefthand_file = 'modular_z121/icons/mob/guns/evo_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/evo_righthand.dmi'
	inhand_icon_state = "evo"
	SET_BASE_PIXEL(-8, 0)

	fire_sound = 'sound/items/weapons/gun/smg/shot.ogg'
	suppressed_sound = 'sound/items/weapons/gun/smg/shot_suppressed.ogg'

	w_class = WEIGHT_CLASS_BULKY  // 很重
	weapon_weight = WEAPON_HEAVY //双手武器
	slot_flags = ITEM_SLOT_BACK  // 背身上

	accepted_magazine_type = /obj/item/ammo_box/magazine/evo_c9mm

	//  可安装消音器
	can_suppress = TRUE
	suppressor_x_offset = 4
	suppressor_y_offset = 0

	burst_size = 3
	burst_delay = 0.1 SECONDS
	fire_delay = 1.2 SECONDS
	spread = 0

/obj/item/gun/ballistic/automatic/evo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.3 SECONDS)

/obj/item/gun/ballistic/automatic/evo/burst_select()
	var/mob/living/carbon/human/user = usr
	burst_fire_selection = !burst_fire_selection
	if(!burst_fire_selection)
		burst_size = 1
		fire_delay = 0.3
		spread = 10
		balloon_alert(user, "switched to semi-automatic")
	else
		burst_size = initial(burst_size)
		fire_delay = initial(fire_delay)
		spread = initial(spread)
		balloon_alert(user, "switched to [burst_size]-round burst")
	playsound(user, 'sound/items/weapons/empty.ogg', 100, TRUE)
	update_appearance()
	update_item_action_buttons()

/obj/item/gun/ballistic/automatic/evo/no_mag
	spawnwithmagazine = FALSE

/obj/item/ammo_box/magazine/evo_c9mm
	name = "EVO-13 冲锋枪弹匣"
	desc = "EVO-13的专用弹匣，可容纳30发子弹"
	icon = 'modular_z121/icons/obj/guns/evo_magazine.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 30

/obj/item/ammo_box/magazine/evo_c9mm/starts_empty
	start_empty = TRUE
