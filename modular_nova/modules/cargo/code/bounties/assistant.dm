/datum/bounty/item/assistant/nuggies
	name = "鸡块"
	description = "我们求过厨师但失败了。听说助手每兑换一张GAP卡就能从蓝色机器里免费拿一盒。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 5
	wanted_types = list(/obj/item/food/nugget = TRUE)

/datum/bounty/item/assistant/fake_id
	name = "纸板身份证明"
	description = "我们的人事部身份识别机坏了，给我们寄些硬纸板ID卡，我们好手动分配职位。"
	reward = CARGO_CRATE_VALUE * 3
	required_count = 3
	wanted_types = list(/obj/item/card/cardboard = TRUE)

/datum/bounty/item/assistant/glass_bowl
	name = "玻璃碗"
	description = "我们在一次激烈的重新装修中打碎了代表的纪念玻璃碗，请尽快寄个替代品过来！"
	reward = CARGO_CRATE_VALUE * 12.5
	wanted_types = list(/obj/item/reagent_containers/cup/bowl/blowing_glass = TRUE)

/datum/bounty/item/assistant/clay_craft
	name = "粘土工艺品"
	description = "我们博物馆的灰烬行者陶罐收藏被一个穿绿色衣服的疯子哑剧演员砸碎了！我们需要三件陶瓷制品，这样我们还能拿到文化补贴。"
	reward = CARGO_CRATE_VALUE * 12.5
	required_count = 3
	wanted_types = list(
		/obj/item/reagent_containers/cup/bowl/ceramic = TRUE,
		/obj/item/plate/oven_tray/material/ceramic = TRUE,
		/obj/item/reagent_containers/cup/beaker/large/ceramic = TRUE,
		/obj/item/plate/ceramic = TRUE,
	)

/datum/bounty/item/assistant/forged_sharp
	name = "锻造匕首"
	description = "我们的厨师坚持要用一把正宗的提兹兰制造刀。给我们寄任何能切割并且是锻造出来的东西，剩下的我们来处理。"
	reward = CARGO_CRATE_VALUE * 9
	wanted_types = list(
		/obj/item/forging/reagent_weapon/sword = TRUE,
		/obj/item/forging/reagent_weapon/katana = TRUE,
		/obj/item/forging/reagent_weapon/dagger = TRUE,
		/obj/item/forging/reagent_weapon/axe = TRUE,
	)

/datum/bounty/item/assistant/wheelchair
	name = "两把轮椅"
	description = "我们发生了太多与电车相关的事故，还有人试图在中间轨道上滑板，我们现在需要额外的轮椅。你可以把它们折叠起来寄送。"
	reward = CARGO_CRATE_VALUE * 5
	required_count = 2
	wanted_types = list(
		/obj/vehicle/ridden/wheelchair = TRUE,
		/obj/item/wheelchair = TRUE,
	)

/datum/bounty/item/assistant/floodlight
	name = "泛光灯"
	description = "一场雷暴过载了我们大部分的电灯！请给我们寄一个完整的泛光灯，要带电缆和灯管并且已经组装好的！"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/power/floodlight = TRUE)

/datum/bounty/item/assistant/mannequin
	name = "人体模型"
	description = "我需要去趟洗手间，但前台必须有人。寄一个木头或塑料做的人体模型来，但要快，我求你了！"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/structure/mannequin = TRUE)

/datum/bounty/item/assistant/blackmarket
	name = "黑市上行链路"
	description = "我们通过正规渠道接收关键物资遇到了麻烦，所以我们需要一个能让我们联系到监管较松路线的设备。不要向安保提及这批货物。"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(/obj/item/market_uplink/blackmarket = TRUE)
