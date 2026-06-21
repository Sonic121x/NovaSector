/datum/market_item/misc
	category = "Miscellaneous"
	abstract_path = /datum/market_item/misc

/datum/market_item/misc/clear_pda
	name = "透明版PDA"
	desc = "一款限量版透明PDA，展现出你的风格！"
	item = /obj/item/modular_computer/pda/clear

	price_min = CARGO_CRATE_VALUE * 1.25
	price_max = CARGO_CRATE_VALUE *3
	stock_max = 2
	availability_prob = 50

/datum/market_item/misc/jade_lantern
	name = "玉提灯"
	desc = "在一个标着“警告:放射性”的盒子里发现的。"
	item = /obj/item/flashlight/lantern/jade

	price_min = CARGO_CRATE_VALUE * 0.75
	price_max = CARGO_CRATE_VALUE * 2.5
	stock_max = 2
	availability_prob = 45

/datum/market_item/misc/cap_gun
	name = "软弹枪"
	desc = "用这把无害的枪捉弄你的朋友吧！保证无害。"
	item = /obj/item/toy/gun

	price_min = CARGO_CRATE_VALUE * 0.25
	price_max = CARGO_CRATE_VALUE
	stock_max = 6
	availability_prob = 80

/datum/market_item/misc/shoulder_holster
	name = "肩部枪套"
	desc = "耶哈，硬汉朋友们！这个枪套是你实现成为侦探梦想并被允许使用真枪的第一步！"
	item = /obj/item/storage/belt/holster

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	stock_max = 8
	availability_prob = 60

/datum/market_item/misc/donk_recycler
	name = "MOD防暴泡沫飞镖回收模块"
	desc = "如果你喜欢玩具枪、讨厌打扫并且有一件MOD防护服，这个模块是必备品。"
	item = /obj/item/mod/module/recycler/donk
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4.5
	stock_max = 2
	availability_prob = 30

/datum/market_item/misc/atrocinator
	name = "MOD反重力模块"
	desc = "我们在一条维护隧道里发现了这个模块，它被放在几个警告锥和危险标志后面，没有标签。它大概是安全的。"
	item = /obj/item/mod/module/atrocinator
	price_min = CARGO_CRATE_VALUE * 4
	price_max = CARGO_CRATE_VALUE * 7
	stock_max = 1
	availability_prob = 22

/datum/market_item/misc/tanner
	name = "MOD美黑模块"
	desc = "曾想过既在海滩又在工作吗？现在有了这个时髦的美黑模块，你就可以做到了！"
	item = /obj/item/mod/module/tanner
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	stock_max = 2
	availability_prob = 30

/datum/market_item/misc/hat_stabilizer
	name = "MOD帽子稳定器模块"
	desc = "有了这个模块，不必为了实用性牺牲风格！帽子不包含在内。"
	item = /obj/item/mod/module/hat_stabilizer
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	stock_max = 2
	availability_prob = 35

/datum/market_item/misc/shove_blocker
	name = "MOD壁垒模块"
	desc = "你根本不知道我们花了多大力气才在上个班次从那该死的防护MOD服里拆出这个模块。"
	item = /obj/item/mod/module/shove_blocker
	price_min = CARGO_CRATE_VALUE * 4
	price_max = CARGO_CRATE_VALUE * 5.75
	stock_max = 1
	availability_prob = 25

/datum/market_item/misc/holywater
	name = "一瓶圣水"
	desc = "卢修斯神父自己制作的现成圣水。"
	item = /obj/item/reagent_containers/cup/glass/bottle/holywater

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	stock_max = 3
	availability_prob = 40

/datum/market_item/misc/holywater/spawn_item(loc, datum/market_purchase/purchase)
	if (prob(6.66))
		item = /obj/item/reagent_containers/cup/beaker/unholywater
	else
		item = initial(item)
	return ..()

/datum/market_item/misc/strange_seed
	name = "奇怪的种子"
	desc = "一包奇怪的种子，可能包含了从荧光植物到酸性植物。"
	item = /obj/item/seeds/random

	price_min = CARGO_CRATE_VALUE * 1.6
	price_max = CARGO_CRATE_VALUE * 1.8
	stock_min = 2
	stock_max = 5
	availability_prob = 50

/datum/market_item/misc/smugglers_satchel
	name = "走私者挎包"
	desc = "这个易于隐藏的挎包可以成为任何希望将特定物品置于视线和思维之外的人的通用工具。其内容物无法被违禁品扫描仪检测到。"
	item = /obj/item/storage/backpack/satchel/flat/empty

	price_min = CARGO_CRATE_VALUE * 3.75
	price_max = CARGO_CRATE_VALUE * 5
	stock_max = 2
	availability_prob = 30

/datum/market_item/misc/roulette
	name = "轮盘信标"
	desc = "无论走到哪里，都可以开启你自己的地下赌场。仅限单次使用。概不退款。"
	item = /obj/item/roulette_wheel_beacon
	price_min = CARGO_CRATE_VALUE * 1
	price_max = CARGO_CRATE_VALUE * 2.5
	stock_max = 3
	availability_prob = 50

/datum/market_item/misc/jawed_hook
	name = "带颚鱼钩"
	desc = "如果你在跟鱼较劲，就用这玩意儿。只要记得在太晚之前猛拉你的鱼竿，因为这玩意儿会像阿肯色牙签一样伤到它们。"
	item = /obj/item/fishing_hook/jaws
	price_min = CARGO_CRATE_VALUE * 0.75
	price_max = CARGO_CRATE_VALUE * 2
	stock_max = 3
	availability_prob = 70

/datum/market_item/misc/v8_engine
	name = "正宗V8发动机（保存版）"
	desc = "嘿，机械工们，准备好启动引擎了吗？想在走廊里飙车，在星际高速公路上做出更急的转弯吗？那你需要这台经典引擎。"
	item = /obj/item/v8_engine
	price_min = CARGO_CRATE_VALUE * 4
	price_max = CARGO_CRATE_VALUE * 6
	stock_max = 1
	availability_prob = 15

/datum/market_item/misc/fishing_capsule
	name = "钓鱼点胶囊"
	//IUU stands for Illegal Unreported and Unregulated fishing. Ironic.
	desc = "一个经过改造的采矿胶囊，连接着一系列专属钓鱼点。已获星际IUU钓鱼协会批准。"
	price_min = CARGO_CRATE_VALUE * 1.125
	price_max = CARGO_CRATE_VALUE * 2.125
	item = /obj/item/survivalcapsule/fishing
	stock_min = 1
	stock_max = 4
	availability_prob = 80

/datum/market_item/misc/fish
	name = "鱼"
	desc = "鱼！新鲜的鱼！你可以切、可以磨，甚至想的话还能养在水族箱里的鱼！趁我村里下一场斗殴爆发前赶紧来点吧！"
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 1.2
	item = /obj/item/storage/fish_case/blackmarket
	stock_min = 3
	stock_max = 8
	availability_prob = 90

/datum/market_item/misc/girlypop
	name = "少女流行海报"
	desc = "一系列可爱迷人的海报。女孩力量！"
	price_min = PAYCHECK_CREW * 2
	price_max = PAYCHECK_CREW * 5
	item = /obj/item/poster/contraband/heart // gives it the rolled poster icon in the menu
	stock_min = 1
	stock_max = 3
	availability_prob = 90

/datum/market_item/misc/girlypop/spawn_item(loc, datum/market_purchase/purchase)
	. = ..()
	var/obj/structure/closet/crate/glitter/C = new(loc)
	for (var/type in list(
		/obj/item/poster/contraband/dream,
		/obj/item/poster/contraband/beekind,
		/obj/item/poster/contraband/heart,
		/obj/item/poster/contraband/dolphin,
		/obj/item/poster/contraband/principles,
		/obj/item/poster/contraband/trigger,
		/obj/item/poster/contraband/barbaro,
		/obj/item/poster/contraband/seabiscuit,
		/obj/item/poster/contraband/pharlap,
		/obj/item/poster/contraband/waradmiral,
		/obj/item/poster/contraband/silver,
		/obj/item/poster/contraband/jovial,
		/obj/item/poster/contraband/bojack,
	))
		new type(C)
	return C

/datum/market_item/misc/self_surgery_skillchip
	name = /obj/item/skillchip/self_surgery::name
	desc = "Man, the insurance companies HATE this one. Damn fat-cats can't stand the idea of people treating their own illnesses - \
	they'd rather you go to THEIR doctors, who THEY convinced to charge EXTORTIONARY prices the average Joe can't afford, all so you \
	gotta sign on to THEIR packages. Most people end up paying for NOTHING for YEARS just so that they have a CHANCE at being able to afford \
	treatment when they actually NEED it. \n\n Uh, what was I talking about again... Oh, yeah. This here skillchip'll let you put yourself under the knife. \
	A must-have for the person who can't rely on anyone else."
	item = /obj/item/skillchip/self_surgery
	price_min = CARGO_CRATE_VALUE * 5
	price_max = CARGO_CRATE_VALUE * 10
	stock_max = 1
	availability_prob = 15

/datum/market_item/misc/self_surgery_skillchip/buy(obj/item/market_uplink/uplink, mob/buyer, shipping_method, legal_status)
	. = ..()
	if(.)
		availability_prob *= 0.5

/datum/market_item/misc/tricktrickcigarettes
	name = "戏法戏法香烟"
	desc = "装满闪光粉的香烟。用来搞恶作剧很有趣！"
	item = /obj/item/storage/fancy/cigarettes/flash_powder
	price_min = PAYCHECK_CREW
	price_max = PAYCHECK_CREW * 3
	stock_max = 3
	availability_prob = 25
