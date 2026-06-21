
// see code/module/crafting/table.dm

////////////////////////////////////////////////DONUTS////////////////////////////////////////////////

/datum/crafting_recipe/food/donut
	time = 1.5 SECONDS
	name = "Donut-甜甜圈"
	reqs = list(
		/datum/reagent/consumable/sugar = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/plain
	added_foodtypes = JUNKFOOD|SUGAR|BREAKFAST|FRIED
	removed_foodtypes = RAW
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donut/chaos
	name = "Chaos donut-混乱甜甜圈"
	reqs = list(
		/datum/reagent/consumable/frostoil = 5,
		/datum/reagent/consumable/capsaicin = 5,
		/obj/item/food/pastrybase = 1
	)
	added_foodtypes = JUNKFOOD|BREAKFAST|FRIED
	result = /obj/item/food/donut/chaos

/datum/crafting_recipe/food/donut/meat
	time = 1.5 SECONDS
	name = "Meat donut-肉甜甜圈"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 1,
		/obj/item/food/pastrybase = 1
	)
	added_foodtypes = JUNKFOOD|BREAKFAST|FRIED|GORE
	result = /obj/item/food/donut/meat

/datum/crafting_recipe/food/donut/jelly
	name = "Jelly donut-果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 5,
		/obj/item/food/pastrybase = 1
	)
	added_foodtypes = parent_type::added_foodtypes|FRUIT
	result = /obj/item/food/donut/jelly/plain

/datum/crafting_recipe/food/donut/slimejelly
	name = "Slime jelly donut-史莱姆果冻甜甜圈"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/food/pastrybase = 1
	)
	added_foodtypes = parent_type::added_foodtypes|TOXIC
	result = /obj/item/food/donut/jelly/slimejelly/plain


/datum/crafting_recipe/food/donut/berry
	name = "Berry Donut-浆果甜甜圈"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 3,
		/obj/item/food/donut/plain = 1
	)
	added_foodtypes = parent_type::added_foodtypes|FRUIT
	result = /obj/item/food/donut/berry

/datum/crafting_recipe/food/donut/trumpet
	name = "Spaceman's Donut-太空人甜甜圈"
	reqs = list(
		/datum/reagent/medicine/polypyr = 3,
		/obj/item/food/donut/plain = 1
	)

	result = /obj/item/food/donut/trumpet

/datum/crafting_recipe/food/donut/apple
	name = "Apple Donut-苹果甜甜圈"
	reqs = list(
		/datum/reagent/consumable/applejuice = 3,
		/obj/item/food/donut/plain = 1
	)
	added_foodtypes = parent_type::added_foodtypes|FRUIT
	result = /obj/item/food/donut/apple

/datum/crafting_recipe/food/donut/caramel
	name = "Caramel Donut-焦糖甜甜圈"
	reqs = list(
		/datum/reagent/consumable/caramel = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/caramel

/datum/crafting_recipe/food/donut/choco
	name = "Chocolate Donut-巧克力甜甜圈"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/choco

/datum/crafting_recipe/food/donut/blumpkin
	name = "Blumpkin Donut-蓝瓜甜甜圈"
	reqs = list(
		/datum/reagent/consumable/blumpkinjuice = 3,
		/obj/item/food/donut/plain = 1
	)
	added_foodtypes = VEGETABLES
	result = /obj/item/food/donut/blumpkin

/datum/crafting_recipe/food/donut/bungo
	name = "Bungo Donut-夏威夷风情甜甜圈"
	reqs = list(
		/datum/reagent/consumable/bungojuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/bungo

/datum/crafting_recipe/food/donut/matcha
	name = "Matcha Donut-抹茶甜甜圈"
	reqs = list(
		/datum/reagent/toxin/teapowder = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/matcha

/datum/crafting_recipe/food/donut/laugh
	name = "Sweet Pea Donut-香豌豆甜甜圈"
	reqs = list(
		/datum/reagent/consumable/laughsyrup = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/laugh

////////////////////////////////////////////////////JELLY DONUTS///////////////////////////////////////////////////////

/datum/crafting_recipe/food/donut/jelly/berry
	name = "Berry Jelly Donut-浆果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/berry

/datum/crafting_recipe/food/donut/jelly/trumpet
	name = "Spaceman's Jelly Donut_太空人果冻甜甜圈"
	reqs = list(
		/datum/reagent/medicine/polypyr = 3,
		/obj/item/food/donut/jelly/plain = 1
	)

	result = /obj/item/food/donut/jelly/trumpet

/datum/crafting_recipe/food/donut/jelly/apple
	name = "Apple Jelly Donut-苹果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/applejuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/apple

/datum/crafting_recipe/food/donut/jelly/caramel
	name = "Caramel Jelly Donut-焦糖果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/caramel = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/caramel

/datum/crafting_recipe/food/donut/jelly/choco
	name = "Chocolate Jelly Donut-巧克力果冻甜甜圈"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/choco

/datum/crafting_recipe/food/donut/jelly/blumpkin
	name = "Blumpkin Jelly Donut-蓝瓜果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/blumpkinjuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	added_foodtypes = parent_type::added_foodtypes|VEGETABLES
	result = /obj/item/food/donut/jelly/blumpkin

/datum/crafting_recipe/food/donut/jelly/bungo
	name = "Bungo Jelly Donut-夏威夷果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/bungojuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/bungo

/datum/crafting_recipe/food/donut/jelly/matcha
	name = "Matcha Jelly Donut-抹茶果冻甜甜圈"
	reqs = list(
		/datum/reagent/toxin/teapowder = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/matcha

/datum/crafting_recipe/food/donut/jelly/laugh
	name = "Sweet Pea Jelly Donut-香豌豆果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/laughsyrup = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/laugh

////////////////////////////////////////////////////SLIME  DONUTS///////////////////////////////////////////////////////

/datum/crafting_recipe/food/donut/slimejelly/berry
	name = "Berry Slime Donut-浆果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	added_foodtypes = parent_type::added_foodtypes|FRUIT
	result = /obj/item/food/donut/jelly/slimejelly/berry

/datum/crafting_recipe/food/donut/slimejelly/trumpet
	name = "Spaceman's Slime Donut宇航员黏胶甜甜圈"
	reqs = list(
		/datum/reagent/medicine/polypyr = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)

	result = /obj/item/food/donut/jelly/slimejelly/trumpet

/datum/crafting_recipe/food/donut/slimejelly/apple
	name = "Apple Slime Donut-苹果黏胶甜甜圈"
	reqs = list(
		/datum/reagent/consumable/applejuice = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	added_foodtypes = parent_type::added_foodtypes|FRUIT
	result = /obj/item/food/donut/jelly/slimejelly/apple

/datum/crafting_recipe/food/donut/slimejelly/caramel
	name = "Caramel Slime Donut-焦糖黏胶甜甜圈"
	reqs = list(
		/datum/reagent/consumable/caramel = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/caramel

/datum/crafting_recipe/food/donut/slimejelly/choco
	name = "巧克力史莱姆甜甜圈"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/choco

/datum/crafting_recipe/food/donut/slimejelly/blumpkin
	name = "蓝南瓜史莱姆甜甜圈"
	reqs = list(
		/datum/reagent/consumable/blumpkinjuice = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	added_foodtypes = parent_type::added_foodtypes|VEGETABLES
	result = /obj/item/food/donut/jelly/slimejelly/blumpkin

/datum/crafting_recipe/food/donut/slimejelly/bungo
	name = "邦戈果史莱姆甜甜圈"
	reqs = list(
		/datum/reagent/consumable/bungojuice = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/bungo

/datum/crafting_recipe/food/donut/slimejelly/matcha
	name = "抹茶史莱姆甜甜圈"
	reqs = list(
		/datum/reagent/toxin/teapowder = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/matcha

/datum/crafting_recipe/food/donut/slimejelly/laugh
	name = "Sweet Pea Jelly Donut-香豌豆果冻甜甜圈"
	reqs = list(
		/datum/reagent/consumable/laughsyrup = 3,
		/obj/item/food/donut/jelly/slimejelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/slimejelly/laugh

////////////////////////////////////////////////WAFFLES////////////////////////////////////////////////

/datum/crafting_recipe/food/waffles
	time = 1.5 SECONDS
	name = "Waffles-华夫饼"
	reqs = list(
		/obj/item/food/pastrybase = 2
	)
	result = /obj/item/food/waffles
	added_foodtypes = BREAKFAST
	dish_category = DISH_BREAD


/datum/crafting_recipe/food/soylenviridians
	name = "Soylent green-绿色食品"
	reqs = list(
		/obj/item/food/pastrybase = 2,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/soylenviridians // they look like waffles
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/soylentgreen
	name = "Soylent green-绿色食品"
	reqs = list(
		/obj/item/food/pastrybase = 2,
		/obj/item/food/meat/slab/human = 2
	)
	result = /obj/item/food/soylentgreen
	removed_foodtypes = GORE|RAW
	dish_category = DISH_PASTRY // they look like waffles


/datum/crafting_recipe/food/rofflewaffles
	name = "Roffle waffles-罗夫华夫饼"
	reqs = list(
		/datum/reagent/drug/mushroomhallucinogen = 5,
		/obj/item/food/pastrybase = 2
	)
	result = /obj/item/food/rofflewaffles
	added_foodtypes = VEGETABLES|BREAKFAST
	dish_category = DISH_BREAD

////////////////////////////////////////////////DONKPOCCKETS////////////////////////////////////////////////

/datum/crafting_recipe/food/donkpocket
	time = 1.5 SECONDS
	name = "Donk-pocket-口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/donkpocket/homemade
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/dankpocket
	time = 1.5 SECONDS
	name = "Dank-pocket-哈草口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/cannabis = 1
	)
	result = /obj/item/food/donkpocket/dank
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donkpocket/spicy
	time = 1.5 SECONDS
	name = "Spicy-pocket-辣味口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/chili = 1
	)
	result = /obj/item/food/donkpocket/spicy/homemade
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donkpocket/teriyaki
	time = 1.5 SECONDS
	name = "Teriyaki-pocket-照烧口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meatball = 1,
		/datum/reagent/consumable/soysauce = 3
	)
	result = /obj/item/food/donkpocket/teriyaki/homemade
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donkpocket/pizza
	time = 1.5 SECONDS
	name = "Pizza-pocket-披萨口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/donkpocket/pizza
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donkpocket/honk
	time = 1.5 SECONDS
	name = "Honk-Pocket-喇叭口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/banana = 1,
		/datum/reagent/consumable/sugar = 3
	)
	result = /obj/item/food/donkpocket/honk
	added_foodtypes = FRUIT|SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donkpocket/berry
	time = 1.5 SECONDS
	name = "Berry-pocket-浆果口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/donkpocket/berry
	added_foodtypes = FRUIT|SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donkpocket/gondola
	time = 1.5 SECONDS
	name = "Gondola-pocket-贡多拉口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meatball = 1,
		/datum/reagent/gondola_mutation_toxin = 5
	)
	result = /obj/item/food/donkpocket/gondola
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donkpocket/deluxe
	time = 1.5 SECONDS
	name = "豪华咚咔包"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/onion_slice/red = 1
	)
	result = /obj/item/food/donkpocket/deluxe
	dish_category = DISH_PASTRY
	removed_foodtypes = BREAKFAST
	crafting_flags = parent_type::crafting_flags | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/food/donkpocket/deluxe/nocarb
	time = 1.5 SECONDS
	name = "豪华肉包"
	reqs = list(
		/obj/item/organ/heart = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/meat/slab = 1,
		/obj/item/food/grown/herbs = 1
	)
	result = /obj/item/food/donkpocket/deluxe/nocarb
	removed_foodtypes = VEGETABLES //The herbs are only to enhance the flavor
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/donkpocket/deluxe/vegan
	time = 1.5 SECONDS
	name = "豪华咚咔卷"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/bell_pepper = 1,
		/obj/item/food/tofu = 2,
	)
	result = /obj/item/food/donkpocket/deluxe/vegan
	removed_foodtypes = BREAKFAST
	dish_category = DISH_PASTRY

////////////////////////////////////////////////MUFFINS////////////////////////////////////////////////

/datum/crafting_recipe/food/muffin
	time = 1.5 SECONDS
	name = "Muffin-松饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1
	)
	added_foodtypes = BREAKFAST|SUGAR|DAIRY
	result = /obj/item/food/muffin
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/berrymuffin
	name = "Berry muffin-浆果松饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/muffin/berry
	added_foodtypes = BREAKFAST|SUGAR|FRUIT|DAIRY
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/booberrymuffin
	name = "Booberry muffin-鬼莓松饼"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/berries = 1,
		/obj/item/ectoplasm = 1
	)
	result = /obj/item/food/muffin/booberry
	added_foodtypes = BREAKFAST|SUGAR|DAIRY
	dish_category = DISH_PASTRY

////////////////////////////////////////////OTHER////////////////////////////////////////////


/datum/crafting_recipe/food/khachapuri
	name = "哈恰普里"
	reqs = list(
		/datum/reagent/consumable/eggyolk = 2,
		/datum/reagent/consumable/eggwhite = 4,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/bread/plain = 1
	)
	result = /obj/item/food/khachapuri
	added_foodtypes = MEAT
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/sugarcookie
	time = 1.5 SECONDS
	name = "Sugar cookie-糖心曲奇"
	reqs = list(
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/cookie/sugar
	added_foodtypes = JUNKFOOD|SUGAR
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/spookyskull
	time = 1.5 SECONDS
	name = "头骨饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/milk = 5
	)
	result = /obj/item/food/cookie/sugar/spookyskull
	added_foodtypes = JUNKFOOD|SUGAR
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/spookycoffin
	time = 1.5 SECONDS
	name = "棺椁饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/coffee = 5
	)
	result = /obj/item/food/cookie/sugar/spookycoffin
	added_foodtypes = JUNKFOOD|SUGAR
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/fortunecookie
	time = 1.5 SECONDS
	name = "Fortune cookie-幸运饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/paper = 1
	)
	parts = list(
		/obj/item/paper = 1
	)
	result = /obj/item/food/fortunecookie
	added_foodtypes = SUGAR
	dish_category = DISH_COOKIE
	requirements_mats_blacklist = list(/obj/item/paper)

/datum/crafting_recipe/food/poppypretzel
	time = 1.5 SECONDS
	name = "Poppy pretzel-罂粟椒盐卷饼"
	reqs = list(
		/obj/item/seeds/poppy = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/poppypretzel
	added_foodtypes = SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/plumphelmetbiscuit
	time = 1.5 SECONDS
	name = "Plumphelmet biscuit-肉盔菇饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/mushroom/plumphelmet = 1
	)
	result = /obj/item/food/plumphelmetbiscuit
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/cracker
	time = 1.5 SECONDS
	name = "Cracker-小饼干"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/doughslice = 1,
	)
	result = /obj/item/food/cracker
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/chococornet
	name = "Choco cornet-巧克力尖蛋卷"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/chococornet
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/oatmealcookie
	name = "Oatmeal cookie-燕麦饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/oat = 1
	)
	result = /obj/item/food/cookie/oatmeal
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/raisincookie
	name = "Raisin cookie-葡萄干饼干"
	reqs = list(
		/obj/item/food/no_raisin = 1,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/oat = 1
	)
	result = /obj/item/food/cookie/raisin
	removed_foodtypes = JUNKFOOD
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/cherrycupcake
	name = "Cherry cupcake-樱桃纸杯蛋糕"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/cherries = 1
	)
	result = /obj/item/food/cherrycupcake
	added_foodtypes = SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/bluecherrycupcake
	name = "Blue cherry cupcake-蓝樱桃纸杯蛋糕"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/bluecherries = 1
	)
	result = /obj/item/food/cherrycupcake/blue
	added_foodtypes = SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/jupitercupcake
	name = "木星杯蛋糕"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/mushroom/jupitercup = 1,
		/datum/reagent/consumable/caramel = 3,
	)
	result = /obj/item/food/jupitercupcake
	added_foodtypes = SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/honeybun
	name = "Honey bun-蜂蜜圆面包"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/honeybun
	added_foodtypes = SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/cannoli
	name = "Cannoli-瑞可塔起司卷"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/milk = 1,
		/datum/reagent/consumable/sugar = 3
	)
	result = /obj/item/food/cannoli
	added_foodtypes = SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/peanut_butter_cookie
	name = "Peanut butter cookie-花生曲奇"
	reqs = list(
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/cookie/peanut_butter
	added_foodtypes = JUNKFOOD|NUTS
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/raw_brownie_batter
	name = "Raw brownie batter-生巧克力蛋糕糊"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/egg = 2,
		/datum/reagent/consumable/coco = 5,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/raw_brownie_batter
	added_foodtypes = GRAIN|JUNKFOOD|BREAKFAST|SUGAR
	removed_foodtypes = MEAT|RAW|EGG
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/peanut_butter_brownie_batter
	name = "生花生酱布朗尼面糊"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/egg = 2,
		/datum/reagent/consumable/coco = 5,
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/peanut_butter_brownie_batter
	added_foodtypes = GRAIN|JUNKFOOD|BREAKFAST|SUGAR|NUTS
	removed_foodtypes = MEAT|RAW|EGG
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/crunchy_peanut_butter_tart
	name = "脆皮花生酱挞"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/food/grown/peanut = 1,
		/datum/reagent/consumable/cream = 5,
	)
	result = /obj/item/food/crunchy_peanut_butter_tart
	added_foodtypes = JUNKFOOD|SUGAR
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/chocolate_chip_cookie
	name = "巧克力曲奇"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/cookie/chocolate_chip_cookie
	removed_foodtypes = JUNKFOOD
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/snickerdoodle
	name = "肉桂糖曲奇"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/vanilla = 5,
	)
	result = /obj/item/food/cookie/snickerdoodle
	added_foodtypes = SUGAR
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/thumbprint_cookie
	name = "拇指印饼干"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/cherryjelly = 5,
	)
	result = /obj/item/food/cookie/thumbprint_cookie
	added_foodtypes = FRUIT|SUGAR
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/macaron
	name = "马卡龙"
	reqs = list(
		/datum/reagent/consumable/eggwhite = 2,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/flour = 5,
	)
	result = /obj/item/food/cookie/macaron
	dish_category = DISH_COOKIE

/datum/crafting_recipe/food/apple_fritter
	name = "Apple fritter"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/appleslice = 1,
	)
	result = /obj/item/food/apple_fritter
	added_foodtypes = GRAIN|FRUIT|FRIED|BREAKFAST
	dish_category = DISH_PASTRY
	meal_category = MEAL_BREAKFAST
