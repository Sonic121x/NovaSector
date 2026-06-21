/obj/item/seeds/thaadra
	name = "萨德拉种子包"
	desc = "这些种子会长成萨德拉植株。一种充满独特药物和银元素的奇异花朵。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "thaadra"
	species = "thaadra"
	plantname = "Thaadra Plant"
	product = /obj/item/food/grown/thaadra
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "thaadra-stage"
	growthstages = 4
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/preserved)
	reagents_add = list(/datum/reagent/silver = 0.1, /datum/reagent/medicine/sansufentanyl = 0.1, /datum/reagent/medicine/cordiolis_hepatico = 0.1)

/obj/item/food/grown/thaadra
	seed = /obj/item/seeds/thaadra
	name = "萨德拉"
	desc = "一簇萨德拉花瓣，富含小众药用化学物质。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "thaadra"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("silver" = 1)

/obj/item/food/grown/thaadra/juice_typepath()
	return /datum/reagent/silver
