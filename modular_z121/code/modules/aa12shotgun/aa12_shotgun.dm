//  AA12全自动霰弹枪
/obj/item/gun/ballistic/shotgun/aa12
	name = "AA12 全自动霰弹枪"
	desc = "这是一把巨大且沉重的霰弹枪，它既没有霰弹枪的轻巧，也没有步枪的杀伤力。不过它可以全自动开火"

	icon = 'modular_z121/icons/obj/guns/aa12.dmi'
	icon_state = "aa12"

	worn_icon = 'modular_z121/icons/mob/guns/aa12_worn.dmi'
	worn_icon_state = "aa12"

	lefthand_file = 'modular_z121/icons/mob/guns/aa12_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/aa12_righthand.dmi'
	inhand_icon_state = "aa12"
	inhand_x_dimension = 32
	inhand_y_dimension = 32

	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_z121/sound/guns/aa12/aa12_fire.ogg'

	special_mags = TRUE
	semi_auto = TRUE
	casing_ejector = TRUE
	internal_magazine = FALSE
	tac_reloads = TRUE

	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK

	accepted_magazine_type = /obj/item/ammo_box/magazine/aa12
	spawnwithmagazine = TRUE

	burst_size = 1
	fire_delay = 0.5 SECONDS
	actions_types = list()
	spread = 0

	//  0.75x 伤害修正
	projectile_damage_multiplier = 0.75

	//  开膛待击
	bolt_type = BOLT_TYPE_OPEN

/obj/item/gun/ballistic/shotgun/aa12/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/ammo_box/magazine/aa12
	name = "\improper AA12 弹匣"
	desc = "可容纳5发霰弹的弹匣，它看上去有点大"

	icon = 'modular_z121/icons/obj/guns/aa12magazine.dmi'
	icon_state = "standard"
	base_icon_state = "standard"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL

	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 5

/obj/item/ammo_box/magazine/aa12/starts_empty
	start_empty = TRUE


/obj/item/ammo_box/magazine/aa12/drum
	name = "\improper AA12 弹鼓"
	desc = "可容纳15发霰弹的弹鼓，容量大的惊人，体积也大的惊人"

	icon = 'modular_z121/icons/obj/guns/aa12magazine.dmi'
	icon_state = "drum"
	base_icon_state = "drum"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_NORMAL

	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 15

/obj/item/ammo_box/magazine/aa12/drum/starts_empty
	start_empty = TRUE
