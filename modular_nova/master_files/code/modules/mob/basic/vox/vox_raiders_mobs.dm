// Vox Raiders

/mob/living/basic/vox
	name = "沃克斯掠夺者"
	desc = "沃克斯人通常有两种身份：可疑的商人或敌对的掠夺者。这个家伙看起来相当有敌意。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_HUMANOID
	icon_state = "vox"
	icon_living = "vox"
	icon_dead = "voxdead"
	speed = 2.5
	gold_core_spawnable = NO_SPAWN
	maxHealth = 125
	health = 125
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/items/weapons/pierce_slow.ogg'
	minimum_survivable_temperature = 0
	unsuitable_atmos_damage = 7.5
	unsuitable_cold_damage = 7.5
	unsuitable_heat_damage = 7.5
	faction = list(FACTION_HOSTILE)
	ai_controller = /datum/ai_controller/basic_controller/voxraider
	/// Does this type do range attacks?
	var/ranged_attacker = FALSE
	/// How often can we shoot?
	var/ranged_cooldown = 2 SECONDS
	/// Projectile sound
	var/projectilesound = 'sound/items/weapons/gun/pistol/shot.ogg'
	/// What gun shoot
	var/casingtype = /obj/item/ammo_casing/c9mm
	/// why he dead?
	var/corpse = /obj/effect/decal/cleanable/blood/gibs
	/// Lootbox
	var/list/death_loot
	death_loot = list(
		/obj/effect/spawner/random/maintenance/three,
	)

/mob/living/basic/vox/Initialize(mapload)
	. = ..()
	if(LAZYLEN(death_loot) || corpse)
		LAZYOR(death_loot, corpse)
		death_loot = string_list(death_loot)
		AddElement(/datum/element/death_drops, death_loot)

/*
* Vox Slappies
*/

/mob/living/basic/vox/melee
	name = "沃克斯持刀匪"
	desc = "一名手持匕首的沃克斯海盗。"
	icon_state = "voxmelee"
	icon_living = "voxmelee"
	icon_dead = "voxmeleedead"
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	ai_controller = /datum/ai_controller/basic_controller/voxraider
	death_loot = list(
		/obj/effect/spawner/random/medical/medkit,
	)

/*
* Guns
*/

/mob/living/basic/vox/ranged
	name = "沃克斯枪手"
	desc = "SKREEEEE！"
	icon_state = "voxbow"
	icon_living = "voxbow"
	icon_dead = "voxdead"
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_sound = 'sound/items/weapons/gun/pistol/shot.ogg'
	ai_controller = /datum/ai_controller/basic_controller/voxraider/ranged
	ranged_attacker = TRUE
	death_loot = list(
		/obj/effect/spawner/random/engineering/material_rare = 2,
	)

/mob/living/basic/vox/ranged/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/ranged_attacks,\
		casing_type = casingtype,\
		projectile_sound = projectilesound,\
		cooldown_time = ranged_cooldown,\
	)

/*
* LASERS
*/

/mob/living/basic/vox/ranged/laser
	name = "沃克斯激光枪手"
	desc = "沃克斯海盗在战斗中经常混合使用能量武器和动能武器。"
	icon_state = "voxlaser"
	icon_living = "voxlaser"
	icon_dead = "voxsuitdead"
	projectilesound = 'sound/items/weapons/laser3.ogg'
	casingtype = /obj/item/ammo_casing/energy/laser/hellfire
	unsuitable_atmos_damage = 0
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0

/*
* Space guns
*/

/mob/living/basic/vox/ranged/space
	name = "沃克斯太空掠夺者"
	desc = "一名穿着太空服、手持枪械的沃克斯人！"
	icon_state = "voxspace"
	icon_living = "voxspace"
	icon_dead = "voxspacedead"
	projectilesound = 'sound/items/weapons/gun/pistol/shot.ogg'
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 0
	death_loot = list(
		/obj/effect/spawner/random/maintenance/five,
	)

/mob/living/basic/vox/ranged/space/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)

/*
* Space LASERS
*/

/mob/living/basic/vox/ranged/space/laser
	name = "沃克斯舵手"
	desc = "太空航行的沃克斯掠夺者，装备激光步枪并穿着MOD防护服。"
	icon_state = "voxspacelaser"
	icon_living = "voxspacelaser"
	icon_dead = "voxspacedead"
	projectilesound = 'sound/items/weapons/laser3.ogg'
	casingtype = /obj/item/ammo_casing/energy/laser/hellfire
	death_loot = list(
		/obj/effect/spawner/random/engineering/material_rare = 4,
	)
