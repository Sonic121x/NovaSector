/datum/ash_ritual
	/// the name of the ritual
	var/name = "召唤程序员"
	/// the description of the ritual
	var/desc

	/// the components necessary for a successful ritual
	var/list/required_components = list()

	/// the list that checks whether the components will be consumed
	var/list/consumed_components = list()

	/// if the ritual is successful, it will go through each item in the list to be spawned
	var/list/ritual_success_items

	/// the effect that is spawned when the components are consumed, etc.
	var/ritual_effect = /obj/effect/particle_effect/sparks

	/// the time it takes to process each stage of the ritual
	var/ritual_time = 5 SECONDS

	/// whether the ritual is in use
	var/in_use = FALSE

/datum/ash_ritual/proc/ritual_start(obj/effect/ash_rune/rune)

	if(in_use)
		return
	in_use = TRUE

	rune.balloon_alert_to_viewers("ritual has begun...")
	new ritual_effect(rune.loc)

	// it is entirely possible to have your own effects here... this is just a suggestion
	var/atom/movable/warp_effect/warp = new(rune)
	rune.vis_contents += warp

	sleep(ritual_time)

	if(!check_component_list(rune))
		rune.vis_contents -= warp
		warp = null
		return

	ritual_success(rune)

	// make sure to remove your effects at the end
	rune.vis_contents -= warp
	warp = null

/datum/ash_ritual/proc/check_component_list(obj/effect/ash_rune/checked_rune)
	for(var/checked_component in required_components)
		var/set_direction = text2dir(checked_component)
		var/turf/checked_turf = get_step(checked_rune, set_direction)
		var/atom_check = locate(required_components[checked_component]) in checked_turf.contents
		if(!atom_check)
			ritual_fail(checked_rune)
			return FALSE
		if(isliving(atom_check))
			var/mob/living/human_sacrifice = atom_check
			if(human_sacrifice.stat < DEAD)
				ritual_fail(checked_rune)
				return FALSE
		if(is_type_in_list(atom_check, consumed_components))
			qdel(atom_check)
			checked_rune.balloon_alert_to_viewers("[checked_component] component has been consumed...")

		else
			checked_rune.balloon_alert_to_viewers("[checked_component] component has been checked...")

		new ritual_effect(checked_rune.loc)
		sleep(ritual_time)

	return TRUE

/datum/ash_ritual/proc/ritual_fail(obj/effect/ash_rune/failed_rune)
	new ritual_effect(failed_rune.loc)
	failed_rune.balloon_alert_to_viewers("ritual has failed...")
	failed_rune.current_ritual = null
	in_use = FALSE
	return

/datum/ash_ritual/proc/ritual_success(obj/effect/ash_rune/success_rune)
	new ritual_effect(success_rune.loc)
	success_rune.balloon_alert_to_viewers("ritual has been successful...")
	log_game("[name] ritual has been successfully activated.")

	var/turf/rune_turf = get_turf(success_rune)
	if(length(ritual_success_items))
		for(var/type in ritual_success_items)
			new type(rune_turf)

	success_rune.current_ritual = null
	in_use = FALSE
	return TRUE

/// Staff Summon
/datum/ash_ritual/summon_staff
	name = "召唤灰烬法杖"
	desc = "召唤一根灌注了触须力量的法杖。需要母体触须的许可。"
	required_components = list(
		"north" = /obj/item/stack/sheet/mineral/wood,
		"south" = /obj/item/organ/monster_core/regenerative_core,
	)
	consumed_components = list(
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/organ/monster_core/regenerative_core,
	)
	ritual_success_items = list(
		/obj/item/ash_staff,
	)

/// Translation Necklace
/datum/ash_ritual/summon_necklace
	name = "召唤龙形项链"
	desc = "召唤一条赋予佩戴者我们语言知识的项链。"
	required_components = list(
		"north" = /obj/item/stack/sheet/bone,
		"south" = /obj/item/organ/monster_core/regenerative_core,
		"east" = /obj/item/stack/sheet/sinew,
		"west" = /obj/item/stack/sheet/sinew,
	)
	consumed_components = list(
		/obj/item/stack/sheet/bone,
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/stack/sheet/sinew,
	)
	ritual_success_items = list(
		/obj/item/clothing/neck/necklace/translator,
	)

/// Skeleton Key
/datum/ash_ritual/summon_key
	name = "召唤骷髅钥匙"
	desc = "召唤一把能打开来自陨落触须的箱子的钥匙。"
	required_components = list(
		"north" = /obj/item/stack/sheet/bone,
		"south" = /obj/item/stack/sheet/bone,
		"east" = /obj/item/stack/sheet/bone,
		"west" = /obj/item/stack/sheet/bone,
	)
	consumed_components = list(
		/obj/item/stack/sheet/bone,
	)
	ritual_success_items = list(
		/obj/item/skeleton_key,
	)

/// THIS IS A KNOIF
/datum/ash_ritual/summon_cursed_knife
	name = "召唤诅咒灰烬匕首"
	desc = "召唤一把能在摧毁我们标记触须的毫无戒心的矿工身上施加追踪诅咒的匕首。"
	required_components = list(
		"north" = /obj/item/organ/monster_core/regenerative_core,
		"south" = /obj/item/forging/reagent_weapon/dagger,
		"east" = /obj/item/stack/sheet/bone,
		"west" = /obj/item/stack/sheet/sinew,
	)
	consumed_components = list(
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/forging/reagent_weapon/dagger,
		/obj/item/stack/sheet/bone,
		/obj/item/stack/sheet/sinew,
	)
	ritual_success_items = list(
		/obj/item/cursed_dagger,
	)

/// Impregnate the ground with a Tendril
/datum/ash_ritual/summon_tendril_seed
	name = "召唤触须种子"
	desc = "召唤一颗种子，当在手中使用时，会在你的位置召唤出一根触须。"
	required_components = list(
		"north" = /obj/item/organ/monster_core/regenerative_core,
		"south" = /obj/item/cursed_dagger,
		"east" = /obj/item/crusher_trophy/goliath_tentacle,
		"west" = /obj/item/crusher_trophy/watcher_wing,
	)
	consumed_components = list(
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/cursed_dagger,
		/obj/item/crusher_trophy/goliath_tentacle,
		/obj/item/crusher_trophy/watcher_wing,
	)
	ritual_success_items = list(
		/obj/item/ash_seed/tendril,
	)

/// Spawns a new megafauna randomly in the ashen wastes
/datum/ash_ritual/incite_megafauna
	name = "激怒巨型生物"
	desc = "发出一种可怕、难以辨认的声音，将吸引星球各处的大型生物。"
	required_components = list(
		"north" = /obj/item/organ/legion_tumour,
		"south" = /obj/item/ash_seed/tendril,
		"east" = /obj/item/organ/legion_tumour,
		"west" = /obj/item/organ/legion_tumour,
	)
	consumed_components = list(
		/obj/item/organ/legion_tumour,
		/obj/item/ash_seed/tendril,
	)

/datum/ash_ritual/incite_megafauna/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()
	for(var/mob/select_mob in GLOB.player_list)
		if(select_mob.z != success_rune.z)
			continue

		to_chat(select_mob, span_userdanger("星球在骚动……又一头怪物降临了！"))
		playsound(get_turf(select_mob), 'sound/effects/magic/demon_attack1.ogg', 50, TRUE)
		flash_color(select_mob, flash_color = "#FF0000", flash_time = 3 SECONDS)

	var/megafauna_choice = pick(
		/mob/living/basic/boss/blood_drunk_miner,
		/mob/living/simple_animal/hostile/megafauna/dragon,
		/mob/living/simple_animal/hostile/megafauna/hierophant,
	)

	var/turf/spawn_turf = locate(rand(1,255), rand(1,255), success_rune.z)

	var/anti_endless = 0
	while(!istype(spawn_turf, /turf/open/misc/asteroid) && anti_endless < 100)
		spawn_turf = locate(rand(1,255), rand(1,255), success_rune.z)
		anti_endless++

	new /obj/effect/particle_effect/sparks(spawn_turf)
	addtimer(CALLBACK(src, PROC_REF(spawn_megafauna), megafauna_choice, spawn_turf), 3 SECONDS)

/**
 * Called within an addtimer in the ritual success of "Incite Megafauna."
 * ARG: chosen_megafauna is the megafauna that will be spawned
 * ARG: spawning_turf is the turf that the megafauna will be spawned on
 */
/datum/ash_ritual/incite_megafauna/proc/spawn_megafauna(chosen_megafauna, turf/spawning_turf)
	new chosen_megafauna(spawning_turf)

/// Age specific buffs - 20 minutes per 'maturation' period
/datum/ash_ritual/ash_ceremony
	name = "灰烬时代仪式"
	desc = "参与仪式并做好准备者将衰老，从而提升其对族人的价值。"
	required_components = list(
		"north" = /obj/item/organ/legion_tumour,
		"south" = /obj/item/organ/monster_core/regenerative_core,
		"east" = /obj/item/stack/sheet/bone,
		"west" = /obj/item/stack/sheet/sinew,
	)
	consumed_components = list(
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/organ/legion_tumour,
		/obj/item/stack/sheet/bone,
		/obj/item/stack/sheet/sinew,
	)

/datum/ash_ritual/ash_ceremony/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()
	for(var/mob/living/carbon/human/human_target in range(2, get_turf(success_rune)))
		SEND_SIGNAL(human_target, COMSIG_RUNE_EVOLUTION)

/// Summon specific lavaland critter
/datum/ash_ritual/summon_lavaland_creature
	name = "召唤熔岩地生物"
	desc = "从太空的另一区域召唤两只随机的野生怪物。"
	required_components = list(
		"north" = /obj/item/organ/monster_core/regenerative_core,
		"south" = /obj/item/stack/sheet/animalhide/ashdrake,
		"east" = /obj/item/stack/ore/bluespace_crystal,
		"west" = /obj/item/stack/ore/bluespace_crystal,
	)
	consumed_components = list(
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/stack/sheet/animalhide/ashdrake,
	)

/datum/ash_ritual/summon_lavaland_creature/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()
	for(var/iterate in 1 to 2)
		var/mob_type = pick(
			/mob/living/basic/mining/goliath,
			/mob/living/basic/mining/legion,
			/mob/living/basic/mining/brimdemon,
			/mob/living/basic/mining/watcher,
			/mob/living/basic/mining/lobstrosity/lava,
			/mob/living/basic/mining/bileworm,
		)
		new mob_type(success_rune.drop_location())

/// Colder versions of critters to summon
/datum/ash_ritual/summon_icemoon_creature
	name = "召唤冰月生物"
	desc = "从太空的另一区域召唤两只随机的野生怪物。"
	required_components = list(
		"north" = /obj/item/organ/monster_core/regenerative_core,
		"south" = /obj/item/food/grown/surik,
		"east" = /obj/item/stack/ore/bluespace_crystal,
		"west" = /obj/item/stack/ore/bluespace_crystal,
	)
	consumed_components = list(
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/food/grown/surik,
	)

/datum/ash_ritual/summon_icemoon_creature/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()
	for(var/iterate in 1 to 2)
		var/mob_type = pick(
			/mob/living/basic/mining/ice_demon,
			/mob/living/basic/mining/ice_whelp,
			/mob/living/basic/mining/lobstrosity,
			/mob/living/basic/mining/polarbear,
			/mob/living/basic/mining/wolf,
		)
		new mob_type(success_rune.drop_location())

/// Xenobio Ritual
/datum/ash_ritual/uncover_rocks
	name = "发掘奇异岩石"
	desc = "符文中心所有神秘的岩石都将试图自行显露。"
	required_components = list(
		"north" = /obj/item/stack/ore/bluespace_crystal,
		"south" = /obj/item/stack/sheet/animalhide/goliath_hide,
		"east" = /obj/item/xenoarch/brush,
		"west" = /obj/item/xenoarch/broken_item,
	)
	consumed_components = list(
		/obj/item/stack/sheet/animalhide/goliath_hide,
		/obj/item/xenoarch/broken_item,
	)

/datum/ash_ritual/uncover_rocks/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()
	for(var/obj/item/xenoarch/strange_rock/found_rock in range(2, get_turf(success_rune)))
		if(prob(30))
			continue

		found_rock.dug_depth = found_rock.item_depth
		found_rock.try_uncover()

/datum/ash_ritual/share_damage
	name = "分担受害者伤害"
	desc = "中心受害者的伤害将被分摊给周围其他存活的族人。"
	required_components = list(
		"north" = /obj/item/stack/sheet/bone,
		"south" = /obj/item/stack/sheet/sinew,
	)
	consumed_components = list(
		/obj/item/stack/sheet/bone,
		/obj/item/stack/sheet/sinew,
	)

/datum/ash_ritual/share_damage/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()

	var/mob/living/carbon/human/human_victim = locate() in get_turf(success_rune)
	if(!human_victim)
		return

	var/total_damage = human_victim.get_brute_loss() + human_victim.get_fire_loss()
	var/divide_damage = 0
	var/list/valid_humans = list()

	for(var/mob/living/carbon/human/human_share in range(2, get_turf(success_rune)))
		if(human_share == human_victim)
			continue

		if(human_share.stat == DEAD)
			continue

		valid_humans += human_share
		divide_damage++

	var/singular_damage = total_damage / divide_damage

	for(var/mob/living/carbon/human/human_target in valid_humans)
		human_target.adjust_brute_loss(singular_damage)

	human_victim.heal_overall_damage(human_victim.get_brute_loss(), human_victim.get_fire_loss())

/// Bye Felicia
/datum/ash_ritual/banish_kin
	name = "放逐族人"
	desc = "有些族人不适合部落，这可以通过民主方式解决该问题。"
	required_components = list()
	consumed_components = list()

/datum/ash_ritual/banish_kin/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()
	var/turf/src_turf = get_turf(success_rune)

	var/mob/living/carbon/human/find_banished = locate() in src_turf
	if(!find_banished)
		return

	if(!find_banished.mind.has_antag_datum(/datum/antagonist/ashwalker)) //must be an ashwalker
		return

	var/list/asked_voters = list()

	for(var/mob/living/carbon/human/poll_human in range(2, src_turf))
		if(poll_human.stat != CONSCIOUS) //must be conscious
			continue

		if(!poll_human.mind.has_antag_datum(/datum/antagonist/ashwalker)) //must be an ashwalker
			continue

		asked_voters += poll_human

	var/list/yes_voters = SSpolling.poll_candidates("Do you wish to banish [find_banished]?", poll_time = 10 SECONDS, group = asked_voters)

	if(length(yes_voters) < max(1, ceil(length(asked_voters) / 2 + 0.01))) // you need a simple majority (ex: 10 people vote, need 6)
		find_banished.balloon_alert_to_viewers("banishment failed!")
		return

	var/turf/teleport_turf = locate(rand(1,255), rand(1,255), success_rune.z)

	var/anti_endless = 0
	while(!istype(teleport_turf, /turf/open/misc/asteroid) && anti_endless < 100)
		teleport_turf = locate(rand(1,255), rand(1,255), success_rune.z)
		anti_endless++

	new /obj/effect/particle_effect/sparks(teleport_turf)
	find_banished.forceMove(teleport_turf)

/// Friend : )
/datum/ash_ritual/revive_animal
	name = "复活动物"
	desc = "复活一只简单的动物，之后它将变得友好。"
	required_components = list(
		"north" = /obj/item/organ/monster_core/regenerative_core,
		"south" = /obj/item/organ/monster_core/regenerative_core,
		"east" = /obj/item/stack/sheet/bone,
		"west" = /obj/item/stack/sheet/sinew,
	)
	consumed_components = list(
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/stack/sheet/bone,
		/obj/item/stack/sheet/sinew,
	)

/datum/ash_ritual/revive_animal/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()
	if(!revive_simple(success_rune))
		revive_basic(success_rune)

/datum/ash_ritual/revive_animal/proc/revive_simple(obj/effect/ash_rune/success_rune)
	var/turf/src_turf = get_turf(success_rune)

	var/mob/living/simple_animal/find_animal = locate() in src_turf

	if(!find_animal)
		return FALSE

	if(find_animal.stat != DEAD)
		return FALSE

	if(find_animal.sentience_type != SENTIENCE_ORGANIC)
		return FALSE

	find_animal.set_faction(list(FACTION_ASHWALKER))

	if(ishostile(find_animal))
		var/mob/living/simple_animal/hostile/hostile_animal = find_animal
		hostile_animal.attack_same = FALSE

	find_animal.revive(HEAL_ALL)
	return TRUE

/datum/ash_ritual/revive_animal/proc/revive_basic(obj/effect/ash_rune/success_rune)
	var/turf/src_turf = get_turf(success_rune)

	var/mob/living/basic/find_animal = locate() in src_turf

	if(!find_animal)
		return FALSE

	if(find_animal.health > 0)
		return FALSE

	if(find_animal.sentience_type != SENTIENCE_ORGANIC)
		return FALSE

	find_animal.set_faction(list(FACTION_ASHWALKER))

	find_animal.revive(HEAL_ALL)
	return TRUE

/// Pacification
/datum/ash_ritual/pacification
	name = "让你的身体与大地共鸣"
	desc = "安抚荒原中的生物，使其转而前来援助你，代价是你的战斗能力。"
	required_components = list(
		"north" = /obj/item/food/grown/ash_flora/fireblossom,
		"south" = /obj/item/organ/monster_core/regenerative_core,
		"east" = /obj/item/stack/sheet/sinew,
		"west" = /obj/item/stack/sheet/sinew,
	)
	consumed_components = list(
		/obj/item/food/grown/ash_flora/fireblossom,
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/stack/sheet/sinew,
	)

/datum/ash_ritual/pacification/ritual_success(obj/effect/ash_rune/success_rune)
	. = ..()
	for(var/mob/living/carbon/human/lizard_target in range(2, get_turf(success_rune)))
		lizard_target.add_faction(FACTION_MINING_FAUNA)
		ADD_TRAIT(lizard_target, TRAIT_PACIFISM, SPECIES_TRAIT)

/// Summon Ore Seed
/datum/ash_ritual/summon_ore_seed
	name = "召唤矿石种子"
	desc = "召唤一颗种子，当握在手中使用时，将导致一条触须钻穿地表外壳，形成一个矿石喷口。"
	required_components = list(
		"north" = /obj/item/crusher_trophy/legion_skull,
		"south" = /obj/item/organ/monster_core/regenerative_core,
		"east" = /obj/item/crusher_trophy/watcher_wing,
		"west" = /obj/item/crusher_trophy/goliath_tentacle,
	)
	consumed_components = list(
		/obj/item/crusher_trophy/legion_skull,
		/obj/item/organ/monster_core/regenerative_core,
		/obj/item/crusher_trophy/watcher_wing,
		/obj/item/crusher_trophy/goliath_tentacle,
	)
	ritual_success_items = list(
		/obj/item/ash_seed/vent,
	)

/// Summon Tunneling Worm
/datum/ash_ritual/summon_tunneling_worm
	name = "召唤掘地蠕虫"
	desc = "召唤一条能够创造相互连接的深层隧道的蠕虫。"
	required_components = list(
		"north" = /obj/item/crusher_trophy/bileworm_spewlet,
		"south" = /obj/item/organ/monster_core/regenerative_core,
		"east" = /obj/item/stack/ore/bluespace_crystal,
		"west" = /obj/item/stack/ore/bluespace_crystal,
	)
	consumed_components = list(
		/obj/item/crusher_trophy/bileworm_spewlet,
		/obj/item/organ/monster_core/regenerative_core,
	)
	ritual_success_items = list(
		/obj/item/tunneling_worm,
	)
