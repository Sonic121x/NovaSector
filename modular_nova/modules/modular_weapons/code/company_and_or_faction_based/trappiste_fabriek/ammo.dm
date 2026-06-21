// .585 Trappiste
// High caliber round used in large pistols and revolvers

/obj/item/ammo_casing/c585trappiste
	name = ".585 Trappiste 致命子弹弹壳"
	desc = "一种白色聚合物弹壳的大口径子弹，常用于手枪。"

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/ammo.dmi'
	icon_state = "585trappiste"

	caliber = CALIBER_585TRAPPISTE
	projectile_type = /obj/projectile/bullet/c585trappiste
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/c585_trappiste

/obj/projectile/bullet/c585trappiste
	name = ".585 Trappiste 子弹"
	damage = 30
	wound_bonus = 5 // Normal bullets are 20

/obj/item/ammo_box/c585trappiste
	name = "弹药盒 (.585 Trappiste 致命弹)"
	desc = "一盒 .585 Trappiste 手枪子弹，装有十发。"

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/ammo.dmi'
	icon_state = "585box"

	multiple_sprites = AMMO_BOX_FULL_EMPTY

	w_class = WEIGHT_CLASS_NORMAL

	caliber = CALIBER_585TRAPPISTE
	ammo_type = /obj/item/ammo_casing/c585trappiste
	max_ammo = 10

// .585 Trappiste equivalent to a rubber bullet

/obj/item/ammo_casing/c585trappiste/incapacitator
	name = ".585 Trappiste 平头子弹弹壳"
	desc = "一种白色聚合物弹壳的大口径子弹，带有相对较软的平头。设计用于在撞击目标时变形，通常不会穿透。"

	icon_state = "585trappiste_disabler"

	projectile_type = /obj/projectile/bullet/c585trappiste/incapacitator
	ammo_categories = AMMO_CLASS_NONE
	harmful = FALSE

/obj/projectile/bullet/c585trappiste/incapacitator
	name = ".585 Trappiste 平头子弹"
	damage = 15
	stamina = 30
	wound_bonus = 10

	weak_against_armour = TRUE

	shrapnel_type = null
	sharpness = NONE
	embed_data = null

/obj/item/ammo_box/c585trappiste/incapacitator
	name = "弹药盒 (.585 特拉皮斯特平头弹)"
	desc = "一盒 .585 特拉皮斯特手枪弹，内装十发。蓝色条纹表明其应装有低致命性弹药。"

	icon_state = "585box_disabler"

	ammo_type = /obj/item/ammo_casing/c585trappiste/incapacitator

// .585 incendiary, less damage, sets people on fire

/obj/item/ammo_casing/c585trappiste/incendiary
	name = ".585 特拉皮斯特燃烧弹弹壳"
	desc = "一种白色聚合物弹壳的大口径子弹，配有同样白色的磷弹头。设计用于在撞击时爆燃。"

	icon_state = "585trappiste_hot"
	projectile_type = /obj/projectile/bullet/c585trappiste/incendiary

	ammo_categories = AMMO_CLASS_NICHE
	custom_materials = AMMO_MATS_TEMP

/obj/projectile/bullet/c585trappiste/incendiary
	name = ".585 特拉皮斯特燃烧弹"
	damage = 25


/// How many firestacks the bullet should impart upon a target when impacting
	var/firestacks_to_give = 1

/obj/projectile/bullet/c585trappiste/incendiary/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()

	if(iscarbon(target))
		var/mob/living/carbon/gaslighter = target
		gaslighter.adjust_fire_stacks(firestacks_to_give)
		gaslighter.ignite_mob()

/obj/item/ammo_box/c585trappiste/incendiary
	name = "弹药盒 (.585 特拉皮斯特燃烧弹)"
	desc = "一盒 .585 特拉皮斯特手枪弹，内装十发。橙色条纹表明其应装有燃烧弹。"

	icon_state = "585box_hot"

	ammo_type = /obj/item/ammo_casing/c585trappiste/incendiary

/obj/item/ammo_box/speedloader/c585trappiste
	name = "快速装弹器 (.585 特拉皮斯特)"
	desc = "设计用于快速装填六发式 .585 特拉皮斯特左轮手枪。"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/ammo.dmi'
	icon_state = "sl585t"
	ammo_type = /obj/item/ammo_casing/c585trappiste
	max_ammo = 6
	caliber = CALIBER_585TRAPPISTE
	w_class = WEIGHT_CLASS_SMALL
	ammo_band_icon = "+sl585_band"
	ammo_band_color = null
