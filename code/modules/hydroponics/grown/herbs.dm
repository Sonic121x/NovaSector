// Herbs
/obj/item/seeds/herbs
	name = "香草种子包"
	desc = "这些种子长大后会产出各种各样的草药和调味料。"
	icon_state = "seed-herbs"
	species = "herbs"
	plantname = "Herbs"
	product = /obj/item/food/grown/herbs
	growthstages = 2
	yield = 5
	potency = 20
	growing_icon = 'icons/obj/service/hydroponics/growing.dmi'
	icon_grow = "herbs-grow"
	icon_dead = "herbs-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/herbs
	seed = /obj/item/seeds/herbs
	name = "一捆草药"
	desc = "一捆各种各样的草药(bundle of herbs)，不知何故，你总能挑出你需要的东西。"
	icon_state = "herbs"
	foodtypes = VEGETABLES
	tastes = list("nondescript herbs" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/fernet

/obj/item/food/grown/herbs/grind_results()
	return list(/datum/reagent/consumable/nutriment = 0)

/obj/item/food/grown/herbs/juice_typepath()
	return /datum/reagent/consumable/nutriment
