// Tobacco
/obj/item/seeds/tobacco
	name = "烟草种子包"
	desc = "能长成烟草植株的种子。"
	icon_state = "seed-tobacco"
	species = "tobacco"
	plantname = "Tobacco Plant"
	product = /obj/item/food/grown/tobacco
	lifespan = 20
	maturation = 5
	production = 5
	yield = 10
	growthstages = 3
	icon_dead = "tobacco-dead"
	mutatelist = list(/obj/item/seeds/tobacco/space)
	reagents_add = list(/datum/reagent/drug/nicotine = 0.03, /datum/reagent/consumable/nutriment = 0.03)

/obj/item/food/grown/tobacco
	seed = /obj/item/seeds/tobacco
	name = "烟草叶"
	desc = "把烟草叶烘干，可以用它们做卷烟。"
	icon_state = "tobacco_leaves"
	distill_reagent = /datum/reagent/consumable/ethanol/creme_de_menthe //Menthol, I guess.

// Space Tobacco
/obj/item/seeds/tobacco/space
	name = "太空烟草种子包"
	desc = "能长成太空烟草植株的种子。"
	icon_state = "seed-stobacco"
	species = "stobacco"
	plantname = "Space Tobacco Plant"
	product = /obj/item/food/grown/tobacco/space
	mutatelist = null
	reagents_add = list(/datum/reagent/medicine/salbutamol = 0.05, /datum/reagent/drug/nicotine = 0.08, /datum/reagent/consumable/nutriment = 0.03)
	rarity = PLANT_MODERATELY_RARE

/obj/item/food/grown/tobacco/space
	seed = /obj/item/seeds/tobacco/space
	name = "太空烟草叶"
	desc = "把太空烟草叶烘干，用它们来做太空卷烟。"
	icon_state = "stobacco_leaves"
	bite_consumption_mod = 2
	distill_reagent = null
	wine_power = 50
