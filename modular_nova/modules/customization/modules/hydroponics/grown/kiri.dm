// Kiri
/obj/item/seeds/kiri
	name = "一包基里果苗"
	desc = "这种细菌菌落会形成基里果。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-kiri"
	species = "kiri"
	plantname = "Kiri Colony"
	product = /obj/item/food/grown/kiri
	growing_icon = 'modular_nova/master_files/icons/obj/hydroponics/growing.dmi'
	icon_grow = "kiri-grow"
	icon_dead = "kiri-dead"
	lifespan = 60
	endurance = 50
	growthstages = 4
	reagents_add = list(/datum/reagent/consumable/kiri_jelly = 0.04, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/kiri
	seed = /obj/item/seeds/kiri
	name = "基里果"
	desc = "一种奇特的蛋形水果，带有鲜艳的粉黄条纹。手感略硬，但整体可食用。内含一种超甜果冻，常用于特莎莉料理，也可单独烘烤制成美味点心。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/harvest.dmi'
	icon_state = "kiri"
	foodtypes = FRUIT | SUGAR
	distill_reagent = /datum/reagent/consumable/ethanol/shakiri
	tastes = list("ultra-sweet jelly" = 1)

/obj/item/food/grown/kiri/grind_results()
	return list(/datum/reagent/consumable/kiri_jelly = 0.1)

/obj/item/food/grown/kiri/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/baked_kiri, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)
