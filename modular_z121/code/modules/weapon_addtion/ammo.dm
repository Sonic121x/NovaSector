//	弹道射弹
//	.20 Nuoli
/obj/item/ammo_casing/c20nuoli
	name = ".20 Nuoli致命弹"
	desc = "一枚.20 Nuoli致命弹，口径很小，常见于一些高射速武器"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "20nuoli"

	caliber = CALIBER_20NUOLI
	projectile_type = /obj/projectile/bullet/c20nuoli
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/c20nuoli

/obj/item/ammo_box/magazine/ammo_stack/c20nuoli
	name = ".20 Nuoli弹堆"
	desc = "一堆.20 Nuoli弹"
	caliber = CALIBER_20NUOLI
	ammo_type = /obj/item/ammo_casing/c20nuoli
	max_ammo = 25
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_casing/c20nuoli/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/caseless)

/obj/projectile/bullet/c20nuoli
	name = ".20 Nuoli弹"
	damage = 20

	wound_bonus = -15
	exposed_wound_bonus = -10

/obj/item/ammo_box/c20nuoli
	name = "弹药箱 (.20 Nuoli致命)"
	desc = "一箱.20 Nuoli致命弹，里面装有200发子弹"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "20box"

	multiple_sprites = AMMO_BOX_FULL_EMPTY

	w_class = WEIGHT_CLASS_BULKY

	caliber = CALIBER_20NUOLI
	ammo_type = /obj/item/ammo_casing/c20nuoli
	max_ammo = 200

	force = 13	//大的跟个工具箱似得，砸人坑定非常痛
	throwforce = 13
	hitsound = 'sound/items/weapons/smash.ogg'
	drop_sound = 'sound/items/handling/toolbox/toolbox_drop.ogg'
	pickup_sound = 'sound/items/handling/toolbox/toolbox_pickup.ogg'

//	聪明弹
/obj/item/ammo_casing/c20nuoli/smart
	name = ".20 Nuoli智能弹"
	desc = "一枚.20 Nuoli智能弹，专为猎杀各种非人形生物设计的弹药。内置了弹道计算芯片自动规避人形生物，避免了误伤人类和类人生物的可能性。子弹对结构类物体破坏力较差"

	icon_state = "20nuoli_smart"

	projectile_type = /obj/projectile/bullet/c20nuoli/smart

	ammo_categories = AMMO_CLASS_PLUS
	ammo_categories = AMMO_MATS_AP

/obj/projectile/bullet/c20nuoli/smart
	name = ".20 Nuoli智能弹"
	icon_state = "gauss_silenced"
	damage = 30
	weak_against_armour = TRUE
	demolition_mod = 0.5
	var/damage_subtraction = 15

/obj/projectile/bullet/c20nuoli/smart/on_hit(mob/living/target, blocked = 0, pierce_hit)
	if (!isliving(target))
		return ..()

	if (target.mob_biotypes & MOB_HUMANOID)
		return BULLET_ACT_FORCE_PIERCE

	if(damage < initial(damage))
		return ..()
	//	我不希望它可以用来对付赛博
	if(target.mob_biotypes & MOB_ROBOTIC)
		damage -= damage_subtraction
	return ..()

/obj/item/ammo_box/c20nuoli/smart
	name = "弹药箱 (.20 Nuoli智能)"
	desc = "一箱.20 Nuoli智能弹，里面装有200发子弹"

	icon_state = "20box_smart"

	ammo_type = /obj/item/ammo_casing/c20nuoli/smart

//	反器材
/obj/item/ammo_casing/c20nuoli/breacher
	name = ".20 Nuoli反器材弹"
	desc = "一枚.20 Nuoli智能弹，门窗结构与载具的杀手，机甲也是一样。子弹在击中目标时，有概率对目标进行emp"

	icon_state = "20nuoli_breacher"

	projectile_type = /obj/projectile/bullet/c20nuoli/breacher

	ammo_categories = AMMO_CLASS_PLUS
	ammo_categories = AMMO_MATS_EMP

/obj/projectile/bullet/c20nuoli/breacher
	name = ".20 Nuoli反器材弹"
	icon_state = "redtrac"
	damage = 15
	demolition_mod = 2

	var/anti_materiel_damage_addition = 15
	var/emp_probability = 5

/obj/projectile/bullet/c20nuoli/breacher/on_hit(mob/living/target, blocked = 0, pierce_hit)
	if(prob(emp_probability))
		empulse(target, 1, 1, emp_source = src)

	if(!isliving(target) || (damage > initial(damage)))
		return ..()
	if(target.mob_biotypes & MOB_ROBOTIC)
		damage += anti_materiel_damage_addition
	return ..()

/obj/item/ammo_box/c20nuoli/breacher
	name = "弹药箱 (.20 Nuoli反器材)"
	desc = "一箱.20 Nuoli反器材弹，里面装有200发子弹"

	icon_state = "20box_breacher"

	ammo_type = /obj/item/ammo_casing/c20nuoli/breacher

//	钢制弩箭
/obj/projectile/bullet/rebar/bolt
	name = "钢制弩箭"

	icon = 'modular_z121/icons/obj/guns/projectiles.dmi'
	icon_state = "steel_bolt"

	//  买的东西还有概率断肢显得太弱智了
	dismemberment = 0

/obj/item/ammo_casing/rebar/bolt
	name = "钢制弩箭"
	desc = "由碳钢铸造的弩箭，可以重复使用。适用于隐蔽作战，在太空内也能保持有效杀伤。"

	icon = 'modular_z121/icons/obj/guns/ammo.dmi'
	icon_state = "steel_bolt"
	base_icon_state = "steel_bolt"

	projectile_type = /obj/projectile/bullet/rebar/bolt

//	能量射弹
/obj/item/ammo_casing/energy/photon_sniper
	projectile_type = /obj/projectile/energy/photon_sniper
	e_cost = LASER_SHOTS(10, STANDARD_CELL_CHARGE)
	fire_sound = "modular_z121/sound/guns/photon_sniper/photon_sniper_fire.ogg"
	click_cooldown_override = 25
	select_name = "burn"

/obj/projectile/energy/photon_sniper
	name = "光子束"
	icon_state = null
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	tracer_type = /obj/effect/projectile/tracer/laser/emitter/redlens
	impact_type = /obj/effect/projectile/impact/heavy_laser
	impact_effect_type = null
	damage = 20
	damage_type = BURN
	armor_flag = ENERGY
	reflectable = NONE
	range = 50
	var/temperature = 300
	var/fire_stacks = 1

/obj/projectile/energy/photon_sniper/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/hit_mob = target
		var/thermal_protection = 1 - hit_mob.get_insulation_protection(hit_mob.bodytemperature + temperature)
		var/how_hot_is_target = hit_mob.bodytemperature
		var/danger_zone = hit_mob.dna.species.bodytemp_heat_damage_limit + 300

		// The new body temperature is adjusted by the bullet's effect temperature
		// Reduce the amount of the effect temperature change based on the amount of insulation the mob is wearing
		hit_mob.adjust_bodytemperature((thermal_protection * temperature) + temperature)

		if(how_hot_is_target > danger_zone)
			hit_mob.adjust_fire_stacks(fire_stacks)
			hit_mob.ignite_mob()

	else if(isliving(target))
		var/mob/living/L = target
		// the new body temperature is adjusted by the bullet's effect temperature
		L.adjust_bodytemperature((1 - blocked) * temperature)

	if(isobj(target))
		var/obj/objectification = target

		if(objectification.reagents)
			var/datum/reagents/reagents = objectification.reagents
			reagents?.expose_temperature(temperature)
