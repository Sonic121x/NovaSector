/datum/crafting_recipe/food/reaction/piru_dough
	reaction = /datum/chemical_reaction/food/piru_dough
	result = /obj/item/food/piru_dough
	cuisine_category = CUISINE_TESHARI

/datum/chemical_reaction/food/piru_dough
	required_reagents = list(
		/datum/reagent/consumable/piru_flour = 15,
		/datum/reagent/consumable/muli_juice = 10,
	)
	mix_message = "The ingredients form a dough."
	reaction_flags = REACTION_INSTANT
	resulting_food_path = /obj/item/food/piru_dough

/datum/crafting_recipe/food/spiced_jerky
	name = "香料肉干"
	reqs = list(
		/obj/item/food/meat/cutlet = 1,
		/datum/reagent/consumable/nakati_spice = 2,
	)
	result = /obj/item/food/spiced_jerky
	dish_category = DISH_MEAT
	meal_category = MEAL_SNACK
	cuisine_category = CUISINE_TESHARI

/datum/crafting_recipe/food/sirisai_wrap
	name = "Sirisai卷饼"
	reqs = list(
		/obj/item/food/breadslice/piru = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/cabbage = 1,
		/datum/reagent/consumable/nakati_spice = 5,
	)
	result = /obj/item/food/sirisai_wrap
	dish_category = DISH_SANDWICH
	meal_category = MEAL_MAIN_COURSE
	cuisine_category = CUISINE_TESHARI

/datum/crafting_recipe/food/sweet_piru_noodles
	name = "甜皮鲁面条"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/piru_pasta = 1,
		/obj/item/food/grown/kiri = 1,
		/obj/item/food/grown/muli = 1,
		/obj/item/food/grown/carrot = 1,
	)
	result = /obj/item/food/sweet_piru_noodles
	dish_category = DISH_NOODLES
	meal_category = MEAL_MAIN_COURSE
	cuisine_category = CUISINE_TESHARI

/datum/crafting_recipe/food/kiri_curry
	name = "Kiri咖喱"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/piru_pasta = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/nakati_spice = 5,
		/datum/reagent/consumable/kiri_jelly = 5,
	)
	result = /obj/item/food/kiri_curry
	dish_category = DISH_MEAT
	meal_category = MEAL_MAIN_COURSE
	cuisine_category = CUISINE_TESHARI
	added_foodtypes = FRUIT|SUGAR

/datum/crafting_recipe/food/sirisai_flatbread
	name = "西里赛扁面包"
	reqs = list(
		/obj/item/food/grilled_piru_flatbread = 1,
		/obj/item/food/meat/cutlet = 3,
		/obj/item/food/grown/muli = 1,
		/obj/item/food/grown/tomato = 1,
		/datum/reagent/consumable/nakati_spice = 5,
	)
	result = /obj/item/food/sirisai_flatbread
	dish_category = DISH_PIZZA
	meal_category = MEAL_MAIN_COURSE
	cuisine_category = CUISINE_TESHARI

/datum/crafting_recipe/food/bluefeather_crisp
	name = "蓝羽脆片"
	reqs = list(
		/obj/item/food/breadslice/piru = 1,
		/datum/reagent/consumable/nakati_spice = 2,
	)
	result = /obj/item/food/bluefeather_crisp
	dish_category = DISH_UNCATEGORIZED
	meal_category = MEAL_SNACK
	cuisine_category = CUISINE_TESHARI

/datum/crafting_recipe/food/stewed_muli
	name = "炖穆利"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/datum/reagent/consumable/muli_juice = 10,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/carrot = 1,
		/datum/reagent/consumable/nakati_spice = 5,
	)
	result = /obj/item/food/stewed_muli
	dish_category = DISH_SOUP
	meal_category = MEAL_MAIN_COURSE
	cuisine_category = CUISINE_TESHARI

/datum/crafting_recipe/food/stuffed_muli_pod
	name = "酿穆利荚"
	reqs = list(
		/obj/item/food/grown/muli = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/kiri = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/nakati_spice = 2,
	)
	result = /obj/item/food/stuffed_muli_pod
	dish_category = DISH_MEAT
	meal_category = MEAL_MAIN_COURSE
	cuisine_category = CUISINE_TESHARI

/datum/crafting_recipe/food/caramel_jelly_toast
	name = "焦糖果酱吐司"
	reqs = list(
		/obj/item/food/breadslice/piru = 1,
		/datum/reagent/consumable/kiri_jelly = 5,
		/datum/reagent/consumable/caramel = 5,
	)
	result = /obj/item/food/caramel_jelly_toast
	dish_category = DISH_BREAD
	meal_category = MEAL_DESSERT
	cuisine_category = CUISINE_TESHARI
	added_foodtypes = FRUIT|SUGAR

/datum/crafting_recipe/food/kiri_jellypuff
	name = "基里果酱泡芙"
	reqs = list(
		/obj/item/food/breadslice/piru = 1,
		/datum/reagent/consumable/kiri_jelly = 5,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/piru_flour = 5,
	)
	result = /obj/item/food/kiri_jellypuff
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT
	cuisine_category = CUISINE_TESHARI
	added_foodtypes = FRUIT|SUGAR

/datum/crafting_recipe/food/bluefeather_crisps_and_dip
	name = "蓝羽脆片配蘸酱"
	reqs = list(
		/obj/item/food/bluefeather_crisp = 2,
		/datum/reagent/consumable/muli_juice = 5,
		/obj/item/food/grown/tomato = 1,
		/datum/reagent/consumable/nakati_spice = 5,
	)
	result = /obj/item/food/bluefeather_crisps_and_dip
	dish_category = DISH_CONDIMENT
	meal_category = MEAL_APPETIZER
	cuisine_category = CUISINE_TESHARI

