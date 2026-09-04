// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define TUMOR_INACTIVE 0
#define TUMOR_ACTIVE 1
#define TUMOR_PASSIVE 2

// Makes the elite mob weaker on victory so they don't just go and trash the station with a dangerous, big health pool
#define ELITE_POST_BATTLE_HEALTH_MULTIPLIER 0.4

//Elite mining mobs
/mob/living/simple_animal/hostile/asteroid/elite
	name = "elite"
	desc = "An elite monster, found in one of the strange tumors on lavaland."
	icon = 'icons/mob/simple/lavaland/lavaland_elites.dmi'
	abstract_type = /mob/living/simple_animal/hostile/asteroid/elite
	faction = list(FACTION_MINING, FACTION_BOSS)
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	ranged = TRUE
	obj_damage = 30
	vision_range = 6
	aggro_vision_range = 18
	environment_smash = ENVIRONMENT_SMASH_NONE  //This is to prevent elites smashing up the mining station (entirely), we'll make sure they can smash minerals fine below.
	harm_intent_damage = 0 //Punching elites gets you nowhere
	stat_attack = HARD_CRIT
	layer = LARGE_MOB_LAYER
	sentience_type = SENTIENCE_BOSS
	var/chosen_attack = 1
	var/list/attack_action_types = list()
	var/can_talk = FALSE
	var/obj/loot_drop = null

//Gives player-controlled variants the ability to swap attacks
/mob/living/simple_animal/hostile/asteroid/elite/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seethrough_mob)
	grant_actions_by_list(attack_action_types)
	ADD_TRAIT(src, TRAIT_UNCONVERTABLE, INNATE_TRAIT) //You cannot convert them while they're battling.

//Prevents elites from attacking members of their faction (can't hurt themselves either) and lets them mine rock with an attack despite not being able to smash walls.
/mob/living/simple_animal/hostile/asteroid/elite/AttackingTarget(atom/attacked_target)
	if(ishostile(target))
		var/mob/living/simple_animal/hostile/M = target
		if(faction_check_atom(M))
			return FALSE
	if(istype(target, /obj/structure/elite_tumor))
		var/obj/structure/elite_tumor/T = target
		if(T.mychild == src && T.activity == TUMOR_PASSIVE)
			var/elite_remove = tgui_alert(usr,LANG("mob.a3870d5598fa61ed", null), LANG("mob.7f0885e7c8c8a39b", null), list("Yes", "No"))
			if(elite_remove == "No" || QDELETED(src) || !Adjacent(T))
				return
			T.mychild = null
			T.activity = TUMOR_INACTIVE
			T.icon_state = "advanced_tumor"
			qdel(src)
			return FALSE
	. = ..()
	if(ismineralturf(target))
		var/turf/closed/mineral/M = target
		M.gets_drilled()
	if(ismecha(target))
		var/obj/vehicle/sealed/mecha/M = target
		M.take_damage(50, BRUTE, MELEE, 1)

//Elites can't talk (normally)!
/mob/living/simple_animal/hostile/asteroid/elite/can_speak(allow_mimes)
	return can_talk && ..()

/*Basic setup for elite attacks, based on Whoneedspace's megafauna attack setup.
While using this makes the system rely on OnFire, it still gives options for timers not tied to OnFire, and it makes using attacks consistent accross the board for player-controlled elites.*/

/datum/action/innate/elite_attack
	name = "Elite Attack"
	button_icon = 'icons/mob/actions/actions_elites.dmi'
	button_icon_state = ""
	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"
	///The displayed message into chat when this attack is selected
	var/chosen_message
	///The internal attack ID for the elite's OpenFire() proc to use
	var/chosen_attack_num = 0

/datum/action/innate/elite_attack/create_button(mob/viewer)
	var/atom/movable/screen/movable/action_button/button = ..()
	button.maptext = ""
	button.maptext_x = 6
	button.maptext_y = 2
	button.maptext_width = 24
	button.maptext_height = 12
	return button

/datum/action/innate/elite_attack/process()
	if(isnull(owner))
		STOP_PROCESSING(SSfastprocess, src)
		qdel(src)
		return

	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/innate/elite_attack/update_button_status(atom/movable/screen/movable/action_button/button, force = FALSE)
	var/mob/living/simple_animal/hostile/asteroid/elite/elite_owner = owner
	if(!istype(owner))
		button.maptext = ""
		return

	var/timeleft = max(elite_owner.ranged_cooldown - world.time, 0)
	if(timeleft == 0)
		button.maptext = ""
	else
		button.maptext = MAPTEXT("<b>[round(timeleft/10, 0.1)]</b>")

/datum/action/innate/elite_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/asteroid/elite))
		START_PROCESSING(SSfastprocess, src)
		return ..()
	return FALSE

/datum/action/innate/elite_attack/Activate()
	var/mob/living/simple_animal/hostile/asteroid/elite/elite_owner = owner
	elite_owner.chosen_attack = chosen_attack_num
	to_chat(elite_owner, chosen_message)

//The Pulsing Tumor, the actual "spawn-point" of elites, handles the spawning, arena, and procs for dealing with basic scenarios.

/obj/structure/elite_tumor
	name = "pulsing tumor"
	desc = "An odd, pulsing tumor sticking out of the ground.  You feel compelled to reach out and touch it..."
	armor_type = /datum/armor/structure_elite_tumor
	resistance_flags = INDESTRUCTIBLE
	icon = 'icons/obj/mining_zones/tumor.dmi'
	icon_state = "tumor"
	pixel_x = -16
	base_pixel_x = -16
	light_color = "#FA8282"
	light_range = 3
	anchored = TRUE
	density = FALSE
	var/activity = TUMOR_INACTIVE
	var/boosted = FALSE
	var/times_won = 0
	var/mob/living/carbon/human/activator
	var/mob/living/simple_animal/hostile/asteroid/elite/mychild = null
	///List of all potentially spawned elites
	var/potentialspawns = list(
		/mob/living/simple_animal/hostile/asteroid/elite/broodmother,
		/mob/living/simple_animal/hostile/asteroid/elite/pandora,
		/mob/living/simple_animal/hostile/asteroid/elite/legionnaire,
		/mob/living/simple_animal/hostile/asteroid/elite/herald,
	)

/datum/armor/structure_elite_tumor
	melee = 100
	bullet = 100
	laser = 100
	energy = 100
	bomb = 100
	bio = 100
	fire = 100
	acid = 100

/obj/structure/elite_tumor/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(!ishuman(user))
		return
	switch(activity)
		if(TUMOR_PASSIVE)
			// Prevents the user from being forcemoved back and forth between two elite arenas.
			if(HAS_TRAIT(user, TRAIT_ELITE_CHALLENGER))
				user.visible_message(span_warning(LANG("obj.49ac9177d92f8559", list(user, src, user.p_their()))),
					span_warning(LANG("obj.6fd67fc8e19273a7", list(src))))
				return
			activity = TUMOR_ACTIVE
			user.visible_message(span_boldwarning(LANG("obj.a942aaeeabdae251", list(src, user))),
				span_boldwarning(LANG("obj.daace54ef0f0bd79", list(src))))
			make_activator(user)
			if(boosted)
				mychild.playsound_local(get_turf(mychild), 'sound/effects/magic.ogg', 40, 0)
				to_chat(mychild, LANG("obj.64a9683da25d0d4d", null))
			addtimer(CALLBACK(src, PROC_REF(return_elite)), 3 SECONDS)
			INVOKE_ASYNC(src, PROC_REF(arena_checks))
		if(TUMOR_INACTIVE)
			if(HAS_TRAIT(user, TRAIT_ELITE_CHALLENGER))
				user.visible_message(span_warning(LANG("obj.49ac9177d92f8559", list(user, src, user.p_their()))),
					span_warning(LANG("obj.6fd67fc8e19273a7", list(src))))
				return
			activity = TUMOR_ACTIVE
			var/mob/dead/observer/elitemind = null
			visible_message(span_boldwarning(LANG("obj.0ada0ace5a615629", list(src))))
			make_activator(user)
			if(!boosted)
				addtimer(CALLBACK(src, PROC_REF(spawn_elite)), 3 SECONDS)
				return
			visible_message(span_boldwarning(LANG("obj.db55f0e824049052", list(src))))
			var/mob/chosen_one = SSpolling.poll_ghosts_for_target(check_jobban = ROLE_SENTIENCE, role = ROLE_SENTIENCE, poll_time = 5 SECONDS, checked_target = src, ignore_category = POLL_IGNORE_LAVALAND_ELITE, alert_pic = src, role_name_text = "lavaland elite")
			if(chosen_one)
				audible_message(span_boldwarning(LANG("obj.df0676597d8a5de8", null)))
				elitemind = chosen_one
				elitemind.playsound_local(get_turf(elitemind), 'sound/effects/magic.ogg', 40, 0)
				to_chat(elitemind, LANG("obj.621d36fd84cbf1eb", null))
				addtimer(CALLBACK(src, PROC_REF(spawn_elite), elitemind), 10 SECONDS)
			else
				visible_message(span_boldwarning(LANG("obj.4a45436b3ec336ff", null)))
				activity = TUMOR_INACTIVE
				clear_activator(user)

/obj/structure/elite_tumor/proc/spawn_elite(mob/dead/observer/elitemind)
	var/selectedspawn = pick(potentialspawns)
	mychild = new selectedspawn(loc)
	visible_message(span_boldwarning(LANG("obj.8616ec7ef6eb4cb4", list(mychild, src))))
	playsound(loc,'sound/effects/phasein.ogg', 200, 0, 50, TRUE, TRUE)
	if(boosted)
		mychild.PossessByPlayer(elitemind.key)
		mychild.sentience_act()
		notify_ghosts(
			LANG("obj.f32ace3947f2a0eb", list(mychild, get_area(src))),
			source = mychild,
			header = "Lavaland Elite awakened",
			notify_flags = NOTIFY_CATEGORY_NOFLASH,
		)
	mychild.log_message("has been awakened by [key_name(activator)]!", LOG_GAME, color="#960000")
	icon_state = "tumor_popped"
	RegisterSignal(mychild, COMSIG_QDELETING, PROC_REF(onEliteLoss))
	INVOKE_ASYNC(src, PROC_REF(arena_checks))

/obj/structure/elite_tumor/proc/return_elite()
	mychild.forceMove(loc)
	visible_message(span_boldwarning(LANG("obj.8616ec7ef6eb4cb4", list(mychild, src))))
	playsound(loc,'sound/effects/phasein.ogg', 200, 0, 50, TRUE, TRUE)
	mychild.revive(HEAL_ALL)
	if(boosted)
		mychild.maxHealth *= 1 / ELITE_POST_BATTLE_HEALTH_MULTIPLIER //we multiply it back to its original value
		mychild.health = mychild.maxHealth
		notify_ghosts(
			LANG("obj.d9091c2cb5950c8d", list(mychild, get_area(src))),
			source = mychild,
			header = "Lavaland Elite challenged",
			notify_flags = NOTIFY_CATEGORY_NOFLASH,
		)
	mychild.log_message("has been challenged by [key_name(activator)]!", LOG_GAME, color="#960000")
	ADD_TRAIT(mychild, TRAIT_UNCONVERTABLE, INNATE_TRAIT)

/obj/structure/elite_tumor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps, "Menacing Signal")
	START_PROCESSING(SSobj, src)

/obj/structure/elite_tumor/Destroy()
	STOP_PROCESSING(SSobj, src)
	mychild = null
	clear_activator(activator)
	return ..()

/obj/structure/elite_tumor/proc/make_activator(mob/user)
	if(activator)
		return
	activator = user
	ADD_TRAIT(user, TRAIT_ELITE_CHALLENGER, REF(src))
	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(clear_activator))
	user.log_message("has activated an elite tumor!", LOG_GAME, color="#960000")

/obj/structure/elite_tumor/proc/clear_activator(mob/source)
	SIGNAL_HANDLER
	if(!activator)
		return
	activator = null
	REMOVE_TRAIT(source, TRAIT_ELITE_CHALLENGER, REF(src))
	UnregisterSignal(source, COMSIG_QDELETING)

/obj/structure/elite_tumor/process(seconds_per_tick)
	if(!isturf(loc))
		return

	for(var/mob/living/simple_animal/hostile/asteroid/elite/elitehere in loc)
		if(elitehere == mychild && activity == TUMOR_PASSIVE)
			mychild.adjust_brute_loss(-mychild.maxHealth * 0.025*seconds_per_tick)
			var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(mychild))
			H.color = COLOR_RED

/obj/structure/elite_tumor/item_interaction(mob/living/user, obj/item/attacking_item, list/modifiers)
	. = NONE
	if(istype(attacking_item, /obj/item/organ/monster_core/regenerative_core) && activity == TUMOR_INACTIVE && !boosted)
		var/obj/item/organ/monster_core/regenerative_core/core = attacking_item
		visible_message(span_boldwarning(LANG("obj.c37af7b71340ce57", list(user, src, src))))
		icon_state = "advanced_tumor"
		boosted = TRUE
		set_light_range(6)
		desc = LANG("obj.a3f1d5f93dddd403", list(desc))
		qdel(core)
		return ITEM_INTERACT_SUCCESS

/obj/structure/elite_tumor/proc/arena_checks()
	if(activity != TUMOR_ACTIVE || QDELETED(src))
		return
	INVOKE_ASYNC(src, PROC_REF(fighters_check))  //Checks to see if our fighters died.
	INVOKE_ASYNC(src, PROC_REF(arena_trap))  //Gets another arena trap queued up for when this one runs out.
	INVOKE_ASYNC(src, PROC_REF(border_check))  //Checks to see if our fighters got out of the arena somehow.
	if(!QDELETED(src))
		addtimer(CALLBACK(src, PROC_REF(arena_checks)), 5 SECONDS)

/obj/structure/elite_tumor/proc/fighters_check()
	if(QDELETED(mychild) || mychild.stat == DEAD)
		onEliteLoss()
		return
	if(QDELETED(activator) || activator.stat == DEAD || (activator.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(activator, TRAIT_NODEATH)))
		if(!QDELETED(activator) && HAS_TRAIT(activator, TRAIT_NODEATH)) // dust the unkillable activator
			activator.dust(drop_items = TRUE)
		onEliteWon()

/obj/structure/elite_tumor/proc/arena_trap()
	var/turf/tumor_turf = get_turf(src)
	if(loc == null)
		return
	var/datum/weakref/activator_ref = WEAKREF(activator)
	var/datum/weakref/mychild_ref = WEAKREF(mychild)
	for(var/tumor_range_turfs in RANGE_TURFS(12, tumor_turf))
		if(get_dist(tumor_range_turfs, tumor_turf) == 12)
			var/obj/effect/temp_visual/elite_tumor_wall/newwall
			newwall = new /obj/effect/temp_visual/elite_tumor_wall(tumor_range_turfs, src)
			newwall.activator_ref = activator_ref
			newwall.ourelite_ref = mychild_ref

/obj/structure/elite_tumor/proc/border_check()
	if(activator != null && get_dist(src, activator) >= 12)
		activator.forceMove(loc)
		visible_message(span_boldwarning(LANG("obj.5ba873c850bb5350", list(activator, src))))
		playsound(loc,'sound/effects/phasein.ogg', 200, 0, 50, TRUE, TRUE)
	if(mychild != null && get_dist(src, mychild) >= 12)
		mychild.forceMove(loc)
		visible_message(span_boldwarning(LANG("obj.5ba873c850bb5350", list(mychild, src))))
		playsound(loc,'sound/effects/phasein.ogg', 200, 0, 50, TRUE, TRUE)

/obj/structure/elite_tumor/proc/onEliteLoss()
	playsound(loc,'sound/effects/tendril_destroyed.ogg', 200, 0, 50, TRUE, TRUE)
	visible_message(span_boldwarning(LANG("obj.954123e25b203555", list(src))))
	visible_message(span_boldwarning(LANG("obj.4e604f07c2578841", list(src))))
	var/obj/structure/closet/crate/necropolis/tendril/lootbox = new /obj/structure/closet/crate/necropolis/tendril(loc)
	if(boosted)
		if(mychild.loot_drop != null && prob(50))
			new mychild.loot_drop(lootbox)
		else
			new /obj/item/tumor_shard(lootbox)
	qdel(src)

/obj/structure/elite_tumor/proc/onEliteWon()
	activity = TUMOR_PASSIVE
	clear_activator(activator)
	mychild.revive(HEAL_ALL)
	if(boosted)
		times_won++
		mychild.maxHealth *= ELITE_POST_BATTLE_HEALTH_MULTIPLIER
		mychild.health = mychild.maxHealth
	if(times_won == 1)
		mychild.playsound_local(get_turf(mychild), 'sound/effects/magic.ogg', 40, 0)
		to_chat(mychild, span_boldwarning(LANG("obj.28e67ca0fe79ab9d", null)))
		to_chat(mychild, LANG("obj.61ba8e65355138ab", null))
		to_chat(mychild, span_boldbig(LANG("obj.7ea05fceb9af52c7", null)))

	REMOVE_TRAIT(mychild, TRAIT_UNCONVERTABLE, INNATE_TRAIT)

/obj/item/tumor_shard
	name = "tumor shard"
	desc = "A strange, sharp, crystal shard from an odd tumor on Lavaland.  Stabbing the corpse of a lavaland elite with this will revive them, assuming their soul still lingers.  Revived lavaland elites only have half their max health, but are completely loyal to their reviver."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "crevice_shard"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	inhand_icon_state = "screwdriver_head"
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5

/obj/item/tumor_shard/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /mob/living/simple_animal/hostile/asteroid/elite))
		return NONE

	var/mob/living/simple_animal/hostile/asteroid/elite/elite = interacting_with
	if(elite.stat != DEAD || elite.sentience_type != SENTIENCE_BOSS || !elite.key)
		user.visible_message(span_notice(LANG("obj.a4d9359bbe0fee6b", list(elite))))
		return ITEM_INTERACT_BLOCKING
	elite.set_allies(list("[REF(user)]"))
	elite.set_faction(null)
	elite.revive(HEAL_ALL)
	user.visible_message(span_notice(LANG("obj.6bcad2d0177d3d67", list(user, elite, src))))
	elite.playsound_local(get_turf(elite), 'sound/effects/magic.ogg', 40, 0)
	to_chat(elite, span_userdanger(LANG("obj.3a95fb82b79b14f9", list(user, user, user.p_them(), user.p_their()))))
	to_chat(elite, span_boldbig(LANG("obj.6ed51246b99a8dfb", list(user))))
	elite.maxHealth *= ELITE_POST_BATTLE_HEALTH_MULTIPLIER
	elite.health = elite.maxHealth
	elite.desc = "[elite.desc] However, this one appears to be less wild in nature, and calmer around people."
	elite.sentience_type = SENTIENCE_ORGANIC
	REMOVE_TRAIT(elite, TRAIT_UNCONVERTABLE, INNATE_TRAIT)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/effect/temp_visual/elite_tumor_wall
	name = "magic wall"
	icon = 'icons/turf/walls/hierophant_wall_temp.dmi'
	icon_state = "hierophant_wall_temp-0"
	base_icon_state = "hierophant_wall_temp"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_HIERO_WALL
	canSmoothWith = SMOOTH_GROUP_HIERO_WALL
	duration = 50
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	color = rgb(255,0,0)
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	light_color = "#FA8282"
	var/datum/weakref/activator_ref
	var/datum/weakref/ourelite_ref

/obj/effect/temp_visual/elite_tumor_wall/Initialize(mapload, new_caster)
	. = ..()
	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH_NEIGHBORS(src)
		QUEUE_SMOOTH(src)

/obj/effect/temp_visual/elite_tumor_wall/Destroy()
	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/temp_visual/elite_tumor_wall/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(mover == ourelite_ref.resolve() || mover == activator_ref.resolve())
		return FALSE

#undef ELITE_POST_BATTLE_HEALTH_MULTIPLIER

#undef TUMOR_ACTIVE
#undef TUMOR_INACTIVE
#undef TUMOR_PASSIVE
