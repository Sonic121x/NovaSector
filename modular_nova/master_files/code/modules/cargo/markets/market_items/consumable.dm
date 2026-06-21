/datum/market_item/consumable/syndie_smokes
	name = "辛迪加香烟"
	desc = "味道浓烈，烟雾浓密，注入了全治宁。"
	item = /obj/item/storage/fancy/cigarettes/cigpack_syndicate
	stock_min = 2
	stock_max = 5
	price_min = CARGO_CRATE_VALUE * 0.25
	price_max = CARGO_CRATE_VALUE * 0.5
	availability_prob = 85

/datum/market_item/consumable/stimpack
	name = "兴奋剂医疗笔"
	desc = "一支快速起效兴奋剂的医疗笔。可能是某个倒霉特工被销赃的装备。"
	item = /obj/item/reagent_containers/hypospray/medipen/stimulants
	stock_max = 1
	price_min = CARGO_CRATE_VALUE * 5
	price_max = CARGO_CRATE_VALUE * 7
	availability_prob = 25

/datum/market_item/consumable/twitch
	name = "抽搐感官兴奋剂注射器"
	desc = "高度非法的感官兴奋剂。这支可能已经过期，也可能没有。"
	item = /obj/item/reagent_containers/hypospray/medipen/deforest/twitch
	stock_max = 1
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	availability_prob = 25

/datum/market_item/consumable/combat_baking
	name = "《无政府主义者烹饪书》"
	desc = "一本广泛非法的食谱书，将教你如何烘焙令人垂死的牛角包。"
	item = /obj/item/book/granter/crafting_recipe/combat_baking
	stock_max = 1
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	availability_prob = 35

/datum/market_item/consumable/pipegun_reciept
	name = "《已故助手日记》"
	desc = "一本从维护区清洁队偷运出来的积尘书籍。卖家备注：极其脆弱。"
	item = /obj/item/book/granter/crafting_recipe/dusting/pipegun_prime
	stock_max = 1
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	availability_prob = 5

/datum/market_item/consumable/trash_cannon
	name = "《被降职工程师日记》"
	desc = "一本从维护区清洁队偷运出来的积尘书籍。卖家备注：散发着油味，还有点滑。可能很适合当引火物。"
	item = /obj/item/book/granter/crafting_recipe/trash_cannon
	stock_max = 1
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	availability_prob = 5

/datum/market_item/consumable/cooking_sweets_101
	name = "《甜点烹饪101》"
	desc = "一本教你更多最新甜点的烹饪书。AI认可，且在Honkplanet上是畅销书。"
	item = /obj/item/book/granter/crafting_recipe/cooking_sweets_101
	stock_max = 50
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 5
	availability_prob = 40

/datum/market_item/consumable/overclock_neuroware
	name = "自制超频神经组件"
	desc = "一个被黑客入侵的神经组件芯片，内含某人自制的神经计算程序。这个程序模拟了肾上腺素的效果。"
	item = /obj/item/disk/neuroware/pumpup
	stock_max = 3
	price_min = PAYCHECK_CREW * 0.2
	price_max = PAYCHECK_CREW * 0.4
	availability_prob = 90

/datum/market_item/consumable/maintenance_neuroware
	name = "未标记神经组件"
	desc = "在维护区深处发现的一块奇怪的神经芯片。"
	item = /obj/item/disk/neuroware/maintenance
	stock_min = 5
	stock_max = 35
	price_min = CARGO_CRATE_VALUE * 0.05
	price_max = CARGO_CRATE_VALUE * 0.3
	availability_prob = 50
