// Citrus - base type
/obj/item/food/grown/citrus
	name = "柑橘"
	desc = "太酸了，你的脸会酸到扭曲的。"
	icon_state = "lime"
	abstract_type = /obj/item/food/grown/citrus
	foodtypes = FRUIT
	wine_power = 30
	seed = /obj/item/seeds/lime

// Lime
/obj/item/seeds/lime
	name = "青柠种子包"
	desc = "这些种子非常酸。"
	icon_state = "seed-lime"
	species = "lime"
	plantname = "Lime Tree"
	product = /obj/item/food/grown/citrus/lime
	lifespan = 55
	endurance = 50
	yield = 4
	potency = 15
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/orange)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/citrus/lime
	seed = /obj/item/seeds/lime
	name = "酸橙"
	desc = "It's so sour, your face will twist."
	icon_state = "lime"

/obj/item/food/grown/citrus/lime/juice_typepath()
	return /datum/reagent/consumable/limejuice

// Orange
/obj/item/seeds/orange
	name = "橙子种子包"
	desc = "很酸的种子。"
	icon_state = "seed-orange"
	species = "orange"
	plantname = "Orange Tree"
	product = /obj/item/food/grown/citrus/orange
	lifespan = 60
	endurance = 50
	yield = 5
	potency = 20
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/lime, /obj/item/seeds/orange_3d)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/citrus/orange
	seed = /obj/item/seeds/orange
	name = "橘子"
	desc = "味道很浓郁的水果。"
	icon_state = "orange"
	foodtypes = ORANGES | FRUIT
	distill_reagent = /datum/reagent/consumable/ethanol/triple_sec

/obj/item/food/grown/citrus/orange/juice_typepath()
	return /datum/reagent/consumable/orangejuice

// Lemon
/obj/item/seeds/lemon
	name = "柠檬种子包"
	desc = "这些种子很酸。"
	icon_state = "seed-lemon"
	species = "lemon"
	plantname = "Lemon Tree"
	product = /obj/item/food/grown/citrus/lemon
	lifespan = 55
	endurance = 45
	yield = 4
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/firelemon)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/citrus/lemon
	seed = /obj/item/seeds/lemon
	name = "柠檬"
	desc = "当生活给了你一堆柠檬，你就可以用它们来榨柠檬汁。"
	icon_state = "lemon"

/obj/item/food/grown/citrus/lemon/juice_typepath()
	return /datum/reagent/consumable/lemonjuice

// Combustible lemon
/obj/item/seeds/firelemon //combustible lemon is too long so firelemon
	name = "可燃柠檬种子包"
	desc = "When life gives you lemons, don't make lemonade. Make life take the lemons back! Get mad! I don't want your damn lemons!"
	icon_state = "seed-firelemon"
	species = "firelemon"
	plantname = "Combustible Lemon Tree"
	product = /obj/item/food/grown/firelemon
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/bomb_plant/potency_based)
	lifespan = 55
	endurance = 45
	yield = 4
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/fuel = 0.05)

/obj/item/food/grown/firelemon
	seed = /obj/item/seeds/firelemon
	name = "爆燃柠檬"
	desc = "专为烧毁房屋而设计的。"
	icon_state = "firelemon"
	alt_icon = "firelemon_active"
	foodtypes = FRUIT
	wine_power = 70

//3D Orange
/obj/item/seeds/orange_3d
	name = "超维橙子种子包"
	desc = "多边形形状的种子。"
	icon_state = "seed-orange"
	species = "orange"
	plantname = "Extradimensional Orange Tree"
	product = /obj/item/food/grown/citrus/orange_3d
	lifespan = 60
	endurance = 50
	yield = 5
	potency = 20
	instability = 64
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/haloperidol = 0.15) //insert joke about the effects of haloperidol and our glorious headcoder here

/obj/item/food/grown/citrus/orange_3d
	seed = /obj/item/seeds/orange_3d
	name = "超维橘子"
	desc = "你简直无法理解这个东西。"
	icon_state = "orang"
	foodtypes = ORANGES
	alt_icon = "orange"
	bite_consumption_mod = 2
	distill_reagent = /datum/reagent/toxin/mindbreaker
	tastes = list("polygons" = 1, "bluespace" = 1, "the true nature of reality" = 1)

/obj/item/food/grown/citrus/orange_3d/juice_typepath()
	return /datum/reagent/consumable/orangejuice

/obj/item/food/grown/citrus/orange_3d/pickup(mob/user)
	. = ..()
	icon_state = alt_icon

/obj/item/food/grown/citrus/orange_3d/dropped(mob/user)
	. = ..()
	icon_state = initial(icon_state)
