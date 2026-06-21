/obj/item/seeds/shand
	name = "闪德种子包"
	desc = "这些种子会长成闪德植株。虽然其本身用途不大，但它富含其他植物无法产生的化学物质。是杂交育种的良好候选。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "shand"
	species = "shand"
	plantname = "Shand Plant"
	product = /obj/item/food/grown/shand
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "shand-stage"
	growthstages = 3
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/maxchem)
	reagents_add = list(/datum/reagent/bromine = 0.1, /datum/reagent/sodium = 0.1, /datum/reagent/copper = 0.1)

/obj/item/food/grown/shand
	seed = /obj/item/seeds/shand
	name = "闪德"
	desc = "一把闪德叶子，叶片油腻，闻起来像实验室的味道。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "shand"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("chemicals" = 1)

/obj/item/food/grown/shand/juice_typepath()
	return /datum/reagent/bromine
