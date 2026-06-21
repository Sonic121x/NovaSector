// Hey! Listen! Update \config\iceruinblacklist.txt with your new ruins!

/datum/map_template/ruin/icemoon
	prefix = "_maps/RandomRuins/IceRuins/"
	allow_duplicates = FALSE
	cost = 5
	ruin_type = ZTRAIT_ICE_RUINS
	default_area = /area/icemoon/surface/outdoors/unexplored
	has_ceiling = TRUE
	ceiling_turf = /turf/closed/mineral/snowmountain/do_not_chasm
	ceiling_baseturfs = list(/turf/open/misc/asteroid/snow/icemoon/do_not_chasm)

// above ground only

/datum/map_template/ruin/icemoon/gas
	name = "冰原遗迹-蜥蜴加油站"
	id = "lizgasruin"
	description = "一个加油站。它看起来最近还在营业，并且状态完好如新。"
	suffix = "icemoon_surface_gas.dmm"

/datum/map_template/ruin/icemoon/lust
	name = "冰原遗迹-欲望废墟"
	id = "lust"
	description = "和你预想的不太一样。"
	suffix = "icemoon_surface_lust.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/asteroid
	name = "冰原遗迹-小行星站点"
	id = "asteroidsite"
	description = "没想到会在这里见到我们吧？"
	suffix = "icemoon_surface_asteroid.dmm"

/datum/map_template/ruin/icemoon/engioutpost
	name = "冰原遗迹-工程师前哨站"
	id = "engioutpost"
	description = "被一场不幸的事故炸毁了。"
	suffix = "icemoon_surface_engioutpost.dmm"

/datum/map_template/ruin/icemoon/fountain
	name = "冰原遗迹-喷泉大厅"
	id = "ice_fountain"
	description = "喷泉侧面有一个警告。危险：可能具有未声明的副作用，只有在实现时才会变得明显。"
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "fountain_hall.dmm"

/datum/map_template/ruin/icemoon/abandoned_homestead
	name = "冰原遗迹-废弃家园"
	id = "abandoned_homestead"
	description = "这个家园曾是一个快乐拓荒家庭的住所。现在则是饥饿的熊的家。"
	suffix = "icemoon_underground_abandoned_homestead.dmm"

/datum/map_template/ruin/icemoon/entemology
	name = "冰原遗迹-昆虫研究站"
	id = "bug_habitat"
	description = "一个独立资助的研究前哨站，早已废弃。他们的使命是勇敢前往任何昆虫生命都永远不会生存的地方，寻找虫子。"
	suffix = "icemoon_surface_bughabitat.dmm"

/datum/map_template/ruin/icemoon/pizza
	name = "冰原遗迹-莫夫奇披萨店"
	id = "pizzeria"
	description = "Moffuchi家族披萨连锁店以提供价格实惠但可食用性存疑的手工餐点而闻名。这家披萨店似乎已被遗弃了一段时间。"
	suffix = "icemoon_surface_pizza.dmm"

/datum/map_template/ruin/icemoon/Lodge
	name = "冰原遗迹-猎人小屋"
	id = "lodge"
	description = "一个古老的狩猎小屋。不知道是否还有人住在这里？"
	suffix = "icemoon_surface_lodge.dmm"

/datum/map_template/ruin/icemoon/frozen_phonebooth
	name = "冰原遗迹-冰冻电话亭"
	id = "frozen_phonebooth"
	description = "纳米传讯为推广全息板使用而进行的一项尝试。这个被送到了冰卫星上。"
	suffix = "icemoon_surface_phonebooth.dmm"

/datum/map_template/ruin/icemoon/smoking_room
	name = "冰原遗迹-吸烟室"
	id = "smoking_room"
	description = "查尔斯·莫尔巴罗长眠于此。他死得其所。"
	suffix = "icemoon_surface_smoking_room.dmm"

/datum/map_template/ruin/icemoon/roro
	name = "冰原废墟-罗罗科工厂"
	id = "gloves"
	description = "一个生产和包装绝缘手套的设施。"
	suffix = "icemoon_surface_gloves.dmm"

/datum/map_template/ruin/icemoon/shoe_facotry
	name = "Ice-Ruin Shoe Factory"
	id = "shoe_factory"
	description = "An abandoned shoe factory."
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "shoe_factory.dmm"
	allow_duplicates = FALSE
	cost = 10

// above and below ground together

/datum/map_template/ruin/icemoon/mining_site
	name = "Ice-Ruin Mining Site"
	id = "miningsite"
	description = "Ruins of a site where people once mined with primitive tools for ore."
	suffix = "icemoon_surface_mining_site.dmm"
	always_place = TRUE
	always_spawn_with = list(/datum/map_template/ruin/icemoon/underground/mining_site_below = PLACE_BELOW)
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/underground/mining_site_below
	name = "Ice-Ruin Mining Site Underground"
	id = "miningsite-underground"
	description = "Who knew ladders could be so useful?"
	suffix = "icemoon_underground_mining_site.dmm"
	has_ceiling = FALSE
	unpickable = TRUE
	enclosed_for_terrain = TRUE

// below ground only

/datum/map_template/ruin/icemoon/underground
	name = "冰原废墟-地下废墟"
	ruin_type = ZTRAIT_ICE_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/icemoon/underground/abandonedvillage
	name = "冰原废墟-废弃村庄"
	id = "abandonedvillage"
	description = "谁知道里面藏着什么？"
	suffix = "icemoon_underground_abandoned_village.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/underground/library
	name = "冰原废墟-埋藏图书馆"
	id = "buriedlibrary"
	description = "一座曾经宏伟的图书馆，如今迷失在冰卫星的深处。"
	suffix = "icemoon_underground_library.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/underground/wrath
	name = "冰原废墟-愤怒遗迹"
	id = "wrath"
	description = "你会战斗、战斗、永不停歇地战斗。"
	suffix = "icemoon_underground_wrath.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/underground/hermit
	name = "冰原废墟-冰封小屋"
	id = "hermitshack"
	description = "一位孤独隐士的栖身之所，勉强维持生计，只为活过又一天。"
	suffix = "icemoon_underground_hermit.dmm"

/datum/map_template/ruin/icemoon/underground/lavaland
	name = "冰原废墟-熔岩地入侵点"
	id = "lavalandsite"
	description = "我想我们从未真正离开过你，是吧？"
	suffix = "icemoon_underground_lavaland.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/underground/puzzle
	name = "冰原废墟-远古谜题"
	id = "puzzle"
	description = "有待解开的谜团。"
	suffix = "icemoon_underground_puzzle.dmm"

/datum/map_template/ruin/icemoon/underground/bathhouse
	name = "冰原废墟-浴场"
	id = "bathhouse"
	description = "一个温暖、安全的地方。"
	suffix = "icemoon_underground_bathhouse.dmm"

/datum/map_template/ruin/icemoon/underground/wendigo_cave
	name = "冰原废墟-温迪戈洞穴"
	id = "wendigocave"
	description = "深入野兽之口。"
	suffix = "icemoon_underground_wendigo_cave.dmm"

/datum/map_template/ruin/icemoon/underground/free_golem
	name = "冰原废墟-自由魔像飞船"
	id = "golem-ship"
	description = "Lumbering humanoids, made out of precious metals, move inside this ship. They frequently leave to mine more minerals, which they somehow turn into more of them. \
	Seem very intent on research and individual liberty, and also geology-based naming?"
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "golem_ship.dmm"

/datum/map_template/ruin/icemoon/underground/mailroom
	name = "冰原废墟-冰封邮局"
	id = "mailroom"
	description = "这就是你所有工资的去向。此致，管理层。"
	suffix = "icemoon_underground_mailroom.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/underground/biodome
	name = "冰原废墟-辛迪加生物穹顶"
	id = "biodome"
	description = "失控的实验出了岔子。"
	suffix = "icemoon_underground_syndidome.dmm"

/datum/map_template/ruin/icemoon/underground/frozen_comms
	name = "冰原废墟-冰封通讯前哨站"
	id = "frozen_comms"
	description = "三峰电台，2000年代永存之地。"
	suffix = "icemoon_underground_frozen_comms.dmm"

/datum/map_template/ruin/icemoon/underground/comms_agent
	name = "冰原废墟-监听站"
	id = "icemoon_comms_agent"
	description = "检测到无线电信号，源头是这堆完全无辜的雪。"
	suffix = "icemoon_underground_comms_agent.dmm"

/datum/map_template/ruin/icemoon/underground/syndie_lab
	name = "冰原废墟-辛迪加实验室"
	id = "syndie_lab"
	description = "辛迪加特工的小型实验室和生活空间。"
	suffix = "icemoon_underground_syndielab.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/underground/o31
	name = "冰原废墟-31号前哨站"
	id = "o31"
	description = "可疑的死寂。可能包含巨型生物，也可能没有。"
	suffix = "icemoon_underground_outpost31.dmm"

//TODO: Bottom-Level ONLY Spawns after Refactoring Related Code
/datum/map_template/ruin/icemoon/underground/plasma_facility
	name = "冰原废墟-废弃等离子设施"
	id = "plasma_facility"
	description = "Rumors have developed over the many years of Freyja plasma mining. These rumors suggest that the ghosts of dead mistreated excavation staff have returned to \
	exact revenge on their (now former) employers. Coorperate reminds all staff that rumors are just that: Old Housewife tales meant to scare misbehaving kids to bed."
	suffix = "icemoon_underground_abandoned_plasma_facility.dmm"

/datum/map_template/ruin/icemoon/underground/hotsprings
	name = "冰原废墟-温泉"
	id = "hotsprings"
	description = "放松一下，泡个澡，我发誓不会出任何问题的！"
	suffix = "icemoon_underground_hotsprings.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/icemoon/underground/vent
	name = "冰原废墟-冰月矿脉喷口"
	id = "ore_vent_i"
	description = "一个喷出矿石的喷口。似乎是自然现象。" //Make this a subtype that only spawns medium and large vents. Some smalls will go to the top level.
	suffix = "icemoon_underground_ore_vent.dmm"
	allow_duplicates = TRUE
	cost = 0
	mineral_cost = 1
	always_place = TRUE

/datum/map_template/ruin/icemoon/ruin/vent
	name = "冰原遗迹-冰月地表矿脉喷口"
	id = "ore_vent_i"
	description = "一个喷出矿石的喷口。似乎是自然现象。比地下的那些要小。"
	suffix = "icemoon_surface_ore_vent.dmm"
	allow_duplicates = TRUE
	cost = 0
	mineral_cost = 1
	always_place = TRUE
