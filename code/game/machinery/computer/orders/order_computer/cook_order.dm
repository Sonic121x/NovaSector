/obj/machinery/computer/order_console/cook
	name = "生产订购控制台"
	desc = "一个用于订购新鲜农产品及其他商品的界面。这个选项比植物学家更贵，但也无所谓。"
	circuit = /obj/item/circuitboard/computer/order_console
	order_categories = list(
		CATEGORY_FRUITS_VEGGIES,
		CATEGORY_MILK_EGGS,
		CATEGORY_SAUCES_REAGENTS,
	)
	blackbox_key = "chef"
	announcement_line = "The kitchen has ordered groceries which will arrive on the cargo shuttle! Please make sure it gets to them as soon as possible!"
	// Discount for items in the chefs category like mining/bitrunning consoles
	cargo_cost_multiplier =  0.65

/obj/machinery/computer/order_console/cook/order_groceries(mob/living/purchaser, obj/item/card/id/card, list/groceries)
	say("Thank you for your purchase! It will arrive on the next cargo shuttle!")
	aas_config_announce(/datum/aas_config_entry/order_console, list(), src, list(radio_channel), capitalize(blackbox_key))
	for(var/datum/orderable_item/ordered_item in groceries)
		if(!(ordered_item.category_index in order_categories))
			groceries.Remove(ordered_item)
			continue
		if(ordered_item in SSshuttle.chef_groceries)
			SSshuttle.chef_groceries[ordered_item] += groceries[ordered_item]
		else
			SSshuttle.chef_groceries[ordered_item] = groceries[ordered_item]
