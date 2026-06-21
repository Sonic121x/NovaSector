// Tea
/obj/item/seeds/tea
	name = "茶（aspera）种子包"
	desc = "能长成茶树的种子。"
	icon_state = "seed-teaaspera"
	species = "teaaspera"
	plantname = "Tea Aspera Plant"
	product = /obj/item/food/grown/tea
	lifespan = 20
	maturation = 5
	production = 5
	yield = 5
	growthstages = 5
	icon_dead = "tea-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/tea/astra)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/toxin/teapowder = 0.1)

/obj/item/food/grown/tea
	seed = /obj/item/seeds/tea
	name = "苦旅茶尖"
	desc = "这些从茶树上采下的芳香茶尖晒干后可以用来泡茶。"
	icon_state = "tea_aspera_leaves"
	dry_grind = TRUE
	can_distill = FALSE

/obj/item/food/grown/tea/grind_results()
	return list(/datum/reagent/toxin/teapowder = 0)

// Tea Astra
/obj/item/seeds/tea/astra
	name = "茶（astra）种子包"
	icon_state = "seed-teaastra"
	species = "teaastra"
	plantname = "Tea Astra Plant"
	product = /obj/item/food/grown/tea/astra
	mutatelist = null
	reagents_add = list(/datum/reagent/medicine/synaptizine = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/toxin/teapowder = 0.1)
	rarity = PLANT_MODERATELY_RARE

/obj/item/food/grown/tea/astra
	seed = /obj/item/seeds/tea/astra
	name = "星辰茶尖"
	icon_state = "tea_astra_leaves"
	bite_consumption_mod = 2

/obj/item/food/grown/tea/astra/grind_results()
	return list(/datum/reagent/toxin/teapowder = 0, /datum/reagent/medicine/salglu_solution = 0)

// Coffee
/obj/item/seeds/coffee
	name = "咖啡（arabica）种子包"
	desc = "能长成阿拉比卡咖啡的种子。"
	icon_state = "seed-coffeea"
	species = "coffeea"
	plantname = "Coffee Arabica Bush"
	product = /obj/item/food/grown/coffee
	lifespan = 30
	endurance = 20
	maturation = 5
	production = 5
	yield = 5
	instability = 20
	growthstages = 5
	icon_dead = "coffee-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/coffee/robusta)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/toxin/coffeepowder = 0.1, /datum/reagent/nitrogen = 0.05)

/obj/item/food/grown/coffee
	seed = /obj/item/seeds/coffee
	name = "阿拉比卡咖啡豆"
	desc = "将它们晾干以用于制作咖啡。"
	icon_state = "coffee_arabica"
	dry_grind = TRUE
	distill_reagent = /datum/reagent/consumable/ethanol/kahlua

/obj/item/food/grown/coffee/grind_results()
	return list(/datum/reagent/toxin/coffeepowder = 0)

// Coffee Robusta
/obj/item/seeds/coffee/robusta
	name = "咖啡（robusta）种子包"
	desc = "这些种子会长成罗布斯塔咖啡树。"
	icon_state = "seed-coffeer"
	species = "coffeer"
	plantname = "Coffee Robusta Bush"
	product = /obj/item/food/grown/coffee/robusta
	mutatelist = null
	reagents_add = list(/datum/reagent/medicine/ephedrine = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/toxin/coffeepowder = 0.1)
	rarity = PLANT_MODERATELY_RARE

/obj/item/food/grown/coffee/robusta
	seed = /obj/item/seeds/coffee/robusta
	name = "罗布斯塔咖啡豆"
	desc = "增强了 37% 的稳定性！"
	icon_state = "coffee_robusta"

/obj/item/food/grown/coffee/robusta/grind_results()
	return list(/datum/reagent/toxin/coffeepowder = 0, /datum/reagent/medicine/morphine = 0)
