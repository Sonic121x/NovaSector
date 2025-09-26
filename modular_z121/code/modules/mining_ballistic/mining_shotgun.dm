/obj/item/gun/ballistic/shotgun/mining
	name = "矿用霰弹枪"
	desc = "一种特化的霰弹枪，主要用于狩猎爱好者与矿工在拉瓦兰狩猎，有着惊人的载弹量。为了防止有人滥用这把枪，它被设计成了只能装填狩猎独头弹"

	icon = 'modular_z121/icons/obj/guns/mining_ballistic.dmi'
	icon_state = "shot_gun"

	worn_icon = 'modular_z121/icons/mob/guns/mining_ballistic_worn.dmi'
	worn_icon_state = "shot_gun"

	lefthand_file = 'modular_z121/icons/mob/guns/mining_ballistic_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/mining_ballistic_righthand.dmi'
	inhand_icon_state = "shot_gun"

	SET_BASE_PIXEL(-8, 0)

	inhand_x_dimension = 32
	inhand_y_dimension = 32
	resistance_flags = FIRE_PROOF
	weapon_weight = WEAPON_HEAVY
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/mining

	can_suppress = FALSE
	fire_delay = 0.8 SECONDS
	fire_sound = 'modular_z121/sound/guns/mining_ballistic/mining_shotgun_fire.ogg'

	projectile_damage_multiplier = 0.75

	casing_ejector = TRUE
	semi_auto = TRUE

	pin = /obj/item/firing_pin/wastes

/obj/item/gun/ballistic/shotgun/mining/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
	)

/obj/item/ammo_box/magazine/internal/shot/mining
	ammo_type = /obj/item/ammo_casing/shotgun/hunter
	caliber = null
	max_ammo = 8
