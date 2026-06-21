// FOOD ITEMS
/obj/item/food/mince_pie
	name = "百果馅饼"
	desc = "圣诞欢乐的可食用化身。"
	w_class = WEIGHT_CLASS_TINY
	icon = 'modular_nova/modules/modular_items/icons/pastries.dmi'
	icon_state = "mince_pie"
	food_flags = FOOD_FINGER_FOOD
	foodtypes = GRAIN | SUGAR | DAIRY | FRUIT
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("fruit" = 1, "raisins" = 1, "christmas spirit" = 1)
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/mimce_pie
	name = "虚无馅饼"
	desc = "一种带有星形盖子的糕点，里面空无一物。"
	w_class = WEIGHT_CLASS_TINY
	icon = 'modular_nova/modules/modular_items/icons/pastries.dmi'
	icon_state = "mimce_pie"
	food_flags = FOOD_FINGER_FOOD
	foodtypes = GRAIN | FRUIT | DAIRY | SUGAR
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("nothing" = 1, "christmas spirit" = 1)
	crafting_complexity = FOOD_COMPLEXITY_3

// RECIPE

/datum/crafting_recipe/food/mince_pie
	name = "百果馅饼"
	reqs = list(
		/obj/item/food/no_raisin = 1,
		/obj/item/food/grown/apple = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/mince_pie
	removed_foodtypes = JUNKFOOD
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/mimce_pie
	name = "默剧演员派"
	reqs = list(
		/obj/item/food/no_raisin = 1,
		/obj/item/food/grown/apple = 1,
		/datum/reagent/consumable/nothing = 25,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/mimce_pie

	removed_foodtypes = JUNKFOOD
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT
