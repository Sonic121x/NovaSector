/datum/bounty/item/chef/birthday_cake
	name = "生日蛋糕"
	description = "纳米传讯的生日快到了！给中央指挥部运送一个生日蛋糕来庆祝吧！"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(
		/obj/item/food/cake/birthday = TRUE,
		/obj/item/food/cakeslice/birthday = TRUE
	)

/datum/bounty/reagent/chef/soup
	name = "汤"
	description = "为了平息无家可归者的起义，纳米传讯将为所有低薪工人提供汤品。"

/datum/bounty/reagent/chef/soup/New()
	. = ..()
	required_volume = pick(10, 15, 20, 25)
	wanted_reagent = pick(subtypesof(/datum/reagent/consumable/nutriment/soup))
	reward = CARGO_CRATE_VALUE * round(required_volume / 3)
	// In the future there could be tiers of soup bounty corresponding to soup difficulty
	// (IE, stew is harder to make than tomato soup, so it should reward more)
	description += " Send us [required_volume] units of [initial(wanted_reagent.name)]."

/datum/bounty/item/chef/popcorn
	name = "爆米花袋"
	description = "高层管理人员想举办一个电影之夜。为此运送一些袋装爆米花过来。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/popcorn = TRUE)

/datum/bounty/item/chef/onionrings
	name = "洋葱圈"
	description = "纳米传讯正在纪念土星日。运送洋葱圈以示空间站的支持。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/onionrings = TRUE)

/datum/bounty/item/chef/icecreamsandwich
	name = "冰淇淋三明治"
	description = "高层管理人员一直在不停地尖叫着要冰淇淋三明治。请送一些过来。"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 3
	wanted_types = list(/obj/item/food/icecreamsandwich = TRUE)

/datum/bounty/item/chef/strawberryicecreamsandwich
	name = "草莓冰淇淋三明治"
	description = "高层管理人员一直在不停地尖叫着要更多口味的冰淇淋三明治。请送一些过来。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(/obj/item/food/strawberryicecreamsandwich = TRUE)

/datum/bounty/item/chef/bread
	name = "面包"
	description = "中央计划出了问题，导致面包价格飞涨。运送一些面包来缓解紧张局势。"
	reward = CARGO_CRATE_VALUE * 2
	wanted_types = list(
		/obj/item/food/bread = TRUE,
		/obj/item/food/breadslice = TRUE,
		/obj/item/food/bun = TRUE,
		/obj/item/food/pizzabread = TRUE,
		/obj/item/food/rawpastrybase = TRUE,
	)

/datum/bounty/item/chef/pie
	name = "馅饼"
	description = "3.14159？不！中央司令部管理层想要能吃的派！运送一个完整的过来。"
	reward = 3142 //Screw it I'll do this one by hand
	wanted_types = list(/obj/item/food/pie = TRUE)

/datum/bounty/item/chef/salad
	name = "沙拉或米饭碗"
	description = "中央司令部管理层正在推行健康饮食。你的任务是运送沙拉或米饭碗。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/salad = TRUE)

/datum/bounty/item/chef/carrotfries
	name = "胡萝卜油炸条"
	description = "夜视能力可能意味着生与死！订单是运送一批胡萝卜薯条。"
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/carrotfries = TRUE)

/datum/bounty/item/chef/superbite
	name = "巨亨堡"
	description = "塔布斯指挥官认为他可以创造一项竞技饮食世界纪录。他只需要一个超级一口汉堡运送给他。"
	reward = CARGO_CRATE_VALUE * 24
	wanted_types = list(/obj/item/food/burger/superbite = TRUE)

/datum/bounty/item/chef/poppypretzel
	name = "罂粟椒盐卷饼"
	description = "中央司令部需要一个理由解雇他们的人力资源主管。送一个罂粟椒盐卷饼过来，好让他药检失败。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/food/poppypretzel = TRUE)

/datum/bounty/item/chef/cubancarp
	name = "古巴鲤鱼"
	description = "为了庆祝卡斯特罗二十七世的诞生，运送一条古巴鲤鱼到中央司令部。"
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/cubancarp = TRUE)

/datum/bounty/item/chef/hotdog
	name = "热狗"
	description = "纳米传讯正在进行口味测试，以确定最佳热狗配方。运送你空间站的版本以参与评选。"
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/hotdog = TRUE)

/datum/bounty/item/chef/eggplantparm
	name = "撒有帕玛森奶酪的茄子"
	description = "一位著名歌手将抵达中央司令部，他们的合同要求只供应茄子帕尔马干酪。请运送一些过来！"
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/eggplantparm = TRUE)

/datum/bounty/item/chef/muffin
	name = "玛芬蛋糕"
	description = "松饼人正在访问中央司令部，但他忘记带他的松饼了！你的任务是纠正这一点。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/muffin = TRUE)

/datum/bounty/item/chef/chawanmushi
	name = "日式蒸蛋"
	description = "纳米传讯希望改善与其姊妹公司Japanotrasen的关系。立即运送茶碗蒸。"
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/chawanmushi = TRUE)

/datum/bounty/item/chef/kebab
	name = "烤肉串"
	description = "把空间站上所有的烤肉串都弄走，你们是最好的食物。运到中央司令部以将其移出此地。"
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/kebab = TRUE)

/datum/bounty/item/chef/soylentgreen
	name = "Soylent green-绿色食品"
	description = "中央司令部听说了关于产品'索伦绿'的美妙传闻，很想尝尝。如果你能满足他们，预计会有不错的奖励。"
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(/obj/item/food/soylentgreen = TRUE)

/datum/bounty/item/chef/pancakes
	name = "煎饼"
	description = "在纳米传讯，我们把员工视为家人。你知道家人喜欢什么吗？煎饼。运送一打（13个）。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 13
	wanted_types = list(/obj/item/food/pancakes = TRUE)

/datum/bounty/item/chef/nuggies
	name = "鸡块"
	description = "副总裁的儿子不停地念叨鸡块。你能运送一些过来吗？"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 6
	wanted_types = list(/obj/item/food/nugget = TRUE)

/datum/bounty/item/chef/corgifarming //Butchering is a chef's job.
	name = "柯基毛皮"
	description = "温斯坦上将的太空游艇需要新的内饰。一打柯基毛皮应该正好。"
	reward = CARGO_CRATE_VALUE * 60 //that's a lot of dead dogs
	required_count = 12
	wanted_types = list(/obj/item/stack/sheet/animalhide/corgi = TRUE)

/datum/bounty/item/chef/pickles
	name = "柯基毛皮"
	description = "食品控制部门没有足够的腌黄瓜来恰当地评估某些不同类型的烈酒。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 7
	wanted_types = list(/obj/item/food/pickle = TRUE)
