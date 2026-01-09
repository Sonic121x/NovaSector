//FOOD ITEM
/obj/item/food/zongzi
	name = "粽子"
	desc = "由米团、咸蛋黄和肉块组成的奇怪三角锥体，很少在空间站看见有人吃这个，毕竟没人见过这个古老的食物了。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "zongzi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 4,
	)
	tastes = list("糯米" = 1, "咸蛋黄" = 1, "肉块" = 1)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/tangyuan
	name = "汤圆"
	desc = "一口大小的糯米团子，包裹着不同口味的馅心，常在佳节团圆时分享。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "tangyuan"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("糯米" = 1, "花生" = 1)
	foodtypes = GRAIN | NUTS | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/qingtuan
	name = "青团"
	desc = "以前用来祭祀的供品。使用艾草汁混合糯米，再裹上红豆沙制成，有股淡淡的草药香气。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "qingtuan"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("糯米皮" = 1, "红豆沙" = 1, "草药味" = 1)
	foodtypes = GRAIN | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/dumpling_boiled
	name = "饺子"
	desc = "煮熟的饺子表皮光滑半透明，边缘捏合处因吸水略微膨胀，隐约可见内馅的色泽。汤汁浸润面皮，散发简单扎实的面食香气。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "dumpling_boiled"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("玉米粒" = 1, "肉馅" = 1, "面皮" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/dumpling_boiled/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/dumpling_grilled, rand(10 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/dumpling_grilled
	name = "煎饺"
	desc = "煎至底部金黄酥脆的饺子，表皮微带油光，顶部撒有零星葱花。内馅饱满，咬开时能尝到焦香外壳与湿润肉汁的混合滋味。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "dumpling_grilled"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("玉米粒" = 1, "肉馅" = 1, "面皮" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/dumpling_raw
	name = "生饺子"
	desc = "未经煮制的半月形面食，面皮边缘捏合紧密，表面微粉，隐约透出内馅的深色轮廓。生面质地偏硬，需烹饪后食用。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "dumpling_raw"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/nutriment/protein = 1,
	)
	tastes = list("玉米粒" = 1, "生肉" = 1, "生面皮" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_0

//  煮点饺子吃
/datum/chemical_reaction/food/soup/boil_dumpling
	required_reagents = list(
		/datum/reagent/water = 5,
	)

	required_ingredients = list(
		/obj/item/food/dumpling_raw = 1,
	)

	results = list(
		/obj/item/food/dumpling_boiled = 1,
	)

	resulting_food_path = /obj/item/food/dumpling_boiled

	//  你肯定不想吃煮漏了的饺子
	ingredient_reagent_multiplier = 0

/obj/item/food/mooncake
	name = "月饼"
	desc = "烘烤制成的圆形糕点，发展到现在已经有了各式口味。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "mooncake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("莲蓉" = 1, "咸蛋黄" = 1, "面皮" = 1)
	foodtypes = GRAIN | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/baozi_steamed
	name = "包子"
	desc = "一个蒸制完成的白胖包子，表皮蓬松柔软，半透明的面皮下隐约透出深色馅料的轮廓。顶部褶皱处因蒸汽浸润微微发亮，散发着淡淡的面香与肉香。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "baozi_steamed"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 3,
	)
	tastes = list("肉馅" = 1, "面皮" = 1)
	foodtypes = GRAIN | MEAT | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/baozi_grilled
	name = "生煎包"
	desc = "一个刚煎好的圆形面点，底部焦黄酥脆。面皮包裹着温热的肉馅，咬开时会有少许汤汁流出，散发着简单却扎实的食物香气。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "baozi_grilled"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 3,
	)
	tastes = list("肉馅" = 1, "酥脆面皮" = 1)
	foodtypes = GRAIN | MEAT | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/baozi_raw
	name = "生包子"
	desc = "一个未经蒸制的白面团，表面略带干粉，褶皱收口处捏合整齐，隐约能看见内部裹着的一小团深色肉馅。生面质地紧实，需蒸熟或煎熟后才能食用。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "baozi_raw"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 1,
	)
	tastes = list("生肉" = 1, "生面皮" = 1)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_0

//  谁家好人用烘焙箱蒸包子
/obj/item/food/baozi_raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/baozi_steamed, rand(10 SECONDS, 20 SECONDS), TRUE, TRUE)

//  用烤来做生煎包听起来有点怪
/obj/item/food/baozi_raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/baozi_grilled, rand(10 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/food/roujiamo
	name = "肉夹馍"
	desc = "烤面饼夹着碎肉，馍皮酥脆，肉馅多汁。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "roujiamo"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("肉馅" = 1, "肉汁" = 1, "面皮" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/wolf_tooth_potato
	name = "狼牙土豆"
	desc = "将波浪形的粗犷土豆条炸至金黄可口，再撒上辣椒面与孜然，香辣酥脆。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "wolf_tooth_potato"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/capsaicin = 3,
	)
	tastes = list("土豆" = 1, "辣味" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/youtiao
	name = "油条"
	desc = "金黄酥脆的中式‘法棍’，建议搭配豆浆食用。"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "youtiao"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
	)
	tastes = list("面皮" = 1)
	foodtypes = GRAIN | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/stinky_tofu
	name = "臭豆腐串"
	desc = "外酥内软的炸豆腐块，但此小吃在空间站褒贬不一，时常引发口水大战."
	icon = 'modular_z121/icons/obj/food/food.dmi'
	icon_state = "stinky_tofu"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("豆腐" = 1, "臭味" = 1)
	foodtypes = GRAIN | GROSS
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

//see code/module/crafting/table.dm

/obj/item/food/popsicle/helmetpop
	name = "巧克力脆皮头盔冰棒"
	desc = "控制变量，百次研发。航天级冰棍模具。无菌密封包装。冷链物流，航空运输。试吃百分百好评。记忆中战友的味道!"
	icon = 'modular_z121/icons/obj/food/food.dmi'
	overlay_state = "helmetpop"
	food_reagents = list(
		/datum/reagent/iron = 4,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/coco = 4,
		/datum/reagent/consumable/sugar = 2,
	)
	tastes = list("巧克力" = 1, "金属" = 1)
	foodtypes = FRUIT | DAIRY | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

////////////////////////////////////////////////CHINESE FOOD RECIPE////////////////////////////////////////////////

/datum/crafting_recipe/food/zongzi
	name = "粽子"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/datum/reagent/consumable/eggyolk = 2,
		/obj/item/food/meat/steak = 1,
		/obj/item/grown/log/bamboo = 1
	)
	result = /obj/item/food/zongzi
	category = CAT_MARTIAN

/datum/crafting_recipe/food/tangyuan
	name = "汤圆"
	reqs = list(
		/obj/item/food/bait/doughball = 5,
		/obj/item/food/grown/peanut = 1,
		/datum/reagent/consumable/sugar = 2

	)
	result = /obj/item/food/tangyuan
	category = CAT_MARTIAN
/*
/datum/crafting_recipe/food/qingtuan
name = "青团"
reqs = list(
	/obj/item/food/grown/herbs = 1,
	/obj/item/food/boiledrice = 1,
	/obj/item/food/grown/redbean = 1 //红豆没写
)
result = /obj/item/food/qingtuan
category = CAT_CHINESE
*/
/datum/crafting_recipe/food/dumpling
    name = "饺子"
    reqs = list(
        /obj/item/food/doughslice = 1,
        /obj/item/food/raw_meatball = 1,
        /obj/item/food/grown/corn = 1
    )
    result = /obj/item/food/dumpling_raw
    category = CAT_MARTIAN

/datum/crafting_recipe/food/mooncake
	name = "月饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/eggyolk = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/mooncake
	category = CAT_MARTIAN

/datum/crafting_recipe/food/baozi_raw
	name = "包子"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/raw_meatball = 1
	)
	result = /obj/item/food/baozi_raw
	category = CAT_MARTIAN

/datum/crafting_recipe/food/roujiamo
	name = "肉夹馍"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/patty/plain = 1
	)
	result = /obj/item/food/roujiamo
	category = CAT_MARTIAN

/datum/crafting_recipe/food/wolf_tooth_potato
	name = "狼牙土豆"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/grown/chili = 1
	)
	result = /obj/item/food/wolf_tooth_potato
	category = CAT_MARTIAN

/datum/crafting_recipe/food/youtiao
	name = "油条"
	reqs = list(
		/obj/item/food/doughslice = 1
	)
	result = /obj/item/food/youtiao
	category = CAT_MARTIAN

/datum/crafting_recipe/food/stinky_tofu
	name = "臭豆腐串"
	reqs = list(
		/obj/item/food/tofu = 1,
		/obj/item/food/grown/chili = 1
	)
	result = /obj/item/food/stinky_tofu
	category = CAT_MARTIAN

/datum/crafting_recipe/food/helmetpop
	name = "巧克力脆皮头盔冰棒"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/iron = 4,
		/datum/reagent/consumable/cream = 2,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/popsicle/helmetpop
	category = CAT_ICE

/datum/reagent/consumable/milktea
	name = "奶茶"
	description = "无任何添加的普通奶茶，以红茶混合鲜奶调制而成，依然非常美味。"
	color = "#ca885c"
	taste_description = "浓郁的奶茶"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/hot_soymilk
	name = "豆浆"
	description = "热腾腾的豆浆，建议搭配油条食用。"
	color = "#f5e6c6"
	taste_description = "热豆浆"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/chemical_reaction/hot_soymilk
	results = list(/datum/reagent/consumable/hot_soymilk = 2)
	required_reagents = list(/datum/reagent/consumable/soymilk = 1)
	required_temp = 363
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_DRINK

/datum/chemical_reaction/drink/milktea
	results = list(/datum/reagent/consumable/milktea = 3)
	required_reagents = list(/datum/reagent/consumable/milk = 1, /datum/reagent/consumable/tea = 1, /datum/reagent/consumable/sugar = 1)

/datum/glass_style/has_foodtype/drinking_glass/hot_soymilk
	required_drink_type = /datum/reagent/consumable/hot_soymilk
	name = "豆浆"
	desc = "热腾腾的豆浆，建议搭配油条食用。"
	icon = 'modular_z121/icons/obj/drinks/drinks.dmi'
	icon_state = "hot_soymilk"
	drink_type = BREAKFAST

/datum/glass_style/drinking_glass/milktea
	required_drink_type = /datum/reagent/consumable/milktea
	name = "奶茶"
	desc = "无任何添加的普通奶茶，以红茶混合鲜奶调制而成，依然非常美味。"
	icon = 'modular_z121/icons/obj/drinks/drinks.dmi'
	icon_state = "milktea"
