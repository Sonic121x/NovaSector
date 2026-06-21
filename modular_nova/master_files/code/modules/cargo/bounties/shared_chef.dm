/datum/bounty/item/shared_chef/birthday_cake
	name = "生日蛋糕"
	description = "生日快到了！给我们运送一个生日蛋糕来庆祝吧！"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(
		/obj/item/food/cake/birthday = TRUE,
		/obj/item/food/cakeslice/birthday = TRUE
	)

/datum/bounty/reagent/shared_chef/soup
	name = "汤"
	description = "为了平息无家可归者的起义，纳米传讯将为所有低薪工人提供汤品。"

/datum/bounty/reagent/shared_chef/soup/New()
	. = ..()
	required_volume = pick(10, 15, 20, 25)
	wanted_reagent = pick(subtypesof(/datum/reagent/consumable/nutriment/soup))
	reward = CARGO_CRATE_VALUE * round(required_volume / 3)
	// In the future there could be tiers of soup bounty corresponding to soup difficulty
	// (IE, stew is harder to make than tomato soup, so it should reward more)
	description += " Send us [required_volume] units of [initial(wanted_reagent.name)]."

/datum/bounty/item/shared_chef/popcorn
	name = "爆米花袋"
	description = "高层管理人员想举办一个电影之夜。为此运送一些爆米花袋。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/popcorn = TRUE)

/datum/bounty/item/shared_chef/onionrings
	name = "洋葱圈"
	description = "总部正在纪念土星日。运送洋葱圈以示空间站的支持。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/onionrings = TRUE)

/datum/bounty/item/shared_chef/icecreamsandwich
	name = "冰淇淋三明治"
	description = "高层管理人员一直在不停地尖叫着要冰淇淋三明治。请送一些过来。"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 3
	wanted_types = list(/obj/item/food/icecreamsandwich = TRUE)

/datum/bounty/item/shared_chef/strawberryicecreamsandwich
	name = "草莓冰淇淋三明治"
	description = "高层管理人员一直在不停地尖叫着要口味更丰富的冰淇淋三明治。请送一些过来。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(/obj/item/food/strawberryicecreamsandwich = TRUE)

/datum/bounty/item/shared_chef/bread
	name = "面包"
	description = "计划问题导致面包价格飞涨。运送一些面包来缓解紧张局势。"
	reward = CARGO_CRATE_VALUE * 2
	wanted_types = list(
		/obj/item/food/bread = TRUE,
		/obj/item/food/breadslice = TRUE,
		/obj/item/food/bun = TRUE,
		/obj/item/food/pizzabread = TRUE,
		/obj/item/food/rawpastrybase = TRUE,
	)

/datum/bounty/item/shared_chef/pie
	name = "馅饼"
	description = "总部想要一个美味的派，别耍小聪明送个数学派，送个真正能吃的。运送一个完整的。"
	reward = 3142 //Screw it I'll do this one by hand
	wanted_types = list(/obj/item/food/pie = TRUE)

/datum/bounty/item/shared_chef/salad
	name = "沙拉或米饭碗"
	description = "高层管理正在搞健康狂热。你的命令是运送沙拉或米饭碗。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/salad = TRUE)

/datum/bounty/item/shared_chef/carrotfries
	name = "胡萝卜薯条"
	description = "夜视能力可能意味着生死！订单是一批胡萝卜薯条。"
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/carrotfries = TRUE)

/datum/bounty/item/shared_chef/superbite
	name = "超级一口堡"
	description = "有个白痴认为他能创下竞技饮食世界纪录。他只需要一个超级一口堡运过去。"
	reward = CARGO_CRATE_VALUE * 24
	wanted_types = list(/obj/item/food/burger/superbite = TRUE)

/datum/bounty/item/shared_chef/poppypretzel
	name = "罂粟椒盐卷饼"
	description = "上级指挥部需要个理由解雇他们的人力资源主管。送个罂粟椒盐卷饼过去，好让他药检失败。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/food/poppypretzel = TRUE)

/datum/bounty/item/shared_chef/cubancarp
	name = "古巴鲤鱼"
	description = "为了庆祝我们一位高层指挥人员的诞生，运送一条古巴鲤鱼给我们。"
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/cubancarp = TRUE)

/datum/bounty/item/shared_chef/hotdog
	name = "热狗"
	description = "指挥部正在进行口味测试以确定最佳热狗配方。运送你们空间站的版本参与。"
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/hotdog = TRUE)

/datum/bounty/item/shared_chef/eggplantparm
	name = "茄子帕尔马干酪"
	description = "一位著名歌手将抵达总部，他们的合同要求只供应茄子帕尔马干酪。请运送一些！"
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/eggplantparm = TRUE)

/datum/bounty/item/shared_chef/muffin
	name = "松饼"
	description = "松饼人正在访问总部，但他忘了带他的松饼！你的命令是纠正这一点。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 3
	wanted_types = list(/obj/item/food/muffin = TRUE)

/datum/bounty/item/shared_chef/chawanmushi
	name = "茶碗蒸"
	description = "总部希望改善与其姊妹公司的关系。立即运送茶碗蒸。"
	reward = CARGO_CRATE_VALUE * 16
	wanted_types = list(/obj/item/food/chawanmushi = TRUE)

/datum/bounty/item/shared_chef/kebab
	name = "烤肉串"
	description = "移除所有烤肉串，你们空间站的食物最棒。运送到总部以将其移出场所。"
	reward = CARGO_CRATE_VALUE * 7
	required_count = 3
	wanted_types = list(/obj/item/food/kebab = TRUE)

/datum/bounty/item/shared_chef/soylentgreen
	name = "绿色索伦特"
	description = "总部听说了产品'绿色索伦特'的美妙之处，很想尝尝。如果你满足他们，期待一份愉快的奖金。"
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(/obj/item/food/soylentgreen = TRUE)

/datum/bounty/item/shared_chef/pancakes
	name = "煎饼"
	description = "在总部这里，我们把员工视为家人。你知道家人喜欢什么吗？煎饼。运送一打过来吧。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 13
	wanted_types = list(/obj/item/food/pancakes = TRUE)

/datum/bounty/item/shared_chef/nuggies
	name = "鸡块"
	description = "副总裁的儿子一直吵着要吃鸡块。你能运送一些过来吗？"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 6
	wanted_types = list(/obj/item/food/nugget = TRUE)

/datum/bounty/item/shared_chef/corgifarming //Butchering is a chef's job.
	name = "柯基毛皮"
	description = "有个开太空游艇的混蛋需要新的内饰材料。一打柯基毛皮应该正好。"
	reward = CARGO_CRATE_VALUE * 60 //that's a lot of dead dogs
	required_count = 12
	wanted_types = list(/obj/item/stack/sheet/animalhide/corgi = TRUE)

/datum/bounty/item/shared_chef/pickles
	name = "腌黄瓜"
	description = "食品监管部门缺少足够的腌黄瓜来正确评估某些不同类型的烈酒。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 7
	wanted_types = list(/obj/item/food/pickle = TRUE)
