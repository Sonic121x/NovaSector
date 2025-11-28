/obj/item/gun/ballistic/revolver/single
	name = "BFR-500 单动式左轮"
	desc = "一把大口径左轮，它不一定不适合狩猎动物，不过用它狩猎两脚兽再适合不过了"
	icon = 'modular_z121/icons/obj/guns/bfr500.dmi'
	icon_state = "bfr500"
	lefthand_file = 'modular_z121/icons/mob/guns/bfr500_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/bfr500_righthand.dmi'
	inhand_icon_state = "bfr500"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/bfr500
	fire_sound = 'modular_z121/sound/guns/bfr500/bfr500_fire.ogg'
	fire_sound_volume = 35
	semi_auto = FALSE
	recoil = 2
	fire_delay = 1 SECONDS
	projectile_damage_multiplier = 0.75

	var/hammer_back_sound = 'modular_z121/sound/guns/bfr500/hammer_back.ogg'
	var/hammer_back_sound_volume = 50

	var/hammer_fall_sound = 'sound/items/weapons/gun/general/bolt_drop.ogg'
	var/hammer_fall_sound_volume = 50
	var/cocked = TRUE

/obj/item/gun/ballistic/revolver/single/examine(mob/user)
	. = ..()
	. += "<b>alt + click</b> 弹出子弹"

/obj/item/gun/ballistic/revolver/single/can_shoot()
	if (!cocked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/revolver/single/before_firing(atom/target,mob/user)
	cocked = FALSE
	update_appearance()
	return ..()

/obj/item/gun/ballistic/revolver/single/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(cocked)
		playsound(src, hammer_fall_sound, hammer_fall_sound_volume, TRUE)
		if (user)
			balloon_alert_to_viewers("击锤放下")
		cocked = FALSE
		update_appearance()
	else
		playsound(src, dry_fire_sound, dry_fire_sound_volume, TRUE)
		balloon_alert_to_viewers("*click*")
	return

/obj/item/gun/ballistic/revolver/single/attack_self(mob/living/user, obj/item/tool, list/modifiers)
	if (!cocked)
		balloon_alert(user, "击锤压下")
		cocked = TRUE
		chamber_round()
		playsound(src, hammer_back_sound, hammer_back_sound_volume, TRUE)
		update_appearance()
	else
		balloon_alert(user, "击锤已压下")
	return

/obj/item/gun/ballistic/revolver/single/click_alt(mob/user)
	unload_ammo(user)
	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/revolver/single/update_overlays()
	. = ..()
	. += "[icon_state]_hammer[cocked ? "_back": ""]"

/obj/item/ammo_box/magazine/internal/cylinder/bfr500
	name = "bfr500 cylinder"
	ammo_type = /obj/item/ammo_casing/c357
	caliber = CALIBER_357
	max_ammo = 5

/obj/item/ammo_box/bfr500
	name = "BFR-500 快速装弹器"
	desc = "BFR-500专用装弹器，它的大小非常大，就像是秤砣一样"
	icon = 'modular_z121/icons/obj/guns/bfr500.dmi'
	icon_state = "loader"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/c357
	max_ammo = 5
	multiple_sprites = AMMO_BOX_PER_BULLET
	item_flags = NO_MAT_REDEMPTION

//	防止被叛徒利用
/obj/item/gun/ballistic/revolver/c38/detective/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if (istype(tool, /obj/item/ammo_box/bfr500))
		to_chat(user, span_danger("你尝试使用[tool]装填[src]，但它们不兼容！"))
		return
	return ..()
