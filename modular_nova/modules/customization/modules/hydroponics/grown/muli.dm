// Muli
/obj/item/seeds/muli
	name = "一包穆利菌种"
	desc = "这种细菌菌落会形成穆利豆荚。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-muli"
	species = "muli"
	plantname = "Muli Colony"
	product = /obj/item/food/grown/muli
	growing_icon = 'modular_nova/master_files/icons/obj/hydroponics/growing.dmi'
	icon_grow = "muli-grow"
	icon_dead = "muli-dead"
	lifespan = 60
	endurance = 50
	growthstages = 4
	reagents_add = list(/datum/reagent/consumable/muli_juice = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/muli
	seed = /obj/item/seeds/muli
	name = "穆利豆荚"
	desc = "一种柔软的椭圆形豆荚。内含薄荷味的淡蓝色汁液，在特莎莉料理中有多种用途。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/harvest.dmi'
	icon_state = "muli"
	foodtypes = VEGETABLES
	tastes = list("mint and savory sweetness" = 1)

/obj/item/food/grown/muli/juice_typepath()
	return list(/datum/reagent/consumable/muli_juice = 0.1)

/obj/item/food/grown/muli/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/baked_muli, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)
