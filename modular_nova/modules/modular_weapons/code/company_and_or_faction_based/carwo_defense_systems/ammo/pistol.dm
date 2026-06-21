// .35 Sol Short
// Pistol caliber caseless round used almost exclusively by SolFed weapons

/obj/item/ammo_casing/c35sol
	name = ".35索尔短弹致命弹壳"
	desc = "一款太阳联邦标准的无壳致命手枪弹。"

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/ammo.dmi'
	icon_state = "35sol"

	caliber = CALIBER_SOL35SHORT
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/c35_sol
	projectile_type = /obj/projectile/bullet/c35sol


/obj/item/ammo_casing/c35sol/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/caseless)


/obj/projectile/bullet/c35sol
	name = ".35索尔短弹"
	damage = 16

	wound_bonus = 5 // Normal bullets are 20
	exposed_wound_bonus = 10


/obj/item/ammo_box/c35sol
	name = "弹药盒（.35索尔短弹致命）"
	desc = "一盒.35索尔短弹手枪弹，内装二十四发。"

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/ammo.dmi'
	icon_state = "35box"

	multiple_sprites = AMMO_BOX_FULL_EMPTY

	w_class = WEIGHT_CLASS_NORMAL

	caliber = CALIBER_SOL35SHORT
	ammo_type = /obj/item/ammo_casing/c35sol
	max_ammo = 24


// .35 Sol's equivalent to a rubber bullet

/obj/item/ammo_casing/c35sol/incapacitator
	name = ".35索尔短弹失能弹壳"
	desc = "一款太阳联邦标准的无壳低致命手枪弹。命中目标会使其力竭，在浅角度撞击墙壁时容易反弹。"

	icon_state = "35sol_disabler"

	projectile_type = /obj/projectile/bullet/c35sol/incapacitator
	harmful = FALSE
	ammo_categories = AMMO_CLASS_NONE


/obj/projectile/bullet/c35sol/incapacitator
	name = ".35索尔短弹失能弹"
	damage = 3
	stamina = 20

	wound_bonus = -40
	exposed_wound_bonus = -20

	weak_against_armour = TRUE

	// The stats of the ricochet are a nerfed version of detective revolver rubber ammo
	// This is due to the fact that there's a lot more rounds fired quickly from weapons that use this, over a revolver
	ricochet_auto_aim_angle = 30
	ricochet_auto_aim_range = 5
	ricochets_max = 4
	ricochet_incidence_leeway = 50
	ricochet_chance = 130
	ricochet_decay_damage = 0.8

	shrapnel_type = null
	sharpness = NONE
	embed_data = null


/obj/item/ammo_box/c35sol/incapacitator
	name = "弹药盒（.35索尔短弹失能）"
	desc = "一盒.35索尔短弹手枪弹，内装二十四发。蓝色条纹表明此盒应装有低致命弹药。"

	icon_state = "35box_disabler"

	ammo_type = /obj/item/ammo_casing/c35sol/incapacitator


// .35 Sol ripper, similar to the detective revolver's dumdum rounds, causes slash wounds and is weak to armor

/obj/item/ammo_casing/c35sol/ripper
	name = ".35索尔短弹撕裂弹壳"
	desc = "一款太阳联邦标准的无壳撕裂手枪弹。对目标造成切割伤，但对护甲效果较弱。"

	icon_state = "35sol_shrapnel"
	projectile_type = /obj/projectile/bullet/c35sol/ripper

	custom_materials = AMMO_MATS_RIPPER
	ammo_categories = AMMO_CLASS_PLUS

/obj/projectile/bullet/c35sol/ripper
	name = ".35索尔撕裂弹"
	damage = 10

	weak_against_armour = TRUE

	sharpness = SHARP_EDGED

	wound_bonus = 20
	exposed_wound_bonus = 20

	embed_type = /datum/embedding/c35sol_ripper

	embed_falloff_tile = -15

/datum/embedding/c35sol_ripper
	embed_chance = 75
	fall_chance = 3
	jostle_chance = 4
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.4
	pain_mult = 5
	jostle_pain_mult = 6
	rip_time = 1 SECONDS

/obj/item/ammo_box/c35sol/ripper
	name = "弹药盒（.35索尔短弹撕裂）"
	desc = "一盒.35索尔短弹手枪弹，内装二十四发。紫色条纹表明此盒应装有类似空尖弹的弹药。"

	icon_state = "35box_shrapnel"

	ammo_type = /obj/item/ammo_casing/c35sol/ripper

// .35 Sol flash, similar to Polaris code flash ammo for pistols.

/obj/item/ammo_casing/c35sol/flash
	name = ".35索尔短弹闪光弹壳"
	desc = "一款太阳联邦标准的无壳低致命手枪弹。命中时产生小型烟火闪光；不足以使机械人过载。"

	icon_state = "35sol_flash"

	projectile_type = /obj/projectile/bullet/c35sol/flash
	harmful = FALSE
	ammo_categories = AMMO_CLASS_NONE

/obj/projectile/bullet/c35sol/flash
	name = ".35索尔短弹闪光弹"
	damage = 5

	shrapnel_type = null
	sharpness = NONE
	embed_data = null

/obj/projectile/bullet/c35sol/flash/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	do_sparks(rand(1, 4), FALSE, src)
	if(isliving(target))
		var/mob/living/flashed_living = target
		flashed_living.ignite_mob() // lmao
		if(flashed_living.flash_act(intensity = 1, affect_silicon = TRUE, length = 1 SECONDS))
			flashed_living.set_confusion_if_lower(2 SECONDS)
			flashed_living.adjust_stamina_loss(rand(30, 35))

/obj/item/ammo_box/c35sol/flash
	name = "弹药盒（.35索尔短弹闪光）"
	desc = "一盒.35索尔短弹手枪弹，内装二十四发。橙色条纹表明此盒应装有闪光弹药，存在引燃风险。"

	icon_state = "35box_flash"

	ammo_type = /obj/item/ammo_casing/c35sol/flash

/obj/item/ammo_box/speedloader/c35sol
	name = "快速装弹器（.35索尔短弹）"
	desc = "专为快速装填八发弹巢的.35索尔短弹左轮手枪而设计。"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/ammo.dmi'
	icon_state = "sl35sol"
	ammo_type = /obj/item/ammo_casing/c35sol
	max_ammo = 8
	caliber = CALIBER_SOL35SHORT
	ammo_band_icon = "+sl35_band"
	ammo_band_color = null
