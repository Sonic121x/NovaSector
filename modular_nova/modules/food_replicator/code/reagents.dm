/datum/reagent/consumable/powdered_tea
	name = "茶粉"
	description = "茶叶的粉末形态。味道糟糕透顶。"
	color = "#3a3a03"
	nutriment_factor = 0
	taste_description = "bitter powder"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/mug/tea

/datum/chemical_reaction/food/unpowdered_tea
	required_reagents = list(
		/datum/reagent/water = 1,
		/datum/reagent/consumable/powdered_tea = 1,
	)
	results = list(/datum/reagent/consumable/tea = 2)
	mix_message = "The mixture instantly heats up."
	reaction_flags = REACTION_INSTANT

/datum/reagent/consumable/powdered_coffee
	name = "咖啡粉"
	description = "美式咖啡的粉末形态。说实话，相当普通的东西。"
	color = "#101000"
	nutriment_factor = 0
	taste_description = "very bitter powder"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/coffee

/datum/chemical_reaction/food/unpowdered_coffee
	required_reagents = list(
		/datum/reagent/water = 1,
		/datum/reagent/consumable/powdered_coffee = 1,
	)
	results = list(/datum/reagent/consumable/coffee = 2)
	mix_message = "The mixture instantly heats up."
	reaction_flags = REACTION_INSTANT

/datum/reagent/consumable/powdered_coco
	name = "可可粉"
	description = "用爱（有待考证）和回收的生物质制成。"
	nutriment_factor = 0
	color = "#403010"
	taste_description = "dry chocolate"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/glass/mug/coco

/datum/chemical_reaction/food/unpowdered_coco
	required_reagents = list(
		/datum/reagent/consumable/milk = 1,
		/datum/reagent/consumable/powdered_coco = 1,
	)
	results = list(/datum/reagent/consumable/hot_coco = 2)
	mix_message = "The mixture instantly heats up."
	reaction_flags = REACTION_INSTANT

/datum/reagent/consumable/powdered_lemonade
	name = "柠檬粉"
	description = "柠檬水的甜酸基底。如果和水混合会很好喝。"
	nutriment_factor = 0
	color = "#FFE978"
	taste_description = "intensely sour and sweet lemon powder"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/soda_cans/lemon_lime

/datum/chemical_reaction/food/unpowdered_lemonade
	required_reagents = list(
		/datum/reagent/water = 1,
		/datum/reagent/consumable/powdered_lemonade = 1,
	)
	results = list(/datum/reagent/consumable/lemonade = 2)
	mix_message = "The mixture instantly cools down."
	reaction_flags = REACTION_INSTANT

/datum/reagent/consumable/powdered_milk
	name = "奶粉"
	description = "由某些机器的生物质重构器产生的不透明白色粉末。"
	nutriment_factor = 0
	color = "#DFDFDF"
	taste_description = "sweet dry milk"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/milk

/datum/chemical_reaction/food/unpowdered_milk
	required_reagents = list(
		/datum/reagent/water = 1,
		/datum/reagent/consumable/powdered_milk = 1,
	)
	results = list(/datum/reagent/consumable/milk = 2)
	mix_message = "The mixture cools down."
	reaction_flags = REACTION_INSTANT

/obj/item/reagent_containers/applicator/pill/convermol
	name = "康沃莫药片"
	desc = "用于治疗缺氧。会使身体中毒。"
	icon_state = "pill16"
	list_reagents = list(/datum/reagent/medicine/c2/convermol = 15)
	rename_with_volume = TRUE

/datum/reagent/consumable/nutriment/glucose
	name = "合成葡萄糖"
	description = "一种粘稠的黄色液体，简单的碳水化合物，有机葡萄糖的同素异形体。为你的身体提供短期能量提升。"
	nutriment_factor = 1
	color = "#f3d00d"
	taste_description = "strong sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	var/delayed_satiety_drain = 30

/datum/reagent/consumable/nutriment/glucose/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	if(affected_mob.satiety < MAX_SATIETY)
		affected_mob.adjust_nutrition(15)
		delayed_satiety_drain += 15

	return ..()

/datum/reagent/consumable/nutriment/glucose/on_mob_delete(mob/living/carbon/detoxed_mob)
	detoxed_mob.adjust_nutrition(-delayed_satiety_drain)
	return ..()
