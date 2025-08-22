/obj/item/gun/ballistic/automatic/europa
	name = "\improper europa轻机枪"
	desc = "一把沉重的.40Sol long口径机枪，自带两根用于稳定射击的脚架，只使用特制的50发大弹盒"

	icon = 'modular_z121/icons/obj/guns/europa.dmi'
	icon_state = "europa"

	worn_icon = 'modular_z121/icons/mob/guns/europa_worn.dmi'
	worn_icon_state = "europa"

	lefthand_file = 'modular_z121/icons/mob/guns/europa_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/europa_righthand.dmi'
	inhand_icon_state = "europa"

	fire_sound = 'modular_z121/sound/guns/europa/europa_fire.ogg'

	mag_display = TRUE  // 显示弹匣
	mag_display_ammo = TRUE  // 显示剩余弹药
	empty_indicator = TRUE

	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK

	accepted_magazine_type = /obj/item/ammo_box/magazine/europa

	item_flags = SLOWS_WHILE_IN_HAND
	slowdown = 1

	burst_size = 1
	fire_delay = 0.2 SECONDS
	recoil = 1
	spread = 25

	actions_types = list()

	projectile_damage_multiplier = 0.75

	force = 15 //你也可以用这枪砸人，也挺疼的

	var/bipod_open = FALSE //脚架的部署状态

/obj/item/gun/ballistic/automatic/europa/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/europa/examine(mob/user)
	. = ..()
	. += "<b>alt + click</b> 把脚架 [bipod_open ? "收起" : "放下"]"
	. += "脚架放下并趴下射击弹道会更加稳定"

/obj/item/gun/ballistic/automatic/europa/click_alt(mob/user)
	bipod_open = !bipod_open
	balloon_alert(user, "脚架 [bipod_open ? "放下" : "收起"]")
	playsound(src, 'sound/items/weapons/gun/l6/l6_door.ogg', 60, TRUE)
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/automatic/europa/update_overlays()
	. = ..()
	. += "europa_bipod_[bipod_open ? "open" : "closed"]"


/obj/item/gun/ballistic/automatic/europa/process_fire(atom/target, mob/living/user, message, params, zone_override)
	if(bipod_open && user.body_position == LYING_DOWN && user.has_gravity())
		recoil = 0.25
		spread = 7.5
	else
		recoil = initial(recoil)
		spread = initial(spread)

	. = ..()
	if(.)
		update_appearance()
	return .

/obj/item/gun/ballistic/automatic/europa/no_mag
	spawnwithmagazine = FALSE
