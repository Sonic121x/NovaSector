// This file contains a WHOLE BUNCH of cost defuckulations to bring the ancient black market stuff back into line with our current cargo pricing.
// I've also taken the liberty of redoing a few descs because man they kinda suck.
// Some availability_probs have been upped considerably for items that I think should be core to the "dodgy" character archetype, like switchblades, science goggles and the various maintenance pills.

// CLOTHING

/datum/market_item/clothing/ninja_mask
	price_min = PAYCHECK_CREW
	price_max = PAYCHECK_CREW * 3

/datum/market_item/clothing/durathread_vest
	desc = "关于高石棉含量的担忧完全没有根据。注意：可能含有石棉。"
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 1.5

/datum/market_item/clothing/durathread_helmet
	desc = "闻起来隐约有冰行者的味道。奇怪。戴在头上，并且勉强算有护甲。注意：可能含有石棉。"
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 1.5

/datum/market_item/clothing/full_spacesuit_set
	desc = "三十年前已退役，这些古老的太空防护遗物成箱地不断出现在某处的仓库里。它们是“旧式”的。"
	price_min = PAYCHECK_CREW * 6
	price_max = PAYCHECK_CREW * 12

/datum/market_item/clothing/chameleon_hat
	desc = "模拟星域内任何帽子的外观！警告：设备未经质量测试。\[REDACTED\]对设备故障或致命伤害不承担任何风险。"
	price_min = PAYCHECK_CREW
	price_max = PAYCHECK_CREW * 3

/datum/market_item/clothing/rocket_boots
	price_min = PAYCHECK_CREW * 6
	price_max = PAYCHECK_CREW * 12

/datum/market_item/clothing/anti_sec_pin
	price_min = PAYCHECK_CREW
	price_max = PAYCHECK_CREW * 3
	availability_prob = 100 //it's funny so why not

// CONSUMABLES
/datum/market_item/consumable/clown_tears
	desc = "由你本地的小丑从符合伦理来源的小丑身上强行拧出。100%保证不含警棍。"
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 1.5

/datum/market_item/consumable/donk_pocket_box
	price_min = PAYCHECK_CREW * 0.3
	price_max = PAYCHECK_CREW * 1
	availability_prob = 100 //you can always afford some (illegal) donkpockets. Donk Co loves you.

/datum/market_item/consumable/suspicious_pills
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 1.5

/datum/market_item/consumable/floor_pill
	desc = "由获得合理报酬的助手每日采集，此药片保证：a) 曾在地板上，且 b) 是一片药片。祝你好运！"
	price_min = PAYCHECK_CREW * 0.1
	price_max = PAYCHECK_CREW * 0.3
	availability_prob = 100 // no shortage of unmarked pills babyyyy

/datum/market_item/consumable/pumpup
	desc = "清洁队每次轮班后都会成打地卖掉这些东西——今天就弄一些吧！维护区的药物能出什么问题呢？"
	price_min = PAYCHECK_CREW * 0.2
	price_max = PAYCHECK_CREW * 0.4

// MISCELLANEOUS

/datum/market_item/misc/clear_pda
	desc = "用这款限量版透明PDA，清晰地展示你对时尚的欣赏吧！"
	price_min = PAYCHECK_CREW
	price_max = PAYCHECK_CREW * 2

/datum/market_item/misc/jade_lantern
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW

/datum/market_item/misc/cap_gun
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW

/datum/market_item/misc/shoulder_holster
	name = "肩部枪套"
	//why in great googly moogly were these so expensive? what the fuck?
	price_min = PAYCHECK_CREW * 0.2
	price_max = PAYCHECK_CREW * 0.6

/datum/market_item/misc/donk_recycler
	price_min = PAYCHECK_CREW * 2
	price_max = PAYCHECK_CREW * 4

/datum/market_item/misc/shove_blocker
	// ok this is a seriously fucking good module so we'll make it cost a bit
	price_min = PAYCHECK_CREW * 8
	price_max = PAYCHECK_CREW * 14

/datum/market_item/misc/voskhod_refit
	name = "Voskhod改装套件"
	desc = "一个免除了运输、仓储、医疗、安保等多项费用的零配件箱，可用于将您那套古老的钢板太空服升级为不那么古老的模块化太空服。"
	item = /obj/item/crafting_conversion_kit/voskhod_refit
	price_min = CARGO_CRATE_VALUE * 4
	price_max = CARGO_CRATE_VALUE * 5.75
	stock_max = 3
	availability_prob = 25

/datum/market_item/misc/holywater
	desc = "旋向独立魔法师协会对此魔法试剂的神圣性（或非神圣性）概不负责。"
	price_min = PAYCHECK_CREW
	price_max = PAYCHECK_CREW * 3

/datum/market_item/misc/strange_seed
	desc = "在包括本扇区在内的大多数扇区都被禁止的奇异种子品种。最坏能发生什么呢？"
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW

/datum/market_item/misc/smugglers_satchel
	//inventory gamers...
	price_min = PAYCHECK_CREW * 3
	price_max = PAYCHECK_CREW * 6

/datum/market_item/misc/roulette
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 6 // it's how the chips fall babyyy

/datum/market_item/misc/jawed_hook
	desc = "如果你搞不定那些鱼，就给它们点颜色看看，懂吗？"
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 1.5

/datum/market_item/misc/v8_engine
	name = "正宗V8引擎（保存完好）"
	price_min = PAYCHECK_CREW * 6
	price_max = PAYCHECK_CREW * 12

/datum/market_item/misc/fish
	name = "一箱走私鱼"
	desc = "是什么让这些鱼成了抢手货？告诉你的话我们就得灭口了。"

// TOOLS
/datum/market_item/tool/caravan_wrench
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 2
	availability_prob = 100 // let's have all the experimental tools be always available, because why not?

/datum/market_item/tool/caravan_wirecutters
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 2
	availability_prob = 100

/datum/market_item/tool/caravan_screwdriver
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 2
	availability_prob = 100

/datum/market_item/tool/caravan_crowbar
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 2
	availability_prob = 100

/datum/market_item/tool/binoculars
	//we can roundstart with these so let's tone them way down
	desc = "来自外星球的军事剩余物资。他们永远也发现不了你的接近。"
	price_min = PAYCHECK_CREW * 0.2
	price_max = PAYCHECK_CREW * 0.5

/datum/market_item/tool/riot_shield
	desc = "血迹不包括在内。"
	price_min = PAYCHECK_CREW * 4
	price_max = PAYCHECK_CREW * 8

/datum/market_item/tool/thermite_bottle
	desc = "五十个星系单位的燃烧剂，几乎能烧穿任何东西。"
	price_min = PAYCHECK_CREW * 2
	price_max = PAYCHECK_CREW * 6

/datum/market_item/tool/program_disk
	name = "盗版PDA数据磁盘"
	desc = "包含由比特跑者从FTU窃取的一系列随机限量版PDA程序。等等，我们不该告诉你这个。"
	price_min = PAYCHECK_CREW * 1.5
	price_max = PAYCHECK_CREW * 3
	availability_prob = 100 // not every program is useful but some of these are and they're fun and hackery, so why not?

// WEAPONS

/datum/market_item/weapon/bear_trap
	price_min = PAYCHECK_CREW * 2
	price_max = PAYCHECK_CREW * 4

/datum/market_item/weapon/shotgun_dart
	price_min = PAYCHECK_CREW * 0.1
	price_max = PAYCHECK_CREW * 0.3

/datum/market_item/weapon/bone_spear
	price_min = PAYCHECK_CREW * 0.5
	price_max = PAYCHECK_CREW * 2

/datum/market_item/weapon/chainsaw
	desc = "曾经用于盖亚星球上砍伐树木的普通链锯，如今已成为本扇区首屈一指的抗霉菌设备。现在只需轻松付款一次，你就能拥有一个！"
	price_min = PAYCHECK_CREW * 2
	price_max = PAYCHECK_CREW * 4
	availability_prob = 75 // USE CHAINSAWS FOR MOLDS MORE OH MY GOD

/datum/market_item/weapon/switchblade
	// This is force 20 like the sabre/shamshir so price it similarly. Also, make it always available so you can shank people in maints.
	desc = "全扇区可疑打手们的标准配置装备。又尖又利。"
	price_min = PAYCHECK_CREW * 4.25
	price_max = PAYCHECK_CREW * 8
	availability_prob = 100

/datum/market_item/weapon/emp_grenade
	desc = "合成人与空间站工程师们无处不在的克星。"
	price_min = PAYCHECK_CREW * 1.5
	price_max = PAYCHECK_CREW * 5

/datum/market_item/weapon/fisher
	price_min = PAYCHECK_CREW * 4
	price_max = PAYCHECK_CREW * 8

/datum/market_item/weapon/giant_wrench_parts
	name = "滑稽巨型扳手零件"
	desc = "他们正在搜查每一条宽带传输信号寻找这把扳手的名字，明白吗？你要是把这玩意儿组装起来就是疯了。我们告诉你，你疯了。"
	price_min = PAYCHECK_CREW * 4
	price_max = PAYCHECK_CREW * 8

