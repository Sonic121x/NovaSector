// Cocoa Pod
/obj/item/seeds/cocoapod
	name = "可可豆荚种子包"
	desc = "能长成可可树的种子，看起来会让人变胖." //SIC: cocoa is the seeds. The trees are spelled cacao.
	icon_state = "seed-cocoapod"
	species = "cocoapod"
	plantname = "Cocao Tree"
	product = /obj/item/food/grown/cocoapod
	lifespan = 20
	maturation = 5
	production = 5
	yield = 2
	instability = 20
	growthstages = 5
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "cocoapod-grow"
	icon_dead = "cocoapod-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/cocoapod/vanillapod, /obj/item/seeds/cocoapod/bungotree)
	reagents_add = list(/datum/reagent/consumable/coco = 0.25, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/cocoapod
	seed = /obj/item/seeds/cocoapod
	name = "可可果"
	desc = "使人变胖...嗯...乔可力."
	icon_state = "cocoapod"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("cocoa" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/creme_de_cacao

// Vanilla Pod
/obj/item/seeds/cocoapod/vanillapod
	name = "香草荚种子包"
	desc = "能长成香兰荚的种子，看起来会让人变胖."
	icon_state = "seed-vanillapod"
	species = "vanillapod"
	plantname = "Vanilla Tree"
	product = /obj/item/food/grown/vanillapod
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/vanilla = 0.25, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/vanillapod
	seed = /obj/item/seeds/cocoapod/vanillapod
	name = "香兰荚"
	desc = "使人变胖...嗯...香兰荚."
	icon_state = "vanillapod"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("vanilla" = 1)
	distill_reagent = /datum/reagent/consumable/vanilla //Takes longer, but you can get even more vanilla from it.

/obj/item/seeds/cocoapod/bungotree
	name = "本戈树种子包"
	desc = "能长成巴古树的种子，它们看起来很重，而且几乎是完美的球形。"
	icon_state = "seed-bungotree"
	plant_icon_offset = 4
	species = "bungotree"
	plantname = "Bungo Tree"
	product = /obj/item/food/grown/bungofruit
	lifespan = 30
	maturation = 4
	yield = 3
	production = 7
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/enzyme = 0.1, /datum/reagent/consumable/nutriment = 0.1)
	growthstages = 4
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "bungotree-grow"
	icon_dead = "bungotree-dead"
	rarity = 15

/obj/item/food/grown/bungofruit
	seed = /obj/item/seeds/cocoapod/bungotree
	name = "巴古果"
	desc = "这是一种奇特的果实，其坚硬的革质外皮包裹着多汁的果肉和巨大的有毒种子。"
	icon_state = "bungo"
	bite_consumption_mod = 2
	trash_type = /obj/item/food/grown/bungopit
	foodtypes = FRUIT
	tastes = list("bungo" = 2, "tropical fruitiness" = 1)
	distill_reagent = null

/obj/item/food/grown/bungofruit/juice_typepath()
	return /datum/reagent/consumable/bungojuice

/obj/item/food/grown/bungopit
	seed = /obj/item/seeds/cocoapod/bungotree
	name = "巴古核"
	icon_state = "bungopit"
	bite_consumption_mod = 5
	desc = "这是一颗硕大的种子，据说其毒性极强，足以让人心脏骤停。"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	foodtypes = TOXIC
	tastes = list("acrid bitterness" = 1)

/obj/item/food/grown/bungopit/Initialize(mapload)
	. =..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/bungotoxin, seed.potency * 0.10) //More than this will kill at too low potency
	reagents.add_reagent(/datum/reagent/consumable/nutriment, seed.potency * 0.04)
