
// see code/module/crafting/table.dm

////////////////////////////////////////////////BREAD////////////////////////////////////////////////

/datum/crafting_recipe/food/meatbread
	name = "Meat bread-肉面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/plain = 3,
		/obj/item/food/cheese/wedge = 3
	)
	result = /obj/item/food/bread/meat
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/xenomeatbread
	name = "Xenomeat bread-异形肉面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/xeno = 3,
		/obj/item/food/cheese/wedge = 3
	)
	result = /obj/item/food/bread/xenomeat
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/spidermeatbread
	name = "Spidermeat bread-蜘蛛肉面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/spider = 3,
		/obj/item/food/cheese/wedge = 3
	)
	result = /obj/item/food/bread/spidermeat
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/sausagebread
	name = "Sausage bread-香肠面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/sausage = 2,
	)
	result = /obj/item/food/bread/sausage
	removed_foodtypes = BREAKFAST
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/banananutbread
	name = "Banana nut bread-香蕉坚果面包"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/boiledegg = 3,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/bread/banana
	removed_foodtypes = BREAKFAST|EGG
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/tofubread
	name = "Tofu bread-豆腐面包"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/tofu = 3,
		/obj/item/food/cheese/wedge = 3
	)
	result = /obj/item/food/bread/tofu
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/creamcheesebread
	name = "Cream cheese bread-奶油芝士面包"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/cheese/wedge = 2
	)
	result = /obj/item/food/bread/creamcheese
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/mimanabread
	name = "Mimana bread-默蕉面包"
	reqs = list(
		/datum/reagent/consumable/soymilk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/tofu = 3,
		/obj/item/food/grown/banana/mime = 1
	)
	result = /obj/item/food/bread/mimana
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/garlicbread
	name = "Garlic Bread-蒜蓉面包"
	time = 4 SECONDS
	reqs = list(/obj/item/food/grown/garlic = 1,
				/obj/item/food/breadslice/plain = 1,
				/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/garlicbread
	dish_category = DISH_BREAD
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/butterbiscuit
	name = "Butter Biscuit-黄油饼干"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/butterbiscuit
	added_foodtypes = BREAKFAST
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/butterdog
	name = "Butterdog-黄油狗"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butter = 1,
		)
	result = /obj/item/food/butterdog
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/baguette
	name = "Baguette-法式长棍"
	time = 4 SECONDS
	reqs = list(/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
		/obj/item/food/doughslice = 2,
	)
	result = /obj/item/food/baguette
	dish_category = DISH_BREAD
	meal_category = MEAL_SNACK

/datum/crafting_recipe/food/raw_breadstick
	name = "Raw breadstick-生面包棒"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/raw_breadstick
	dish_category = DISH_BREAD
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/raw_croissant
	name = "生可颂"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/consumable/sugar = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/raw_croissant
	dish_category = DISH_BREAD
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/throwing_croissant
	name = "投掷可颂"
	reqs = list(
		/obj/item/food/croissant = 1,
		/obj/item/stack/rods = 1,
	)
	result = /obj/item/food/croissant/throwing
	dish_category = DISH_BREAD
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/breaddog
	name = "活体狗/面包混合体"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/organ/heart = 1,
		/obj/item/food/bread/plain = 2,
		/obj/item/food/meat/slab = 3,
		/datum/reagent/blood = 30,
		/datum/reagent/teslium = 1 //To shock the whole thing into life
	)
	parts = list(
		/obj/item/organ/brain,
		/obj/item/organ/heart
	)
	result = /mob/living/basic/pet/dog/breaddog
	dish_category = DISH_BREAD
	meal_category = MEAL_UNCATEGORIZED


////////////////////////////////////////////////TOAST////////////////////////////////////////////////

/datum/crafting_recipe/food/slimetoast
	name = "Slime toast-史莱姆吐司"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/food/breadslice/plain = 1
	)
	result = /obj/item/food/jelliedtoast/slime
	added_foodtypes = TOXIC | BREAKFAST
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/jelliedyoast
	name = "Jellied toast-果酱吐司"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/food/breadslice/plain = 1
	)
	result = /obj/item/food/jelliedtoast/cherry
	added_foodtypes = FRUIT | SUGAR | BREAKFAST
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/butteredtoast
	name = "Buttered Toast-黄油吐司"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/butteredtoast
	added_foodtypes = BREAKFAST
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/twobread
	name = "Two bread-两片面包"
	reqs = list(
		/datum/reagent/consumable/ethanol/wine = 5,
		/obj/item/food/breadslice/plain = 2
	)
	result = /obj/item/food/twobread
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/moldybread // why would you make this?
	name = "Moldy Bread-发霉的面包"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/obj/item/food/grown/mushroom/amanita = 1
		)
	result = /obj/item/food/breadslice/moldy
	removed_foodtypes = VEGETABLES|GRAIN
	added_foodtypes = GROSS
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/breadcat
	name = "面包猫/面包混合体"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/organ/ears/cat = 1,
		/obj/item/organ/tail/cat = 1,
		/obj/item/food/meat/slab = 3,
		/datum/reagent/blood = 50,
		/datum/reagent/medicine/strange_reagent = 5
	)
	result = /mob/living/basic/pet/cat/breadcat
	dish_category = DISH_BREAD
	meal_category = MEAL_UNCATEGORIZED

/datum/crafting_recipe/food/frenchtoast
	name = "Raw french toast-生法式吐司"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/obj/item/food/egg = 2,
		/datum/reagent/consumable/milk = 5
	)
	result = /obj/item/food/raw_frenchtoast
	added_foodtypes = BREAKFAST
	dish_category = DISH_BREAD
	meal_category = MEAL_COMPONENT
