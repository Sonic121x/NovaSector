/obj/item/gun/energy/recharge/kinetic_accelerator
	name = "原动能加速器"
	desc = "一种可自我充电的远程采矿工具，在低压力环境下能造成更大的伤害。"
	icon_state = "kineticgun"
	base_icon_state = "kineticgun"
	inhand_icon_state = "kineticgun"
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic)
	item_flags = NONE
	obj_flags = UNIQUE_RENAME
	resistance_flags = FIRE_PROOF
	weapon_weight = WEAPON_LIGHT
	gun_flags = NOT_A_REAL_GUN
	///List of all mobs that projectiles fired from this gun will ignore.
	var/list/ignored_mob_types
	///List of all modkits currently in the kinetic accelerator.
	var/list/obj/item/borg/upgrade/modkit/modkits = list()
	///The max capacity of modkits the PKA can have installed at once.
	var/max_mod_capacity = 100

/obj/item/gun/energy/recharge/kinetic_accelerator/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 20, offset_y = 12)

/obj/item/gun/energy/recharge/kinetic_accelerator/Initialize(mapload)
	. = ..()
	// Only actual KAs can be converted
	if(type != /obj/item/gun/energy/recharge/kinetic_accelerator)
		return
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/ebow)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/gun/energy/recharge/kinetic_accelerator/apply_fantasy_bonuses(bonus)
	. = ..()
	max_mod_capacity = modify_fantasy_variable("max_mod_capacity", max_mod_capacity, bonus * 10)

/obj/item/gun/energy/recharge/kinetic_accelerator/remove_fantasy_bonuses(bonus)
	max_mod_capacity = reset_fantasy_variable("max_mod_capacity", max_mod_capacity)
	return ..()

/obj/item/gun/energy/recharge/kinetic_accelerator/Initialize(mapload)
	. = ..()

	AddElement( \
		/datum/element/contextual_screentip_bare_hands, \
		rmb_text = "Detach a modkit", \
	)

	var/static/list/tool_behaviors = list(
		TOOL_CROWBAR = list(
			SCREENTIP_CONTEXT_LMB = "Eject all modkits",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/obj/item/gun/energy/recharge/kinetic_accelerator/shoot_with_empty_chamber(mob/living/user)
	playsound(src, dry_fire_sound, 30, TRUE) //click sound but no to_chat message to cut on spam
	return

/obj/item/gun/energy/recharge/kinetic_accelerator/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 9)

/obj/item/gun/energy/recharge/kinetic_accelerator/examine(mob/user)
	. = ..()
	if(max_mod_capacity)
		. += "<b>[get_remaining_mod_capacity()]%</b> mod capacity remaining."
		. += span_info("你可以使用<b>撬棍</b>来移除所有模块，或者<b>右键单击</b>空手来移除特定模块。")
		for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in modkits)
			. += span_notice("There is \a [modkit_upgrade] installed, using <b>[modkit_upgrade.cost]%</b> capacity.")

/obj/item/gun/energy/recharge/kinetic_accelerator/crowbar_act(mob/living/user, obj/item/I)
	. = TRUE
	if(modkits.len)
		to_chat(user, span_notice("你把所有改装件都撬了出来。"))
		I.play_tool_sound(src, 100)
		for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in modkits)
			if (modkit_upgrade.removable)
				modkit_upgrade.forceMove(drop_location()) //uninstallation handled in Exited(), or /mob/living/silicon/robot/remove_from_upgrades() for borgs
	else
		to_chat(user, span_notice("当前没有安装任何改装件。"))

/obj/item/gun/energy/recharge/kinetic_accelerator/try_fire_gun(atom/target, mob/living/user, params)
	return fire_gun(target, user, user.Adjacent(target) && !isturf(target), params)

/obj/item/gun/energy/recharge/kinetic_accelerator/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!LAZYLEN(modkits))
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	var/list/display_names = list()
	var/list/items = list()
	for(var/modkits_length in 1 to length(modkits))
		var/obj/item/borg/upgrade/modkit/thing = modkits[modkits_length]
		if (!thing.removable)
			continue
		display_names["[thing.name] ([modkits_length])"] = REF(thing)
		var/image/item_image = image(icon = thing.icon, icon_state = thing.icon_state)
		if(length(thing.overlays))
			item_image.copy_overlays(thing)
		items["[thing.name] ([modkits_length])"] = item_image

	var/pick = show_radial_menu(user, src, items, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE, tooltips = TRUE)
	if(!pick)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/modkit_reference = display_names[pick]
	var/obj/item/borg/upgrade/modkit/modkit_to_remove = locate(modkit_reference) in modkits
	if(!istype(modkit_to_remove))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!user.put_in_hands(modkit_to_remove))
		modkit_to_remove.forceMove(drop_location())
	update_appearance(UPDATE_ICON)


	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/energy/recharge/kinetic_accelerator/proc/check_menu(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated)
		return FALSE
	return TRUE

/obj/item/gun/energy/recharge/kinetic_accelerator/Exited(atom/movable/gone, direction)
	if(gone in modkits)
		var/obj/item/borg/upgrade/modkit/MK = gone
		MK.uninstall(src)
	return ..()

/obj/item/gun/energy/recharge/kinetic_accelerator/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(istype(arrived, /obj/item/borg/upgrade/modkit))
		modkits |= arrived

/obj/item/gun/energy/recharge/kinetic_accelerator/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/borg/upgrade/modkit))
		var/obj/item/borg/upgrade/modkit/MK = I
		MK.install(src, user)
	else
		return ..()

/obj/item/gun/energy/recharge/kinetic_accelerator/proc/get_remaining_mod_capacity()
	var/current_capacity_used = 0
	for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in modkits)
		current_capacity_used += modkit_upgrade.cost
	return max_mod_capacity - current_capacity_used

/obj/item/gun/energy/recharge/kinetic_accelerator/proc/modify_projectile(obj/projectile/kinetic/kinetic_projectile)
	kinetic_projectile.kinetic_gun = src //do something special on-hit, easy!
	for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in modkits)
		modkit_upgrade.modify_projectile(kinetic_projectile)

/obj/item/gun/energy/recharge/kinetic_accelerator/bdm
	name = "infernal proto-kinetic accelerator"
	icon_state = "kineticgun_evil"
	inhand_icon_state = "kineticgun_evil"

/obj/item/gun/energy/recharge/kinetic_accelerator/bdm/Initialize(mapload)
	. = ..()
	var/obj/item/borg/upgrade/modkit/cooldown/repeater/bdm/repeater_mod = new()
	repeater_mod.install(src)

/obj/item/gun/energy/recharge/kinetic_accelerator/cyborg
	icon_state = "kineticgun_b"
	holds_charge = TRUE
	unique_frequency = TRUE
	max_mod_capacity = 90

/obj/item/gun/energy/recharge/kinetic_accelerator/minebot
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	recharge_time = 2 SECONDS
	holds_charge = TRUE
	unique_frequency = TRUE

//Casing
/obj/item/ammo_casing/energy/kinetic
	projectile_type = /obj/projectile/kinetic
	select_name = "kinetic"
	e_cost = LASER_SHOTS(1, STANDARD_CELL_CHARGE * 0.5)
	fire_sound = 'sound/items/weapons/kinetic_accel.ogg'
	newtonian_force = 1

/obj/item/ammo_casing/energy/kinetic/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	..()
	if(loc && istype(loc, /obj/item/gun/energy/recharge/kinetic_accelerator))
		var/obj/item/gun/energy/recharge/kinetic_accelerator/KA = loc
		KA.modify_projectile(loaded_projectile)

//Projectiles
/obj/projectile/kinetic
	name = "动能力场"
	icon_state = null
	damage = 40
	damage_type = BRUTE
	armor_flag = BOMB
	range = 3
	log_override = TRUE

	var/pressure_decrease_active = FALSE
	var/pressure_decrease = 0.25
	var/obj/item/gun/energy/recharge/kinetic_accelerator/kinetic_gun

/obj/projectile/kinetic/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/parriable_projectile, parry_callback = CALLBACK(src, PROC_REF(on_parry)))

/obj/projectile/kinetic/Destroy()
	kinetic_gun = null
	return ..()

/obj/projectile/kinetic/prehit_pierce(atom/target)
	if(is_type_in_typecache(target, kinetic_gun?.ignored_mob_types))
		return PROJECTILE_PIERCE_PHASE
	. = ..()
	if(. == PROJECTILE_PIERCE_PHASE)
		return
	for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in kinetic_gun?.modkits)
		modkit_upgrade.projectile_prehit(src, target, kinetic_gun)
	if(!pressure_decrease_active && !lavaland_equipment_pressure_check(get_turf(target)))
		name = "虚弱的[name]"
		damage = damage * pressure_decrease
		pressure_decrease_active = TRUE

/obj/projectile/kinetic/proc/on_parry(mob/user)
	SIGNAL_HANDLER

	// Ensure that if the user doesn't have tracer mod we're still visible
	icon_state = "ka_tracer"
	update_appearance()

/obj/projectile/kinetic/on_range()
	if(!pressure_decrease_active && !lavaland_equipment_pressure_check(get_turf(src)))
		name = "虚弱的[name]"
		damage = damage * pressure_decrease
		pressure_decrease_active = TRUE

	strike_thing(loc)
	..()

/obj/projectile/kinetic/on_hit(atom/target, blocked = 0, pierce_hit)
	strike_thing(target)
	. = ..()

/obj/projectile/kinetic/proc/strike_thing(atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		target_turf = get_turf(src)
	if(kinetic_gun) //hopefully whoever shot this was not very, very unfortunate.
		var/list/mods = kinetic_gun.modkits
		for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in mods)
			modkit_upgrade.projectile_strike_predamage(src, target_turf, target, kinetic_gun)
		for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in mods)
			modkit_upgrade.projectile_strike(src, target_turf, target, kinetic_gun)
	if(ismineralturf(target_turf))
		var/turf/closed/mineral/M = target_turf
		M.gets_drilled(firer, 1)
		if(iscarbon(firer))
			var/mob/living/carbon/carbon_firer = firer
			var/skill_modifier = 1
			// If there is a mind, check for skill modifier to allow them to reload faster.
			if(carbon_firer.mind)
				skill_modifier = carbon_firer.mind.get_skill_modifier(/datum/skill/mining, SKILL_SPEED_MODIFIER)
			kinetic_gun.attempt_reload(kinetic_gun.recharge_time * skill_modifier) //If you hit a mineral, you might get a quicker reload. epic gamer style.
	var/obj/effect/temp_visual/kinetic_blast/K = new /obj/effect/temp_visual/kinetic_blast(target_turf)
	K.color = color

//mecha_kineticgun version of the projectile
/obj/projectile/kinetic/mech
	range = 5
	damage = 50

/obj/projectile/kinetic/mech/strike_thing(atom/target)
	. = ..()
	new /obj/effect/temp_visual/explosion/fast(get_turf(target))

	for(var/turf/closed/mineral/mineral_turf in RANGE_TURFS(2, target) - target)
		mineral_turf.drill_aoe(firer, 0.1)

	for(var/mob/living/living_mob in range(2, target) - firer - target)
		if(!ismining(living_mob))
			continue
		var/armor = living_mob.run_armor_check(def_zone, armor_flag, armour_penetration = armour_penetration)
		living_mob.apply_damage(damage, damage_type, def_zone, armor)
		to_chat(living_mob, span_userdanger("你被一个[name]击中了！"))

//Modkits
/obj/item/borg/upgrade/modkit
	name = "动能加速器改装套件"
	desc = "对动能加速器的升级。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "modkit"
	w_class = WEIGHT_CLASS_SMALL
	require_model = TRUE
	model_type = list(/obj/item/robot_model/miner)
	model_flags = BORG_MODEL_MINER
	//Most modkits are supposed to allow duplicates. The ones that don't should be blocked by PKA code anyways.
	allow_duplicates = TRUE
	// If defined with a type of mod, prevents paring this mod with another of the same mod in the same PKA
	var/denied_type = null
	// If defined, limits the number of a mod to this value in a single PKA. If denied_type is not defined. but this value is above 1, it will default to types of itself.
	var/maximum_of_type = 0
	var/cost = 30
	var/modifier = 1 //For use in any mod kit that has numerical modifiers
	var/minebot_upgrade = TRUE
	var/minebot_exclusive = FALSE
	/// Can it be removed?
	var/removable = TRUE

/obj/item/borg/upgrade/modkit/examine(mob/user)
	. = ..()
	. += span_notice("占用<b>[cost]%</b>的模组容量。")

/obj/item/borg/upgrade/modkit/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/gun/energy/recharge/kinetic_accelerator) && !issilicon(user))
		install(A, user)
	else
		return ..()

/obj/item/borg/upgrade/modkit/action(mob/living/silicon/robot/R)
	. = ..()
	if (.)
		for(var/obj/item/gun/energy/recharge/kinetic_accelerator/cyborg/H in R.model.modules)
			return install(H, usr, FALSE)

/obj/item/borg/upgrade/modkit/proc/install(obj/item/gun/energy/recharge/kinetic_accelerator/KA, mob/user, transfer_to_loc = TRUE)
	. = TRUE
	if(minebot_upgrade)
		if(minebot_exclusive && !istype(KA.loc, /mob/living/basic/mining_drone))
			if (user)
				to_chat(user, span_notice("你尝试安装的模组套件仅适用于矿用机器人。"))
			return FALSE
	else if(istype(KA.loc, /mob/living/basic/mining_drone))
		if (user)
			to_chat(user, span_notice("你尝试安装的模组套件不适用于矿用机器人。"))
		return FALSE

	var/type_to_limit = denied_type

	if(!type_to_limit && maximum_of_type)
		type_to_limit = src

	if(type_to_limit)
		var/number_of_denied = 0
		for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in KA.modkits)
			if(istype(modkit_upgrade, type_to_limit))
				number_of_denied++
			if(maximum_of_type && number_of_denied >= maximum_of_type || !maximum_of_type && number_of_denied) //if we denied a type, or we have a maximum to reach, break
				if (user)
					to_chat(user, span_notice("你尝试安装的模组套件会与已安装的模组套件冲突。请先移除现有模组套件。"))
				return FALSE

	if(KA.get_remaining_mod_capacity() < cost)
		to_chat(user, span_notice("你没有足够的空间（剩余<b>[KA.get_remaining_mod_capacity()]%</b>，需要[cost]%）来安装此模组套件。使用撬棍或空手右键点击以移除现有模组套件。"))
		return FALSE

	if(transfer_to_loc)
		if (user && !user.transferItemToLoc(src, KA))
			return FALSE
		else if (!user)
			forceMove(KA)

	if (user)
		to_chat(user, span_notice("你安装了模组套件。"))
		playsound(loc, 'sound/items/tools/screwdriver.ogg', 100, TRUE)
	KA.modkits |= src

/obj/item/borg/upgrade/modkit/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/gun/energy/recharge/kinetic_accelerator/cyborg/KA in R.model.modules)
			uninstall(KA)

/obj/item/borg/upgrade/modkit/proc/uninstall(obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	KA.modkits -= src

/obj/item/borg/upgrade/modkit/proc/modify_projectile(obj/projectile/kinetic/K)

//use this one for effects you want to trigger before any damage is done at all and before damage is decreased by pressure
/obj/item/borg/upgrade/modkit/proc/projectile_prehit(obj/projectile/kinetic/K, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)
//use this one for effects you want to trigger before mods that do damage
/obj/item/borg/upgrade/modkit/proc/projectile_strike_predamage(obj/projectile/kinetic/K, turf/target_turf, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)
//and this one for things that don't need to trigger before other damage-dealing mods
/obj/item/borg/upgrade/modkit/proc/projectile_strike(obj/projectile/kinetic/K, turf/target_turf, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)

//Range
/obj/item/borg/upgrade/modkit/range
	name = "射程提升模块"
	desc = "安装后可扩大动能加速器的覆盖范围。"
	modifier = 1
	cost = 25

/obj/item/borg/upgrade/modkit/range/modify_projectile(obj/projectile/kinetic/K)
	K.range += modifier


//Damage
/obj/item/borg/upgrade/modkit/damage
	name = "伤害提升模块"
	desc = "安装后可增强动能加速器的攻击力。"
	modifier = 10

/obj/item/borg/upgrade/modkit/damage/modify_projectile(obj/projectile/kinetic/K)
	K.damage += modifier


//Cooldown
/obj/item/borg/upgrade/modkit/cooldown
	name = "冷却时间减少模块"
	desc = "降低动能加速器的冷却时间。不适用于矿工机器人使用。"
	modifier = 3.2
	minebot_upgrade = FALSE

// Recalculate recharge time after adding or removing cooldown mods.
/obj/item/borg/upgrade/modkit/cooldown/proc/get_recharge_time(obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	var/new_recharge_time = initial(KA.recharge_time)
	for(var/obj/item/borg/upgrade/modkit/modkit_upgrade as anything in KA.modkits)
		if(istype(modkit_upgrade, src))
			new_recharge_time -= modifier

	return new_recharge_time

/obj/item/borg/upgrade/modkit/cooldown/install(obj/item/gun/energy/recharge/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(.)
		KA.recharge_time = get_recharge_time(KA)

/obj/item/borg/upgrade/modkit/cooldown/uninstall(obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	..()
	KA.recharge_time = get_recharge_time(KA)

/obj/item/borg/upgrade/modkit/cooldown/minebot
	name = "矿工机器人冷却时间减少"
	desc = "降低动能加速器的冷却时间。仅适用于矿工机器人使用。"
	icon_state = "door_electronics"
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	denied_type = /obj/item/borg/upgrade/modkit/cooldown/minebot
	modifier = 10
	cost = 0
	minebot_upgrade = TRUE
	minebot_exclusive = TRUE

// AoE blasts
// These are a subtype of cooldown so they can affect firing speed
/obj/item/borg/upgrade/modkit/cooldown/aoe
	modifier = 0
	cost = 10
	denied_type = /obj/item/borg/upgrade/modkit/cooldown/aoe
	maximum_of_type = 1
	/// Does the AOE mine turfs?
	var/turf_aoe = FALSE
	/// Have we taken another kit's AOE?
	var/stats_stolen = FALSE
	/// Multiplier for mob damage
	var/damage_modifier = 0

/obj/item/borg/upgrade/modkit/cooldown/aoe/install(obj/item/gun/energy/recharge/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(!.)
		return
	for(var/obj/item/borg/upgrade/modkit/cooldown/aoe/AOE in KA.modkits) //make sure only one of the aoe modules has values if somebody has multiple
		if(AOE.stats_stolen || AOE == src)
			continue
		modifier += AOE.modifier //take its modifiers
		damage_modifier += AOE.damage_modifier
		AOE.modifier = 0
		AOE.damage_modifier = 0
		turf_aoe += AOE.turf_aoe
		AOE.turf_aoe = FALSE
		AOE.stats_stolen = TRUE

/obj/item/borg/upgrade/modkit/cooldown/aoe/uninstall(obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	..()
	modifier = initial(modifier) //get our modifiers back
	damage_modifier = initial(damage_modifier)
	turf_aoe = initial(turf_aoe)
	stats_stolen = FALSE

/obj/item/borg/upgrade/modkit/cooldown/aoe/modify_projectile(obj/projectile/kinetic/K)
	K.name = "动能爆炸模块"

/obj/item/borg/upgrade/modkit/cooldown/aoe/projectile_strike(obj/projectile/kinetic/kinetic_blast, turf/target_turf, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	if(stats_stolen)
		return
	new /obj/effect/temp_visual/explosion/fast(target_turf)
	if(turf_aoe)
		for(var/T in RANGE_TURFS(1, target_turf) - target_turf)
			if(ismineralturf(T))
				var/turf/closed/mineral/M = T
				M.gets_drilled(kinetic_blast.firer, 0.1)

	if(!damage_modifier)
		return

	for(var/mob/living/living_mob in range(1, target) - kinetic_blast.firer - target)
		if(!ismining(living_mob))
			continue
		var/armor = living_mob.run_armor_check(kinetic_blast.def_zone, kinetic_blast.armor_flag, armour_penetration = kinetic_blast.armour_penetration)
		living_mob.apply_damage(kinetic_blast.damage * damage_modifier, kinetic_blast.damage_type, kinetic_blast.def_zone, armor)
		to_chat(living_mob, span_userdanger("你被[kinetic_blast.name]击中了！"))

/obj/item/borg/upgrade/modkit/cooldown/aoe/turfs
	name = "采矿爆炸"
	desc = "使动能加速器破坏范围内的岩石。"
	turf_aoe = TRUE
	// Negates one CD modifier
	modifier = -/obj/item/borg/upgrade/modkit/cooldown::modifier

/obj/item/borg/upgrade/modkit/cooldown/aoe/mobs
	name = "攻击性爆炸"
	desc = "会使动能加速器对范围内的怪物造成伤害。"
	damage_modifier = 1

/obj/item/borg/upgrade/modkit/cooldown/aoe/mobs/andturfs
	name = "攻击性采矿爆炸"
	desc = "使动能加速器破坏岩石和伤害范围内的生物。"
	turf_aoe = TRUE
	modifier = -1 // Slightly better than normal turf AOE as its a rare find

// Minebot passthrough
/obj/item/borg/upgrade/modkit/minebot_passthrough
	name = "矿工机器人穿透"
	desc = "使动能加速器射击穿过机器人。"
	denied_type = /obj/item/borg/upgrade/modkit/human_passthrough
	cost = 0

/obj/item/borg/upgrade/modkit/minebot_passthrough/install(obj/item/gun/energy/recharge/kinetic_accelerator/KA, mob/user, transfer_to_loc)
	. = ..()
	LAZYADD(KA.ignored_mob_types, typecacheof(/mob/living/basic/mining_drone))

/obj/item/borg/upgrade/modkit/minebot_passthrough/uninstall(obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	. = ..()
	LAZYREMOVE(KA.ignored_mob_types, typecacheof(/mob/living/basic/mining_drone))

/obj/item/borg/upgrade/modkit/human_passthrough
	name = "人体穿透"
	desc = "使动能加速器射弹能够穿透人体，有助于防止友军误伤。"
	denied_type = /obj/item/borg/upgrade/modkit/minebot_passthrough
	cost = 0

/obj/item/borg/upgrade/modkit/human_passthrough/install(obj/item/gun/energy/recharge/kinetic_accelerator/KA, mob/user, transfer_to_loc)
	. = ..()
	LAZYADD(KA.ignored_mob_types, typecacheof(/mob/living/carbon/human))

/obj/item/borg/upgrade/modkit/human_passthrough/uninstall(obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	. = ..()
	LAZYREMOVE(KA.ignored_mob_types, typecacheof(/mob/living/carbon/human))

//Tendril-unique modules
/obj/item/borg/upgrade/modkit/cooldown/repeater
	name = "快速蓄能"
	desc = "缩短了动能加速器攻击活体目标时的冷却时间，但同时大幅延长了其基础冷却时间。"
	denied_type = /obj/item/borg/upgrade/modkit/cooldown/repeater
	modifier = -14 //Makes the cooldown 3 seconds(with no cooldown mods) if you miss. Don't miss.
	cost = 50

/obj/item/borg/upgrade/modkit/cooldown/repeater/projectile_strike_predamage(obj/projectile/kinetic/K, turf/target_turf, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	var/valid_repeat = FALSE
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			valid_repeat = TRUE
	if(ismineralturf(target_turf))
		valid_repeat = TRUE
	if(valid_repeat)
		KA.cell.use(KA.cell.charge)
		KA.attempt_reload(KA.recharge_time * 0.25) //If you hit, the cooldown drops to 0.75 seconds.

/obj/item/borg/upgrade/modkit/cooldown/repeater/bdm
	name = "infernal repeater"
	removable = FALSE
	cost = 30
	modifier = -10

/obj/item/borg/upgrade/modkit/lifesteal
	name = "生命盗取晶体"
	desc = "使动能加速射击在击中活目标时轻微治疗射击者。"
	icon_state = "modkit_crystal"
	modifier = 2.5 //Not a very effective method of healing.
	cost = 20
	var/static/list/damage_heal_order = list(BRUTE, BURN, OXY)

/obj/item/borg/upgrade/modkit/lifesteal/projectile_prehit(obj/projectile/kinetic/K, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	if(isliving(target) && isliving(K.firer))
		var/mob/living/L = target
		if(L.stat == DEAD)
			return
		L = K.firer
		L.heal_ordered_damage(modifier, damage_heal_order)

/obj/item/borg/upgrade/modkit/resonator_blasts
	name = "谐振器爆炸"
	desc = "使动能加速器炮发射并引爆共振炮弹。"
	denied_type = /obj/item/borg/upgrade/modkit/resonator_blasts
	cost = 30
	modifier = 0.25 //A bonus 15 damage if you burst the field on a target, 60 if you lure them into it.

/obj/item/borg/upgrade/modkit/resonator_blasts/projectile_strike(obj/projectile/kinetic/K, turf/target_turf, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	if(target_turf && !ismineralturf(target_turf)) //Don't make fields on mineral turfs.
		var/obj/effect/temp_visual/resonance/R = locate(/obj/effect/temp_visual/resonance) in target_turf
		if(R)
			R.damage_multiplier = modifier
			R.burst()
			return
		new /obj/effect/temp_visual/resonance(target_turf, K.firer, null, RESONATOR_MODE_MANUAL, 100) //manual detonate mode and will NOT spread

/obj/item/borg/upgrade/modkit/bounty
	name = "死亡虹吸"
	desc = "杀害或协助杀害某种生物会永久性地提高你对该种生物的攻击力。"
	denied_type = /obj/item/borg/upgrade/modkit/bounty
	modifier = 1.25
	cost = 30
	var/maximum_bounty = 25
	var/list/bounties_reaped = list()

/obj/item/borg/upgrade/modkit/bounty/projectile_prehit(obj/projectile/kinetic/K, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	if(isliving(target))
		var/mob/living/L = target
		var/list/existing_marks = L.has_status_effect_list(/datum/status_effect/syphon_mark)
		for(var/i in existing_marks)
			var/datum/status_effect/syphon_mark/SM = i
			if(SM.reward_target == src) //we want to allow multiple people with bounty modkits to use them, but we need to replace our own marks so we don't multi-reward
				SM.reward_target = null
				qdel(SM)
		L.apply_status_effect(/datum/status_effect/syphon_mark, src)

/obj/item/borg/upgrade/modkit/bounty/projectile_strike(obj/projectile/kinetic/K, turf/target_turf, atom/target, obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	if(isliving(target))
		var/mob/living/L = target
		if(bounties_reaped[L.type])
			var/kill_modifier = 1
			if(K.pressure_decrease_active)
				kill_modifier *= K.pressure_decrease
			var/armor = L.run_armor_check(K.def_zone, K.armor_flag, "", "", K.armour_penetration)
			L.apply_damage(bounties_reaped[L.type]*kill_modifier, K.damage_type, K.def_zone, armor)

/obj/item/borg/upgrade/modkit/bounty/proc/get_kill(mob/living/L)
	var/bonus_mod = 1
	if(ismegafauna(L)) //megafauna reward
		bonus_mod = 4
	if(!bounties_reaped[L.type])
		bounties_reaped[L.type] = min(modifier * bonus_mod, maximum_bounty)
	else
		bounties_reaped[L.type] = min(bounties_reaped[L.type] + (modifier * bonus_mod), maximum_bounty)

//Indoors
/obj/item/borg/upgrade/modkit/indoors
	name = "降低压力惩罚"
	desc = "一个辛迪加改装套件，能提升动能加速器在高压环境下的伤害。"
	modifier = 2
	maximum_of_type = 2
	cost = 35

/obj/item/borg/upgrade/modkit/indoors/modify_projectile(obj/projectile/kinetic/K)
	K.pressure_decrease *= modifier


//Trigger Guard
/obj/item/borg/upgrade/modkit/trigger_guard
	name = "改进型扳机护卫"
	desc = "允许通常无法使用枪械的生物在安装后操作武器。"
	cost = 20
	denied_type = /obj/item/borg/upgrade/modkit/trigger_guard

/obj/item/borg/upgrade/modkit/trigger_guard/install(obj/item/gun/energy/recharge/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(.)
		KA.trigger_guard = TRIGGER_GUARD_ALLOW_ALL

/obj/item/borg/upgrade/modkit/trigger_guard/uninstall(obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	KA.trigger_guard = TRIGGER_GUARD_NORMAL
	..()


//Cosmetic

/obj/item/borg/upgrade/modkit/chassis_mod
	name = "超级底盘"
	desc = "使你的KA变黄。拥有一个更强大的KA而不是真正拥有一个更强大的KA的乐趣。"
	cost = 0
	denied_type = /obj/item/borg/upgrade/modkit/chassis_mod
	var/chassis_icon = "kineticgun_u"
	var/chassis_name = "super-kinetic accelerator"

/obj/item/borg/upgrade/modkit/chassis_mod/install(obj/item/gun/energy/recharge/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(.)
		KA.icon_state = chassis_icon
		KA.inhand_icon_state = chassis_icon
		KA.name = chassis_name
		if(iscarbon(KA.loc))
			var/mob/living/carbon/holder = KA.loc
			holder.update_held_items()

/obj/item/borg/upgrade/modkit/chassis_mod/uninstall(obj/item/gun/energy/recharge/kinetic_accelerator/KA)
	KA.icon_state = initial(KA.icon_state)
	KA.inhand_icon_state = initial(KA.inhand_icon_state)
	KA.name = initial(KA.name)
	if(iscarbon(KA.loc))
		var/mob/living/carbon/holder = KA.loc
		holder.update_held_items()
	..()

/obj/item/borg/upgrade/modkit/chassis_mod/orange
	name = "高底盘"
	desc = "让你的KA变成橙色。在没有爆炸的情况下进行爆炸的所有乐趣。"
	chassis_icon = "kineticgun_h"
	chassis_name = "hyper-kinetic accelerator"

/obj/item/borg/upgrade/modkit/tracer
	name = "白色示踪螺栓"
	desc = "使动能加速器螺栓产生白色的发光痕迹并引发爆炸。"
	cost = 0
	denied_type = /obj/item/borg/upgrade/modkit/tracer
	var/bolt_color = COLOR_WHITE

/obj/item/borg/upgrade/modkit/tracer/modify_projectile(obj/projectile/kinetic/K)
	K.icon_state = "ka_tracer"
	K.color = bolt_color

/obj/item/borg/upgrade/modkit/tracer/adjustable
	name = "可调节的示踪螺栓"
	desc = "使动能加速器螺栓产生可调节颜色的示踪轨迹和爆炸效果。通过手柄可改变颜色。"

/obj/item/borg/upgrade/modkit/tracer/adjustable/interact(mob/user)
	..()
	choose_bolt_color(user)

/obj/item/borg/upgrade/modkit/tracer/adjustable/proc/choose_bolt_color(mob/user)
	set waitfor = FALSE

	var/new_color = tgui_color_picker(user, "", "Choose Color", bolt_color)
	bolt_color = new_color || bolt_color
