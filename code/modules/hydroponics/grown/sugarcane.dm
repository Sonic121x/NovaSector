
// Sugarcane
/obj/item/seeds/sugarcane
	name = "甘蔗种子包"
	desc = "能长成甘蔗的种子。"
	icon_state = "seed-sugarcane"
	species = "sugarcane"
	plantname = "Sugarcane"
	product = /obj/item/food/grown/sugarcane
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	lifespan = 60
	endurance = 50
	maturation = 3
	yield = 4
	instability = 15
	growthstages = 2
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/sugar = 0.25)
	mutatelist = list(/obj/item/seeds/bamboo, /obj/item/seeds/sugarcane/saltcane)

/obj/item/food/grown/sugarcane
	seed = /obj/item/seeds/sugarcane
	name = "sugarcane"
	desc = "甜到死。"
	icon_state = "sugarcane"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | SUGAR
	distill_reagent = /datum/reagent/consumable/ethanol/rum

///and bamboo!
/obj/item/seeds/bamboo
	name = "竹子种子包"
	desc = "一种可产出柔韧性和抗性很高的木材的植物。"
	icon_state = "seed-bamboo"
	species = "bamboo"
	plantname = "Bamboo"
	product = /obj/item/grown/log/bamboo
	lifespan = 80
	endurance = 70
	maturation = 15
	production = 2
	yield = 5
	potency = 50
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing.dmi'
	icon_dead = "bamboo-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = null

/obj/item/grown/log/bamboo
	seed = /obj/item/seeds/bamboo
	name = "竹木"
	desc = "长度长，抗性强的竹木。"
	icon_state = "bamboo"
	plank_type = /obj/item/stack/sheet/mineral/bamboo
	plank_name = "bamboo sticks"

/obj/item/grown/log/bamboo/CheckAccepted(obj/item/I)
	return FALSE

//Saltcane - Gross, salty shafts!
/obj/item/seeds/sugarcane/saltcane
	name = "盐藤种子包"
	desc = "这些种子会长成盐藤。"
	icon_state = "seed-saltcane"
	species = "saltcane"
	plantname = "Saltcane"
	product = /obj/item/food/grown/sugarcane/saltcane
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/salt = 0.25)
	mutatelist = null

/obj/item/food/grown/sugarcane/saltcane
	seed = /obj/item/seeds/sugarcane/saltcane
	name = "盐藤"
	desc = "咸得离谱，蛞蝓的克星，马匹的珍宝。"
	icon_state = "saltcane"
	foodtypes = VEGETABLES | GROSS

/obj/item/food/grown/sugarcane/saltcane/make_dryable()
	AddElement(/datum/element/dryable, /obj/item/food/seaweedsheet/saltcane) //soooshi
