// Cherries
/obj/item/seeds/cherry
	name = "樱桃核包"
	desc = "千万要小心别把牙齿磕断了……那样可就糟糕了。"
	icon_state = "seed-cherry"
	species = "cherry"
	plantname = "Cherry Tree"
	product = /obj/item/food/grown/cherries
	lifespan = 35
	endurance = 35
	maturation = 5
	production = 5
	growthstages = 5
	instability = 15
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "cherry-grow"
	icon_dead = "cherry-dead"
	icon_harvest = "cherry-harvest"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/cherry/blue, /obj/item/seeds/cherry/bulb)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07)

/obj/item/food/grown/cherries
	seed = /obj/item/seeds/cherry
	name = "樱桃"
	desc = "非常适合用作配料！"
	icon_state = "cherry"
	gender = PLURAL
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("cherry" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/maraschino

/obj/item/food/grown/cherries/grind_results()
	return list(/datum/reagent/consumable/cherryjelly = 0)

// Blue Cherries
/obj/item/seeds/cherry/blue
	name = "蓝樱桃核包"
	desc = "蓝色的那种樱桃。"
	icon_state = "seed-bluecherry"
	species = "bluecherry"
	plantname = "Blue Cherry Tree"
	product = /obj/item/food/grown/bluecherries
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07, /datum/reagent/oxygen = 0.07)
	rarity = 10

/obj/item/food/grown/bluecherries
	seed = /obj/item/seeds/cherry/blue
	name = "蓝樱桃"
	desc = "蓝色的樱桃。"
	icon_state = "bluecherry"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("blue cherry" = 1)
	wine_power = 50

/obj/item/food/grown/bluecherries/grind_results()
	return list(/datum/reagent/consumable/bluecherryjelly = 0)

//Cherry Bulbs
/obj/item/seeds/cherry/bulb
	name = "樱桃球茎核包"
	desc = "那种色泽鲜艳的樱桃。"
	icon_state = "seed-cherrybulb"
	species = "cherrybulb"
	plantname = "Cherry Bulb Tree"
	product = /obj/item/food/grown/cherrybulbs
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/pink)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07)
	rarity = 10
	graft_gene = /datum/plant_gene/trait/glow/pink

/obj/item/food/grown/cherrybulbs
	seed = /obj/item/seeds/cherry/bulb
	name = "灯泡樱桃"
	desc = "它们就像小小的太空圣诞灯！"
	icon_state = "cherry_bulb"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("cherry" = 1)
	wine_power = 50

/obj/item/food/grown/cherrybulbs/grind_results()
	return list(/datum/reagent/consumable/cherryjelly = 0)

//Cherry Bombs
/obj/item/seeds/cherry/bomb
	name = "樱桃炸弹核包"
	desc = "他们给你带来的感觉是恐惧和沮丧。"
	icon_state = "seed-cherry_bomb"
	species = "cherry_bomb"
	plantname = "Cherry Bomb Tree"
	product = /obj/item/food/grown/cherry_bomb
	mutatelist = null
	genes = list(/datum/plant_gene/trait/bomb_plant, /datum/plant_gene/trait/modified_volume/cherry_bomb)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/sugar = 0.1, /datum/reagent/gunpowder = 0.7)
	rarity = 60 //See above

/obj/item/food/grown/cherry_bomb
	name = "樱桃炸弹"
	desc = "你觉得你能听到一根小保险丝发出的嘶嘶声。"
	icon_state = "cherry_bomb"
	alt_icon = "cherry_bomb_lit"
	seed = /obj/item/seeds/cherry/bomb
	bite_consumption_mod = 3
	wine_power = 80
