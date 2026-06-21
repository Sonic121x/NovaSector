// Modular plants

// Catnip
/obj/item/seeds/tea/catnip
	name = "猫薄荷种子包"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-catnip"
	growing_icon = 'modular_nova/master_files/icons/obj/hydroponics/growing.dmi'
	desc = "长茎带花尖，含有一种能吸引猫科动物的化学物质。"
	species = "catnip"
	plantname = "Catnip Plant"
	icon_dead = null
	growthstages = 3
	product = /obj/item/food/grown/tea/catnip
	reagents_add = list(/datum/reagent/pax/catnip = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.06, /datum/reagent/toxin/teapowder = 0.1)
	rarity = 50

/obj/item/food/grown/tea/catnip
	seed = /obj/item/seeds/tea/catnip
	name = "猫薄荷花蕾"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/harvest.dmi'
	icon_state = "catnip"
	filling_color = "#4582B4"
	distill_reagent = /datum/reagent/consumable/pinkmilk //Don't ask, cats speak in poptart
	can_distill = TRUE //override for tea's FALSE

/obj/item/food/grown/tea/catnip/grind_results()
	return list(/datum/reagent/pax/catnip = 2, /datum/reagent/water = 1)
