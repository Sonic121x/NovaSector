/obj/item/seeds/telriis
	name = "泰尔里斯种子包"
	desc = "这些种子会长成泰尔里斯植株。作为马利筋的远亲，这种草实际上可以榨出奶状汁液。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "telriis"
	species = "telriis"
	plantname = "Telriis Plant"
	product = /obj/item/food/grown/telriis
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "telriis-stage"
	growthstages = 4
	plant_icon_offset = 7
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/invasive)
	reagents_add = list(/datum/reagent/consumable/milk = 0.1, /datum/reagent/consumable/soymilk = 0.1, /datum/reagent/consumable/korta_milk)

/obj/item/food/grown/telriis
	seed = /obj/item/seeds/telriis
	name = "泰尔里斯"
	desc = "一束泰尔里斯，可以研磨或榨成乳状液体。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "telriis"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("milk" = 1)

/obj/item/food/grown/telriis/juice_typepath()
	return /datum/reagent/consumable/coconut_milk
