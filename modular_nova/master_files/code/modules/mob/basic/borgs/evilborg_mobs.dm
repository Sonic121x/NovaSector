// Damaged Borgs
/mob/living/basic/evilborgs/evilborg
	name = "故障机械人"
	desc = "一个小型机械人单位，被黑客入侵或发生故障。它很可能具有敌意。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "evilbotold"
	icon_living = "evilbotold"
	gender = NEUTER
	basic_mob_flags = DEL_ON_DEATH
	maxHealth = 125
	health = 125
	melee_damage_lower = 20
	melee_damage_upper = 25
	speed = 2.5
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 0
	unsuitable_atmos_damage = 7.5
	unsuitable_cold_damage = 7.5
	unsuitable_heat_damage = 7.5
	gold_core_spawnable = NO_SPAWN
	sight = SEE_TURFS
	faction = list(FACTION_HOSTILE)
	ai_controller = /datum/ai_controller/basic_controller/evilborgs
	/// Does this type do range attacks?
	var/ranged_attacker = FALSE
	/// How often can we shoot?
	var/ranged_cooldown = 3 SECONDS
	/// Projectile sound
	var/projectilesound = 'sound/items/weapons/gun/pistol/shot.ogg'
	/// What gun shoot
	var/casingtype = /obj/item/ammo_casing/c9mm
	/// bursty bois
	var/burst_shots
	/// dead
	var/list/death_loot
	/// Loot box
	var/corpse = /obj/effect/gibspawner/robot


/mob/living/basic/evilborgs/evilborg/Initialize(mapload)
	. = ..()
	if(LAZYLEN(death_loot) || corpse)
		LAZYOR(death_loot, corpse)
		death_loot = string_list(death_loot)
		AddElement(/datum/element/death_drops, death_loot)
	AddComponent(/datum/component/appearance_on_aggro, overlay_icon = icon, overlay_state = "[initial(icon_state)]_attack")

/mob/living/basic/evilborgs/evilborg/death(gibbed)
	do_sparks(number = 3, cardinal_only = TRUE, source = src)
	return ..()

/*
* I am Heavy weapons guy, and this is my saw arm
*/

/mob/living/basic/evilborgs/evilborg/heavy
	name = "故障重型机械人"
	desc = "一个大型机械人单位，被黑客入侵或发生故障。它——哦，天哪，那是电锯吗？！"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "evilbotheavy"
	health = 200
	maxHealth = 200
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_verb_continuous = "saws"
	attack_verb_simple = "saw"
	attack_sound = 'sound/items/weapons/chainsawhit.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs

/*
* Peace through surperior smacking
*/

/mob/living/basic/evilborgs/evilborg/peace
	name = "故障维和机械人"
	desc = "一个机械人单位，被黑客入侵或发生故障。这是维和者型号。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "evilbotpeace"
	icon_living = "evilbotpeace"
	health = 125
	maxHealth = 125
	melee_damage_lower = 18
	melee_damage_upper = 18
	attack_verb_continuous = "smacks"
	attack_verb_simple = "smack"
	attack_sound = 'sound/items/weapons/cqchit1.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs

/*
* Zug Zug
*/

/mob/living/basic/evilborgs/evilborg/engi
	name = "故障工程机械人"
	desc = "一个工程机械人单位，被黑客入侵或发生故障——哦该死那是等离子棒。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "evilbotengi"
	icon_living = "evilbotengi"
	health = 145
	maxHealth = 145
	melee_damage_type = BURN
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "welds"
	attack_verb_simple = "weld"
	attack_sound = 'sound/items/tools/welder.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs

/*
* What do you mean I cant just stab
*/

/mob/living/basic/evilborgs/evilborg/sec
	name = "故障安保机械人"
	desc = "一个安保机械人单位，被黑客入侵或发生故障。它身上装有两把枪。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "evilbotsec"
	icon_living = "evilbotsec"
	health = 100
	maxHealth = 100
	melee_damage_lower = 8
	melee_damage_upper = 8
	attack_verb_continuous = "gunbutts"
	attack_verb_simple = "gunbutt"
	attack_sound = 'sound/items/weapons/smash.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs/ranged
	burst_shots = 2
	ranged_attacker = TRUE

/mob/living/basic/evilborgs/evilborg/sec/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/ranged_attacks,\
		casing_type = casingtype,\
		projectile_sound = projectilesound,\
		cooldown_time = ranged_cooldown,\
		burst_shots = burst_shots,\
	)
	if (ranged_cooldown <= 1 SECONDS)
		AddComponent(/datum/component/ranged_mob_full_auto)

/*
* I clean the floors and your skin
*/

/mob/living/basic/evilborgs/evilborg/roomba
	name = "故障扫地机械人"
	desc = "一个扫地机器人，被黑客入侵或发生故障——嗷我的脚！"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "evilbotroomba"
	icon_living = "evilbotroomba"
	health = 110
	maxHealth = 110
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "pokes"
	attack_verb_simple = "stab"
	attack_sound = 'sound/items/weapons/genhit2.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs

/*
* Woof says the dog
*/

/mob/living/basic/evilborgs/evilborg/dog
	name = "故障犬型机械人"
	desc = "一个犬型机械人，被黑客入侵或发生故障。这似乎是一个采矿型号。"
	icon = 'modular_nova/master_files/icons/mob/newmobs64x32.dmi'
	icon_state = "evilbotmine"
	icon_living = "evilbotmine"
	health = 155
	maxHealth = 155
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "cleaves"
	attack_verb_simple = "smash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs

/*
* Can i pet that dawg!?
*/

/mob/living/basic/evilborgs/evilborg/dogstrong
	name = "腐化猎犬"
	desc = "一个犬型机械人，被黑客入侵或发生故障。这个体型巨大，气势逼人，能造成重击。"
	icon = 'modular_nova/master_files/icons/mob/newmobs64x32.dmi'
	icon_state = "evilbotelite" // ported from VORE
	icon_living = "evilbotelite"
	health = 180
	maxHealth = 180
	melee_damage_lower = 18
	melee_damage_upper = 18
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/items/weapons/bite.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs

/*
* Tank
*/

/mob/living/basic/evilborgs/evilborg/bigguy
	name = "故障军用机器人"
	desc = "一个军用机器人单位，被黑客入侵或发生故障。这个看起来非常结实.."
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "sentrybot"
	icon_living = "sentrybot"
	health = 350
	maxHealth = 350
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "gunbutts"
	attack_verb_simple = "gunbutt"
	attack_sound = 'sound/items/weapons/smash.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs/burst
	burst_shots = 5
	ranged_cooldown = 1.2 SECONDS
	ranged_attacker = TRUE
	casingtype = /obj/item/ammo_casing/c45/ap

/mob/living/basic/evilborgs/evilborg/bigguy/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/ranged_attacks,\
		casing_type = casingtype,\
		projectile_sound = projectilesound,\
		cooldown_time = ranged_cooldown,\
		burst_shots = burst_shots,\
	)
	if (ranged_cooldown <= 1 SECONDS)
		AddComponent(/datum/component/ranged_mob_full_auto)


/*
* Totally not copyright infringing content here
*/

/mob/living/basic/evilborgs/evilborg/protect
	name = "故障标准机器人"
	desc = "一个民用型号机器人，被黑客入侵或发生故障，带有机械爪臂。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "protectbot"
	icon_living = "protectbot"
	ranged_attacker = FALSE
	health = 150
	maxHealth = 150
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "claws"
	attack_verb_simple = "punch"
	attack_sound = 'sound/items/weapons/genhit2.ogg'
	ai_controller = /datum/ai_controller/basic_controller/evilborgs
