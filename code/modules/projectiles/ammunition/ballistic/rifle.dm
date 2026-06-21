// .310 Strilka (Sakhno Rifle)

/obj/item/ammo_casing/strilka310
	name = ".310斯特里尔卡子弹壳"
	desc = "一枚.310斯特里尔卡子弹壳。说它是弹壳有点名不副实；根本没有弹壳，它只是一块红色粉末块。"
	icon_state = "310-casing"
	caliber = CALIBER_STRILKA310
	projectile_type = /obj/projectile/bullet/strilka310

/obj/item/ammo_casing/strilka310/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/strilka310/surplus
	name = ".310斯特里尔卡剩余子弹壳"
	desc = parent_type::desc + "而且还是潮湿的红色粉末。"
	projectile_type = /obj/projectile/bullet/strilka310/surplus

/obj/item/ammo_casing/strilka310/enchanted
	projectile_type = /obj/projectile/bullet/strilka310/enchanted

/obj/item/ammo_casing/strilka310/phasic
	name = ".310斯特里尔卡相位子弹壳"
	desc = "一个相位 .310 斯特里尔卡子弹弹壳。"
	projectile_type = /obj/projectile/bullet/strilka310/phasic

// .223 (M-90gl Carbine)

/obj/item/ammo_casing/a223
	name = ".223 子弹弹壳"
	desc = "一个 .223 子弹弹壳。"
	icon_state = "223-casing"
	caliber = CALIBER_A223
	projectile_type = /obj/projectile/bullet/a223

/obj/item/ammo_casing/a223/phasic
	name = ".223 相位子弹弹壳"
	desc = "一个 .223 相位子弹弹壳。"
	projectile_type = /obj/projectile/bullet/a223/phasic

/obj/item/ammo_casing/a223/weak
	projectile_type = /obj/projectile/bullet/a223/weak

// 40mm (Grenade Launcher)

/obj/item/ammo_casing/a40mm
	name = "40毫米HE弹"
	desc = "A cased high explosive grenade that can only be activated once fired out of a ballistic grenade launcher."
	caliber = CALIBER_40MM
	icon_state = "40mmHE"
	projectile_type = /obj/projectile/bullet/a40mm
	newtonian_force = 1.25

/obj/item/ammo_casing/a40mm/rubber
	name = "40mm 橡胶弹"
	desc = "A cased rubber puck. The big brother of the beanbag slug. Made for stopping someone dead in their tracks."
	projectile_type = /obj/projectile/bullet/shotgun_beanbag/a40mm

/obj/item/ammo_casing/a40mm/flak
	name = "40mm titanium flak shell"
	desc = "An oversized shotgun case. The big brother of buckshot, this shell launches dense titanium shells for immense damage to armor and flesh alike."
	pellets = 8
	variance = 10
	projectile_type = /obj/projectile/bullet/pellet/shotgun_buckshot/milspec/flak

/obj/item/ammo_casing/a40mm/incendiary
	name = "40mm incendiary shell"
	desc = "A cased incendiary explosive grenade that can only be activated once fired out of a ballistic grenade launcher. Creates a mighty conflagration. A favourite of inquisitors."
	projectile_type = /obj/projectile/bullet/a40mm/incendiary

/obj/item/ammo_casing/a40mm/tear_gas
	name = "40mm tear gas shell"
	desc = "A cased tear gas grenade that can only be activated once fired out of a ballistic grenade launcher. Spreads a large amount of tear gas into the air upon impact. \
		Great for suppressing riots, protests and birthday parties!"
	projectile_type = /obj/projectile/bullet/a40mm/tear_gas

/obj/item/disk/design_disk/tear_gas_40mm
	name = "40mm riot suppression grenade shells design disk"

/obj/item/disk/design_disk/liberator/Initialize(mapload)
	. = ..()
	blueprints += new /datum/design/tear_gas_40mm
	blueprints += new /datum/design/rubber_40mm

// Rebar Bolts

/obj/item/ammo_casing/rebar
	name = "磨尖的铁棒"
	desc = "一根磨尖的铁棒。它很尖！"
	caliber = CALIBER_REBAR
	icon_state = "rod_sharp"
	base_icon_state = "rod_sharp"
	projectile_type = /obj/projectile/bullet/rebar
	newtonian_force = 1.5
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/ammo_casing/rebar/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless, TRUE)

/obj/item/ammo_casing/rebar/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]"

/obj/item/ammo_casing/rebar/syndie
	name = "锯齿铁棒"
	desc = "一根铁棒，上面刻有凹槽。你绝对不想让这东西扎进你身体里。"
	caliber = CALIBER_REBAR
	icon_state = "rod_jagged"
	base_icon_state = "rod_jagged"
	projectile_type = /obj/projectile/bullet/rebar/syndie

/obj/item/ammo_casing/rebar/zaukerite
	name = "扎克里特晶片"
	desc = "一片扎克里特水晶的碎片。由于其边缘不规则且呈锯齿状，嵌入体内的扎克里特晶片只能由训练有素的外科医生取出。"
	caliber = CALIBER_REBAR
	icon_state = "rod_zaukerite"
	base_icon_state = "rod_zaukerite"
	projectile_type = /obj/projectile/bullet/rebar/zaukerite

/obj/item/ammo_casing/rebar/hydrogen
	name = "金属氢箭矢"
	desc = "一根由纯金属氢制成的超锋利箭矢。盔甲就跟不存在一样。"
	caliber = CALIBER_REBAR
	icon_state = "rod_hydrogen"
	base_icon_state = "rod_hydrogen"
	projectile_type = /obj/projectile/bullet/rebar/hydrogen

/obj/item/ammo_casing/rebar/healium
	name = "希利姆水晶箭矢"
	desc = "谁还需要注射枪呢？"
	caliber = CALIBER_REBAR
	icon_state = "rod_healium"
	base_icon_state =  "rod_healium"
	projectile_type = /obj/projectile/bullet/rebar/healium
	custom_materials = null
	/// How many seconds of healing/sleeping action we have left, once all are spent the bolt dissolves
	var/heals_left = 6 SECONDS

/obj/item/ammo_casing/rebar/healium/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if (loaded_projectile)
		var/obj/projectile/bullet/rebar/healium/bolt = loaded_projectile
		bolt.heals_left = heals_left
	return ..()

/datum/embedding/rebar_healium
	embed_chance = 100
	fall_chance = 0
	pain_stam_pct = 0.9
	ignore_throwspeed_threshold = TRUE
	rip_time = 1.5 SECONDS
	/// Amount of each type of damage healed per second
	var/healing_per_second = 5
	/// Amount of drowsiness added per second
	var/drowsy_per_second = 2 SECONDS
	/// At what point of drowsiness do we knock out the owner
	var/drowsy_knockout = 5 SECONDS // Actually more like 8 seconds, because you need 4 ticks to reach this
	/// Can this bolt cause sleeping? Used to prevent sleep stacking by shooting multiple bolts
	var/can_sleep = TRUE

/datum/embedding/rebar_healium/on_successful_embed(mob/living/carbon/victim, obj/item/bodypart/target_limb)
	. = ..()
	for(var/obj/item/bodypart/limb as anything in victim.get_bodyparts())
		for(var/obj/item/ammo_casing/rebar/healium/other_rebar in limb.embedded_objects)
			if (other_rebar == parent)
				continue
			var/datum/embedding/rebar_healium/embed_data = other_rebar.get_embed()
			if (istype(embed_data) && embed_data.can_sleep)
				can_sleep = FALSE
				return

/datum/embedding/rebar_healium/process(seconds_per_tick)
	. = ..()
	var/obj/item/ammo_casing/rebar/healium/casing = parent
	casing.heals_left -= seconds_per_tick * 1 SECONDS
	var/update_health = FALSE
	var/healing = -healing_per_second * seconds_per_tick
	update_health += owner.adjust_brute_loss(healing, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
	update_health += owner.adjust_fire_loss(healing, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
	update_health += owner.adjust_tox_loss(healing, updating_health = FALSE, required_biotype = MOB_ORGANIC)
	update_health += owner.adjust_oxy_loss(healing, updating_health = FALSE, required_biotype = MOB_ORGANIC)
	if (update_health)
		owner.updatehealth()
	if (can_sleep && (owner.mob_biotypes & MOB_ORGANIC))
		owner.adjust_drowsiness(drowsy_per_second * seconds_per_tick)
		var/datum/status_effect/drowsiness/drowsiness = owner.has_status_effect(/datum/status_effect/drowsiness)
		if (drowsiness?.duration >= drowsy_knockout)
			owner.Sleeping(3 SECONDS)
	if (casing.heals_left <= 0)
		fall_out()

/datum/embedding/rebar_healium/remove_embedding(mob/living/to_hands)
	. = ..()
	var/obj/item/ammo_casing/rebar/healium/casing = parent
	casing.heals_left = initial(casing.heals_left)
	can_sleep = TRUE

/obj/item/ammo_casing/rebar/supermatter
	name = "超物质箭矢"
	desc = "等等，这把弓怎么能发射这个而不变成灰？"
	caliber = CALIBER_REBAR
	icon_state = "rod_supermatter"
	base_icon_state = "rod_supermatter"
	projectile_type = /obj/projectile/bullet/rebar/supermatter

/obj/item/ammo_casing/rebar/paperball
	name = "纸团"
	desc = "咚！"
	caliber = CALIBER_REBAR
	icon_state = "paperball"
	base_icon_state = "paperball"
	projectile_type = /obj/projectile/bullet/paperball
	newtonian_force = 0.5
	custom_materials = list(/datum/material/paper = HALF_SHEET_MATERIAL_AMOUNT / 2)
