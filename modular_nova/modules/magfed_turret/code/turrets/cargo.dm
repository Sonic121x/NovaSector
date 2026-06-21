/obj/item/storage/toolbox/emergency/turret/mag_fed/toy
	name = "玩具炮塔套件"
	desc = "一种为办公室战争设计的可部署炮塔。把它扔进隔壁的隔间，然后找掩护，剩下的交给它。由一种柔韧、可重新着色的材料制成。"
	inhand_icon_state = "smoke" //I was originally gonna leave it spriteless here but after doing this for the other quick_deploy, why not.
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = IS_PLAYER_COLORABLE_1
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'icons/map_icons/objects.dmi'
	icon_state = "/obj/item/storage/toolbox/emergency/turret/mag_fed/toy"
	post_init_icon_state = "toy_toolbox"
	greyscale_config = /datum/greyscale_config/turret/toolbox
	greyscale_colors = "#E0C14F#C67A4B"
	throw_speed = 2
	turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed/toy
	mag_slots = 1
	quick_deployable = TRUE
	quick_deploy_timer = 0.5 SECONDS
	easy_deploy = TRUE
	easy_deploy_timer = 0.5 SECONDS
	turret_safety = FALSE
	mag_types_allowed = list(
		/obj/item/ammo_box/magazine/toy,
	)

/obj/item/storage/toolbox/emergency/turret/mag_fed/toy/pre_filled
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/storage/toolbox/emergency/turret/mag_fed/toy/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/toy/smg(src)

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/toy
	name = "\improper 隔间点防御炮塔"
	desc = "一种小型可部署炮塔，设计为在投掷后展开。其内部装填着最可怕的弹药：泡沫飞镖。"
	max_integrity = 10 //small weak thing
	base_icon_state = "toy"
	flags_1 = IS_PLAYER_COLORABLE_1
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/toy"
	post_init_icon_state = "toy_off"
	greyscale_config = /datum/greyscale_config/turret
	greyscale_colors = "#E0C14F#C67A4B"
	quick_retract = TRUE
	retract_timer = 1 SECONDS
	shot_delay = 0.5 SECONDS
	faction_targeting = FALSE
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/toy/pre_filled
