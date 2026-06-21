// Finally, peas. Base plant.
/obj/item/seeds/peas
	name = "豌豆荚包"
	desc = "这些种子能长成维生素含量丰富的豌豆！"
	icon_state = "seed-peas"
	species = "peas"
	plantname = "Pea Vines"
	product = /obj/item/food/grown/peas
	maturation = 3
	potency = 25
	instability = 15
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	icon_grow = "peas-grow"
	icon_dead = "peas-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/peas/laugh)
	reagents_add = list (/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/water = 0.05)

/obj/item/food/grown/peas
	seed = /obj/item/seeds/peas
	name = "豌豆荚"
	desc = "最后……豌豆。"
	icon_state = "peas"
	foodtypes = VEGETABLES
	tastes = list ("peas" = 1, "chalky saltiness" = 1)
	wine_power = 50
	wine_flavor = "what is, distressingly, fermented peas."

// Laughin' Peas
/obj/item/seeds/peas/laugh
	name = "笑豆包"
	desc = "这些种子会发出一种非常柔和的紫色光芒……它们应该会长成欢笑豌豆。"
	icon_state = "seed-laughpeas"
	species = "laughpeas"
	plantname = "Laughin' Peas"
	product = /obj/item/food/grown/laugh
	maturation = 7
	potency = 10
	yield = 7
	production = 5
	growthstages = 3
	icon_grow = "laughpeas-grow"
	icon_dead = "laughpeas-dead"
	genes = list (/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/purple, /datum/plant_gene/trait/plant_laughter)
	mutatelist = list (/obj/item/seeds/peas/laugh/peace)
	reagents_add = list (/datum/reagent/consumable/laughter = 0.05, /datum/reagent/consumable/sugar = 0.05, /datum/reagent/consumable/nutriment = 0.07)
	rarity = 25 //It actually might make Central Command Officials loosen up a smidge, eh?
	graft_gene = /datum/plant_gene/trait/plant_laughter

/obj/item/food/grown/laugh
	seed = /obj/item/seeds/peas/laugh
	name = "一荚笑豆"
	desc = "食用后绝对能让你的心情大为改善！"
	icon_state = "laughpeas"
	foodtypes = VEGETABLES
	tastes = list ("a prancing rabbit" = 1) //Vib Ribbon sends her regards.. wherever she is.
	wine_power = 90
	wine_flavor = "a vector-graphic rabbit dancing on your tongue"

/obj/item/food/grown/laugh/juice_typepath()
	return /datum/reagent/consumable/laughsyrup

// World Peas - Peace at last, peace at last...
/obj/item/seeds/peas/laugh/peace
	name = "世界豌豆包"
	desc = "这些相当大的种子会发出柔和的蓝光。"
	icon_state = "seed-worldpeas"
	species = "worldpeas"
	plantname = "World Peas"
	product = /obj/item/food/grown/peace
	maturation = 20
	potency = 75
	yield = 1
	production = 10
	instability = 45 //The world is a very unstable place. Constantly changing.
	growthstages = 3
	icon_grow = "worldpeas-grow"
	icon_dead = "worldpeas-dead"
	genes = list (/datum/plant_gene/trait/glow/blue)
	reagents_add = list (/datum/reagent/pax = 0.1, /datum/reagent/drug/happiness = 0.1, /datum/reagent/consumable/nutriment = 0.15)
	rarity = 50 // This absolutely will make even the most hardened Syndicate Operators relax.
	graft_gene = /datum/plant_gene/trait/glow/blue
	mutatelist = null

/obj/item/food/grown/peace
	seed = /obj/item/seeds/peas/laugh/peace
	name = "世界豌豆丛"
	desc = "A plant discovered through extensive genetic engineering, and iterative graft work. It's rumored to bring peace to any who consume it. In the wider AgSci community, it's attained the nickname of 'Pax Mundi'." //at last... world peas. I'm not sorry.
	icon_state = "worldpeas"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	tastes = list ("numbing tranquility" = 2, "warmth" = 1)
	wine_power = 100
	wine_flavor = "mind-numbing peace and warmth"
