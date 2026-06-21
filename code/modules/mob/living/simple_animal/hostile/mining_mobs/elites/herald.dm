#define HERALD_TRISHOT 1
#define HERALD_DIRECTIONALSHOT 2
#define HERALD_TELESHOT 3
#define HERALD_MIRROR 4

/**
 * # Herald
 *
 * A slow-moving projectile user with a few tricks up its sleeve.  Less unga-bunga than Colossus, with more cleverness in its fighting style.
 * As its health gets lower, the amount of projectiles fired per-attack increases.
 * Its attacks are as follows:
 * - Fires three projectiles in a given direction.
 * - Fires a spread in every cardinal and diagonal direction at once, then does it again after a bit.
 * - Shoots a single, golden bolt.  Wherever it lands, the herald will be teleported to the location.
 * - Spawns a mirror which reflects projectiles directly at the target.
 * Herald is a more concentrated variation of the Colossus fight, having less projectiles overall, but more focused attacks.
 */

/mob/living/simple_animal/hostile/asteroid/elite/herald
	name = "预兆"
	desc = "一种体型巨大的怪兽，它能发射致命的弹丸来对付威胁和猎物。"
	icon = 'icons/mob/simple/lavaland/lavaland_elites_64.dmi'
	icon_state = "herald"
	icon_living = "herald"
	icon_aggro = "herald"
	icon_dead = "herald_dying"
	icon_gib = "syndicate_gib"
	pixel_x = -16
	base_pixel_x = -16
	health_doll_icon = "herald"
	maxHealth = 1000
	health = 1000
	melee_damage_lower = 20
	melee_damage_upper = 20
	mob_biotypes = MOB_ORGANIC|MOB_MINING
	attack_verb_continuous = "preaches to"
	attack_verb_simple = "preach to"
	attack_sound = 'sound/effects/magic/clockwork/ratvar_attack.ogg'
	throw_message = "doesn't affect the purity of"
	speed = 2
	move_to_delay = 10
	mouse_opacity = MOUSE_OPACITY_ICON
	death_sound = 'sound/effects/magic/demon_dies.ogg'
	death_message = "begins to shudder as it becomes transparent..."
	loot_drop = /obj/item/clothing/neck/cloak/herald_cloak

	can_talk = 1

	attack_action_types = list(/datum/action/innate/elite_attack/herald_trishot,
								/datum/action/innate/elite_attack/herald_directionalshot,
								/datum/action/innate/elite_attack/herald_teleshot,
								/datum/action/innate/elite_attack/herald_mirror)

	var/mob/living/simple_animal/hostile/asteroid/elite/herald/mirror/my_mirror = null
	var/is_mirror = FALSE

/mob/living/simple_animal/hostile/asteroid/elite/herald/death()
	. = ..()
	if(!is_mirror)
		addtimer(CALLBACK(src, PROC_REF(become_ghost)), 0.8 SECONDS)
	if(my_mirror != null)
		qdel(my_mirror)

/mob/living/simple_animal/hostile/asteroid/elite/herald/proc/become_ghost()
	icon_state = "herald_ghost"

/mob/living/simple_animal/hostile/asteroid/elite/herald/send_speech(message_raw, message_range, obj/source, bubble_type, list/spans, datum/language/message_language, list/message_mods, forced, tts_message, list/tts_filter)
	. = ..()
	if(stat != CONSCIOUS)
		return
	playsound(src, 'sound/effects/magic/clockwork/invoke_general.ogg', 20, TRUE)

/datum/action/innate/elite_attack/herald_trishot
	name = "三连发"
	button_icon_state = "herald_trishot"
	chosen_message = span_boldwarning("你现在将朝你选择的方向发射三发子弹。")
	chosen_attack_num = HERALD_TRISHOT

/datum/action/innate/elite_attack/herald_directionalshot
	name = "环形射击"
	button_icon_state = "herald_directionalshot"
	chosen_message = span_boldwarning("你正在朝所有方向发射投射物。")
	chosen_attack_num = HERALD_DIRECTIONALSHOT

/datum/action/innate/elite_attack/herald_teleshot
	name = "传送射击"
	button_icon_state = "herald_teleshot"
	chosen_message = span_boldwarning("你现在将发射一发子弹，它会将你传送到其落点。")
	chosen_attack_num = HERALD_TELESHOT

/datum/action/innate/elite_attack/herald_mirror
	name = "召唤镜"
	button_icon_state = "herald_mirror"
	chosen_message = span_boldwarning("你将生成一面镜子来复制你的攻击。")
	chosen_attack_num = HERALD_MIRROR

/mob/living/simple_animal/hostile/asteroid/elite/herald/OpenFire()
	if(client)
		switch(chosen_attack)
			if(HERALD_TRISHOT)
				herald_trishot(target)
				if(my_mirror != null)
					my_mirror.herald_trishot(target)
			if(HERALD_DIRECTIONALSHOT)
				herald_directionalshot()
				if(my_mirror != null)
					my_mirror.herald_directionalshot()
			if(HERALD_TELESHOT)
				herald_teleshot(target)
				if(my_mirror != null)
					my_mirror.herald_teleshot(target)
			if(HERALD_MIRROR)
				herald_mirror()
		return
	var/aiattack = rand(1,4)
	switch(aiattack)
		if(HERALD_TRISHOT)
			herald_trishot(target)
			if(my_mirror != null)
				my_mirror.herald_trishot(target)
		if(HERALD_DIRECTIONALSHOT)
			herald_directionalshot()
			if(my_mirror != null)
				my_mirror.herald_directionalshot()
		if(HERALD_TELESHOT)
			herald_teleshot(target)
			if(my_mirror != null)
				my_mirror.herald_teleshot(target)
		if(HERALD_MIRROR)
			herald_mirror()

/mob/living/simple_animal/hostile/asteroid/elite/herald/proc/shoot_projectile(turf/marker, set_angle, is_teleshot, is_trishot)
	var/turf/startloc = get_turf(src)
	var/obj/projectile/herald/H = null
	if(!is_teleshot)
		H = new /obj/projectile/herald(startloc)
	else
		H = new /obj/projectile/herald/teleshot(startloc)
	H.aim_projectile(marker, startloc)
	H.firer = src
	if(target)
		H.original = target
	H.fire(set_angle)
	if(is_trishot)
		shoot_projectile(marker, set_angle + 15, FALSE, FALSE)
		shoot_projectile(marker, set_angle - 15, FALSE, FALSE)

/mob/living/simple_animal/hostile/asteroid/elite/herald/proc/herald_trishot(target)
	ranged_cooldown = world.time + 30
	playsound(get_turf(src), 'sound/effects/magic/clockwork/invoke_general.ogg', 20, TRUE)
	var/target_turf = get_turf(target)
	var/angle_to_target = get_angle(src, target_turf)
	shoot_projectile(target_turf, angle_to_target, FALSE, TRUE)
	addtimer(CALLBACK(src, PROC_REF(shoot_projectile), target_turf, angle_to_target, FALSE, TRUE), 0.2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(shoot_projectile), target_turf, angle_to_target, FALSE, TRUE), 0.4 SECONDS)
	if(health < maxHealth * 0.5 && !is_mirror)
		playsound(get_turf(src), 'sound/effects/magic/clockwork/invoke_general.ogg', 20, TRUE)
		addtimer(CALLBACK(src, PROC_REF(shoot_projectile), target_turf, angle_to_target, FALSE, TRUE), 1 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(shoot_projectile), target_turf, angle_to_target, FALSE, TRUE), 1.2 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(shoot_projectile), target_turf, angle_to_target, FALSE, TRUE), 1.4 SECONDS)

/mob/living/simple_animal/hostile/asteroid/elite/herald/proc/herald_circleshot(offset)
	var/static/list/directional_shot_angles = list(0, 45, 90, 135, 180, 225, 270, 315)
	for(var/i in directional_shot_angles)
		shoot_projectile(get_turf(src), i + offset, FALSE, FALSE)

/mob/living/simple_animal/hostile/asteroid/elite/herald/proc/unenrage()
	if(stat == DEAD || is_mirror)
		return
	icon_state = "herald"

/mob/living/simple_animal/hostile/asteroid/elite/herald/proc/herald_directionalshot()
	ranged_cooldown = world.time + 3 SECONDS
	if(!is_mirror)
		icon_state = "herald_enraged"
	playsound(get_turf(src), 'sound/effects/magic/clockwork/invoke_general.ogg', 20, TRUE)
	addtimer(CALLBACK(src, PROC_REF(herald_circleshot), 0), 0.5 SECONDS)
	if(health < maxHealth * 0.5 && !is_mirror)
		playsound(get_turf(src), 'sound/effects/magic/clockwork/invoke_general.ogg', 20, TRUE)
		addtimer(CALLBACK(src, PROC_REF(herald_circleshot), 22.5), 1.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(unenrage)), 2 SECONDS)

/mob/living/simple_animal/hostile/asteroid/elite/herald/proc/herald_teleshot(target)
	ranged_cooldown = world.time + 30
	playsound(get_turf(src), 'sound/effects/magic/clockwork/invoke_general.ogg', 20, TRUE)
	var/target_turf = get_turf(target)
	var/angle_to_target = get_angle(src, target_turf)
	shoot_projectile(target_turf, angle_to_target, TRUE, FALSE)

/mob/living/simple_animal/hostile/asteroid/elite/herald/proc/herald_mirror()
	ranged_cooldown = world.time + 4 SECONDS
	playsound(get_turf(src), 'sound/effects/magic/clockwork/invoke_general.ogg', 20, TRUE)
	if(my_mirror != null)
		qdel(my_mirror)
		my_mirror = null
	var/mob/living/simple_animal/hostile/asteroid/elite/herald/mirror/new_mirror = new /mob/living/simple_animal/hostile/asteroid/elite/herald/mirror(loc)
	my_mirror = new_mirror
	my_mirror.my_master = src
	SET_FACTION_AND_ALLIES_FROM(my_mirror, src)

/mob/living/simple_animal/hostile/asteroid/elite/herald/mirror
	name = "先驱者之镜"
	desc = "这个邪恶的魔法阵效仿了传令官的攻击方式。显然应该将其摧毁。"
	health = 60
	maxHealth = 60
	icon_state = "herald_mirror"
	icon_aggro = "herald_mirror"
	pixel_x = -16
	base_pixel_x = -16
	death_message = "shatters violently!"
	death_sound = 'sound/effects/glass/glassbr1.ogg'
	del_on_death = TRUE
	is_mirror = TRUE
	move_resist = MOVE_FORCE_OVERPOWERING // no dragging your mirror around
	var/mob/living/simple_animal/hostile/asteroid/elite/herald/my_master = null

/mob/living/simple_animal/hostile/asteroid/elite/herald/mirror/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/simple_flying)
	toggle_ai(AI_OFF)

/mob/living/simple_animal/hostile/asteroid/elite/herald/mirror/Destroy()
	if(my_master != null)
		my_master.my_mirror = null
	. = ..()

/obj/projectile/herald
	name ="死亡箭矢"
	icon_state= "chronobolt"
	damage = 20
	armour_penetration = 60
	speed = 0.5
	damage_type = BRUTE
	pass_flags = PASSTABLE

/obj/projectile/herald/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/parriable_projectile)

/obj/projectile/herald/on_hit(atom/target, blocked = 0, pierce_hit)
	if(ismob(target) && ismob(firer))
		var/mob/living/mob_target = target
		if(mob_target.faction_check_atom(firer))
			damage = 0

	. = ..()
	if(ismineralturf(target))
		var/turf/closed/mineral/rock_target = target
		rock_target.gets_drilled()

/obj/projectile/herald/teleshot
	name = "黄金箭矢"
	damage = 0
	color = rgb(255,255,102)

/obj/projectile/herald/teleshot/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(!QDELETED(firer))
		firer.forceMove(get_turf(src))

//Herald's loot: Cloak of the Prophet

/obj/item/clothing/neck/cloak/herald_cloak
	name = "先知法衣"
	desc = "一件能保护你免受世间邪说影响的斗篷。"
	icon = 'icons/obj/mining_zones/elite_trophies.dmi'
	icon_state = "herald_cloak"
	body_parts_covered = CHEST|GROIN|ARMS
	hit_reaction_chance = 20

/obj/item/clothing/neck/cloak/herald_cloak/proc/reactionshot(mob/living/carbon/owner)
	var/static/list/directional_shot_angles = list(0, 45, 90, 135, 180, 225, 270, 315)
	for(var/i in directional_shot_angles)
		shoot_projectile(get_turf(owner), i, owner)

/obj/item/clothing/neck/cloak/herald_cloak/proc/shoot_projectile(turf/marker, set_angle, mob/living/carbon/owner)
	var/turf/startloc = get_turf(owner)
	var/obj/projectile/herald/H = null
	H = new /obj/projectile/herald(startloc)
	H.aim_projectile(marker, startloc)
	H.firer = owner
	H.fire(set_angle)

/obj/item/clothing/neck/cloak/herald_cloak/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	. = ..()
	if(prob(hit_reaction_chance))
		return
	owner.visible_message(span_danger("[owner]的[src]在[owner]被击中时发出巨响！"))
	var/static/list/directional_shot_angles = list(0, 45, 90, 135, 180, 225, 270, 315)
	playsound(get_turf(owner), 'sound/effects/magic/clockwork/invoke_general.ogg', 20, TRUE)
	addtimer(CALLBACK(src, PROC_REF(reactionshot), owner), 1 SECONDS)

#undef HERALD_TRISHOT
#undef HERALD_DIRECTIONALSHOT
#undef HERALD_TELESHOT
#undef HERALD_MIRROR
