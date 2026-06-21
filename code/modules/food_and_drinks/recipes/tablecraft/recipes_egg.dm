
// see code/module/crafting/table.dm

////////////////////////////////////////////////EGG RECIPE's////////////////////////////////////////////////

/datum/crafting_recipe/food/sausageegg
	name = "腊肠煎蛋"
	reqs = list(
		/obj/item/food/sausage = 1,
		/obj/item/food/friedegg = 1,
	)
	result = /obj/item/food/eggsausage
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/omelette
	name = "奶酪煎蛋卷"
	reqs = list(
		/obj/item/food/egg = 2,
		/obj/item/food/cheese/wedge = 2
	)
	result = /obj/item/food/omelette
	added_foodtypes = BREAKFAST
	removed_foodtypes = RAW

/datum/crafting_recipe/food/chocolateegg
	name = "巧克力蛋"
	reqs = list(
		/obj/item/food/boiledegg = 1,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/chocolateegg
	removed_foodtypes = MEAT|BREAKFAST //This recipe is very wrong, please change it ffs
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/eggsbenedict
	name = "Eggs benedict-班尼迪克蛋"
	reqs = list(
		/obj/item/food/friedegg = 1,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/breadslice/plain = 1,
	)
	result = /obj/item/food/benedict
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/eggbowl
	name = "Egg bowl-蛋碗"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/corn = 1
	)
	result = /obj/item/food/salad/eggbowl
	removed_foodtypes = BREAKFAST
	dish_category = DISH_RICE

/datum/crafting_recipe/food/wrap
	name = "Egg Wrap-蛋卷"
	reqs = list(/datum/reagent/consumable/soysauce = 10,
		/obj/item/food/friedegg = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/eggwrap
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MEXICAN
	dish_category = DISH_BURRITO

/datum/crafting_recipe/food/chawanmushi
	name = "Chawanmushi-茶碗蒸"
	reqs = list(
		/datum/reagent/water = 5,
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/food/boiledegg = 2,
		/obj/item/food/grown/mushroom/chanterelle = 1
	)
	result = /obj/item/food/chawanmushi
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_JAPANESE
