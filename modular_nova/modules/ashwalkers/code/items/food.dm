/datum/reagent/consumable/sap
	name = "树液"
	description = "树木的生命之血。充满了本该属于树木的糖分，你这个怪物。"
	color = "#c9a030b6"
	taste_description = "sugary"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	evaporates = TRUE

/datum/reagent/consumable/syrup
	name = "糖浆"
	description = "一种从树木中提取并加工而成的粘稠、富含淀粉和糖分的液体。"
	color = "#3a1d05b6"
	taste_description = "sugary"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	evaporates = TRUE

/datum/crafting_recipe/food/bacon_syrup
	name = "糖浆培根"
	reqs = list(
		/obj/item/food/meat/bacon = 1,
		/datum/reagent/consumable/syrup = 2,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/sugar = 1
	)
	result = /obj/item/food/meat/bacon/syrup
	dish_category = DISH_MEAT
	meal_category = MEAL_SNACK

/obj/item/food/meat/bacon/syrup
	name = "一块糖浆培根"
	desc = "一块美味的培根，表面涂有糖浆、糖和盐。"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/syrup = 1,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/fat = 2,
	)

/datum/chemical_reaction/food/sap_syrup
	results = list(/datum/reagent/consumable/syrup = 1)
	required_reagents = list(/datum/reagent/consumable/sap = 2)
	required_temp = 390.15
	optimal_temp = 600
	mob_react = FALSE

/datum/chemical_reaction/food/syrup_sugar
	results = list(/datum/reagent/consumable/sugar = 1)
	required_reagents = list(/datum/reagent/consumable/syrup = 1)
	required_temp = 400.15
	optimal_temp = 600
	mob_react = FALSE
