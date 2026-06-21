//Mounted guns are basically a smaller equivalent to cannons, designed to use pre-existing ammo rather than cannonballs.
//Due to using pre-existing ammo, they dont require to be loaded with gunpowder or an equivalent.

/obj/structure/mounted_gun
	name = "架设式火炮"
	desc = "用于继承目的的默认架设式火炮。"
	density = TRUE
	anchored = FALSE
	icon = 'icons/obj/weapons/cannons.dmi'
	icon_state = "falconet_patina"
	base_icon_state = "falconet_patina"
	max_integrity = 300
	/// Suffix added to base icon state when firing
	var/fire_suffix = "_fire"
	/// whether the cannon can be unwrenched from the ground. Anchorable_cannon equivalent.
	var/anchorable_gun = TRUE
	/// Max shots per firing of the gun.
	var/max_shots_per_fire = 1
	/// Delay it takes to load the gun. Set to 0 if none.
	var/load_delay = 0 SECONDS
	/// Message displayed when loading gun
	var/loading_message = "gun loaded"
	/// Shots currently loaded. Should never be more than max_shots_per_fire.
	var/shots_in_gun = 1
	/// Shots added to gun, per piece of ammo loaded.
	var/shots_per_load = 1
	/// Things you can load into the gun
	var/list/accepted_ammo_types = list(/obj/item/ammo_casing/strilka310)
	/// Projectile to fire
	var/projectile_type = /obj/projectile/bullet/strilka310
	/// Delay in firing the gun after lighting
	var/fire_delay = 5 DECISECONDS
	/// Delay between shots
	var/shot_delay = 3 DECISECONDS
	/// If the gun shakes the camera when firing
	var/firing_shakes_camera = TRUE
	/// Sound of firing for all but last shot
	var/fire_sound = 'sound/items/weapons/gun/general/mountedgun.ogg'
	/// Sound of firing for last shot
	var/last_fire_sound = 'sound/items/weapons/gun/general/mountedgunend.ogg'
	/// So you can't reload it mid-firing
	var/is_firing = FALSE
	/// How many degrees to vary fire angle if the gun is not anchored
	var/unanchored_variance = 20
	/// What items to spawn when destroyed
	var/list/debris = list(
		/obj/item/stack/sheet/iron = 4,
		/obj/item/stack/rods = 3,
		/obj/item/assembly/igniter = 1,
	)

/obj/structure/mounted_gun/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/simple_rotation)
	register_context()

/obj/structure/mounted_gun/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(!isliving(user))
		return

	if(anchorable_gun && held_item?.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = anchored ? "Unanchor" : "Anchor"

	if(is_type_in_list(held_item, accepted_ammo_types))
		context[SCREENTIP_CONTEXT_LMB] = "Load weapon"

	if (!held_item)
		context[SCREENTIP_CONTEXT_LMB] = "Fire weapon"

	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/mounted_gun/update_icon_state()
	. = ..()
	icon_state = base_icon_state + (is_firing ? fire_suffix : "")

/obj/structure/mounted_gun/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!anchorable_gun) /// Can't anchor an unanchorable gun.
		return FALSE
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

///Covers Reloading and lighting of the gun
/obj/structure/mounted_gun/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode || !is_type_in_list(tool, accepted_ammo_types)) //see if the gun needs to be loaded in some way.
		return NONE

	if(is_firing)
		balloon_alert(user, "火炮开火！")
		return ITEM_INTERACT_BLOCKING

	var/fully_loaded = shots_in_gun >= max_shots_per_fire
	if(fully_loaded)
		balloon_alert(user, "已经装填！")
		return ITEM_INTERACT_BLOCKING

	if (load_delay > 0)
		user.visible_message(span_warning("[user] 开始装填 [src]。"))
		if(!do_after(user, load_delay, target = src))
			return ITEM_INTERACT_BLOCKING

	shots_in_gun = min(shots_in_gun + shots_per_load, max_shots_per_fire)
	balloon_alert(user, loading_message)
	QDEL_NULL(tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/mounted_gun/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if (.)
		return
	if (is_firing)
		balloon_alert(user, "火炮开火！")
		return
	try_firing(user)

/// Start firing the weapon on interaction
/obj/structure/mounted_gun/proc/try_firing(mob/living/user)
	user.log_message("fired a [initial(name)]", LOG_ATTACK)
	addtimer(CALLBACK(src, PROC_REF(fire_sequence), user), fire_delay)

/// Loop firing until we are done
/obj/structure/mounted_gun/proc/fire_sequence(mob/living/user)
	if (!shots_in_gun)
		balloon_alert(user, "未装填！")
		return

	is_firing = TRUE
	update_appearance(UPDATE_ICON_STATE)

	var/delay = 0
	while (shots_in_gun > 0)
		shots_in_gun--
		addtimer(CALLBACK(src, PROC_REF(fire_loop), user), delay, TIMER_DELETE_ME)
		if (shots_in_gun == 0)
			addtimer(CALLBACK(src, PROC_REF(finish_firing)), delay, TIMER_DELETE_ME)
		else
			delay += time_until_next_shot()

/// Called when we run out of bullets
/obj/structure/mounted_gun/proc/finish_firing()
	is_firing = FALSE
	update_appearance(UPDATE_ICON_STATE)

/// Return
/obj/structure/mounted_gun/proc/time_until_next_shot()
	return shot_delay

/obj/structure/mounted_gun/atom_deconstruct(disassembled = TRUE)
	. = ..()
	dump_contents()
	var/droploc = drop_location()
	for (var/type in debris)
		if(ispath(type, /obj/item/stack))
			new type(droploc, debris[type])
			continue
		for (var/i in 1 to debris[type])
			new type(droploc)

/obj/structure/mounted_gun/dump_contents()
	return // Generally we don't have contents to dump but some children do.

/// Perform the contents of the loop, return the amount of time until the next shot
/obj/structure/mounted_gun/proc/fire_loop(mob/living/user)
	for(var/mob/shaken_mob in urange(3, src))
		if(shaken_mob.stat == CONSCIOUS && firing_shakes_camera) //is the mob awake to feel the shaking?
			shake_camera(shaken_mob, 3, 1)
	playsound(src, shots_in_gun > 0 ? fire_sound : last_fire_sound, vol = 50, vary = FALSE, falloff_exponent = 5)
	fire_gun(user)

/// Actually finally shoot the thing
/obj/structure/mounted_gun/proc/fire_gun(mob/living/user)
	var/obj/projectile/fired_projectile = get_fired_projectile()
	fired_projectile.firer = user
	fired_projectile.fired_from = src
	var/fire_angle = dir2angle(dir) + (!anchorable_gun || anchored ? 0 : rand(-unanchored_variance, unanchored_variance))
	fired_projectile.fire(fire_angle)
	return fired_projectile

/// What kind of ammo are we shooting
/obj/structure/mounted_gun/proc/get_fired_projectile()
	return new projectile_type(get_turf(src))

/// Rapidly fires a barrage of random junk ammo
/obj/structure/mounted_gun/organ_gun
	name = "管风琴火炮"
	desc = "要成为杀戮者的主宰，就必须成为更优秀的杀手。这台毁灭引擎正是为此目的制造的众多事物之一。"
	icon_state = "pipeorgangun"
	base_icon_state = "pipeorgangun"
	anchored = FALSE
	max_shots_per_fire = 8
	shots_in_gun = 8
	shots_per_load = 2
	accepted_ammo_types = list(/obj/item/ammo_casing/junk)
	projectile_type = /obj/projectile/bullet/junk
	fire_delay = 3 DECISECONDS
	shot_delay = 2 DECISECONDS
	firing_shakes_camera = FALSE
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 24.5,
		/datum/material/wood = SHEET_MATERIAL_AMOUNT * 15,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT
	)
	debris = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/mineral/wood = 3,
		/obj/item/storage/toolbox = 1,
		/obj/item/stack/rods = 4,
		/obj/item/assembly/igniter = 1,
	)
	/// Different kinds of bullet we can fire
	var/static/list_of_projectiles = list(
		/obj/projectile/bullet/junk = 40,
		/obj/projectile/bullet/incendiary/fire/junk = 25,
		/obj/projectile/bullet/junk/shock = 25,
		/obj/projectile/bullet/junk/hunter = 20,
		/obj/projectile/bullet/junk/phasic = 8,
		/obj/projectile/bullet/junk/ripper = 8,
		/obj/projectile/bullet/junk/reaper = 3,
	)

/obj/structure/mounted_gun/organ_gun/examine_more(mob/user)
	. = ..()
	. += span_notice("<b><i>低头看着 \the [src]，你回忆起某个遥远记忆里听到的故事...</i></b>")

	. += span_info("实施复仇之举，无异于与魔鬼订立血契，以自身为代价终结他人性命。")
	. += span_info("当人类首次用可能不过是石块的东西，染上同类的鲜血时，封印便被打破。复仇由此降临世间。")
	. += span_info("然而，仅凭复仇不足以完成谋杀这一冷酷行径。必须获得超越对手的优势。")
	. += span_info("因此，用石头终结他人性命者，终将死于持矛者之手。矛之后是弓。剑。枪。坦克。导弹。复仇不断吞噬，日益强大，日益恶化。")
	. += span_info("复仇延续至今。它有时或许会沉睡，看似满足于饱餐一顿，但最终，它那永无止境的饥渴既无法麻痹也无法满足。")

/obj/structure/mounted_gun/organ_gun/get_fired_projectile()
	var/random_type = pick_weight(list_of_projectiles)
	return new random_type(get_turf(src))

/// Rapidly sprays a large amount of bullets, used by pirates
/obj/structure/mounted_gun/canister_gatling
	name = "霰弹加特林炮"
	desc = "'数量本身就是一种质量。'"
	icon_state = "canister_gatling"
	base_icon_state = "canister_gatling"
	anchored = FALSE
	max_shots_per_fire = 50
	shots_per_load = 50
	shots_in_gun = 50
	accepted_ammo_types = list(/obj/item/ammo_casing/canister_shot)
	projectile_type = /obj/projectile/bullet/shrapnel
	fire_delay = 3 DECISECONDS
	shot_delay = 1 DECISECONDS
	firing_shakes_camera = FALSE
	debris = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/mineral/wood = 3,
		/obj/item/stack/rods = 4,
		/obj/item/assembly/igniter = 1,
	)

/obj/item/ammo_casing/canister_shot
	name = "霰弹"
	desc = "一个巨大的……嗯，霰弹罐。用于为霰弹加特林炮重新装填。"
	icon_state = "canister_shot"
	obj_flags = CONDUCTS_ELECTRICITY
	throwforce = 0
	w_class = WEIGHT_CLASS_BULKY
	projectile_type = /obj/projectile/bullet/shrapnel

/// Hand-cranked laser repeater which does not need to be reloaded
/obj/structure/mounted_gun/ratvarian_repeater
	name = "拉特瓦连发炮"
	desc = "'大脑？青铜？为何不兼得？'"
	icon_state = "ratvarian_repeater"
	base_icon_state = "ratvarian_repeater"
	loading_message = "gun charged"
	anchored = FALSE
	accepted_ammo_types = list() // We don't want any of that shit
	load_delay = 3 SECONDS
	max_shots_per_fire = 12
	shots_per_load = 12
	shots_in_gun = 12
	fire_sound = 'sound/items/weapons/thermalpistol.ogg'
	last_fire_sound = 'sound/items/weapons/thermalpistol.ogg'
	projectile_type = /obj/projectile/beam/laser/repeater
	fire_delay = 1
	shot_delay = 2
	firing_shakes_camera = FALSE
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5.25,
		/datum/material/bronze = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.29
	)
	debris = list(
		/obj/item/stack/cable_coil = 4,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/shard = 2,
		/obj/item/stack/sheet/bronze = 2,
		/obj/item/stack/rods = 3,
	)

/obj/structure/mounted_gun/ratvarian_repeater/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(!isliving(user))
		return

	if(anchorable_gun && held_item?.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = anchored ? "Unanchor" : "Anchor"

	if (!held_item)
		context[SCREENTIP_CONTEXT_LMB] = shots_in_gun >= max_shots_per_fire ? "Fire weapon" : "Crank weapon"

	return CONTEXTUAL_SCREENTIP_SET

// Charge the gun instead of firing it if it's not loaded
/obj/structure/mounted_gun/ratvarian_repeater/try_firing(mob/user)
	var/fully_loaded = shots_in_gun >= max_shots_per_fire
	if(fully_loaded)
		return ..()

	if (load_delay > 0)
		user.visible_message(span_warning("[user]开始给[src]上弦。"))
		if(!do_after(user, load_delay, target = src))
			return

	shots_in_gun = min(shots_in_gun + shots_per_load, max_shots_per_fire)
	playsound(src, 'sound/effects/magic/clockwork/fellowship_armory.ogg', 50, FALSE, 5)

/obj/structure/mounted_gun/ratvarian_repeater/time_until_next_shot()
	return shots_in_gun % 2 != 1 ? shot_delay * 2 : shot_delay

/// A makeshift structure for firing spears with increased force
/obj/structure/mounted_gun/ballista
	name = "简易弩炮"
	desc = "'工程师喜欢解决问题。如果没有现成的问题，他们就会自己制造问题。'"
	icon_state = "improvised_ballista"
	base_icon_state = "improvised_ballista"
	throwforce = 30
	anchored = FALSE
	load_delay = 6 SECONDS
	max_shots_per_fire = 1
	shots_per_load = 1
	shots_in_gun = 0
	fire_sound = 'sound/items/xbow_lock.ogg'
	last_fire_sound = 'sound/items/xbow_lock.ogg'
	accepted_ammo_types = list(
		/obj/item/brass_spear,
		/obj/item/melee/baton/security/cattleprod,
		/obj/item/nullrod/spear,
		/obj/item/spear,
	)
	projectile_type = /obj/projectile/bullet/ballista_spear
	fire_delay = 1
	shot_delay = 1
	firing_shakes_camera = FALSE
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 15.15,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.5
	)
	debris = list(
		/obj/item/stack/cable_coil = 3,
		/obj/item/stack/sheet/iron = 2,
		/obj/item/stack/rods = 3,
	)
	/// What spear has someone put in us?
	var/obj/item/loaded_spear

/obj/structure/mounted_gun/ballista/update_icon_state()
	. = ..()
	if (loaded_spear)
		icon_state = base_icon_state + (istype(loaded_spear, /obj/item/melee/baton/security/cattleprod) ? "_loaded_prod" : "_loaded")
	else
		icon_state = base_icon_state

/obj/structure/mounted_gun/ballista/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!is_type_in_list(tool, accepted_ammo_types) || user.combat_mode)
		return NONE

	if(is_firing)
		balloon_alert(user, "火炮开火！")
		return ITEM_INTERACT_BLOCKING

	if(loaded_spear)
		balloon_alert(user, "已经装填！")
		return ITEM_INTERACT_BLOCKING

	playsound(src, 'sound/items/weapons/draw_bow.ogg', 50, FALSE, 5)
	if (load_delay > 0)
		user.visible_message(span_warning("[user]开始为[src]装填。"))
		if (!do_after(user, load_delay, target = src))
			return ITEM_INTERACT_BLOCKING

	shots_in_gun = 1

	loaded_spear = tool
	loaded_spear.forceMove(src)
	update_appearance(UPDATE_ICON_STATE)
	RegisterSignals(loaded_spear, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING), PROC_REF(on_spear_left))
	return ITEM_INTERACT_SUCCESS

/obj/structure/mounted_gun/ballista/get_fired_projectile()
	if (istype(loaded_spear, /obj/item/spear/dragonator))
		return new /obj/projectile/bullet/ballista_spear/dragonator(get_turf(src))
	if (istype(loaded_spear, /obj/item/melee/baton/security/cattleprod))
		return new /obj/projectile/bullet/ballista_spear/prod(get_turf(src))
	return ..()

/obj/structure/mounted_gun/ballista/fire_gun(mob/living/user)
	var/obj/projectile/bullet/ballista_spear/fired_projectile = . = ..()
	fired_projectile.attach_spear(loaded_spear)

/// Called when our spear is not inside us any more
/obj/structure/mounted_gun/ballista/proc/on_spear_left()
	SIGNAL_HANDLER
	UnregisterSignal(loaded_spear, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	shots_in_gun = 0
	loaded_spear = null
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/mounted_gun/ballista/dump_contents()
	. = ..()
	loaded_spear?.forceMove(drop_location())
