
// see code/module/crafting/table.dm

////////////////////////////////////////////////SPAGHETTI////////////////////////////////////////////////

/datum/crafting_recipe/food/tomatopasta
	name = "Tomato pasta-西红柿意面"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/grown/tomato = 2
	)
	result = /obj/item/food/spaghetti/pastatomato
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_ITALIAN

/datum/crafting_recipe/food/copypasta
	name = "复制意面"
	reqs = list(
		/obj/item/food/spaghetti/pastatomato = 2
	)
	result = /obj/item/food/spaghetti/copypasta
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_ITALIAN

/datum/crafting_recipe/food/spaghettimeatball
	name = "Spaghetti meatball-意大利肉丸"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meatball = 2
	)
	result = /obj/item/food/spaghetti/meatballspaghetti
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_ITALIAN

/datum/crafting_recipe/food/spesslaw
	name = "太空肉丸意面"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meatball = 4
	)
	result = /obj/item/food/spaghetti/spesslaw
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_ITALIAN

/datum/crafting_recipe/food/beefnoodle
	name = "Beef noodle-牛肉面"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/spaghetti/beefnoodle
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_ITALIAN

/datum/crafting_recipe/food/chowmein
	name = "Chowmein-炒面"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/cabbage = 2,
		/obj/item/food/grown/carrot = 1
	)
	result = /obj/item/food/spaghetti/chowmein
	dish_category = DISH_NOODLES
	// cuisine_category = CUISINE_CHINESE

/datum/crafting_recipe/food/butternoodles
	name = "Butter Noodles-黄油面条"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/butterslice = 1
	)
	result = /obj/item/food/spaghetti/butternoodles
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_ITALIAN

/datum/crafting_recipe/food/mac_n_cheese
	name = "Mac n' cheese-芝士煮通心粉"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/bechamel_sauce = 1,
		/obj/item/food/cheese/wedge = 2,
		/obj/item/food/breadslice/plain = 1,
		/datum/reagent/consumable/blackpepper = 2
	)
	result = /obj/item/food/spaghetti/mac_n_cheese
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/shoyu_tonkotsu_ramen
	name = "酱油豚骨拉面"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/seaweedsheet = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/spaghetti/shoyu_tonkotsu_ramen
	removed_foodtypes = BREAKFAST
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_JAPANESE

/datum/crafting_recipe/food/kitakata_ramen
	name = "喜多方拉面"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/mushroom/chanterelle = 1,
		/obj/item/food/grown/garlic = 1,
	)
	result = /obj/item/food/spaghetti/kitakata_ramen
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_JAPANESE

/datum/crafting_recipe/food/kitsune_udon
	name = "狐狸乌冬面"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/tofu = 2,
		/obj/item/food/grown/onion = 1,
		/datum/reagent/consumable/soysauce = 5,
		/datum/reagent/consumable/sugar = 5,
	)
	result = /obj/item/food/spaghetti/kitsune_udon
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_JAPANESE

/datum/crafting_recipe/food/nikujaga
	name = "肉じゃが"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/peas = 1,
	)
	result = /obj/item/food/spaghetti/nikujaga
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_JAPANESE

/datum/crafting_recipe/food/pho
	name = "越南河粉"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/spaghetti/pho
	dish_category = DISH_NOODLES
	// cuisine_category = CUISINE_VIETNAMESE

/datum/crafting_recipe/food/pad_thai
	name = "泰式炒河粉"
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/tofu = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/peanut = 1,
		/obj/item/food/grown/citrus/lime = 1,
	)
	result = /obj/item/food/spaghetti/pad_thai
	dish_category = DISH_NOODLES
	// cuisine_category = CUISINE_THAI

/datum/crafting_recipe/food/carbonara
	name = "培根蛋酱意大利面"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/cheese/firm_cheese_slice = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/egg = 1,
		/datum/reagent/consumable/blackpepper = 2,
	)
	result = /obj/item/food/spaghetti/carbonara
	removed_foodtypes = BREAKFAST|RAW
	dish_category = DISH_NOODLES
	cuisine_category = CUISINE_ITALIAN
