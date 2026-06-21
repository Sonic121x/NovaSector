/obj/item/seeds/vale
	name = "维尔种子包"
	desc = "这些种子会长成维尔植株。曾因其独特美学作为奢侈品出售，但在树木突然自燃后便从市场上撤下。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "vale"
	species = "vale"
	plantname = "Vale Plant"
	product = /obj/item/food/grown/vale
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "vale-stage"
	growthstages = 4
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/pink)
	reagents_add = list(/datum/reagent/stable_plasma = 0.1, /datum/reagent/toxin/plasma = 0.1, /datum/reagent/napalm = 0.1)

/obj/item/food/grown/vale
	seed = /obj/item/seeds/vale
	name = "维尔"
	desc = "一簇维尔叶子，请远离明火。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "vale"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("plasma" = 1)

/obj/item/food/grown/vale/juice_typepath()
	return /datum/reagent/toxin/plasma
