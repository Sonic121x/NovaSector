//  AA12全自动霰弹枪
/obj/item/gun/ballistic/shotgun/aa12
	name = "\improper AA12 全自动霰弹枪"
	desc = "一把可以进行全自动开火的霰弹枪，原本为军方研制，不过过大的体积和过慢的射速被军方拒绝。不过在民用市场是一把很受欢迎的娱乐武器"

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

	w_class = WEIGHT_CLASS_BULKY  // 很重
	weapon_weight = WEAPON_HEAVY //别想双持
	slot_flags = ITEM_SLOT_BACK  // 背身上

	accepted_magazine_type = /obj/item/ammo_box/magazine/aa12
	spawnwithmagazine = TRUE

	burst_size = 1
	fire_delay = 0.65 SECONDS
	actions_types = list()
	spread = 0

	//  0.75x 伤害修正
	projectile_damage_multiplier = 0.75

	//  开膛待击
	bolt_type = BOLT_TYPE_OPEN

/obj/item/gun/ballistic/shotgun/aa12/Initialize(mapload)
	. = ..()

	give_autofire()

/obj/item/gun/ballistic/shotgun/aa12/proc/give_autofire()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/shotgun/aa12/no_mag
	spawnwithmagazine = FALSE
