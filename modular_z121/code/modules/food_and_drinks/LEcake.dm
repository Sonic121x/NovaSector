/datum/crafting_recipe/food/liquid_electric_cake
	name = "lecake"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/stock_parts/power_store/cell = 1,
		/obj/item/light/bulb = 1
	)
	result = /obj/item/food/cake/liquid_electric
	added_foodtypes = TOXIC
	category = CAT_CAKE

/obj/item/food/cake/liquid_electric
	name = "液电蛋糕"
	desc = "发光发热，充满能量。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "electriccake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 25,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/liquidelectricity/enriched = 15,
	)
	tastes = list("cake" = 4, "sweetness" = 1, "metal" = 2, "electricity" = 3)
	foodtypes = GRAIN | DAIRY | TOXIC | SUGAR
	slice_type = /obj/item/food/cakeslice/liquid_electric
	crafting_complexity = FOOD_COMPLEXITY_3
	light_system = OVERLAY_LIGHT
	light_color = "#00FF00"
	light_range = 3
	light_power = 0.6
	light_on = TRUE
/obj/item/food/cake/liquid_electric/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/clothing/head/utility/hardhat/cakehat/energycake)


/obj/item/food/cakeslice/liquid_electric
	name = "一块液电蛋糕"
	desc = "发光发热，充满能量。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "electriccakeslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/liquidelectricity/enriched = 3,
	)
	tastes = list("cake" = 4, "sweetness" = 1, "metal" = 2, "electricity" = 3)
	foodtypes = GRAIN | DAIRY | TOXIC | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3
	light_system = OVERLAY_LIGHT
	light_color = "#00FF00"
	light_range = 1
	light_power = 0.3
	light_on = TRUE

/obj/item/food/cakeslice/liquid_electric/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_FOOD_EATEN, PROC_REF(bite_taken))

/obj/item/food/cakeslice/liquid_electric/proc/bite_taken(datum/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER
	to_chat(eater, "<font color='blue' size='5'>As you eat the cake slice, a small electric shock courses through your body!</font>")
	if(eater != feeder)
		log_combat(feeder, eater, "fed a liquid electric cake to", src)

