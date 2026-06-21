// Ported from Citadel Station

/mob/living/basic/banana_spider
	name = "香蕉蜘蛛"
	desc = "这他妈是什么怪物？"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "bananaspider"
	icon_dead = "bananaspider_peel"
	health = 1
	maxHealth = 1
	speed = 2
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	mob_size = MOB_SIZE_TINY
	density = TRUE
	verb_say = "吱吱叫"
	verb_ask = "好奇地吱吱叫"
	verb_exclaim = "大声吱吱叫"
	verb_yell = "大声吱吱叫"
	basic_mob_flags = DEL_ON_DEATH
	ai_controller = /datum/ai_controller/basic_controller/cockroach/banana_spider

/mob/living/basic/banana_spider/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 40)
	var/static/list/banana_drops = list(/obj/item/food/deadbanana_spider)
	AddElement(/datum/element/death_drops, banana_drops)
	AddComponent(/datum/component/squashable, squash_chance = 50, squash_damage = 1)

/datum/ai_controller/basic_controller/cockroach/banana_spider
	idle_behavior = /datum/idle_behavior/idle_random_walk/banana_spider

/datum/idle_behavior/idle_random_walk/banana_spider
	walk_chance = 10

/obj/item/food/deadbanana_spider
	name = "香蕉蜘蛛尸体"
	desc = "谢天谢地它总算死了……不过看起来滑溜溜的。"
	icon = 'modular_nova/master_files/icons/mob/newmobs.dmi'
	icon_state = "bananaspider_peel"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtypes = GORE | MEAT | RAW

/obj/item/food/deadbanana_spider/grind_results()
	return list(/datum/reagent/blood = 20, /datum/reagent/consumable/liquidgibs = 5)

/obj/item/food/deadbanana_spider/juice_typepath()
	return /datum/reagent/consumable/banana

/obj/item/food/deadbanana_spider/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 20)
