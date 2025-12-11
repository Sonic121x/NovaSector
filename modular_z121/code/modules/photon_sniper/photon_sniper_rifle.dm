/obj/item/gun/energy/photon_sniper
	name = "光子狙击步枪"
	desc = "一把能量狙击枪，发射足以点燃目标的高能激光，且不能烤肉，建议使用年龄：18岁以上"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns48x.dmi'
	icon_state = "photon"
	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "photon"
	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "photon"
	SET_BASE_VISUAL_PIXEL(-8, 0)
	weapon_weight = WEAPON_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/photon_sniper)
	shaded_charge = TRUE
	charge_sections = 3

/obj/item/gun/energy/photon_sniper/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

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

