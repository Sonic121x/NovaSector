// Packaged whole meals and sides for the 'meals' tab of vendors

/* TRASH */

/obj/item/trash/empty_food_tray
	name = "空的塑料餐盘"
	desc = "冷凝水以及你只能希望是食物残渣的东西，让这玩意儿有点难以重复使用。"
	icon = 'modular_nova/modules/imported_vendors/icons/imported_quick_foods.dmi'
	icon_state = "foodtray_empty"
	custom_materials = list(
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
	)

/obj/item/trash/empty_side_pack
	name = "空的配菜包装纸"
	desc = "Unfortunately, this no longer holds any sides to distract you from the other 'food'."
	icon = 'modular_nova/modules/imported_vendors/icons/imported_quick_foods.dmi'
	icon_state = "foodpack_generic_trash"
	custom_materials = list(
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
	)

/obj/item/trash/empty_side_pack/nt
	icon_state = "foodpack_nt_trash"

/obj/item/trash/empty_side_pack/yangyu
	icon_state = "foodpack_yangyu_trash"

/obj/item/trash/empty_side_pack/moth
	icon_state = "foodpack_moth_trash"

/obj/item/trash/empty_side_pack/tizira
	icon_state = "foodpack_tizira_trash"

/* MEALS */

/*
*	NT Meals
*/

/obj/item/food/vendor_tray_meal
	name = "\improper 纳米传讯-餐盘：牛排配通心粉"
	desc = "一份浸泡在类似肉汁酱料中的'索尔兹伯里牛排'，旁边放着一份通心粉和奶酪替代品混合物。"
	icon = 'modular_nova/modules/imported_vendors/icons/imported_quick_foods.dmi'
	icon_state = "foodtray_sad_steak"
	trash_type = /obj/item/trash/empty_food_tray
	food_reagents = list(/datum/reagent/consumable/nutriment = 8)
	tastes = list("meat?" = 2, "cheese?" = 2, "laziness" = 1)
	foodtypes = MEAT | GRAIN | DAIRY
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	///Does this food have the steam effect on it when initialized
	var/hot_and_steamy = TRUE

/obj/item/food/vendor_tray_meal/Initialize(mapload)
	. = ..()
	if(hot_and_steamy)
		overlays += mutable_appearance('icons/effects/steam.dmi', "steam_triple", ABOVE_OBJ_LAYER)

/obj/item/food/vendor_tray_meal/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你浏览着盒子背面...</i>")
	. += "\t[span_warning("Warning: Packaged in a factory where every allergen known is present.")]"
	. += "\t[span_warning("Warning: Contents might be hot.")]"
	. += "\t[span_info("Per 200g serving contains: 8g Sodium; 25g Fat, of which 22g are saturated; 2g Sugar.")]"
	return .

/obj/item/food/vendor_tray_meal/burger
	name = "\improper 纳米传讯套餐：芝士汉堡"
	desc = "一个看起来相当凄惨的汉堡，底层面包有点湿软，奶酪是荧光黄色的。"
	icon_state = "foodtray_burg"
	tastes = list("bread" = 2, "meat?" = 2, "cheese?" = 2, "laziness" = 1)
	foodtypes = MEAT | GRAIN | DAIRY

/obj/item/food/vendor_tray_meal/chicken_sandwich
	name = "\improper NT-套餐：辣味鸡肉三明治"
	desc = "A pretty sad looking chicken sandwich, the 'meat' patty is covered in so many manufactured spices that it has become an eerie red color."
	icon_state = "foodtray_chickie_sandwich"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/capsaicin = 10)
	tastes = list("bread" = 2, "chicken?" = 2, "overwhelming spice" = 2, "laziness" = 1)
	foodtypes = MEAT | GRAIN | DAIRY

/*
*	Yangyu Meals
*/

/obj/item/food/vendor_tray_meal/ramen
	name = "\improper 美之素：家常风味面条"
	desc = "一块最优质的工厂制拉面砖，漂浮着少量复水蔬菜和香草。"
	icon_state = "foodtray_noodle"
	tastes = list("cheap noodles" = 2, "laziness" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/vendor_tray_meal/sushi
	name = "\improper 明光寿司：新鲜鲤鱼卷"
	desc = "一对寿司卷，其外观会让你觉得标签在骗你。"
	icon_state = "foodtray_gas_station_sushi"
	tastes = list("imitation space carp" = 2, "stale rice" = 2, "laziness" = 1)
	foodtypes = GRAIN | SEAFOOD

/obj/item/food/vendor_tray_meal/beef_rice
	name = "\improper 美之素：牛肉炒饭"
	desc = "几片看起来像是烤过的牛肉，搭配着不成比例的大量米饭。"
	icon_state = "foodtray_beef_n_rice"
	tastes = list("cheap beef" = 1, "rice" = 3, "laziness" = 1)
	foodtypes = GRAIN | MEAT

/*
*	Mothic Meals
*/

/obj/item/food/vendor_tray_meal/pesto_pizza
	name = "\improper 主菜 - M型：香蒜披萨"
	desc = "一块长方形披萨，用可疑的亮绿色香蒜酱代替了标准的番茄酱。"
	icon_state = "foodtray_pesto_pizza"
	tastes = list("tomato?" = 2, "cheese?" = 2, "herbs" = 1, "laziness" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES

/obj/item/food/vendor_tray_meal/baked_rice
	name = "\improper 主菜 - M型：焗饭与烤奶酪"
	desc = "一份看起来低于平均水准的舰队风格米饭，配着一大块烤得焦黄的奶酪。"
	icon_state = "foodtray_rice_n_grilled_cheese"
	tastes = list("rice" = 2, "peppers" = 2, "charred cheese" = 2, "laziness" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES

/obj/item/food/vendor_tray_meal/fueljack
	name = "\improper 主菜 - M型：燃料工的餐盘"
	desc = "一块扁平的燃料工午餐，似乎缺少了通常配菜的大部分种类。"
	icon_state = "foodtray_fuel_jacks_meal"
	tastes = list("potato" = 2, "cabbage" = 2, "cheese?" = 2, "laziness" = 1)
	foodtypes = DAIRY | VEGETABLES

/*
*	Tiziran Meals
*/

/obj/item/food/vendor_tray_meal/moonfish_nizaya
	name = "\improper 提兹拉进口：月鱼与尼扎亚面"
	desc = "一块看起来几乎像合成品的月鱼切片，搭配着等量的尼扎亚面。"
	icon_state = "foodtray_moonfish_nizaya"
	tastes = list("fish?" = 2, "cheap noodles" = 2, "laziness" = 1)
	foodtypes = VEGETABLES | NUTS | SEAFOOD

/obj/item/food/vendor_tray_meal/emperor_roll
	name = "\improper 提兹拉进口：帝王卷"
	desc = "一份看起来相当寒酸的帝王卷，如果这还能称之为帝王卷的话；看来鱼子酱不在预算之内。"
	icon_state = "foodtray_emperor_roll"
	tastes = list("bread" = 2, "cheese?" = 2, "liver?" = 2, "laziness" = 1)
	foodtypes = VEGETABLES | NUTS | MEAT | GORE

/obj/item/food/vendor_tray_meal/mushroom_fry
	name = "\improper 提兹拉进口：蘑菇炒菜"
	desc = "一堆很可能是品质太低、无法用于制作正经菜肴的蘑菇，稍微炒过后一起扔进了一个塑料容器里。"
	icon_state = "foodtray_shroom_fry"
	tastes = list("mushroom" = 4, "becoming rich" = 1, "laziness" = 1)
	foodtypes = VEGETABLES

/* SIDES */

/obj/effect/spawner/random/vendor_meal_sides
	name = "随机配菜生成器"
	desc = "希望我能拿到一个真正配得上主菜的配菜。"
	icon_state = "loot"

/*
*	NT Sides
*/

/obj/effect/spawner/random/vendor_meal_sides/nt
	name = "随机纳米传讯配菜生成器"

/obj/effect/spawner/random/vendor_meal_sides/nt/Initialize(mapload)
	loot = list(
		/obj/item/food/vendor_tray_meal/side,
		/obj/item/food/vendor_tray_meal/side/crackers_and_jam,
		/obj/item/food/vendor_tray_meal/side/crackers_and_cheese,
	)
	. = ..()

/obj/item/food/vendor_tray_meal/side
	name = "\improper 纳米传讯配菜：扁面包与花生酱"
	desc = "一小叠硬实的扁面包，每片配一小抹花生酱。"
	icon_state = "foodpack_nt"
	trash_type = /obj/item/trash/empty_side_pack/nt
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("tough bread" = 2, "peanut butter" = 2)
	foodtypes = GRAIN
	hot_and_steamy = FALSE
	custom_price = PAYCHECK_LOWER * 2.5

/obj/item/food/vendor_tray_meal/side/crackers_and_jam
	name = "\improper 纳米传讯配菜：扁面包与浆果果冻"
	desc = "一小叠硬实的扁面包，每片配一小抹不知名的浆果果冻。"
	tastes = list("tough bread" = 2, "berries" = 2)
	foodtypes = GRAIN | FRUIT

/obj/item/food/vendor_tray_meal/side/crackers_and_cheese
	name = "\improper 纳米传讯配菜：扁面包与奶酪酱"
	desc = "一小叠硬实的扁面包，每片配一小抹奶酪酱。"
	tastes = list("tough bread" = 2, "cheese" = 2)
	foodtypes = GRAIN | DAIRY

/*
*	Yangyu Sides
*/

/obj/effect/spawner/random/vendor_meal_sides/yangyu
	name = "随机阳芋配菜生成器"

/obj/effect/spawner/random/vendor_meal_sides/yangyu/Initialize(mapload)
	loot = list(
		/obj/item/food/vendor_tray_meal/side/miso,
		/obj/item/food/vendor_tray_meal/side/rice,
		/obj/item/food/vendor_tray_meal/side/pickled_vegetables,
	)
	. = ..()

/obj/item/food/vendor_tray_meal/side/miso
	name = "\improper 福彩：味噌汤"
	desc = "这真的只是一个装满味噌汤的塑料袋，从指示面以外的任何一侧打开都可能导致汤汁洒出。"
	icon_state = "foodpack_yangyu"
	trash_type = /obj/item/trash/empty_side_pack/yangyu
	tastes = list("miso" = 2)
	foodtypes = VEGETABLES

/obj/item/food/vendor_tray_meal/side/rice
	name = "\improper 福彩：白米饭"
	desc = "一个塞满了白米饭的袋子，以防你的餐食分量不足以满足你的需求。"
	icon_state = "foodpack_yangyu"
	trash_type = /obj/item/trash/empty_side_pack/yangyu
	tastes = list("old rice" = 2)
	foodtypes = GRAIN

/obj/item/food/vendor_tray_meal/side/pickled_vegetables
	name = "\improper 福彩：腌渍蔬菜"
	desc = "包含一小份用类似醋的溶液腌渍的蔬菜。"
	icon_state = "foodpack_yangyu"
	trash_type = /obj/item/trash/empty_side_pack/yangyu
	tastes = list("vinegar" = 4)
	foodtypes = VEGETABLES

/*
*	Mothic Sides
*/

/obj/effect/spawner/random/vendor_meal_sides/moth
	name = "随机蛾类配菜生成器"

/obj/effect/spawner/random/vendor_meal_sides/moth/Initialize(mapload)
	loot = list(
		/obj/item/food/vendor_tray_meal/side/moffin,
		/obj/item/food/vendor_tray_meal/side/cornbread,
		/obj/item/food/vendor_tray_meal/side/roasted_seeds,
	)
	. = ..()

/obj/item/food/vendor_tray_meal/side/moffin
	name = "\improper 配菜 - M型：蛾松饼"
	desc = "将一个原本完美的蛾松饼压扁成更接近威化饼形态的结果。"
	icon_state = "foodpack_moth"
	trash_type = /obj/item/trash/empty_side_pack/moth
	tastes = list("fabric?" = 2, "sugar" = 2)
	foodtypes = CLOTH | GRAIN | SUGAR

/obj/item/food/vendor_tray_meal/side/cornbread
	name = "\improper 配菜 - M型：玉米面包"
	desc = "一块压扁的甜味玉米面包切片，搭配黄油很美味。"
	icon_state = "foodpack_moth"
	trash_type = /obj/item/trash/empty_side_pack/moth
	tastes = list("cornbread" = 2, "sweetness" = 2)
	foodtypes = GRAIN | SUGAR

/obj/item/food/vendor_tray_meal/side/roasted_seeds
	name = "\improper 配菜 - M型：烤种子"
	desc = "一包装满各种烤箱烤制种子的袋子。"
	icon_state = "foodpack_moth"
	trash_type = /obj/item/trash/empty_side_pack/moth
	tastes = list("seeds" = 2, "char" = 2)
	foodtypes = NUTS

/*
*	Tiziran Sides
*/

/obj/effect/spawner/random/vendor_meal_sides/tizira
	name = "随机提兹兰配菜生成器"

/obj/effect/spawner/random/vendor_meal_sides/tizira/Initialize(mapload)
	loot = list(
		/obj/item/food/vendor_tray_meal/side/root_crackers,
		/obj/item/food/vendor_tray_meal/side/korta_brittle,
		/obj/item/food/vendor_tray_meal/side/crispy_headcheese,
	)
	. = ..()

/obj/item/food/vendor_tray_meal/side/root_crackers
	name = "\improper 提兹兰进口：根面包饼干与肉酱"
	desc = "一小叠根面包饼干，每块都配有一小抹肉酱。"
	icon_state = "foodpack_tizira"
	trash_type = /obj/item/trash/empty_side_pack/tizira
	tastes = list("tough rootbread" = 2, "pate" = 2)
	foodtypes = VEGETABLES | NUTS | MEAT

/obj/item/food/vendor_tray_meal/side/korta_brittle
	name = "\improper 提兹兰进口：科尔塔脆片"
	desc = "一块完美矩形的无糖科尔塔脆片。"
	icon_state = "foodpack_tizira"
	trash_type = /obj/item/trash/empty_side_pack/tizira
	tastes = list("peppery heat" = 2)
	foodtypes = NUTS

/obj/item/food/vendor_tray_meal/side/crispy_headcheese
	name = "\improper 提兹兰进口：脆皮头肉冻"
	desc = "一块看起来经过加工、裹了面包屑的头肉冻方块。"
	icon_state = "foodpack_tizira"
	trash_type = /obj/item/trash/empty_side_pack/tizira
	tastes = list("cheese" = 1, "oil" = 1)
	foodtypes = MEAT | VEGETABLES | NUTS | GORE
