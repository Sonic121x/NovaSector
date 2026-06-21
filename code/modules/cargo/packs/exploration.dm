/// Exploration drone unlockables ///

/datum/supply_pack/exploration
	order_flags = ORDER_SPECIAL
	group = "Outsourced"

/datum/supply_pack/exploration/scrapyard
	name = "Scrapyard Crate"
	desc = "包含各种垃圾。"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/relic,
					/obj/item/broken_bottle,
					/obj/item/pickaxe/rusted)
	crate_name = "scrapyard crate"

/datum/supply_pack/exploration/catering
	name = "酒席板条箱"
	desc = "没有厨师吗?没问题!食品质量可能因供应商而异。"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/food/sandwich = 5)
	crate_name = "outsourced food crate"

/datum/supply_pack/exploration/catering/fill(obj/structure/closet/crate/crate)
	. = ..()
	if(!prob(30))
		return

	for(var/obj/item/food/food_item in crate)
		// makes all of our items GROSS
		food_item.name = "变质的[food_item.name]"
		food_item.AddComponentFrom(SOURCE_EDIBLE_INNATE, /datum/component/edible, foodtypes = GROSS)

/datum/supply_pack/exploration/shrubbery
	name = "Shrubbery Crate"
	desc = "满是灌木的板条箱。"
	cost = CARGO_CRATE_VALUE * 5
	crate_name = "shrubbery crate"
	var/shrub_amount = 8

/datum/supply_pack/exploration/shrubbery/fill(obj/container)
	for(var/i in 1 to shrub_amount)
		new /obj/item/grown/shrub(container)
