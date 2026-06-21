// Cult
/mob/living/basic/cult
	name = "血教邪教徒"
	desc = "血母的追随者。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "cult"
	icon_living = "cult"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	basic_mob_flags = DEL_ON_DEATH
	speed = 2.5
	maxHealth = 100
	health = 100
	melee_damage_lower = 15
	melee_damage_upper = 15
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 0
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/items/weapons/punch1.ogg'
	faction = list(FACTION_HOSTILE, FACTION_CULT)
	ai_controller =/datum/ai_controller/basic_controller/cult
	///does this type do range attacks?
	var/ranged_attacker = FALSE
	/// How often can we shoot?
	var/ranged_cooldown = 3 SECONDS
	/// Projectile sound
	var/projectilesound = 'sound/effects/magic/magic_missile.ogg'
	/// What gun shoot
	var/casingtype = /obj/item/ammo_casing/magic/magic_missile
	/// he ded, so what he pop to
	var/corpse = /obj/effect/gibspawner/human
	/// Get that LEWT
	var/list/death_loot

/mob/living/basic/cult/Initialize(mapload)
	. = ..()
	if(LAZYLEN(death_loot) || corpse)
		LAZYOR(death_loot, corpse)
		death_loot = string_list(death_loot)
		AddElement(/datum/element/death_drops, death_loot)
	ADD_TRAIT(src,TRAIT_LAVA_IMMUNE, TRAIT_ASHSTORM_IMMUNE)

/*
* Spookyyyyyy
*/

/mob/living/basic/cult/ghost
	name = "血之幽灵"
	desc = "血母的幽灵追随者。"
	icon_state = "cultghost"
	icon_living = "cultghost"
	maxHealth = 75
	health = 75
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	ai_controller =/datum/ai_controller/basic_controller/cult

/*
* Are they even alive
*/

/mob/living/basic/cult/mannequin
	name = "符文人偶"
	desc = "一个由符文金属和红色水晶构成的造物，一个活生生的人偶。"
	icon_state = "mannequin_cult"
	icon_living = "mannequin_cult"
	maxHealth = 120
	health = 120
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	ai_controller =/datum/ai_controller/basic_controller/cult
	corpse = /obj/effect/gibspawner/robot

/*
* Call the ambulance
*/

/mob/living/basic/cult/horror
	name = "畸变邪教徒"
	desc = "血母的信徒，要么是被实验改造，要么是虔诚到足以变成怪物。"
	icon_state = "culthorror"
	icon_living = "culthorror"
	maxHealth = 150
	health = 150
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	ai_controller =/datum/ai_controller/basic_controller/cult

/*
* Bro has a SWORD
*/

/mob/living/basic/cult/warrior
	name = "邪教徒战士"
	desc = "血母的信徒，身披厚重盔甲，手持剑与盾。"
	icon_state = "cultwarrior"
	icon_living = "cultwarrior"
	maxHealth = 180
	health = 180
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	ai_controller =/datum/ai_controller/basic_controller/cult

/*
* Bro has a spear!!
*/

/mob/living/basic/cult/spear
	name = "邪教徒矛兵"
	desc = "血母的信徒，手持血矛。"
	icon_state = "cultspear"
	icon_living = "cultspear"
	maxHealth = 125
	health = 125
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	ai_controller =/datum/ai_controller/basic_controller/cult

/*
* The lizards are here for revenge
*/

/mob/living/basic/cult/assassin
	name = "邪教徒刺客"
	desc = "血母的信徒，手持两把仪式匕首。"
	icon_state = "cultliz"
	icon_living = "cultliz"
	maxHealth = 125
	health = 125
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	ai_controller =/datum/ai_controller/basic_controller/cult

/*
* pewpew
*/

// magic user
/mob/living/basic/cult/magic
	name = "邪教血法师"
	desc = "一名掌握血魔法的邪教徒。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "cultmage"
	icon_living = "cultmage"
	maxHealth = 115
	health = 115
	obj_damage = 20
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "punches"
	projectilesound = 'sound/effects/magic/magic_missile.ogg'
	ai_controller = /datum/ai_controller/basic_controller/cult/magic
	casingtype = /obj/item/ammo_casing/magic/magic_missile
	ranged_attacker = TRUE

/obj/projectile/magic/spell/magic_missile/lesser
	color = "#792300"

/obj/item/ammo_casing/magic/magic_missile
	projectile_type = /obj/projectile/magic/spell/magic_missile/lesser

/mob/living/basic/cult/magic/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	AddComponent(\
		/datum/component/ranged_attacks,\
		casing_type = casingtype,\
		projectile_sound = projectilesound,\
		cooldown_time = ranged_cooldown,\
	)

/*
* Arcane grunge
*/

/mob/living/basic/cult/magic/elite
	name = "邪教大师"
	desc = "一名对血魔法拥有强大掌控力的邪教徒，似乎在教派中地位更高。"
	icon_state = "cultelite"
	icon_living = "cultelite"
	maxHealth = 200
	health = 200
	projectilesound = 'sound/items/weapons/barragespellhit.ogg'
	casingtype = /obj/item/ammo_casing/magic/arcane_barrage
	ranged_attacker = TRUE

/mob/living/basic/cult/magic/elite/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)

/*
* FIREBALL USE FIREBALL JUST FIREBALL
*/

/mob/living/basic/cult/magic/elite/fireball
	name = "邪教火焰大师"
	desc = "一名对血魔法拥有强大掌控力的邪教徒，似乎在教派中地位更高。"
	icon_state = "cultelite"
	icon_living = "cultelite"
	maxHealth = 300
	health = 300
	projectilesound = 'sound/items/weapons/barragespellhit.ogg'
	casingtype = /obj/item/ammo_casing/magic/fireball
	ranged_attacker = TRUE

/*
* People are way too... 'into' this ones sprite
*/

/mob/living/basic/cult/engorge
	name = "利爪恶魔"
	desc = "一种移动速度相对较快但伤害不高的恶魔生物。"
	icon = 'modular_nova/master_files/icons/mob/newmobs32x64.dmi'
	icon_state = "engorgedemon"
	icon_living = "engorgedemon"
	icon_dead = "demondead"
	mob_biotypes = MOB_SPIRIT
	basic_mob_flags = NONE
	butcher_results = list(/obj/item/stack/sheet/runed_metal/ten = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	speak_emote = list("cackles manically")
	maxHealth = 200
	health = 200
	speed = 2
	obj_damage = 50
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_verb_continuous = "claws"
	attack_verb_simple = "slice"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'

/*
* the ugly one
*/

/mob/living/basic/cult/engorge/devourdem
	name = "吞噬领主"
	desc = "这生物本身就是恐怖，是凡人原始饥饿与贪婪的具现。"
	icon = 'modular_nova/master_files/icons/mob/newmobs32x64.dmi'
	icon_state = "devourdemon"
	icon_living = "devourdemon"
	icon_dead = "demondead"
	mob_biotypes = MOB_SPIRIT
	basic_mob_flags = NONE
	butcher_results = list(/obj/item/stack/sheet/runed_metal/ten = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	speed = 2
	maxHealth = 450
	health = 450
	obj_damage = 80
	melee_damage_lower = 35
	melee_damage_upper = 35
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/effects/wounds/crackandbleed.ogg'
	speak_emote = list("hums ominously")
