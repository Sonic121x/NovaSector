// Honeysuckle
/obj/item/seeds/honeysuckle
	name = "金银花种子包"
	desc = "这些种子会长成金银花。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-honeysuckle"
	species = "honeysuckle"
	plantname = "Honeysuckle Bush"
	product = /obj/item/food/grown/honeysuckle
	lifespan = 50
	endurance = 10
	growthstages = 3
	growing_icon = 'modular_nova/master_files/icons/obj/hydroponics/growing.dmi'
	icon_grow = "honeysuckle-grow"
	icon_dead = "honeysuckle-dead"
	genes = list(/datum/plant_gene/trait/preserved, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/honey = 0.2, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/honeysuckle
	seed = /obj/item/seeds/honeysuckle
	name = "金银花"
	desc = "这种花朵的锥形末端含有一种类似蜂蜜的甜美花蜜。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/harvest.dmi'
	icon_state = "honeysuckle"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | SUGAR
	distill_reagent = /datum/reagent/consumable/ethanol/mead
