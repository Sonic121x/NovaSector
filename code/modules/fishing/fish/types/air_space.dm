/obj/item/fish/sand_surfer
	name = "沙地冲浪者"
	fish_id = "sand_surfer"
	desc = "一种生活在遥远沙地之下的青铜色外星“鱼”。"
	icon_state = "sand_surfer"
	sprite_height = 6
	sprite_width = 6
	stable_population = 5
	average_size = 65
	average_weight = 1100
	weight_size_deviation = 0.35
	random_case_rarity = FISH_RARITY_RARE
	required_fluid_type = AQUARIUM_FLUID_AIR
	required_temperature_min = MIN_AQUARIUM_TEMP+25
	required_temperature_max = MIN_AQUARIUM_TEMP+60
	fish_movement_type = /datum/fish_movement/plunger
	fishing_difficulty_modifier = 5
	fish_traits = list(/datum/fish_trait/shiny_lover)
	beauty = FISH_BEAUTY_GOOD

/obj/item/fish/sand_crab
	name = "掘穴蟹"
	fish_id = "sand_crab"
	desc = "一种栖息在沙地中的甲壳动物。它看起来像螃蟹，尝起来也像螃蟹，但走起路来像鱼。"
	icon_state = "crab"
	dedicated_in_aquarium_icon_state = "crab_small"
	sprite_height = 6
	sprite_width = 10
	average_size = 60
	average_weight = 1000
	weight_size_deviation = 0.1
	stable_population = 5
	required_fluid_type = AQUARIUM_FLUID_SALTWATER
	required_temperature_min = MIN_AQUARIUM_TEMP+20
	required_temperature_max = MIN_AQUARIUM_TEMP+40
	fillet_type = /obj/item/food/meat/slab/rawcrab
	fish_traits = list(/datum/fish_trait/amphibious, /datum/fish_trait/shiny_lover, /datum/fish_trait/carnivore)
	fish_movement_type = /datum/fish_movement/slow
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = SEAFOOD,
		),
	)

/obj/item/fish/sand_crab/get_fish_taste()
	return list("raw crab" = 2)

/obj/item/fish/sand_crab/get_fish_taste_cooked()
	return list("cooked crab" = 2)

/obj/item/fish/bumpy
	name = "碰撞鱼"
	fish_id = "bumpy"
	desc = "一条畸形的鱼状生物，浑身覆盖着粗短的触须。"
	icon_state = "bumpy"
	sprite_height = 4
	sprite_width = 5
	stable_population = 4
	required_fluid_type = AQUARIUM_FLUID_ANY_WATER
	required_temperature_min = MIN_AQUARIUM_TEMP+15
	required_temperature_max = MIN_AQUARIUM_TEMP+40
	beauty = FISH_BEAUTY_BAD
	fish_traits = list(/datum/fish_trait/amphibious, /datum/fish_trait/vegan)
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = VEGETABLES,
		),
	)

/obj/item/fish/starfish
	name = "宇宙海星"
	fish_id = "cosmostarfish"
	desc = "一种来自超空间的奇特、无视重力的棘皮动物样生物。"
	icon_state = "starfish"
	icon_state_dead = "starfish_dead"
	sprite_height = 3
	sprite_width = 4
	average_size = 30
	average_weight = 300
	stable_population = 3
	required_fluid_type = AQUARIUM_FLUID_AIR
	random_case_rarity = FISH_RARITY_NOPE
	required_temperature_min = 0
	required_temperature_max = INFINITY
	safe_air_limits = null
	min_pressure = 0
	max_pressure = INFINITY
	fillet_type = null
	fish_traits = list(/datum/fish_trait/antigrav, /datum/fish_trait/mixotroph)
	compatible_types = list(/obj/item/fish/starfish/chrystarfish)
	beauty = FISH_BEAUTY_GREAT

/obj/item/fish/starfish/Initialize(mapload, apply_qualities = TRUE)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/fish/starfish/fish_grind_results()
	return list(/datum/reagent/bluespace = 10)

/obj/item/fish/starfish/update_overlays()
	. = ..()
	. += add_emissive()

/obj/item/fish/starfish/proc/add_emissive()
	if(status == FISH_ALIVE)
		return emissive_appearance(icon, "starfish_emissive", src, effect_type = EMISSIVE_NO_BLOOM)

///It spins, and dimly glows in the dark.
/obj/item/fish/starfish/flop_animation()
	DO_FLOATING_ANIM(src)

/obj/item/fish/starfish/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 吞下了 [src]，并向上看去……"))
	if (prob(20))
		user.say("I must go. My people need me.", forced = "starfish suicide")
	addtimer(CALLBACK(src, PROC_REF(ascension), user), 1 SECONDS)
	return MANUAL_SUICIDE

/obj/item/fish/starfish/proc/ascension(mob/living/user)
	user.visible_message(span_suicide("[user] 抛弃了 [user.p_their()] 的肉体形态！"))
	user.drop_everything()
	user.add_filter("space", 1, layering_filter(icon = icon('icons/mob/human/textures.dmi', "spacey"), blend_mode = BLEND_INSET_OVERLAY))
	user.apply_status_effect(/datum/status_effect/go_away/deletes_mob)
	qdel(src)

/obj/item/fish/baby_carp
	name = "太空鲤鱼幼崽"
	fish_id = "baby_carp"
	desc = "可怕的太空鲤鱼的幼年个体。别被它无辜的外表骗了，它们是具有攻击性的小混蛋。"
	icon_state = "baby_carp"
	sprite_height = 3
	sprite_width = 5
	average_size = 35
	average_weight = 550
	stable_population = 7
	required_fluid_type = AQUARIUM_FLUID_ANY_WATER
	random_case_rarity = FISH_RARITY_VERY_RARE
	required_temperature_min = 0
	required_temperature_max = MIN_AQUARIUM_TEMP+200
	safe_air_limits = null
	fillet_type = /obj/item/food/fishmeat/carp/no_tox
	fish_traits = list(
		/datum/fish_trait/carnivore,
		/datum/fish_trait/territorial,
		/datum/fish_trait/predator,
		/datum/fish_trait/necrophage,
		/datum/fish_trait/no_mating,
		/datum/fish_trait/toxic/carpotoxin,
	)
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = MEAT,
		),
	)
	disliked_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = GRAIN|DAIRY,
		),
	)
	beauty = FISH_BEAUTY_GREAT

/obj/item/fish/baby_carp/Initialize(mapload, apply_qualities = TRUE)
	color = pick_weight(GLOB.carp_colors)
	. = ..()
	RegisterSignal(src, COMSIG_FISH_BEFORE_GROWING, PROC_REF(growth_checks))
	RegisterSignal(src, COMSIG_FISH_FINISH_GROWING, PROC_REF(on_growth))
	update_appearance(UPDATE_OVERLAYS)

/obj/item/fish/baby_carp/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 把 [src] 整个吞了下去！"))
	src.forceMove(user)
	if(status == FISH_DEAD)
		user.emote("gasp")
		user.visible_message(span_suicide("[user] 被 [src] 噎住并死去了！"))
		return OXYLOSS

	// the fish grows
	addtimer(CALLBACK(src, PROC_REF(gestation), user), 20 SECONDS)
	user.visible_message(span_suicide("[user] 开始不自然地生长……"))

	var/matrix/M = matrix()
	M.Scale(1.8, 1.2)
	animate(user, time = 20 SECONDS, transform = M, easing = SINE_EASING)
	return MANUAL_SUICIDE

/obj/item/fish/baby_carp/proc/gestation(mob/living/user)
	if(QDELETED(user) || QDELETED(src))
		return
	// carp grow big and strong inside the nutritious innards of the human
	var/mob/living/basic/carp/mega/babby = new(get_turf(user))
	babby.name = user.name + "二世"

	var/obj/item/bodypart/chest = user.get_bodypart(BODY_ZONE_CHEST)
	if(chest)
		babby.set_greyscale(chest.species_color) // this isn't working. why isnt this working

	user.gib(DROP_ALL_REMAINS)
	qdel(src)

/obj/item/fish/baby_carp/update_overlays()
	. = ..()
	var/mutable_appearance/eyes = mutable_appearance(icon, "baby_carp_eyes")
	if(status == FISH_DEAD)
		eyes.icon_state += "_dead"
	else
		eyes.appearance_flags = RESET_COLOR|KEEP_APART
	. += eyes

///Determines the speed at which the carp grows based on how big it's
/obj/item/fish/baby_carp/update_size_and_weight(new_size = average_size, new_weight = average_weight, update_materials = TRUE)
	. = ..()
	var/growth_rate = 4.5 MINUTES
	growth_rate *= clamp(size/average_size, 0.5, 2)
	growth_rate *= clamp(weight/average_weight, 0.5, 2)

	AddComponent(/datum/component/fish_growth, /mob/living/basic/carp/advanced, growth_rate)

/obj/item/fish/baby_carp/proc/growth_checks(datum/source, seconds_per_tick, growth, result_path)
	SIGNAL_HANDLER
	var/hunger = CLAMP01((world.time - last_feeding) / feeding_frequency)
	if(get_health_percentage() <= 0.6 || hunger >= 0.6) //if too hurt or hungry, don't grow.
		return COMPONENT_DONT_GROW

	if(!loc || !HAS_TRAIT(loc, TRAIT_IS_AQUARIUM))
		return

	if(HAS_TRAIT(loc, TRAIT_STOP_FISH_REPRODUCTION_AND_GROWTH)) //the aquarium has breeding disabled
		return COMPONENT_DONT_GROW
	if(length(get_aquarium_fishes()) > AQUARIUM_MAX_BREEDING_POPULATION * 0.5) //check if there's enough room to maturate.
		return COMPONENT_DONT_GROW

/obj/item/fish/baby_carp/proc/on_growth(datum/source, mob/living/basic/carp/result)
	SIGNAL_HANDLER
	//yes, this means that if we use a spraycan on the fish, the resulting space carp will be of spraycan color
	result.set_greyscale(colors = list(color))

#define PERSISTENCE_FISH_CARP_COLOR "carp_color"

/obj/item/fish/baby_carp/persistence_save(list/data)
	data[PERSISTENCE_FISH_CARP_COLOR] = color

/obj/item/fish/baby_carp/persistence_load(list/data)
	add_atom_colour(data[PERSISTENCE_FISH_CARP_COLOR], FIXED_COLOUR_PRIORITY)

#undef PERSISTENCE_FISH_CARP_COLOR
