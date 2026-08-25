// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/computer/order_console/cook
	name = "Produce Orders Console"
	desc = "An interface for ordering fresh produce and other. A far more expensive option than the botanists, but oh well."
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
	say(LANG("obj.7e5306e0ef9ee55e", null))
	aas_config_announce(/datum/aas_config_entry/order_console, list(), src, list(radio_channel), capitalize(blackbox_key))
	for(var/datum/orderable_item/ordered_item in groceries)
		if(!(ordered_item.category_index in order_categories))
			groceries.Remove(ordered_item)
			continue
		if(ordered_item in SSshuttle.chef_groceries)
			SSshuttle.chef_groceries[ordered_item] += groceries[ordered_item]
		else
			SSshuttle.chef_groceries[ordered_item] = groceries[ordered_item]
