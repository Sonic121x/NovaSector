// Snacks and drinks for the 'snacks' tab of vendors

/obj/item/food/vendor_snacks
	name = "\improper 神之最强零食"
	desc = "你最好祈祷自己不是罪人。（你永远不该看到这个物品，请报告它）"
	icon = 'modular_nova/modules/imported_vendors/icons/imported_quick_foods.dmi'
	icon_state = "foodpack_generic"
	trash_type = /obj/item/trash/vendor_trash
	bite_consumption = 10
	food_reagents = list(/datum/reagent/consumable/nutriment = INFINITY)
	junkiness = 10
	custom_price = PAYCHECK_LOWER * INFINITY
	tastes = list("the unmatched power of the sun" = 10)
	foodtypes = JUNKFOOD | CLOTH | GORE | NUTS | FRIED | FRUIT //You don't want to know what's in the broken debug snacks
	w_class = WEIGHT_CLASS_SMALL

/obj/item/trash/vendor_trash
	name = "\improper 神之最弱零食"
	desc = "很可能是过去某个伟大零食的残骸。"
	icon = 'modular_nova/modules/imported_vendors/icons/imported_quick_foods.dmi'
	icon_state = "foodpack_generic_trash"
	custom_materials = list(
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
	)

/*
*	Yangyu Snacks
*/

/obj/item/reagent_containers/cup/glass/dry_ramen/prepared
	name = "杯面"
	desc = "这个甚至还带了水，太棒了！"
	list_reagents = list(/datum/reagent/consumable/hot_ramen = 15, /datum/reagent/consumable/salt = 3)

/obj/item/reagent_containers/cup/glass/dry_ramen/prepared/hell
	name = "辣味杯面"
	desc = "这个带了水，还有相当于一个安保检查站分量的辣椒素！"
	list_reagents = list(/datum/reagent/consumable/hell_ramen = 15, /datum/reagent/consumable/salt = 3)

/obj/item/food/vendor_snacks/rice_crackers
	name = "米饼"
	desc = "尽管包装大部分是透明的，但除非你吃下去，否则永远无法真正知道这些是什么口味。"
	icon_state = "rice_cracka"
	trash_type = /obj/item/trash/vendor_trash/rice_crackers
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/rice = 2)
	tastes = list("incomprehensible flavoring" = 1, "rice cracker" = 2)
	foodtypes = JUNKFOOD | GRAIN
	custom_price = PAYCHECK_LOWER * 0.8

/obj/item/food/vendor_snacks/rice_crackers/make_leave_trash()
	AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)

/obj/item/trash/vendor_trash/rice_crackers
	name = "空米饼袋"
	desc = "你终究还是没搞清楚那本该是什么口味，对吧？"
	icon_state = "rice_cracka_trash"

/obj/item/food/vendor_snacks/mochi_ice_cream
	name = "麻糬冰淇淋球 - 香草味"
	desc = "一盒六颗装的麻糬冰淇淋，即香草冰淇淋包裹在麻糬中。附赠小塑料签用于食用。"
	icon_state = "mochi_ice"
	trash_type = /obj/item/trash/vendor_trash/mochi_ice_cream
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/ice = 3)
	tastes = list("rice cake" = 2, "vanilla" = 2)
	foodtypes = JUNKFOOD | DAIRY | GRAIN
	custom_price = PAYCHECK_LOWER

/obj/item/food/vendor_snacks/mochi_ice_cream/matcha
	name = "麻糬冰淇淋球 - 抹茶味"
	desc = "一盒六颗装的麻糬冰淇淋——更具体地说，是抹茶冰淇淋包裹在麻糬中。附赠小塑料签用于食用。"
	icon_state = "mochi_ice_green"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/ice = 1, /datum/reagent/consumable/tea = 2)
	tastes = list("rice cake" = 1, "bitter matcha" = 2)
	custom_price = PAYCHECK_LOWER * 1.2

/obj/item/food/vendor_snacks/mochi_ice_cream/matcha/examine_more(mob/user)
	. = ..()
	. += span_notice("容器上的一个小标签注明，这款冰淇淋仅使用太阳系外种植的烹饪级抹茶制成。")
	return .

/obj/item/trash/vendor_trash/mochi_ice_cream
	name = "空麻糬冰淇淋托盘"
	desc = "不知怎的，它附赠的那根小塑料签不见了。"
	icon_state = "mochi_ice_trash"

/obj/item/reagent_containers/cup/glass/waterbottle/tea
	name = "瓶装茶"
	desc = "一瓶装在便利塑料瓶中的茶。"
	icon = 'modular_nova/modules/imported_vendors/icons/imported_quick_foods.dmi'
	icon_state = "tea_bottle"
	list_reagents = list(/datum/reagent/consumable/tea = 40)
	cap_icon_state = "bottle_cap_tea"
	flip_chance = 5 //I fucking dare you
	custom_price = PAYCHECK_LOWER * 1.2
	fill_icon_state = null

/obj/item/reagent_containers/cup/glass/waterbottle/tea/astra
	name = "astra牌茶饮"
	desc = "一瓶astra牌茶饮，以其茶叶冲泡后带来的相当独特的口感而闻名。"
	icon_state = "tea_bottle_blue"
	list_reagents = list(
		/datum/reagent/consumable/tea = 25,
		/datum/reagent/medicine/salglu_solution = 10, // I know this looks strange but this is what tea astra grinds into, tea in the year 25whatever baby
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	custom_price = PAYCHECK_LOWER * 2

/obj/item/reagent_containers/cup/glass/waterbottle/tea/strawberry
	name = "草莓味茶饮"
	desc = "一瓶草莓味茶饮；不含任何真正的草莓。"
	icon_state = "tea_bottle_pink"
	list_reagents = list(/datum/reagent/consumable/pinktea = 40)
	custom_price = PAYCHECK_LOWER * 2

/obj/item/reagent_containers/cup/glass/waterbottle/tea/nip
	name = "猫薄荷茶饮"
	desc = "一瓶猫薄荷茶饮，根据SFDA的安全规定，其浓度必须控制在50%或以下。"
	icon_state = "tea_bottle_pink"
	list_reagents = list(
		/datum/reagent/consumable/catnip_tea = 20,
		/datum/reagent/consumable/pinkmilk = 20, // I can't believe they would cut my catnip
	)
	custom_price = PAYCHECK_LOWER * 2.5

/*
*	Mothic Snacks
*/

/obj/item/food/vendor_snacks/mothmallow
	name = "蛾虫软糖"
	desc = "一个真空密封袋，里面装着一块看起来被压得相当扁的蛾虫软糖，谁来救救它！"
	icon_state = "mothmallow"
	trash_type = /obj/item/trash/vendor_trash/mothmallow
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 4)
	tastes = list("vanilla" = 1, "cotton" = 1, "chocolate" = 1)
	foodtypes = VEGETABLES | SUGAR
	custom_price = PAYCHECK_LOWER

/obj/item/food/vendor_snacks/mothmallow/make_leave_trash()
	AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)

/obj/item/trash/vendor_trash/mothmallow
	name = "空的蛾虫软糖袋"
	desc = "它终于自由了。"
	icon_state = "mothmallow_trash"

/obj/item/food/vendor_snacks/moth_bag
	name = "引擎饲料"
	desc = "一个真空密封袋，内含一小份色彩缤纷的引擎饲料。"
	icon_state = "fodder"
	trash_type = /obj/item/trash/vendor_trash/moth_bag
	food_reagents = list(/datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/salt = 2)
	tastes = list("seeds" = 1, "nuts" = 1, "chocolate" = 1, "salt" = 1, "popcorn" = 1, "potato" = 1)
	foodtypes = GRAIN | NUTS | VEGETABLES | SUGAR
	custom_price = PAYCHECK_LOWER * 1.2

/obj/item/food/vendor_snacks/moth_bag/fuel_jack
	name = "燃料杰克的零食"
	desc = "一个真空密封袋，内含一块比通常规格小的燃料杰克午餐砖，因此降级为燃料杰克的零食。"
	icon_state = "fuel_jack_snack"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("cabbage" = 1, "potato" = 1, "onion" = 1, "chili" = 1, "cheese" = 1)
	foodtypes = DAIRY | VEGETABLES
	custom_price = PAYCHECK_LOWER * 1.2

/obj/item/food/vendor_snacks/moth_bag/cheesecake
	name = "巧克力芝士蛋糕方块"
	desc = "一个真空密封袋，内含一小块飞蛾风格的芝士蛋糕方块，这个表面覆盖着巧克力。"
	icon_state = "choco_cheese_cake"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/sugar = 4)
	tastes = list("cheesecake" = 1, "chocolate" = 1)
	foodtypes = SUGAR | FRIED | DAIRY | GRAIN
	custom_price = PAYCHECK_LOWER * 1.4

/obj/item/food/vendor_snacks/moth_bag/cheesecake/honey
	name = "蜂蜜芝士蛋糕方块"
	desc = "一个真空密封袋，内含一小块飞蛾风格的芝士蛋糕方块，这个表面覆盖着蜂蜜。"
	icon_state = "honey_cheese_cake"
	tastes = list("cheesecake" = 1, "honey" = 1)
	foodtypes = SUGAR | FRIED | DAIRY | GRAIN

/obj/item/trash/vendor_trash/moth_bag
	name = "空的飞蛾风格零食袋"
	desc = "透明的塑料包装表明，它已不再为你那些带翅膀的朋友们保留美味零食了。"
	icon_state = "moth_bag_trash"

/obj/item/reagent_containers/cup/soda_cans/nova/lemonade
	name = "\improper 工厂船 1023：柠檬汽水"
	desc = "一罐柠檬汽水，适合那些好这口的人，或者只是别无选择。"
	icon_state = "lemonade"
	list_reagents = list(/datum/reagent/consumable/lemonade = 30)
	drink_type = FRUIT

/obj/item/reagent_containers/cup/soda_cans/nova/lemonade/examine_more(mob/user)
	. = ..()
	. += span_notice("罐身上的标记表明，这罐产自大游牧舰队的<i>工厂船 1023</i>。")
	return .

/obj/item/reagent_containers/cup/soda_cans/nova/navy_rum
	name = "\improper 工厂船 1506：海军朗姆酒"
	desc = "一罐海军朗姆酒，据罐身说明，是由游牧舰队的一支分遣队酿造并进口的。"
	icon_state = "navy_rum"
	list_reagents = list(/datum/reagent/consumable/ethanol/navy_rum = 30)
	drink_type = ALCOHOL

/obj/item/reagent_containers/cup/soda_cans/nova/navy_rum/examine_more(mob/user)
	. = ..()
	. += span_notice("罐身上的标记表明，这罐产自大游牧舰队的<i>工厂船 1506</i>。")
	return .

/obj/item/reagent_containers/cup/soda_cans/nova/soda_water_moth
	name = "\improper 工厂船 1023：苏打水"
	desc = "一罐苏打水。何不调一杯朗姆苏打呢？现在想想，也许还是算了。"
	icon_state = "soda_water"
	list_reagents = list(/datum/reagent/consumable/sodawater = 30)
	drink_type = SUGAR

/obj/item/reagent_containers/cup/soda_cans/nova/soda_water_moth/examine_more(mob/user)
	. = ..()
	. += span_notice("罐身上的标记表明，这罐产自大游牧舰队的<i>工厂船 1023</i>。")
	return .

/obj/item/reagent_containers/cup/soda_cans/nova/ginger_beer
	name = "\improper 工厂船 1023：姜汁啤酒"
	desc = "一罐姜汁啤酒，别被“啤酒”二字误导了，这完全不含酒精。"
	icon_state = "gingie_beer"
	list_reagents = list(/datum/reagent/consumable/sol_dry = 30)
	drink_type = SUGAR

/obj/item/reagent_containers/cup/soda_cans/nova/ginger_beer/examine_more(mob/user)
	. = ..()
	. += span_notice("罐身上的标记表明，这罐产自大游牧舰队的<i>工厂船 1023</i>。")
	return .

/*
*	Tiziran Snacks
*/

/obj/item/food/vendor_snacks/lizard_bag
	name = "蜜饯蘑菇"
	desc = "蜥蜴帝国的一种奇特零食，一种裹了焦糖的蘑菇；不幸的是，它似乎在焦糖完全凝固前就被装袋了。"
	icon_state = "candied_shroom"
	trash_type = /obj/item/trash/vendor_trash/lizard_bag
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/caramel = 2)
	tastes = list("savouriness" = 1, "sweetness" = 1)
	foodtypes = SUGAR | VEGETABLES
	custom_price = PAYCHECK_LOWER * 1.4 //Tiziran imports are a bit more expensive overall

/obj/item/food/vendor_snacks/lizard_bag/make_leave_trash()
	AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)

/obj/item/food/vendor_snacks/lizard_bag/moon_jerky
	name = "月鱼肉干"
	desc = "一种鱼肉干，由你只能希望是月鱼的鱼制成。尝起来似乎还有一丝微妙的烧烤味。"
	icon_state = "moon_jerky"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/bbqsauce = 2)
	tastes = list("fish" = 1, "smokey sauce" = 1)
	foodtypes = MEAT
	custom_price = PAYCHECK_LOWER * 1.6

/obj/item/trash/vendor_trash/lizard_bag
	name = "空的提兹兰零食袋"
	desc = "花了那么多钱进口提兹兰零食，最后就落得这个？"
	icon_state = "tizira_bag_trash"

/obj/item/food/vendor_snacks/lizard_box
	name = "提兹兰饺子"
	desc = "一盒三只装的提兹兰风格饺子，实际上里面什么馅料都没有。"
	icon_state = "dumpling"
	trash_type = /obj/item/trash/vendor_trash/lizard_box
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	tastes = list("potato" = 1, "earthy heat" = 1)
	foodtypes = VEGETABLES | NUTS
	custom_price = PAYCHECK_LOWER * 1.6

/obj/item/food/vendor_snacks/lizard_box/sweet_roll
	name = "蜂蜜卷"
	desc = "绝对不要让卫兵发现有人偷走了你最后一个。"
	icon_state = "sweet_roll"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/honey = 2)
	tastes = list("bread" = 1, "honey" = 1, "fruit" = 1)
	foodtypes = VEGETABLES | NUTS | FRUIT
	custom_price = PAYCHECK_LOWER *1.8

/obj/item/trash/vendor_trash/lizard_box
	name = "空的提兹兰零食盒"
	desc = "提兹兰，自2530年起为太空塑料危机贡献力量。"
	icon_state = "tizira_box_trash"

/obj/item/reagent_containers/cup/glass/waterbottle/tea/mushroom
	name = "一瓶蘑菇茶"
	desc = "一瓶略带苦味的蘑菇茶，提兹兰帝国的最爱。"
	icon_state = "tea_bottle_grey"
	list_reagents = list(/datum/reagent/consumable/mushroom_tea = 40)
	custom_price = PAYCHECK_LOWER * 2

/obj/item/reagent_containers/cup/soda_cans/nova/kortara
	name = "Kortara-科塔拉"
	desc = "一罐科尔塔拉，一种用科尔塔种子酿造的酒精饮料，赋予其独特的胡椒香料风味。"
	icon_state = "kortara"
	list_reagents = list(/datum/reagent/consumable/ethanol/kortara = 30)
	drink_type = ALCOHOL
