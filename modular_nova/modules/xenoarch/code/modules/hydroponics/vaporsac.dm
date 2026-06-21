/obj/item/seeds/vaporsac
	name = "气雾囊种子包"
	desc = "这些种子会长成气雾囊植物。通常气雾囊植物通过漂浮在空中并爆炸来传播，但幸好这种品系的气雾囊不会。"
	icon = 'modular_nova/modules/xenoarch/icons/seeds.dmi'
	icon_state = "vaporsac"
	species = "vaporsac"
	plantname = "Vaporsac Plant"
	product = /obj/item/food/grown/vaporsac
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'modular_nova/modules/xenoarch/icons/growing.dmi'
	icon_grow = "vaporsac-stage"
	growthstages = 3
	genes = list(/datum/plant_gene/trait/squash, /datum/plant_gene/trait/smoke)
	reagents_add = list(/datum/reagent/nitrous_oxide = 0.1, /datum/reagent/medicine/muscle_stimulant = 0.1, /datum/reagent/medicine/coagulant = 0.1)

/obj/item/food/grown/vaporsac
	seed = /obj/item/seeds/vaporsac
	name = "气雾囊"
	desc = "一个充满气溶胶化学物质的浮力气雾囊。"
	icon = 'modular_nova/modules/xenoarch/icons/harvest.dmi'
	icon_state = "vaporsac"
	filling_color = "#FF4500"
	bite_consumption_mod = 0.5
	foodtypes = FRUIT
	tastes = list("sleep" = 1)

/obj/item/food/grown/vaporsac/juice_typepath()
	return /datum/reagent/nitrous_oxide
