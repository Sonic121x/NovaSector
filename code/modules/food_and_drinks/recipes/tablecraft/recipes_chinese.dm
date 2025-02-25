//see code/module/crafting/table.dm

////////////////////////////////////////////////CHINESE FOOD////////////////////////////////////////////////

/datum/crafting_recipe/food/zongzi
	name = "粽子"
	reqs = list(
		/obj/item/food/boiledrice = 1,
		/datum/reagent/consumable/eggyolk = 2,
		/obj/item/food/meat/steak = 1,
		/obj/item/grown/log/bamboo = 1
	)
	result = /obj/item/food/zongzi
	category = CAT_CHINESE

/datum/crafting_recipe/food/tangyuan
	name = "汤圆"
	reqs = list(
		/obj/item/food/bait/doughball = 5,
		/obj/item/food/grown/peanut = 1,
		/datum/reagent/consumable/sugar = 2

	)
	result = /obj/item/food/tangyuan
	category = CAT_CHINESE

// /datum/crafting_recipe/food/qingtuan
// 	name = "青团"
// 	reqs = list(
// 		/obj/item/food/grown/herbs = 1,
// 		/obj/item/food/boiledrice = 1,
// 		/obj/item/food/grown/redbean = 1 //红豆没写
// 	)
// 	result = /obj/item/food/qingtuan
// 	category = CAT_CHINESE

/datum/crafting_recipe/food/mooncake
	name = "月饼"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/eggyolk = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/mooncake
	category = CAT_CHINESE

/datum/crafting_recipe/food/baozi
	name = "包子"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/baozi
	category = CAT_CHINESE

/datum/crafting_recipe/food/roujiamo
	name = "肉夹馍"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/patty/plain = 1
	)
	result = /obj/item/food/roujiamo
	category = CAT_CHINESE

/datum/crafting_recipe/food/wolf_tooth_potato
	name = "狼牙土豆"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/grown/chili = 1
	)
	result = /obj/item/food/wolf_tooth_potato
	category = CAT_CHINESE

/datum/crafting_recipe/food/youtiao
	name = "油条"
	reqs = list(
		/obj/item/food/doughslice = 1
	)
	result = /obj/item/food/youtiao
	category = CAT_CHINESE

/datum/crafting_recipe/food/stinky_tofu
	name = "臭豆腐串"
	reqs = list(
		/obj/item/food/tofu = 1,
		/obj/item/food/grown/chili = 1
	)
	result = /obj/item/food/stinky_tofu
	category = CAT_CHINESE
