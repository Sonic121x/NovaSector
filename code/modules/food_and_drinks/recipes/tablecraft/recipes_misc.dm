
// see code/module/crafting/table.dm

// MISC

/datum/crafting_recipe/food/candiedapple
	name = "Candied apple-苹果蜜饯"
	reqs = list(
		/datum/reagent/consumable/caramel = 5,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/candiedapple
	added_foodtypes = JUNKFOOD|SUGAR
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/spiderlollipop
	name = "Spider Lollipop-蜘蛛棒棒糖"
	reqs = list(/obj/item/stack/rods = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/water = 5,
		/obj/item/food/spiderling = 1
	)
	result = /obj/item/food/spiderlollipop
	added_foodtypes = JUNKFOOD|SUGAR
	removed_foodtypes = TOXIC
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/chococoin
	name = "Choco coin-巧克力硬币"
	reqs = list(/obj/item/food/chocolatebar = 1)
	tool_paths = list(/obj/item/coin)
	result = /obj/item/food/chococoin
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/fudgedice
	name = "Fudge dice-软糖骰子"
	reqs = list(
		/obj/item/dice = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/fudgedice
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/chocoorange
	name = "Choco orange-巧克力橙子"
	reqs = list(
		/obj/item/food/grown/citrus/orange = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/chocoorange
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/cheesyfries
	name = "Cheesy fries-芝士薯条"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/cheese/wedge = 1
	)
	result = /obj/item/food/cheesyfries
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/poutine
	name = "Poutine-肉汁乳酪薯条"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/cheese/wedge = 1,
		/datum/reagent/consumable/gravy = 3
	)
	result = /obj/item/food/poutine
	added_foodtypes = MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/beans
	name = "豆子"
	time = 4 SECONDS
	reqs = list(/datum/reagent/consumable/ketchup = 5,
		/obj/item/food/grown/soybeans = 2
	)
	result = /obj/item/food/canned/beans
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/eggplantparm
	name ="茄子帕尔马干酪"
	reqs = list(
		/obj/item/food/cheese/wedge = 2,
		/obj/item/food/grown/eggplant = 1
	)
	result = /obj/item/food/eggplantparm
	dish_category = DISH_SALAD // ??
	cuisine_category = CUISINE_ITALIAN

/datum/crafting_recipe/food/melonkeg
	name ="西瓜酒桶"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 25,
		/obj/item/food/grown/holymelon = 1,
		/obj/item/reagent_containers/cup/glass/bottle/vodka = 1
	)
	result = /obj/item/food/melonkeg
	added_foodtypes = ALCOHOL
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/honeybar
	name = "Honey nut bar-蜂蜜坚果棒"
	reqs = list(
		/obj/item/food/grown/oat = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/honeybar
	added_foodtypes = SUGAR
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/powercrepe
	name = "Powercrepe-能量薄饼"
	time = 4 SECONDS
	reqs = list(
		/obj/item/food/flatdough = 1,
		/datum/reagent/consumable/milk = 1,
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/stock_parts/power_store/cell/super =1,
		/obj/item/melee/sabre = 1
	)
	result = /obj/item/food/powercrepe
	added_foodtypes = FRUIT|SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/branrequests
	name = "Bran Requests Cereal-麸皮需求麦片"
	reqs = list(
		/obj/item/food/grown/wheat = 1,
		/obj/item/food/no_raisin = 1,
	)
	result = /obj/item/food/branrequests
	removed_foodtypes = JUNKFOOD
	added_foodtypes = BREAKFAST

/datum/crafting_recipe/food/ricepudding
	name = "Rice pudding-大米布丁"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/boiledrice = 1
	)
	result = /obj/item/food/salad/ricepudding
	added_foodtypes = DAIRY|SUGAR
	removed_foodtypes = BREAKFAST
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/risotto
	name = "Risotto-意式烩饭"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/cheese/wedge = 1,
		/datum/reagent/consumable/ethanol/wine = 5,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/mushroom/chanterelle = 1
	)
	result = /obj/item/food/salad/risotto
	removed_foodtypes = BREAKFAST
	dish_category = DISH_SALAD

/datum/crafting_recipe/food/butterbear //ITS ALIVEEEEEE!
	name = "活体熊/黄油混合体"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/organ/heart = 1,
		/obj/item/food/butter = 4,
		/obj/item/food/meat/slab = 5,
		/datum/reagent/blood = 50,
		/datum/reagent/teslium = 1 //To shock the whole thing into life
	)
	parts = list(
		/obj/item/organ/brain,
		/obj/item/organ/heart
	)
	result = /mob/living/basic/bear/butter
	dish_category = DISH_UNCATEGORIZED
	meal_category = MEAL_UNCATEGORIZED

/datum/crafting_recipe/food/crab_rangoon
	name = "Crab Rangoon-炸蟹角"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/slab/rawcrab = 1
	)
	result = /obj/item/food/crab_rangoon
	removed_foodtypes = RAW
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/royalcheese
	name = "Royal Cheese-皇家奶酪"
	reqs = list(
		/obj/item/food/cheese/wheel = 1,
		/obj/item/clothing/head/costume/crown = 1,
		/datum/reagent/medicine/strange_reagent = 5,
		/datum/reagent/toxin/mutagen = 5
	)
	result = /obj/item/food/cheese/royal
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/ant_candy
	name = "Ant Candy-蚂蚁糖"
	reqs = list(/obj/item/stack/rods = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/water = 5,
		/datum/reagent/ants = 10
	)
	result = /obj/item/food/ant_candy
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/pesto
	name = "Pesto-意大利松子青酱"
	reqs = list(
		/obj/item/food/cheese/firm_cheese_slice = 1,
		/datum/reagent/consumable/salt = 5,
		/obj/item/food/grown/herbs = 2,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5,
		/obj/item/food/canned/pine_nuts = 1
	)
	result = /obj/item/food/pesto
	dish_category = DISH_CONDIMENT
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/tomato_sauce
	name = "Tomato sauce-番茄酱"
	reqs = list(
		/obj/item/food/canned/tomatoes = 1,
		/datum/reagent/consumable/salt = 2,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5
	)
	result = /obj/item/food/tomato_sauce
	dish_category = DISH_CONDIMENT
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/bechamel_sauce
	name = "Bechamel sauce-贝夏梅尔调味酱"
	reqs = list(
		/datum/reagent/consumable/milk = 10,
		/datum/reagent/consumable/flour = 5,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/bechamel_sauce
	added_foodtypes = GRAIN
	dish_category = DISH_CONDIMENT
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/pierogi
	name = "波兰饺子"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/pierogi
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/stuffed_cabbage
	name = "Stuffed cabbage-填馅卷心菜"
	reqs = list(
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1,
	)
	result = /obj/item/food/stuffed_cabbage
	removed_foodtypes = BREAKFAST
	dish_category = DISH_SALAD

/datum/crafting_recipe/food/granola_bar
	name = "Granola bar-燕麦能量棒"
	reqs = list(
		/obj/item/food/grown/oat = 1,
		/obj/item/food/grown/peanut = 1,
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/no_raisin = 1,
	)
	result = /obj/item/food/granola_bar
	removed_foodtypes = JUNKFOOD
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/onigiri
	name = "Onigiri-饭团"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/seaweedsheet = 1,
	)
	result = /obj/item/food/onigiri
	removed_foodtypes = BREAKFAST
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/mashed_potatoes
	name = "Mashed potatoes-土豆泥"
	reqs = list(
		/obj/item/food/grown/potato = 2,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/mashed_potatoes
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/pacoca
	name = "Pacoca-巴考卡-花生砖糖"
	reqs = list(
		/obj/item/food/grown/peanut = 2,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/pacoca
	added_foodtypes = SUGAR
	dish_category = DISH_CANDY

/datum/crafting_recipe/food/springroll
	name = "Spring roll-春卷"
	reqs = list(
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/cucumber = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/rice = 10,
		/datum/reagent/water = 10,
	)
	result = /obj/item/food/springroll
	added_foodtypes = GRAIN
	meal_category = MEAL_APPETIZER
	// cuisine_category = CUISINE_CHINESE

/datum/crafting_recipe/food/caramel_popcorn
	name = "焦糖爆米花"
	reqs = list(
		/obj/item/food/popcorn = 1,
		/datum/reagent/consumable/caramel = 3,
	)
	result = /obj/item/food/popcorn/caramel
	added_foodtypes = SUGAR
	dish_category = DISH_CANDY
	meal_category = MEAL_SNACK

/datum/crafting_recipe/food/salty_popcorn
	name = "咸味爆米花"
	reqs = list(
		/obj/item/food/popcorn = 1,
		/datum/reagent/consumable/salt = 3,
	)
	result = /obj/item/food/popcorn/salty
	meal_category = MEAL_SNACK

/datum/crafting_recipe/food/spacylibertyduff
	name = "太空自由布丁"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/grown/mushroom/libertycap = 3
	)
	result = /obj/item/food/bowled/spacylibertyduff
	meal_category = MEAL_DESSERT // jello

/datum/crafting_recipe/food/amanitajelly
	name = "毒蝇伞果冻"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/grown/mushroom/amanita = 3
	)
	result = /obj/item/food/bowled/amanitajelly
	added_foodtypes = TOXIC
	meal_category = MEAL_DESSERT // jello

/datum/crafting_recipe/food/buttered_baked_potato
	name = "黄油烤土豆"
	reqs = list(
		/obj/item/food/baked_potato = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/buttered_baked_potato
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/loaded_baked_potato
	name = "Loaded baked potato-撒好料的烤土豆"
	reqs = list(
		/obj/item/food/baked_potato = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/loaded_baked_potato
	removed_foodtypes = BREAKFAST
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/cheese_pierogi
	name = "奶酪波兰饺子"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/cheese/wedge = 1,
	)
	result = /obj/item/food/cheese_pierogi
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/meat_pierogi
	name = "肉馅波兰饺子"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/meat/cutlet = 1,
	)
	result = /obj/item/food/meat_pierogi
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/bonbon/caramel_truffle
	name = "焦糖松露"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/caramel = 2,
	)
	result = /obj/item/food/bonbon/caramel_truffle
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/bonbon/chocolate_truffle
	name = "巧克力松露"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/sugar = 2,
	)
	result = /obj/item/food/bonbon/chocolate_truffle
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/bonbon/peanut_truffle
	name = "花生松露"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/grown/peanut = 1,
	)
	result = /obj/item/food/bonbon/peanut_truffle
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/bonbon/peanut_butter_cup
	name = "花生酱杯"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/peanut_butter = 2,
	)
	result = /obj/item/food/bonbon/peanut_butter_cup
	added_foodtypes = NUTS
	dish_category = DISH_CANDY

/datum/crafting_recipe/pickles_jar
	name = "Jar of pickles-一罐泡菜"
	reqs = list(
		/obj/item/reagent_containers/cup/beaker/large = 1,
		/obj/item/food/grown/cucumber = 10,
		/datum/reagent/water/salt = 20,
	)
	result = /obj/item/storage/fancy/pickles_jar
	category = CAT_FOOD
	delete_contents = FALSE

/datum/crafting_recipe/food/sauteed_eggplant
	name = "炒茄子"
	reqs = list(
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 3,
	)
	result = /obj/item/food/sauteed_eggplant
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/stuffed_eggplant
	name = "酿茄子"
	reqs = list(
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/cutlet = 1,
	)
	result = /obj/item/food/stuffed_eggplant
	dish_category = DISH_SALAD

/datum/crafting_recipe/food/baba_ghanoush
	name = "巴巴甘努许"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/pita_bread = 1,
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5,
		/datum/reagent/consumable/lemonjuice = 3,
	)
	result = /obj/item/food/baba_ghanoush
	dish_category = DISH_CONDIMENT

/datum/crafting_recipe/food/moussaka
	name = "慕萨卡"
	reqs = list(
		/obj/item/food/grown/eggplant = 2,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/bechamel_sauce = 1,
	)
	result = /obj/item/food/moussaka
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/falafel
	name = "法拉费"
	reqs = list(
		/obj/item/food/grown/soybeans = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/herbs = 1,
	)
	result = /obj/item/food/falafel
	dish_category = DISH_UNCATEGORIZED

/datum/crafting_recipe/food/candied_pineapple
	name = "蜜饯菠萝"
	reqs = list(
		/obj/item/food/pineappleslice = 1,
		/datum/reagent/consumable/sugar = 2,
		/datum/reagent/water = 2,
	)
	result = /obj/item/food/candied_pineapple
	added_foodtypes = SUGAR
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/tzatziki_sauce
	name = "酸奶黄瓜酱"
	reqs = list(
		/obj/item/food/grown/cucumber = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/salt = 1,
	)
	result = /obj/item/food/tzatziki_sauce
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/tzatziki_and_pita_bread
	name = "酸奶黄瓜酱配皮塔饼"
	reqs = list(
		/obj/item/food/tzatziki_sauce = 1,
		/obj/item/food/pita_bread = 1,
	)
	result = /obj/item/food/tzatziki_and_pita_bread
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/grilled_beef_gyro
	name = "烤牛肉卷饼"
	reqs = list(
		/obj/item/food/tzatziki_sauce = 1,
		/obj/item/food/pita_bread = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/grilled_beef_gyro
	dish_category = DISH_BURRITO

/datum/crafting_recipe/food/vegetarian_gyro
	name = "素食卷饼"
	reqs = list(
		/obj/item/food/tzatziki_sauce = 1,
		/obj/item/food/pita_bread = 1,
		/obj/item/food/grown/cucumber = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/vegetarian_gyro
	dish_category = DISH_BURRITO

/datum/crafting_recipe/food/raw_pita_bread
	name = "生皮塔饼"
	reqs = list(
		/datum/reagent/consumable/flour = 10,
		/datum/reagent/water = 5,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
		/datum/reagent/consumable/sugar = 2,
	)
	result = /obj/item/food/raw_pita_bread
	dish_category = DISH_BREAD
