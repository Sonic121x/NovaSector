// Eggplant
/obj/item/seeds/eggplant
	name = "茄子种子包"
	desc = "这些种子长成的浆果看起来一点也不像鸡蛋。"
	icon_state = "seed-eggplant"
	species = "eggplant"
	plantname = "Eggplants"
	product = /obj/item/food/grown/eggplant
	yield = 2
	potency = 20
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	icon_grow = "eggplant-grow"
	icon_dead = "eggplant-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/eggplant/eggy)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/eggplant
	seed = /obj/item/seeds/eggplant
	name = "茄子"
	desc = "也许里面有只鸡？"
	icon_state = "eggplant"
	foodtypes = VEGETABLES
	wine_power = 20

// Egg-Plant
/obj/item/seeds/eggplant/eggy
	name = "蛋茄种子包"
	desc = "这些种子长出的浆果看起来很像鸡蛋。"
	icon_state = "seed-eggy"
	species = "eggy"
	plantname = "Egg-Plants"
	product = /obj/item/food/grown/eggy
	lifespan = 75
	production = 12
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/eggy
	seed = /obj/item/seeds/eggplant/eggy
	name = "蛋茄"
	desc = "里面一定有只鸡。"
	icon_state = "eggyplant"
	trash_type = /obj/item/food/egg
	foodtypes = MEAT
	distill_reagent = /datum/reagent/consumable/ethanol/eggnog
