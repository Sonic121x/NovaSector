/mob/living/basic/cockroach
	name = "蟑螂"
	desc = "这空间站简直爬满了虫子。"
	icon_state = "cockroach"
	icon_dead = "cockroach_no_animation"
	density = FALSE
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	mob_size = MOB_SIZE_TINY
	held_w_class = WEIGHT_CLASS_TINY
	health = 1
	maxHealth = 1
	speed = 1.25
	can_be_held = TRUE
	gold_core_spawnable = FRIENDLY_SPAWN
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB

	verb_say = "吱吱叫"
	verb_ask = "好奇地吱吱叫"
	verb_exclaim = "大声吱吱叫"
	verb_yell = "大声吱吱叫"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "splats"
	response_harm_simple = "splat"
	speak_emote = list("chitters")

	basic_mob_flags = DEL_ON_DEATH
	faction = list(FACTION_HOSTILE, FACTION_MAINT_CREATURES)

	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 270
	maximum_survivable_temperature = INFINITY

	ai_controller = /datum/ai_controller/basic_controller/cockroach

	var/cockroach_cell_line = CELL_LINE_TABLE_COCKROACH
	/// What do we turn into if recruited by a regal rat?
	var/minion_path = /mob/living/basic/cockroach/sewer
	/// Command list given to minionised cockroaches
	var/list/minion_commands

/mob/living/basic/cockroach/Initialize(mapload)
	var/turf/our_turf = get_turf(src)
	if(SSmapping.level_trait(our_turf.z, ZTRAIT_SNOWSTORM) || SSmapping.level_trait(our_turf.z, ZTRAIT_ICE_RUINS) || SSmapping.level_trait(our_turf.z, ZTRAIT_ICE_RUINS_UNDERGROUND))
		name = "冰-[name]"
		real_name = name
		desc += "<br>This one seems to have a blue tint and has adapted to the cold."
		minimum_survivable_temperature = 140 // 40kelvin below icebox temp
		add_atom_colour("#66ccff", FIXED_COLOUR_PRIORITY)
	. = ..()
	AddElement(/datum/element/death_drops, /obj/effect/decal/cleanable/insectguts)
	AddElement(/datum/element/swabable, cockroach_cell_line, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 7)
	AddComponent( \
		/datum/component/squashable, \
		squash_chance = 50, \
		squash_damage = 1, \
		squash_flags = SQUASHED_SHOULD_BE_GIBBED|SQUASHED_ALWAYS_IF_DEAD|SQUASHED_DONT_SQUASH_IN_CONTENTS, \
	)
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NUKEIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_RADIMMUNE, INNATE_TRAIT)

	if (minion_path)
		set_pet_commands()
		AddElement(/datum/element/regal_rat_minion, converted_path = minion_path, success_balloon = "hiss", pet_commands = minion_commands)

/// Decide what this should be able to be told to do
/mob/living/basic/cockroach/proc/set_pet_commands()
	minion_commands = GLOB.regal_rat_minion_commands

/mob/living/basic/cockroach/ex_act() //Explosions are a terrible way to handle a cockroach.
	return FALSE

// Roach goop is the gibs to drop
/mob/living/basic/cockroach/get_gibs_type(drop_bitflags = NONE)
	return

/// Roach which tries to ineffectually attack you
/mob/living/basic/cockroach/sewer
	name = "下水道蟑螂"
	icon_state = "cockroach_sewer"
	desc = "这只虫子脾气真的很差。"
	health = 2
	maxHealth = 2 // Wow!
	melee_damage_lower = 2
	melee_damage_upper = 4
	obj_damage = 5
	melee_attack_cooldown = 0.8 SECONDS
	gold_core_spawnable = HOSTILE_SPAWN
	minion_path = null
	ai_controller = /datum/ai_controller/basic_controller/cockroach/aggro

/mob/living/basic/cockroach/bloodroach
	name = "血蟑螂"
	desc = "这只蟑螂饱食了维护区的血液，其肥厚的甲壳上闪烁着红色的光泽。极其恶心。"
	icon_state = "bloodroach"
	icon_dead = "bloodroach_no_animation"
	health = 3
	maxHealth = 3 // Wow!!

/mob/living/basic/cockroach/bloodroach/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/death_drops, /obj/effect/decal/cleanable/blood/gibs/old)

/mob/living/basic/cockroach/bloodroach/death(gibbed)
	if(HAS_TRAIT(src, TRAIT_BUGKILLER_DEATH))
		return ..()
	// explode into a pile of blood if not pest controlled
	for(var/turf/messy_turf in view(src, 2))
		new /obj/effect/decal/cleanable/blood(messy_turf)
		for(var/mob/living/mob_in_turf in messy_turf)
			mob_in_turf.visible_message(span_danger("[mob_in_turf] 被溅了一身血！"), span_userdanger("你被溅了一身血！"))
			mob_in_turf.add_blood_DNA(list("Non-human DNA" = random_human_blood_type()))
			mob_in_turf.add_mood_event("splattered_with_blood", /datum/mood_event/splattered_with_blood)
			playsound(mob_in_turf, 'sound/effects/splat.ogg', 50, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
	return ..()

/// Roach with a spiky hat, like a caltrop
/mob/living/basic/cockroach/hauberoach
	name = "尖盔蟑螂"
	desc = "那只蟑螂是不是戴着一顶微小却完美复刻的19世纪普鲁士尖顶头盔？……这算坏事吗？"
	icon_state = "hauberoach"
	attack_verb_continuous = "rams its spike into"
	attack_verb_simple = "ram your spike into"
	melee_damage_lower = 2.5
	melee_damage_upper = 10
	obj_damage = 10
	melee_attack_cooldown = 1 SECONDS
	gold_core_spawnable = HOSTILE_SPAWN
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	faction = list(FACTION_HOSTILE, FACTION_MAINT_CREATURES)
	sharpness = SHARP_POINTY
	ai_controller = /datum/ai_controller/basic_controller/cockroach/aggro
	cockroach_cell_line = CELL_LINE_TABLE_HAUBEROACH
	minion_path = /mob/living/basic/cockroach/hauberoach/imperial

/mob/living/basic/cockroach/hauberoach/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 10, max_damage = 15, flags = (CALTROP_BYPASS_SHOES | CALTROP_SILENT))
	AddComponent( \
		/datum/component/squashable, \
		squash_chance = 100, \
		squash_damage = 1, \
		squash_flags = SQUASHED_SHOULD_BE_GIBBED|SQUASHED_ALWAYS_IF_DEAD|SQUASHED_DONT_SQUASH_IN_CONTENTS, \
		squash_callback = TYPE_PROC_REF(/mob/living/basic/cockroach/hauberoach, on_squish), \
	)

///Proc used to override the squashing behavior of the normal cockroach.
/mob/living/basic/cockroach/hauberoach/proc/on_squish(mob/living/cockroach, mob/living/living_target)
	if(!istype(living_target))
		return FALSE //We failed to run the invoke. Might be because we're a structure. Let the squashable element handle it then!
	if(!HAS_TRAIT(living_target, TRAIT_PIERCEIMMUNE))
		living_target.visible_message(span_danger("[living_target] 踩到了 [cockroach] 的尖刺上！"), span_userdanger("你踩到了 [cockroach] 的尖刺上！"))
		return TRUE
	living_target.visible_message(span_notice("[living_target] 踩扁了 [cockroach]，甚至没注意到它的尖刺。"), span_notice("你踩扁了 [cockroach]，甚至没注意到它的尖刺。"))
	return FALSE

/// Regal rat royal escort
/mob/living/basic/cockroach/hauberoach/imperial
	name = "帝国尖盔蟑螂"
	desc = "这只蟑螂似乎找到了一份职业皇家卫队的工作。"
	health = 2
	maxHealth = 2
	melee_damage_lower = 3
	melee_damage_upper = 12
	icon_state = "hauberoach_sewer"
	minion_path = null
	gold_core_spawnable = NO_SPAWN

/// Roach with a gun
/mob/living/basic/cockroach/glockroach
	name = "枪蟑螂"
	desc = "我操，那只蟑螂有枪！"
	icon_state = "glockroach"
	melee_damage_lower = 2.5
	melee_damage_upper = 10
	obj_damage = 10
	gold_core_spawnable = HOSTILE_SPAWN
	faction = list(FACTION_HOSTILE, FACTION_MAINT_CREATURES)
	ai_controller = /datum/ai_controller/basic_controller/cockroach/glockroach
	cockroach_cell_line = CELL_LINE_TABLE_GLOCKROACH
	minion_path = /mob/living/basic/cockroach/glockroach/gang
	///number of burst shots
	var/burst_shots
	///cooldown between attacks
	var/ranged_cooldown = 1 SECONDS

/mob/living/basic/cockroach/glockroach/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/ranged_attacks,\
		casing_type = /obj/item/ammo_casing/glockroach,\
		burst_shots = burst_shots,\
		cooldown_time = ranged_cooldown,\
	)
	if (ranged_cooldown <= 1 SECONDS)
		AddComponent(/datum/component/ranged_mob_full_auto)

/mob/living/basic/cockroach/glockroach/set_pet_commands()
	var/static/list/glockroach_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/protect_owner/glockroach,
		/datum/pet_command/follow,
		/datum/pet_command/attack/glockroach
	)
	minion_commands = glockroach_commands

/mob/living/basic/cockroach/glockroach/gang
	name = "帮派蟑螂"
	desc = "这只蟑螂在街头错误的环境中长大，并误入了歧途。"
	icon_state = "glockroach_sewer"
	health = 2
	maxHealth = 2
	minion_path = null
	gold_core_spawnable = NO_SPAWN

/obj/projectile/glockroachbullet
	damage = 10 //same damage as a hivebot
	damage_type = BRUTE

/obj/item/ammo_casing/glockroach
	name = "0.9毫米弹壳"
	desc = "一个……0.9毫米弹壳？什么鬼？"
	projectile_type = /obj/projectile/glockroachbullet

/// Roach with an SMG
/mob/living/basic/cockroach/glockroach/mobroach
	name = "暴徒蟑螂"
	desc = "我们完蛋了，那只蟑螂有把汤普森冲锋枪！"
	icon_state = "mobroach"
	burst_shots = 4
	ranged_cooldown = 2 SECONDS
	minion_path = /mob/living/basic/cockroach/glockroach/mobroach/goon

	ai_controller = /datum/ai_controller/basic_controller/cockroach/glockroach

/mob/living/basic/cockroach/glockroach/mobroach/goon
	name = "打手蟑螂"
	desc = "遵命，老大。"
	icon_state = "mobroach_sewer"
	health = 2
	maxHealth = 2
	minion_path = null
	gold_core_spawnable = NO_SPAWN
