/obj/item/gun/energy/photon_sniper
	name = "光子狙击步枪"
	desc = "一把能量狙击枪，发射足以点燃目标的高能激光，且不能烤肉，建议使用年龄：18岁以上"
	icon = 'modular_z121/icons/obj/guns/photon_sniper.dmi'
	icon_state = "photon"
	lefthand_file = 'modular_z121/icons/mob/guns/photon_sniper_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/photon_sniper_righthand.dmi'
	inhand_icon_state = "photon"
	worn_icon = 'modular_z121/icons/mob/guns/photon_sniper_worn.dmi'
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
	click_cooldown_override = 20
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
	armor_flag = LASER
	reflectable = NONE
	range = 50
	var/fire_stacks = 4

/obj/projectile/energy/photon_sniper/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.ignite_mob()
