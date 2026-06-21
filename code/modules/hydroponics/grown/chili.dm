// Chili
/obj/item/seeds/chili
	name = "辣椒种子包"
	desc = "能长成辣椒植株的种子。辣！辣！辣！"
	icon_state = "seed-chili"
	species = "chili"
	plantname = "Chili Plants"
	product = /obj/item/food/grown/chili
	lifespan = 20
	maturation = 5
	production = 5
	yield = 4
	potency = 20
	instability = 30
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	icon_grow = "chili-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "chili-dead" // Same for the dead icon
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/chili/ice, /obj/item/seeds/chili/ghost)
	reagents_add = list(/datum/reagent/consumable/capsaicin = 0.25, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/food/grown/chili
	seed = /obj/item/seeds/chili
	name = "辣椒"
	desc = "It's spicy! Wait... IT'S BURNING ME!!"
	icon_state = "chilipepper"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 20

// Ice Chili
/obj/item/seeds/chili/ice
	name = "寒椒种子包"
	desc = "能长成冷椒植株的种子。"
	icon_state = "seed-icepepper"
	species = "chiliice"
	plantname = "Chilly Pepper Plants"
	product = /obj/item/food/grown/icepepper
	lifespan = 25
	maturation = 4
	production = 4
	rarity = PLANT_MODERATELY_RARE
	genes = list(/datum/plant_gene/trait/chem_cooling)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/frostoil = 0.25, /datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/consumable/nutriment = 0.02)
	graft_gene = /datum/plant_gene/trait/chem_cooling

/obj/item/food/grown/icepepper
	seed = /obj/item/seeds/chili/ice
	name = "冷椒"
	desc = "这是一种变异的辣椒品种。"
	icon_state = "icepepper"
	bite_consumption_mod = 5
	foodtypes = VEGETABLES
	wine_power = 30

// Ghost Chili
/obj/item/seeds/chili/ghost
	name = "鬼椒种子包"
	desc = "能长成全宇宙最辣的辣椒的种子。"
	icon_state = "seed-chilighost"
	species = "chilighost"
	plantname = "Ghost Chili Plants"
	product = /obj/item/food/grown/ghost_chili
	endurance = 10
	maturation = 10
	production = 10
	yield = 3
	rarity = PLANT_MODERATELY_RARE
	genes = list(/datum/plant_gene/trait/chem_heating, /datum/plant_gene/trait/backfire/chili_heat)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/condensedcapsaicin = 0.3, /datum/reagent/consumable/capsaicin = 0.55, /datum/reagent/consumable/nutriment = 0.04)
	graft_gene = /datum/plant_gene/trait/chem_heating

/obj/item/food/grown/ghost_chili
	seed = /obj/item/seeds/chili/ghost
	name = "魔鬼辣椒"
	desc = "它似乎在轻轻地振动着。"
	icon_state = "ghostchilipepper"
	bite_consumption_mod = 5
	foodtypes = VEGETABLES
	wine_power = 50

// Bell Pepper
/obj/item/seeds/chili/bell_pepper
	name = "甜椒种子包"
	desc = "能长成灯笼椒植株的种子。温和！温和！温和！"
	icon_state = "seed-bell-pepper"
	species = "bellpepper"
	plantname = "Bell Pepper Plants"
	product = /obj/item/food/grown/bell_pepper
	endurance = 10
	maturation = 10
	production = 10
	yield = 3
	rarity = PLANT_MODERATELY_RARE
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.08, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/food/grown/bell_pepper
	seed = /obj/item/seeds/chili/bell_pepper
	name = "灯笼椒"
	desc = "一种味道温和的大辣椒，用途广泛。"
	icon_state = "bell_pepper"
	foodtypes = VEGETABLES

/obj/item/food/grown/bell_pepper/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/roasted_bell_pepper, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)
