/datum/market_item/consumable
	category = "Consumables"
	abstract_path = /datum/market_item/consumable

/datum/market_item/consumable/clown_tears
	name = "小丑眼泪瓶"
	desc = "保证新鲜，来自哭泣的博金斯悲剧厨房"
	item = /obj/item/reagent_containers/cup/bottle/clownstears
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2.6
	price_max = CARGO_CRATE_VALUE * 3
	availability_prob = 10

/datum/market_item/consumable/donk_pocket_box
	name = "一盒口袋饼"
	desc = "一个包装精美的盒子，里面装着每个宇航员最喜欢的零食。"
	item = /obj/item/storage/box/donkpockets

	stock_min = 2
	stock_max = 5
	price_min = CARGO_CRATE_VALUE * 1.375
	price_max = CARGO_CRATE_VALUE * 1.825
	availability_prob = 80

/datum/market_item/consumable/donk_pocket_box/spawn_item(loc)
	var/static/list/choices
	if(isnull(choices))
		choices = list()
		for(var/boxtype in typesof(/obj/item/storage/box/donkpockets))
			choices[boxtype] = 3
		choices[/obj/item/storage/box/donkpockets/donkpocketgondola] = 1
	item = pick_weight(choices)
	return ..()

/datum/market_item/consumable/suspicious_pills
	name = "一瓶可疑的药丸"
	desc = "包含了随机的鸡尾酒混合药物，保证让你脸上绽放笑容。"
	item = /obj/item/storage/pill_bottle

	stock_min = 2
	stock_max = 3
	price_min = CARGO_CRATE_VALUE * 0.625
	price_max = CARGO_CRATE_VALUE * 1.25
	availability_prob = 50

/datum/market_item/consumable/suspicious_pills/spawn_item(loc)
	item = pick(list(/obj/item/storage/pill_bottle/zoom,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/lsd,
		/obj/item/storage/pill_bottle/aranesp,
		/obj/item/storage/pill_bottle/stimulant,
		/obj/item/storage/pill_bottle/maintenance_pill,
	))
	return ..()

/datum/market_item/consumable/floor_pill
	name = "奇怪的药丸"
	desc = "从维护管道找到的俄罗斯转盘药片."
	item = /obj/item/reagent_containers/applicator/pill/maintenance

	stock_min = 5
	stock_max = 35
	price_min = CARGO_CRATE_VALUE * 0.05
	price_max = CARGO_CRATE_VALUE * 0.3
	availability_prob = 50

/datum/market_item/consumable/pumpup
	name = "维修兴奋剂"
	desc = "这个便捷注射器能让你不惧电棍的眩晕！"
	item = /obj/item/reagent_containers/hypospray/medipen/pumpup

	stock_max = 3
	price_min = CARGO_CRATE_VALUE * 0.25
	price_max = CARGO_CRATE_VALUE * 0.75
	availability_prob = 90

/datum/market_item/consumable/methshipment
	name = "批发甲基苯丙胺货件"
	desc = "经销商数量！别在自己的货上嗨过头。或者嗨也行。反正你已经买了。"
	item = /obj/item/storage/box/methdealer

	stock_min = 1
	stock_max = 3
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 1.5
	availability_prob = 25

/datum/market_item/consumable/opiumshipment
	name = "批发鸦片货件"
	desc = "你的同事压力大吗？我们有大宗恶习品供应。"
	item = /obj/item/storage/box/opiumdealer

	stock_min = 1
	stock_max = 3
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 1.2
	availability_prob = 35

/datum/market_item/consumable/kronkshipment
	name = "批发克罗可因货件"
	desc = "警告！安保部门这次可能真的会管！"
	item = /obj/item/storage/box/kronkdealer

	stock_min = 1
	stock_max = 3
	price_min = CARGO_CRATE_VALUE * 1
	price_max = CARGO_CRATE_VALUE * 2
	availability_prob = 15

/datum/market_item/consumable/methaphetamine
	name = "水晶冰毒"
	desc = "一大块，当你急需来一口的时候用。"
	item = /obj/item/food/drug/meth_crystal

	stock_min = 1
	stock_max = 5
	price_min = CARGO_CRATE_VALUE * 0.4
	price_max = CARGO_CRATE_VALUE * 0.5
	availability_prob = 35

/datum/market_item/consumable/heroin
	name = "海洛因"
	desc = "追龙。"
	item = /obj/item/food/drug/opium

	stock_min = 1
	stock_max = 5
	price_min = CARGO_CRATE_VALUE * 0.35
	price_max = CARGO_CRATE_VALUE * 0.5
	availability_prob = 45

/datum/market_item/consumable/kronkaine
	name = "克罗可因"
	desc = "一个8⁸球，这玩意儿在市场上可不多见！"
	item = /obj/item/food/drug/moon_rock

	stock_min = 1
	stock_max = 2
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 1
	availability_prob = 15
