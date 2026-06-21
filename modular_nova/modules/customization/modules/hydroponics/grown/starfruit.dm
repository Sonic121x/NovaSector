// Starfruit
/obj/item/seeds/starfruit
	name = "杨桃种子包"
	desc = "这些种子会长成杨桃植株，结出甜美可口的果实。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-starfruit"
	species = "starfruit"
	plantname = "Starfruit Plants"
	product = /obj/item/food/grown/starfruit
	lifespan = 50
	endurance = 15
	growthstages = 4
	growing_icon = 'modular_nova/master_files/icons/obj/hydroponics/growing.dmi'
	icon_grow = "starfruit-grow"
	icon_dead = "starfruit-dead"
	icon_harvest = "starfruit-harvest"
	genes = list(/datum/plant_gene/trait/glow/yellow, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(
		/datum/reagent/consumable/starfruit_juice = 0.3,
		/datum/reagent/consumable/nutriment = 0.1,
	)

/obj/item/food/grown/starfruit
	seed = /obj/item/seeds/starfruit
	name = "杨桃"
	desc = "稀有的普里米丁杨桃曾是普里米丁星上最常收获的水果之一，在秋季和主要收获季节种植。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/harvest.dmi'
	icon_state = "starfruit"
	bite_consumption_mod = 2
	foodtypes = FRUIT | SUGAR

/obj/item/food/grown/starfruit/juice_typepath()
	return /datum/reagent/consumable/starfruit_juice

//Starfruit drinks
//All the drinks are very good because this shit cost 1k minimum to get the starfruit

/datum/chemical_reaction/drink/starfruit_soda
	results = list(/datum/reagent/consumable/ethanol/starfruit_soda = 5)
	required_reagents = list(
		/datum/reagent/consumable/starfruit_juice = 2,
		/datum/reagent/consumable/ethanol/rum = 2,
		/datum/reagent/consumable/ethanol/cognac = 1,
		/datum/reagent/consumable/sodawater = 1,
	)
	mix_message = "The ingredients combine into fizzy soda."

/datum/reagent/consumable/ethanol/starfruit_soda //starfruit juice 2, rum 2, cognac 1, soda water 1
	name = "星旋"
	description = "一种疲惫的妈妈们可以藏在保温杯里的饮料。"
	boozepwr = 35
	color = "#434294"
	quality = DRINK_VERYGOOD
	taste_description = "sweet stellar adventures"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/starfruit_soda
	required_drink_type = /datum/reagent/consumable/ethanol/starfruit_soda
	name = "星旋"
	desc = "一种含酒精的杨桃汽水，你能看到玻璃杯中的气泡。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "starsoda"

/datum/chemical_reaction/drink/starfruit_lubricant
	results = list(/datum/reagent/consumable/ethanol/starfruit_lubricant = 2)
	required_reagents = list(
		/datum/reagent/consumable/starfruit_juice = 1,
		/datum/reagent/consumable/ethanol/synthanol = 1,
	)
	mix_message = "The ingredients combine into a fizzy soda."

/datum/reagent/consumable/ethanol/starfruit_lubricant //starfruit juice 1, Synthanol 1
	name = "星尘润滑剂"
	description = "一种疲惫的妈妈们可以藏在保温杯里的饮料。现在合成人也能喝了！"
	boozepwr = 35
	color = "#45b33b"
	quality = DRINK_VERYGOOD
	taste_description = "sweet stellar adventures"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/starfruit_lubricant
	required_drink_type = /datum/reagent/consumable/ethanol/starfruit_lubricant
	name = "星尘润滑剂"
	desc = "一种对合成人友好的含酒精杨桃苏打水，你能在杯中看到气泡。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "starsodasynth"

/datum/chemical_reaction/drink/starfruit_latte
	results = list(/datum/reagent/consumable/starfruit_latte = 2)
	required_reagents = list(
		/datum/reagent/consumable/starfruit_juice = 1,
		/datum/reagent/consumable/coffee = 1,
	)

/datum/reagent/consumable/starfruit_latte //starfruit juice 1, coffee 1
	name = "星光拿铁"
	description = "一种微甜、仿佛来自另一个世界的咖啡。"
	nutriment_factor = 8
	color = "#361329"
	quality = DRINK_VERYGOOD
	taste_description = "hauntingly familiar allure"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/starfruit_latte
	required_drink_type = /datum/reagent/consumable/starfruit_latte
	name = "一杯星光拿铁"
	desc = "一种用甜杨桃汁调味的简单咖啡。它带你踏上一段旅程，前往一个你从未到过，却又莫名熟悉的地方。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "starfruit_latte"

/datum/chemical_reaction/drink/starbeam_shake //starfruit juice 1 , vanilla dream 1 , ice 1
	results = list(/datum/reagent/consumable/starbeam_shake = 3)
	required_reagents = list(
		/datum/reagent/consumable/starfruit_juice = 1,
		/datum/reagent/consumable/vanilla_dream = 1,
		/datum/reagent/consumable/ice = 1,
	)

/datum/reagent/consumable/starbeam_shake
	name = "星束奶昔"
	description = "一种用稀有杨桃制成的美味奶昔。"
	color = "#a551be"
	nutriment_factor = 0
	quality = DRINK_VERYGOOD
	taste_description = "smooth starlight"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/starbeam_shake
	required_drink_type = /datum/reagent/consumable/starbeam_shake
	name = "星束奶昔"
	desc = "一种浓稠顺滑的饮品，带你踏上星际之旅。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "voidshake"

/datum/chemical_reaction/drink/forgotten_star
	results = list(/datum/reagent/consumable/ethanol/forgotten_star = 5)
	required_reagents = list(
		/datum/reagent/consumable/starfruit_juice = 1,
		/datum/reagent/consumable/pineapplejuice = 1,
		/datum/reagent/consumable/ethanol/white_russian = 1,
		/datum/reagent/consumable/ethanol/creme_de_coconut = 1,
		/datum/reagent/consumable/ethanol/bitters = 1,
	)
	mix_message = "The ingredients combine into a shooting star."

/datum/reagent/consumable/ethanol/forgotten_star //starfruit juice 1, creme de coconut 1, white russian 1, pineapple juice 1, bitters 1
	name = "被遗忘的星辰"
	description = "一个逝去时代的宇宙之泣。"
	boozepwr = 55
	color = "#434294"
	quality = DRINK_VERYGOOD
	taste_description = "dreamy, tropical starlit sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/forgotten_star
	required_drink_type = /datum/reagent/consumable/ethanol/forgotten_star
	name = "被遗忘的星辰"
	desc = "一种含酒精的杨桃鸡尾酒，你几乎能在杯中辨认出一个遥远的星系。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "forgottenstar"

/datum/chemical_reaction/drink/astral_flame
	results = list(/datum/reagent/consumable/ethanol/astral_flame = 6)
	required_reagents = list(
		/datum/reagent/consumable/starfruit_juice = 1,
		/datum/reagent/consumable/ethanol/navy_rum = 1,
		/datum/reagent/consumable/menthol = 1,
		/datum/reagent/consumable/limejuice = 1,
		/datum/reagent/consumable/sodawater = 1,
	)
	mix_message = "The ingredients morph into a an enticing smell"

/datum/reagent/consumable/ethanol/astral_flame //starfruit juice 1, navy rum 1, lime juice 1, soda water 1, menthol 1
	name = "星界火焰"
	description = "诱人的火焰。"
	boozepwr = 55
	color = "#6b3481"
	quality = DRINK_VERYGOOD
	taste_description = "enticing warmth"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/astral_flame
	required_drink_type = /datum/reagent/consumable/ethanol/astral_flame
	name = "星界火焰"
	desc = "一种含酒精的杨桃莫吉托，杯中的火焰引诱着你靠近。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "astralflame"

/datum/chemical_reaction/drink/space_muse
	results = list(/datum/reagent/consumable/ethanol/space_muse = 3)
	required_reagents = list(
		/datum/reagent/consumable/starfruit_juice = 1,
		/datum/reagent/consumable/ethanol/creme_de_menthe = 1,
		/datum/reagent/consumable/ethanol/vodka = 1,
	)
	mix_message = "The mixture gives a soft crackling snap."

/datum/reagent/consumable/ethanol/space_muse //starfruit juice 1, creme de menthe, 1 vodka
	name = "太空缪斯"
	description = "一张直接从你本地望远镜拍摄的快照。"
	boozepwr = 35
	color = "#7cb1e2"
	quality = DRINK_VERYGOOD
	taste_description = "haughty cosmic thought"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/space_muse
	required_drink_type = /datum/reagent/consumable/ethanol/space_muse
	name = "太空缪斯"
	desc = "一种含酒精的鸡尾酒，以薄荷和杨桃的微妙刺激感吸引着你。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "spacemuse"

//Starfruit dishes

/datum/crafting_recipe/food/glazed_ribs
	name = "杨桃釉烤肋排"
	reqs = list(
		/obj/item/food/bbqribs = 1,
		/obj/item/food/grown/starfruit = 2,
		/datum/reagent/consumable/starfruit_juice = 5,
	)
	result = /obj/item/food/glazed_ribs
	dish_category = DISH_MEAT
	meal_category = MEAL_MAIN_COURSE

/obj/item/food/glazed_ribs
	name = "杨桃釉烤肋排"
	desc = "鲜嫩多汁的烧烤肋排，淋上甜美的杨桃酱汁。配以焦糖化杨桃作为装饰。这是边境地带最甜、最不素食的美味。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "glazedchops"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/meat = MEATSLAB_MATERIAL_AMOUNT * 2)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/bbqsauce = 5,
		/datum/reagent/consumable/starfruit_juice = 5,
	)
	tastes = list("tender meat" = 2, "sweet sauce" = 1, "sugary glaze" = 1)
	foodtypes = MEAT | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

/datum/crafting_recipe/food/meatplatter
	name = "烧烤肉类拼盘"
	reqs = list(
		/obj/item/food/bbqribs = 1,
		/obj/item/food/glazed_ribs = 1,
		/obj/item/food/roasted_bell_pepper = 2,
	)
	result = /obj/item/food/meatplatter
	dish_category = DISH_MEAT
	meal_category = MEAL_MAIN_COURSE

/obj/item/food/meatplatter
	name = "烧烤肉类拼盘"
	desc = "一个精致的烧烤拼盘，装饰着银河系这边最受欢迎的几种烧烤美食。配以一些烤辣椒作为点缀。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "meatdisc"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/meat = MEATSLAB_MATERIAL_AMOUNT * 4)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 30,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/bbqsauce = 10,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("tender meat" = 2, "sweet sauce" = 1, "smokey BBQ" = 1, "sugary glaze" = 1)
	foodtypes = MEAT | VEGETABLES | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_5

/datum/crafting_recipe/food/chicken_alfredo
	name = "杨桃鸡肉阿尔弗雷多意面"
	reqs = list(
		/obj/item/food/meat/slab/chicken = 1,
		/obj/item/food/grown/starfruit = 2,
		/datum/reagent/consumable/cream = 10,
		/obj/item/food/spaghetti/boiledspaghetti = 1
	)
	result = /obj/item/food/chicken_alfredo
	removed_foodtypes = RAW
	dish_category = DISH_NOODLES
	meal_category = MEAL_MAIN_COURSE

/obj/item/food/chicken_alfredo
	name = "杨桃鸡肉阿尔弗雷多意面"
	desc = "一道用杨桃奶油酱调制的鸡肉阿尔弗雷多意面。不适合胆小的人。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "alfredo"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/meat = MEATSLAB_MATERIAL_AMOUNT)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("sweet chicken" = 2, "creamy sauce" = 1, "cursed knowledge" = 1, "tasty noodles" = 1)
	foodtypes = MEAT | GRAIN | FRUIT| SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/starfruitsushiroll
	name = "杨桃寿司卷"
	reqs = list(
		/obj/item/food/seaweedsheet = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/starfruit_sashimi = 1,
	)
	result = /obj/item/food/starfruitsushiroll
	removed_foodtypes = BREAKFAST
	dish_category = DISH_SUSHI
	meal_category = MEAL_APPETIZER

/obj/item/food/starfruitsushiroll
	name = "杨桃寿司卷"
	desc = "一卷简单的寿司，内含美味的杨桃生鱼片。可以切成小块！"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "sashimiroll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("boiled rice" = 2, "starfruit" = 2, "fish" = 2)
	foodtypes = SEAFOOD | VEGETABLES | GRAIN |FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruitsushiroll/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/starfruitsushislice, 4, screentip_verb = "Chop")

/obj/item/food/starfruitsushislice
	name = "杨桃寿司片"
	desc = "一片杨桃寿司，包含米饭、鱼肉，包裹在海苔卷中。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "sashimirollslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("boiled rice" = 2, "starfruit" = 2, "fish" = 2)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/starfruit_sashimi
	name = "杨桃生鱼片"
	reqs = list(
		/obj/item/food/fishmeat = 2,
		/datum/reagent/consumable/soysauce = 10,
		/obj/item/food/grown/starfruit = 1,
	)
	result = /obj/item/food/starfruit_sashimi
	dish_category = DISH_SUSHI
	meal_category = MEAL_APPETIZER

/obj/item/food/starfruit_sashimi
	name = "杨桃生鱼片"
	desc = "用杨桃浓缩酱油精心制作的生鱼片。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "sashimi"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("raw fish" = 2, "sweet fish" = 1, "soy sauce" = 1)
	foodtypes = SEAFOOD | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_2

/datum/crafting_recipe/food/eggplantfry
	name = "杨桃茄子炒菜"
	reqs = list(
		/obj/item/food/grown/bell_pepper = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/starfruit = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/eggplant = 2,
	)
	result = /obj/item/food/eggplantfry
	meal_category = MEAL_MAIN_COURSE

/obj/item/food/eggplantfry
	name = "杨桃茄子炒菜"
	desc = "茄子炒菜，配以浓缩杨桃酱汁、胡萝卜、辣椒和卷心菜。杨桃的味道完全覆盖了这道菜。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "eggplantfry"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("eggplant" = 2, "simmered starfruit" = 1, "sautaed vegetables" = 1)
	foodtypes = VEGETABLES | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/tofubeef
	name = "杨桃豆腐牛肉拉面"
	reqs = list(
		/obj/item/food/tofu = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/starfruit = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
	)
	result = /obj/item/food/tofubeef
	dish_category = DISH_NOODLES
	meal_category = MEAL_MAIN_COURSE

/obj/item/food/tofubeef
	name = "杨桃豆腐牛肉拉面"
	desc = "一道令人愉悦的拉面菜肴，浸透着牛肉、豆腐和杨桃。食材的奇异组合造就了一种出奇酸爽、回味微甜的佳肴。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "tofubeef"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT * 2)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("noodles" = 2, "boiled starfruit" = 1, "sweet ramen" = 1)
	foodtypes = VEGETABLES | MEAT | GRAIN | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/starfruitplate
	name = "杨桃面条意面"
	reqs = list(
		/obj/item/food/meatball = 2,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/starfruit = 1,
		/obj/item/food/spaghetti/pastatomato = 1,
	)
	result = /obj/item/food/starfruitplate
	dish_category = DISH_NOODLES
	meal_category = MEAL_MAIN_COURSE

/obj/item/food/starfruitplate
	name = "杨桃面条意面"
	desc = "美味的煮意面，配以浓郁奶油般的浓缩杨桃肉酱。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "starfruitplate"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT * 4)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("sweet spagetti" = 2, "simmered starfruit" = 1, "savory meat" = 1)
	foodtypes = GRAIN | VEGETABLES | MEAT | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/starfruitcake
	name = "杨桃蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/starfruit = 5
	)
	result = /obj/item/food/cake/starfruit
	dish_category = DISH_CAKE
	meal_category = MEAL_DESSERT

/obj/item/food/cake/starfruit
	name = "杨桃蛋糕"
	desc = "一款精心装饰、内填杨桃的蛋糕。与星光拿铁是绝配。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "starcake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("cake" = 3, "sweetness" = 2, "unbearable longing" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	slice_type = /obj/item/food/cakeslice/starfruit
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/cakeslice/starfruit
	name = "杨桃蛋糕切片"
	desc = "一片杨桃蛋糕，你分到的这片额外多了一层糖霜！真走运！"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "starcake_slice"
	tastes = list("cake" = 3, "astral sweetness" = 2, "unbearable longing" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/reagent/consumable/starfruitjelly
	name = "杨桃果冻"
	description = "一种稀有的甜味水果果冻"
	nutriment_factor = 10
	color = "#6d3890"
	taste_description = "starfruit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/starfruitjelly

/obj/item/reagent_containers/condiment/starfruitjelly
	name = "杨桃果冻"
	desc = "一罐超甜的杨桃果冻。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "spacejam"
	list_reagents = list(/datum/reagent/consumable/starfruitjelly = 50)
	fill_icon_thresholds = null

/datum/crafting_recipe/bottled/starfruitjelly
	name = "杨桃果冻"
	reqs = list(
		/obj/item/food/grown/starfruit = 10,
		/datum/reagent/water = 25,
	)
	category = CAT_FOOD
	result = /obj/item/reagent_containers/condiment/starfruitjelly

/obj/item/food/cookie/macaron/starfruit
	name = "杨桃马卡龙"
	desc = "一种三明治状的甜点，有着柔软的饼干外壳和奶油般的杨桃果冻蛋白霜夹心。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "macaron_4"
	tastes = list("wafer" = 2, "sweet starfruit" = 2, "creamy meringue" = 3)

/datum/crafting_recipe/food/macaron/starfruit
	name = "杨桃马卡龙"
	reqs = list(
		/datum/reagent/consumable/eggwhite = 2,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/starfruitjelly = 5,
	)
	result = /obj/item/food/cookie/macaron/starfruit
	dish_category = DISH_COOKIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/starfruitcobbler
	name = "杨桃酥皮水果馅饼"
	reqs = list(
		/obj/item/food/pastrybase = 2,
		/obj/item/food/grown/starfruit = 2,
		/datum/reagent/consumable/starfruitjelly = 10,
	)
	result = /obj/item/food/pie/starfruitcobbler
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/obj/item/food/pie/starfruitcobbler
	name = "杨桃酥皮水果馅饼"
	desc = "美味的馅饼，内馅是甜美的杨桃，包裹在黄油酥皮中。顶部点缀着少量甜奶油。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "cobbler"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("pie" = 1, "sugar" = 2, "starfruit" = 1, "cosmic longing" = 1)
	foodtypes = GRAIN | FRUIT | FRUIT | DAIRY | SUGAR

/datum/crafting_recipe/food/starfruit_toast
	name = "杨桃果酱吐司"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/datum/reagent/consumable/starfruitjelly = 5,
	)
	result = /obj/item/food/starfruit_toast
	added_foodtypes = BREAKFAST
	dish_category = DISH_BREAD
	meal_category = MEAL_APPETIZER

/obj/item/food/starfruit_toast
	name = "杨桃果酱吐司"
	desc = "一片涂满美味杨桃果酱的吐司。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "spacejamtoast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	bite_consumption = 3
	tastes = list("toast" = 1, "jelly" = 1, "starfruit jelly" = 1)
	foodtypes = GRAIN | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/starfruitpie
	name = "杨桃派"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/starfruit = 2,
	)
	result = /obj/item/food/pie/starfruitpie
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/obj/item/food/pie/starfruitpie
	name = "杨桃派"
	desc = "看似简单，实则风味浓郁。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "starfruitpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 14,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("starfruit" = 1, "pie" = 1, "cosmic longing" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR | DAIRY
	slice_type = /obj/item/food/pieslice/starfruitpie
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/starfruitpie
	name = "杨桃派切片"
	desc = "带你开启一场穿越太空的旅程！"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "starfruitpie_slice"
	tastes = list("pie" = 1, "starfruit" = 1, "cosmic longing" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/starfruitcompote
	name = "杨桃蜜饯"
	reqs = list(
		/obj/item/food/grown/starfruit = 5,
		/datum/reagent/consumable/sugar = 10,
		/datum/reagent/consumable/ethanol/cognac = 10,
	)
	result = /obj/item/food/starfruitcompote
	meal_category = MEAL_DESSERT

/obj/item/food/starfruitcompote
	name = "杨桃蜜饯"
	desc = "一道用杨桃在白兰地和糖中熬煮而成的、令人无法抗拒的甜点。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "compote"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("starfruit" = 1, "sweet sugar" = 1, "cognac spice" = 1)
	bite_consumption = 3
	foodtypes = FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/starfruitbrulee
	name = "杨桃焦糖布丁"
	reqs = list(
		/datum/reagent/consumable/starfruit_juice = 10,
		/datum/reagent/consumable/sugar = 10,
		/datum/reagent/consumable/salt = 5,
		/datum/reagent/consumable/eggyolk = 2,
		/datum/reagent/consumable/eggwhite = 4,
	)
	result = /obj/item/food/starfruitbrulee
	meal_category = MEAL_DESSERT

/obj/item/food/starfruitbrulee
	name = "杨桃焦糖布丁"
	desc = "一道主要由焦糖、杨桃和蛋清制成的美味布丁甜点。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "cremebrulee"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("starfruit" = 1, "caramel" = 1, "subtle cream" = 1)
	foodtypes = FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/datum/crafting_recipe/food/starcupcake
	name = "杨桃纸杯蛋糕"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/starfruit = 2
	)
	result = /obj/item/food/starcupcake
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/obj/item/food/starcupcake
	name = "杨桃纸杯蛋糕"
	desc = "一个带有杨桃糖霜的甜味纸杯蛋糕。"
	icon = 'modular_nova/master_files/icons/obj/food/starfruit.dmi'
	icon_state = "cupcakestar"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("cake" = 3, "starfruit" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR | DAIRY
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/book/manual/starfruit
	name = "杨桃制备与你！"
	icon = 'modular_nova/master_files/icons/obj/starfruitbook.dmi'
	icon_state = "cookbook"
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/starfruitbook_lhand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/starfruitbook_rhand.dmi'
	starting_author = "Artic Deep Beverage Research Division"
	starting_title = "Starfruit preperation and you!"
	starting_content = {"<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<style>
h1 {font-size: 18px; margin: 15px 0px 5px;}
h2 {font-size: 15px; margin: 15px 0px 5px;}
li {margin: 2px 0px 2px 15px;}
ul {list-style: none; margin: 5px; padding: 0px;}
ol {margin: 5px; padding: 0px 15px;}
</style>
</head>
<body>

<h2>Artic Starfruit Beverage Recipies:</h2>

<b>Starfruit Soda:</b> Two parts starfruit juice, two parts rum, one part cognac, one part soda water<br>

<b>Starfruit Lubricant:</b> One part starfruit juice, one part synthanol<br>

<b>Starlit Latte:</b> One part starfruit juice, one part coffee<br>

<b>Starbeam Shake:</b> One part starfruit juice, one part vanilla dream, one part ice<br>

<b>Forgotten Star:</b> One part starfruit juice, one part creme de coconut, one part white russian, one part pineapple juice, one part bitters

<b>Astral Flame:</b> One Part Starfruit juice, one part navy rum,one part lime juice,one part soda water, one part menthol

<b>Space Muse:</b> One part starfruit juice, one part creme de menthe, one part vodka
</body>
</html>
"}
