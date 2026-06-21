// Modular DRINK REAGENTS, see the following file for the mixes: modular_nova\modules\customization\modules\food_and_drinks\recipes\drinks_recipes.dm

/datum/reagent/consumable/pinkmilk
	name = "草莓牛奶"
	description = "来自岩石故乡、由牛奶和人造甜味剂制成的旧时代饮品。"
	color = "#f76aeb"//rgb(247, 106, 235)
	quality = DRINK_VERYGOOD
	taste_description = "sweet strawberry and milk cream"

/datum/glass_style/drinking_glass/pinkmilk
	required_drink_type = /datum/reagent/consumable/pinkmilk
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "pinkmilk"
	name = "高杯草莓牛奶"
	desc = "美味的调味草莓糖浆与牛奶混合而成。"

/datum/reagent/consumable/pinkmilk/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(prob(15))
		to_chat(affected_mob, span_notice("[pick("You cant help to smile.","You feel nostalgia all of sudden.","You remember to relax.")]"))

/datum/reagent/consumable/pinktea //Tiny Tim song
	name = "草莓茶"
	description = "永恒的经典！"
	color = "#f76aeb"//rgb(247, 106, 235)
	quality = DRINK_VERYGOOD
	taste_description = "sweet tea with a hint of strawberry"

/datum/glass_style/drinking_glass/pinktea
	required_drink_type = /datum/reagent/consumable/pinktea
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "pinktea"
	name = "一杯草莓茶"
	desc = "用草莓调味的传统美味茶饮。"

/datum/reagent/consumable/pinktea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(prob(10))
		to_chat(affected_mob, span_notice("[pick("Diamond skies where white deer fly.","Sipping strawberry tea.","Silver raindrops drift through timeless, Neverending June.","Crystal ... pearls free, with love!","Beaming love into me.")]"))

/datum/reagent/consumable/catnip_tea
	name = "猫薄荷茶"
	description = "一杯令人昏昏欲睡又美味的猫薄荷茶！"
	color = "#101000" // rgb: 16, 16, 0
	taste_description = "sugar and catnip"

/datum/glass_style/drinking_glass/catnip_tea
	required_drink_type = /datum/reagent/consumable/catnip_tea
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "catnip_tea"
	name = "一杯猫薄荷茶"
	desc = "为猫咪准备的完美饮品。"

/datum/reagent/consumable/catnip_tea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_stamina_loss(min(50 - affected_mob.get_stamina_loss(), 3)))
		. = UPDATE_MOB_HEALTH
	if(isfeline(affected_mob))
		if(prob(20))
			affected_mob.emote("nya")
		if(prob(20))
			to_chat(affected_mob, span_notice("[pick("Headpats feel nice.", "Backrubs would be nice.", "Mew")]"))
	else
		to_chat(affected_mob, span_notice("[pick("I feel oddly calm.", "I feel relaxed.", "Mew?")]"))

/datum/reagent/consumable/ethanol/beerbatter
	name = "啤酒面糊"
	description = "喝下这玩意儿可能不是个好主意……这简直是泥浆。"
	color = "#f5f4e9"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	taste_description = "flour and cheap booze"
	boozepwr = 8 // beer diluted at about a 1:3 ratio
	ph = 6

/datum/glass_style/drinking_glass/beerbatter
	required_drink_type = /datum/reagent/consumable/ethanol/beerbatter
	icon = 'icons/obj/drinks/shakes.dmi'
	icon_state = "chocolatepudding"
	name = "一杯啤酒面糊"
	desc = "用于烹饪，纯胆固醇，苏格兰人吃这个。"

// Reagent metabolize: Nuka Cola
/datum/reagent/consumable/nuka_cola/on_mob_metabolize(mob/living/affected_mob)
	. = ..()

	// Add mood bonus
	if(HAS_TRAIT_FROM(affected_mob, TRAIT_RADIMMUNE, QUIRK_TRAIT))
		affected_mob.add_mood_event("fav_food", /datum/mood_event/favorite_food)
