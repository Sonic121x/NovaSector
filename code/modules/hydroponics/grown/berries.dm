// Berries
/obj/item/seeds/berry
	name = "浆果种子包"
	desc = "能长成浆果树的种子。"
	icon_state = "seed-berry"
	species = "berry"
	plantname = "Berry Bush"
	product = /obj/item/food/grown/berries
	lifespan = 20
	maturation = 5
	production = 5
	yield = 2
	instability = 30
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "berry-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "berry-dead" // Same for the dead icon
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/berry/glow, /obj/item/seeds/berry/poison)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/berries
	seed = /obj/item/seeds/berry
	name = "一串浆果"
	desc = "营养超丰富！"
	icon_state = "berrypile"
	gender = PLURAL
	foodtypes = FRUIT
	tastes = list("berry" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/gin

/obj/item/food/grown/berries/juice_typepath()
	return /datum/reagent/consumable/berryjuice

// Poison Berries
/obj/item/seeds/berry/poison
	name = "毒莓种子包"
	desc = "能长成毒浆果树的种子。"
	icon_state = "seed-poisonberry"
	species = "poisonberry"
	plantname = "Poison-Berry Bush"
	product = /obj/item/food/grown/berries/poison
	mutatelist = list(/obj/item/seeds/berry/death)
	reagents_add = list(/datum/reagent/toxin/cyanide = 0.15, /datum/reagent/toxin/staminatoxin = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = 10 // Mildly poisonous berries are common in reality

/obj/item/food/grown/berries/poison
	seed = /obj/item/seeds/berry/poison
	name = "一串毒浆果"
	desc = "味道超级好，但吃完之后，你可能会挂掉！"
	icon_state = "poisonberrypile"
	bite_consumption_mod = 3
	foodtypes = FRUIT | TOXIC
	tastes = list("poison-berry" = 1)
	distill_reagent = null
	wine_power = 35

/obj/item/food/grown/berries/poison/juice_typepath()
	return /datum/reagent/consumable/poisonberryjuice

// Death Berries
/obj/item/seeds/berry/death
	name = "死亡莓种子包"
	desc = "能长成死亡浆果树的种子。"
	icon_state = "seed-deathberry"
	species = "deathberry"
	plantname = "Death Berry Bush"
	product = /obj/item/food/grown/berries/death
	lifespan = 30
	potency = 50
	mutatelist = null
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/tox_resistance)
	reagents_add = list(/datum/reagent/toxin/coniine = 0.08, /datum/reagent/toxin/staminatoxin = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/tox_resistance

/obj/item/food/grown/berries/death
	seed = /obj/item/seeds/berry/death
	name = "一串死亡浆果"
	desc = "味道超级好，但吃完之后，你肯定会死！"
	icon_state = "deathberrypile"
	bite_consumption_mod = 3
	foodtypes = FRUIT | TOXIC
	tastes = list("death-berry" = 1)
	distill_reagent = null
	wine_power = 50

/obj/item/food/grown/berries/death/juice_typepath()
	return /datum/reagent/consumable/poisonberryjuice

// Glow Berries
/obj/item/seeds/berry/glow
	name = "发光莓种子包"
	desc = "能长成发光浆果树的种子。"
	icon_state = "seed-glowberry"
	species = "glowberry"
	plantname = "Glow-Berry Bush"
	product = /obj/item/food/grown/berries/glow
	lifespan = 30
	endurance = 25
	mutatelist = null
	genes = list(/datum/plant_gene/trait/glow/white, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/uranium = 0.25, /datum/reagent/iodine = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = PLANT_MODERATELY_RARE
	graft_gene = /datum/plant_gene/trait/glow/white

/obj/item/food/grown/berries/glow
	seed = /obj/item/seeds/berry/glow
	name = "一串发光浆果"
	desc = "Nutritious!"
	bite_consumption_mod = 3
	icon_state = "glowberrypile"
	foodtypes = FRUIT
	tastes = list("glow-berry" = 1)
	distill_reagent = null
	wine_power = 60

// Grapes
/obj/item/seeds/grape
	name = "葡萄种子包"
	desc = "能长成葡萄藤的种子。"
	icon_state = "seed-grapes"
	species = "grape"
	plantname = "Grape Vine"
	product = /obj/item/food/grown/grapes
	lifespan = 50
	endurance = 25
	maturation = 3
	production = 5
	yield = 4
	growthstages = 2
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "grape-grow"
	icon_dead = "grape-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/grape/green)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/sugar = 0.1)

/obj/item/food/grown/grapes
	seed = /obj/item/seeds/grape
	name = "一串葡萄"
	desc = "营养丰富！"
	icon_state = "grapes"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("grape" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/wine

/obj/item/food/grown/grapes/juice_typepath()
	return /datum/reagent/consumable/grapejuice

/obj/item/food/grown/grapes/make_dryable()
	AddElement(/datum/element/dryable, /obj/item/food/no_raisin/healthy)

// Green Grapes
/obj/item/seeds/grape/green
	name = "绿葡萄种子包"
	desc = "能长成青葡萄藤的种子。"
	icon_state = "seed-greengrapes"
	species = "greengrape"
	plantname = "Green-Grape Vine"
	product = /obj/item/food/grown/grapes/green
	reagents_add = list( /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/sugar = 0.1, /datum/reagent/medicine/c2/aiuri = 0.2)
	mutatelist = null

/obj/item/food/grown/grapes/green
	seed = /obj/item/seeds/grape/green
	name = "一串青葡萄"
	icon_state = "greengrapes"
	bite_consumption_mod = 3
	tastes = list("green grape" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/cognac

// Toechtauese Berries
/obj/item/seeds/toechtauese
	name = "töchtaüse 莓种子包"
	desc = "能长成托赫塔乌斯灌木的种子。"
	icon_state = "seed-toechtauese"
	species = "toechtauese"
	plantname = "Töchtaüse Bush"
	product = /obj/item/food/grown/toechtauese
	lifespan = 20
	maturation = 5
	production = 5
	yield = 2
	instability = 30
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "toechtauese-grow"
	icon_dead = "toechtauese-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/toxin/itching_powder = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/toechtauese
	seed = /obj/item/seeds/toechtauese
	name = "托赫塔乌斯浆果"
	desc = "上面有托赫塔乌斯浆果的树枝，它们是蛾人舰队的宠儿，但不是这种形式。"
	icon_state = "toechtauese_branch"
	foodtypes = FRUIT
	tastes = list("fiery itchy pain" = 1)
	distill_reagent = /datum/reagent/toxin/itching_powder

/obj/item/food/grown/toechtauese/juice_typepath()
	return /datum/reagent/consumable/toechtauese_juice

/obj/item/seeds/lanternfruit
	name = "灯笼果种子包"
	desc = "这些种子会长成灯笼果荚。"
	icon_state = "seed-lanternfruit"
	species = "lanternfruit"
	plantname = "Lanternfruit Pod"
	product = /obj/item/food/grown/lanternfruit
	lifespan = 35
	endurance = 35
	maturation = 5
	production = 5
	growthstages = 3
	instability = 15
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "lanternfruit-grow"
	icon_dead = "lanternfruit-dead"
	icon_harvest = "lanternfruit-harvest"
	genes = list(/datum/plant_gene/trait/glow/yellow)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/sulfur = 0.07, /datum/reagent/consumable/sugar = 0.07, /datum/reagent/consumable/liquidelectricity = 0.07)
	graft_gene = /datum/plant_gene/trait/glow/yellow

/obj/item/food/grown/lanternfruit
	seed = /obj/item/seeds/lanternfruit
	name = "灯笼果"
	desc = "一种散发着柔和光芒的水果，带有手柄状的茎，是以太族的挚爱！"
	icon_state = "lanternfruit"
	foodtypes = FRUIT
	tastes = list("tv static" = 1, "sour pear" = 1, "grapefruit" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/wine_voltaic
