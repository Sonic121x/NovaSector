/obj/item/grenade/spawnergrenade
	desc = "它将在周围区域释放一个未指定的异常现象。"
	name = "投递手榴弹"
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "delivery"
	inhand_icon_state = "flashbang"
	var/spawner_type = null // must be an object path
	var/deliveryamt = 1 // amount of type to deliver

/obj/item/grenade/spawnergrenade/apply_grenade_fantasy_bonuses(quality)
	deliveryamt = modify_fantasy_variable("deliveryamt", deliveryamt, quality)

/obj/item/grenade/spawnergrenade/remove_grenade_fantasy_bonuses(quality)
	deliveryamt = reset_fantasy_variable("deliveryamt", deliveryamt)

/obj/item/grenade/spawnergrenade/detonate(mob/living/lanced_by) // Prime now just handles the two loops that query for people in lockers and people who can see it.
	. = ..()
	if(!.)
		return

	update_mob()
	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/target_turf = get_turf(src)
		playsound(target_turf, 'sound/effects/phasein.ogg', 100, TRUE)
		for(var/mob/living/carbon/target_carbon in viewers(target_turf, null))
			target_carbon.flash_act()

		// Spawn some hostile syndicate critters and spread them out
		var/list/spawned = spawn_and_random_walk(spawner_type, target_turf, deliveryamt, walk_chance = 50, admin_spawn = ((flags_1 & ADMIN_SPAWNED_1) ? TRUE : FALSE))
		afterspawn(spawned)
		for(var/mob/living/created as anything in spawned)
			ADD_TRAIT(created, TRAIT_SPAWNED_MOB, INNATE_TRAIT)

	qdel(src)

/obj/item/grenade/spawnergrenade/proc/afterspawn(list/mob/spawned)
	return

/obj/item/grenade/spawnergrenade/manhacks
	name = "开膛者投递手榴弹"
	spawner_type = /mob/living/basic/viscerator
	deliveryamt = 10

/obj/item/grenade/spawnergrenade/spesscarp
	name = "鲤鱼投递手榴弹"
	spawner_type = /mob/living/basic/carp
	deliveryamt = 5

/obj/item/grenade/spawnergrenade/syndiesoap
	name = "擦洗先生"
	spawner_type = /obj/item/soap/syndie

/obj/item/grenade/spawnergrenade/buzzkill
	name = "扫兴手榴弹"
	desc = "标签上写着：\"警告：装置激活后将释放活体样本。使用前请密封防护服。\"它摸起来温热，并轻微振动。"
	icon_state = "holy_grenade"
	spawner_type = /mob/living/basic/bee/toxin
	deliveryamt = 10

/obj/item/grenade/spawnergrenade/clown
	name = "C.L.U.W.N.E."
	desc = "一种流线型装置，常在小丑十岁生日时赠予他们用于防身。你能听到里面传来微弱的抓挠声。"
	icon_state = "clown_ball"
	inhand_icon_state = null
	spawner_type = list(/mob/living/basic/clown/fleshclown, /mob/living/basic/clown/clownhulk, /mob/living/basic/clown/longface, /mob/living/basic/clown/clownhulk/chlown, /mob/living/basic/clown/clownhulk/honkmunculus, /mob/living/basic/clown/mutant/glutton, /mob/living/basic/clown/banana, /mob/living/basic/clown/honkling, /mob/living/basic/clown/lube)
	deliveryamt = 1

/obj/item/grenade/spawnergrenade/clown_broken
	name = "填充式C.L.U.W.N.E."
	desc = "一种流线型装置，常在小丑十岁生日时赠予他们用于防身。虽然典型的C.L.U.W.N.E.只容纳一只生物，但有时愚蠢的年轻小丑会试图塞进更多，往往导致灾难性后果。"
	icon_state = "clown_broken"
	inhand_icon_state = null
	spawner_type = /mob/living/basic/clown/mutant
	deliveryamt = 5

/obj/item/grenade/spawnergrenade/cat
	name = "猫榴弹"
	desc = "你能听到里面传来微弱的喵喵声和爪子抓挠金属的声音。"
	spawner_type = /mob/living/basic/pet/cat/feral
	deliveryamt = 5
