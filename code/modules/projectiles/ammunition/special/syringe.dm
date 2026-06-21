/obj/item/ammo_casing/syringegun
	name = "注射枪弹簧"
	desc = "发射注射器的高功率弹簧"
	slot_flags = null
	projectile_type = /obj/projectile/bullet/dart/syringe
	firing_effect_type = null

/obj/item/ammo_casing/syringegun/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if(!loaded_projectile)
		return

	if(istype(loc, /obj/item/gun/syringe))
		var/obj/item/gun/syringe/syringegun = loc
		if(!syringegun.syringes.len)
			return

		var/obj/item/reagent_containers/syringe/syringe = syringegun.syringes[1]
		var/obj/projectile/bullet/dart/dart = loaded_projectile
		dart.name = syringe.name
		dart.inject_flags = syringe.inject_flags
		dart.armour_penetration = syringe.armour_penetration
		syringegun.syringes.Remove(syringe)
		if (syringegun.low_power)
			insert_syringe(syringe)
			return ..()

		syringe.reagents.trans_to(dart, syringe.reagents.total_volume, transferred_by = user)
		qdel(syringe)
		return ..()

	if(!istype(loc, /obj/item/mecha_parts/mecha_equipment/medical/syringe_gun))
		return ..()

	var/obj/item/mecha_parts/mecha_equipment/medical/syringe_gun/syringe_gun = loc
	var/obj/item/reagent_containers/syringe/loaded_syringe = syringe_gun.syringes[1]
	var/obj/projectile/bullet/dart/shot_dart = loaded_projectile
	syringe_gun.reagents.trans_to(shot_dart, min(loaded_syringe.volume, syringe_gun.reagents.total_volume), transferred_by = user)
	shot_dart.name = loaded_syringe.name
	shot_dart.inject_flags = loaded_syringe.inject_flags
	LAZYREMOVE(syringe_gun.syringes, loaded_syringe)
	qdel(loaded_syringe)
	return ..()

/obj/item/ammo_casing/syringegun/proc/insert_syringe(obj/item/reagent_containers/syringe/syringe)
	var/obj/projectile/bullet/dart/syringe/dart = loaded_projectile
	dart.set_embed(syringe.get_embed()?.create_copy())
	dart.get_embed().embed_chance = 100 // Don't want to fail the shot here
	syringe.forceMove(dart)
	dart.inner_syringe = syringe

/obj/item/ammo_casing/chemgun
	name = "飞镖合成器"
	desc = "一个强力弹簧，与一种基于能量的穿刺飞镖合成器相连。"
	projectile_type = /obj/projectile/bullet/dart/piercing
	firing_effect_type = null

/obj/item/ammo_casing/chemgun/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if(!loaded_projectile)
		return
	if(istype(loc, /obj/item/gun/chem))
		var/obj/item/gun/chem/CG = loc
		if(CG.syringes_left <= 0)
			return
		CG.reagents.trans_to(loaded_projectile, 15, transferred_by = user)
		loaded_projectile.name = "穿甲化学镖弹"
		CG.syringes_left--
	return ..()

/obj/item/ammo_casing/dnainjector
	name = "改装注射枪弹簧"
	desc = "一个强力弹簧，用于发射 DNA 注射器。"
	projectile_type = /obj/projectile/bullet/dnainjector
	firing_effect_type = null

/obj/item/ammo_casing/dnainjector/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if(!loaded_projectile)
		return
	if(istype(loc, /obj/item/gun/syringe/dna))
		var/obj/item/gun/syringe/dna/SG = loc
		if(!SG.syringes.len)
			return

		var/obj/item/dnainjector/S = popleft(SG.syringes)
		var/obj/projectile/bullet/dnainjector/D = loaded_projectile
		S.forceMove(D)
		D.injector = S
	return ..()
