/obj/item/seeds/garlic
	name = "大蒜种子包"
	desc = "一包气味极其浓烈的种子。"
	icon_state = "seed-garlic"
	species = "garlic"
	plantname = "Garlic Sprouts"
	product = /obj/item/food/grown/garlic
	yield = 6
	potency = 25
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	reagents_add = list(/datum/reagent/consumable/garlic = 0.15, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/garlic
	seed = /obj/item/seeds/garlic
	name = "大蒜"
	desc = "味道迷人，但可能会散发出令人难以忍受的气味."
	icon_state = "garlic"
	tastes = list("garlic" = 1)
	wine_power = 10
	foodtypes = VEGETABLES
