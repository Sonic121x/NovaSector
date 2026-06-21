/obj/item/seeds/surik
	name = "苏里克种子包"
	desc = "这些种子会长成苏里克植株。据说蕴含着不可解星球的精髓。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "surik"
	species = "surik"
	plantname = "Surik Plant"
	product = /obj/item/food/grown/surik
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "surik-stage"
	growthstages = 4
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/fire_resistance)
	reagents_add = list(/datum/reagent/brimdust = 0.1, /datum/reagent/medicine/omnizine/godblood = 0.1, /datum/reagent/wittel = 0.1)

/obj/item/food/grown/surik
	seed = /obj/item/seeds/surik
	name = "苏里克"
	desc = "一块闪烁的苏里克水晶。宝石中心随着火山活动而脉动。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "surik"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("crystals" = 1)

/obj/item/food/grown/surik/juice_typepath()
	return /datum/reagent/brimdust
