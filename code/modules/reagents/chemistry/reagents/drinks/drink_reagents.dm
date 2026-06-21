/datum/reagent/consumable/orangejuice
	name = "Orange Juice"
	description = "既美味又富含维生素C，你还需要什么呢？"
	color = "#E78108" // rgb: 231, 129, 8
	taste_description = "oranges"
	ph = 3.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/orangejuice

/datum/reagent/consumable/orangejuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.get_oxy_loss() && SPT_PROB(16, seconds_per_tick))
		if(affected_mob.adjust_oxy_loss(-0.5 * metabolization_ratio, FALSE, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/tomatojuice
	name = "Tomato Juice"
	description = "番茄做成的汁。真是浪费了又大又多汁的番茄，对吧？"
	color = "#731008" // rgb: 115, 16, 8
	taste_description = "tomatoes"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/tomatojuice

/datum/reagent/consumable/tomatojuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.get_fire_loss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(brute = 0, burn = 0.5 * metabolization_ratio, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/limejuice
	name = "Lime Juice"
	description = "青柠酸甜的汁液。"
	color = "#a6f19a" // rgb: 166, 241, 154
	taste_description = "unbearable sourness"
	ph = 2.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/limejuice

/datum/reagent/consumable/limejuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.get_tox_loss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.adjust_tox_loss(-0.5 * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/carrotjuice
	name = "Carrot Juice"
	description = "就像胡萝卜一样，只是不用嚼。"
	color = "#973800" // rgb: 151, 56, 0
	taste_description = "carrots"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/carrotjuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_eye_blur(-1 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_temp_blindness(-1 SECONDS * metabolization_ratio * seconds_per_tick)
	var/need_mob_update
	switch(current_cycle)
		if(21 to 110)
			if(SPT_PROB(100 * (1 - (sqrt(110 - current_cycle) / 10)), seconds_per_tick))
				need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_EYES, -1 * metabolization_ratio)
		if(110 to INFINITY)
			need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_EYES, -1 * metabolization_ratio * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/berryjuice
	name = "Berry Juice"
	description = "多种浆果的美味混合。"
	color = "#863333" // rgb: 134, 51, 51
	taste_description = "berries"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/applejuice
	name = "Apple Juice"
	description = "苹果的甜美果汁，适合所有年龄段。"
	color = "#fff06b" // rgb: 255, 240, 107
	taste_description = "apples"
	ph = 3.2 // ~ 2.7 -> 3.7

/datum/reagent/consumable/poisonberryjuice
	name = "Poison Berry Juice"
	description = "由多种剧毒浆果混合而成的美味果汁。"
	color = "#792b49" // rgb: 121, 43, 73
	taste_description = "berries"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/poisonberryjuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_tox_loss(0.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/watermelonjuice
	name = "Watermelon Juice"
	description = "用西瓜制成的美味果汁。"
	color = "#af5e5e" // rgb: 175, 94, 94
	taste_description = "juicy watermelon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/lemonjuice
	name = "Lemon Juice"
	description = "这果汁非常酸。"
	color = "#ebeb9e" // rgb: 235, 235, 158
	taste_description = "sourness"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/lemonjuice

/datum/reagent/consumable/banana
	name = "Banana Juice"
	description = "纯正香蕉精华。HONK"
	color = "#FFFCB9" // rgb: 255, 252, 185
	taste_description = "banana"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/banana/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/obj/item/organ/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM)) || is_simian(affected_mob))
		if(affected_mob.heal_bodypart_damage(brute = 0.5 * metabolization_ratio * seconds_per_tick, burn = 0.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/nothing
	name = "Nothing"
	description = "绝对的空无一物。"
	taste_description = "nothing"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/glass_style/shot_glass/nothing
	required_drink_type = /datum/reagent/consumable/nothing
	icon_state = "shotglass"

/datum/reagent/consumable/nothing/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(ishuman(drinker) && HAS_MIND_TRAIT(drinker, TRAIT_MIMING))
		drinker.set_silence_if_lower(MIMEDRINK_SILENCE_DURATION)
		if(drinker.heal_bodypart_damage(brute = 0.5 * metabolization_ratio * seconds_per_tick, burn = 0.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/laughter
	name = "Laughter"
	description = "有人说这是最好的良药，但最近的研究证明并非如此。"
	metabolization_rate = INFINITY
	color = "#FF4DD2"
	taste_description = "laughter"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/laughter/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tic, metabolization_ratio)
	. = ..()
	affected_mob.emote("laugh")
	affected_mob.add_mood_event("chemical_laughter", /datum/mood_event/chemical_laughter)

/datum/reagent/consumable/superlaughter
	name = "Super Laughter"
	description = "好笑，直到笑的是你自己。"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	color = "#FF4DD2"
	taste_description = "laughter"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/superlaughter/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(16, seconds_per_tick))
		affected_mob.visible_message(span_danger("[affected_mob] bursts out into a fit of uncontrollable laughter!"), span_userdanger("You burst out in a fit of uncontrollable laughter!"))
		affected_mob.Stun(5)
		affected_mob.add_mood_event("chemical_laughter", /datum/mood_event/chemical_superlaughter)

/datum/reagent/consumable/potato_juice
	name = "Potato Juice"
	description = "土豆的汁液。呃。"
	nutriment_factor = 2
	color = "#E8A856" // rgb: 234, 157, 58
	taste_description = "irish sadness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/pickle
	name = "Pickle Juice"
	description = "更准确地说，这是腌黄瓜漂浮着的卤水"
	nutriment_factor = 2
	color = "#cde65e" // rgb: 205, 230, 94
	taste_description = "vinegar brine"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/pickle/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/obj/item/organ/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_CORONER_METABOLISM)))
		if(affected_mob.adjust_tox_loss(-0.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/grapejuice
	name = "Grape Juice"
	description = "一串葡萄的汁液。保证不含酒精。"
	color = "#290029" // dark purple
	taste_description = "grape soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/plumjuice
	name = "Plum Juice"
	description = "清爽且略带酸味的饮料。"
	color = "#b6062c"
	taste_description = "plums"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/milk
	name = "Milk-奶"
	description = "哺乳动物乳腺产生的不透明白色液体。"
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "milk"
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/condiment/milk

// Milk is good for humans, but bad for plants.
// The sugars cannot be used by plants, and the milk fat harms growth. Except shrooms.
/datum/reagent/consumable/milk/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_waterlevel(round(volume * 0.3))
	var/obj/item/seeds/myseed = mytray.myseed
	if(isnull(myseed) || myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
		return
	myseed.adjust_potency(-round(volume * 0.5))

/datum/reagent/consumable/milk/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	if(affected_mob.get_brute_loss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(brute = 0.5 * metabolization_ratio, burn = 0, updating_health = FALSE))
			. = UPDATE_MOB_HEALTH
	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, seconds_per_tick)
	return ..() || .

/datum/reagent/consumable/milk/used_on_fish(obj/item/fish/fish)
	if(HAS_TRAIT(fish, TRAIT_FISH_MADE_OF_BONE))
		fish.repair_damage(fish.max_integrity * max(fish.get_hunger() * 0.5, 0.12))
		fish.sate_hunger()
		return TRUE

/datum/reagent/consumable/soymilk
	name = "Soy Milk-豆奶"
	description = "由大豆制成的不透明白色液体。"
	color = "#DFDFC7" // rgb: 223, 223, 199
	taste_description = "soy milk"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/condiment/soymilk

/datum/reagent/consumable/soymilk/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.get_brute_loss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(1, 0))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/cream
	name = "Cream-奶油"
	description = "牛奶中仍呈液态的脂肪部分。为什么不把它和苏格兰威士忌混合一下呢？"
	color = "#DFD7AF" // rgb: 223, 215, 175
	taste_description = "creamy milk"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/cream

/datum/reagent/consumable/cream/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick) && affected_mob.heal_bodypart_damage(1, 0))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/coffee
	name = "Coffee-咖啡"
	description = "咖啡是一种用咖啡植物的烘焙种子（通常称为咖啡豆）冲泡而成的饮品。"
	color = "#482000" // rgb: 72, 32, 0
	nutriment_factor = 0
	overdose_threshold = 80
	taste_description = "bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/coffee/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/coffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.AdjustSleeping(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	//310.15 is the normal bodytemp.
	affected_mob.adjust_bodytemperature(12.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 2.5 * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/tea
	name = "Tea-茶"
	description = "美味的红茶，含有抗氧化剂，对你有好处！"
	color = "#101000" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "tart black tea"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK
	default_container = /obj/item/reagent_containers/cup/glass/mug/tea
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/tea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-1 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_jitter(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.AdjustSleeping(-1 SECONDS * metabolization_ratio * seconds_per_tick)
	if(affected_mob.get_tox_loss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.adjust_tox_loss(-0.5 * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	affected_mob.adjust_bodytemperature(10 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())

	var/to_chatted = FALSE
	for(var/datum/wound/iter_wound as anything in affected_mob.all_wounds)
		if(SPT_PROB(10, seconds_per_tick))
			var/helped = iter_wound.tea_life_process()
			if(!to_chatted && helped)
				to_chat(affected_mob, span_notice("一股平静、放松的感觉弥漫全身。你的伤口感觉好了一些。"))
			to_chatted = TRUE

// Different handling, different name.
// Returns FALSE by default so broken bones and 'loss' wounds don't give a false message
/datum/wound/proc/tea_life_process()
	return FALSE

// Slowly increase (gauzed) clot rate
/datum/wound/pierce/bleed/tea_life_process()
	gauzed_clot_rate += 0.1
	return TRUE

// Slowly increase clot rate
/datum/wound/slash/flesh/tea_life_process()
	clot_rate += 0.2
	return TRUE

// There's a designated burn process, but I felt this would be better for consistency with the rest of the reagent's procs
/datum/wound/burn/flesh/tea_life_process()
	// Sanitizes and heals, but with a limit
	flesh_healing = (flesh_healing > 0.1) ? flesh_healing : flesh_healing + 0.02
	infection_rate = max(infection_rate - 0.005, 0)
	return TRUE

/datum/reagent/consumable/lemonade
	name = "Lemonade-柠檬水"
	description = "香甜、浓郁的柠檬水。有益于灵魂。"
	color = "#FFE978"
	quality = DRINK_NICE
	taste_description = "sunshine and summertime"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/tea/arnold_palmer
	name = "阿诺德·帕尔默"
	description = "鼓励病人去打高尔夫。"
	color = "#FFB766"
	quality = DRINK_NICE
	nutriment_factor = 10
	taste_description = "bitter tea"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/tea/arnold_palmer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[pick("You remember to square your shoulders.","You remember to keep your head down.","You can't decide between squaring your shoulders and keeping your head down.","You remember to relax.","You think about how someday you'll get two strokes off your golf game.")]"))

/datum/reagent/consumable/icecoffee
	name = "冰咖啡"
	description = "咖啡加冰，清爽又凉爽。"
	color = "#462b15" // rgb: 70, 43, 21
	nutriment_factor = 0
	overdose_threshold = 80
	taste_description = "bitter coldness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/icecoffee/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/icecoffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.AdjustSleeping(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/hot_ice_coffee
	name = "热冰咖啡"
	description = "带有脉动冰晶的咖啡"
	color = "#462b15" // rgb: 70, 43, 21
	nutriment_factor = 0
	overdose_threshold = 80
	taste_description = "bitter coldness and a hint of smoke"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/hot_ice_coffee/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/hot_ice_coffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.AdjustSleeping(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-3.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	if(affected_mob.adjust_tox_loss(0.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/icetea
	name = "冰茶"
	description = "与某位说唱歌手/演员无关。"
	color = "#104038" // rgb: 16, 64, 56
	nutriment_factor = 0
	taste_description = "sweet tea"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/icetea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-1 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.AdjustSleeping(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	if(affected_mob.get_tox_loss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.adjust_tox_loss(-0.5 * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	affected_mob.adjust_bodytemperature(-2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/space_cola
	name = "Cola-可乐"
	description = "一种清爽的饮料。"
	color = "#100800" // rgb: 16, 8, 0
	taste_description = "cola"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/space_cola/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_drowsiness(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/roy_rogers
	name = "罗伊·罗杰斯"
	description = "一种甜味的起泡饮料。"
	color = "#53090B"
	quality = DRINK_GOOD
	taste_description = "fruity overlysweet cola"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/roy_rogers/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	affected_mob.set_jitter_if_lower(6 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/nuka_cola
	name = "Nuka Cola-核子可乐"
	description = "可乐，可乐永不改变。"
	color = "#100800" // rgb: 16, 8, 0
	quality = DRINK_VERYGOOD
	taste_description = "the future"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/nuka_cola/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/reagent/nuka_cola)

/datum/reagent/consumable/nuka_cola/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/nuka_cola)

/datum/reagent/consumable/nuka_cola/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(20 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.set_drugginess(30 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_dizzy(1.5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.remove_status_effect(/datum/status_effect/drowsiness)
	affected_mob.AdjustSleeping(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, affected_mob.get_body_temp_normal())
	if (SSradiation.can_irradiate_basic(affected_mob))
		affected_mob.AddComponent(/datum/component/irradiated)

/datum/reagent/consumable/rootbeer
	name = "root beer-根汁汽水"
	description = "一种令人愉悦的起泡根汁啤酒，充满了如此多的糖分，以至于它实际上可以加快使用者的扳机指速度。"
	color = "#181008" // rgb: 24, 16, 8
	quality = DRINK_VERYGOOD
	nutriment_factor = 10
	metabolization_rate = 2 * REAGENTS_METABOLISM
	taste_description = "a monstrous sugar rush"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	/// If we activated the effect
	var/effect_enabled = FALSE

/datum/reagent/consumable/rootbeer/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_DOUBLE_TAP, type)
	if(current_cycle > 10)
		to_chat(affected_mob, span_warning("You feel kinda tired as your sugar rush wears off..."))
		affected_mob.adjust_stamina_loss(min(80, current_cycle * 3), required_biotype = affected_biotype)
		affected_mob.adjust_drowsiness((current_cycle-1) * 2 SECONDS)

/datum/reagent/consumable/rootbeer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle > 3 && !effect_enabled) // takes a few seconds for the bonus to kick in to prevent microdosing
		to_chat(affected_mob, span_notice("You feel your trigger finger getting itchy..."))
		ADD_TRAIT(affected_mob, TRAIT_DOUBLE_TAP, type)
		effect_enabled = TRUE

	affected_mob.set_jitter_if_lower(1 SECONDS * metabolization_ratio * seconds_per_tick)
	if(prob(50))
		affected_mob.adjust_dizzy(0.5 SECONDS * metabolization_ratio * seconds_per_tick)
	if(current_cycle > 10)
		affected_mob.adjust_dizzy(0.75 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/grey_bull
	name = "Grey Bull"
	description = "灰牛，它给你手套！"
	color = "#EEFF00" // rgb: 238, 255, 0
	quality = DRINK_VERYGOOD
	taste_description = "carbonated oil"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_SHOCKIMMUNE)

/datum/reagent/consumable/grey_bull/on_mob_metabolize(mob/living/carbon/affected_atom)
	. = ..()
	var/obj/item/organ/liver/liver = affected_atom.get_organ_slot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_MAINTENANCE_METABOLISM))
		affected_atom.add_mood_event("maintenance_fun", /datum/mood_event/maintenance_high)
		metabolization_rate *= 0.8

/datum/reagent/consumable/grey_bull/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(20 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_dizzy(1 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.remove_status_effect(/datum/status_effect/drowsiness)
	affected_mob.AdjustSleeping(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/spacemountainwind
	name = "SM Wind"
	description = "像太空风一样吹透你的身体。"
	color = "#102000" // rgb: 16, 32, 0
	taste_description = "sweet citrus soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/spacemountainwind/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_drowsiness(-7 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.AdjustSleeping(-1 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	affected_mob.set_jitter_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/dr_gibb
	name = "Dr. Gibb"
	description = "胡言博士，并不像glass_name所暗示的那样危险。"
	color = "#102000" // rgb: 16, 32, 0
	taste_description = "cherry soda" // FALSE ADVERTISING
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/dr_gibb/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_drowsiness(-6 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/space_up
	name = "Space-Up"
	description = "尝起来像你嘴里发生了船体破裂。"
	color = COLOR_VIBRANT_LIME // rgb: 0, 255, 0
	taste_description = "cherry soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/space_up/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-4 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/lemon_lime
	name = "Lemon Lime"
	description = "一种由0.5%天然柑橘制成的刺激性物质！"
	color = "#8CFF00" // rgb: 135, 255, 0
	taste_description = "tangy lime and lemon soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/lemon_lime/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-4 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/pwr_game
	name = "Pwr Game"
	description = "唯一一款拥有真正玩家所渴望的PWR能量的饮料。"
	color = "#9385bf" // rgb: 58, 52, 75
	taste_description = "sweet and salty tang"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/pwr_game/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(exposed_mob?.mind?.get_skill_level(/datum/skill/gaming) >= SKILL_LEVEL_LEGENDARY && (methods & INGEST) && !HAS_TRAIT(exposed_mob, TRAIT_GAMERGOD))
		ADD_TRAIT(exposed_mob, TRAIT_GAMERGOD, "pwr_game")
		to_chat(exposed_mob, span_nicegreen("As you imbibe the Pwr Game, your gamer third eye opens... \
		You feel as though a great secret of the universe has been made known to you..."))

/datum/reagent/consumable/pwr_game/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-4 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.mind?.adjust_experience(/datum/skill/gaming, 5)

/datum/reagent/consumable/shamblers
	name = "Shambler's Juice"
	description = "~给我来点颤栗者果汁！~"
	color = "#f00060" // rgb: 94, 0, 38
	taste_description = "carbonated metallic soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/shamblers/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-4 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/sodawater
	name = "Soda Water"
	description = "一罐苏打水。何不来杯苏格兰威士忌加苏打水呢？"
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "carbonated water"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

// A variety of nutrients are dissolved in club soda, without sugar.
// These nutrients include carbon, oxygen, hydrogen, phosphorous, potassium, sulfur and sodium, all of which are needed for healthy plant growth.
/datum/reagent/consumable/sodawater/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_waterlevel(round(volume))
	mytray.adjust_plant_health(round(volume * 0.1))

/datum/reagent/consumable/sodawater/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/tonic
	name = "Tonic Water"
	description = "味道有点怪，但至少奎宁能抵御太空疟疾。"
	color = "#0064C8" // rgb: 0, 100, 200
	taste_description = "tart and fresh"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/tonic/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.AdjustSleeping(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/wellcheers
	name = "Wellcheers"
	description = "一种奇怪的紫色饮料，闻起来有海水味。远处，你仿佛听到了海鸥的叫声。"
	color = "#762399" // rgb: 118, 35, 153
	taste_description = "grapes and the fresh open sea"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/wellcheers/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_drowsiness(1.5 SECONDS * metabolization_ratio * seconds_per_tick)
	var/need_mob_update
	switch(affected_mob.mob_mood.sanity_level)
		if (SANITY_LEVEL_GREAT to SANITY_LEVEL_NEUTRAL)
			need_mob_update = affected_mob.adjust_brute_loss(-0.75 * metabolization_ratio * seconds_per_tick, updating_health = FALSE)
		if (SANITY_LEVEL_DISTURBED to SANITY_LEVEL_UNSTABLE)
			affected_mob.add_mood_event("wellcheers", /datum/mood_event/wellcheers)
		if (SANITY_LEVEL_CRAZY to SANITY_LEVEL_INSANE)
			need_mob_update = affected_mob.adjust_stamina_loss(1.5 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/monkey_energy
	name = "Monkey Energy"
	description = "唯一能让你释放内心猿性的饮料。"
	color = "#f39b03" // rgb: 243, 155, 3
	overdose_threshold = 60
	taste_description = "barbecue and nostalgia"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/monkey_energy/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(40 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_dizzy(1 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.remove_status_effect(/datum/status_effect/drowsiness)
	affected_mob.AdjustSleeping(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/monkey_energy/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(is_simian(affected_mob))
		affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/reagent/monkey_energy)

/datum/reagent/consumable/monkey_energy/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/monkey_energy)

/datum/reagent/consumable/monkey_energy/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(7.5, seconds_per_tick))
		affected_mob.say(pick_list_replacements(BOOMER_FILE, "boomer"), forced = /datum/reagent/consumable/monkey_energy)

/datum/reagent/consumable/ice
	name = "Ice"
	description = "冻住的水，你的牙医可不会喜欢你嚼这个。"
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "ice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/ice

/datum/reagent/consumable/ice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_bodytemperature(-2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, FALSE, affected_mob.get_body_temp_normal()))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/soy_latte
	name = "Soy Latte"
	description = "一杯在你阅读嬉皮士书籍时享用的美味饮品。"
	color = "#cc6404" // rgb: 204,100,4
	overdose_threshold = 80
	quality = DRINK_NICE
	taste_description = "creamy coffee"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/soy_latte/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/soy_latte/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	var/need_mob_update
	need_mob_update = affected_mob.SetSleeping(0)
	affected_mob.adjust_bodytemperature(2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	if(affected_mob.get_brute_loss() && SPT_PROB(10, seconds_per_tick))
		need_mob_update += affected_mob.heal_bodypart_damage(brute = 0.5 * metabolization_ratio, burn = 0, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/cafe_latte
	name = "Cafe Latte"
	description = "一杯在你阅读时享用的美味、提神且可口的饮品。"
	color = "#cc6404" // rgb: 204,100,4
	overdose_threshold = 80
	quality = DRINK_NICE
	taste_description = "bitter cream"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/cafe_latte/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/cafe_latte/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-6 SECONDS * metabolization_ratio * seconds_per_tick)
	var/need_mob_update
	need_mob_update = affected_mob.SetSleeping(0)
	affected_mob.adjust_bodytemperature(2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	if(affected_mob.get_brute_loss() && SPT_PROB(10, seconds_per_tick))
		need_mob_update += affected_mob.heal_bodypart_damage(brute = 0.5 * metabolization_ratio, burn = 0, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/doctor_delight
	name = "The Doctor's Delight"
	description = "一天一杯，医疗机器人远离你！一种果汁混合物，能以消耗饥饿为代价快速治愈大多数类型的伤害。"
	color = "#FF8CFF" // rgb: 255, 140, 255
	quality = DRINK_VERYGOOD
	taste_description = "homely fruit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/doctor_delight/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_brute_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjust_fire_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjust_tox_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjust_oxy_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(affected_mob.nutrition && (affected_mob.nutrition - 2 > 0))
		var/obj/item/organ/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
		if(!(HAS_TRAIT(liver, TRAIT_MEDICAL_METABOLISM)))
			// Drains the nutrition of the holder. Not medical doctors though, since it's the Doctor's Delight!
			affected_mob.adjust_nutrition(-1 * metabolization_ratio * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/cinderella
	name = "Cinderella"
	description = "绝对是和朋友们聚会时享用的果味酒精鸡尾酒。"
	color = "#FF6A50"
	quality = DRINK_VERYGOOD
	taste_description = "sweet tangy fruit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/cinderella/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_disgust(-2.5 * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/cherryshake
	name = "Cherry Shake"
	description = "一款樱桃味的奶昔。"
	color = "#FFB6C1"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "creamy tart cherry"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/bluecherryshake
	name = "Blue Cherry Shake"
	description = "一款异国风情的奶昔。"
	color = "#00F1FF"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "creamy blue cherry"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/vanillashake
	name = "Vanilla Shake"
	description = "一款香草味的奶昔。经典依然美味。"
	color = "#E9D2B2"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "sweet creamy vanilla"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/caramelshake
	name = "Caramel Shake"
	description = "一款焦糖味的奶昔。光是看着就觉得牙疼。"
	color = "#E17C00"
	quality = DRINK_GOOD
	nutriment_factor = 10
	taste_description = "sweet rich creamy caramel"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/choccyshake
	name = "Chocolate Shake"
	description = "一杯冰凉的巧克力奶昔。"
	color = "#541B00"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "sweet creamy chocolate"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/strawberryshake
	name = "Strawberry Shake"
	description = "一杯草莓奶昔。"
	color = "#ff7b7b"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "sweet strawberries and milk"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/bananashake
	name = "Banana Shake"
	description = "一杯香蕉奶昔。小丑们在他们的“鸣叫日”派对上喝的东西。"
	color = "#f2d554"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8
	taste_description = "thick banana"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/pumpkin_latte
	name = "Pumpkin Latte"
	description = "南瓜汁和咖啡的混合物。"
	color = "#F4A460"
	overdose_threshold = 80
	quality = DRINK_VERYGOOD
	nutriment_factor = 3
	taste_description = "creamy pumpkin"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/pumpkin_latte/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/pumpkin_latte/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_dizzy(-5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drowsiness(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	var/need_mob_update
	need_mob_update = affected_mob.SetSleeping(0)
	affected_mob.adjust_bodytemperature(2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	if(affected_mob.get_brute_loss() && SPT_PROB(10, seconds_per_tick))
		need_mob_update += affected_mob.heal_bodypart_damage(brute = 0.5 * metabolization_ratio, burn = 0, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/gibbfloats
	name = "Gibb Floats"
	description = "吉布博士杯上的冰淇淋。"
	color = "#B22222"
	quality = DRINK_NICE
	nutriment_factor = 3
	taste_description = "creamy cherry"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/pumpkinjuice
	name = "Pumpkin Juice"
	description = "由真正的南瓜榨取而成。"
	color = "#FFA500"
	taste_description = "pumpkin"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/blumpkinjuice
	name = "Blumpkin Juice"
	description = "由真正的蓝南瓜榨取而成。"
	color = "#00BFFF"
	taste_description = "a mouthful of pool water"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/triple_citrus
	name = "Triple Citrus"
	description = "一种溶液。"
	color = "#EEFF00"
	quality = DRINK_NICE
	taste_description = "extreme bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/grape_soda
	name = "Grape Soda"
	description = "深受儿童和禁酒者的喜爱。"
	color = "#E6CDFF"
	taste_description = "grape soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/grape_soda/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/milk/chocolate_milk
	name = "Chocolate Milk"
	description = "酷小孩喝的牛奶。"
	color = "#7D4E29"
	quality = DRINK_NICE
	taste_description = "chocolate milk"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/hot_coco
	name = "Hot Coco"
	description = "用爱制成！还有可可豆。"
	nutriment_factor = 4
	color = "#3b240e" // rgb: 59, 36, 14
	taste_description = "creamy chocolate"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/hot_coco/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	affected_mob.adjust_bodytemperature(2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	if(affected_mob.get_brute_loss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(brute = 0.5 * metabolization_ratio, burn = 0, updating_health = FALSE))
			. = UPDATE_MOB_HEALTH
	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, 1 * metabolization_ratio * seconds_per_tick)
	return ..() || .

/datum/reagent/consumable/italian_coco
	name = "Italian Hot Chocolate"
	description = "用爱制成！光是闻到这味道，你就能想象出一位开心的老奶奶。"
	nutriment_factor = 8
	color = "#57372A"
	quality = DRINK_VERYGOOD
	taste_description = "thick creamy chocolate"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/italian_coco/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(2.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 0, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/menthol
	name = "Menthol"
	description = "可以缓解可能出现的咳嗽症状。"
	color = "#80AF9C"
	taste_description = "mint"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/menthol

/datum/reagent/consumable/menthol/on_mob_life(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/throat_soothed)

/datum/reagent/consumable/grenadine
	name = "Grenadine"
	description = "不是樱桃味的！"
	color = "#EA1D26"
	taste_description = "sweet pomegranates"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/grenadine/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(IS_REVOLUTIONARY(drinker))
		to_chat(drinker, span_warning("Antioxidants are weakening your radical spirit!"))

/datum/reagent/consumable/grenadine/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(IS_REVOLUTIONARY(drinker))
		drinker.set_dizzy_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)
		if(drinker.get_stamina_loss() < 80)
			drinker.adjust_stamina_loss(12, required_biotype = affected_biotype) //The pomegranate stops free radicals! Har har.

/datum/reagent/consumable/parsnipjuice
	name = "Parsnip Juice"
	description = "为什么..."
	color = "#FFA500"
	taste_description = "parsnip"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/pineapplejuice
	name = "Pineapple Juice"
	description = "酸涩、热带风味，且备受争议。"
	color = "#F7D435"
	taste_description = "pineapple"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/bottle/juice/pineapplejuice

/datum/reagent/consumable/peachjuice //Intended to be extremely rare due to being the limiting ingredients in the blazaam drink
	name = "Peach Juice"
	description = "正是桃子味。"
	color = "#E78108"
	taste_description = "peaches"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/cream_soda
	name = "Cream Soda"
	description = "一种经典的太空美式香草味软饮料。"
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "fizzy vanilla"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/cream_soda/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-2.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/sol_dry
	name = "Sol Dry"
	description = "一种用姜制成的舒缓、醇和的饮料。"
	color = "#f7d26a"
	quality = DRINK_NICE
	taste_description = "sweet ginger spice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/sol_dry/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_disgust(-2.5 * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/shirley_temple
	name = "Shirley Temple"
	description = "给你，小姑娘，现在你可以像大人一样喝了。"
	color = "#F43724"
	quality = DRINK_GOOD
	taste_description = "sweet cherry syrup and ginger spice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/shirley_temple/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	affected_mob.adjust_disgust(-1.5 * metabolization_ratio * seconds_per_tick)
	return ..()

/datum/reagent/consumable/red_queen
	name = "Red Queen"
	description = "喝掉我。"
	color = "#e6ddc3"
	quality = DRINK_GOOD
	taste_description = "wonder"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/consumable/red_queen/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(50, seconds_per_tick))
		return

	var/newsize = pick(0.5, 0.75, 1, 1.50, 2)
	newsize *= RESIZE_DEFAULT_SIZE
	affected_mob.update_transform(newsize/current_size)
	current_size = newsize
	if(SPT_PROB(23, seconds_per_tick))
		affected_mob.emote("sneeze")

/datum/reagent/consumable/red_queen/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.update_transform(RESIZE_DEFAULT_SIZE/current_size)
	current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/consumable/bungojuice
	name = "Bungo Juice"
	color = "#F9E43D"
	description = "异域风味！你感觉自己已经在度假了。"
	taste_description = "succulent bungo"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/prunomix
	name = "Pruno Mixture"
	color = "#E78108"
	description = "水果、糖、酵母和水混合捣碎成一种刺鼻的浆状物。"
	taste_description = "garbage"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/aloejuice
	name = "Aloe Juice"
	color = "#b3c5a7" // rgb: 179, 197, 167
	description = "一种健康清爽的果汁。"
	taste_description = "vegetable"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/aloejuice/on_mob_life(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.get_tox_loss() && SPT_PROB(16, seconds_per_tick))
		if(affected_mob.adjust_tox_loss(-0.5 * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/agua_fresca
	name = "Agua Fresca"
	description = "一种清爽的西瓜阿瓜弗雷斯卡。在全息甲板度过一天时的完美饮品。"
	color = "#D25B66"
	quality = DRINK_VERYGOOD
	taste_description = "cool refreshing watermelon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/agua_fresca/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-4 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())
	if(affected_mob.get_tox_loss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.adjust_tox_loss(-0.25 * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/mushroom_tea
	name = "Mushroom Tea"
	description = "一杯用多孔菌蘑菇碎屑制成的风味茶，原产于提兹拉。"
	color = "#674945" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "mushrooms"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/mushroom_tea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(islizard(affected_mob))
		if(affected_mob.adjust_oxy_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type))
			return UPDATE_MOB_HEALTH

//Moth Stuff
/datum/reagent/consumable/toechtauese_juice
	name = "Töchtaüse Juice"
	description = "未经加工的töchtaüse果汁。喝一口就会让你后悔。"
	color = "#554862" // rgb: 85, 72, 98
	nutriment_factor = 0
	taste_description = "fiery itchy pain"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/toechtauese_syrup
	name = "Töchtaüse Syrup"
	description = "一种由托赫陶瑟浆果制成的辛辣苦涩的糖浆。作为食材很有用，无论是用于食物还是鸡尾酒。"
	color = "#554862" // rgb: 85, 72, 98
	nutriment_factor = 0
	taste_description = "sugar, spice, and nothing nice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/strawberry_banana
	name = "Strawberry Banana Smoothie"
	description = "一款由草莓和香蕉制成的经典思慕雪。"
	color = "#FF9999"
	nutriment_factor = 0
	taste_description = "strawberry and banana"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/berry_blast
	name = "Berry Blast Smoothie"
	description = "一款由混合浆果制成的经典思慕雪。"
	color = "#A76DC5"
	nutriment_factor = 0
	taste_description = "mixed berry"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/funky_monkey
	name = "Funky Monkey Smoothie"
	description = "一款由巧克力和香蕉制成的经典思慕雪。"
	color = COLOR_BROWNER_BROWN
	nutriment_factor = 0
	taste_description = "chocolate and banana"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/green_giant
	name = "Green Giant Smoothie"
	description = "一款绿色的蔬菜思慕雪，但并非用蔬菜制成。"
	color = COLOR_VERY_DARK_LIME_GREEN
	nutriment_factor = 0
	taste_description = "green, just green"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/melon_baller
	name = "Melon Baller Smoothie"
	description = "一款由蜜瓜制成的经典思慕雪。"
	color = "#D22F55"
	nutriment_factor = 0
	taste_description = "fresh melon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/vanilla_dream
	name = "Vanilla Dream Smoothie"
	description = "一款由香草和新鲜奶油制成的经典思慕雪。"
	color = "#FFF3DD"
	nutriment_factor = 0
	taste_description = "creamy vanilla"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/cucumberjuice
	name = "Cucumber Juice"
	description = "普通的黄瓜汁，不是什么奇幻世界的东西。"
	color = "#B1D861" // rgb: 177, 216, 97
	taste_description = "light cucumber"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/cucumberlemonade
	name = "Cucumber Lemonade"
	description = "黄瓜汁、糖和苏打水；我还需要什么？"
	color = "#cbe248" // rgb: 203, 226, 72
	quality = DRINK_GOOD
	taste_description = "citrus soda with cucumber"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/cucumberlemonade/on_mob_life(mob/living/carbon/doll, seconds_per_tick, metabolization_ratio)
	. = ..()
	doll.adjust_bodytemperature(-4 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, doll.get_body_temp_normal())
	if(doll.get_tox_loss() && SPT_PROB(10, seconds_per_tick))
		if(doll.adjust_tox_loss(-0.25 * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/mississippi_queen
	name = "Mississippi Queen"
	description = "如果你觉得自己很厉害，来杯庆功酒如何？"
	color = "#d4422f" // rgb: 212,66,47
	taste_description = "sludge seeping down your throat"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/mississippi_queen/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	switch(current_cycle)
		if(11 to 21)
			drinker.adjust_dizzy(2 SECONDS * metabolization_ratio * seconds_per_tick)
		if(21 to 31)
			if(SPT_PROB(15, seconds_per_tick))
				drinker.adjust_confusion(2 SECONDS * metabolization_ratio)
		if(31 to 201)
			drinker.adjust_hallucinations(30 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/t_letter
	name = "T"
	description = "你本以为会在汤里找到它，不过这样也不错。"
	color = "#583d09" // rgb: 88, 61, 9
	taste_description = "one of your 26 favorite letters"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/t_letter/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!HAS_MIND_TRAIT(affected_mob, TRAIT_MIMING))
		return
	affected_mob.set_silence_if_lower(MIMEDRINK_SILENCE_DURATION)
	affected_mob.adjust_drowsiness(-3 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.AdjustSleeping(-2 SECONDS * metabolization_ratio * seconds_per_tick)
	if(affected_mob.get_tox_loss() && SPT_PROB(25, seconds_per_tick))
		if(affected_mob.adjust_tox_loss(-1 * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/hakka_mate
	name = "Hakka-Mate"
	description = "一种火星产的马黛茶汽水，直接从黑客大会的角落里拖出来的。"
	color = "#c4b000"
	taste_description = "bubbly yerba mate"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/coconut_milk
	name = "Coconut Milk"
	description = "一种用途广泛的牛奶替代品，从烹饪到调制鸡尾酒都完美适用。"
	color = "#DFDFDF"
	taste_description = "milky coconut"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/melon_soda
	name = "Melon Soda"
	description = "一抹霓虹绿色的怀旧冲击。"
	color = "#6FEB48"
	taste_description = "fizzy melon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/volt_energy
	name = "24-Volt Energy"
	description = "一种人工着色和调味的电能饮料，灯笼果风味。由以太人制造，为以太人服务。"
	color = "#99E550"
	taste_description = "sour pear"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/volt_energy/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 20 * ETHEREAL_DISCHARGE_RATE)

/datum/reagent/consumable/fruit_punch
	name = "fruit punch"
	description = "Impossibly sweet fruit punch. Nobody knows what fruits were used to make it, not even it's creators... \
		It's unique recipe heals and rejuvinates the drinker, but is unsafe to consume without the support of a nearby watercooler."
	color = "#f7b2e3"
	taste_description = "dangerously sweet fruit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/fruit_punch/on_mob_life(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	var/found_valid_cooler = FALSE
	for(var/obj/structure/reagent_dispensers/water_cooler/found_cooler in range(4, affected_mob))
		if(found_cooler.anchored)
			found_valid_cooler = TRUE
			var/obj/effect/temp_visual/heal/heal_effect = new /obj/effect/temp_visual/heal(get_turf(found_cooler))
			heal_effect.color = "#f7b2e3"
			break

	if(found_valid_cooler)
		affected_mob.clear_alert("punch_bad")
		affected_mob.throw_alert("punch_good", /atom/movable/screen/alert/fruit_punch_good)
		need_mob_update = affected_mob.adjust_tox_loss(-0.3 * metabolization_ratio * seconds_per_tick, updating_health = FALSE)
		need_mob_update = affected_mob.adjust_brute_loss(-0.3 * metabolization_ratio * seconds_per_tick, updating_health = FALSE)
		need_mob_update = affected_mob.adjust_fire_loss(-0.3 * metabolization_ratio * seconds_per_tick, updating_health = FALSE)
		affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/punch_punishment)
	else
		affected_mob.clear_alert("punch_good")
		affected_mob.throw_alert("punch_bad", /atom/movable/screen/alert/fruit_punch_bad)
		need_mob_update = affected_mob.apply_damage(0.75 * metabolization_ratio * seconds_per_tick, TOX)
		affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/punch_punishment)
		if(SPT_PROB(10, seconds_per_tick))
			affected_mob.Knockdown(3 SECONDS, 6 SECONDS) //Gives daze effect. Using the cooler is a commitment and if you get jumped during it or have to run away to fight something, you should be vulnerable.
			to_chat(affected_mob, span_warning("The overwhelming sweetness of the fruit punch disorients and confounds you!"))
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/movespeed_modifier/punch_punishment
	multiplicative_slowdown = 0.30

/datum/reagent/consumable/fruit_punch/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.clear_alert("punch_bad")
	affected_mob.clear_alert("punch_good")
	affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/punch_punishment)

/atom/movable/screen/alert/fruit_punch_good
	name = "Fruit Punch Blessing"
	desc = "The sweetness of the fruit punch and the friendly company of the liquid cooler are slowly restoring your health..."
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "punch_blessing"

/atom/movable/screen/alert/fruit_punch_bad
	name = "Fruit Punishment"
	desc = "The unbearable sweetness of the fruit punch is too much to bear without the soothing aura of a liquid cooler! Your body is going into shock!"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "punch_punishment"

/datum/reagent/consumable/ethanol/bitters_soda
	name = "Bitters and Soda"
	description = "一种用芳香苦精调味的苏打水制成的简单饮品。能安抚不适的胃。"
	boozepwr = 0
	color = "#f1c1b3"
	quality = DRINK_NICE
	taste_description = "mild aromatics"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bitters_soda/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_disgust(-2.5 * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/lean
	name = "Lean"
	description = "这种饮料会让你变得气喘吁吁。"
	color = "#DE55ED"
	quality = DRINK_GOOD
	taste_description = "purple and a hint of opioid."
	addiction_types = list(/datum/addiction/opioids = 200)
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/consumable/lean/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_jitter(2.5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_stutter(2.25 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_drugginess(2 SECONDS * metabolization_ratio * seconds_per_tick)
	if(SPT_PROB(15, seconds_per_tick))
		affected_mob.emote(pick("taunt","twitch","shiver","laugh","moan","blush","stare"))
	if(current_cycle > 16 && SPT_PROB(3.5, seconds_per_tick))
		affected_mob.adjust_dizzy(15 SECONDS * metabolization_ratio)
		affected_mob.adjust_drowsiness(6.5 SECONDS * metabolization_ratio)
		affected_mob.emote("drool")
