/obj/item/seeds/nofruit
	name = "诺果种子包"
	desc = "这些种子会长成诺果植株。一种常被默剧表演者培育的奇特植物。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "nofruit"
	species = "nofruit"
	plantname = "Nofruit Plant"
	product = /obj/item/food/grown/nofruit
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "nofruit-stage"
	growthstages = 4
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nothing = 0.1, /datum/reagent/toxin/mimesbane = 0.1, /datum/reagent/toxin/mutetoxin = 0.1)

/obj/item/food/grown/nofruit
	seed = /obj/item/seeds/nofruit
	name = "诺果"
	desc = "一个立方形的诺果，顶部的叶子疯狂地比划着。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "nofruit"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("nothing" = 1)

/obj/item/food/grown/nofruit/juice_typepath()
	return /datum/reagent/consumable/nothing
