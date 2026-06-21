/obj/item/seeds/jurlmah
	name = "尤尔玛种子包"
	desc = "这些种子会长成尤尔玛植株。在无法设置专用低温治疗舱的区域，常被用作临时低温治疗手段。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "jurlmah"
	species = "jurlmah"
	plantname = "Jurlmah Plant"
	product = /obj/item/food/grown/jurlmah
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "jurlmah-stage"
	growthstages = 5
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/blue)
	reagents_add = list(/datum/reagent/medicine/cryoxadone = 0.1, /datum/reagent/inverse/healing/tirimol  = 0.1, /datum/reagent/consumable/frostoil = 0.1)

/obj/item/food/grown/jurlmah
	seed = /obj/item/seeds/jurlmah
	name = "尤尔玛"
	desc = "一个冰冷的尤尔玛果实，摸起来很凉。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "jurlmah"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("snow" = 1)

/obj/item/food/grown/jurlmah/juice_typepath()
	return /datum/reagent/medicine/cryoxadone
