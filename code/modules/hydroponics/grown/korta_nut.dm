//Korta Nut
/obj/item/seeds/korta_nut
	name = "科尔塔坚果种子包"
	desc = "这些种子(pack of korta nut seeds)长成科尔塔坚果灌木丛，原生于泰泽拉。"
	icon_state = "seed-korta"
	species = "kortanut"
	plantname = "Korta Nut Bush"
	product = /obj/item/food/grown/korta_nut
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "kortanut-grow"
	icon_dead = "kortanut-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/one_bite)
	mutatelist = list(/obj/item/seeds/korta_nut/sweet)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/korta_nut
	seed = /obj/item/seeds/korta_nut
	name = "科尔塔坚果"
	desc = "非常重要的小坚果(korta nut)，有可以磨成面粉的辛辣的外壳和柔软的果肉内部，当榨汁时会产生乳白色的液体。或者你把它当做能直接吃掉的方便零食。"
	icon_state = "korta_nut"
	foodtypes = NUTS
	tastes = list("peppery heat" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/kortara

/obj/item/food/grown/korta_nut/grind_results()
	return list(/datum/reagent/consumable/korta_flour = 0)

/obj/item/food/grown/korta_nut/juice_typepath()
	return /datum/reagent/consumable/korta_milk

//Sweet Korta Nut
/obj/item/seeds/korta_nut/sweet
	name = "甜科尔塔坚果种子包"
	desc = "这些种子(sweet korta nut seeds)会长成了甜科尔塔坚果，这是原始物种的一个突变，它生产出一种浓稠的糖浆，泰泽拉人用它来制作甜点。"
	icon_state = "seed-sweetkorta"
	species = "kortanut"
	plantname = "Sweet Korta Nut Bush"
	product = /obj/item/food/grown/korta_nut/sweet
	maturation = 10
	production = 10
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/korta_nectar = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = PLANT_MODERATELY_RARE

/obj/item/food/grown/korta_nut/sweet
	seed = /obj/item/seeds/korta_nut/sweet
	name = "甜科塔坚果"
	desc = "蜥蜴人们喜欢吃的甜食(sweet korta nut)。"
	icon_state = "korta_nut"
	tastes = list("peppery sweet" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/kortara

/obj/item/food/grown/korta_nut/sweet/grind_results()
	return list(/datum/reagent/consumable/korta_flour = 0)

/obj/item/food/grown/korta_nut/sweet/juice_typepath()
	return /datum/reagent/consumable/korta_nectar
