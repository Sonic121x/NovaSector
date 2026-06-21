// CUCUMBERS YEAH
/obj/item/seeds/cucumber
	name = "黄瓜种子包"
	desc = "能长成黄瓜植株的种子。"
	icon_state = "seed-cucumber"
	species = "cucumber"
	plantname = "Cucumber Plant"
	product = /obj/item/food/grown/cucumber
	maturation = 10
	production = 1
	yield = 5
	instability = 15
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	icon_grow = "cucumber-grow"
	icon_dead = "cucumber-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/cucumber
	seed = /obj/item/seeds/cucumber
	name = "黄瓜"
	desc = "长椭圆形和绿色，有疙瘩，这是沙拉的标准。"
	icon_state = "cucumber"
	foodtypes = VEGETABLES
	tastes = list("cucumber" = 1)

/obj/item/food/grown/cucumber/juice_typepath()
	return /datum/reagent/consumable/cucumberjuice
