// Nakati
/obj/item/seeds/nakati
	name = "一包纳卡提菌种"
	desc = "这种细菌菌落会形成生物发光的纳卡提增生体。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-nakati"
	species = "nakati"
	plantname = "Nakati Colony"
	product = /obj/item/food/grown/nakati
	growing_icon = 'modular_nova/master_files/icons/obj/hydroponics/growing.dmi'
	icon_grow = "nakati-grow"
	icon_dead = "nakati-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	lifespan = 60
	endurance = 50
	growthstages = 4
	reagents_add = list(/datum/reagent/consumable/nakati_spice = 0.25)

/obj/item/food/grown/nakati
	seed = /obj/item/seeds/nakati
	name = "纳卡提树皮"
	desc = "A segment of fragrant brown 'bark' from a nakati growth, grinds into a zesty spice widely used in teshari cooking."
	icon = 'modular_nova/master_files/icons/obj/hydroponics/harvest.dmi'
	icon_state = "nakati"
	foodtypes = VEGETABLES
	tastes = list("overwhelming spicyness" = 1)

/obj/item/food/grown/nakati/grind_results()
	return list(/datum/reagent/consumable/nakati_spice = 0)
