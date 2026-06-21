/obj/item/fish/clownfish
	name = "小丑鱼"
	fish_id = "clownfish"
	desc = "小丑鱼通过游到礁石上吸引更大的鱼，并将它们引诱回海葵处来捕食。海葵会蜇伤并吃掉大鱼，留下残骸给小丑鱼。"
	icon_state = "clownfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 7
	sprite_height = 4
	average_size = 30
	average_weight = 500
	stable_population = 4
	fish_traits = list(/datum/fish_trait/picky_eater)
	evolution_types = list(/datum/fish_evolution/lubefish)
	compatible_types = list(/obj/item/fish/clownfish/lube)
	required_temperature_min = MIN_AQUARIUM_TEMP+22
	required_temperature_max = MIN_AQUARIUM_TEMP+30

/obj/item/fish/clownfish/get_fish_taste()
	return list("raw fish" = 2, "something funny" = 1)

/obj/item/fish/clownfish/lube
	name = "润滑鱼"
	fish_id = "lube"
	desc = "一条暴露在樱桃味润滑剂中过久的小丑鱼。首次发现于欧罗巴海域一次货物事故后的几天，当时成千上万成千上万成千上万..."
	icon_state = "lubefish"
	random_case_rarity = FISH_RARITY_VERY_RARE
	fish_traits = list(/datum/fish_trait/picky_eater, /datum/fish_trait/lubed)
	evolution_types = null
	compatible_types = list(/obj/item/fish/clownfish)
	food = /datum/reagent/lube
	fishing_difficulty_modifier = 5
	beauty = FISH_BEAUTY_GREAT

// become lubeman. but you suicide
/obj/item/fish/clownfish/lube/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]用[src]的残留物覆盖全身，然后将其整个吞下！看起来[user.p_theyre()]想进行润滑自杀！"))
	user.AddComponent(/datum/component/slippery, 8 SECONDS, SLIDE|GALOSHES_DONT_HELP)
	user.AddElement(/datum/element/lube_walking)
	qdel(src)
	return OXYLOSS

/obj/item/fish/cardinal
	name = "天竺鲷"
	fish_id = "cardinal"
	desc = "天竺鲷常出现在海胆附近，受到威胁时鱼会躲藏其中。"
	icon_state = "cardinalfish"
	sprite_width = 6
	sprite_height = 3
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 4
	fish_traits = list(/datum/fish_trait/vegan)
	required_temperature_min = MIN_AQUARIUM_TEMP+22
	required_temperature_max = MIN_AQUARIUM_TEMP+30

/obj/item/fish/greenchromis
	name = "绿光鳃鱼"
	fish_id = "greenchromis"
	desc = "光鳃鱼的颜色可从蓝色到绿色变化，具体取决于光照条件和与光源的距离。"
	icon_state = "greenchromis"
	sprite_width = 5
	sprite_height = 3
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 5
	required_temperature_min = MIN_AQUARIUM_TEMP+23
	required_temperature_max = MIN_AQUARIUM_TEMP+28

	fishing_difficulty_modifier = 5 // Bit harder

/obj/item/fish/firefish
	name = "火鱼虾虎鱼"
	fish_id = "firefish"
	desc = "在野外，火鱼通过背鳍来警示同伴潜在的危险。"
	icon_state = "firefish"
	sprite_width = 5
	sprite_height = 3
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	average_size = 30
	average_weight = 500
	stable_population = 3
	disliked_bait = list(/obj/item/food/bait/worm, /obj/item/food/bait/doughball)
	fish_movement_type = /datum/fish_movement/zippy
	required_temperature_min = MIN_AQUARIUM_TEMP+23
	required_temperature_max = MIN_AQUARIUM_TEMP+28

/obj/item/fish/pufferfish
	name = "河豚"
	fish_id = "pufferfish"
	desc = "据说一条河豚所含的毒素足以杀死30个人，尽管在过去的几十年里，它们已被大规模基因改造，毒性有所降低。"
	icon_state = "pufferfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_width = 8
	sprite_height = 6
	average_size = 60
	average_weight = 1000
	stable_population = 3
	required_temperature_min = MIN_AQUARIUM_TEMP+23
	required_temperature_max = MIN_AQUARIUM_TEMP+28
	fillet_type = /obj/item/food/fishmeat/quality //Too bad they're poisonous
	fish_traits = list(/datum/fish_trait/heavy, /datum/fish_trait/toxic)
	beauty = FISH_BEAUTY_GOOD

/obj/item/fish/pufferfish/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]咬住[src]并开始吮吸！看起来[user.p_theyre()]想自杀！"))
	return TOXLOSS

/obj/item/fish/lanternfish
	name = "灯笼鱼"
	fish_id = "lanternfish"
	desc = "通常生活在海面以下6600英尺的区域，它们生活在完全的黑暗中。"
	icon_state = "lanternfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	random_case_rarity = FISH_RARITY_VERY_RARE
	sprite_width = 6
	sprite_height = 5
	average_size = 50
	average_weight = 1000
	stable_population = 3
	fish_traits = list(/datum/fish_trait/nocturnal)
	required_temperature_min = MIN_AQUARIUM_TEMP+2 //My source is that the water at a depth 6600 feet is pretty darn cold.
	required_temperature_max = MIN_AQUARIUM_TEMP+18
	beauty = FISH_BEAUTY_NULL

/obj/item/fish/stingray
	name = "黄貂鱼"
	fish_id = "stingray"
	desc = "一种鳐鱼，以其有毒的尾刺而闻名。尽管如此，它们通常很温顺，只是有点容易受惊。"
	icon_state = "stingray"
	stable_population = 4
	sprite_height = 7
	sprite_width = 8
	average_size = 60
	average_weight = 700
	beauty = FISH_BEAUTY_GREAT
	random_case_rarity = FISH_RARITY_RARE
	required_fluid_type = AQUARIUM_FLUID_SALTWATER //Someone ought to add river rays later I guess.
	fish_traits = list(/datum/fish_trait/stinger, /datum/fish_trait/toxic_barbs, /datum/fish_trait/wary, /datum/fish_trait/carnivore, /datum/fish_trait/predator)

/obj/item/fish/swordfish
	name = "剑鱼"
	fish_id = "swordfish"
	desc = "一种大型长嘴鱼，以其细长的吻部最为著名，同时也因其烹饪价值而广受欢迎，在经验丰富的太空渔民手中更是一件可怕的武器。"
	icon = 'icons/obj/aquarium/wide.dmi'
	icon_state = "swordfish"
	inhand_icon_state = "swordfish"
	force = 18
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts", "pierces")
	attack_verb_simple = list("slash", "cut", "pierce")
	block_sound = 'sound/items/weapons/parry.ogg'
	hitsound = 'sound/items/weapons/rapierhit.ogg'
	demolition_mod = 0.75
	attack_speed = 1 SECONDS
	block_chance = 50
	wound_bonus = 10
	exposed_wound_bonus = 20
	armour_penetration = 75
	base_pixel_w = -18
	pixel_w = -18
	sprite_width = 13
	sprite_height = 6
	stable_population = 3
	average_size = 140
	average_weight = 4000
	breeding_timeout = 4.5 MINUTES
	feeding_frequency = 4 MINUTES
	max_integrity = 360
	beauty = FISH_BEAUTY_EXCELLENT
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	fish_movement_type = /datum/fish_movement/plunger
	fishing_difficulty_modifier = 25
	fillet_type = /obj/item/food/fishmeat/quality
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = SEAFOOD,
		),
		/obj/item/fish,
	)
	fish_traits = list(/datum/fish_trait/carnivore, /datum/fish_trait/predator, /datum/fish_trait/stinger)

/obj/item/fish/swordfish/get_force_rank()
	switch(w_class)
		if(WEIGHT_CLASS_TINY)
			force -= 11
			attack_speed -= 0.4 SECONDS
			block_chance -= 45
			armour_penetration -= 20
			wound_bonus -= 15
			exposed_wound_bonus -= 20
		if(WEIGHT_CLASS_SMALL)
			force -= 8
			attack_speed -= 0.3 SECONDS
			block_chance -= 30
			armour_penetration -= 15
			wound_bonus -= 10
			exposed_wound_bonus -= 20
		if(WEIGHT_CLASS_NORMAL)
			force -= 5
			attack_speed -= 0.2 SECONDS
			block_chance -= 20
			armour_penetration -= 10
			wound_bonus -= 10
			exposed_wound_bonus -= 15
		if(WEIGHT_CLASS_BULKY)
			force -= 3
			attack_speed -= 0.1 SECONDS
			block_chance -= 10
			armour_penetration -= 5
			wound_bonus -= 5
			exposed_wound_bonus -= 10
		if(WEIGHT_CLASS_GIGANTIC)
			force += 5
			attack_speed += 0.2 SECONDS
			demolition_mod += 0.15
			block_chance += 10
			armour_penetration += 5
			wound_bonus += 5
			exposed_wound_bonus += 10

	if(status == FISH_DEAD)
		force -= 4 + w_class
		block_chance -= 25
		armour_penetration -= 30
		wound_bonus -= 10
		exposed_wound_bonus -= 10

/obj/item/fish/swordfish/calculate_fish_force_bonus(bonus_malus)
	. = ..()
	armour_penetration += bonus_malus * 5
	wound_bonus += bonus_malus * 3
	exposed_wound_bonus += bonus_malus * 5
	block_chance += bonus_malus * 7

/obj/item/fish/squid
	name = "鱿鱼"
	fish_id = "squid"
	desc = "一种细长的软体动物，有八条触手，拥有天然伪装能力并能向捕食者喷射墨汁。是现存最聪明、装备最精良的无脊椎动物之一。"
	icon_state = "squid"
	sprite_width = 4
	sprite_height = 5
	stable_population = 6
	weight_size_deviation = 0.5 // They vary greatly in size.
	average_weight = 500 //They're quite lighter than they're long.
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	beauty = FISH_BEAUTY_GOOD
	required_temperature_min = MIN_AQUARIUM_TEMP+5
	required_temperature_max = MIN_AQUARIUM_TEMP+26
	fish_traits = list(/datum/fish_trait/heavy, /datum/fish_trait/carnivore, /datum/fish_trait/predator, /datum/fish_trait/ink, /datum/fish_trait/camouflage, /datum/fish_trait/wary)

/obj/item/fish/squid/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]将[src]的墨腺对准自己的脸，然后使出了吃奶的力气按压！看起来[user.p_theyre()]想搞鱿鱼自杀！"))

	// No head? Bozo.
	var/obj/item/bodypart/head = user.get_bodypart(BODY_ZONE_HEAD)
	if(isnull(head))
		user.visible_message(span_suicide("[user]没有头！墨汁喷了个空！"))
		return SHAME

	// get inked.
	user.visible_message(span_warning("[user]被[src]喷了一脸墨！"), span_userdanger("你被[src]喷了一脸墨！"))
	user.AddComponent(/datum/component/face_decal/splat, \
		color = COLOR_NEARLY_ALL_BLACK, \
		memory_type = /datum/memory/witnessed_inking, \
		mood_event_type = /datum/mood_event/inked, \
	)
	playsound(user, SFX_DESECRATION, 50, TRUE)

	if(!HAS_TRAIT(user, TRAIT_STRENGTH) && !HAS_TRAIT(user, TRAIT_HULK))
		return OXYLOSS

	head.dismember(silent = FALSE)
	user.visible_message(span_suicide("[user]的脑袋被超压墨汁喷流给冲飞了！"))
	return MANUAL_SUICIDE

/obj/item/fish/squid/get_fish_taste()
	return list("raw mollusk" = 2)

/obj/item/fish/squid/get_fish_taste_cooked()
	return list("cooked mollusk" = 2, "tenderness" = 0.5)

/obj/item/fish/monkfish
	name = "鮟鱇鱼"
	fish_id = "monkfish"
	desc = "鮟鱇科鱼类的一员。它有好几个不同的名字，但哪个名字都无法让它看起来更漂亮，也无法让它变得不那么美味。"
	icon_state = "monkfish"
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	sprite_height = 7
	sprite_width = 7
	beauty = FISH_BEAUTY_UGLY
	required_temperature_min = MIN_AQUARIUM_TEMP+2
	required_temperature_max = MIN_AQUARIUM_TEMP+23
	average_size = 60
	average_weight = 1400
	stable_population = 4
	fish_traits = list(/datum/fish_trait/heavy)
	fillet_type = /obj/item/food/fishmeat/quality
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = SEAFOOD|BUGS,
		),
	)

/obj/item/fish/monkfish/Initialize(mapload, apply_qualities = TRUE)
	. = ..()
	name = pick("鮟鱇鱼", "钓鱼蛙", "蛙鱼", "海魔鱼", "鹅鱼")

/obj/item/fish/plaice
	name = "欧鲽"
	fish_id = "plaice"
	desc = "或许是太空市场上最著名的比目鱼。大自然这次真的拿出了擀面杖。"
	icon_state = "plaice"
	sprite_height = 7
	sprite_width = 6
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	required_temperature_min = MIN_AQUARIUM_TEMP+2
	required_temperature_max = MIN_AQUARIUM_TEMP+18
	average_size = 40
	average_weight = 700
	stable_population = 5
	fish_traits = list(/datum/fish_trait/heavy)
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = SEAFOOD|BUGS,
		),
	)

