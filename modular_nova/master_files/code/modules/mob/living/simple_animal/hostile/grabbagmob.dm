// Syndicate

/mob/living/basic/trooper/syndicate/melee/anthro
	name = "辛迪加捅刀者"
	desc = "一名手持匕首的辛迪加拟人化小熊猫成员。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "syndiredpan"
	icon_living = "syndiredpan"

/mob/living/basic/trooper/syndicate/melee/sword/anthro
	name = "辛迪加剑兽"
	desc = "一名手持能量剑与盾牌的辛迪加拟人化耳廓狐成员。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "syndifennec"
	icon_living = "syndifennec"

/mob/living/basic/trooper/syndicate/ranged/anthro
	name = "辛迪加手枪手"
	desc = "一名手持手枪的辛迪加拟人化成员。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "syndisquirrel"
	icon_living = "syndisquirrel"

/mob/living/basic/trooper/syndicate/ranged/smg/anthro
	name = "辛迪加速射枪手"
	desc = "一名手持冲锋枪的辛迪加蛾人成员。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "syndimoth"
	icon_living = "syndimoth"

/mob/living/basic/trooper/syndicate/melee/space/anthro/lizard
	name = "辛迪加突击队蜥蜴"
	desc = "辛迪加的爬行类成员！"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "syndilizard"
	icon_living = "syndilizard"

/mob/living/basic/trooper/syndicate/ranged/space/anthro/cat
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "syndicat"
	icon_living = "syndicat"
	name = "辛迪加突击队猫科"
	desc = "辛迪加的拟人化猫科成员。"

/mob/living/basic/trooper/syndicate/ranged/shotgun/space/stormtrooper/anthro/fox
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "syndifox"
	icon_living = "syndifox"
	name = "辛迪加冲锋队狐狸"
	desc = "辛迪加的拟人化狐狸成员。"

// Beasts

/mob/living/simple_animal/hostile/bigcrab
	name = "巨型螃蟹"
	desc = "咔嗒咔嗒！"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "giantcrab"
	icon_living = "giantcrab"
	icon_dead = "giantcrab_d"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/food/meat/slab/rawcrab = 8, /obj/item/stack/sheet/bone = 4)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("snaps")
	taunt_chance = 30
	move_to_delay = 20
	speed = 2
	maxHealth = 150
	health = 150
	harm_intent_damage = 3
	obj_damage = 40
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "claws"
	attack_verb_simple = "pinch"
	attack_sound = 'sound/items/weapons/genhit2.ogg'
	speak_emote = list("gnashes")
	atmos_requirements = null
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list(FACTION_HOSTILE)
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/trog
	name = "变异人类"
	desc = "要么是某种出了差错的实验，要么是等离子体暴露导致突变的结果。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "trog"
	icon_living = "trog"
	icon_dead = "trog_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/food/meat/slab/human = 4)
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "shoos away"
	response_disarm_simple = "shoo away"
	emote_taunt = list("screeches")
	taunt_chance = 30
	speed = 0
	maxHealth = 80
	health = 80
	harm_intent_damage = 8
	obj_damage = 30
	melee_damage_lower = 18
	melee_damage_upper = 18
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/items/weapons/bite.ogg'
	speak_emote = list("screeches")
	atmos_requirements = null
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list(FACTION_HOSTILE)
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/trog/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/hostile/plantmutant
	name = "植物突变体"
	desc = "某种被植物或真菌孢子变异成可怕怪物的人形生物。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "plantmonster"
	icon_living = "plantmonster"
	icon_dead = "plantmonster_dead"
	mob_biotypes = MOB_ORGANIC|MOB_PLANT
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/plant = 4)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	taunt_chance = 30
	speed = 0
	maxHealth = 90
	health = 90
	obj_damage = 10
	melee_damage_lower = 18
	melee_damage_upper = 18
	attack_verb_continuous = "bites"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bite.ogg'
	speak_emote = list("gurlges")
	atmos_requirements = list("min_oxy" = 10, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list(FACTION_HOSTILE, "vines", "plants")
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/plantmutant/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/hostile/cazador
	name = "卡萨多"
	desc = "你感觉有点头晕……"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "cazador"
	icon_living = "cazador"
	icon_dead = "cazador_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	speak_chance = 0
	turns_per_move = 5
	loot = list(/obj/item/reagent_containers/cup/bottle/rezadone)
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("buzzes")
	taunt_chance = 30
	speed = 0
	maxHealth = 60
	health = 60
	melee_damage_type = TOX
	melee_damage_lower = 25
	melee_damage_upper = 25
	move_to_delay = 4
	attack_verb_continuous = "stings"
	attack_verb_simple = "sting"
	attack_sound = 'sound/items/weapons/genhit2.ogg'
	speak_emote = list("buzzes")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 800
	faction = list(FACTION_HOSTILE)
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/cazador/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/hostile/mutantliz
	name = "变异蜥蜴"
	desc = "一只巨大的变异蜥蜴生物，长着锯齿状的牙齿和锋利的爪子。"
	icon = 'modular_nova/master_files/icons/mob/newmobs64x64.dmi'
	icon_state = "mutantliz"
	icon_living = "mutantliz"
	icon_dead = "mutantliz_d"
	mob_biotypes = MOB_ORGANIC|MOB_REPTILE
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/lizard = 6)
	response_help_continuous = "pats"
	response_help_simple = "pat"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("roars")
	taunt_chance = 30
	speed = 1
	maxHealth = 250
	health = 250
	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	speak_emote = list("growls")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 800
	faction = list(FACTION_HOSTILE)
	pressure_resistance = 200
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/hostile/scorpion
	name = "大蝎子"
	desc = "一只异常巨大的蝎子。小心它的毒刺！"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "scorpion"
	icon_living = "scorpion"
	icon_dead = "scorpion_d"
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	speed = 0
	maxHealth = 75
	health = 75
	melee_damage_type = TOX
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "stings"
	attack_verb_simple = "sting"
	attack_sound = 'sound/items/weapons/genhit2.ogg'
	speak_emote = list("chitters")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 900
	faction = list(FACTION_HOSTILE)
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/syndimouse
	name = "辛迪加鼠装特工"
	desc = "一只穿着辛迪加战斗MOD服的鼠鼠，专为鼠鼠打造！"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "mouse_operative"
	icon_living = "mouse_operative"
	icon_dead = "mouse_operative_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("aggressively squeaks")
	taunt_chance = 30
	speed = 0
	maxHealth = 30
	health = 30
	harm_intent_damage = 5
	obj_damage = 25
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "bosses"
	attack_verb_simple = "boss"
	attack_sound = 'sound/items/weapons/cqchit2.ogg'
	speak_emote = list("squeaks")
	emote_see = list("squeaks.", "practices CQC.", "cocks the bolt of a tiny CR20.", "plots to steal DAT DISK!", "fiddles with a tiny radio.")
	speak_chance = 1
	atmos_requirements = null
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list(ROLE_SYNDICATE)
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/syndimouse/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/hostile/mannequin
	name = "活体人偶"
	desc = "一个奇怪的、活着的木质人偶。真吓人！"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "mannequin"
	icon_living = "mannequin"
	mob_biotypes = MOB_UNDEAD
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "poke"
	response_help_simple = "poke"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	speed = 2
	maxHealth = 50
	health = 50
	harm_intent_damage = 3
	obj_damage = 15
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/items/weapons/cqchit1.ogg'
	speak_emote = list("clacks")
	atmos_requirements = null
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list(FACTION_HOSTILE)
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/basic/gorilla/pitbull
	name = "pitbull"
	desc = "Lover of Blood. Hater of Toddlers. Doesn't look too happy to see you."
	icon = 'modular_nova/master_files/icons/mob/pets.dmi'
	icon_state = "pitbull"
	icon_dead = "pitbull_dead"
	icon_living = "pitbull"
