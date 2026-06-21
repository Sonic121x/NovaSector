// Olive
/obj/item/seeds/olive
	name = "橄榄种子包"
	desc = "能长成橄榄的种子。"
	icon_state = "seed-olive"
	species = "olive"
	plantname = "Olive Tree"
	product = /obj/item/food/grown/olive
	lifespan = 150
	endurance = 35
	yield = 5
	maturation = 10
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "olive-grow"
	icon_dead = "olive-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/one_bite)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/olive
	seed = /obj/item/seeds/olive
	name = "橄榄"
	desc = "一种小巧的圆柱形咸味水果，与芒果有密切关系。这种水果可以被研磨成糊状物，并与水混合制成优质油。"
	icon_state = "olive"
	foodtypes = FRUIT
	tastes = list("olive" = 1)

/obj/item/food/grown/olive/grind_results()
	return list(/datum/reagent/consumable/olivepaste = 0)
