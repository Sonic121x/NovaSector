/datum/crafting_recipe/food/kimchi
	name = "泡菜"
	reqs = list(
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/salt = 5
	)
	result = /obj/item/food/kimchi
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/inferno_kimchi
	name = "地狱泡菜"
	reqs = list(
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/ghost_chili = 1,
		/datum/reagent/consumable/salt = 5
	)
	result = /obj/item/food/inferno_kimchi
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/garlic_kimchi
	name = "蒜香泡菜"
	reqs = list(
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/salt = 5
	)
	result = /obj/item/food/garlic_kimchi
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/surimi
	name = "鱼糜"
	reqs = list(
		/obj/item/food/fishmeat = 1,
	)
	result = /obj/item/food/surimi
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/sambal
	name = "参巴酱"
	reqs = list(
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/onion = 1,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/limejuice = 3,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/sambal
	added_foodtypes = SEAFOOD //Until we have easy to get shrimp to add to the recipe
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/katsu_fillet
	name = "炸猪排"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 1,
		/obj/item/food/breadslice/reispan = 1,
	)
	result = /obj/item/food/katsu_fillet
	removed_foodtypes = RAW
	added_foodtypes = FRIED
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_FROZEN

/datum/crafting_recipe/food/rice_dough
	name = "米面团"
	reqs = list(
		/datum/reagent/consumable/flour = 10,
		/datum/reagent/consumable/rice = 10,
		/datum/reagent/water = 10,
	)
	result = /obj/item/food/rice_dough
	crafting_flags = CRAFT_CHECK_DENSITY
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/hurricane_rice
	name = "飓风炒饭"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/egg = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/pineappleslice = 1,
		/datum/reagent/consumable/soysauce = 3,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/hurricane_rice
	removed_foodtypes = RAW|BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/ikareis
	name = "伊卡莱斯"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/canned/squid_ink = 1,
		/obj/item/food/grown/bell_pepper = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/sausage = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/ikareis
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/hawaiian_fried_rice
	name = "夏威夷炒饭"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/chapslice = 1,
		/obj/item/food/grown/bell_pepper = 1,
		/obj/item/food/pineappleslice = 1,
		/obj/item/food/onion_slice = 1,
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/hawaiian_fried_rice
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/ketchup_fried_rice
	name = "番茄酱炒饭"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/sausage/american = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/peas = 1,
		/datum/reagent/consumable/ketchup = 5,
		/datum/reagent/consumable/worcestershire = 2,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/ketchup_fried_rice
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/mediterranean_fried_rice
	name = "地中海炒饭"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/grown/herbs = 1,
		/obj/item/food/cheese/firm_cheese_slice = 1,
		/obj/item/food/grown/olive = 1,
		/obj/item/food/meatball = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/mediterranean_fried_rice
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/egg_fried_rice
	name = "蛋炒饭"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/egg = 1,
		/datum/reagent/consumable/soysauce = 3,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/egg_fried_rice
	removed_foodtypes = BREAKFAST|RAW
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/bibimbap
	name = "石锅拌饭"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/cucumber = 1,
		/obj/item/food/grown/mushroom = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/kimchi = 1,
		/obj/item/food/egg = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/bibimbap
	removed_foodtypes = RAW|BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/bulgogi_noodles
	name = "韩式烤肉面"
	reqs = list(
		/obj/item/food/spaghetti/boilednoodles = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/apple = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/onion_slice = 1,
		/datum/reagent/consumable/nutriment/soup/teriyaki = 4,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/bulgogi_noodles
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/yakisoba_katsu
	name = "日式炒面炸猪排"
	reqs = list(
		/obj/item/food/spaghetti/boilednoodles = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/katsu_fillet = 1,
		/datum/reagent/consumable/worcestershire = 3,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/yakisoba_katsu
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/martian_fried_noodles
	name = "火星炒面"
	reqs = list(
		/obj/item/food/spaghetti/boilednoodles = 1,
		/obj/item/food/grown/peanut = 2,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/egg = 1,
		/datum/reagent/consumable/soysauce = 3,
		/datum/reagent/consumable/red_bay = 3,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/martian_fried_noodles
	removed_foodtypes = RAW
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/simple_fried_noodles
	name = "简易炒面"
	reqs = list(
		/obj/item/food/spaghetti/boilednoodles = 1,
		/datum/reagent/consumable/soysauce = 3,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/simple_fried_noodles
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/setagaya_curry
	name = "世田谷咖喱"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/apple = 1,
		/datum/reagent/consumable/honey = 3,
		/datum/reagent/consumable/ketchup = 3,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/coffee = 3,
		/datum/reagent/consumable/ethanol/wine = 3,
		/datum/reagent/consumable/curry_powder = 3,
		/obj/item/food/meat/slab = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/setagaya_curry
	removed_foodtypes = RAW|JUNKFOOD|BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/big_blue_burger
	name = "巨无霸蓝空汉堡"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/patty = 2,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/pineappleslice = 1,
		/datum/reagent/consumable/nutriment/soup/teriyaki = 4,
	)
	result = /obj/item/food/burger/big_blue
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_BURGER

/datum/crafting_recipe/food/chappy_patty
	name = "快乐肉饼"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/grilled_chapslice = 2,
		/obj/item/food/friedegg = 1,
		/obj/item/food/cheese/wedge = 1,
		/datum/reagent/consumable/ketchup = 3,
	)
	result = /obj/item/food/burger/chappy
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_BURGER

/datum/crafting_recipe/food/king_katsu_sandwich
	name = "帝王猪排三明治"
	reqs = list(
		/obj/item/food/breadslice/reispan = 2,
		/obj/item/food/katsu_fillet = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/kimchi = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/grown/tomato = 1,
	)
	result = /obj/item/food/king_katsu_sandwich
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/marte_cubano_sandwich
	name = "火星古巴三明治"
	reqs = list(
		/obj/item/food/breadslice/reispan = 2,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/pickle = 2,
		/obj/item/food/cheese/wedge = 1,
	)
	result = /obj/item/food/marte_cubano_sandwich
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/little_shiro_sandwich
	name = "小白三明治"
	reqs = list(
		/obj/item/food/breadslice/reispan = 2,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/friedegg = 1,
		/obj/item/food/garlic_kimchi = 1,
		/obj/item/food/cheese/mozzarella = 1,
		/obj/item/food/grown/herbs = 1,
	)
	result = /obj/item/food/little_shiro_sandwich
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/croque_martienne
	name = "火星夫人三明治"
	reqs = list(
		/obj/item/food/breadslice/reispan = 2,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/pineappleslice = 1,
		/obj/item/food/friedegg = 1,
	)
	result = /obj/item/food/croque_martienne
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/prospect_sunrise
	name = "晨曦展望三明治"
	reqs = list(
		/obj/item/food/breadslice/reispan = 2,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/omelette = 1,
		/obj/item/food/pickle = 1,
	)
	result = /obj/item/food/prospect_sunrise
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/takoyaki
	name = "章鱼烧"
	reqs = list(
		/obj/item/food/fishmeat/octopus = 1,
		/obj/item/food/onion_slice = 1,
		/datum/reagent/consumable/martian_batter = 6,
		/datum/reagent/consumable/worcestershire = 3,
	)
	result = /obj/item/food/takoyaki
	added_foodtypes = GRAIN|FRIED
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/russian_takoyaki
	name = "俄式章鱼烧"
	reqs = list(
		/obj/item/food/fishmeat/octopus = 1,
		/obj/item/food/grown/ghost_chili = 1,
		/datum/reagent/consumable/martian_batter = 6,
		/datum/reagent/consumable/capsaicin = 3,
	)
	result = /obj/item/food/takoyaki/russian
	added_foodtypes = GRAIN|FRIED
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/tacoyaki
	name = "塔可烧"
	reqs = list(
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/corn = 1,
		/datum/reagent/consumable/martian_batter = 6,
		/datum/reagent/consumable/red_bay = 3,
		/obj/item/food/cheese/wedge = 1,
	)
	result = /obj/item/food/takoyaki/taco
	added_foodtypes = GRAIN|FRIED|SEAFOOD
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/okonomiyaki
	name = "御好烧"
	reqs = list(
		/datum/reagent/consumable/martian_batter = 6,
		/datum/reagent/consumable/worcestershire = 3,
		/datum/reagent/consumable/mayonnaise = 3,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/potato/sweet = 1,
	)
	result = /obj/item/food/okonomiyaki
	added_foodtypes = GRAIN|FRIED|SEAFOOD
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_PASTRY // ??
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/brat_kimchi
	name = "泡菜香肠"
	reqs = list(
		/obj/item/food/sausage = 1,
		/obj/item/food/kimchi = 1,
		/datum/reagent/consumable/sugar = 3,
	)
	result = /obj/item/food/brat_kimchi
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/tonkatsuwurst
	name = "猪排香肠"
	reqs = list(
		/obj/item/food/sausage = 1,
		/obj/item/food/fries = 1,
		/datum/reagent/consumable/worcestershire = 3,
		/datum/reagent/consumable/red_bay = 2,
	)
	result = /obj/item/food/tonkatsuwurst
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/ti_hoeh_koe
	name = "蹄花糕"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/peanuts/salted = 1,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/blood = 5,
	)
	result = /obj/item/food/kebab/ti_hoeh_koe
	removed_foodtypes = JUNKFOOD|VEGETABLES|BREAKFAST
	added_foodtypes = MEAT|FRIED
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/kitzushi
	name = "芝士寿司"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/tofu = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/grown/chili = 1,
	)
	result = /obj/item/food/kitzushi
	removed_foodtypes = BREAKFAST
	added_foodtypes = FRIED
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SUSHI

/datum/crafting_recipe/food/epok_epok
	name = "咖喱角"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meat/cutlet/chicken = 1,
		/obj/item/food/grown/potato/wedges = 1,
		/obj/item/food/boiledegg = 1,
		/datum/reagent/consumable/curry_powder = 3,
	)
	result = /obj/item/food/epok_epok
	removed_foodtypes = BREAKFAST
	added_foodtypes = FRIED
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/roti_john
	name = "约翰面包"
	reqs = list(
		/obj/item/food/baguette = 1,
		/obj/item/food/raw_meatball = 1,
		/obj/item/food/egg = 1,
		/obj/item/food/onion_slice = 1,
		/datum/reagent/consumable/capsaicin = 3,
		/datum/reagent/consumable/mayonnaise = 3,
	)
	result = /obj/item/food/roti_john
	added_foodtypes = BREAKFAST
	removed_foodtypes = RAW
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/izakaya_fries
	name = "居酒屋薯条"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/red_bay = 3,
		/datum/reagent/consumable/mayonnaise = 3,
	)
	result = /obj/item/food/izakaya_fries
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/kurry_ok_subsando
	name = "咖喱OK潜艇三明治"
	reqs = list(
		/obj/item/food/baguette = 1,
		/obj/item/food/izakaya_fries = 1,
		/obj/item/food/katsu_fillet = 1,
		/datum/reagent/consumable/nutriment/soup/curry_sauce = 5,
	)
	result = /obj/item/food/kurry_ok_subsando
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/loco_moco
	name = "疯狂盖饭"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/patty = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/friedegg = 1,
		/datum/reagent/consumable/gravy = 5,
	)
	result = /obj/item/food/loco_moco
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/wild_duck_fries
	name = "野鸭薯条"
	reqs = list(
		/obj/item/food/izakaya_fries = 1,
		/obj/item/food/meat/cutlet = 1,
		/datum/reagent/consumable/ketchup = 3,
	)
	result = /obj/item/food/wild_duck_fries
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/little_hawaii_hotdog
	name = "小夏威夷热狗"
	reqs = list(
		/obj/item/food/hotdog = 1,
		/obj/item/food/pineappleslice = 1,
		/obj/item/food/onion_slice = 1,
		/datum/reagent/consumable/nutriment/soup/teriyaki = 3,
	)
	result = /obj/item/food/little_hawaii_hotdog
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/salt_chilli_fries
	name = "盐辣薯条"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/salt = 3,
	)
	result = /obj/item/food/salt_chilli_fries
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/steak_croquette
	name = "炸牛排饼"
	reqs = list(
		/obj/item/food/meat/steak = 1,
		/obj/item/food/mashed_potatoes = 1,
		/obj/item/food/breadslice/reispan = 1,
	)
	result = /obj/item/food/steak_croquette
	added_foodtypes = FRIED
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/chapsilog
	name = "牛肉蒜香饭"
	reqs = list(
		/obj/item/food/grilled_chapslice = 2,
		/obj/item/food/friedegg = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/garlic = 1,
	)
	result = /obj/item/food/chapsilog
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/chap_hash
	name = "牛肉杂烩"
	reqs = list(
		/obj/item/food/chapslice = 2,
		/obj/item/food/egg = 1,
		/obj/item/food/grown/bell_pepper = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/onion_slice = 1,
	)
	result = /obj/item/food/chap_hash
	removed_foodtypes = RAW
	added_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/agedashi_tofu
	name = "扬出豆腐"
	reqs = list(
		/obj/item/food/tofu = 1,
		/obj/item/food/onion_slice = 1,
		/datum/reagent/consumable/nutriment/soup/dashi = 20,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/agedashi_tofu
	added_foodtypes = SEAFOOD
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SOUP

/datum/crafting_recipe/food/po_kok_gai
	name = "破壳鸡"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/obj/item/food/meat/slab/chicken = 1,
		/datum/reagent/consumable/coconut_milk = 5,
		/datum/reagent/consumable/curry_powder = 3,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/po_kok_gai
	added_foodtypes = FRUIT
	removed_foodtypes = RAW|BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/huoxing_tofu
	name = "火星豆腐"
	reqs = list(
		/obj/item/food/tofu = 1,
		/obj/item/food/raw_meatball = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/soybeans = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/huoxing_tofu
	removed_foodtypes = RAW
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/feizhou_ji
	name = "非洲鸡"
	reqs = list(
		/obj/item/food/meat/slab/chicken = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/bell_pepper = 1,
		/datum/reagent/consumable/vinegar = 5,
	)
	result = /obj/item/food/feizhou_ji
	removed_foodtypes = RAW
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/galinha_de_cabidela
	name = "血汁炖鸡"
	reqs = list(
		/obj/item/food/meat/slab/chicken = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/uncooked_rice = 1,
		/datum/reagent/blood = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/galinha_de_cabidela
	removed_foodtypes = RAW
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/katsu_curry
	name = "炸猪排咖喱"
	reqs = list(
		/obj/item/food/katsu_fillet = 1,
		/obj/item/food/boiledrice = 1,
		/datum/reagent/consumable/nutriment/soup/curry_sauce = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/katsu_curry
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/beef_bowl
	name = "牛肉盖饭"
	reqs = list(
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/boiledrice = 1,
		/datum/reagent/consumable/nutriment/soup/dashi = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/beef_bowl
	removed_foodtypes = BREAKFAST
	added_foodtypes = SEAFOOD
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/salt_chilli_bowl
	name = "盐辣章鱼盖饭"
	reqs = list(
		/obj/item/food/grilled_octopus = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/boiledrice = 1,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/nutriment/soup/curry_sauce = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/salt_chilli_bowl
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/kansai_bowl
	name = "关西盖饭"
	reqs = list(
		/obj/item/food/kamaboko_slice = 2,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/boiledrice = 1,
		/datum/reagent/consumable/nutriment/soup/dashi = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/kansai_bowl
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/eigamudo_curry
	name = "艾加姆多咖喱"
	reqs = list(
		/obj/item/food/grown/olive = 1,
		/obj/item/food/kimchi = 1,
		/obj/item/food/fishmeat = 1,
		/obj/item/food/boiledrice = 1,
		/datum/reagent/consumable/cafe_latte = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/eigamudo_curry
	removed_foodtypes = BREAKFAST
	added_foodtypes = GROSS|TOXIC
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

/datum/crafting_recipe/food/cilbir
	name = "土耳其酸奶蛋"
	reqs = list(
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/friedegg = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/yoghurt = 5,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
	)
	result = /obj/item/food/cilbir
	added_foodtypes = DAIRY
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/peking_duck_crepes
	name = "橙香北京烤鸭薄饼"
	reqs = list(
		/obj/item/food/pancakes = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/citrus/orange = 1,
		/datum/reagent/consumable/ethanol/cognac = 2,
	)
	result = /obj/item/food/peking_duck_crepes
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/vulgaris_spekkoek
	name = "粗俗千层糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/ambrosia/vulgaris = 1,
		/obj/item/food/butterslice = 2,
	)
	result = /obj/item/food/cake/spekkoek
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_CAKE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/pineapple_foster
	name = "火焰菠萝"
	reqs = list(
		/obj/item/food/pineappleslice = 1,
		/datum/reagent/consumable/caramel = 2,
		/obj/item/food/icecream = 1,
		/datum/reagent/consumable/ethanol/rum = 2,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/pineapple_foster
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/pastel_de_nata
	name = "葡式蛋挞"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/vanillapod = 1,
		/obj/item/food/egg = 1,
		/datum/reagent/consumable/sugar = 2,
	)
	result = /obj/item/food/pastel_de_nata
	removed_foodtypes = MEAT|RAW
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/boh_loh_yah
	name = "菠萝包"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/butterslice = 1,
		/datum/reagent/consumable/sugar = 5,
	)
	result = /obj/item/food/boh_loh_yah
	added_foodtypes = PINEAPPLE // someone thought it's funny to give it this foodtype smh
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_COOKIE
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/banana_fritter
	name = "香蕉炸饼"
	reqs = list(
		/obj/item/food/grown/banana = 1,
		/datum/reagent/consumable/martian_batter = 2
	)
	result = /obj/item/food/banana_fritter
	added_foodtypes = GRAIN|FRIED|SEAFOOD
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/pineapple_fritter
	name = "菠萝炸饼"
	reqs = list(
		/obj/item/food/pineappleslice = 1,
		/datum/reagent/consumable/martian_batter = 2
	)
	result = /obj/item/food/pineapple_fritter
	added_foodtypes = GRAIN|FRIED|SEAFOOD
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/kasei_dango
	name = "火星团子"
	reqs = list(
		/obj/item/stack/rods = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/rice = 5,
		/datum/reagent/consumable/orangejuice = 2,
		/datum/reagent/consumable/grenadine = 2,
	)
	result = /obj/item/food/kebab/kasei_dango
	added_foodtypes = GRAIN
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/pb_ice_cream_mochi
	name = "花生酱冰淇淋麻糬"
	reqs = list(
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/rice = 5,
		/datum/reagent/consumable/peanut_butter = 2,
		/obj/item/food/icecream = 1,
	)
	result = /obj/item/food/pb_ice_cream_mochi
	added_foodtypes = NUTS
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/frozen_pineapple_pop
	name = "冷冻菠萝冰棒"
	reqs = list(
		/obj/item/food/pineappleslice = 1,
		/obj/item/food/chocolatebar = 1,
		/obj/item/popsicle_stick = 1,
	)
	result = /obj/item/food/popsicle/pineapple_pop
	removed_foodtypes = JUNKFOOD
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/sea_salt_pop
	name = "海盐冰淇淋棒"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/salt = 3,
		/obj/item/popsicle_stick = 1,
	)
	result = /obj/item/food/popsicle/sea_salt
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/berry_topsicle
	name = "浆果顶冰"
	reqs = list(
		/obj/item/food/tofu = 1,
		/datum/reagent/consumable/berryjuice = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/popsicle_stick = 1,
	)
	result = /obj/item/food/popsicle/topsicle
	added_foodtypes = SUGAR|FRUIT
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/banana_topsicle
	name = "香蕉顶冰"
	reqs = list(
		/obj/item/food/tofu = 1,
		/datum/reagent/consumable/banana = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/popsicle_stick = 1,
	)
	result = /obj/item/food/popsicle/topsicle/banana
	added_foodtypes = SUGAR|FRUIT
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/pineapple_topsicle
	name = "菠萝顶冰"
	reqs = list(
		/obj/item/food/tofu = 1,
		/datum/reagent/consumable/pineapplejuice = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/popsicle_stick = 1,
	)
	result = /obj/item/food/popsicle/topsicle/pineapple
	added_foodtypes = SUGAR|FRUIT|PINEAPPLE
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/plasma_dog_supreme
	name = "至尊等离子热狗"
	reqs = list(
		/obj/item/food/hotdog = 1,
		/obj/item/food/pineappleslice = 1,
		/obj/item/food/sambal = 1,
		/obj/item/food/onion_slice = 1,
	)
	result = /obj/item/food/plasma_dog_supreme
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/frickles
	name = "炸酸黄瓜"
	reqs = list(
		/obj/item/food/pickle = 1,
		/datum/reagent/consumable/martian_batter = 2,
		/datum/reagent/consumable/red_bay = 1,
	)
	result = /obj/item/food/frickles
	added_foodtypes = GRAIN|FRIED|SEAFOOD
	cuisine_category = CUISINE_MARTIAN
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/raw_ballpark_pretzel
	name = "生球场椒盐卷饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/raw_ballpark_pretzel
	added_foodtypes = RAW
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_PASTRY
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/raw_ballpark_tsukune
	name = "生球场鸡肉丸"
	reqs = list(
		/obj/item/food/raw_meatball/chicken = 1,
		/datum/reagent/consumable/nutriment/soup/teriyaki = 2,
		/obj/item/stack/rods = 1,
	)
	result = /obj/item/food/kebab/raw_ballpark_tsukune
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/sprout_bowl
	name = "豆芽碗"
	reqs = list(
		/obj/item/food/pickled_voltvine = 1,
		/obj/item/food/fishmeat = 1,
		/obj/item/food/boiledrice = 1,
		/datum/reagent/consumable/nutriment/soup/dashi = 5,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/salad/sprout_bowl
	removed_foodtypes = BREAKFAST
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_RICE

// Soups

/datum/crafting_recipe/food/reaction/soup/boilednoodles
	reaction = /datum/chemical_reaction/food/soup/boilednoodles
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/dashi
	reaction = /datum/chemical_reaction/food/soup/dashi
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/teriyaki
	reaction = /datum/chemical_reaction/food/soup/teriyaki
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/curry_sauce
	reaction = /datum/chemical_reaction/food/soup/curry_sauce
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/shoyu_ramen
	reaction = /datum/chemical_reaction/food/soup/shoyu_ramen
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/gyuramen
	reaction = /datum/chemical_reaction/food/soup/gyuramen
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/new_osaka_sunrise
	reaction = /datum/chemical_reaction/food/soup/new_osaka_sunrise
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/satsuma_black
	reaction = /datum/chemical_reaction/food/soup/satsuma_black
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/dragon_ramen
	reaction = /datum/chemical_reaction/food/soup/dragon_ramen
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/hong_kong_borscht
	reaction = /datum/chemical_reaction/food/soup/hong_kong_borscht
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/hong_kong_macaroni
	reaction = /datum/chemical_reaction/food/soup/hong_kong_macaroni
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/foxs_prize_soup
	reaction = /datum/chemical_reaction/food/soup/foxs_prize_soup
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/secret_noodle_soup
	reaction = /datum/chemical_reaction/food/soup/secret_noodle_soup
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/budae_jjigae
	reaction = /datum/chemical_reaction/food/soup/budae_jjigae
	cuisine_category = CUISINE_MARTIAN

/datum/crafting_recipe/food/reaction/soup/volt_fish
	reaction = /datum/chemical_reaction/food/soup/volt_fish
	cuisine_category = CUISINE_MARTIAN
	dish_category = DISH_MEAT
