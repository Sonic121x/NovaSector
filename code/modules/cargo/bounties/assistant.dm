/* NOVA EDIT REMOVAL START - Removes bounties that are luck or destruction based
/datum/bounty/item/assistant/strange_object
	name = "Strange Object"
	description = "Nanotrasen has taken an interest in strange objects. Find one in maintenance, and ship it off to CentCom right away."
	reward = CARGO_CRATE_VALUE * 2.4
	wanted_types = list(/obj/item/relic = TRUE)
*/ // NOVA EDIT REMOVAL END

/* NOVA EDIT REMOVAL START - Removes bounties, these are just boring.
/datum/bounty/item/assistant/scooter
	name = "Scooter"
	description = "Nanotrasen has determined walking to be wasteful. Ship a scooter to CentCom to speed operations up."
	reward = CARGO_CRATE_VALUE * 2.16 // the mat hoffman
	wanted_types = list(/obj/vehicle/ridden/scooter = TRUE)
	include_subtypes = FALSE

/datum/bounty/item/assistant/skateboard
	name = "Skateboard"
	description = "Nanotrasen has determined walking to be wasteful. Ship a skateboard to CentCom to speed operations up."
	reward = CARGO_CRATE_VALUE * 1.8 // the tony hawk
	wanted_types = list(
		/obj/vehicle/ridden/scooter/skateboard = TRUE,
		/obj/item/melee/skateboard = TRUE,
	)
*/ // NOVA EDIT REMOVAL END

/datum/bounty/item/assistant/stunprod
	name = "电击棒"
	description = "中央司令部需要一根电击棒来对付异见分子。制作一根，然后运送过来。"
	reward = CARGO_CRATE_VALUE * 2.6
	wanted_types = list(/obj/item/melee/baton/security/cattleprod = TRUE)

/* NOVA EDIT REMOVAL START - Removes bounties that are luck or destruction based
/datum/bounty/item/assistant/soap
	name = "Soap"
	description = "Soap has gone missing from CentCom's bathrooms and nobody knows who took it. Replace it and be the hero CentCom needs."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/item/soap = TRUE)
*/ // NOVA EDIT REMOVAL END

/datum/bounty/item/assistant/spear
	name = "矛"
	description = "中央司令部的安保部队正在经历预算削减。如果你运送一套长矛，你将获得报酬。"
	reward = CARGO_CRATE_VALUE * 4
	required_count = 5
	wanted_types = list(/obj/item/spear = TRUE)

/datum/bounty/item/assistant/toolbox
	name = "已备好的工具箱"
	description = "中央司令部缺乏强健性。运送一个装满工具的工具箱作为解决方案，里面应包含螺丝刀、扳手、焊接工具、撬棍、分析仪和钢丝钳。"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/item/storage/toolbox = TRUE)
	/// List of tools that we want to see sorted into a toolbox
	var/static/list/static_packing_list = list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/analyzer,
		/obj/item/wirecutters,
	)

/datum/bounty/item/assistant/toolbox/applies_to(obj/shipped)
	var/list/packing_list = static_packing_list.Copy()
	for(var/obj/item_contents as anything in shipped.contents)
		for(var/match_type in packing_list)
			if(istype(item_contents, match_type))
				packing_list -= match_type
				break
		if(!length(packing_list))
			return ..()
	return FALSE

/datum/bounty/item/assistant/toolbox/ship(obj/shipped)
	. = ..()
	for(var/obj/object as anything in shipped.contents)
		if(!is_type_in_list(object, static_packing_list))
			object.forceMove(shipped.drop_location())

/datum/bounty/item/assistant/statue
	name = "雕像"
	description = "中央司令部想为大厅委托制作一座艺术雕像。可能的话，运送一座过来。"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/structure/statue = TRUE)

/* NOVA EDIT REMOVAL START - Removes bounties that are luck or destruction based
/datum/bounty/item/assistant/clown_box
	name = "Clown Box"
	description = "The universe needs laughter. Stamp cardboard with a clown stamp and ship it out."
	reward = CARGO_CRATE_VALUE * 3
	wanted_types = list(/obj/item/storage/box/clown = TRUE)

/datum/bounty/item/assistant/cheesiehonkers
	name = "Cheesie Honkers"
	description = "Apparently the company that makes Cheesie Honkers is going out of business soon. CentCom wants to stock up before it happens!"
	reward = CARGO_CRATE_VALUE * 2.4
	required_count = 3
	wanted_types = list(/obj/item/food/cheesiehonkers = TRUE)
*/ // NOVA EDIT REMOVAL END

/datum/bounty/item/assistant/baseball_bat
	name = "棒球棒"
	description = "中央司令部正掀起棒球热！帮个忙，给他们运送一些棒球棒，好让管理层实现他们童年的梦想。"
	reward = CARGO_CRATE_VALUE * 4
	required_count = 5
	wanted_types = list(/obj/item/melee/baseball_bat = TRUE)

/datum/bounty/item/assistant/extendohand
	name = "棒球棒"
	description = "贝琪指挥官年纪大了，弯腰够不到远程屏幕遥控器了。管理层请求一个延长手来帮助她。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/item/extendohand = TRUE)

/datum/bounty/item/assistant/donut
	name = "甜甜圈"
	description = "中央司令部的安保部队在与辛迪加的战斗中损失惨重。运送甜甜圈来提振士气。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 6
	wanted_types = list(/obj/item/food/donut = TRUE)

/datum/bounty/item/assistant/donkpocket
	name = "口袋饼"
	description = "消费者安全召回：警告。过去一年生产的唐克口袋含有危险的蜥蜴生物物质。请立即将产品退回中央司令部。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 10
	wanted_types = list(/obj/item/food/donkpocket = TRUE)

/datum/bounty/item/assistant/monkey_hide
	name = "猴皮"
	description = "中央司令部的一位科学家有兴趣在猴子皮上测试产品。你的任务是获取猴皮并运送过来。"
	reward = CARGO_CRATE_VALUE * 3
	wanted_types = list(/obj/item/stack/sheet/animalhide/carbon/monkey = TRUE)

/* NOVA EDIT REMOVAL START - Removes bounties that are luck or destruction based
/datum/bounty/item/assistant/dead_mice
	name = "Dead Mice"
	description = "Station 14 ran out of freeze-dried mice. Ship some fresh ones so their janitor doesn't go on strike."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 5
	wanted_types = list(/obj/item/food/deadmouse = TRUE)
*/ // NOVA EDIT REMOVAL END

/datum/bounty/item/assistant/comfy_chair
	name = "康乐椅"
	description = "帕特指挥官对他的椅子不满意。他声称椅子伤了他的背。运送一些替代品来让他开心一下。"
	reward = CARGO_CRATE_VALUE * 3
	required_count = 5
	wanted_types = list(/obj/structure/chair/comfy = TRUE)

/datum/bounty/item/assistant/geranium
	name = "天竺葵"
	description = "佐特指挥官对泽娜指挥官有好感。运送一批她最喜欢的天竺葵花，他会乐意奖励你的。"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 3
	wanted_types = list(/obj/item/food/grown/poppy/geranium = TRUE)
	include_subtypes = FALSE

/datum/bounty/item/assistant/poppy
	name = "罂粟"
	description = "佐特指挥官真的很想赢得安保干员奥利维亚的芳心。运送一批她最喜欢的罂粟花，他会乐意奖励你的。"
	reward = CARGO_CRATE_VALUE * 2
	required_count = 3
	wanted_types = list(/obj/item/food/grown/poppy = TRUE)
	include_subtypes = FALSE

/datum/bounty/item/assistant/potted_plants
	name = "盆栽植物"
	description = "中央司令部正在计划建造一个新的BirdBoat级空间站。你被命令提供盆栽植物。"
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(
		/obj/item/kirbyplants = TRUE,
		/obj/item/kirbyplants/synthetic = FALSE
		)

/datum/bounty/item/assistant/monkey_cubes
	name = "猴子方块"
	description = "由于最近的一次基因实验事故，中央司令部急需猴子。你的任务是运送猴子方块。"
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/item/food/monkeycube = TRUE)

/datum/bounty/item/assistant/ied
	name = "简易爆炸物"
	description = "纳米传讯在中央司令部的最高安全监狱正在进行人员培训。运送一些简易爆炸装置作为训练工具。"
	reward = CARGO_CRATE_VALUE * 4
	required_count = 3
	wanted_types = list(/obj/item/grenade/iedcasing = TRUE)

/* NOVA EDIT REMOVAL START - Removes bounties that are luck or destruction based
/datum/bounty/item/assistant/corgimeat
	name = "Raw Corgi Meat"
	description = "The Syndicate recently stole all of CentCom's corgi meat. Ship out a replacement immediately."
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/food/meat/slab/corgi = TRUE)

/datum/bounty/item/assistant/toys
	name = "Arcade Toys"
	description = "The vice president's son saw an ad for new toys on the telescreen and now he won't shut up about them. Ship some arcade toys over to ease his complaints."
	reward = CARGO_CRATE_VALUE * 8
	required_count = 5
	wanted_types = list(/obj/item/toy = TRUE)

/datum/bounty/item/assistant/paper_bin
	name = "Paper Bins"
	description = "Our accounting division is all out of paper. We need a new shipment immediately."
	reward = CARGO_CRATE_VALUE * 5
	required_count = 5
	wanted_types = list(/obj/item/paper_bin = TRUE)

/datum/bounty/item/assistant/crayons
	name = "Crayons"
	description = "Dr. Jones's kid ate all of our crayons again. Please send us yours."
	reward = CARGO_CRATE_VALUE * 4
	required_count = 8
	wanted_types = list(/obj/item/toy/crayon = TRUE)
*/ // NOVA EDIT REMOVAL END

/datum/bounty/item/assistant/water_tank
	name = "水箱"
	description = "我们的水培区需要更多水。找一个水箱并运送给我们。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/structure/reagent_dispensers/watertank = TRUE)

/datum/bounty/item/assistant/pneumatic_cannon
	name = "气动炮"
	description = "我们正在研究能用气动炮把超物质碎片发射多远。尽快给我们送一个过来。"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/item/pneumatic_cannon/ghetto = TRUE)

/datum/bounty/item/assistant/improvised_shells
	name = "垃圾弹壳"
	description = "我们的助手民兵耗尽了所有的铁储备。为了防止他们用空间站的财产制造子弹，我们需要垃圾弹壳，立刻就要。"
	reward = CARGO_CRATE_VALUE * 4
	required_count = 5
	wanted_types = list(/obj/item/ammo_casing/junk = TRUE)

/datum/bounty/item/assistant/flamethrower
	name = "喷火器"
	description = "我们遭遇了飞蛾侵扰，送一个火焰喷射器来帮忙处理情况。"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/item/flamethrower = TRUE)

/datum/bounty/item/assistant/fish
	name = "鱼"
	description = "我们需要鱼类来充实我们的水族箱。已死亡或从货物购买的鱼类只能获得一半报酬。"
	reward = CARGO_CRATE_VALUE * 9.5
	required_count = 4
	wanted_types = list(/obj/item/fish = TRUE, /obj/item/storage/fish_case = TRUE)
	///the penalty for shipping dead/bought fish, which can subtract up to half the reward in total.
	var/shipping_penalty

/datum/bounty/item/assistant/fish/New()
	..()
	shipping_penalty = reward * 0.5 / required_count

/datum/bounty/item/assistant/fish/applies_to(obj/shipped)
	. = ..()
	if(!.)
		return
	var/obj/item/fish/fishie = shipped
	if(istype(shipped, /obj/item/storage/fish_case))
		fishie = locate() in shipped
		if(!fishie || !is_type_in_typecache(fishie, wanted_types))
			return FALSE
	return can_ship_fish(fishie)

/datum/bounty/item/assistant/fish/proc/can_ship_fish(obj/item/fish/fishie)
	return TRUE

/datum/bounty/item/assistant/fish/ship(obj/shipped)
	. = ..()
	if(!.)
		return
	var/obj/item/fish/fishie = shipped
	if(istype(shipped, /obj/item/storage/fish_case))
		fishie = locate() in shipped
	if(fishie.status == FISH_DEAD || HAS_TRAIT(fishie, TRAIT_FISH_LOW_PRICE))
		reward -= shipping_penalty

///A subtype of the fish bounty that requires fish with a specific fluid type
/datum/bounty/item/assistant/fish/fluid
	reward = CARGO_CRATE_VALUE * 12
	///The required fluid type of the fish for it to be shipped
	var/fluid_type

/datum/bounty/item/assistant/fish/fluid/New()
	..()
	fluid_type = pick(AQUARIUM_FLUID_FRESHWATER, AQUARIUM_FLUID_SALTWATER, AQUARIUM_FLUID_SULPHWATEVER)
	name = "[fluid_type] 鱼"
	description = "我们需要[LOWER_TEXT(fluid_type)]鱼类来充实我们的水族箱。已死亡或从货物购买的鱼类只能获得一半报酬。"

/datum/bounty/item/assistant/fish/fluid/can_ship_fish(obj/item/fish/fishie)
	return (fluid_type in GLOB.fish_compatible_fluid_types[fishie.required_fluid_type])
