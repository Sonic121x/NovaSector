/obj/item/seeds/gelthi
	name = "盖尔西种子包"
	desc = "这些种子会长成盖尔西植株。因其独特的产蜜能力而备受厨师赞誉，也常因此被囤积。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "gelthi"
	species = "gelthi"
	plantname = "Gelthi Plant"
	product = /obj/item/food/grown/gelthi
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "gelthi-stage"
	growthstages = 3
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/squash)
	reagents_add = list(/datum/reagent/consumable/sprinkles = 0.1, /datum/reagent/consumable/astrotame = 0.1, /datum/reagent/consumable/honey = 0.2)

/obj/item/food/grown/gelthi
	seed = /obj/item/seeds/gelthi
	name = "盖尔西"
	desc = "一簇盖尔西豆荚。每个豆荚含有不同的甜味剂，豆荚可以榨出粗糖。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "gelthi"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("overpowering sweetness" = 1)

/obj/item/food/grown/gelthi/juice_typepath()
	return /datum/reagent/consumable/sugar
