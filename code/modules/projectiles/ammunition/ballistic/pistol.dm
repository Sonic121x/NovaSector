// 10mm

/obj/item/ammo_casing/c10mm
	name = "10mm 子弹弹壳"
	desc = "一颗 10mm 子弹弹壳。"
	caliber = CALIBER_10MM
	projectile_type = /obj/projectile/bullet/c10mm
	newtonian_force = 0.75

/obj/item/ammo_casing/c10mm/ap
	name = "10mm 穿甲弹弹壳"
	desc = "一颗 10mm 穿甲弹弹壳。"
	projectile_type = /obj/projectile/bullet/c10mm/ap

/obj/item/ammo_casing/c10mm/hp
	name = "10mm 空尖弹弹壳"
	desc = "A 10mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/c10mm/hp

/obj/item/ammo_casing/c10mm/fire
	name = "10mm 燃烧弹弹壳"
	desc = "一颗 10mm 燃烧弹弹壳。"
	projectile_type = /obj/projectile/bullet/incendiary/c10mm

// 9mm (Makarov, Stechkin APS)

/obj/item/ammo_casing/c9mm
	name = "9mm 子弹弹壳"
	desc = "一颗 9mm 子弹弹壳。"
	caliber = CALIBER_9MM
	projectile_type = /obj/projectile/bullet/c9mm
	newtonian_force = 0.75

/obj/item/ammo_casing/c9mm/ap
	name = "9mm 穿甲弹弹壳"
	desc = "一颗 9mm 穿甲弹弹壳。"
	projectile_type =/obj/projectile/bullet/c9mm/ap

/obj/item/ammo_casing/c9mm/hp
	name = "9mm 空尖弹弹壳"
	desc = "一个9毫米空尖子弹弹壳。"
	projectile_type = /obj/projectile/bullet/c9mm/hp

/obj/item/ammo_casing/c9mm/fire
	name = "9mm 燃烧弹弹壳"
	desc = "一颗 9mm 燃烧弹弹壳。"
	projectile_type = /obj/projectile/bullet/incendiary/c9mm

// .50AE (Desert Eagle)

/obj/item/ammo_casing/a50ae
	name = ".50AE 子弹"
	desc = "一颗 .50AE 子弹弹壳。"
	caliber = CALIBER_50AE
	projectile_type = /obj/projectile/bullet/a50ae

// .160 Smart (Abielle smartgun)

/obj/item/ammo_casing/c160smart
	name = ".160智能子弹弹壳"
	desc = "一枚.160智能子弹，底部装有少量助推推进剂。"
	icon_state = "smartgun_casing"
	caliber = CALIBER_160SMART
	projectile_type = /obj/projectile/bullet/c160smart
	/// How many tiles away should we check for smart auto-locking
	var/auto_lock_range = 2

/obj/item/ammo_casing/c160smart/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/c160smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	. = ..()
	if(!isturf(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	else
		var/atom/aimbot_target = locate(/mob/living) in range(auto_lock_range, target)
		if(aimbot_target)
			loaded_projectile.set_homing_target(aimbot_target)
			new /obj/effect/temp_visual/smartgun_target(get_turf(aimbot_target))

/obj/effect/temp_visual/smartgun_target
	name = "智能枪目标瞄准镜"
	desc = "一个全息十字准星，这可能意味着你应该开始逃跑了。"
	icon_state = "launchpad_pull"
	duration = 0.25 SECONDS
