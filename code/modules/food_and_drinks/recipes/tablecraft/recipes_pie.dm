
// see code/module/crafting/table.dm

////////////////////////////////////////////////PIES////////////////////////////////////////////////

/datum/crafting_recipe/food/bananacreampie
	name = "Banana cream pie-香蕉奶油派"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/pie/cream
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/meatpie
	name = "Meat pie-肉馅饼"
	reqs = list(
		/datum/reagent/consumable/blackpepper = 1,
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/meat/steak/plain = 1
	)
	result = /obj/item/food/pie/meatpie
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/tofupie
	name = "Tofu pie-豆腐馅饼"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/tofu = 1
	)
	result = /obj/item/food/pie/tofupie
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/xenopie
	name = "Xeno pie-异形馅饼"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/meat/cutlet/xeno = 1
	)
	result = /obj/item/food/pie/xemeatpie
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/cherrypie
	name = "Cherry pie-樱桃馅饼"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/cherries = 1
	)
	result = /obj/item/food/pie/cherrypie
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/berryclafoutis
	name = "Berry clafoutis-浆果克拉芙缇"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/pie/berryclafoutis
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/bearypie
	name = "Beary Pie-熊派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 1,
		/obj/item/food/meat/steak/bear = 1
	)
	result = /obj/item/food/pie/bearypie
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/amanitapie
	name = "Amanita pie-鹅膏菌馅饼"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/mushroom/amanita = 1
	)
	result = /obj/item/food/pie/amanita_pie
	added_foodtypes = TOXIC|GROSS
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/plumppie
	name = "Plump pie-肉盔菇馅饼"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/mushroom/plumphelmet = 1
	)
	result = /obj/item/food/pie/plump_pie
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/applepie
	name = "Apple pie-苹果派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/pie/applepie
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/pumpkinpie
	name = "Pumpkin pie-南瓜馅饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/pumpkin = 1
	)
	result = /obj/item/food/pie/pumpkinpie
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/goldenappletart
	name = "Golden apple tart-金苹果挞"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple/gold = 1
	)
	result = /obj/item/food/pie/appletart
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/grapetart
	name = "Grape tart-葡萄挞"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/grapes = 3
	)
	result = /obj/item/food/pie/grapetart
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/mimetart
	name = "Mime tart-默剧挞"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/datum/reagent/consumable/nothing = 5
	)
	result = /obj/item/food/pie/mimetart
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT
	added_foodtypes = SUGAR
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/berrytart
	name = "Berry tart-浆果挞"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 3
	)
	result = /obj/item/food/pie/berrytart
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT
	added_foodtypes = SUGAR
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/cocolavatart
	name = "Chocolate Lava tart-巧克力熔岩挞"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/chocolatebar = 3,
		/obj/item/slime_extract = 1 //The reason you dont know how to make it!
	)
	result = /obj/item/food/pie/cocolavatart
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT
	added_foodtypes = SUGAR
	removed_foodtypes = JUNKFOOD
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/blumpkinpie
	name = "Blumpkin pie-蓝南瓜馅饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/pumpkin/blumpkin = 1
	)
	result = /obj/item/food/pie/blumpkinpie
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/dulcedebatata
	name = "Dulce de batata-甜红薯派"
	reqs = list(
		/datum/reagent/consumable/vanilla = 5,
		/datum/reagent/water = 5,
		/obj/item/food/grown/potato/sweet = 2
	)
	result = /obj/item/food/pie/dulcedebatata
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/frostypie
	name = "Frosty pie-霜冻派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/bluecherries = 1
	)
	result = /obj/item/food/pie/frostypie
	added_foodtypes = FRUIT|SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/baklava
	name = "Baklava pie-果仁蜜派"
	reqs = list(
		/obj/item/food/butterslice = 2,
		/obj/item/food/tortilla = 4, //Layers
		/obj/item/seeds/wheat/oat = 4
	)
	result = /obj/item/food/pie/baklava
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/frenchsilkpie
	name = "French silk pie-丝滑巧克力派"
	reqs = list(
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/chocolatebar = 2,
	)
	result = /obj/item/food/pie/frenchsilkpie
	removed_foodtypes = JUNKFOOD
	added_foodtypes = SUGAR
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/shepherds_pie
	name = "Shepherds pie-牧羊人派"
	reqs = list(
		/obj/item/food/mashed_potatoes = 1,
		/obj/item/food/meat/cutlet = 3,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/peas = 1,
		/obj/item/food/grown/corn = 1,
		/obj/item/food/grown/garlic = 1,
	)
	result = /obj/item/food/pie/shepherds_pie
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/asdfpie
	name = "派味派"
	reqs = list(
		/obj/item/food/pie/plain = 2,
	)
	result = /obj/item/food/pie/asdfpie
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/bacid_pie
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/stock_parts/power_store/cell = 2,
	)
	requirements_mats_blacklist = list(/obj/item/stock_parts/power_store/cell)
	result = /obj/item/food/pie/bacid_pie
	added_foodtypes = TOXIC
	dish_category = DISH_PIE
	meal_category = MEAL_DESSERT
