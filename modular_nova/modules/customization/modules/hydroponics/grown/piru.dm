// Piru
/obj/item/seeds/piru
	name = "一包皮鲁菌种"
	desc = "这种细菌菌落会形成皮鲁叶簇。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-piru"
	species = "piru"
	plantname = "Piru Colony"
	product = /obj/item/food/grown/piru
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	growing_icon = 'modular_nova/master_files/icons/obj/hydroponics/growing.dmi'
	icon_grow = "piru-grow"
	icon_dead = "piru-dead"
	lifespan = 60
	endurance = 50
	growthstages = 4
	reagents_add = list(/datum/reagent/consumable/piru_flour = 0.25)

/obj/item/food/grown/piru
	seed = /obj/item/seeds/piru
	name = "皮鲁叶簇"
	desc = "一簇精致的皮鲁叶，与其说是叶子不如说更像丝线。可研磨成用于特莎莉料理的皮鲁面粉。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/harvest.dmi'
	icon_state = "piru"
	foodtypes = VEGETABLES
	tastes = list("chalky dryness" = 1)

/obj/item/food/grown/piru/grind_results()
	return list(/datum/reagent/consumable/piru_flour = 0)
