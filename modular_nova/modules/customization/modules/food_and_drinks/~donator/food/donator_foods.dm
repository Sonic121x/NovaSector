// Sprites Creator: Dumbdumn5 https://github.com/Dumbdumn5
// mrsanderp's donator item
/obj/item/food/donator/miso_pasta
	name = "味噌意面"
	desc = "一道流行的火星-意大利融合菜肴。出汁汤面配上意大利面条，并佐以香草和蘑菇。"
	icon = 'modular_nova/master_files/icons/obj/food/martian_italian.dmi'
	icon_state = "misonoodle"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/nutriment = 4
	)
	tastes = list("miso broth" = 10, "dough" = 3)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

// mrsanderp's donator item
/obj/item/food/donator/red_bay_chicken_meatballs
	name = "红湾鸡肉丸"
	desc = "用红湾调味料调味的鸡肉丸，然后串在木签上。这是火星殖民地“红色意大利”的一道流行菜肴。"
	icon = 'modular_nova/master_files/icons/obj/food/martian_italian.dmi'
	icon_state = "redbayballs"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/nutriment/vitamin = 2
	)
	tastes = list("spicy meatballs" = 5, "chicken" = 4)
	foodtypes = MEAT|VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 3.95)

// mrsanderp's donator item
/obj/item/food/donator/tiramisu
	name = "提拉米苏"
	desc = "一种甜点，由浸过咖啡的薄酥皮层层叠加，再涂上奶油和可可粉制成。过去传闻有助于解决卧室里的婚姻问题。"
	icon = 'modular_nova/master_files/icons/obj/food/martian_italian.dmi'
	icon_state = "tiramisu"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/coffee = 3,
		/datum/reagent/consumable/coco = 2
	)
	tastes = list("coffee" = 10, "pastry" = 4 , "sugar" = 5)
	foodtypes = JUNKFOOD | SUGAR | GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

// mrsanderp's donator item
/obj/item/food/donator/red_planet_parm
	name = "红色星球帕尔姆"
	desc = "一种炸鸡帕尔马干酪潜艇三明治，用米面包制成，上面淋有番茄酱和帕尔马干酪。这是居住于“红色意大利”殖民地的地球-意大利与火星文化融合的骄傲象征。"
	icon = 'modular_nova/master_files/icons/obj/food/martian_italian.dmi'
	icon_state = "chickenparm"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/nutriment/fat/oil = 2
	)
	tastes = list("rice dough" = 5, "chicken" = 4, "tomatoes" = 3, "cheese" = 2)
	foodtypes = MEAT | GRAIN | DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_4
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 4)

// mrsanderp's donator item
/obj/item/food/donator/aubergine_rolls
	name = "茄子卷"
	desc = "茄子片卷起并包裹着融化的奶酪，然后用番茄酱和橄榄油调味。简单，但很饱腹！"
	icon = 'modular_nova/master_files/icons/obj/food/martian_italian.dmi'
	icon_state = "auberginerolls"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2
	)
	tastes = list("eggplant" = 5, "cheese" = 4)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

// mrsanderp's donator item
/obj/item/food/donator/pineapple_trifle
	name = "菠萝松糕"
	desc = "深受火星人和地球-意大利人喜爱的菠萝松糕，是一种以酥皮衬底的蛋奶冻，上面铺有菠萝干和菠萝糖浆。完美的跨年甜点！"
	icon = 'modular_nova/master_files/icons/obj/food/martian_italian.dmi'
	icon_state = "pineappletrifle"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 4,
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("pineapple" = 10, "pastry" = 3 , "sugar" = 5)
	foodtypes = SUGAR | GRAIN | FRUIT | DAIRY | PINEAPPLE
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3
